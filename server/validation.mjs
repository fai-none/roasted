import { createHash } from 'node:crypto';

export class DemoError extends Error {
  constructor(message, status = 400) { super(message); this.status = status; }
}

const words = (value) => [...value.matchAll(/[\p{L}\p{M}\p{N}]+(?:['’][\p{L}\p{M}\p{N}]+)*/gu)].map((match) => ({
  value: match[0].normalize('NFC').toLowerCase().replace(/['’]/gu, ''),
  start: match.index, end: match.index + match[0].length,
}));
const normalize = (value) => words(value).map((word) => word.value).join(' ');
const bounded = (value, maximum = 1000) => typeof value === 'string' && value.length <= maximum ? value.trim() : '';
// Compare actual words, tolerating only casing, Unicode and punctuation differences.
// Return the source substring so persisted quotes keep the provider's wording.
function quoteWithin(quote, item) {
  if (!quote) return '';
  const needle = words(quote);
  const haystack = words(item.text);
  if (!needle.length) return '';
  for (let i = 0; i <= haystack.length - needle.length; i += 1) {
    if (needle.every((word, offset) => word.value === haystack[i + offset].value)) {
      return item.text.slice(haystack[i].start, haystack[i + needle.length - 1].end);
    }
  }
  return '';
}

// Only selected quotes and item IDs leave this validator. Full transcripts stay in request memory.
export function validateSession(input) {
  if (!input || !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(input.id ?? '')) {
    throw new DemoError('A valid session ID is required.');
  }
  const date = new Date(input.createdAt);
  if (!input.createdAt || !Number.isFinite(date.getTime())) throw new DemoError('A valid session date is required.');
  const topic = bounded(input.topic, 300);
  if (!topic) throw new DemoError('A topic is required.');
  if (!Array.isArray(input.transcript) || input.transcript.length > 300 || !Array.isArray(input.candidates) || input.candidates.length > 30) {
    throw new DemoError('Conversation evidence is missing or too large.');
  }
  const seen = new Set();
  const transcript = input.transcript.map((item, index) => {
    const id = bounded(item?.id, 200);
    const text = bounded(item?.text, 12000);
    const speaker = ({ you: 'user', user: 'user', nobody: 'assistant', assistant: 'assistant' })[String(item?.speaker).toLowerCase()];
    if (!id || !text || !speaker || seen.has(id)) throw new DemoError('Conversation evidence contains invalid or duplicate items.');
    seen.add(id);
    return { id, text, speaker, index };
  });
  if (!transcript.some((item) => item.speaker === 'user')) throw new DemoError('No actual learner speech was captured.');
  const signals = [];
  const sources = [];
  const signalKeys = new Set();
  let usefulExpression = '';
  let culturalTakeaway = '';
  let closingRoast = '';
  let rejectedSignals = 0;
  const warnings = [];
  for (const candidate of input.candidates) {
    for (const field of ['usefulExpression', 'culturalTakeaway', 'closingRoast']) {
      const value = bounded(candidate?.[field]);
      const spoken = transcript.find((item) => item.speaker === 'assistant' && quoteWithin(value, item));
      if (value && spoken) {
        if (field === 'usefulExpression') usefulExpression = quoteWithin(value, spoken);
        else if (field === 'culturalTakeaway') culturalTakeaway = quoteWithin(value, spoken);
        else closingRoast = quoteWithin(value, spoken);
      } else if (value) {
        const label = { usefulExpression: 'The useful expression', culturalTakeaway: 'The cultural takeaway', closingRoast: 'The closing roast' }[field];
        warnings.push(`${label} could not be matched to Nobody's actual words and was omitted.`);
      }
    }
    for (const source of Array.isArray(candidate?.signals) ? candidate.signals.slice(0, 3) : []) {
      const kind = source?.kind;
      const signal = bounded(source?.signal);
      const originalQuote = bounded(source?.originalQuote);
      const nativeAlternative = bounded(source?.nativeAlternative);
      const original = transcript.find((item) => item.speaker === 'user' && quoteWithin(originalQuote, item));
      const correction = transcript.find((item) => item.speaker === 'assistant' && item.index > (original?.index ?? Infinity) && quoteWithin(nativeAlternative, item));
      if (!['grammar', 'vocabulary', 'culture'].includes(kind) || !signal || !original || !correction) {
        rejectedSignals += 1;
        continue;
      }
      const key = createHash('sha256').update(`${kind}:${normalize(signal).toLowerCase()}`).digest('hex');
      const retryQuote = bounded(source.retryQuote);
      const retry = transcript.find((item) => item.speaker === 'user' && item.index > correction.index && quoteWithin(retryQuote, item));
      let spokenAlternative = quoteWithin(nativeAlternative, correction);
      const alternativeWords = words(spokenAlternative);
      if (retry && alternativeWords.length >= 3 && alternativeWords.at(-1).value === 'something'
        && !words(originalQuote).some((word) => word.value === 'something')) {
        const withoutPlaceholder = spokenAlternative.slice(0, alternativeWords.at(-2).end);
        const actualRetry = { text: quoteWithin(retryQuote, retry) };
        if (quoteWithin(withoutPlaceholder, actualRetry) && !quoteWithin(spokenAlternative, actualRetry)) {
          spokenAlternative = withoutPlaceholder;
        }
      }
      const validated = {
        kind, signal, originalQuote: quoteWithin(originalQuote, original), nativeAlternative: spokenAlternative,
        retryQuote: retry ? quoteWithin(retryQuote, retry) : '',
        improvementObserved: source.improvementObserved === true && Boolean(retry)
          && Boolean(quoteWithin(spokenAlternative, { text: retryQuote }))
          && normalize(originalQuote) !== normalize(retryQuote),
      };
      // Tool order is not learner progress: an untried duplicate must not erase a verified retry.
      const existing = signals.findIndex((item) => item.key === key);
      const selected = { key, ...validated };
      const provenance = { originalItemID: original.id, correctionItemID: correction.id, retryItemID: retry?.id ?? null };
      if (existing >= 0) {
        const previousRetry = transcript.find((item) => item.id === sources[existing].retryItemID);
        const hasNewerRetry = retry && previousRetry && retry.index > previousRetry.index;
        if (signals[existing].improvementObserved && !hasNewerRetry) continue;
        signals[existing] = selected;
        sources[existing] = provenance;
      }
      else if (signalKeys.size < 3) { signalKeys.add(key); signals.push(selected); sources.push(provenance); }
    }
  }
  if (rejectedSignals && !signals.length) throw new DemoError('Learning candidates did not match the actual conversation. No learning was saved.', 422);
  if (rejectedSignals) warnings.push(`${rejectedSignals} learning candidate(s) did not match the actual conversation and were omitted.`);
  const thaiSegments = transcript.filter((item) => item.speaker === 'user')
    .flatMap((item) => [...item.text.matchAll(/\p{Script=Thai}[\p{Script=Thai}\s]*/gu)].map((match) => match[0].trim()));
  const momentOfWeaknessQuote = thaiSegments.reduce((longest, segment) => segment.length > longest.length ? segment : longest, '').slice(0, 300);
  const receipt = {
    id: input.id.toLowerCase(), createdAt: date.toISOString(), topic,
    signals: signals.map(({ key, ...signal }) => signal), usefulExpression, culturalTakeaway, isMock: false,
    cultureLabel: transcript.some((item) => /\bAI\s+agents?\b/i.test(item.text)) ? 'AI agents' : '',
    momentOfWeakness: momentOfWeaknessQuote ? 'Fled to Thai under pressure' : '',
    momentOfWeaknessQuote, closingRoast,
  };
  return { receipt, sources, memories: signals, rejectedSignals, warnings: [...new Set(warnings)] };
}
