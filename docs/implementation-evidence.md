# Roasted implementation evidence

Started 2026-09-18 18:43 UTC (11:43 America/Los_Angeles). Hard stop: 21:43 UTC (14:43 local), including verification/rehearsal.

Repository: `/Users/fai/Documents/GitHub/Roast`; origin `https://github.com/fai-none/roasted.git`; baseline `7585adf`; implementation branch `codex/roasted-demo`. Existing untracked `.agents/`, `.claude/`, `AGENTS.md`, `CLAUDE.md` are preserved.

## M0.1 — build and simulator proof

Started: create one independent SwiftUI target and offline Home, then build/cold-launch and inspect a screenshot. No provider keys or donor dependencies. Canonical dashboard verification is being investigated; no dashboard mutation has been made.

Passed at 18:50 UTC: `xcodegen generate`; `xcodebuild -project Roasted.xcodeproj -scheme Roasted -configuration Debug -destination id=DB91726F-277C-4CFB-9577-E17D0E0B1726 -derivedDataPath /tmp/RoastedDerivedData CODE_SIGNING_ALLOWED=NO build`. Exactly one app target, no dependencies. Installed on iPhone 17 Pro / iOS 26.3, launched, then repeated with `simctl launch --terminate-running-process`; visually inspected Home with “Roasted / Your English. Well done.” Screenshot: `docs/evidence/m0-bootstrap.png`. Initial simulator cold boot took several minutes. This does not prove iPhone 14, microphone or provider behavior.

Exact read-only donor: `/Users/fai/Documents/GitHub/nobody/.codex-worktrees/baby-beluga`, revision `8dad99224fb830c4059a5120416b0c32f89d6c72`. Its pre-existing modified `.baby-beluga/snapshot.md` is untouched. Read pinned project, root, Home, theme and controls source. Excluded all donor identity/signing/packages/remote environment and social routes.

Human inputs: English + Thai; iPhone 14. User requested an ignored `.env` to fill in. Live usage permission, provider access, static journey review, live tone/receipt/final acceptance remain unverified. No human check has been approved by implementation.

## Canonical dashboard check

Read-only durable database inspection confirmed Snapshot **v6**, `in_sync`, updated `2026-09-18T18:24:17.047Z`, with JSON equal to the repository snapshot. Project `project_b4dd4fad-2f3d-4f41-a13b-372e6ddcf89f`; active connection `repository_connection_45220f8a-626b-4dbe-a907-e7e349d35392`; root `/Users/fai/Documents/GitHub/Roast`. Latest proposal v5 was approved/exported; no newer pending proposal/progress. No authenticated task-local MCP connection is available, so dashboard writes remain blocked. This is binding verification, not authenticated MCP context proof. Canonical state is untouched; local progress awaits reconciliation through `get_dashboard_state_context` and supported progress/proposal tools.

## M0 visual/session foundation and M1 static journey

Implemented and simulator-verified 18:59 UTC (~16 minutes elapsed). Theme and mascot PNG match pinned donor bytes; controls adapt accessibility identifiers only. `CallSession` owns one guarded mock lifecycle; no donor runtime, LiveKit, social routes or backend was imported. The eventual live adapter is not implemented at this checkpoint.

Build passed with the same Xcode command/destination/cache. Fixed XcodeGen's default AppIcon expectation by leaving the app-icon setting empty; icon polish is deferred. Focused executable checks passed: accept guard, duplicate accept, decline, no fabricated signal on empty call, no improvement before retry, mock receipt excluded from saved learner history, cleanup. Command: `swiftc -module-cache-path /tmp/RoastedSwiftCache Roasted/CallSession.swift Tests/CallSessionChecks.swift -o /tmp/roasted-session-checks && /tmp/roasted-session-checks`.

Manually exercised simulator Home → incoming → decline → Home → incoming → accept → mute → sample opinion/roast → retry → Thai code-switch → end → sample receipt → Home. Screens visually inspected: `docs/evidence/m1-home.png`, `m1-incoming.png`, `m1-coaching.png`, `m1-receipt.png`. Receipt lower fields and return action confirmed through accessibility; full small-device visual fit remains unverified. All conversation/learning content here is labeled mock, never live evidence.

Topic source was read on 2026-09-18: Apple Newsroom's September 9 iPhone 18 Pro announcement, availability September 18. The upgrade-culture question is editorial framing, not a sourced claim about public opinion.

**Existing human gate:** static journey/tone review before M2 is pending. No live provider calls, real microphone capture, InsForge writes, signed iPhone install or new human acceptance has occurred.

## Roast quality correction — 19:07 UTC

