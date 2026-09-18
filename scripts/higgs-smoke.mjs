// Live wire smoke only: no microphone, learner data, or database writes.
// Run: node --env-file=.env scripts/higgs-smoke.mjs [--tool-smoke]
import { buildInstructions, learningTool } from '../server/prompt.mjs';

const toolSmoke = process.argv.includes('--tool-smoke');
const summary = {
  test: toolSmoke ? 'synthetic-empty-tool' : 'synthetic-greeting',
  persistence: false, microphoneInput: false,
  credentialHTTPStatus: null, eventCounts: {}, audioBytes: 0,
  toolCalls: 0, emptyToolEvidence: null, toolResultSent: false,
  responseStatus: null, outcome: 'pending', errors: [],
};
const safeIdentifier = (value) => typeof value === 'string' && /^[a-zA-Z0-9_.\[\]-]{1,100}$/.test(value)
  ? value : null;

try {
  if (!process.env.BOSON_API_KEY) throw new Error('missing-key');
  const response = await fetch('https://api.boson.ai/v1/realtime/client_secrets', {
    method: 'POST', redirect: 'error',
    headers: { Authorization: `Bearer ${process.env.BOSON_API_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ expires_after: { seconds: 300 } }),
    signal: AbortSignal.timeout(15_000),
  });
  summary.credentialHTTPStatus = response.status;
  if (!response.ok) throw new Error('credential-http');
  const credential = await response.json();
  if (typeof credential.value !== 'string') throw new Error('credential-shape');

  await new Promise((resolve) => {
    const socket = new WebSocket('wss://api.boson.ai/v1/realtime?model=higgs-realtime',
      ['realtime', `bai-client-secret.${credential.value}`]);
    let finished = false;
    let toolReturned = false;
    const finish = (outcome) => {
      if (finished) return;
      finished = true;
      summary.outcome = outcome;
      clearTimeout(timer);
      socket.close();
      resolve();
    };
    const timer = setTimeout(() => finish('timeout'), 30_000);
    const send = (event) => socket.send(JSON.stringify(event));
    socket.addEventListener('open', () => {
      // Keep this object aligned with HiggsVoiceClient.start().
      send({
        type: 'session.update',
        session: {
          type: 'realtime', model: 'higgs-realtime',
          instructions: buildInstructions({
            topic: { title: 'Phone upgrades', context: 'Evergreen debate: is a new phone worth buying when the old one still works?' },
            memory: [], language: 'Thai',
          }),
          output_modalities: ['audio'],
          audio: {
            input: {
              format: { type: 'audio/pcm', rate: 24_000 },
              transcription: { model: 'higgs-stt-3.1', language: 'en' },
              turn_detection: { type: 'semantic_vad' },
            },
            output: { format: { type: 'audio/pcm', rate: 24_000 }, voice: 'default' },
          },
          tools: [learningTool], tool_choice: 'auto',
        },
      });
    });
    socket.addEventListener('message', (message) => {
      if (finished) return;
      let event;
      try { event = JSON.parse(message.data); } catch { finish('invalid-json'); return; }
      const type = safeIdentifier(event.type) ?? 'unknown';
      summary.eventCounts[type] = (summary.eventCounts[type] ?? 0) + 1;
      if (type === 'session.created') {
        send(toolSmoke ? {
          type: 'response.create',
          response: { instructions: 'This is a synthetic transport test with no learner utterances. Call capture_learning exactly once now with signals [], usefulExpression "", culturalTakeaway "", closingRoast "". Do not fabricate evidence and do not speak before the tool call.' },
        } : { type: 'response.create' });
      }
      if (type === 'response.output_audio.delta' && typeof event.delta === 'string') {
        summary.audioBytes += Buffer.from(event.delta, 'base64').byteLength;
      }
      if (type === 'error') {
        summary.errors.push({ code: safeIdentifier(event.error?.code), param: safeIdentifier(event.error?.param) });
        finish('provider-error');
      }
      if (type !== 'response.done') return;
      summary.responseStatus = safeIdentifier(event.response?.status);
      if (summary.responseStatus !== 'completed') { finish('response-not-completed'); return; }
      const calls = (event.response?.output ?? []).filter((item) => item.type === 'function_call');
      summary.toolCalls += calls.length;
      if (toolSmoke && !toolReturned) {
        const call = calls.find((item) => item.name === 'capture_learning');
        if (!call) { finish('tool-not-called'); return; }
        let argumentsObject;
        try { argumentsObject = JSON.parse(call.arguments); } catch { finish('invalid-tool-json'); return; }
        summary.emptyToolEvidence = Array.isArray(argumentsObject.signals)
          && argumentsObject.signals.length === 0
          && argumentsObject.usefulExpression === '' && argumentsObject.culturalTakeaway === '';
        if (!summary.emptyToolEvidence) { finish('unexpected-tool-evidence'); return; }
        send({ type: 'conversation.item.create', item: {
          type: 'function_call_output', call_id: call.call_id,
          output: JSON.stringify({ accepted: true, persisted: false, reason: 'Synthetic transport test; nothing saved.' }),
        } });
        summary.toolResultSent = true;
        toolReturned = true;
        send({ type: 'response.create', response: { instructions: 'The synthetic transport test is complete. Say only: Connection check complete. Do not call any tools.' } });
        return;
      }
      finish(summary.audioBytes > 0 ? 'passed' : 'no-audio');
    });
    socket.addEventListener('error', () => finish('websocket-error'));
    socket.addEventListener('close', () => { if (!finished) finish('closed-before-response'); });
  });
} catch (error) {
  const known = new Set(['missing-key', 'credential-http', 'credential-shape']);
  summary.outcome = known.has(error.message) ? error.message : 'connection-failed';
}
console.log(JSON.stringify(summary, null, 2));
if (summary.outcome !== 'passed') process.exitCode = 1;
