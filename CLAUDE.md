# Hold Me Up

## What this is
A local multiplayer party game for kids: hold your phone as flat as possible,
longest (or last) player standing wins. iOS-only, no backend server, no
accounts. This file is the durable summary of everything decided during
planning, so any future session — this one, or Claude Code running locally
on the developer's Mac — has full context without re-deriving it.

## Stack & why
- **Swift + SwiftUI**, not React Native/Flutter — the two hardest technical
  pieces (CoreMotion for tilt, MultipeerConnectivity for local multiplayer)
  are both Apple-native frameworks. Cross-platform tooling would only add a
  bridging layer for zero benefit, since this is iOS-only.
- **No backend.** MultipeerConnectivity connects nearby devices directly over
  Wi-Fi/Bluetooth — no server, no internet required, no hosting cost.
- Deployment target: **iOS 17**.

## Architecture
- **Host-authoritative.** The host device runs the game clock, aggregates
  every player's tilt state, decides eliminations/winner, and broadcasts
  results. Joiners send their own tilt readings to the host; they don't
  decide anything themselves.
- **Star topology.** Every joiner connects only to the host (peers don't
  connect to each other), so any device can just call `broadcast()` and it
  correctly reaches "the host" (from a joiner) or "everyone" (from the host).
- **No accounts.** Nickname + avatar are chosen once in onboarding and stored
  in `UserDefaults` (`PlayerProfileStore`). Never leaves the device except as
  part of the in-game roster shared with whoever you're actively playing with.

## Where things live
- `Models/` — plain data types (`Player`, `PlayerResult`, `DifficultyLevel`,
  `AvatarOption`, `GameMessage` — the wire protocol).
- `Services/` — `MotionService` (CoreMotion), `MultipeerService` (networking),
  `GameSessionController` (the actual game loop, ties the two together),
  `StoreService` (StoreKit 2, currently placeholder product IDs).
- `Screens/` — one SwiftUI view per screen in the locked mockup.
- `Components/` — shared UI: `BullseyeView` (the core tilt visualization),
  buttons, avatar badges, result rows, etc.
- `Theme/Theme.swift` — color tokens ported from the mockup, light/dark both
  defined.

## Locked mockup (visual reference)
https://claude.ai/code/artifact/94950ad9-8fc6-4721-976d-51cb24660eda

Every screen's layout, copy, and states (including the How to Play tutorial)
should match this. If an implementation needs to diverge, flag it — the
mockup is the source of truth until explicitly updated.

## Deferred / TODO — do not silently fill these in
- **Tolerance and duration per difficulty** (`DifficultyLevel.swift`) are
  placeholders from early planning (Easy: 3min/50°, Medium: 5min/30°,
  Hard/Savage extrapolated). Real values need playtesting on a physical
  device — not final.
- **StoreKit product IDs** (`StoreService.swift`) use the real bundle ID
  prefix (`com.wynwin.holdmeup.*`) but won't resolve to real products until
  Apple Developer Program enrollment is done and products exist in App Store
  Connect.
- **Fail-sound** in the tutorial (`HowToPlayEliminationView`) uses a built-in
  iOS system sound as a stand-in — swap for a real custom sound asset later.
- **App name** "Hold Me Up" is not finalized branding, just what the repo is
  called today.

## Specialized agents
`.claude/agents/frontend-developer.md` and `.claude/agents/tester.md` define
two project-scoped subagents (SwiftUI screens/components, and Swift Testing
unit tests respectively). Any Claude Code session opened in this repo picks
them up automatically — no per-session setup needed. More roles (backend,
etc.) get added the same way if/when a project actually needs the split;
this one doesn't need more yet since it's a single Swift codebase with no
backend.

Give the `tester` agent latitude on scope — it decides what "comprehensive"
means within its documented boundaries (pure logic + `GameSessionController`
decision logic; not motion/networking/UI, which need a real device) rather
than following a fixed checklist. Ask it to state what it covered and what
it deliberately skipped, each time.

## Workflow
From here on, any development/implementation request goes through the
`frontend-developer` and `tester` agents in this fixed sequence, not ad hoc:

1. **Clarify** — confirm the requirement and priority of the next feature or
   change before any code or tests get written. Ask if it's ambiguous.
2. **Tester writes tests first** — `tester` creates/updates the test(s) for
   the agreed behavior before any implementation exists.
3. **Developer implements** — `frontend-developer` writes or updates the
   code needed to satisfy those tests.
4. **Tester runs the tests** — `tester` executes them (locally, via
   `xcodebuild`/`swift test` against `holdmeup.xcodeproj` — see "Dev
   environment" below for how test execution works in local vs. cloud
   sessions) and reports pass/fail plainly, never guessing.
5. **Outcome**:
   - All green → the feature/change is **COMPLETED OK**.
   - Any failure → go back to step 3 (developer fixes, tester re-runs).

**Guardrail: max 3 iterations of steps 3–4.** If the 3rd re-run still has
failures, stop — don't keep looping. Explain the situation in chat (what's
failing, what's been tried) and offer concrete next-action options (e.g.
narrow the requirement, pair on the failing case directly, accept a partial
fix, or escalate a blocker like a missing device/API).

## Monetization
- **Party Pack** — non-consumable IAP, host-only, raises the room cap from
  3 → 8 players. Enforcement is client-side (no server to check against) —
  accepted risk for a casual kids' game, not worth building a backend to
  prevent.
