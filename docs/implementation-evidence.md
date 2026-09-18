# Roasted implementation evidence

Started 2026-09-18 18:43 UTC (11:43 America/Los_Angeles). Hard stop: 21:43 UTC (14:43 local), including verification/rehearsal.

Repository: `/Users/fai/Documents/GitHub/Roast`; origin `https://github.com/fai-none/roasted.git`; baseline `7585adf`; implementation branch `codex/roasted-demo`. Existing untracked `.agents/`, `.claude/`, `AGENTS.md`, `CLAUDE.md` are preserved.

## M0.1 — build and simulator proof

Started: create one independent SwiftUI target and offline Home, then build/cold-launch and inspect a screenshot. No provider keys or donor dependencies. Canonical dashboard verification is being investigated; no dashboard mutation has been made.

Passed at 18:50 UTC: `xcodegen generate`; `xcodebuild -project Roasted.xcodeproj -scheme Roasted -configuration Debug -destination id=DB91726F-277C-4CFB-9577-E17D0E0B1726 -derivedDataPath /tmp/RoastedDerivedData CODE_SIGNING_ALLOWED=NO build`. Exactly one app target, no dependencies. Installed on iPhone 17 Pro / iOS 26.3, launched, then repeated with `simctl launch --terminate-running-process`; visually inspected Home with “Roasted / Your English. Well done.” Screenshot: `docs/evidence/m0-bootstrap.png`. Initial simulator cold boot took several minutes. This does not prove iPhone 14, microphone or provider behavior.

Exact read-only donor: `/Users/fai/Documents/GitHub/nobody/.codex-worktrees/baby-beluga`, revision `8dad99224fb830c4059a5120416b0c32f89d6c72`. Its pre-existing modified `.baby-beluga/snapshot.md` is untouched. Read pinned project, root, Home, theme and controls source. Excluded all donor identity/signing/packages/remote environment and social routes.

Human inputs: English + Thai; iPhone 14. User requested an ignored `.env` to fill in. Live usage permission, provider access, static journey review, live tone/receipt/final acceptance remain unverified. No human check has been approved by implementation.

## Canonical dashboard check

Read-only durable database inspection confirmed Snapshot **v6**, `in_sync`, updated `2026-09-18T18:24:17.047Z`, with JSON equal to the repository snapshot. Project `project_b4dd4fad-2f3d-4f41-a13b-372e6ddcf89f`; active connection `repository_connection_45220f8a-626b-4dbe-a907-e7e349d35392`; root `/Users/fai/Documents/GitHub/Roast`. Latest proposal v5 was approved/exported; no newer pending proposal/progress. No authenticated task-local MCP connection is available, so dashboard writes remain blocked. This is binding verification, not authenticated MCP context proof. Canonical state is untouched; local progress awaits reconciliation through `get_dashboard_state_context` and supported progress/proposal tools.
