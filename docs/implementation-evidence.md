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

At 20:21 UTC the duplicate-candidate regression is fixed: verified improvement is retained unless a duplicate includes a genuinely later learner retry. A later unsuccessful retry may supersede older progress; tool ordering alone cannot downgrade it. Two regressions were reproduced before the fix; **15 backend tests pass** afterward. Backend restart and installation of the signed native capture-failure fix are pending the founder completing the current phone test. Existing saved receipts have not been rewritten.

## Physical transcription-language bug — 20:22–20:25 UTC

Founder feedback, verbatim: “oh i do see chinese lanugage instead of english or thai while everyone is speaking english”; clarification: “Under YOU”. This localizes the reported script mismatch to input transcription, not assistant speech. The app had omitted `audio.input.transcription.language`. Added the provider-documented `en` hint to native configuration and aligned retained provider smokes.

Signed device build passed. Live synthetic English speech transcribed exactly with the hint and received spoken output. A separate live comparison confirmed the provider acknowledged `en`; both hinted and automatic sessions preserved a standalone Thai sentence. Both omitted Thai embedded between English phrases. No Chinese was reproduced by the synthetic tests, and mixed-language subtitle fidelity remains a known limitation rather than an accepted result.

Founder confirmed “Back on Home”. At 20:25 UTC the broker was restarted with the verified progress-preservation fix; the signed iPhone app was installed and privately launched with both the language hint and explicit capture-failure handling. No existing receipt was rewritten. Requested a fresh physical English transcription → correction → retry → receipt test. Physical confirmation of the language fix and real learning memory is pending.

## Founder-directed personality and receipt repair — 20:32–20:42 UTC

Founder feedback: “i speak Thai and it should roast me on that”; “the conversation is also not savage. it just explains things to me.” Full reference call is retained in `docs/ideal-call.md` as a product target, never live learner evidence.

Changed the topic to source-backed AI-agent shopping/booking/calling; the prompt now makes Thai retreat trigger a short English roast and return to English, keeps normal turns 5–25 words, and embeds occasional corrections in the joke. Receipt adds verified culture context, actual learner Thai excerpt, and an actually spoken closing roast. Optional fields preserve old saved receipts; no database migration or old-receipt rewrite.

- **Build:** signed generic iPhone build passed. The direct device build was blocked because the phone is now unavailable; this update has NOT yet been installed on the phone. Last installed device version remains the 20:25 language/capture fix.
- **Automated:** simulator integration suite passed; final icon/capture changes also built in simulator and signed device targets. Backend **23/23 tests** passed, including matching-only receipt fields, longer actual Thai excerpt, and conservative placeholder removal when a later real retry proves the corrected phrase.
- **Visual mock:** Home → incoming → correction → retry → Thai → compact receipt exercised in Simulator. Final SF Symbols and complete layout inspected; screenshot `docs/evidence/personality/receipt-simulator.png`. This is a sample, not learner persistence.
- **Live Higgs, synthetic typed input:** original example and two varied answer sequences generated audio and final tool capture in about 1.4–1.9 seconds. The original followed the reference closely. A novel Netflix answer initially leaked the Spider-Man punchline; after removing that payoff, later runs reacted to Netflix/cooking instead. Latest retained run `2026-09-18T20-40-47.124Z.json` has 7 short spoken turns, immediate Thai roast, exact corrected phrase/retry, improvement true and no validator warnings. No database writes.
- **Quality limit:** novel jokes remain uneven and sometimes add unsupported assumptions; brevity is improved, but founder comedic acceptance is NOT established. The provider can omit Thai inside mixed-language audio even though standalone Thai survives. A receipt cannot display omitted evidence.

The local broker was restarted with the new prompt/receipt behavior at approximately 20:42 UTC. User was asked to reconnect/unlock the phone and leave Home for installation. Actual two-call learning continuity, phone transcription-fix confirmation, interruption, and founder roast/receipt/final acceptance remain open. Canonical Snapshot v6 and donor unchanged; no publication/submission.

## Updated physical installation — 21:36 UTC

Founder reconnected the iPhone. CoreDevice confirmed the same iPhone 14 Pro connected; the prepared signed build of checkpoint `45dcca6` installed successfully and the private launch helper confirmed launch. Authenticated local HTTPS health returned 200 with Higgs and InsForge configured. This installs the AI-agents topic, compact receipt, English transcription hint and latest native final-capture instructions. The current broker contains the updated personality and receipt validation.

Founder was asked to perform Thai switch → actual preposition error → offered correction → completed retry caption → End. Physical roast quality, receipt fidelity and fresh-call learning callback remain pending; installation does not approve them. Original hard timebox ends 21:43 UTC.

