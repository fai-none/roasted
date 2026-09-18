// Synthetic PCM speech-in / Higgs audio-out. No microphone, learner identity, or database writes.
// Run: node --env-file=.env scripts/higgs-audio-smoke.mjs
import { execFileSync } from 'node:child_process';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { setTimeout as delay } from 'node:timers/promises';
import { buildInstructions, learningTool } from '../server/prompt.mjs';

const directory = fileURLToPath(new URL('../.demo/', import.meta.url));
const phrase = 'I think buying a new phone every year is a waste of money.';
const summary = {
  test: 'synthetic-pcm-speech-in-audio-out', microphoneInput: false, humanSpeech: false,
  persistence: false, learnerIdentity: null, syntheticPhrase: phrase,
  inputFormat: '24000Hz mono PCM16 little-endian', inputAudioBytes: 0,
  silenceBytes: 0, greetingAudioBytes: 0, replyAudioBytes: 0,
  inputTranscript: '', replyTranscript: '', eventCounts: {},
  credentialHTTPStatus: null, outcome: 'pending', errors: [],
};
const safeIdentifier = (value) => typeof value === 'string' && /^[a-zA-Z0-9_.\[\]-]{1,100}$/.test(value) ? value : null;

function syntheticPCM() {
  mkdirSync(directory, { recursive: true, mode: 0o700 });
  execFileSync('/usr/bin/say', ['-v', 'Samantha', '-r', '175', '-o', `${directory}/higgs-synthetic-input.aiff`, phrase], { stdio: 'ignore' });
  execFileSync('/usr/bin/afconvert', ['-f', 'WAVE', '-d', 'LEI16@24000', '-c', '1', `${directory}/higgs-synthetic-input.aiff`, `${directory}/higgs-synthetic-input.wav`], { stdio: 'ignore' });
  const wave = readFileSync(`${directory}/higgs-synthetic-input.wav`);
  if (wave.toString('ascii', 0, 4) !== 'RIFF' || wave.toString('ascii', 8, 12) !== 'WAVE') throw new Error('invalid-wave');
  let format;
  let pcm;
  for (let offset = 12; offset + 8 <= wave.length;) {
    const type = wave.toString('ascii', offset, offset + 4);
    const length = wave.readUInt32LE(offset + 4);
    const start = offset + 8;
    if (start + length > wave.length) throw new Error('invalid-wave');
    if (type === 'fmt ') format = wave.subarray(start, start + length);
    if (type === 'data') pcm = wave.subarray(start, start + length);
    offset = start + length + (length % 2);
  }
  if (!format || format.length < 16 || format.readUInt16LE(0) !== 1 || format.readUInt16LE(2) !== 1
      || format.readUInt32LE(4) !== 24000 || format.readUInt16LE(14) !== 16 || !pcm?.length) throw new Error('invalid-pcm');
  return pcm;
}

