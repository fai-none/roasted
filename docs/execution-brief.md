# Hackathon execution brief

> Hard timebox: 3 hours. Optimize for the shortest path to a reliable end-to-end demo. Defer polish, architecture work, refactors, abstractions, edge cases, and non-demo functionality unless they directly unblock the demo.

This constraint applies across **M0–M5**, including verification and rehearsal. It is an execution/prioritization constraint, not a blocker or a claim that implementation has started. This update changes planning only. All app tasks remain pending; **M0.1 is the current task for the next implementation session**.

**Execution priority:** (1) working end-to-end voice conversation, (2) compelling roasting/coaching, (3) InsForge learner memory working end-to-end, (4) demo polish. Anything outside these goals is postponed. InsForge does not authorize broad backend cleanup or refactoring.

Scope sources: [original request](original-request.md), [Nobody reuse analysis](reuse-map.md), and the existing product journey. D below means the exact branded donor checkout/revision pinned in the reuse analysis. The donor stays read-only.

## Product architecture — Higgs + InsForge

**Higgs Realtime = real-time conversation layer:** speaking/listening, interruption, roasting and coaching. **InsForge = persistent learner-memory/backend layer:** useful learner state across calls.

Minimal intended scope is InsForge Postgres with **`sessions`** and **`learning_memory`**, plus two small backend functions/API operations: **retrieve learner memory** and **save/update learner memory**. Save the completed session’s selected learning evidence, then update that learner’s signals. On a later call, retrieve the same learner’s state and pass the relevant bounded context into Higgs. Reuse the saved session for the receipt rather than building a parallel receipt-persistence system. These are planned contracts, not a claim of deployed tables or verified provider access.

Keep only useful signals: recurring grammar mistakes, vocabulary issues, cultural knowledge gaps, topics discussed, actual mistake examples and evidence of improvement. Store enough session/learner association to retrieve the right state; use one confirmed demo learner with minimal access control, not an account-system project. Do not put privileged credentials in the app. No raw audio archive or full-transcript history is required; selected examples suffice. Additional sensitive-data retention remains outside this bounded decision.

Illustrative demo only: call one contains “People is overreacting because Apple don't really change much.” Save subject/verb agreement and do/does confusion with its actual example. Call two may naturally reference those signals and check progress. The implementation must demonstrate this from its real saved call, not pre-seed this example or claim “yesterday” when both calls happened today. An immediate second call can prove persistence; no cron, date simulation or overnight wait is required.

## Demo scope and execution order

For conversationally fluent non-native English speakers, Nobody is a savage but useful friend: one daily culture conversation, an opinion-first reaction, a meaningful correction with a native alternative, a retry, and continuation of the same discussion. The call ends with **What gave you away**: the actual original phrase, native phrasing, useful expression and cultural takeaway, retained for later access from Home.

Native iOS and **in-app incoming calls** are founder-confirmed. Higgs is the real speech-to-speech engine, not just TTS. Preserve natural turn-taking, interruption, hesitation, changing one's mind and the intended demo language pair's code-switching. Prove those in one short conversation, not a broad language or device matrix. A curated, dated, source-backed topic and a manual demo reset are sufficient; do not build a topic service or scheduler.

Home/Nobody → today's topic → Nobody calls → accept → live discussion/context → opinion and substantive reaction → roast plus native alternative → retry → continue → end → save session/learner signals in InsForge → retained learning receipt → later call retrieves memory and uses a prior signal. Decline returns Home. Basic microphone/connection failure must be visible and end safely. Mock examples must never appear as actual live learning.

| Milestone | Working budget | Required observable outcome |
| --- | ---: | --- |
| M0 — Foundation | 15 min | Independent app launches with reused Nobody identity and one small mock/live session boundary |
| M1 — Static journey | 15 min | Founder can walk through the complete mocked demo and review the interaction |
| M2 — Higgs realtime | 60 min | Real microphone input and speech output, interruption and clean session end on demo hardware |
| M3 — Nobody coaching | 30 min | One sourced discussion demonstrates opinion → useful roast/correction → retry → continuation |
| M4 — Learning receipt | 45 min | InsForge saves learner signals; call two retrieves and uses one; the real receipt reopens from the saved session |
| M5 — Demo evidence | 15 min | Two-call voice/coaching/memory proof, concise setup and final human review; polish last |
| **Total** | **180 min** | **Reliable end-to-end demo** |