## Physical rehearsal feedback and automatic sleep — 21:39 UTC

Founder reported verbatim: “tested and you should have the log”; “the topic is boring. AI topic is okay but the content is not savage at all”; “the app stopped working when iphone goes to sleep more”. Clarified: “Screen locked automatically”. This explicitly leaves roast quality rejected/open.

Fresh InsForge read found receipt `194b1854-07f3-4f8a-b1f9-b52af8e7701e`, created21:36:31 UTC, AI-agents topic, actual learner Thai excerpt and zero learning signals. Memory remains empty. Full conversation/audio was intentionally not retained, so the receipt cannot diagnose the exact bland response. No invented learning has been added.

Source cause: `RoastedApp.swift` ends active calls on background entry, consistent with the approved foreground-only scope. Small fix disables the idle timer only while a live call connects, runs or saves in an active scene, and restores normal behavior on completion/failure/background. Signed device build passed. Automatic-lock prevention still needs physical verification; manual lock/background calls remain outside the implemented scope.

At21:40 UTC CoreDevice confirmed installation of the auto-lock fix and the private launch helper succeeded on the same physical iPhone. This is build/install evidence only; founder must still verify that a live call survives the normal auto-lock interval and that idle behavior returns afterward. No personality acceptance or two-call memory proof was inferred.

## Authorized roast-quality extension — from21:42 UTC

Founder approved an additional hour, hard stop22:42UTC. This is a new bounded quality repair, not approval of the earlier demo.

Compared native and synthetic session configuration: same Higgs model, instructions field, tools,24kHzPCM, semantic VAD and English transcription hint. Live synthetic speech confirmed the provider echoed submitted instructions exactly, retained a mixed English/Thai phrase, roasted the switch and corrected/retried the deliberate preposition error. No microphone or database writes in that check (`scripts/higgs-conversation-audio.mjs`; local evidence `.demo/conversation-audio/2026-09-18T21-47-58.593Z.json`). This rules out a demonstrated missing-prompt issue; typed-input tests were still a weaker proxy for real speech. Broker imports are cached until restart.

Reworked topic from a broad productivity question to “Would you outsource being an adult?” and a concrete provocative opening. Simplified the character instructions; removed the repeated-task-selection agenda, varied isolated style examples and made the spoken correction a short exact phrase. Added realistic `--probe` replies beyond the supplied script. Tested the documented temperature0.8 against default0.3; the higher setting introduced unsupported statements and did not reliably fix tone, so native settings remain unchanged. Reference: https://docs.boson.ai/models/higgs-realtime/guides/connections-and-sessions .

Latest retained typed-input runs at21:49 (`...21-49-02.874Z.json` family, `...21-49-13.561Z.json` novel) produced concise turns, Thai reaction, a validated exact correction/retry with improvement true, and no repeated stock family punchline. Some replies remain generic and cultural-summary candidates were correctly omitted with warnings. These are candidate improvements, not comedic acceptance.

Receipt validation now retains the last actual completed Nobody line (maximum1000 characters) if the tool omits a valid selected closing quote. It preserves one actual selected line for the receipt/review, not full transcript or audio. Valid tool-selected quotes remain preferred. Backend25/25 tests pass; signed iOS candidate build passed. Prepared for physical installation and human roast/memory rehearsal.

At21:50 UTC the latest-prompt synthetic two-call InsForge run passed: one exact correction (`spend time for`→`spend time ON`) with verified retry improvement saved under an isolated temporary learner, freshly retrieved and supplied to a new Higgs connection. Asked to recall, Nobody said “I do have your grammar slip from last time. You said 'spend time for' instead of 'spend time on.'” This was prompted recall, not a spontaneous opening callback. Temporary session/memory cleanup verified. One unsupported cultural summary was omitted. Real learner memory remains unproven. The broker was restarted with the candidate around21:52UTC.

## Repetition report — 21:58 UTC

Founder: “the roast is better but it got stuck repeating the same paragraph \"you're outsourcing your opinion too? next time you know ...\" no matter what my response was”. Asked whether YOU captions changed, founder replied “No, it stayed the same or missed them”. This is partial positive tone feedback, not roast acceptance; missing new input makes microphone/turn handling the immediate blocker.

Latest saved real receipt `f677e7d6-d309-4300-bbb6-b0417d203286`, created21:53:48 UTC, contains the reported actual closing line but zero learning signals; memory remains empty. The native UI still has the earlier title because the new topic-display build has not been installed; new calls already receive the restarted broker’s latest prompt.