- **Tip jar** — consumable IAP, 3 tiers, purely optional, no functional
  unlock.

## Player cap
Hard technical ceiling is 8 peers per `MCSession` (Apple's own guidance on
reliable real-time sync). Free tier: 3. Party Pack: 8.

## Not yet built
- Real StoreKit purchase flow wiring (needs Dev Program enrollment first)
- Persisted stats history across games
- Any settings beyond nickname/avatar
- Dynamically updating a host's advertised difficulty/player-count after
  hosting has started (currently captured once at the moment hosting begins)

## Dev environment
- Xcode must run locally on macOS — this repo can be edited/pushed from a
  cloud session, but building, the Simulator, and physical-device testing
  all require a local Mac with Xcode installed. See `SETUP.md`.
- MultipeerConnectivity and CoreMotion's live behavior (real discovery, real
  sensor data) can't be verified in Simulator — plan to test on physical
  iPhones early and often.
- Developer's Mac: 2020 Intel MacBook Air, 8GB RAM — workable but slow to
  build; was stuck on macOS Sequoia (15.x) which the current Xcode doesn't
  support (needs macOS 26+). Fix was downloading an older Xcode (16.x) from
  developer.apple.com/download/all/ instead of the App Store.
- **Testing approach right now: direct USB install via Xcode's free
  "Personal Team," not TestFlight.** Deliberately deferring Apple Developer
  Program enrollment until closer to real playtesting. Known limits of this
  path: builds expire after 7 days and need reinstalling, free-team device
  registration is capped well below the paid program's 100/year (historically
  ~3), each device needs a one-time "trust this developer" step in Settings,
  and there's no way to distribute to anyone not physically cabled to this
  Mac. StoreKit purchases (tip jar / Party Pack) can still be tested locally
  via an Xcode StoreKit Configuration file without needing enrollment.
- **Bundle ID: `com.wynwin.holdmeup`** (targets are named `holdmeup` /
  `holdmeupTests` / `holdmeupUITests`, lowercase — matches the real Xcode
  project, not the `HoldMeUp`/`com.holdmeup.*` naming used earlier in
  planning). Testing System is Swift Testing, matching `StoreService.swift`'s
  product ID prefixes.
- Deployment target is **iOS 17.0** — confirmed as the real minimum; a local
  drift to 18.5 was found and corrected back once, and a drift to 15.6 was
  found and corrected back twice more (see the reproducible-drift quirk
  below).
- `holdmeup.xcodeproj` (plus `holdmeupTests/`, `holdmeupUITests/`) lives at
  the root of this repo. It uses Xcode 16's file-system-synchronized groups,
  so the project's main source group just points at `HoldMeUp/` on disk —
  new files added under `HoldMeUp/` are picked up automatically, no manual
  target-membership step needed for files inside that tree. `Assets.xcassets`
  and `Info.plist` live under `HoldMeUp/` alongside the hand-written source.
  (The old separate local-only copy at `~/Documents/XCode/Developer/holdmeup`
  has been deleted now that this repo is the single source.)
- **Git push/pull from Terminal is authenticated via `gh auth login`** (set
  up 2026-08-17, logged in as `cramtirolf`) — works directly now. If a local
  `git push` ever fails again with `could not read Username for
  'https://github.com'`, it means this Mac's `gh` auth or git credential
  helper (`osxkeychain`) needs re-running, not that push is fundamentally
  broken — a cloud session has no access to this and should fall back to the
  GitHub MCP tools (`push_files`, `create_pull_request`, etc.) instead.
- **Known quirk: Simulator window can render solid black on first launch of
  a session** on this Mac, even though the app is actually running fine
  underneath (confirmed via `simctl` screenshot showing real content, and no
  crash in `simctl spawn booted log show` or `~/Library/Logs/
  DiagnosticReports`). Looks like a Metal/GPU rendering glitch tied to this
  Intel Mac's hardware, not an app or project-config bug — iOS 17 deployment
  target vs. an iOS 18 Simulator runtime is *not* the cause (that's the
  normal, fully-supported case). Fix: quit Simulator.app completely (⌘Q, not
  just closing the window) and re-run from Xcode.
- **Known quirk: local builds reproducibly rewrite `project.pbxproj`** on
  this Mac. Any local `xcodebuild`/Xcode build of the `holdmeup` target
  (Debug and Release configs both) reliably re-adds three lines that are
  *not* in the committed baseline: `IPHONEOS_DEPLOYMENT_TARGET = 15.6;`,
  `INFOPLIST_KEY_CFBundleDisplayName = "Hold Me Up";`, and
  `INFOPLIST_KEY_LSApplicationCategoryType =
  "public.app-category.kids-games";`. Confirmed reproducible twice in the
  same session — reverting via `git checkout` or manual edit, then simply
  rebuilding again, brought all three right back. Root cause not fully
  pinned down (looks like Xcode's own project-settings inference writing
  its guesses back to disk on build), but the fix is mechanical: **always
  check `git diff holdmeup.xcodeproj/project.pbxproj` before committing**,
  and revert these three lines (or `git checkout --
  holdmeup.xcodeproj/project.pbxproj` if no other intentional pbxproj
  changes are pending) if they reappear. The deployment target must stay
  `17.0` (see above); the two `INFOPLIST_KEY_*` lines are undesired because
  app branding/category are still open TODOs, not because they're wrong
  per se — revisit if branding gets finalized.
