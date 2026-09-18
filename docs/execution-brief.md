# Hackathon execution brief

Scope source: [full original request](original-request.md). This is the durable task detail behind Beluga's compact labels. All app work is pending; the planning repository and dashboard are the only deliverables so far. D means the exact branded donor checkout/revision in [Reuse Map](reuse-map.md).

## Product and scope

For conversationally fluent non-native English speakers: one daily culture conversation with Nobody, a savage but useful friend. Respond to the user's opinion before correcting meaningful grammar/phrasing, give a native alternative, invite a retry, then resume the same conversation. Support hesitation, imperfect speech, natural barge-in, changing one's mind and mid-sentence code-switching. A post-call receipt includes **What gave you away**, actual original phrase, native phrasing, expression learned and cultural takeaway.

Higgs is the live speech-to-speech conversation engine, not a TTS layer. Do not add a separate lesson/chat product, social graph, sender/receiver flow, roast-a-friend, App Clip, sharing or callback scheduling. Optional live topic tools come after the core demo works. Keep one app, one small session boundary and the minimum trusted credential endpoint needed by the actual provider contract.

Planning assumption: native iOS, because the donor is SwiftUI. Daily-call delivery is **not resolved**: in-app incoming call versus real scheduled/background call must be selected before its implementation. The plan does not claim a foreground simulation satisfies background daily delivery. No date, credential availability, organizer rule or official judging threshold has been invented.

## Journey

Home/Nobody → today's topic → Nobody calls → accept → live discussion/context → user opinion and Nobody's substantive reaction → detect meaningful unnatural English → roast plus native alternative → retry → continue the conversation → end → learning receipt.

Beluga groups these into ten readable steps. Repeated discussion/correction is a loop within one call, not separate lessons or a forced correction of every utterance. Decline returns Home; microphone/connection failure ends gracefully; a failed or empty call never invents a learning receipt.

## M0 — Foundation (current, not reached)

**Done:** independent app builds and launches; selected theme/avatar/primitives render; mock/live session boundary exists; no irrelevant donor routes or backend dependency.

| Task | Reuse / adaptation / exclusion | Depends on | Verification |
| --- | --- | --- | --- |
| **M0.1 Clean app bootstrap** (first/current) | Minimal `project.yml`, `RootView`/`HomeView` patterns only; own identity; no old `AppEnvironment`, friend/receiver/App Clip targets | Planning repository | Build and simulator cold launch without donor or keys; full AI TODOs in `implementation-plan/m0-foundation.md` |
| **M0.2 Port selected visual primitives** | Reuse `NobodyTheme`, `NobodyAvatar`, `NobodyActionStyle` and exact mascot catalog. Extract `CallControlsView` value/callback UI from Receiver folder. Keep `ActiveCallView` layout as a reference; no `CallOrchestrator` dependency | M0.1 | Theme and avatar render in new target; asset bytes match donor; controls invoke mock callbacks; no receiver imports |
| **M0.3 Define single-call state and Higgs boundary** | Adapt `RealtimeTransport`/session-ID and state-machine invariants into idle/ringing/connecting/active/ending/ended/failed; deterministic mock. Inspect official Higgs WebSocket audio/auth/events; do not port `NativeWebRTCRealtimeTransport` or roast modes | M0.1; M0.2 for visual integration | State-transition tests reject stale session events and finish twice; mock plugs into UI; short architecture note states exact verified provider contract and unknowns |

AI can execute M0.1 in the next authorized implementation session without Higgs credentials. M0.2 and the mock portion of M0.3 do not need paid calls. Human decision: daily foreground/demo versus scheduled/background delivery before implementing that behavior.

## M1 — Complete static product journey

**Done:** a user can traverse Home → topic → incoming → accept → discussion/coaching/retry → end → sample receipt with deterministic mocked data; decline/error/back paths work; founder reviews UX before live integration.

