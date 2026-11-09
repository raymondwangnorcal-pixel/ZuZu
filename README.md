# ZuZu pushup tracker

An iPhone-only SwiftUI app for standalone pushup sessions. Requires iOS 17 or later and does not restrict access by iPhone model.

## Open and build

Open `ZuZu.xcodeproj` in Xcode. Select an iPhone signing team to install on a device. The camera counter requires a physical iPhone; the simulator cannot validate pose tracking.

For a code-signing-free build:

```sh
xcodebuild -project ZuZu.xcodeproj -scheme ZuZu -configuration Debug \
  -sdk iphoneos -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO build
```

The project contains no external packages. `Package.swift` exposes the pure counting and Progress calculations for tests:

```sh
swift test
```

If new Swift source or resource files are added, run `python3 tools/make_xcodeproj.py` to refresh the Xcode project file.

## Current behavior

- A session starts from the Start tab with a 5–100 rep target (default 15; presets 10, 15, 20, 30).
- The app chooses an available front wide-angle camera, with another front video camera as a fallback. It checks capture presets at runtime and does not require TrueDepth. Frames stay in memory while Vision counts a clear elbow bend and return; no recording, image log, or upload is made.
- Camera interruption, capture failure, or denied access preserves the session and offers tap counting. The camera setup also offers tap counting if no front camera is available.
- The user can pause, resume, switch to tap counting, correct the count before saving, and save or discard a partial session. The goal stops automatic and tap counting until final review.
- Saved sessions remain on the iPhone and in normal device backups until deleted. Progress derives the seven-day chart, lifetime count, streak, and each 500-rep milestone from those sessions.
- A saved partial adds reps to Progress. Only a completed goal can earn a streak day. One missed day receives grace.
- Sessions are attributed to the iPhone's local calendar day at completion; later travel does not move those reps to another day.

## Release verification

The camera algorithm is a prototype until [the physical-device test matrix](docs/camera-validation.md) passes. A successful build and unit tests do not establish zero camera count errors on every model. The current environment cannot launch a simulator or enumerate an attached iPhone, so the on-device flow and camera have not been run here.

The Figma remote design-context connection currently reports an access error. The completion illustration was exported through the Figma desktop app; other screens were implemented from the previously inspected Figma frames and approved standalone adaptations.
