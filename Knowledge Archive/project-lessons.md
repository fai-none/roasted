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

## Test a personality against answers that are absent from its examples

- Context: Nobody followed the founder’s ideal script in a live synthetic Higgs call, but delivered a Spider-Man punchline when a different user answer said Netflix.
- Lesson: Script adherence is weaker evidence than reactive conversation. Change both the user’s opinion and their payoff answer; check that the model’s joke uses the actual last utterance without importing example facts. Keep human comedic acceptance separate from brevity and transport checks.
- Evidence: `scripts/higgs-personality-smoke.mjs --novel` and `--family`; `docs/evidence/personality/2026-09-18T20-36-38.775Z.json` shows the unrelated film reference. Removing that specific payoff stopped it in subsequent retained runs, but humor remained uneven.
- Apply when: Tuning examples for a conversational character or evaluating a demo against a founder-written ideal call.
- Avoid: Calling a prompt successful solely because the model reproduces the supplied conversation, or weakening quote validation to make its learning receipt look better.

## A missing save response does not prove a missing database write

- Context: A physical Roasted call showed “no save was confirmed”, while a fresh InsForge read found that exact call receipt committed.
- Lesson: Treat a lost acknowledgement as uncertain. Confirm by reading the same session ID; an unrelated receipt or a successful voice call proves nothing about that write. Preserve the original error if confirmation fails.
- Evidence: `DemoBackend.save` performs one read after an uncertain save; `DemoBackendSaveRecoveryChecks` covers exact-ID recovery, unrelated receipts and validation rejection. The actual device/database observation is in `docs/implementation-evidence.md`.
- Apply when: A client reports failure after a transactional save or loses connectivity around hang-up.
- Avoid: Creating a new session ID to retry, fabricating a receipt, or turning an explicit validation rejection into success.

## Verify phone reachability before debugging the voice provider

- Context: Mac-local session creation worked while the iPhone could not start a call; its backend request failed with NSURLErrorDomain -1004 before Higgs connected.
- Lesson: A local health check only proves the Mac can reach itself. Check a phone-originated request, address family, server binding and certificate hostname separately. An IPv6 hotspot may expose a CLAT IPv4 address that is unsuitable as a LAN server address.
- Evidence: `DemoBackend.recordConnection`, the IPv6-capable default listener in `server/index.mjs`, and physical HTTP200 plus Higgs101 after hotspot reprovisioning in `docs/implementation-evidence.md`.
- Apply when: Moving a locally hosted phone demo between guest Wi-Fi and Personal Hotspot. Refresh the private URL/certificate and relaunch both clients when the server address changes.
- Avoid: Disabling TLS verification or treating Simulator success as proof that the physical phone can reach the broker.
