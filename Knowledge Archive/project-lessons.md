# Project lessons

## Keep sample learning outside persistent learner history

- Context: Roasted's full static call journey precedes live Higgs and InsForge integration.
- Lesson: A receipt can render convincingly without proving learning happened. Keep its sample provenance explicit, never add mock receipts to saved history, and emit no learning signal when a call ends before evidence exists. A correction alone is not proof of improvement.
- Evidence: `Roasted/CallSession.swift`; `Tests/CallSessionChecks.swift` verifies empty-call behavior, retry provenance and sample isolation. Simulator walkthrough and labeled screenshots are recorded in `docs/implementation-evidence.md`.
- Apply when: Replacing mock calls with live transcript/tool evidence and adding InsForge persistence. Validate selected quotes before saving, then render the receipt from that same saved session.
- Avoid: Seeding illustrative mistakes into a demo learner or claiming a second call remembered something merely because a local mock variable survived.

## A successful Swift build does not prove an audio callback is safe

- Context: The native Higgs call built successfully but crashed when AVAudioEngine invoked a microphone tap on its audio queue.
- Lesson: Explicitly mark audio callbacks `@Sendable` and move UI/state changes onto `MainActor`. A callback created inside a MainActor method can otherwise inherit an executor assertion that only fails when the audio thread invokes it. Also rebuild conversion after a hardware route change stops the engine.
- Evidence: `VoiceAudio.swift`; `VoiceAudioChecks.swift` exercises two real engine start/mute/playback/stop cycles in Simulator. The original crash named the microphone-tap closure and `_swift_task_checkIsolatedSwift`; the corrected runtime test passed.
- Apply when: Adding AVFoundation callbacks or changing audio routing in Swift 6.
- Avoid: Treating typecheck or a provider WebSocket handshake as proof of native microphone/speaker operation.
