We are starting a new hackathon project based on our existing Nobody product.

Your task is to update the Baby Beluga dashboard so it becomes the execution control plane for this hackathon.

Do **not** implement the new app yet.

## 1. First inspect the existing code

Before changing the dashboard:

1. Inspect the current Baby Beluga repo and understand how projects, milestones, user journeys, current tasks, AI TODOs, Human TODOs, progress, blockers, and repo references are represented.
2. Inspect the existing **nobody-told-you-? repo** as read-only reference material.
3. Identify what from Nobody can realistically be reused in the new hackathon project.

Pay particular attention to:

- design system
- roasted chicken / Nobody avatar and other assets
- call UI
- chat UI
- onboarding
- navigation
- state management
- realtime/audio infrastructure
- post-call/completion UI
- reusable services/components

Also identify old product architecture that should **not** be carried over, including where applicable:

- sender/receiver architecture
- roast-a-friend flow
- App Clip
- sharing
- callback scheduling
- receiver consent flow
- other functionality irrelevant to the new product

Do not assume something is reusable just because it exists. Inspect the actual implementation.

---

# Hackathon Product

## Target user

A non-native English speaker who is already conversationally fluent but wants to:

- sound native and natural
- speak grammatically correctly
- understand current cultural references and conversations
- become culturally relevant rather than merely textbook-fluent

## Core product concept

**Nobody calls the user every day.**

Each call revolves around one culturally relevant topic for that day.

Nobody behaves like a savage but useful friend rather than a traditional English tutor.

During the conversation:

1. Nobody introduces today's culturally relevant topic.
2. Nobody gives the user enough context to participate intelligently.
3. Nobody asks for the user's opinion.
4. The user responds naturally.
5. Nobody reacts to the substance of their opinion.
6. Nobody notices English that makes the user sound non-native:
   - grammatical errors
   - unnatural phrasing
   - overly formal/textbook English
   - poor word choice
   - missing cultural context
7. Nobody roasts the mistake while explaining the better native expression.
8. The user gets another opportunity to say the thought naturally.
9. Conversation continues rather than turning into a lesson.

The user should be able to:

- interrupt Nobody naturally
- change their mind mid-sentence
- hesitate
- speak imperfectly
- code-switch into another language when stuck

Nobody should understand and continue the conversation naturally.

## Higgs Realtime

This is being built for a Higgs Realtime hackathon.

The experience should deliberately demonstrate capabilities such as:

- realtime speech-to-speech
- natural interruptions
- fast turn-taking
- interruption recovery
- multilingual speech
- mid-sentence code-switching
- potentially realtime tool calling for fetching/contextualizing today's topic

Higgs must feel essential to the experience rather than being used as generic TTS.

Primary hackathon track:

**Breaking the Language Barrier**

Secondary strength:

**Most Human Conversation**

---

# Target user journey

Represent the actual end-to-end product journey visually in the Baby Beluga dashboard.

The intended MVP journey is:

Home / Nobody
↓
Today's culturally relevant topic
↓
Nobody calls user
↓
User accepts
↓
Live realtime conversation
↓
Nobody discusses topic
↓
User gives opinion
↓
Nobody reacts
↓
Nobody detects unnatural / incorrect English
↓
Savage correction + natural/native alternative
↓
User retries the thought
↓
Conversation continues
↓
Call ends
↓
Post-call learning receipt

The receipt should summarize things such as:

- **What gave you away**
- original phrase
- more native phrasing
- useful expression learned
- cultural takeaway from today's topic

Do not add old sender/receiver flows to this user journey.

Keep the journey understandable at a glance.

---

# Execution milestones

Break the project into implementation milestones small enough that each milestone can be completed and verified independently.

Use the existing Beluga milestone/task conventions.

The approximate decomposition should be:

## M0 — Foundation

Goal: create a clean new hackathon app while selectively reusing proven Nobody implementation.

Examples:

- establish new repo/project
- app builds and launches
- port design system/assets needed for MVP
- port/adapt reusable Nobody UI components
- establish architecture for Higgs integration
- remove dependency on irrelevant old product architecture

## M1 — Complete static product journey

Goal: the entire product can be experienced end-to-end using mocked realtime data.

