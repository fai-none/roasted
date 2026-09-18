# Project lessons

## Keep sample learning outside persistent learner history

- Context: Roasted's full static call journey precedes live Higgs and InsForge integration.
- Lesson: A receipt can render convincingly without proving learning happened. Keep its sample provenance explicit, never add mock receipts to saved history, and emit no learning signal when a call ends before evidence exists. A correction alone is not proof of improvement.
- Evidence: `Roasted/CallSession.swift`; `Tests/CallSessionChecks.swift` verifies empty-call behavior, retry provenance and sample isolation. Simulator walkthrough and labeled screenshots are recorded in `docs/implementation-evidence.md`.
- Apply when: Replacing mock calls with live transcript/tool evidence and adding InsForge persistence. Validate selected quotes before saving, then render the receipt from that same saved session.
- Avoid: Seeding illustrative mistakes into a demo learner or claiming a second call remembered something merely because a local mock variable survived.
