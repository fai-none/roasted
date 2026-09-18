import test from 'node:test';
import assert from 'node:assert/strict';
import http from 'node:http';
import { once } from 'node:events';
import { validateSession, DemoError } from './validation.mjs';
import { createStore } from './store.mjs';
import { createHandler } from './index.mjs';

const id = 'da2dc042-b561-4d09-a5ee-edab8835e947';
const fixture = () => ({
  id, createdAt: '2026-09-18T19:00:00Z', topic: 'Synthetic validation fixture',
  transcript: [
    { id: 'user-1', speaker: 'You', text: 'Humans can spend time for more important things.' },
    { id: 'assistant-1', speaker: 'Nobody', text: 'You spend time ON something. Try again. Keeping up with the Joneses means copying the neighbours.' },
    { id: 'user-2', speaker: 'You', text: 'I spend time on more important things.' },
  ],
  candidates: [{
    signals: [{ kind: 'grammar', signal: 'Spend time on', originalQuote: 'humans can spend time for more important things', nativeAlternative: 'spend time on', retryQuote: 'I spend time on more important things', improvementObserved: true }],
    usefulExpression: 'keeping up with the Joneses', culturalTakeaway: '',
  }],
});

test('matches punctuation/casing while storing actual source wording and item IDs', () => {
  const result = validateSession(fixture());
  assert.equal(result.receipt.signals[0].originalQuote, 'Humans can spend time for more important things');
  assert.equal(result.receipt.signals[0].nativeAlternative, 'spend time ON');
  assert.equal(result.receipt.signals[0].improvementObserved, true);
  assert.deepEqual(result.sources, [{ originalItemID: 'user-1', correctionItemID: 'assistant-1', retryItemID: 'user-2' }]);
  assert.equal(result.receipt.isMock, false);
  assert.equal(JSON.stringify(result).includes('transcript'), false);
});

test('a fabricated original or assistant alternative cannot persist', () => {
  for (const field of ['originalQuote', 'nativeAlternative']) {
    const input = fixture();
    input.candidates[0].signals[0][field] = 'this was never said';
    assert.throws(() => validateSession(input), (error) => error.status === 422);
  }
});

test('substring inside a word is not evidence', () => {
  const input = fixture();
  input.candidates[0].signals[0].originalQuote = 'man';
  assert.throws(() => validateSession(input), (error) => error.status === 422);
});

test('retry must occur after correction; improvement requires the corrected words', () => {
  const earlier = fixture();
  earlier.candidates[0].signals[0].retryQuote = earlier.transcript[0].text;
  const result = validateSession(earlier);
  assert.equal(result.receipt.signals[0].retryQuote, '');
  assert.equal(result.receipt.signals[0].improvementObserved, false);
  const uncorrected = fixture();
  uncorrected.transcript[2].text = 'I spend time for more important things';
  uncorrected.candidates[0].signals[0].retryQuote = uncorrected.transcript[2].text;
  assert.equal(validateSession(uncorrected).receipt.signals[0].improvementObserved, false);
});

function duplicateCorrectionFixture() {
  const input = fixture();
  input.transcript.push({ id: 'assistant-2', speaker: 'Nobody', text: 'You can also say spend time doing something.' });
  input.candidates.push({ signals: [{
    ...input.candidates[0].signals[0], nativeAlternative: 'spend time doing', retryQuote: '', improvementObserved: false,
  }], usefulExpression: '', culturalTakeaway: '' });
  return input;
}

test('a later duplicate correction without a newer learner retry preserves verified improvement', () => {
  // Reproduces the PCM rehearsal: corrected "on" retry followed by an untried "doing" alternative.
  const result = validateSession(duplicateCorrectionFixture());
  assert.equal(result.receipt.signals.length, 1);
  assert.equal(result.receipt.signals[0].nativeAlternative, 'spend time ON');
  assert.equal(result.receipt.signals[0].retryQuote, 'I spend time on more important things');
  assert.equal(result.receipt.signals[0].improvementObserved, true);
  assert.equal(result.sources[0].correctionItemID, 'assistant-1');
  assert.equal(result.sources[0].retryItemID, 'user-2');
});

test('a duplicate reusing the same retry cannot downgrade verified improvement', () => {
  const input = fixture();
  input.candidates.push({ signals: [{ ...input.candidates[0].signals[0], improvementObserved: false }] });
  assert.equal(validateSession(input).receipt.signals[0].improvementObserved, true);
});