Founder supplied the Roast Quality Contract, preserved in `docs/roast-quality-contract.md`. Roast quality is P0: entertain first; approximately 70% roast/culture, 20% reactive back-and-forth, 10% explicit correction. Updated the sample interaction to use a specific upgrade callback and tease the act of switching into Thai. Added `server/prompt.mjs` with bounded, untrusted topic/memory context and actual-evidence tool instructions; no live backend is wired at this checkpoint.

Revised app build passed; installed/relaunched in the same simulator. Prompt Node syntax and focused call-state checks passed. Provider configuration presence was checked without exposing values: all five required fields are populated. Credentials have not yet been tested. CoreDevice reports the paired iPhone 14 Pro as unavailable, so no physical-device proof. Static/M2 usage confirmation remains pending; adding keys has not been recorded as acceptance.

## Authorized live integration — 19:13 UTC onward

Founder said “connected my phone” and “you can proceed for now. we will optimise the roast quality after everything is done”. This authorizes advancing the existing static flow and the previously described live-provider tests; it does not approve live roast quality, receipt fidelity or the final demo. The phone is now available (iPhone 14 Pro). Xcode device build reports no signed-in account/profile; founder asked to sign in while simulator/provider work continues.

Provider/backend evidence at 19:23 UTC:
- Higgs ephemeral credential mint: HTTP 200. Exact session configuration produced a completed synthetic greeting with 312,960 PCM bytes/132 chunks. Empty-evidence tool round trip also completed. No microphone or persistence in those wire tests.
- InsForge project inspected empty before additive `sessions` + `learning_memory` migration. Atomic save RPC is behind server-side admin access and table RLS; app has no provider key.
- 11 backend tests passed (local loopback permission required). Live synthetic isolated-learner test passed save, fresh retrieval, immutable retry and rollback. Temporary test rows removed and cleanup verified; configured demo learner never seeded.
- Local HTTPS broker `/health`, `/memory`, `/session` returned HTTP 200 under certificate validation and bearer authentication. Keys/client secrets were not printed. App simulator Home showed HIGGS LIVE and first-call empty memory after a genuine backend read.
- First native simulator call received microphone permission but WebSocket closed before audio. Native connection diagnosis is in progress; no audible native conversation is claimed yet.

## Native integration checkpoint — 19:38 UTC

Native Higgs WebSocket authentication is verified (HTTP 101); transport smoke is not microphone proof. Simulator runtime exposed two separate audio issues: an engine stopped after a configuration change, then a Swift 6 MainActor assertion in the audio tap. The implementation now recreates capture conversion for the current route and uses explicitly Sendable audio callbacks with MainActor hops for app state. Rebuilt successfully. The next simulator call remained active and produced microphone transcripts, but repeated fragments suggest speaker feedback; it was muted and terminated without saving. No learner-memory evidence is claimed from that call.

The app's lifecycle/evidence-isolation test now runs in the real iOS unit-test target: xcodebuild test passed, 1 test, 0 failures, on the same simulator/cache at 19:33 UTC. This verifies the labeled sample path and does not prove live voice quality.

Xcode Apple Accounts UI was inspected and has no signed-in account. Physical-device build/install remains blocked on founder sign-in. Synthetic live-provider learning-capture rehearsal is underway independently; no actual two-call learner-memory result or human acceptance has been recorded.

At 19:43 UTC the focused native audio runtime test passed two start/mute/synthetic-play/stop cycles: engine running, voice processing enabled, 48 kHz hardware capture, Speaker output, playback callbacks completed, muted output contained zero non-silent chunks. This test sends nothing to a provider and stores no microphone samples; it proves plumbing and teardown, not acoustic echo suppression or a human conversation. Provider keys/token literal scan passed across app, backend, scripts and docs; `.env` remains ignored with permissions `0600`.

At 19:44 UTC a native **muted-input** simulator call rendered a real Higgs greeting, “iPhone 18 Pro again? You're upgrading your phone faster than you upgrade your excuses.” The app moved from speaking to Your turn; screenshot `docs/evidence/m2-live-greeting-muted.png` was visually inspected. This is live-provider/native-playback evidence, not a human two-way conversation or accepted roast quality. Muting during connection avoided the prior speaker-feedback loop.

At 19:48 UTC `scripts/higgs-audio-smoke.mjs` sent locally synthesized English speech as paced 24 kHz mono PCM16, then VAD silence. Higgs transcribed “I think buying a new phone every year is a waste of money.” exactly and returned 501,120 response audio bytes. It received 133,560 speech bytes and 99,840 silence bytes; speech-start/stop/commit events were observed. This is **synthetic audio through the live provider**, not microphone, human, physical-device or InsForge evidence. Synthetic files stay in ignored `.demo/`.

