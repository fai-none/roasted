# Reuse Map

Inspected 2026-09-18. Source inspection proves candidate reuse, not that anything has been ported or tested in this new app.

## Exact donor bindings

The Codex project named **nobody-told-you-?** points to `/Users/fai/Documents/GitHub/nobody`, origin `https://github.com/fai-none/nobody.git`.

| Reference | Exact checkout | Inspected revision | Role |
| --- | --- | --- | --- |
| Connected root | `/Users/fai/Documents/GitHub/nobody` | `dfd2024e6196bc23fc1d4022638e89f2fc5eace6` | Older conversation-first app; does not contain branded theme/avatar |
| Main donor | `/Users/fai/Documents/GitHub/nobody/.codex-worktrees/main` | `6a7d682e0c658963814f3a7084fe0c2e57682e58` | Later native realtime contracts/culture handling; no branded chicken theme |
| Branded donor, **D** below | `/Users/fai/Documents/GitHub/nobody/.codex-worktrees/baby-beluga` | `8dad99224fb830c4059a5120416b0c32f89d6c72` (`codex/nobody-reference-ui`) | Preferred inspected UI source; contains real roasted-chicken artwork and native transport |

Each checkout has pre-existing local state. Never switch branches, clean, modify, build in, or commit in the donor. Read pinned source with `git show <revision>:<path>` if the checkout changes. Do not copy its `.env`, signing identities, backend URLs, app IDs or project history.

## Decisions

All paths below are relative to **D** unless otherwise stated.

| Existing implementation / evidence | Hackathon use | Decision / boundary |
| --- | --- | --- |
| `Nobody/Features/Shared/NobodyTheme.swift`: `NobodyTheme`, `NobodyActionStyle` | White/ink/pink visual tokens and accessible button styling | **Reuse** small SwiftUI primitives. This is a compact theme, not a large component library. |
| Same file: `NobodyAvatar`; `Nobody/Resources/Assets.xcassets/NobodyMascot.imageset/mascot.png` | Roasted chicken avatar | **Reuse unchanged** artwork and wrapper. Actual PNG visually inspected; preserve asset name and catalog metadata. |
| `Nobody/Features/Conversation/ConversationView.swift`: `ActiveCallView`; `Nobody/Features/Receiver/CallControlsView.swift` | Live call visual, mute/speaker/end controls | **Adapt** value/callback presentation; remove `CallOrchestrator`, friend/receiver and production diagnostic bindings. `CallControlsView` is reusable despite its Receiver folder. There is no inspected `CallView.swift`. |
| Same conversation file: private `MessageBubble`, message list/composer | Conversation/coaching visual states, optional transcript | **Adapt** small rendering pieces. Do not port the whole controller, scheduling actions or friend conversation endpoints. Separate chat product is not required for MVP. |
| `Nobody/Features/Home/HomeView.swift`, `Nobody/App/RootView.swift` | Home/Nobody and simple route shell | **Adapt** presentation only. Remove People picker, friend destinations, receiver recovery and global production environment. |
| `Nobody/Features/Onboarding/OnboardingView.swift`; `Nobody/Features/Onboarding/NobodyProfileController.swift` | Small first-run introduction/permission explanation if necessary | **Adapt selectively** branded presentation; do not import remote installation/profile provisioning, friend identity or all old questionnaire steps. Avoid onboarding expansion. |
| `Nobody/Domain/CallStateMachine.swift`, `Nobody/Domain/CallOrchestrator.swift`; `Nobody/Services/Realtime/RealtimeContracts.swift` | Session-scoped lifecycle and stale-event rejection | **Adapt patterns**, not the entire orchestration graph. Keep a single self-call session and a small mock/live boundary; remove `CallMode.roast`, personalization memory and sender identity. |
| `Nobody/Services/Realtime/NativeWebRTCRealtimeTransport.swift` | Reference for permissions, cancellation, session cleanup and output draining | **Replace transport** for Higgs WebSocket. Donor uses LiveKitWebRTC/OpenAI-specific session/SDP/data-channel behavior; provider compatibility does not prove wire/audio compatibility. |
| `Nobody/Services/Realtime/RealtimeProviderEventReducer.swift`; `NobodyTests/Services/RealtimeProviderEventReducerTests.swift` | Finish-once, late event and goodbye/audio-drain behavior | **Adapt and test** only applicable invariants against Higgs events. Remove `finish_friend_call`, `finish_roast`, proprietary artifact/receipt envelopes and memory candidates. |
| `server/src/nobody-prompt.js`: personality/learning/culture instructions | Savage but useful friend, natural phrasing and topic context | **Adapt** inspected wording and bounded untrusted-context separation. Add opinion-first response, explicit retry and code-switch recovery; remove friend/sender modes and relationship memory. Existing prompt is not proof of new coaching quality. |
| `server/src/culture-topics.js`; `server/src/topic-suggestions.js` | Dated source-backed topic packet, context/hooks/expressions | **Adapt** validation/provenance and bounds. Existing seven-day eligibility and recommendation ranking do not implement one topic per day; add date/timezone selection and honest unavailable fallback. Do not copy the social-personalization store. |
| `server/src/openai.js`: finish schemas (`phrase`, `naturalAlternative`, `culturalReference`, `takeaway`); `Nobody/Services/Realtime/RealtimeProviderEventReducer.swift`; conversation message bubble | Learning receipt | **Adapt schema ideas; build missing display/data path.** Swift reduces accepted finish data to summary/memory candidates. No existing complete structured learning-receipt screen was found. Keep actual utterance provenance, not fabricated examples. |
| `Nobody/Features/People/`, `Features/Receiver/`, sender/friend routes in `HomeView` and `App/RootView.swift`; `server/src/friend-roast.js`, `receiver-service.js`, `social-service.js`, `receiver-page.js` | None | **Discard** sender/receiver, friend-roast, sharing/invite links, receiver consent/recovery and social graph. Basic microphone permission remains necessary; it is not the old receiver consent flow. |
| `project.yml` App Clip/associated-domain targets, App Clip entry routing | None | **Discard** App Clip, associated-domain/share-link infrastructure and old bundle/signing configuration. Reuse only a minimal build-target pattern. |
| `server/src/scheduler.js`, `schedule-service.js`, `scheduling.js`; client callback actions | None from old product | **Discard old callback scheduling.** New daily self-call delivery is a separate pending product choice; genuine background delivery would need its own bounded scheduling/device proof. Do not silently claim an in-app trigger fulfills it. |

## Higgs boundary

[Official realtime overview](https://docs.boson.ai/models/higgs-realtime/overview), checked 2026-09-18, documents full-duplex audio over WebSocket and says WebRTC support is in progress. It also documents turn detection, tool calls, input transcription and short-lived client secrets. This makes the donor transport a behavioral reference rather than a drop-in implementation. Do not import LiveKitWebRTC merely because Nobody has it. Verify the current audio format, events and mobile authentication contract in M0/M2 before committing to the adapter. No provider call or credential verification was performed in this planning run.
