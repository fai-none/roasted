# M0.1 — Bootstrap a clean launchable app

Status: **pending**. Planning only; do not implement until the founder starts implementation.

## Bounded task

Create the smallest clean native iOS app target in this repository, with its own identity and a single Home placeholder. Native iOS is the planning assumption based on the inspected SwiftUI donor. Do not clone the donor product or copy its project wholesale.

## Read first

- `docs/original-request.md`, `docs/reuse-map.md`, `docs/execution-brief.md`, `.baby-beluga/snapshot.md`.
- Donor D from the Reuse Map: `project.yml`, `Nobody/App/RootView.swift`, `Nobody/Features/Home/HomeView.swift`, `Nobody/Features/Shared/NobodyTheme.swift`.
- Beluga implementation agents must resolve the exact registered project/repository, read saved and pending state and write factual task-start evidence before code. This planning run installed no project MCP configuration or authorization.

## AI TODO contracts

1. **m0-target** — Create one app target using only the donor's minimal SwiftUI/XcodeGen target pattern. Adapt names/build settings to the new repo; exclude App Clip, PushKit/CallKit background plumbing, friend/receiver targets, associated domains, production URLs and signing data. Dependency: none beyond the planning repository. Done: generated/checked-in project has exactly the intended app target and can compile without donor files or credentials.
2. **m0-shell** — Create a small app root and Home placeholder with an explicit dependency entry point. Read `RootView`/`HomeView` for structure; do not port `AppEnvironment`, People, receiver recovery, remote profile provisioning or the whole conversation controller. Depends on m0-target. Done: cold launch reaches Home with no network and no old routes.
3. **m0-isolation** — Inspect target membership and dependencies for accidental donor inheritance. No old bundle IDs, secrets, social APIs, App Clip, friend-roast or LiveKit dependency without a new justification. Depends on m0-shell. Done: source/dependency audit reports exact inspected files and any residual coupling is removed.
4. **m0-launch-proof** — Build the new target and launch it in a simulator; document the exact command, simulator and result. Depends on m0-isolation. Done: visible Home, successful repeat cold launch and a real screenshot saved with provenance. This does not prove microphone, live Higgs, physical-device or background-call behavior.

Do not bundle M0.2 visual port or M0.3 session architecture into this task unless the dashboard is explicitly advanced after verification. Keep changes small, preserve donor bytes, and report only observed evidence. No dependency additions unless necessary for the actual next step.
