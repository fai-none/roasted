# Minimum provider contract

Official documentation checked 2026-09-18; no live-provider proof is implied.

## Higgs

Trusted backend mints a five-minute client credential with `POST https://api.boson.ai/v1/realtime/client_secrets`, bearer `BOSON_API_KEY`, body `{"expires_after":{"seconds":300}}`. The iOS client connects to `wss://api.boson.ai/v1/realtime?model=higgs-realtime` using subprotocols `realtime` and `bai-client-secret.<value>`. Mint afresh for each call; no provider key goes into the app.

Send `session.update` immediately: the first update is acknowledged with `session.created`. Use mono PCM16 little-endian at 24 kHz in both directions, base64 JSON. Configure `audio.input.format` and `audio.output.format` as `{"type":"audio/pcm","rate":24000}`; output modalities `["audio"]`; output voice `default`; input transcription model `higgs-stt-3.1`; semantic VAD. Convert hardware microphone samples to this format.

Send `input_audio_buffer.append`; play `response.output_audio.delta`. On `input_audio_buffer.speech_started`, discard queued local playback. Capture actual input from `conversation.item.input_audio_transcription.completed` and assistant words from `response.output_audio_transcript.done`. Start greeting with `response.create`; VAD handles later turns. Execute completed function calls once from `response.done.response.output`; reply with a `function_call_output` conversation item, then `response.create`.

Live discovery: a plain `response.create` after an already completed turn can fail with `No user input`. At hang-up, stop audible playback, allow the last transcript to settle, await cancellation if needed, then send a distinct application-control text item requesting `capture_learning` with exact finalized source records. Await that item's acknowledgement before `response.create`. Keep the control item out of learner evidence. Quote provenance still requires backend validation; a model can return valid JSON with invented or unspoken wording. Synthetic provider tests verified this flow; it is not human-conversation acceptance.

Sources: [connections](https://docs.boson.ai/models/higgs-realtime/guides/connections-and-sessions), [audio](https://docs.boson.ai/models/higgs-realtime/guides/audio-and-voices), [client events](https://docs.boson.ai/api-reference/realtime/client-events), [server events](https://docs.boson.ai/api-reference/realtime/server-events), [interruptions](https://docs.boson.ai/models/higgs-realtime/guides/turn-detection-and-interruptions), [tools](https://docs.boson.ai/models/higgs-realtime/guides/tool-calling).

## InsForge

Server-only bearer credential, project base URL. Retrieve bounded learner rows with `GET /api/database/records/learning_memory?learner_id=eq.<id>&order=updated_at.desc&limit=8`. Insert records with an **array** body and `Prefer: return=representation`; upsert supports `resolution=merge-duplicates` against a unique key. An atomic SQL function called through `/api/database/rpc/<name>` can save `sessions` and `learning_memory` together. Admin-only migrations use `POST /api/database/migrations` with `{version,name,sql}`. Project/schema permissions still need verification.

Single configured demo learner, backend-enforced; retain selected actual examples, not raw audio. Receipt reads the same saved session. Retrieve afresh before the second call. A local trusted backend can serve credential/retrieve/save operations without deploying another vendor service.

Source: [database REST](https://docs.insforge.dev/sdks/rest/database), [REST authentication](https://docs.insforge.dev/sdks/rest/overview).