Budgets are prioritization targets, not guarantees or new acceptance gates. Within the hard limit, move time toward Higgs voice, core coaching and persistent learner memory, in that order; polish is last. M4 gains 20 minutes by trimming bootstrap/static scaffolding, broad coaching evaluation and final presentation time, not by cutting live voice. If a step overruns, cut deferred work first; do not relabel mock audio or sample receipts as live. Check the documented Higgs audio/auth/events contract early in M0.3, then reach live audio in M2 before spending time on prompt tuning or polish. Keep existing human reviews brief and show the concrete result; never infer acceptance from silence. Required founder Higgs access/language inputs should be ready for M2; InsForge project access and the single demo learner identity should be ready for M4. Provider setup is not performed by this planning update.

## M0 — Foundation (current, not reached)

**Done:** an independent app builds and launches with the selected Nobody theme/avatar and minimum session actions; no friend, receiver, App Clip or old backend dependency.

| Task | Minimum contract and reuse | Done evidence |
| --- | --- | --- |
| **M0.1 Bootstrap clean app; build and launch** — current | Adapt minimal donor `project.yml` and `RootView`/`HomeView` patterns with an independent identity. Exclude old global environment, social routes, targets and secrets. | Target builds; Home cold-launches offline; capture the real screen. Current-task AI TODOs remain in the Snapshot; existing plan: `implementation-plan/m0-foundation.md`. |
| **M0.2 Reuse Nobody theme, avatar and call controls** | Reuse `NobodyTheme`, `NobodyAvatar`, exact mascot asset and the small value/callback controls needed for the demo. | Branded Home/call shell renders; mock controls respond without receiver dependencies. |
| **M0.3 Connect one-call mock state to a minimal Higgs boundary** | Adapt donor session identity and cleanup patterns only. Check the current provider contract; use one mock/live boundary, not a provider framework or copied LiveKit stack. | Mock accept/end works once; identify the actual audio/auth/events needed for M2. No architecture document or generic state framework is required. |

All three tasks directly unblock the demo. Credentials are unnecessary for bootstrap and mock work. Do not run donor builds or clean its existing state. The timebox overrides nonessential elaboration in the older M0 plan; keep its build, isolation and launch outcomes without expanding it during this planning-only update.

## M1 — Complete static product journey

**Done:** one labeled mock walkthrough covers Home/topic → incoming → accept → conversation/coaching/retry → end → sample receipt; decline and basic failure return safely. Founder reviews the journey before M2.

| Task | Concise contract | Done evidence |
| --- | --- | --- |
| **M1.1 Show Home, curated topic and in-app accept/decline** | Adapt donor Home/root presentation; use one static topic and the confirmed foreground call scope. No onboarding expansion or profile backend. | Accept enters one mock call; decline returns Home. |
| **M1.2 Show the mock opinion, correction and retry loop** | Adapt `ActiveCallView`, callback controls and only the message rendering needed to understand Nobody's reaction and retry. | One short scripted exchange reaches retry and continues; end works. |
| **M1.3 End into a labeled sample receipt; review static journey** | Reuse theme/finish-field ideas; the donor has no complete receipt screen to copy. | All receipt fields and Home return are visible; failed/empty mock calls show no invented learning; founder reviews the walkthrough. |

These tasks prove the core interaction cheaply before live integration. Defer animation, additional screens, exhaustive state variants and unrelated visual refinements. **Human gate:** review the complete static journey and tone before M2; mock approval is not live-provider verification.

## M2 — Higgs realtime conversation

**Done:** a real in-app call uses Higgs microphone-in/speech-out, supports a natural interruption and ends cleanly on the intended demo device; the same path can start again.

| Task | Concise contract | Done evidence |
| --- | --- | --- |
| **M2.1 Connect secure Higgs microphone input and speech output** | Implement the verified Higgs contract behind M0's boundary. Reuse donor permission/cleanup patterns; use only the minimum trusted credential endpoint required. No long-lived key in the app or logs. | Speak on demo hardware and hear a real Higgs response; microphone denial/auth failure is visible. |
| **M2.2 Support interruption, clean end and another call** | Adapt relevant donor cancellation/session-identity invariants to Higgs; no automatic reconnect framework. | Interrupt Nobody, continue the topic, end and start again without stale playback or an active old microphone. A disconnected call ends safely and can be retried manually. |
| **M2.3 Wire the in-app incoming call to the live session** | Replace M1's mock start with live accept; retain decline and one active session. Use today's curated packet and a manual rehearsal reset. | Home → incoming → accept reaches real conversation; decline returns Home; repeated taps do not create duplicate live sessions. |

