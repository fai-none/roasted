import { readFile } from 'node:fs/promises';
import { createStore } from './store.mjs';
import { DemoError } from './validation.mjs';

const version = '20260918190000';
const name = 'roasted-demo-learner-memory';
const store = createStore();
try {
  const history = await store.request('/api/database/migrations');
  const migrations = Array.isArray(history) ? history : history.migrations;
  if (!Array.isArray(migrations)) throw new DemoError('Could not inspect migration history.', 502);
  if (migrations.some((entry) => String(entry.version) === version && entry.name === name)) {
    await store.retrieve();
    console.log('Roasted schema already installed; read access verified.');
  } else {
    const tables = await store.request('/api/database/tables');
    if (!Array.isArray(tables)) throw new DemoError('Could not inspect existing tables.', 502);
    if (tables.some((table) => ['sessions', 'learning_memory'].includes(typeof table === 'string' ? table : (table.name ?? table.tableName ?? table.table_name)))) {
      throw new DemoError('Existing sessions or learning_memory table requires inspection; nothing was changed.', 409);
    }
    const sql = await readFile(new URL('./schema.sql', import.meta.url), 'utf8');
    await store.request('/api/database/migrations', { method: 'POST', body: JSON.stringify({ version, name, sql }) });
    await store.retrieve();
    console.log('Roasted schema installed; empty/readable learner state verified.');
  }
} catch (error) {
  console.error(error instanceof DemoError ? error.message : 'Schema setup failed. No raw provider details were logged.');
  process.exitCode = 1;
}
