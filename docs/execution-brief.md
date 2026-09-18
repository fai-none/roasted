# Hackathon execution brief

> Hard timebox: 3 hours. Optimize for the shortest path to a reliable end-to-end demo. Defer polish, architecture work, refactors, abstractions, edge cases, and non-demo functionality unless they directly unblock the demo.

This constraint applies across **M0–M5**, including verification and rehearsal. It is an execution/prioritization constraint, not a blocker or a claim that implementation has started. This update changes planning only. All app tasks remain pending; **M0.1 is the current task for the next implementation session**.

Scope sources: [original request](original-request.md), [Nobody reuse analysis](reuse-map.md), and the existing product journey. D below means the exact branded donor checkout/revision pinned in the reuse analysis. The donor stays read-only.

## Demo scope and execution order

For conversationally fluent non-native English speakers, Nobody is a savage but useful friend: one daily culture conversation, an opinion-first reaction, a meaningful correction with a native alternative, a retry, and continuation of the same discussion. The call ends with **What gave you away**: the actual original phrase, native phrasing, useful expression and cultural takeaway, retained for later access from Home.

Native iOS and **in-app incoming calls** are founder-confirmed. Higgs is the real speech-to-speech engine, not just TTS. Preserve natural turn-taking, interruption, hesitation, changing one's mind and the intended demo language pair's code-switching. Prove those in one short conversation, not a broad language or device matrix. A curated, dated, source-backed topic and a manual demo reset are sufficient; do not build a topic service or scheduler.

Home/Nobody → today's topic → Nobody calls → accept → live discussion/context → opinion and substantive reaction → roast plus native alternative → retry → continue → end → retained learning receipt. Decline returns Home. Basic microphone/connection failure must be visible and end safely. Mock examples must never appear as actual live learning.

| Milestone | Working budget | Required observable outcome |
| --- | ---: | --- |
| M0 — Foundation | 20 min | Independent app launches with reused Nobody identity and one small mock/live session boundary |
| M1 — Static journey | 20 min | Founder can walk through the complete mocked demo and review the interaction |
| M2 — Higgs realtime | 60 min | Real microphone input and speech output, interruption and clean session end on demo hardware |
| M3 — Nobody coaching | 35 min | One sourced discussion demonstrates opinion → useful roast/correction → retry → continuation |
| M4 — Learning receipt | 25 min | Actual call examples appear in a receipt that survives relaunch |
| M5 — Demo evidence | 20 min | Repeatable live walkthrough, concise setup/evidence and final human review |
| **Total** | **180 min** | **Reliable end-to-end demo** |

Budgets are prioritization targets, not guarantees or new acceptance gates. Within the hard limit, move time toward Higgs and the core coaching/receipt path. If a step overruns, cut deferred work first; do not relabel mock audio or sample receipts as live. Check the documented Higgs audio/auth/events contract early in M0.3, then reach live audio in M2 before spending time on prompt tuning or polish. Keep existing human reviews brief and show the concrete result; never infer acceptance from silence. Required founder access/language inputs should be ready for M2.

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
| **M3.2 Adapt Nobody's opinion-first roast, correction and retry** | Reuse `nobody-prompt.js` personality/learning wording; remove friend/sender modes and memory. React to meaning before correcting; retain the user's point. | Live opinion → substantive reaction → useful native alternative → user retry → conversation continuation. Natural English is not needlessly corrected. |
| **M3.3 Verify tone and one code-switch/hesitation recovery** | Use the same demo conversation and language pair, not a separate evaluation system. | One mid-sentence native-language word or hesitation preserves meaning/topic; target user reviews usefulness and tone. |

All three tasks demonstrate the differentiator. Defer multilingual matrices, a prompt/evaluation framework, topic tools, broad correction categories and personalization. **Human check:** useful, savage friend rather than a derailing lecture; automation cannot declare that accepted.

## M4 — Learning receipt from the real call

**Done:** actual call evidence supplies the original phrase, native alternative, useful expression and cultural takeaway in a retained receipt; no sample content is silently substituted.