try {
  if (!process.env.BOSON_API_KEY) throw new Error('missing-key');
  const pcm = syntheticPCM();
  const credentialResponse = await fetch('https://api.boson.ai/v1/realtime/client_secrets', {
    method: 'POST', redirect: 'error',
    headers: { Authorization: `Bearer ${process.env.BOSON_API_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ expires_after: { seconds: 300 } }), signal: AbortSignal.timeout(15_000),
  });
  summary.credentialHTTPStatus = credentialResponse.status;
  if (!credentialResponse.ok) throw new Error('credential-http');
  const credential = await credentialResponse.json();
  if (typeof credential.value !== 'string') throw new Error('credential-shape');

  await new Promise((resolve) => {
    const socket = new WebSocket('wss://api.boson.ai/v1/realtime?model=higgs-realtime', ['realtime', `bai-client-secret.${credential.value}`]);
    let finished = false;
    let inputStarted = false;
    let replyCompleted = false;
    const finish = (outcome) => {
      if (finished) return;
      finished = true;
      summary.outcome = outcome;
      clearTimeout(timer);
      socket.close();
      resolve();
    };
    const timer = setTimeout(() => finish('timeout'), 50_000);
    const send = (event) => { if (!finished) socket.send(JSON.stringify(event)); };
    const check = () => {
      if (summary.inputTranscript && replyCompleted) finish(summary.replyAudioBytes > 0 ? 'passed' : 'no-reply-audio');
    };
    const streamInput = async () => {
      inputStarted = true;
      const chunkBytes = 1920; // 40 ms, matching a real-time microphone stream.
      for (let offset = 0; offset < pcm.length && !finished; offset += chunkBytes) {
        const chunk = pcm.subarray(offset, offset + chunkBytes);
        send({ type: 'input_audio_buffer.append', audio: chunk.toString('base64') });
        summary.inputAudioBytes += chunk.length;
        await delay(chunk.length / 48);
      }
      // No explicit commit or response.create: this verifies the app's semantic VAD path.
      const silence = Buffer.alloc(chunkBytes);
      for (let i = 0; i < 100 && !finished; i += 1) {
        send({ type: 'input_audio_buffer.append', audio: silence.toString('base64') });
        summary.silenceBytes += silence.length;
        await delay(40);
      }
    };
    socket.addEventListener('open', () => send({
      type: 'session.update', session: {
        type: 'realtime', model: 'higgs-realtime',
        instructions: buildInstructions({ topic: { title: 'Phone upgrades', context: 'Evergreen debate: is a new phone worth buying when the old one still works?' }, memory: [], language: 'Thai' }),
        output_modalities: ['audio'],
        audio: {
          input: { format: { type: 'audio/pcm', rate: 24000 }, transcription: { model: 'higgs-stt-3.1' }, turn_detection: { type: 'semantic_vad' } },
          output: { format: { type: 'audio/pcm', rate: 24000 }, voice: 'default' },
        },
        tools: [learningTool], tool_choice: 'auto',
      },
    }));
    socket.addEventListener('message', (message) => {
      if (finished) return;
      let event;
      try { event = JSON.parse(message.data); } catch { finish('invalid-json'); return; }
      const type = safeIdentifier(event.type) ?? 'unknown';
      summary.eventCounts[type] = (summary.eventCounts[type] ?? 0) + 1;
      if (type === 'session.created') send({ type: 'response.create' });
      if (type === 'conversation.item.input_audio_transcription.completed') {
        summary.inputTranscript = typeof event.transcript === 'string' ? event.transcript : '';
        check();
      }
      if (type === 'response.output_audio.delta' && typeof event.delta === 'string') {
        summary[inputStarted ? 'replyAudioBytes' : 'greetingAudioBytes'] += Buffer.from(event.delta, 'base64').length;
      }
      if (type === 'response.output_audio_transcript.done' && inputStarted && typeof event.transcript === 'string') summary.replyTranscript = event.transcript;
      if (type === 'error') {
        summary.errors.push({ code: safeIdentifier(event.error?.code), param: safeIdentifier(event.error?.param) });
        finish('provider-error');
      }
      if (type !== 'response.done') return;
      if (event.response?.status !== 'completed') { finish('response-not-completed'); return; }
      for (const item of event.response?.output ?? []) {
        if (item.type === 'function_call') {
          send({ type: 'conversation.item.create', item: { type: 'function_call_output', call_id: item.call_id, output: '{"saved":false,"reason":"Synthetic audio transport test; no database writes."}' } });
          send({ type: 'response.create' });
          return;
        }
      }
      if (!inputStarted) streamInput().catch(() => finish('audio-stream-failed'));
      else { replyCompleted = true; check(); }
    });
    socket.addEventListener('error', () => finish('websocket-error'));
    socket.addEventListener('close', () => { if (!finished) finish('closed-before-response'); });
  });
} catch (error) {
  const known = new Set(['missing-key', 'credential-http', 'credential-shape', 'invalid-wave', 'invalid-pcm']);
  summary.outcome = known.has(error.message) ? error.message : 'local-audio-or-connection-failed';
}
summary.completedAt = new Date().toISOString();
mkdirSync(directory, { recursive: true, mode: 0o700 });
writeFileSync(`${directory}/higgs-audio-smoke.json`, `${JSON.stringify(summary, null, 2)}\n`, { mode: 0o600 });
console.log(JSON.stringify(summary, null, 2));
if (summary.outcome !== 'passed') process.exitCode = 1;
