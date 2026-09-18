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

## M0 visual/session foundation and M1 static journey

Implemented and simulator-verified 18:59 UTC (~16 minutes elapsed). Theme and mascot PNG match pinned donor bytes; controls adapt accessibility identifiers only. `CallSession` owns one guarded mock lifecycle; no donor runtime, LiveKit, social routes or backend was imported. The eventual live adapter is not implemented at this checkpoint.

Build passed with the same Xcode command/destination/cache. Fixed XcodeGen's default AppIcon expectation by leaving the app-icon setting empty; icon polish is deferred. Focused executable checks passed: accept guard, duplicate accept, decline, no fabricated signal on empty call, no improvement before retry, mock receipt excluded from saved learner history, cleanup. Command: `swiftc -module-cache-path /tmp/RoastedSwiftCache Roasted/CallSession.swift Tests/CallSessionChecks.swift -o /tmp/roasted-session-checks && /tmp/roasted-session-checks`.

Manually exercised simulator Home → incoming → decline → Home → incoming → accept → mute → sample opinion/roast → retry → Thai code-switch → end → sample receipt → Home. Screens visually inspected: `docs/evidence/m1-home.png`, `m1-incoming.png`, `m1-coaching.png`, `m1-receipt.png`. Receipt lower fields and return action confirmed through accessibility; full small-device visual fit remains unverified. All conversation/learning content here is labeled mock, never live evidence.

Topic source was read on 2026-09-18: Apple Newsroom's September 9 iPhone 18 Pro announcement, availability September 18. The upgrade-culture question is editorial framing, not a sourced claim about public opinion.

**Existing human gate:** static journey/tone review before M2 is pending. No live provider calls, real microphone capture, InsForge writes, signed iPhone install or new human acceptance has occurred.

## Roast quality correction — 19:07 UTC

Founder supplied the Roast Quality Contract, preserved in `docs/roast-quality-contract.md`. Roast quality is P0: entertain first; approximately 70% roast/culture, 20% reactive back-and-forth, 10% explicit correction. Updated the sample interaction to use a specific upgrade callback and tease the act of switching into Thai. Added `server/prompt.mjs` with bounded, untrusted topic/memory context and actual-evidence tool instructions; no live backend is wired at this checkpoint.

Revised app build passed; installed/relaunched in the same simulator. Prompt Node syntax and focused call-state checks passed. Provider configuration presence was checked without exposing values: all five required fields are populated. Credentials have not yet been tested. CoreDevice reports the paired iPhone 14 Pro as unavailable, so no physical-device proof. Static/M2 usage confirmation remains pending; adding keys has not been recorded as acceptance.