Every task is needed to show Higgs's essential role. Defer multi-day scheduling, timezone/missed-call logic, background delivery, broad network recovery and latency instrumentation. **Human input before live calls:** secure Higgs access, demo language pair, and permission for the required provider spend/private-audio testing. No secrets in Snapshot tasks. Simulator screens do not prove live device audio.

## M3 — Nobody coaching intelligence

**Done:** one real sourced conversation reacts to the user's opinion, gives a useful savage correction/native alternative, lets the user retry and continues the same discussion; one code-switch/hesitation example works in the demo language pair.

| Task | Concise contract | Done evidence |
| --- | --- | --- |
| **M3.1 Prepare one dated, sourced cultural topic** | Reuse donor culture packet context, hooks and bounded source handling. Curate one packet rather than rebuilding ranking, discovery or daily automation. | Source/date, short context, useful expression and opinion prompt support the demo. Treat source text as context, not instructions. |
| **M3.2 Adapt Nobody's opinion-first roast, correction and retry** | Reuse `nobody-prompt.js` personality/learning wording; remove donor friend/sender modes and unrelated relationship memory; M4 supplies the new InsForge learner context without importing the donor memory system. React to meaning before correcting; retain the user's point. | Live opinion → substantive reaction → useful native alternative → user retry → conversation continuation. Natural English is not needlessly corrected. |
| **M3.3 Verify tone and one code-switch/hesitation recovery** | Use the same demo conversation and language pair, not a separate evaluation system. | One mid-sentence native-language word or hesitation preserves meaning/topic; target user reviews usefulness and tone. |

All three tasks demonstrate the differentiator. Defer multilingual matrices, a prompt/evaluation framework, topic tools, broad correction categories and personalization beyond the small InsForge learner signals required for the demo. **Human check:** useful, savage friend rather than a derailing lecture; automation cannot declare that accepted.

## M4 — Learning receipt from the real call

M4 keeps its existing position and milestone ID; its captured learning evidence now also powers persistent learner memory. **Done:** completed call one saves useful learner signals in InsForge, call two retrieves them and naturally uses at least one prior mistake/progress signal; the real receipt reopens from its saved session. No fabricated examples or improvement claims.

| Task | Concise contract | Done evidence |
| --- | --- | --- |
| **M4.1 Capture actual phrases, learning signals and progress evidence** | Adapt donor finish-schema ideas to available Higgs events. Capture selected grammar/vocabulary/culture signals, topic, actual example and observed improvement, with their session association. No generic event system or raw audio archive. | A selected signal/example traces to the actual conversation. Empty/failed input cannot invent fields, and improved performance is not assumed merely because a retry occurred. |
| **M4.2 Persistent learner memory — InsForge** — new | InsForge Postgres `sessions` + `learning_memory`; minimal retrieve and save/update functions/API. Save at completed-call end; retrieve relevant state for the same learner before the next Higgs conversation and let it influence coaching. Depends on M2 live voice, M3 coaching and M4.1 signals. | Completed call persists useful signals; a subsequent session retrieves them; at least one prior mistake/progress signal visibly affects the next conversation. Demonstrate the entire path and explain InsForge’s role. A new session must read the backend, not reuse in-memory call-one state. |
| **M4.3 Display and reopen the real receipt from the saved session** — existing receipt task | Replace mock fixtures with the real saved session’s phrase, native alternative, expression and cultural takeaway. Use that same persistence result rather than adding a second local storage architecture. | Compare the call with its receipt, relaunch and reopen it from Home; missing fields stay honest. |

The only added milestone task is M4.2. Existing capture and receipt task IDs remain stable; receipt display follows the shared save/read path. Keep this to one learner and one convincing two-call demonstration. Basic credential/learner separation and honest failure reporting remain necessary, but complex auth, vector search, file storage, subscriptions, cron, analytics, migrations/refactors and generic backend abstractions are deferred.

