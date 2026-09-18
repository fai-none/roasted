# Roast Product Snapshot

```json
{
  "schemaVersion": "repo-snapshot.v2",
  "updatedAt": "2026-09-18",
  "product": {
    "id": "nobody-higgs-hackathon",
    "name": "Roast",
    "purpose": "Daily English coaching: Higgs Realtime handles voice, interruption and roasting; InsForge Postgres retains learner signals so later calls build on mistakes and progress.",
    "executionConstraint": "Hard timebox: 3 hours. Optimize for the shortest path to a reliable end-to-end demo. Defer polish, architecture work, refactors, abstractions, edge cases, and non-demo functionality unless they directly unblock the demo. Priority: working voice → compelling roasting/coaching → InsForge memory end-to-end → demo polish. No broad backend cleanup.",
    "screenFormat": "mobile"
  },
  "milestone": {
    "id": "m0-foundation",
    "title": "M0 — Foundation",
    "status": "not_reached",
    "definition": "Done: independent app launches with reused Nobody theme/avatar, working mock accept/end and a minimal Higgs boundary. No friend, receiver, App Clip or old backend dependencies. Target: 15 of 180 minutes.",
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
        "title": "M0.2 — Reuse Nobody theme, avatar and call controls",
        "status": "pending",
        "journeyStepIds": [
          "home",
          "incoming",
          "discussion"
        ]
      },
      {
        "id": "m0-session",
        "title": "M0.3 — Connect one-call mock state to a minimal Higgs boundary",
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
      "definition": "Done: labeled mock Home/topic → incoming → coaching/retry → sample receipt; accept/decline/end work. Founder reviews the static journey before M2. Target: 15 of 180 minutes.",
      "tasks": [
        {
          "id": "m1-home",
          "title": "M1.1 — Show Home, curated topic and in-app accept/decline",
          "status": "pending",
          "journeyStepIds": [
            "home",
            "topic",
            "incoming",
            "accept"
          ]
        },
        {
          "id": "m1-conversation",
          "title": "M1.2 — Show the mock opinion, correction and retry loop",
          "status": "pending",
          "journeyStepIds": [
            "discussion",
            "opinion",
            "correction",
            "retry",
            "end"
          ]
        },
        {
          "id": "m1-receipt",
          "title": "M1.3 — End into a labeled sample receipt; review static journey",
          "status": "pending",
          "journeyStepIds": [
            "end",
            "receipt",
            "home"
          ]
        }
      ]
    },
    {
      "id": "m2-realtime",
      "title": "M2 — Higgs realtime conversation",
      "definition": "Done: real Higgs mic-in/speech-out on demo hardware, natural interruption, clean end and another in-app call. One reliable path; no recovery framework or calendar engine. Target: 60 of 180 minutes.",
      "tasks": [
        {
          "id": "m2-audio",
          "title": "M2.1 — Connect secure Higgs microphone input and speech output",
          "status": "pending",
          "journeyStepIds": [
            "accept",
            "discussion"
          ]
        },
        {
          "id": "m2-turns",
          "title": "M2.2 — Support interruption, clean end and another call",
          "status": "pending",
          "journeyStepIds": [
            "discussion",
            "opinion",
            "retry",
            "end"
          ]
        },
        {
          "id": "m2-incoming",
          "title": "M2.3 — Wire the in-app incoming call to the live session",
          "status": "pending",
          "journeyStepIds": [
            "home",
            "topic",
            "incoming",
            "accept",
            "end"
          ]
        }
      ]
    },
    {
      "id": "m3-coaching",
      "title": "M3 — Nobody coaching intelligence",
      "definition": "Done: one sourced live discussion reacts to opinion, roasts usefully, gives a native alternative, retries and continues; demonstrate code-switch/hesitation in the demo language pair. Target: 30 of 180 minutes.",
      "tasks": [
        {
          "id": "m3-topic",
          "title": "M3.1 — Prepare one dated, sourced cultural topic",
          "status": "pending",
          "journeyStepIds": [
            "topic",
            "discussion"
          ]
        },
        {
          "id": "m3-coaching-loop",
          "title": "M3.2 — Adapt Nobody’s opinion-first roast, correction and retry",
          "status": "pending",
          "journeyStepIds": [
            "opinion",
            "correction",
            "retry"
          ]
        },
        {
          "id": "m3-recovery",
          "title": "M3.3 — Verify tone and one code-switch/hesitation recovery",
          "status": "pending",
          "journeyStepIds": [
            "discussion",
            "opinion",
            "correction",
            "retry"
          ]
        }
      ]
    },
    {
      "id": "m4-receipt",
      "title": "M4 — Learning receipt",
      "definition": "Done: InsForge sessions + learning_memory persist real signals; a later Higgs call retrieves and uses at least one prior mistake/progress signal. Receipt reopens from saved session; demo proves both layers. Target: 45 of 180 minutes.",
      "tasks": [
        {
          "id": "m4-evidence",
          "title": "M4.1 — Capture actual phrases, learning signals and progress evidence",
          "status": "pending",
          "journeyStepIds": [
            "discussion",
            "correction",
            "retry",
            "end",
            "receipt"
          ]
        },
        {
          "id": "m4-insforge-memory",
          "title": "M4.2 — Persistent learner memory — InsForge",
          "status": "pending",
          "journeyStepIds": [
            "accept",
            "discussion",
            "opinion",
            "correction",
            "retry",
            "end",
            "receipt"
          ]
        },
        {
          "id": "m4-retain",
          "title": "M4.3 — Display and reopen the real receipt from the saved session",
          "status": "pending",
          "journeyStepIds": [
            "end",
            "receipt",
            "home"
          ]
        }
      ]
    },
    {
      "id": "m5-demo",
      "title": "M5 — Hackathon-ready product",
      "definition": "Done: a two-call live demo proves Higgs voice/coaching and InsForge save → retrieve → prior signal affects call two. Capture evidence, minimum setup and supplied-rule review. No automatic submission. Target: 15 of 180 minutes.",
      "tasks": [
        {
          "id": "m5-rehearsal",
          "title": "M5.1 — Demonstrate two live calls with InsForge learner-memory continuity",
          "status": "pending",
          "journeyStepIds": [
            "home",
            "topic",
            "incoming",
            "accept",
            "discussion",
            "opinion",
            "correction",
            "retry",
            "end",
            "receipt"
          ]
        },
        {
          "id": "m5-handoff",
          "title": "M5.2 — Explain Higgs voice, InsForge memory, minimum setup and known limits",
          "status": "pending",
          "journeyStepIds": [
            "home",
            "discussion",
            "receipt"
          ]
        },
        {
          "id": "m5-review",
          "title": "M5.3 — Check supplied rules and present final human review",
          "status": "pending",
          "journeyStepIds": [
            "discussion",
            "correction",
            "retry",
            "receipt"
          ]
        }
      ]
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
      "summary": "Planned: Nobody presents an incoming daily call while the app is open. The user accepts or declines. Scheduled/background calls are outside the hackathon MVP.",
      "laneId": "daily-call"
    },
    {
      "id": "accept",
      "title": "User accepts",
      "status": "pending",
      "summary": "Planned: accept → retrieve this learner’s prior state from InsForge → connect Higgs; decline returns Home. Missing memory is a first call, not invented history; failures stay visible.",
      "laneId": "daily-call"
    },
    {
      "id": "discussion",
      "title": "Live topic discussion",
      "status": "pending",
      "summary": "Planned: Higgs Realtime handles speech, listening and interruption. Roasted introduces today’s topic and can naturally use a prior mistake or progress signal retrieved from InsForge.",
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
      "summary": "Planned: give a useful roast and native alternative; identify grammar/vocabulary issues, cultural gaps, topics, actual mistake examples and evidence of improvement for learner memory.",
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
      "summary": "Planned: end the Higgs session safely; save actual session evidence and update learner signals in InsForge sessions + learning_memory. Empty/failed input never fabricates learning.",
      "laneId": "daily-call"
    },
    {
      "id": "receipt",
      "title": "What gave you away",
      "status": "pending",
      "summary": "Planned: show actual original phrase → native phrasing, expression and cultural takeaway from the saved session. Return Home; a later call can build on persistent learner memory.",
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
    "humanWants": "Next implementation session: bootstrap the independent native iOS app from minimal Nobody patterns; keep the donor read-only. Three-hour priority: Higgs voice → compelling coaching → InsForge learner memory → polish. M0.1 is still pending. InsForge is planned in M4, not extra bootstrap architecture.",
    "originalHumanWants": "Goal: create a clean new hackathon app while selectively reusing proven Nobody implementation.\n\nExamples:\n\n- establish new repo/project\n- app builds and launches\n- port design system/assets needed for MVP\n- port/adapt reusable Nobody UI components\n- establish architecture for Higgs integration\n- remove dependency on irrelevant old product architecture\n\n- native ios is correct\n\n- I created and published a GH repo called roasted\n- agree with your rec on in-app incoming calls\n- deadlines and rules will be provided later",
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
      },
      {
        "id": "inapp-scope-confirmed",
        "text": "agree with your rec on in-app incoming calls",
        "aiTodoIds": [],
        "humanCheckIds": [
          "daily-delivery-choice"
        ],
        "journeyStepIds": [
          "incoming",
          "accept"
        ]
      }
    ],
    "aiTodo": [
      {
        "id": "m0-target",
        "label": "1. Adapt minimal project.yml and app identity; exclude App Clip/old backend. Done: target compiles.",
        "status": "pending",
        "journeyStepIds": [
          "home"
        ]
      },
      {
        "id": "m0-shell",
        "label": "2. Adapt RootView/HomeView shell without People, receiver or old AppEnvironment. Done: offline Home launch.",
        "status": "pending",
        "journeyStepIds": [
          "home"
        ]
      },
      {
        "id": "m0-isolation",
        "label": "3. Check copied target has no donor secrets, social APIs or LiveKit dependency. Done: isolated demo target.",
        "status": "pending",
        "journeyStepIds": [
          "home"
        ]
      },
      {
        "id": "m0-launch-proof",
        "label": "4. Build and cold-launch in simulator; save real Home evidence. Done: working launch, no extra test matrix.",
        "status": "pending",
        "journeyStepIds": [
          "home"
        ]
      }
    ],
    "humanChecks": [
      {
        "id": "daily-delivery-choice",
        "label": "MVP scope confirmed: in-app incoming calls; scheduled/background calls are deferred.",
        "status": "approved"
      },
      {
        "id": "higgs-access",
        "label": "Before M2: provide Higgs access securely and the demo language pair; confirm permitted live-test usage.",
        "status": "needs_review"
      },
      {
        "id": "event-details",
        "label": "Before M5: review official deadline/rules when supplied, then verify the demo against the rubric.",
        "status": "needs_review"
      },
      {
        "id": "review-static-journey",
        "label": "Before M2: review the mock journey and tone; fixtures are not live learning evidence.",
        "status": "needs_review"
      },
      {
        "id": "review-coaching-tone",
        "label": "At M3: review one live correction/retry for useful coaching and savage friend tone.",
        "status": "needs_review"
      },
      {
        "id": "review-real-receipt",
        "label": "At M4: compare the real call with its retained receipt for fidelity and learning value.",
        "status": "needs_review"
      },
      {
        "id": "review-final-demo",
        "label": "At M5: review the live demo and submission evidence; publication needs a separate instruction.",
        "status": "needs_review"
      },
      {
        "id": "insforge-access",
        "label": "Before M4: provide InsForge project access securely and confirm the single demo learner identity.",
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
      },
      {
        "id": "return-for-next-call",
        "fromStepId": "receipt",
        "toStepId": "home",
        "label": "Return Home; next call retrieves saved learner memory"
      }
    ],
    "entryPaths": []
  },
  "taskHistory": [],
  "progress": {
    "summary": "Planning only · 3 hours: voice → coaching → InsForge memory → polish. M0.1 pending; 18 app tasks pending. M4 adds save → retrieve → influence next call.",
    "blockers": [
      "Before M2: Higgs access, demo language pair and live-test permission. Event rules/deadline are needed for submission review, not M0.",
      "Before M4: InsForge project access and the single demo learner identity are not yet verified; this does not block M0–M3."
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
      "label": "Higgs voice + InsForge learner memory: 3-hour scope and acceptance",
      "kind": "document",
      "path": "docs/execution-brief.md"
    }
  ]
}
```
