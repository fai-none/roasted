# Roasted — submission copy and recording guide

## Name and tagline

**Roasted** — Get roasted. Speak better English.

## Description

Roasted turns English practice into a voice call with Nobody, a sharp-tongued friend who challenges your opinions, catches your excuses, and sneaks corrections into the joke. Instead of a lesson, you get a conversation worth reacting to. Switch into Thai under pressure and Nobody nudges you back to English.

Higgs Realtime powers the live microphone-to-speech conversation, turn-taking, interruption, roasting and coaching. InsForge Postgres stores the completed call’s selected learning evidence in `sessions` and `learning_memory`. Each new call retrieves that learner’s memory, so Nobody can reference a real earlier mistake or improvement. The post-call receipt uses that same saved session.

Built as a native SwiftUI iPhone app with a minimal Node HTTPS broker. Provider keys stay on the Mac. Full transcripts and audio are not archived; only selected learning examples are retained.

## What the demo has actually proved

- Real iPhone microphone input, spoken Higgs replies and reactive conversation.
- Actual spoken correction: “spend time for” → “spend time ON”, followed by a successful “spend time on” retry.
- That correction and improvement persisted in InsForge, with memory linked to the same saved receipt.
- Founder-confirmed recall in a fresh second call **after asking** what improved. Spontaneous recall is not claimed.
- Signed iOS build and native automated checks, plus backend validation and isolated provider/persistence checks. Detailed evidence: `docs/implementation-evidence.md`.

Humor quality remains variable; the founder has reported improvement, not final acceptance against every roast-quality criterion.

## Record a short demo

Use the live app, not its labeled sample mode. Keep the Mac broker running and the app foreground.

1. **0:00–0:10 — Hook:** “English apps let you practice. Roasted gives you someone worth arguing with.” Show Home and accept Nobody’s call.
2. **0:10–0:45 — Conversation:** Answer the topic honestly. Give one real spoken mistake, such as “Humans can spend time for more important things.” Let Nobody finish, then retry the actual correction. A Thai reaction is optional.
3. **0:45–1:00 — Receipt:** End after the retry caption appears. Show “Saved in InsForge” and the exact original/correction/retry.
4. **1:00–1:25 — Memory:** Return Home and begin a new call. Ask “What did I improve last time?” without giving the target phrase first. Capture its actual callback.
5. **1:25–1:35 — Explain:** “Higgs makes the conversation possible. InsForge makes the next conversation remember. Same learner, new call, real saved progress.”

If a live step fails, retake it; do not edit sample output into purported live evidence. Before a full take, make a five-second recording and play it back to confirm both your microphone and Nobody’s audio are captured. Simulator video capture alone may omit audio.

## Run on this Mac

The broker is already configured and running for rehearsal. If stopped, from the repository root run:

```sh
node --env-file=.env server/index.mjs
```

Keep that process running. Open the installed Roasted app in Simulator. Its launch helper provisions the private local-demo connection:

```sh
python3 scripts/launch-demo.py simulator DB91726F-277C-4CFB-9577-E17D0E0B1726
```

Fresh-machine setup, signing and verification commands are in `README.md`. No key belongs in the public repository or recording.

## Scope and attribution

This is a foreground, manually triggered demo with one configured learner and a curated AI-agent discussion. It has no background scheduled calls, public hosted backend or account system. An awake Mac broker and provider credentials are required.

Reused Nobody visual primitives, mascot artwork, call-control presentation and personality patterns from the exact donor revision documented in `docs/reuse-map.md`. Higgs transport, InsForge persistence and the demo app are implemented here; unrelated social, receiver, App Clip and backend architecture were excluded.

Suggested tracks supplied by the founder: Breaking the Language Barrier; Most Human Conversation. Official submission fields/rules still need to be checked in the submission portal. This file is draft submission copy, not a submitted entry.
