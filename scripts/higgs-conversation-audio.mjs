// Three synthetic speech turns through the native Higgs PCM/VAD configuration.
// No microphone, learner identity, database access, or persistence.
// node --env-file=.env scripts/higgs-conversation-audio.mjs
import { execFileSync } from 'node:child_process';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { setTimeout as delay } from 'node:timers/promises';
import { buildInstructions, learningTool } from '../server/prompt.mjs';
import { topic } from '../server/index.mjs';

const startedAt = new Date().toISOString();
const outputDirectory = '.demo/conversation-audio';
mkdirSync(outputDirectory, { recursive: true, mode: 0o700 });
const instructions = buildInstructions({ topic, memory: [], language: 'Thai' });
const evidence = {
  evidenceTier: 'LIVE HIGGS WITH LOCAL SYNTHETIC SPEECH. NOT MICROPHONE, DEVICE, PERSISTENCE OR HUMAN COMEDY ACCEPTANCE.',
  startedAt, outcome: 'pending', topic,
  instructionsSHA256: createHash('sha256').update(instructions).digest('hex'),
  promptFileSHA256: createHash('sha256').update(readFileSync('server/prompt.mjs')).digest('hex'),
  sessionInstructionsAcknowledged: false, sessionConfigurationMatched: false,
  plannedSyntheticTurns: [
    { label: 'thai-switch', segments: [['Samantha', 'Humans will have more time to'], ['Kanya', 'เอ่อ ทำสิ่งที่มีประโยชน์กว่า']] },
    { label: 'grammar-error', segments: [['Samantha', 'Humans can spend time for more important things.']] },
    { label: 'retry', segments: [['Samantha', 'Humans can spend time on more important things.']] },
  ],
  transcript: [], candidates: [], eventCounts: {}, audioBytes: {}, errors: [],
};
const safeID = (value) => Number.isInteger(value) ? value
  : typeof value === 'string' && /^[a-zA-Z0-9_.-]{1,100}$/.test(value) ? value : null;
const fail = (code) => { throw new Error(code); };

function synthesize(voice, text, name) {
  const path = `${outputDirectory}/${name}`;
  execFileSync('/usr/bin/say', ['-v', voice, '-r', '165', '-o', `${path}.aiff`, text], { stdio: 'ignore' });
  execFileSync('/usr/bin/afconvert', ['-f', 'WAVE', '-d', 'LEI16@24000', '-c', '1', `${path}.aiff`, `${path}.wav`], { stdio: 'ignore' });
  const wave = readFileSync(`${path}.wav`);
  if (wave.toString('ascii', 0, 4) !== 'RIFF' || wave.toString('ascii', 8, 12) !== 'WAVE') fail('invalid-wave');
  let format;
  let pcm;
  for (let offset = 12; offset + 8 <= wave.length;) {
    const length = wave.readUInt32LE(offset + 4);
    const start = offset + 8;
    if (start + length > wave.length) fail('invalid-wave');
    const type = wave.toString('ascii', offset, offset + 4);
    if (type === 'fmt ') format = wave.subarray(start, start + length);
    if (type === 'data') pcm = wave.subarray(start, start + length);
    offset = start + length + length % 2;
  }
  if (!format || format.readUInt16LE(0) !== 1 || format.readUInt16LE(2) !== 1
    || format.readUInt32LE(4) !== 24000 || format.readUInt16LE(14) !== 16 || !pcm?.length) fail('invalid-pcm');
  // Keep a mixed-language utterance together: trim TTS leading/trailing silence.
  let start = 0;
  let end = pcm.length;
  while (start + 2 < end && Math.abs(pcm.readInt16LE(start)) < 80) start += 2;
  while (end - 2 > start && Math.abs(pcm.readInt16LE(end - 2)) < 80) end -= 2;
  return pcm.subarray(Math.max(0, start - 960), Math.min(pcm.length, end + 960));
}