Must include:

- Home
- incoming/daily call state
- active call UI
- conversation/coaching states
- end call
- learning receipt

This milestone should prove the UX before realtime complexity is introduced.

## M2 — Higgs realtime conversation

Goal: replace mocked conversation with working realtime voice.

Must verify:

- speech in → speech out
- interruption
- recovery after interruption
- natural turn-taking
- call lifecycle
- session reliability
- graceful failure/end states

## M3 — Nobody coaching intelligence

Goal: make the realtime conversation deliver the actual product value.

Must support:

- culturally relevant topic context
- user opinion/discussion
- grammar detection
- unnatural English detection
- more native alternatives
- savage Nobody personality
- retry behavior
- code-switching
- maintaining the conversational thread rather than behaving like a classroom tutor

## M4 — Learning receipt

Goal: convert the live conversation into something the user can retain.

Must capture useful examples from the actual conversation and show them after the call.

## M5 — Hackathon-ready product

Goal: reliable finished demo/submission.

Include:

- demo-quality topic
- end-to-end verification
- reliability/error states
- clean repo structure
- setup instructions
- README
- Higgs usage clearly documented
- honest unfinished notes
- verification against hackathon judging criteria

Adjust these milestones if repo inspection reveals a better decomposition.

The dashboard should reflect reality rather than blindly copying this list.

---

# AI TODO requirements

This is especially important.

AI TODOs must be grounded in what you discover in the existing Nobody repo.

Do not write generic tasks such as:

> Build call screen.

Instead, where applicable, produce implementation-aware tasks such as:

> Reuse/adapt the existing Nobody CallView, remove receiver-specific state, preserve its visual system, and connect its call lifecycle to the new Higgs realtime session.

Each AI task should make clear:

- what needs to be accomplished
- what existing implementation can be reused
- what must be adapted
- what should not be inherited
- dependencies
- verification/definition of done

Tasks should be small enough that Codex can execute them individually without needing the human to repeatedly explain the product.

---

# Reuse Map

Add a compact project-level **Reuse Map** or equivalent dashboard representation.

It should be based on actual repo inspection.

Example structure:

| Existing Nobody    | Hackathon project | Decision        |
| ------------------ | ----------------- | --------------- |
| Design system      | New app           | Reuse           |
| Chicken avatar     | New app           | Reuse unchanged |
| Call UI            | New app           | Adapt           |
| Chat UI            | New app           | Reuse/adapt     |
| Post-call UI       | Learning receipt  | Adapt           |
| Audio/session code | Higgs realtime    | Inspect first   |
| Sender flow        | —                 | Discard         |
| Receiver flow      | —                 | Discard         |
| App Clip           | —                 | Discard         |
| Friend roast       | —                 | Discard         |

Do not fabricate mappings. Use real implementation evidence.

---

# Dashboard outcome

When complete, I should be able to open Baby Beluga and immediately understand:

1. **What are we building?**
2. **What is the complete user journey?**
3. **What must be finished for the hackathon?**
4. **What milestone are we currently on?**
5. **What tasks are left?**
6. **Which tasks can AI execute now?**
7. **Which tasks require human input or verification?**
8. **What are we reusing from the old Nobody repo?**
9. **What are we intentionally not carrying over?**
10. **What counts as done for each milestone?**
11. **What repo/files should the implementation agent look at?**

Preserve Baby Beluga's existing visual language and interaction model. Do not turn this into a dense project-management dashboard.

The result should remain minimal and scannable.

---

# Important constraints

- Do not modify the existing Nobody repo.
- Treat Nobody as a read-only donor/reference repo.
- Do not implement the new hackathon app as part of this task.
- Do not carry over features simply because they already exist.
- Do not invent reuse opportunities without inspecting the code.
- Do not make the milestone plan unnecessarily granular.
- Do make implementation tasks granular enough to execute and verify independently.
- Prioritize a finished working hackathon product over production-scale architecture.
- The hackathon deadline means scope discipline is critical.

After updating the dashboard, report back with only:

1. what you inspected
2. the reuse decisions you made
3. the milestone structure you created
4. the current first implementation task
5. any blocker that genuinely requires human input