| Task | Reuse / adaptation / exclusion | Depends on | Verification |
| --- | --- | --- | --- |
| **M1.1 Home, topic and incoming call** | Adapt D `HomeView`/`RootView` layout and selected onboarding presentation; build a single-user incoming view and accept/decline state. Remove People, friend destinations, receiver recovery/consent and remote profile requirements | M0; delivery choice for final behavior | Cold launch and returning-user paths reach topic; accept starts one mock session; decline returns Home; no dead-end navigation |
| **M1.2 Active conversation and coaching loop** | Adapt D `ActiveCallView`, `CallControlsView`, private `MessageBubble`; replace `CallOrchestrator` bindings with M0 state/actions. Mock listening/speaking/opinion/reaction/correction/retry/continue without creating a standalone messaging product | M1.1 | Complete scenario including hesitation and interruption states; mute/end work; state labels reflect mock state; no networking |
| **M1.3 End and mock learning receipt** | Adapt conversation receipt/bubble styling and finish-schema field names, not a nonexistent completed receipt screen. Use clearly labeled fixture examples for all receipt fields | M1.2 | End navigates once to receipt; empty/failed calls show honest empty state; Home return works; founder reviews full static journey |

Human gate: accept the complete static journey and tone before M2. Mock data must never be reported as live learning evidence.

## M2 — Higgs realtime conversation

**Done:** physical-device speech-in/speech-out, natural interruption/recovery and repeated call lifecycle work over Higgs; failure/end paths clean up mic/playback; selected daily-call delivery mode is honestly demonstrated.

| Task | Reuse / adaptation / exclusion | Depends on | Verification |
| --- | --- | --- | --- |
| **M2.1 Secure Higgs session and full-duplex audio** | Implement the current documented WebSocket contract behind M0 boundary. Reuse donor permission/attempt-ID/cleanup lessons and tests, not OpenAI SDP/LiveKit transport. Use documented short-lived credentials from a minimal trusted server; never put the long-lived key in the app | M1 acceptance, current API contract, human-provided access | Real mic input produces Higgs speech output; invalid/expired credentials and mic denial fail visibly; no key in source/logs/app bundle |
| **M2.2 Turn-taking, interruption and teardown** | Adapt applicable `RealtimeProviderEventReducerTests`, `CallStateMachineTests`, `CallOrchestratorTests` scenarios; replace provider-specific event names/tools. Handle output flush/cancellation, stale events, disconnect and idempotent end | M2.1 | Device scripts: barge-in, change opinion mid-sentence, pause/hesitate, recover same topic; three consecutive calls; network loss/retry/end; no overlapping old output or mic left active. Record actual latency observations, not invented targets |
| **M2.3 Selected daily-call delivery** | In-app branch: one dated topic/incoming state with clearly described foreground limit. Background branch: implement only daily self-call scheduling and required iOS delivery integration after platform feasibility; reference donor system-call lifecycle only, never its callback/friend scheduler wholesale | Human delivery choice, M2.1 | In-app branch demonstrated as in-app only. Background branch requires signed physical-device scheduled arrival, timezone/day deduplication, accept/decline and missed-call proof; blocked if platform constraints invalidate the chosen UX |

Human input: provide Higgs access through a secret store and the intended demo language pair; approve any required provider spend/private-audio test. No secrets should be pasted into dashboard tasks. Simulator UI proof does not satisfy live voice or background delivery.

## M3 — Nobody coaching intelligence

**Done:** a real discussion reacts to opinion, catches useful grammar and unnatural phrasing, supplies a natural alternative, lets the user retry and continues the same thread; multilingual/code-switch cases work with the desired personality.

| Task | Reuse / adaptation / exclusion | Depends on | Verification |
| --- | --- | --- | --- |
| **M3.1 Today's bounded cultural topic** | Adapt D `culture-topics.js` provenance, sanitization/bounds and `topic-suggestions.js` hooks into one dated topic packet with event/source dates, context, expressions and opinion prompt. Replace seven-day selection assumptions with explicit daily selection; no social graph/profile ranking | M2; one sourced demo topic | Stale/malformed/missing sources rejected; unavailable day is explicit; injected source instructions ignored; demo topic checked against source. A curated packet suffices; realtime lookup remains optional |
| **M3.2 Friend-first coaching and retry** | Adapt personality and `learningInstructions` in `nobody-prompt.js`; strip friend/sender modes and memory. Add substance-first reaction → brief roast/correction → native alternative → user retry → return to discussion. Avoid false corrections and pronunciation inference from text | M3.1 | Live scripted cases for grammar, textbook/formal phrasing, word choice and missing context; natural English not needlessly corrected; retry maintains intended meaning; no classroom lecture |
| **M3.3 Multilingual and recovery evaluation** | Use M2 event boundary and donor evaluation-pattern ideas, with new relevant scenarios rather than old roast fixtures. Optional topic function only if baseline works and time permits | M3.2 | Native-language word in an English sentence, hesitation, mid-thought revision and interruption during correction preserve opinion/topic; person reviews usefulness and roast tone. Tool failure never invents fresh context |