let socket;
let pumping = false;
let globalTimer;
let phase = 'greeting';
const items = new Map();
const responses = new Map();
let playbackEnd = 0;
const queued = [];
let waiter;
const deliver = (event) => {
  if (waiter) { const callback = waiter; waiter = undefined; callback(event); }
  else queued.push(event);
};
const send = (event) => socket.send(JSON.stringify(event));
async function nextEvent() {
  if (queued.length) return queued.shift();
  return new Promise((resolve) => {
    const timeout = setTimeout(() => { waiter = undefined; resolve({ type: 'timeout' }); }, 25_000);
    waiter = (event) => { clearTimeout(timeout); resolve(event); };
  });
}
async function waitFor(type) {
  while (true) {
    const event = await nextEvent();
    if (['error', 'closed', 'timeout', 'global-timeout'].includes(event.type)) fail(event.type);
    if (event.type === type) return event;
  }
}
async function finishResponse() {
  for (let attempt = 0; attempt < 4; attempt += 1) {
    const event = await waitFor('response.done');
    if (event.response?.status !== 'completed') fail('response-not-completed');
    const calls = (event.response.output ?? []).filter((item) => item.type === 'function_call');
    for (const call of calls) {
      if (call.name === 'capture_learning') {
        try { evidence.candidates.push(JSON.parse(call.arguments)); } catch { fail('invalid-tool-json'); }
      }
      send({ type: 'conversation.item.create', item: { type: 'function_call_output', call_id: call.call_id,
        output: '{"status":"candidate_received","saved":false,"syntheticTest":true}' } });
    }
    if (!calls.length) {
      await delay(Math.max(0, playbackEnd - Date.now()) + 150);
      return;
    }
    send({ type: 'response.create' });
  }
  fail('tool-loop');
}

