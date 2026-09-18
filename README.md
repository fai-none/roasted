# Roast

Native iOS hackathon demo. The app builds, runs the full labeled mock journey, connects to Higgs, and uses a secure local broker for InsForge receipts and learner memory. Native playback and synthetic persistence checks pass; the real two-call iPhone rehearsal and human quality review remain open. See [actual evidence](docs/implementation-evidence.md) and the [rehearsal steps](docs/demo-rehearsal.md).

Nobody calls a conversationally fluent non-native English speaker each day about one culturally relevant topic. It reacts to their opinion, roasts meaningful unnatural English, supplies a native alternative, invites a retry, and keeps talking like a friend. A post-call learning receipt retains useful examples.

Primary track: **Breaking the Language Barrier**. Secondary strength: **Most Human Conversation**. These track names are supplied by the founder; the event URL, deadline and official rubric still need confirmation.

[Roast quality is P0](docs/roast-quality-contract.md): entertain first, react specifically, use callbacks, keep corrections occasional and inside the joke. Working audio without convincing roast quality is not demo-ready.

## Start here

- `.baby-beluga/snapshot.md`: canonical dashboard state after Beluga export.
- [Reuse Map](docs/reuse-map.md): exact donor paths, revisions, reuse boundaries.
- [Execution brief](docs/execution-brief.md): M0–M5 task contracts, dependencies and proof.
- [First implementation task](implementation-plan/m0-foundation.md): clean app bootstrap.
- [Original request](docs/original-request.md): complete unabridged founder wording.

The donor is read-only. This repository is distinct from Nobody and Baby Beluga. Native iOS and English + Thai on iPhone 14 are founder-confirmed. The local repository is Roast, connected to [fai-none/roasted](https://github.com/fai-none/roasted). No remote history has been merged or pushed by implementation.

The founder approved **in-app incoming calls** for the hackathon MVP. Background/scheduled incoming calls are deferred. Official event deadlines and rules will be provided later.

## Run the app

Open `Roasted.xcodeproj`, choose the `Roasted` scheme and an installed iPhone simulator, then Run. No keys are required for the static mock journey. To regenerate the project after adding Swift files: `xcodegen generate`.

For iPhone 14, select your own development team in Xcode Signing & Capabilities and your connected device. Physical-device installation has not yet been verified. No donor signing identity is copied.

## Run the live demo backend

Fill the ignored `.env` from `.env.example`. Node 22 and Python 3 are sufficient; no npm packages are required. Provider keys stay on the Mac.

```sh
python3 scripts/setup-local-demo.py
node --env-file=.env server/init.mjs
node --env-file=.env server/index.mjs
```

Keep the last command running. It serves HTTPS on port 8787 with a seven-day local certificate and a required demo bearer token. The setup script keeps its private TLS key in ignored `.demo/`. The iPhone must be on a network that can reach this Mac. Nothing is publicly deployed.

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
xcodebuild test -project Roasted.xcodeproj -scheme Roasted -destination 'id=SIMULATOR_ID'
```

The Higgs smoke uses provider quota but no microphone or database writes. `server/verify-memory.mjs` performs an explicitly synthetic InsForge transaction test under a separate temporary learner and cleans it up. Neither proves real two-call learning. Actual observations and open gaps are in [implementation evidence](docs/implementation-evidence.md).

Canonical Snapshot v6 is preserved. Dashboard writes are blocked by the absent authenticated Baby Beluga connection in this task; current evidence is recorded locally. Mock UX, build, simulator, physical device, live provider and human acceptance remain separate proof levels.