A live typed eight-turn repetition probe (`docs/evidence/personality/2026-09-18T22-00-03.429Z.json`) reproduced one sentence across two distinct response IDs but tracked other changed inputs, with zero mid-conversation tool calls. This demonstrates a model-level repetition risk, but not the phone’s missing-caption failure. Native source has no explicit PCM replay loop. Adding metadata-only on-device counters to distinguish capture, send and provider transcription progression; no raw speech or full transcript retention.

At22:04UTC the metadata-only diagnostic candidate passed the signed generic iOS build and both Simulator tests (2passed,0failed; xcresult `Test-Roasted-2026.09.18_15-03-31--0700.xcresult`). The six-turn live PCM probe at22:00:46 also repeated the same CEO/filing joke three times with zero tool calls, then followed running/Thai/cat inputs; one planned interruption cancelled correctly. Provider repetition is independently reproduced; physical missing-caption cause remains unproven. Installation awaits confirmation that the phone is on Home.

At22:09UTC, after explicit Home confirmation, checkpoint `c50a140` diagnostic build installed and privately launched successfully on the connected iPhone14Pro. Founder was asked for three distinct replies and to leave any stuck call running. At22:11UTC CoreDevice reported the same device unavailable, so no physical diagnostic snapshot has yet been retrieved. Local metadata is retained on the phone; no input-stall fix or human acceptance is claimed.

## Physical diagnostic result — 22:12 UTC

Founder tested and reconnected: “i see \"the call ended but no save was confirmed... \"”; “during the call, it seems to hear me but it only replied to me one sentence at a time”. Clarification: “reponded correctly. i dont have the screen for the no save was confirmed anymore but it was for the receipt at the end of the call”. This confirms reactive turns in this test, not final comedic acceptance.

Device metadata for the approximately60-second call shows594tap callbacks,594converted chunks and594sent chunks (2,850,672bytes), zero dropped chunks,13speech starts and13completed input transcriptions,15responses, zero voice errors. No capture/send stall reproduced. Raw speech was not recorded. Metadata retained locally in `.demo/voice-health/2026-09-18T22-09-43.json`.

Fresh InsForge read confirms receipt `5bd82c81-a815-4a1f-84dc-baa892ae8941` (call created22:09:42UTC) was committed despite the app’s unconfirmed-save message. It has zero learning signals; configured learner memory remains empty. The original error detail is unavailable, so transport/decoding cause cannot be distinguished. Adding one fresh read after an uncertain save: only the exact call ID found in InsForge can confirm success; rejected4xx saves and missing receipts remain failures. No duplicate session or fabricated memory.

The receipt-recovery change passed a signed iOS build and all5Simulator tests at22:16UTC: existing mock/audio checks plus lost-response exact-receipt recovery, unrelated-receipt rejection and HTTP422 preservation. Regression tests use an isolated URLProtocol stub and fake data, never a provider or database. The original physical error detail remains unknown; recovery correctness does not prove the original network cause.

At22:17UTC checkpoint `dbe956e` installed and privately launched successfully on the connected iPhone14Pro. Founder was asked to speak an actual preposition mistake, hear the offered correction, retry it and verify the saved receipt before the second-call memory rehearsal. Installation is confirmed; physical recovery behavior and real two-call learning remain pending.

## First real phone learning signal — 22:21 UTC

After founder reported “done”, a fresh InsForge read confirmed actual phone receipt `26c02783-e225-4eea-a9ed-6c82a4885d9a` (created22:20:04UTC) and a persisted learning-memory signal updated22:20:50UTC: original `spend time for`, offered alternative `spend time ON`, later retry `spend time on`, improvementObserved=true. This is the configured learner's real spoken rehearsal, not a seeded or synthetic fixture. The saved receipt carries the same validated signal.

Device metadata shows5completed input transcriptions,6speech starts,7responses,437sent chunks, zero dropped chunks and zero voice errors; call stopped normally. This proves the first real call's persistence. The founder was asked to cold-reopen, start a new call without first revealing the target phrase, and report Nobody's callback (spontaneous or prompted). Receipt UI confirmation, new-call usage, automatic-lock interval and final comedy acceptance remain separate open gates.

The memory row's `source_session_id` was independently read and matches `26c02783-e225-4eea-a9ed-6c82a4885d9a`, confirming receipt and memory provenance.

## Real two-call memory confirmed — 22:24 UTC

Founder answered “Yes, after I asked” when asked whether the new call recalled the actual for/on correction. Combined with the independently verified first-call receipt/memory provenance, this establishes real physical two-call continuity with **prompted recall**, not spontaneous recall. Founder then requested a live Mac Simulator recording build and explicitly authorized pushing the repository and making it public. Submission itself remains a human action.