| Task | Concise contract | Done evidence |
| --- | --- | --- |
| **M4.1 Capture actual phrases and selected learning fields** | Adapt donor finish-schema ideas to the available Higgs events; keep the minimum utterance-to-correction link. No raw audio archive, memory pipeline or generic event system. | A displayed original phrase can be matched to real input; end produces learning at most once; empty/failed input cannot fabricate fields. |
| **M4.2 Display and locally retain the real receipt** | Replace M1 fixtures with captured fields; use the smallest local storage and Home access sufficient to reopen the completed receipt. | Compare one call against the receipt, relaunch and reopen it; missing fields stay honest. |

Both tasks are essential product evidence. Defer search, sync, analytics, history management and broad malformed-event testing. **Human check:** review the real call/receipt pair for fidelity and value. Keep retention to the already planned local learning fields; any additional sensitive retention needs an explicit decision. Raw audio retention stays out of scope.

## M5 — Hackathon-ready demo

**Done:** the full live path repeats on the demo device, setup and Higgs's role are documented honestly, and the founder has the evidence needed for final submission review.

| Task | Concise contract | Done evidence |
| --- | --- | --- |
| **M5.1 Rehearse twice and capture the complete live demo** | Run the M0–M4 happy path with one sourced topic. Reuse earlier mic/auth/disconnect checks rather than a fresh broad failure sweep. | Two complete runs through coaching/retry and retained receipt; genuine recording/screens plus revision/device/topic/date. Fix only failures that threaten this path. |
| **M5.2 Write minimum setup, Higgs usage and known limits** | Keep a short README with actual launch/configuration steps and secret-free examples; no repo restructuring or architecture essay. | Reproduce launch using the written steps; clearly distinguish reused Nobody code, mock preview, actual Higgs behavior and unproved cases. |
| **M5.3 Check supplied rules and present final human review** | Map actual demo evidence to official requirements once the founder supplies them. Do not invent criteria or publish automatically. | Founder sees the demo, limitations and supplied rubric/deadline checks. Missing event information remains an input for submission, not a reason to stop demo work. |

**Human input/gate:** official event page/deadline/rules and final demo/submission review. Publishing or submission is a separate later action; this plan grants neither.

## Explicitly deferred across M0–M5

- Production architecture, generic abstractions, refactors, provider frameworks and infrastructure not required for the demo.
- Visual polish, animation, expanded onboarding, extra screens and broad device/language/edge-case matrices.
- Automated topic discovery/ranking, live topic tools, personalization and multi-day/calendar/missed-call behavior. Use one curated packet and manual demo reset.
- Social graph, sender/receiver/friend-roast, App Clip, sharing, background calls, APNs/PushKit/CallKit and callback scheduling.
- Receipt search/cloud sync/analytics, raw audio retention and unrelated data pipelines.

Do not defer the real Higgs conversation, Nobody interaction, basic safe session ending, actual learning evidence, local receipt reopening or visible demo proof. If the hard limit is reached with essential work incomplete, report the precise missing demo step; never claim it works from mocks or source alone.

## Dashboard hierarchy and status discipline

**Milestone → concise milestone tasks → one current task → detailed AI TODOs / human checks.** The Snapshot holds M0 tasks and future M1–M5 task contracts, with stable IDs and affected journey steps. Only M0.1 carries implementation-level detail. Selecting a future milestone browses scope; it does not start it or copy the current task's TODOs. Future detail is written only when that task becomes current.

The exact hard-timebox text is saved in the project-level constraint and stays visible across milestone views. It must not be added to blockers. All 17 app task contracts remain pending, M0 remains not reached, and the journey remains explicitly planned. Existing founder-confirmed native iOS/in-app scope and pending access/review checks are preserved.

The full original 9,793-character product request remains in `docs/original-request.md`; this planning correction is retained separately in dashboard feedback. No prior intent or human acceptance is overwritten. No app build, provider call or new human acceptance was claimed by this planning update.
