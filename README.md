# Roast

Native iOS hackathon demo in implementation. The clean app builds and launches in the simulator; live Higgs voice and InsForge persistence are not yet verified. See [actual evidence](docs/implementation-evidence.md).

Nobody calls a conversationally fluent non-native English speaker each day about one culturally relevant topic. It reacts to their opinion, roasts meaningful unnatural English, supplies a native alternative, invites a retry, and keeps talking like a friend. A post-call learning receipt retains useful examples.

Primary track: **Breaking the Language Barrier**. Secondary strength: **Most Human Conversation**. These track names are supplied by the founder; the event URL, deadline and official rubric still need confirmation.

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

Provider setup: fill the ignored `.env` from `.env.example`. Provider keys belong only in the local trusted backend, never in the iOS app, logs, source or dashboard. The app will use a short-lived Higgs credential. See the [verified documentation contract](docs/provider-contract.md).

Canonical Snapshot v6 is preserved. Dashboard writes are blocked by the absent authenticated Baby Beluga connection in this task; current evidence is recorded locally. Mock UX, build, simulator, physical device, live provider and human acceptance remain separate proof levels.