try {
  if (!process.env.BOSON_API_KEY) fail('missing-key');
  const synthetic = evidence.plannedSyntheticTurns.map((turn, turnIndex) => Buffer.concat(
    turn.segments.flatMap(([voice, text], segmentIndex) => [
      synthesize(voice, text, `turn-${turnIndex}-${segmentIndex}`), Buffer.alloc(3_840),
    ]),
  ));
  const credentialResponse = await fetch('https://api.boson.ai/v1/realtime/client_secrets', {
    method: 'POST', redirect: 'error', signal: AbortSignal.timeout(15_000),
    headers: { Authorization: `Bearer ${process.env.BOSON_API_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ expires_after: { seconds: 300 } }),
  });
  evidence.credentialHTTPStatus = credentialResponse.status;
  if (!credentialResponse.ok) fail('credential-http');
  const secret = (await credentialResponse.json()).value;
  if (typeof secret !== 'string') fail('credential-shape');
  socket = new WebSocket('wss://api.boson.ai/v1/realtime?model=higgs-realtime', ['realtime', `bai-client-secret.${secret}`]);
  socket.addEventListener('message', ({ data }) => {
    let event;
    try { event = JSON.parse(String(data)); } catch { deliver({ type: 'error' }); return; }
    const type = safeID(event.type) ?? 'unknown';
    evidence.eventCounts[type] = (evidence.eventCounts[type] ?? 0) + 1;
    if (type === 'input_audio_buffer.speech_started') items.set(event.item_id, phase);
    if (type === 'response.created') responses.set(event.response?.id, phase);
    if (type === 'conversation.item.input_audio_transcription.completed') {
      evidence.transcript.push({ speaker: 'You', phase: items.get(event.item_id) ?? phase, text: event.transcript });
    }
    if (type === 'response.output_audio_transcript.done') {
      evidence.transcript.push({ speaker: 'Nobody', phase: responses.get(event.response_id) ?? phase,
        text: event.transcript, wordCount: event.transcript.trim().split(/\s+/u).length });
    }
    if (type === 'response.output_audio.delta') {
      const bytes = Buffer.from(event.delta, 'base64').length;
      const responsePhase = responses.get(event.response_id) ?? phase;
      evidence.audioBytes[responsePhase] = (evidence.audioBytes[responsePhase] ?? 0) + bytes;
      playbackEnd = Math.max(Date.now(), playbackEnd) + bytes / 48;
    }
    if (type === 'error') evidence.errors.push({ code: safeID(event.error?.code), param: safeID(event.error?.param) });
    deliver(event);
  });
  socket.addEventListener('close', () => deliver({ type: 'closed' }));
  socket.addEventListener('error', () => deliver({ type: 'error' }));
  await new Promise((resolve, reject) => {
    const timeout = setTimeout(() => reject(new Error('open-timeout')), 15_000);
    socket.addEventListener('open', () => { clearTimeout(timeout); resolve(); }, { once: true });
    socket.addEventListener('error', () => { clearTimeout(timeout); reject(new Error('open-error')); }, { once: true });
  });
  globalTimer = setTimeout(() => { pumping = false; deliver({ type: 'global-timeout' }); socket.close(); }, 120_000);
  send({ type: 'session.update', session: {
    type: 'realtime', model: 'higgs-realtime', instructions, output_modalities: ['audio'],
    audio: { input: { format: { type: 'audio/pcm', rate: 24000 }, transcription: { model: 'higgs-stt-3.1', language: 'en' }, turn_detection: { type: 'semantic_vad' } },
      output: { format: { type: 'audio/pcm', rate: 24000 }, voice: 'default' } },
    tools: [learningTool], tool_choice: 'auto',
  } });
  const created = await waitFor('session.created');
  evidence.sessionInstructionsAcknowledged = created.session?.instructions === instructions;
  evidence.sessionConfigurationMatched = created.session?.model === 'higgs-realtime'
    && created.session?.audio?.input?.turn_detection?.type === 'semantic_vad'
    && created.session?.audio?.input?.transcription?.language === 'en';
  let input;
  let offset = 0;
  let inputDone;
  pumping = true;
  const pump = (async () => {
    const silence = Buffer.alloc(1_920);
    while (pumping && socket.readyState === WebSocket.OPEN) {
      const chunk = input ? input.subarray(offset, offset + 1_920) : silence;
      send({ type: 'input_audio_buffer.append', audio: chunk.toString('base64') });
      if (input) {
        offset += chunk.length;
        if (offset >= input.length) { input = undefined; inputDone?.(); inputDone = undefined; }
      }
      await delay(chunk.length / 48);
    }
  })().catch(() => deliver({ type: 'error' }));
  send({ type: 'response.create' });
  await finishResponse();
  for (let index = 0; index < synthetic.length; index += 1) {
    phase = evidence.plannedSyntheticTurns[index].label;
    await new Promise((resolve, reject) => {
      const timeout = setTimeout(() => reject(new Error('input-timeout')), 20_000);
      inputDone = () => { clearTimeout(timeout); resolve(); };
      offset = 0;
      input = synthetic[index];
    });
    // VAD creates the response; no typed user item, commit, or response.create here.
    await finishResponse();
  }
  pumping = false;
  await pump;
  evidence.outcome = 'completed';
} catch (error) {
  const known = new Set(['missing-key', 'invalid-wave', 'invalid-pcm', 'credential-http', 'credential-shape', 'open-timeout', 'open-error', 'input-timeout', 'error', 'closed', 'timeout', 'global-timeout', 'response-not-completed', 'invalid-tool-json', 'tool-loop']);
  evidence.outcome = 'failed';
  evidence.error = known.has(error.message) ? error.message : 'local-audio-or-connection-failed';
  process.exitCode = 1;
} finally {
  pumping = false;
  clearTimeout(globalTimer);
  socket?.close();
  evidence.completedAt = new Date().toISOString();
  const evidenceFile = `${outputDirectory}/${startedAt.replaceAll(':', '-')}.json`;
  writeFileSync(evidenceFile, JSON.stringify(evidence, null, 2), { mode: 0o600 });
  console.log(JSON.stringify({ outcome: evidence.outcome, error: evidence.error, instructionsSHA256: evidence.instructionsSHA256,
    sessionInstructionsAcknowledged: evidence.sessionInstructionsAcknowledged,
    sessionConfigurationMatched: evidence.sessionConfigurationMatched,
    transcript: evidence.transcript, audioBytes: evidence.audioBytes, errors: evidence.errors, evidenceFile }, null, 2));
}
