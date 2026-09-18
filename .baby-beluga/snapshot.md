# Roast Product Snapshot

```json
{
  "schemaVersion": "repo-snapshot.v2",
  "updatedAt": "2026-09-18",
  "product": {
    "id": "nobody-higgs-hackathon",
    "name": "Roast",
    "purpose": "Nobody calls daily: a savage friend helps fluent English speakers sound natural and culturally fluent through live Higgs conversations.",
    "screenFormat": "mobile"
  },
  "milestone": {
    "id": "m0-foundation",
    "title": "M0 — Foundation",
    "status": "not_reached",
    "definition": "Done when the independent app builds and launches, selected Nobody visuals render, and a mock/live Higgs session boundary works without friend, receiver or App Clip dependencies.",
    "tasks": [
      {
        "id": "m0-bootstrap",
        "title": "M0.1 — Bootstrap clean app; build and launch",
        "status": "pending",
        "journeyStepIds": [
          "home"
        ]
      },
      {
        "id": "m0-visuals",
        "title": "M0.2 — Port NobodyTheme, chicken avatar and call-control primitives",
        "status": "pending",
        "journeyStepIds": [
          "home",
          "incoming",
          "discussion"
        ]
      },
      {
        "id": "m0-session",
        "title": "M0.3 — Define one-call state, mock transport and Higgs boundary",
        "status": "pending",
        "journeyStepIds": [
          "incoming",
          "accept",
          "discussion",
          "end"
        ]
      }
    ]
  },
  "plannedMilestones": [
    {
      "id": "m1-static",
      "title": "M1 — Complete static product journey",
      "definition": "Done: mock Home → daily incoming → accept → conversation/coaching/retry → end → sample receipt; decline/error paths work. Human reviews the full UX before live voice."
    },
    {
      "id": "m2-realtime",
      "title": "M2 — Higgs realtime conversation",
      "definition": "Done: real speech-in/out, barge-in, recovery, turn-taking and repeated reliable sessions; graceful failures/end; selected daily-call mode verified. Device proof required for background delivery."
    },
    {
      "id": "m3-coaching",
      "title": "M3 — Nobody coaching intelligence",
      "definition": "Done: sourced topic, opinion-first reaction, grammar/unnatural-English detection, native alternatives, savage useful tone, retry and code-switching preserve the conversational thread."
    },
    {
      "id": "m4-receipt",
      "title": "M4 — Learning receipt",
      "definition": "Done: actual conversation examples reach a retained receipt: original phrase, native alternative, useful expression and cultural takeaway. Empty/partial calls never fabricate learning."
    },
    {
      "id": "m5-demo",
      "title": "M5 — Hackathon-ready product",
      "definition": "Done: repeatable live demo, failure sweep, clean setup/README, documented essential Higgs usage, honest limits and evidence against official judging criteria; human submission review."
    }
  ],
  "journey": [
    {
      "id": "home",
      "title": "Home / Nobody",
      "status": "pending",
      "summary": "Planned: open Nobody, see today’s call and return to completed learning receipts.",
      "laneId": "daily-call"
    },
    {
      "id": "topic",
      "title": "Today’s cultural topic",
      "status": "pending",
      "summary": "Planned: one dated, sourced topic gives the user a reason to talk today.",
      "laneId": "daily-call"
    },
    {
      "id": "incoming",
      "title": "Nobody calls",
      "status": "pending",
      "summary": "Planned: incoming daily-call state. Foreground versus scheduled/background delivery still requires a human decision.",
      "laneId": "daily-call"
    },
    {
      "id": "accept",
      "title": "User accepts",
      "status": "pending",
      "summary": "Planned: accept → microphone/session connection; decline returns Home; failures are visible and recoverable.",
      "laneId": "daily-call"
    },
    {
      "id": "discussion",
      "title": "Live topic discussion",
      "status": "pending",
      "summary": "Planned: Higgs speech-to-speech. Nobody introduces the topic and enough cultural context to join in intelligently.",
      "laneId": "daily-call"
    },
    {
      "id": "opinion",
      "title": "Opinion → Nobody reacts",
      "status": "pending",
      "summary": "Planned: the user responds naturally; Nobody reacts to the substance. Hesitation, interruption and changing one’s mind are supported.",
      "laneId": "daily-call"
    },
    {
      "id": "correction",
      "title": "Roast + native alternative",
      "status": "pending",
      "summary": "Planned: notice meaningful grammar, phrasing, word-choice or cultural-context gaps; give a savage useful correction and natural expression.",
      "laneId": "daily-call"
    },
    {
      "id": "retry",
      "title": "Retry → conversation continues",
      "status": "pending",
      "summary": "Planned: the user retries their thought, can code-switch when stuck, and returns to the same discussion instead of a classroom lesson.",
      "laneId": "daily-call"
    },
    {
      "id": "end",
      "title": "Call ends",
      "status": "pending",
      "summary": "Planned: user or Nobody ends once; release audio/session resources. Failure or empty input never invents learned content.",
      "laneId": "daily-call"
    },
    {
      "id": "receipt",
      "title": "What gave you away",
      "status": "pending",
      "summary": "Planned learning receipt: actual original phrase → native phrasing, useful expression and today’s cultural takeaway; retain it after the call.",
      "laneId": "daily-call"
    }
  ],
  "currentTask": {
    "id": "current-m0-bootstrap",
    "milestoneTaskId": "m0-bootstrap",
    "title": "M0.1 — Bootstrap clean app; build and launch",
    "status": "pending",
    "journeyStepIds": [
      "home"
    ],
    "implementationPlanPath": "implementation-plan/m0-foundation.md",
    "humanWants": "Next implementation session: create an independent native iOS app using only Nobody’s minimal SwiftUI target/root patterns. Native iOS is confirmed by the founder. Keep the donor read-only. See the referenced brief for M0–M5 task contracts. No app implementation has started.",
    "originalHumanWants": "Goal: create a clean new hackathon app while selectively reusing proven Nobody implementation.\n\nExamples:\n\n- establish new repo/project\n- app builds and launches\n- port design system/assets needed for MVP\n- port/adapt reusable Nobody UI components\n- establish architecture for Higgs integration\n- remove dependency on irrelevant old product architecture\n\n- native ios is correct",
    "requests": [
      {
        "id": "clean-target",
        "text": "create a clean new hackathon app while selectively reusing proven Nobody implementation.",
        "aiTodoIds": [
          "m0-target",
          "m0-shell"
        ],
        "humanCheckIds": [],
        "journeyStepIds": [
          "home"
        ]
      },
      {
        "id": "exclude-old",
        "text": "remove dependency on irrelevant old product architecture",
        "aiTodoIds": [
          "m0-isolation"
        ],
        "humanCheckIds": [],
        "journeyStepIds": [
          "home"
        ]
      },
      {
        "id": "launch-app",
        "text": "app builds and launches",
        "aiTodoIds": [
          "m0-launch-proof"
        ],
        "humanCheckIds": [],
        "journeyStepIds": [
          "home"
        ]
      },
      {
        "id": "native-ios-confirmed",
        "text": "native ios is correct",
        "aiTodoIds": [
          "m0-target"
        ],
        "humanCheckIds": [],
        "journeyStepIds": [
          "home"
        ]
      }
    ],
    "aiTodo": [
      {
        "id": "m0-target",
        "label": "1. Adapt minimal project.yml target; own app identity; exclude App Clip and old backend. Done: target compiles.",
        "status": "pending",
        "journeyStepIds": [
          "home"
        ]
      },
      {
        "id": "m0-shell",
        "label": "2. After 1, adapt RootView/HomeView shell; omit People/receiver/AppEnvironment. Done: offline Home launch.",
        "status": "pending",
        "journeyStepIds": [
          "home"
        ]
      },
      {
        "id": "m0-isolation",
        "label": "3. After 2, audit target/dependencies; no donor secrets, social APIs or LiveKit. Done: isolated source audit.",
        "status": "pending",
        "journeyStepIds": [
          "home"
        ]
      },
      {
        "id": "m0-launch-proof",
        "label": "4. After 3, build and simulator-launch twice; save real Home evidence. Done: reproducible cold launch.",
        "status": "pending",
        "journeyStepIds": [
          "home"
        ]
      }
    ],
    "humanChecks": [
      {
        "id": "daily-delivery-choice",
        "label": "Before daily-call work: choose in-app demo or real scheduled/background incoming calls.",
        "status": "needs_review"
      },
      {
        "id": "higgs-access",
        "label": "Before M2: provide Higgs access securely and the demo language pair; confirm permitted live-test usage.",
        "status": "needs_review"
      },
      {
        "id": "event-details",
        "label": "Before M5: supply official hackathon URL/deadline; review the final demo against its rubric.",
        "status": "needs_review"
      }
    ]
  },
  "journeyFlow": {
    "lanes": [
      {
        "id": "daily-call",
        "label": "Planned MVP — one user, one Nobody call"
      }
    ],
    "connections": [
      {
        "id": "next-home",
        "fromStepId": "home",
        "toStepId": "topic",
        "label": "Open today’s topic"
      },
      {
        "id": "next-topic",
        "fromStepId": "topic",
        "toStepId": "incoming",
        "label": "Daily call becomes available"
      },
      {
        "id": "next-incoming",
        "fromStepId": "incoming",
        "toStepId": "accept",
        "label": "Accept incoming call"
      },
      {
        "id": "next-accept",
        "fromStepId": "accept",
        "toStepId": "discussion",
        "label": "Session connects"
      },
      {
        "id": "next-discussion",
        "fromStepId": "discussion",
        "toStepId": "opinion",
        "label": "Nobody asks for an opinion"
      },
      {
        "id": "next-opinion",
        "fromStepId": "opinion",
        "toStepId": "correction",
        "label": "Meaningful correction noticed"
      },
      {
        "id": "next-correction",
        "fromStepId": "correction",
        "toStepId": "retry",
        "label": "Try the natural expression"
      },
      {
        "id": "next-retry",
        "fromStepId": "retry",
        "toStepId": "end",
        "label": "When the conversation finishes"
      },
      {
        "id": "next-end",
        "fromStepId": "end",
        "toStepId": "receipt",
        "label": "Keep actual learning examples"
      },
      {
        "id": "normal-end",
        "fromStepId": "discussion",
        "toStepId": "end",
        "label": "User or Nobody ends; correction not required"
      },
      {
        "id": "continue-discussion",
        "fromStepId": "retry",
        "toStepId": "opinion",
        "label": "Keep discussing; correction is a loop"
      },
      {
        "id": "decline-call",
        "fromStepId": "accept",
        "toStepId": "home",
        "label": "Decline / return Home"
      },
      {
        "id": "natural-opinion",
        "fromStepId": "opinion",
        "toStepId": "discussion",
        "label": "Already natural: keep talking"
      },
      {
        "id": "call-failure",
        "fromStepId": "discussion",
        "toStepId": "end",
        "label": "Disconnect/error: graceful end"
      }
    ],
    "entryPaths": []
  },
  "taskHistory": [],
  "progress": {
    "summary": "Planning only · M0 next: clean app bootstrap. 0 app tasks complete. Future milestone task contracts and proof gates are in docs/execution-brief.md.",
    "blockers": [
      "Daily-call delivery mode needs a human choice before implementation; M0 bootstrap can proceed.",
      "Higgs access is unverified for M2; official event URL/deadline/rubric are needed before M5."
    ]
  },
  "references": [
    {
      "id": "reuse-map",
      "label": "Reuse: NobodyTheme + chicken. Adapt: call/chat/onboarding/receipt.",
      "kind": "document",
      "path": "docs/reuse-map.md"
    },
    {
      "id": "discard-map",
      "label": "Discard: sender/receiver, friend roast, App Clip, sharing, callback scheduling.",
      "kind": "document",
      "path": "docs/reuse-map.md"
    },
    {
      "id": "task-contracts",
      "label": "M0–M5 task contracts, donor paths, dependencies and done checks",
      "kind": "document",
      "path": "docs/execution-brief.md"
    }
  ]
}
```
