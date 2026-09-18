// Explicit synthetic backend contract check. Never writes the configured demo learner.
// All generated fixture rows are deleted in finally; no audio or transcript is uploaded.
import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { createStore } from './store.mjs';
import { DemoError } from './validation.mjs';

const learner = `roasted-contract-check-${randomUUID()}`;
const store = createStore({ ...process.env, DEMO_LEARNER_ID: learner });
const id = randomUUID();
const rollbackID = randomUUID();
const signal = {
  kind: 'grammar', signal: 'Synthetic backend contract fixture', originalQuote: 'Synthetic original',
  nativeAlternative: 'Synthetic alternative', retryQuote: '', improvementObserved: false,
};
const receipt = {
  id, createdAt: new Date().toISOString(), topic: 'SYNTHETIC backend contract check, not a real conversation',
  signals: [signal], usefulExpression: '', culturalTakeaway: '', isMock: true,
};
try {
  const first = await store.save({ receipt, sources: [], memories: [{ key: 'synthetic-fixture', ...signal }] });
  assert.equal(first.receipt.id, id);
  assert.equal(first.memory.length, 1);
  const read = await createStore({ ...process.env, DEMO_LEARNER_ID: learner }).retrieve();
  assert.equal(read.memory.length, 1);
  assert.equal(read.receipts[0].id, id);
  const retry = await store.save({ receipt: { ...receipt, topic: 'must not overwrite original' }, sources: [], memories: [] });
  assert.equal(retry.receipt.topic, receipt.topic);
  let atomicFailure = false;
  try {
    await store.request('/api/database/rpc/save_learning_session', {
      method: 'POST', body: JSON.stringify({
        p_learner_id: learner, p_receipt: { ...receipt, id: rollbackID }, p_sources: [],
        p_memories: [{ key: 'would-be-new-memory', payload: signal }, { payload: signal }],
      }),
    });
  } catch (error) {
    if (!(error instanceof DemoError)) throw error;
    atomicFailure = true;
  }
  assert.equal(atomicFailure, true);
  const after = await store.retrieve();
  assert.equal(after.receipts.length, 1);
  assert.equal(after.memory.length, 1);
  console.log('PASS: synthetic InsForge save, fresh retrieval, immutable retry and atomic rollback. This is not live learner proof.');
} catch (error) {
  console.error(error instanceof DemoError ? error.message : 'Synthetic InsForge contract assertion failed.');
  process.exitCode = 1;
} finally {
  try {
    await store.request('/api/database/advance/rawsql', {
      method: 'POST', body: JSON.stringify({
        query: 'WITH removed_memory AS (DELETE FROM public.learning_memory WHERE learner_id = $1 RETURNING signal_key) DELETE FROM public.sessions WHERE learner_id = $1',
        params: [learner],
      }),
    });
    const remaining = await store.retrieve();
    assert.equal(remaining.memory.length, 0);
    assert.equal(remaining.receipts.length, 0);
    console.log('Synthetic fixture cleanup verified; demo learner was never changed.');
  } catch {
    console.error(`Synthetic fixture cleanup requires attention for learner ${learner}.`);
    process.exitCode = 1;
  }
}
