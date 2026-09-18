import { DemoError } from './validation.mjs';

export function createStore(env = process.env, fetcher = fetch) {
  const base = env.INSFORGE_BASE_URL?.replace(/\/$/, '');
  const learner = env.DEMO_LEARNER_ID;
  const configured = Boolean(base && env.INSFORGE_API_KEY && learner);
  async function request(path, options = {}) {
    if (!configured) throw new DemoError('InsForge learner memory is not configured.', 503);
    let response;
    try {
      response = await fetcher(`${base}${path}`, {
        ...options, redirect: 'error',
        headers: { Authorization: `Bearer ${env.INSFORGE_API_KEY}`, 'Content-Type': 'application/json', ...options.headers },
        signal: AbortSignal.timeout(15000),
      });
    } catch { throw new DemoError('InsForge connection failed. Learner memory was not confirmed.', 502); }
    if (!response.ok) throw new DemoError(`InsForge request failed (HTTP ${response.status}).`, 502);
    try { return await response.json(); }
    catch { throw new DemoError('InsForge returned an invalid response.', 502); }
  }
  async function retrieve() {
    const filter = new URLSearchParams({ learner_id: `eq.${learner}` });
    const [memoryRows, sessionRows] = await Promise.all([
      request(`/api/database/records/learning_memory?${filter}&order=updated_at.desc&limit=8&select=payload,updated_at`),
      request(`/api/database/records/sessions?${filter}&order=created_at.desc&limit=10&select=receipt`),
    ]);
    if (!Array.isArray(memoryRows) || !Array.isArray(sessionRows)) throw new DemoError('InsForge memory response was invalid.', 502);
    return {
      memory: memoryRows.map((row) => ({ ...row.payload, updatedAt: row.updated_at })),
      receipts: sessionRows.map((row) => row.receipt),
    };
  }
  async function save({ receipt, sources, memories }) {
    const result = await request('/api/database/rpc/save_learning_session', {
      method: 'POST',
      body: JSON.stringify({
        p_learner_id: learner, p_receipt: receipt, p_sources: sources,
        p_memories: memories.map(({ key, ...payload }) => ({ key, payload })),
      }),
    });
    if (!result?.receipt || !Array.isArray(result.memory)) throw new DemoError('InsForge save confirmation was invalid.', 502);
    return result;
  }
  return { configured, retrieve, save, request };
}