Final review caught UUID case normalization in save recovery: Swift creates uppercase UUID strings, while the backend normalizes them lowercase. Recovery now compares normalized IDs; the regression uses the real uppercase-request/lowercase-receipt shape. This is a delivery-blocking correction to the earlier recovery check, not a claim the earlier version handled that case.

## Recording candidate — 22:28 UTC

Final Simulator candidate passed all5native tests, including uppercase-request/lowercase-saved UUID recovery (`Test-Roasted-2026.09.18_15-26-15--0700.xcresult`). Installed and privately launched on the existing iPhone17Pro Simulator; UI accessibility verified **HIGGS LIVE** and **Retrieved from InsForge: spend time for**. Simulator audio input/output explicitly set to MacBook Air Microphone/Speakers. Human recording must verify capture of both voices; no video has been fabricated or submitted.

Before requested publication,76tracked files and201reachable historical blob versions were checked for the current three secret values, private-key markers and credential patterns; zero findings. No tracked audio files. All16retained full conversation evidence JSON files are explicitly synthetic. Ignored `.env` and `.demo` remain excluded.

## Authorized public repository delivery — 22:30 UTC

Founder explicitly requested pushing and making the repository public. Verified code candidate `895d78fffc281dcf7e47f591233ce10144c99595` pushed to `origin/codex/roasted-demo`; GitHub default branch set to that branch while the existing unrelated remote main initialization was preserved. `gh repo view` confirmed visibility PUBLIC and default branch codex/roasted-demo; `git ls-remote` confirmed the exact candidate hash. Public link: https://github.com/fai-none/roasted . No hackathon form was submitted. Simulator remains the live recording candidate; both-voice recording audio and actual video upload remain founder steps. Final documentation-only delivery record follows this verified code revision.

## Simulator recording interruption — 22:37 UTC

Founder reported: “it's really buggy. i can't have it speak longer than1word. it seems to get interrupted”. Latest approximately9-second Simulator call recorded4speech starts/transcriptions and6responses, with each speech-start event immediately after response.done while audio was still being played;76of76tap callbacks were audible, zero transport drops/errors. This supports a speaker-echo hypothesis but does not prove it without isolation. Native phone behavior and Simulator recording behavior are separate evidence tiers.

Founder selected headphones to preserve natural interruption rather than a Simulator-only half-duplex change. Simulator output was changed from pinned MacBook Air Speakers to System; Mac microphone remains selected. Await headphone route/retest. No application behavior changed or success claimed. Recording must capture system audio as well as microphone; a microphone-only recording with headphones would omit Nobody.

## Founder-requested final topic change — 22:46 UTC

After the timeboxed implementation, founder explicitly requested a new topic, then clarified: keep AI but make it savage about SF dating, pickleball and monotone tech-scene conversations. Changed Home/receipt topic and broker opening to “SF dating: emotionally available. In private beta.” Retained the existing sourced AI-agent context; SF dating material is labeled comic satire, not new factual reporting. Added conditional yesterday-go→yesterday-went correction only when actually spoken.

Simulator build and all25backend tests passed. Live synthetic typed Higgs probe `2026-09-18T22-46-03.431Z.json` delivered the exact intended roast/correction, followed changed dating/pickleball details and validated an actual synthetic retry with improvement=true; no database writes or human comedy acceptance. Broker restarted with the new prompt. The earlier morning-routine proposal was superseded before implementation.

## Physical connection restored on hotspot — 23:16 UTC

Founder reported that the phone could not start a call. New metadata-only `RoastedBackendHealth.json` diagnostics identified NSURLErrorDomain -1004 on `/memory`, before Higgs connection. Mac-local session creation succeeded; phone reachability on Guest Wi-Fi failed. This isolates the observed failure to the local broker connection, without claiming the guest network's exact policy was proven.

Founder explicitly authorized using the iPhone hotspot. This hotspot supplied usable IPv6 while its CLAT IPv4 address was unsuitable for phone-to-Mac serving. Changed the broker's default bind from IPv4-only to `::`, updated the ignored device URL and certificate SAN, retained the same private key, and reprovisioned the pinned public certificate. No TLS validation or authentication was disabled. Local addresses and credentials remain outside tracked files.

Verification: signed iOS diagnostic build and installation passed; all25backend tests passed; direct IPv6 HTTPS health returned200. Physical `/memory` then returned200 in approximately1second. Founder answered “yes” to whether Nobody spoke. The new phone voice metadata shows active phase, Higgs handshake101,3completed input transcriptions,4responses and zero failures. This verifies restored live phone conversation, not final comedic acceptance or a newly completed receipt. Simulator was relaunched with the refreshed certificate; accessibility inspection shows HIGGS LIVE and “Retrieved from InsForge: spend time for”. Keep the Mac connected to the authorized hotspot and the broker running for recording.