Human gate: target user confirms corrections are useful and tone is savage without derailing the conversation. Automation can verify structure; it cannot declare human acceptance.

## M4 — Learning receipt from the real call

**Done:** receipt shows useful examples grounded in the actual completed conversation, including original phrase, native alternative, expression and cultural takeaway; no fabricated content on empty/failed calls.

| Task | Reuse / adaptation / exclusion | Depends on | Verification |
| --- | --- | --- | --- |
| **M4.1 Preserve structured learning evidence** | Adapt D `openai.js` finish schema ideas and reducer finish-once behavior into Higgs-compatible bounded learning events. Preserve exact user-utterance source IDs and selected correction fields instead of dropping them into summary/memory candidates; no raw audio archive or unrelated personalization memory | M3; M1 receipt contract | Real session examples trace back to spoken/transcribed input; duplicate, delayed, missing or malformed events do not create invented/duplicate receipts; cancellation yields only actually captured evidence |
| **M4.2 Populate and retain receipt** | Replace M1 fixtures with M4.1 data. Build minimal local receipt persistence and Home access; reuse theme/bubble typography, not donor chat cache wholesale | M4.1 | End-to-end compare displayed phrase/alternative with session evidence; relaunch retains the completed receipt; empty/partial state is honest; no fixture can appear in live mode |

Human check: review one real call and its receipt for fidelity and learning value. Confirm the intended retention behavior before persisting additional sensitive data; raw audio retention is outside MVP.

## M5 — Hackathon-ready product

**Done:** repeatable live demo on the intended device, setup works from clean checkout, Higgs's essential role is documented, official submission requirements are checked, and limitations are candid.

| Task | Reuse / adaptation / exclusion | Depends on | Verification |
| --- | --- | --- | --- |
| **M5.1 Demo rehearsal and failure sweep** | Run the new journey, relevant adapted lifecycle tests and one sourced demo topic. Do not import Nobody's unrelated App Store/receiver test matrix | M4 | Two complete rehearsals plus network/mic/auth interruption scenarios on intended hardware; artifact records revision/device/topic/date and separates mocks, simulator and live proof |
| **M5.2 Clean handoff and judging matrix** | Own README, setup/env example without secrets, minimal repo structure, explicit Higgs session/audio/interrupt/tool usage; map user-specified tracks to observed demo behavior | M5.1; official event URL/deadline/rules | New contributor follows setup; each judging claim links to genuine demo evidence; unfinished notes name background-call limits, optional tools and unproved cases; no borrowed donor features presented as new |

Human gate: provide official event page/deadline and review final demo/submission. Publishing/submission remains an explicit later action.

## Beluga conventions and status discipline

`repo-snapshot.v2` stores the active milestone and tasks, one detailed current task with AI TODOs/Human TODOs, journey + connections, compact progress/blockers, and three repo-relative references. `plannedMilestones` stores future titles and definitions only; future task contracts live here until their milestone is activated. Do not put future work into fake task history or copy completion between requests. AI TODO IDs M0.1 map to `implementation-plan/m0-foundation.md`; subsequent task IDs follow these table identifiers.

The 9,793-character original request exceeds the Snapshot's 8,192-character original-intent field. Its full text is preserved in `docs/original-request.md` and feedback evidence; currentTask.originalHumanWants contains only the exact M0 excerpt relevant to that task. No original wording was silently truncated or rewritten as founder approval.

Build/test commands must be taken from the new app when it exists. No donor build, current app build, paid Higgs call or human acceptance was claimed in this planning session.