The final-capture protocol now uses a distinct application-control item because Higgs rejected a new response without new input. Quote-grounded control produced two validated signals in 1.7 seconds in a fresh synthetic typed conversation. Native integration builds. The backend still rejects unmatched quotes and conservatively downgrades unsupported improvement; exact words alone do not prove pedagogical value. Human receipt/tone checks remain open.

## Integrated checkpoint — 19:53 UTC (~70 minutes elapsed)

`xcodebuild test` on the original simulator/cache passed **2 tests, 0 failures** (lifecycle/evidence isolation plus native audio). Result: `/tmp/RoastedDerivedData/Logs/Test/Test-Roasted-2026.09.18_12-50-40--0700.xcresult`. Backend tests passed **11/11** after the final fidelity instruction. The microphone callback/runtime fix and native integration are committed as `bcc8c51`; subsequent receipt-fidelity changes are included in this checkpoint.

`node --env-file=.env server/rehearse-provider.mjs --memory-continuity` passed a full **synthetic typed-input, live-provider** chain using the latest English-replacement rule:
- Call one produced 1,453,440 audio bytes and one validated preposition signal; final capture took 1.072 seconds.
- A random isolated learner's session and signal were saved to InsForge. A new store freshly retrieved one memory; a new Higgs connection used it.
- Call two said: “Oh, you mean the time you tried to say ‘spend time for’ instead of ‘spend time on’? Classic.” It generated 1,100,160 audio bytes.
- Test receipts were explicitly mock-marked. Temporary session and memory rows were deleted, then fresh reads verified cleanup. The configured demo learner was untouched.

This does **not** prove a real learner's two-call voice interaction. The provider still guessed an unsupported phone model in one synthetic greeting; comedy quality and factual restraint are not accepted. An earlier tool candidate selected commentary about a Thai word as the English alternative; tightened instructions removed that signal in the final run. Backend quote validation remains unchanged.

**Next concrete gate:** sign into Xcode Apple Accounts so the connected iPhone 14 Pro can be provisioned, then perform `docs/demo-rehearsal.md`. Device signing/install, phone microphone/speaker/interruption, actual learner save/callback, cold-launch receipt/Keychain, and founder roast/receipt/final acceptance remain unverified. Dashboard writes remain unavailable; canonical Snapshot v6 and the donor remain untouched. Nothing published or submitted.

## Signed physical-device installation — 20:08 UTC

Founder completed Xcode account sign-in. The physical iPhone 14 Pro is connected. `xcodebuild` for CoreDevice `B53111E4-BE2B-5489-98CD-ED53A2BA07A0`, cache `/tmp/RoastedDeviceData`, automatic provisioning, and the user's existing development team completed successfully. `devicectl device install app` confirmed `dev.roasted.demo` installed; the private launch script reported success. The local authenticated HTTPS health check returned 200. Signing configuration was passed locally, not copied from the donor or embedded in project source.

Founder was asked to allow local-network/microphone access and verify Home, hearing Nobody, and a response to actual speech. These observations are pending. Installation/launch success does not prove phone audio, receipt persistence, second-call influence or human acceptance. Implementation revision: `adfbad9`.

## First physical audio observation — 20:12 UTC

Founder reported verbatim: “i do hear it correctly”. This confirms audible output on the physical iPhone, not yet microphone response, interruption, roast quality or memory acceptance. A fresh InsForge read found two non-mock receipts for the configured learner, both with zero learning signals; no learning-memory rows yet. Latest receipt: `d348868d-f3c5-430d-b727-91c41a6e0ccf`, created `2026-09-18T20:11:34.000Z`. This proves real app-to-InsForge receipt persistence, not learning continuity. Founder was asked to complete one actual correction/retry, interrupt once, then end and inspect the receipt.

Founder replied “no error”; a subsequent read still showed the same two empty receipts. Whether Nobody actually offered a correction remains a requested clarification. Source review found that final-capture errors/timeouts were swallowed and could lead to an empty saved receipt. `finishCapture` now explicitly reports success; the app shows a failure and does not save when final capture is unconfirmed. Signed device build passed at 20:16 UTC; this update has not yet been installed over the founder's running app.

A separate synthetic **audio** diagnostic preserved the erroneous preposition in real Higgs STT, generated a spoken correction, transcribed the retry, and captured a valid signal in 1.570 seconds while silent PCM continued streaming. No database writes. Continuous audio is therefore not inherently blocking capture. This is not proof of what happened in the physical calls. The diagnostic also exposed duplicate candidates discarding an earlier successful retry; a focused validation fix is in progress. The provider incorrectly corrected an already-correct synthetic retry, so coaching semantics remain an explicit quality gap.
