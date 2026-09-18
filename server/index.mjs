import https from 'node:https';
import { readFileSync } from 'node:fs';
import { timingSafeEqual } from 'node:crypto';
import { pathToFileURL } from 'node:url';
import { buildInstructions, learningTool } from './prompt.mjs';
import { createStore } from './store.mjs';
import { DemoError, validateSession } from './validation.mjs';

export const topic = {
  title: 'AI got productive. What’s your excuse?',
  date: '2026-09-18',
  context: 'AI agents can help with shopping, bookings and business phone calls. Google announced agentic shopping and store calling on November 13, 2025, and booking assistance for restaurants, event tickets and appointments on November 17, 2025. Availability varies by market and service; these are established examples, not news announced today. What will humans actually do with the time saved?',
  sourceURL: 'https://blog.google/products-and-platforms/products/shopping/agentic-checkout-holiday-ai-shopping/',
  expression: 'spend time on something',
  opening: 'AI agents can shop for you, help book things, and call businesses for you now. Basically your AI has become more productive than you. Thoughts?',
};

async function readJSON(request) {
  const chunks = [];
  let bytes = 0;
  for await (const chunk of request) {
    bytes += chunk.length;
    if (bytes > 1_000_000) throw new DemoError('Request is too large.', 413);
    chunks.push(chunk);
  }
  try { return JSON.parse(Buffer.concat(chunks).toString('utf8')); }
  catch { throw new DemoError('Request body must be JSON.'); }
}

export function createHandler({ env = process.env, fetcher = fetch, store = createStore(env, fetcher) } = {}) {
  const token = env.DEMO_ACCESS_TOKEN;
  return async (request, response) => {
    const send = (status, value) => {
      response.writeHead(status, { 'Content-Type': 'application/json', 'Cache-Control': 'no-store' });
      response.end(JSON.stringify(value));
    };
    try {
      const provided = Buffer.from(request.headers.authorization ?? '');
      const expected = Buffer.from(`Bearer ${token ?? ''}`);
      if (!token || provided.length !== expected.length || !timingSafeEqual(provided, expected)) throw new DemoError('Demo access token is required.', 401);
      const path = new URL(request.url, 'https://localhost').pathname;
      if (request.method === 'GET' && path === '/health') {
        return send(200, { higgsConfigured: Boolean(env.BOSON_API_KEY), memoryConfigured: store.configured });
      }
      if (request.method === 'GET' && path === '/memory') return send(200, await store.retrieve());
      if (request.method === 'POST' && path === '/session') {
        if (!env.BOSON_API_KEY) throw new DemoError('Higgs is not configured.', 503);
        // A failed memory read must never masquerade as a first call with no memory.
        const saved = await store.retrieve();
        let result;
        try {
          result = await fetcher('https://api.boson.ai/v1/realtime/client_secrets', {
            method: 'POST', redirect: 'error',
            headers: { Authorization: `Bearer ${env.BOSON_API_KEY}`, 'Content-Type': 'application/json' },
            body: JSON.stringify({ expires_after: { seconds: 300 } }), signal: AbortSignal.timeout(15000),
          });
        } catch { throw new DemoError('Higgs credential connection failed.', 502); }
        if (!result.ok) throw new DemoError(`Higgs credential request failed (HTTP ${result.status}).`, 502);
        const body = await result.json().catch(() => null);
        if (typeof body?.value !== 'string') throw new DemoError('Higgs credential response was invalid.', 502);
        return send(200, {
          secret: body.value, expiresAt: body.expires_at,
          instructions: buildInstructions({ topic, memory: saved.memory, language: env.DEMO_LANGUAGE ?? 'Thai' }),
          tools: [learningTool], ...saved,
        });
      }
      if (request.method === 'POST' && path === '/sessions') {
        const evidence = validateSession(await readJSON(request));
        const saved = await store.save(evidence);
        return send(200, { ...saved, rejectedSignals: evidence.rejectedSignals, warnings: evidence.warnings });
      }
      throw new DemoError('Route not found.', 404);
    } catch (error) {
      // Provider payloads, URLs, audio, transcript and credentials are never logged.
      const status = error instanceof DemoError ? error.status : 500;
      const message = error instanceof DemoError ? error.message : 'Demo backend request failed.';
      console.error(`Demo request failed (HTTP ${status}).`);
      send(status, { error: message });
    }
  };
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  if (!process.env.DEMO_ACCESS_TOKEN) {
    console.error('DEMO_ACCESS_TOKEN is required.');
    process.exitCode = 1;
  } else {
    try {
      const server = https.createServer({
        key: readFileSync('.demo/server-key.pem'), cert: readFileSync('.demo/server-cert.pem'),
      }, createHandler());
      server.requestTimeout = 30000;
      server.headersTimeout = 15000;
      server.on('error', () => { console.error('Demo HTTPS server failed to start.'); process.exitCode = 1; });
      server.listen(Number(process.env.PORT || 8787), process.env.HOST || '0.0.0.0', () => console.log('Roasted HTTPS demo broker is listening.'));
    } catch { console.error('Demo HTTPS certificate/key unavailable.'); process.exitCode = 1; }
  }
}