for (const corrected of [true, false]) {
  test(`a genuinely newer ${corrected ? 'corrected' : 'unsuccessful'} retry can supersede earlier progress`, () => {
    const input = duplicateCorrectionFixture();
    const latest = `I spend time ${corrected ? 'doing' : 'for'} more important things`;
    input.transcript.push({ id: 'user-3', speaker: 'You', text: latest });
    input.candidates[1].signals[0].retryQuote = latest;
    input.candidates[1].signals[0].improvementObserved = corrected;
    const result = validateSession(input);
    assert.equal(result.receipt.signals.length, 1);
    assert.equal(result.receipt.signals[0].nativeAlternative, 'spend time doing');
    assert.equal(result.receipt.signals[0].retryQuote, latest);
    assert.equal(result.receipt.signals[0].improvementObserved, corrected);
    assert.equal(result.sources[0].retryItemID, 'user-3');
  });
}

test('unmatched supplemental fields are omitted with visible warnings', () => {
  const input = fixture();
  input.candidates[0].culturalTakeaway = 'An invented cultural lesson';
  const result = validateSession(input);
  assert.equal(result.receipt.culturalTakeaway, '');
  assert.equal(result.warnings.length, 1);
});

test('duplicate transcript IDs and no actual user speech are rejected', () => {
  const duplicate = fixture();
  duplicate.transcript[2].id = 'user-1';
  assert.throws(() => validateSession(duplicate), DemoError);
  const empty = fixture();
  empty.transcript = [empty.transcript[1]];
  assert.throws(() => validateSession(empty), DemoError);
});

test('one atomic RPC carries only selected evidence; retries retain the same session ID', async () => {
  const requests = [];
  const saved = new Map();
  const fetcher = async (url, options) => {
    assert.match(url, /\/rpc\/save_learning_session$/);
    const body = JSON.parse(options.body);
    requests.push(body);
    if (!saved.has(body.p_receipt.id)) saved.set(body.p_receipt.id, body.p_receipt);
    return Response.json({ receipt: saved.get(body.p_receipt.id), memory: [] });
  };
  const store = createStore({ INSFORGE_BASE_URL: 'https://example.invalid', INSFORGE_API_KEY: 'server-secret', DEMO_LEARNER_ID: 'fixed-demo' }, fetcher);
  const evidence = validateSession(fixture());
  await store.save(evidence);
  evidence.receipt.topic = 'A changed retry payload';
  const result = await store.save(evidence);
  assert.equal(requests.length, 2);
  assert.equal(saved.size, 1);
  assert.equal(result.receipt.topic, 'Synthetic validation fixture');
  assert.equal(requests[0].p_learner_id, 'fixed-demo');
  assert.equal('transcript' in requests[0], false);
});

async function withBroker(handler, action) {
  const server = http.createServer(handler);
  server.listen(0, '127.0.0.1');
  await once(server, 'listening');
  try { await action(`http://127.0.0.1:${server.address().port}`); }
  finally { server.closeAllConnections(); await new Promise((resolve) => server.close(resolve)); }
}

test('broker requires authorization even for health', async () => {
  await withBroker(createHandler({ env: { DEMO_ACCESS_TOKEN: 'demo' }, store: { configured: true } }), async (base) => {
    assert.equal((await fetch(`${base}/health`)).status, 401);
    assert.equal((await fetch(`${base}/health`, { headers: { Authorization: 'Bearer demo' } })).status, 200);
  });
});

test('memory failure cannot be misrepresented as first-call empty memory', async () => {
  let mints = 0;
  const handler = createHandler({
    env: { DEMO_ACCESS_TOKEN: 'demo', BOSON_API_KEY: 'secret' },
    store: { configured: true, retrieve: async () => { throw new DemoError('Memory unavailable.', 502); } },
    fetcher: async () => { mints += 1; return Response.json({ value: 'ephemeral' }); },
  });
  await withBroker(handler, async (base) => {
    assert.equal((await fetch(`${base}/session`, { method: 'POST', headers: { Authorization: 'Bearer demo' } })).status, 502);
  });
  assert.equal(mints, 0);
});

test('each new call reads fresh memory instead of caching earlier state', async () => {
  let reads = 0;
  const handler = createHandler({
    env: { DEMO_ACCESS_TOKEN: 'demo', BOSON_API_KEY: 'secret' },
    store: { configured: true, retrieve: async () => ({ memory: [{ signal: `read ${++reads}`, originalQuote: 'source words' }], receipts: [] }) },
    fetcher: async () => Response.json({ value: 'ephemeral' }),
  });
  await withBroker(handler, async (base) => {
    for (let expected = 1; expected <= 2; expected += 1) {
      const response = await fetch(`${base}/session`, { method: 'POST', headers: { Authorization: 'Bearer demo' } });
      assert.equal((await response.json()).memory[0].signal, `read ${expected}`);
    }
  });
});

test('provider error bodies never reach app errors', async () => {
  const store = createStore({ INSFORGE_BASE_URL: 'https://example.invalid', INSFORGE_API_KEY: 'secret', DEMO_LEARNER_ID: 'demo' }, async () => new Response('PRIVATE SECRET ECHO', { status: 403 }));
  await assert.rejects(store.retrieve(), (error) => error.message === 'InsForge request failed (HTTP 403).');
});
