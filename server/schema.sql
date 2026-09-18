-- Additive demo schema. Access stays behind the authenticated local broker.
CREATE TABLE public.sessions (
  id uuid PRIMARY KEY,
  learner_id text NOT NULL,
  created_at timestamptz NOT NULL,
  topic text NOT NULL,
  receipt jsonb NOT NULL,
  selected_source_items jsonb NOT NULL DEFAULT '[]'::jsonb
);
CREATE INDEX sessions_learner_created ON public.sessions (learner_id, created_at DESC);

CREATE TABLE public.learning_memory (
  learner_id text NOT NULL,
  signal_key text NOT NULL,
  source_session_id uuid NOT NULL REFERENCES public.sessions(id),
  payload jsonb NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (learner_id, signal_key)
);
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.learning_memory ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.sessions, public.learning_memory FROM anon, authenticated;
GRANT SELECT, INSERT, UPDATE ON public.sessions, public.learning_memory TO project_admin;
CREATE POLICY roasted_sessions_admin ON public.sessions TO project_admin USING (true) WITH CHECK (true);
CREATE POLICY roasted_memory_admin ON public.learning_memory TO project_admin USING (true) WITH CHECK (true);

CREATE FUNCTION public.save_learning_session(
  p_learner_id text, p_receipt jsonb, p_sources jsonb, p_memories jsonb
) RETURNS jsonb LANGUAGE plpgsql SECURITY INVOKER SET search_path = public, pg_temp AS $$
DECLARE
  saved public.sessions%ROWTYPE;
  inserted_count integer;
  signal_entry jsonb;
  memories jsonb;
BEGIN
  INSERT INTO public.sessions(id, learner_id, created_at, topic, receipt, selected_source_items)
  VALUES ((p_receipt->>'id')::uuid, p_learner_id, (p_receipt->>'createdAt')::timestamptz,
    p_receipt->>'topic', p_receipt, p_sources)
  ON CONFLICT (id) DO NOTHING;
  GET DIAGNOSTICS inserted_count = ROW_COUNT;
  SELECT * INTO saved FROM public.sessions WHERE id = (p_receipt->>'id')::uuid;
  IF saved.learner_id <> p_learner_id THEN RAISE EXCEPTION 'Session ownership mismatch'; END IF;
  -- Retried saves return the immutable first receipt, without applying memory twice.
  IF inserted_count = 1 THEN
    FOR signal_entry IN SELECT value FROM jsonb_array_elements(p_memories) LOOP
      INSERT INTO public.learning_memory(learner_id, signal_key, source_session_id, payload, updated_at)
      VALUES (p_learner_id, signal_entry->>'key', saved.id, signal_entry->'payload', now())
      ON CONFLICT (learner_id, signal_key) DO UPDATE SET
        source_session_id = EXCLUDED.source_session_id,
        payload = EXCLUDED.payload,
        updated_at = EXCLUDED.updated_at;
    END LOOP;
  END IF;
  SELECT COALESCE(jsonb_agg(entry.payload || jsonb_build_object('updatedAt', entry.updated_at)), '[]'::jsonb)
    INTO memories FROM (
      SELECT payload, updated_at FROM public.learning_memory
      WHERE learner_id = p_learner_id ORDER BY updated_at DESC LIMIT 8
    ) entry;
  RETURN jsonb_build_object('receipt', saved.receipt, 'memory', memories);
END;
$$;
REVOKE ALL ON FUNCTION public.save_learning_session(text, jsonb, jsonb, jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.save_learning_session(text, jsonb, jsonb, jsonb) TO project_admin;