**Acceptance for persistent memory:** (1) completed conversation persists useful learner signals, (2) subsequent conversation retrieves them, (3) at least one prior mistake/progress signal affects the next conversation, (4) behavior is proven end-to-end, and (5) InsForge’s role is clear in the hackathon explanation. Database rows alone do not prove criterion 3; both the retrieved signal and resulting conversational reference need genuine demo evidence.

**Human input:** InsForge project access supplied securely and a confirmed single demo learner identity. **Existing human check:** compare the real call with the saved receipt for fidelity/value; retain that review. This decision adds bounded learner-signal persistence, not permission to archive audio or expand into unrelated personal data.

## M5 — Hackathon-ready demo

**Done:** a two-call live demo proves voice, compelling coaching and memory continuity. Explain Higgs as the conversation layer and InsForge as the persistent learner-memory backend; retain honest setup/limits and final founder review.

| Task | Concise contract | Done evidence |
| --- | --- | --- |
| **M5.1 Demonstrate two live calls with InsForge learner-memory continuity** | Use the existing two runs as a connected story: call one captures/saves signals, then call two retrieves and uses at least one. Reuse prior mic/auth/disconnect checks. | Genuine voice/coaching + saved/retrieved signal + resulting call-two reference, with revision/device/topic/date. Fix failures on this path before polish; do not substitute seeded memory. |
| **M5.2 Explain Higgs voice, InsForge memory, minimum setup and known limits** | Short setup instructions, secret-free configuration names and a plain explanation of the two provider roles. No repo restructuring or architecture essay. | Explain Higgs speaking/listening/interruption/coaching and InsForge `sessions`/`learning_memory` save/read continuity; distinguish reused code, mocks, verified behavior and limitations. |
| **M5.3 Check supplied rules and present final human review** | Map actual demo evidence to official requirements once the founder supplies them. Do not invent criteria or publish automatically. | Founder sees the demo, limitations and supplied rubric/deadline checks. Missing event information remains an input for submission, not a reason to stop demo work. |

**Human input/gate:** official event page/deadline/rules and final demo/submission review. Publishing or submission is a separate later action; this plan grants neither.

## Explicitly deferred across M0–M5

- Production architecture, generic abstractions, refactors, provider frameworks and infrastructure not required for the demo.
- Visual polish, animation, expanded onboarding, extra screens and broad device/language/edge-case matrices.
- Automated topic discovery/ranking, live topic tools, personalization beyond the minimal learner signals, and multi-day/calendar/missed-call behavior. Use one curated packet and manual demo reset.
- Social graph, sender/receiver/friend-roast, App Clip, sharing, background calls, APNs/PushKit/CallKit and callback scheduling.
- Receipt search, extra offline/cloud synchronization systems, analytics, raw audio retention and unrelated data pipelines. InsForge learner persistence and the shared saved-session receipt are required, not deferred.
- Complex auth/account management, vector search, file storage, realtime subscriptions, cron jobs, analytics infrastructure and broad backend migrations/refactoring. None is required for this bounded two-call demo; do not add them speculatively.

Do not defer the real Higgs conversation, Nobody interaction, basic safe session ending, actual learning evidence, InsForge save/retrieve/influence on call two, receipt reopening or visible demo proof. If the hard limit is reached with essential work incomplete, report the precise missing demo step; never claim it works from mocks or source alone.

## Dashboard hierarchy and status discipline

**Milestone → concise milestone tasks → one current task → detailed AI TODOs / human checks.** The Snapshot holds M0 tasks and future M1–M5 task contracts, with stable IDs and affected journey steps. Only M0.1 carries implementation-level detail. Selecting a future milestone browses scope; it does not start it or copy the current task's TODOs. Future detail is written only when that task becomes current.

The hard-timebox text and voice → coaching → InsForge memory → polish priority are saved in the project-level constraint and stay visible across milestone views. It must not be added to blockers. All 18 app task contracts remain pending, M0 remains not reached, and the journey remains explicitly planned. Existing founder-confirmed native iOS/in-app scope and pending access/review checks are preserved.

The full original 9,793-character product request remains in `docs/original-request.md`; the InsForge product decision and prior planning corrections are retained separately in dashboard feedback. No prior intent or human acceptance is overwritten. No app build, provider call or new human acceptance was claimed by this planning update.
