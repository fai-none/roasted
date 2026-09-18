# Roast

Native iOS hackathon demo. The app builds, runs the full labeled mock journey, connects to Higgs, and uses a secure local broker for InsForge receipts and learner memory. Real iPhone conversation, correction/retry persistence in InsForge and founder-confirmed prompted recall in a second call are verified. Humor quality remains variable and final human quality review is open. [Submission copy and recording guide](docs/submission.md). See [actual evidence](docs/implementation-evidence.md) and the [rehearsal steps](docs/demo-rehearsal.md).

Nobody calls a conversationally fluent non-native English speaker each day about one culturally relevant topic. It reacts to their opinion, roasts meaningful unnatural English, supplies a native alternative, invites a retry, and keeps talking like a friend. A post-call learning receipt retains useful examples.

Primary track: **Breaking the Language Barrier**. Secondary strength: **Most Human Conversation**. These track names are supplied by the founder; the event URL, deadline and official rubric still need confirmation.

[Roast quality is P0](docs/roast-quality-contract.md): entertain first, react specifically, use callbacks, keep corrections occasional and inside the joke. Working audio without convincing roast quality is not demo-ready.

## Start here

- `.baby-beluga/snapshot.md`: canonical dashboard state after Beluga export.
- [Reuse Map](docs/reuse-map.md): exact donor paths, revisions, reuse boundaries.
- [Execution brief](docs/execution-brief.md): M0–M5 task contracts, dependencies and proof.
- [First implementation task](implementation-plan/m0-foundation.md): clean app bootstrap.
- [Original request](docs/original-request.md): complete unabridged founder wording.

The donor is read-only. This repository is distinct from Nobody and Baby Beluga. Native iOS and English + Thai on iPhone 14 are founder-confirmed. The local repository is Roast, connected to the founder-authorized public [fai-none/roasted](https://github.com/fai-none/roasted) repository; its working default branch is `codex/roasted-demo`.

The founder approved **in-app incoming calls** for the hackathon MVP. Background/scheduled incoming calls are deferred. Official event deadlines and rules will be provided later.

## Run the app

Open `Roasted.xcodeproj`, choose the `Roasted` scheme and an installed iPhone simulator, then Run. No keys are required for the static mock journey. To regenerate the project after adding Swift files: `xcodegen generate`.

For iPhone 14, sign into Xcode Apple Accounts, select your own development team in Signing & Capabilities and your connected device. Signed installation, real correction/retry persistence and founder-confirmed prompted recall succeeded on the founder's iPhone 14 Pro on September 18. No donor signing identity is copied.

## Run the live demo backend

Fill the ignored `.env` from `.env.example`. Node 22 and Python 3 are sufficient; no npm packages are required. Provider keys stay on the Mac.

```sh
python3 scripts/setup-local-demo.py
node --env-file=.env server/init.mjs
node --env-file=.env server/index.mjs
```

Keep the last command running. It serves HTTPS on port 8787 with a seven-day local certificate and a required demo bearer token. The setup script keeps its private TLS key in ignored `.demo/`. The iPhone must be on a network that can reach this Mac. Nothing is publicly deployed.

Guest Wi-Fi may prevent the phone from reaching the Mac. The founder's working recording setup uses the iPhone's Personal Hotspot with the Mac connected. The broker accepts IPv6 and IPv4 by default. If switching networks changes the Mac's address, update the ignored device URL and certificate SAN for that address, then provision the updated certificate with the launch helper below. The setup script does not automatically discover every IPv6 hotspot configuration. Keep certificate validation enabled.

After installing the app from Xcode, configure it once through a private launch environment:

```sh
xcrun devicectl list devices
python3 scripts/launch-demo.py device DEVICE_ID
```

For Simulator, use `python3 scripts/launch-demo.py simulator SIMULATOR_ID`. This provisions the demo access token into Keychain and a public TLS certificate for exact trust validation; no provider key is included. Unsigned simulator builds may require this launch command again on each cold launch. Allow microphone and local-network access when prompted.

Higgs receives 24 kHz microphone audio and generates speech, reactions and corrections. InsForge stores `sessions` and `learning_memory`; accepting another call reads fresh backend memory. A receipt uses the same saved session. Full transcripts are used transiently to validate selected quotes, then discarded by the backend; no audio is archived.

## Verification commands

```sh
node --test server/server.test.mjs
node --env-file=.env scripts/higgs-smoke.mjs
node --env-file=.env scripts/higgs-audio-smoke.mjs
node --env-file=.env server/rehearse-provider.mjs --memory-continuity
xcodebuild test -project Roasted.xcodeproj -scheme Roasted -destination 'id=SIMULATOR_ID'
```

The Higgs smokes use provider quota but no microphone or database writes. The audio smoke requires macOS `say`/`afconvert` and synthesizes its own test sentence. The provider rehearsal uses synthetic typed input; `--memory-continuity` saves under a separate temporary learner, retrieves it in a new call, and cleans it up. Without that flag it writes no database rows. `server/verify-memory.mjs` tests the InsForge transaction separately. These automated checks alone do not prove real two-call learning. The separate physical rehearsal confirmed a saved correction/retry and prompted recall; actual observations and open gaps are in [implementation evidence](docs/implementation-evidence.md).

To rehearse from an empty learner without deleting previous receipts, choose a new `DEMO_LEARNER_ID` in the ignored `.env` and restart the Mac broker. Keep the same ID across the two calls being demonstrated.

Canonical Snapshot v6 is preserved. Dashboard writes are blocked by the absent authenticated Baby Beluga connection in this task; current evidence is recorded locally. Mock UX, build, simulator, physical device, live provider and human acceptance remain separate proof levels.
