# Current implementation task

M2.1 — connect secure Higgs microphone input and speech output. Founder authorized proceeding on 2026-09-18 at approximately 19:13 UTC; roast tuning is deferred until the end-to-end flow works. Existing live tone/receipt/final acceptance checks remain pending.

Done means an accepted in-app call sends actual microphone audio to Higgs and plays its response on the iPhone, with visible permission/connection failures and clean end. No simulator or mock result counts as live-device proof.

Current AI TODOs:
- Audio owner: two focused native files for PCM conversion/playback, Higgs WebSocket, interruption and teardown. No donor WebRTC stack.
- Backend owner: local HTTPS credential endpoint, fresh InsForge retrieve and atomic selected-evidence save; two tables only. Validate provider access without logging keys.
- Lead: app API client, single-session integration, private runtime configuration and existing-device signing. Keep mock separately labeled.
- Build, install, exercise microphone-in/speech-out and end/restart on the connected iPhone. Record actual observations and unresolved gaps.

Dashboard reconciliation is blocked by missing authenticated task tools; Snapshot v6 remains untouched. Evidence is in `docs/implementation-evidence.md`.
