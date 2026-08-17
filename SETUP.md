# Setup — Getting This Running in Xcode

This repo already contains a real Xcode project — `holdmeup.xcodeproj` at
the repo root, alongside `holdmeupTests/` and `holdmeupUITests/`. Clone the
repo and open `holdmeup.xcodeproj`; there's no project to create from
scratch anymore.

## 1. Install Xcode
If the Mac App Store won't offer Xcode because your macOS is older than the
latest release requires, download a matching older Xcode version instead
from **developer.apple.com/download/all/** (sign in with any Apple ID, no
paid enrollment needed). This project was created with Xcode 16.4 — match
that era (e.g. Xcode 16.x for macOS Sequoia, 15.x).

## 2. Open and build
1. `open holdmeup.xcodeproj` (or double-click it in Finder).
2. The project uses Xcode's file-system-synchronized groups — the app
   target's source group points straight at `HoldMeUp/` on disk, so
   everything's already wired up. No manual target-membership step needed.
3. Build (⌘B). If Xcode can't find a scheme to run/test with (only a
   user-local auto-created one exists, not a shared one yet), open
   **Product → Scheme → Manage Schemes…** and check "Shared" next to
   `holdmeup` — this also lets `xcodebuild`/the `tester` agent find it from
   the command line.
4. `NSLocalNetworkUsageDescription` and `NSBonjourServices` (required for
   MultipeerConnectivity — without them it silently fails to
   discover/advertise on iOS 14+) are already set: the description via a
   build setting, the Bonjour service types in `HoldMeUp/Info.plist`.
   Nothing to add manually.

(No entry is needed for CoreMotion/the gyroscope — `NSMotionUsageDescription`
only applies to step-counting/activity APIs, not raw device motion.)

## 3. Run it
- Simulator works fine for Onboarding, Home, How to Play, and Support
  screens.
- **Host/Join/Gameplay need real devices** — Simulator can't fake nearby
  peer discovery or real gyroscope data. Test with two physical iPhones once
  you're at that stage.
- Sign in under Xcode → Settings → Accounts if you haven't — creates a free
  "Personal Team," enough to run on your own device before formal Developer
  Program enrollment.

## 4. Suggested build order
1. Onboarding + Home (Simulator is fine)
2. How to Play tutorial (Simulator is fine — static/sample data)
3. Host/Join/Lobby (needs 2 physical devices)
4. Gameplay + Results (needs 2 physical devices)
5. Support & Unlocks — real purchases need Developer Program enrollment +
   App Store Connect product setup first; the UI can be reviewed before that
