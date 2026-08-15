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
- **StoreKit product IDs** (`StoreService.swift`) are placeholders
  (`com.holdmeup.*`). They won't resolve to real products until Apple
  Developer Program enrollment is done and products exist in App Store
  Connect.
- **Fail-sound** in the tutorial (`HowToPlayEliminationView`) uses a built-in
  iOS system sound as a stand-in — swap for a real custom sound asset later.
- **App name** "Hold Me Up" is not finalized branding, just what the repo is
  called today.
- **Bundle identifier** used in `SETUP.md` / `StoreService.swift` is a
  placeholder (`com.holdmeup.*`) — replace with whatever's registered once
  Developer Program enrollment happens.

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
