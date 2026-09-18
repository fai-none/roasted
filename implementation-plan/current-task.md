# Current implementation task

M2.1 — connect secure Higgs microphone input and speech output. Founder authorized proceeding on 2026-09-18 at approximately 19:13 UTC; roast tuning is deferred until the end-to-end flow works. Existing live tone/receipt/final acceptance checks remain pending.

Done means an accepted in-app call sends actual microphone audio to Higgs and plays its response on the iPhone, with visible permission/connection failures and clean end. No simulator or mock result counts as live-device proof.

Current AI TODOs:
- [x] Implement native PCM capture/playback and Higgs transport; fix observed route-change and Swift callback crashes. Simulator runtime tests and muted native live greeting pass.
- [x] Integrate private local HTTPS access, fresh InsForge reads and atomic selected-evidence saves. Two-call synthetic provider/database chain passes; configured learner remains unseeded.
- [x] Build integrated app; 2 iOS tests and 11 backend tests pass. Commit the reviewable implementation and retain proof tiers.
- [ ] Install on connected iPhone after founder signs into Xcode Apple Accounts; no account/profile is currently available.
- [ ] Exercise real microphone-in/speech-out, interruption, clean end/restart, then real two-call saved memory and receipt reopening. Record observations; founder quality/fidelity acceptance remains pending.

Dashboard reconciliation is blocked by missing authenticated task tools; Snapshot v6 remains untouched. Evidence is in `docs/implementation-evidence.md`.
