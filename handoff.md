# ZuZu pushup tracker handoff

## 1. Current task goal

Build the standalone SwiftUI pushup tracker from the ZuZu Figma screens. The app source and Xcode project now exist. Real-device camera accuracy testing remains before a release claim.

## 2. User requirements and constraints

- iOS 17+, iPhone only, standalone sessions; default 15 reps, presets 10/15/20/30, target range 5–100.
- Front camera must count clear down/up cycles on device with no recording or upload. Manual tap fallback and count correction are available any time before Save.
- Stop counting at the goal and review before Save. A partial session asks Save or Discard; only a completed goal earns a streak day.
- Pause/Resume is manual; backgrounding, lock, and calls pause. Unsaved sessions restart if the app is closed.
- Progress uses accepted reps from all saved sessions, including partials. Same-day sessions add only to the daily total. One grace day is allowed; two consecutive missed days reset the streak. Milestones occur every 500 reps with no ETA.
- Saved history stays on iPhone, participates in normal iPhone backups, and is deleted only through a visible per-row menu with confirmation. History rows show reps/goal and completion date/time, without duration.
- Reps and streak credit stay on the local calendar day shown at completion even after travel.
- Standalone copy: “Pushup session,” “reps to goal,” “Goal complete,” and “Done.” Keep Snoozy's advancing race and completion celebration.
- Camera release gate: zero missed or extra reps in ten 15-rep sessions per tested iPhone, with bright/dim light and two placements against manual ground truth. The available phone is iPhone 14 Plus. Every iOS 17-compatible iPhone model must be able to use the tracker, without a model allowlist or TrueDepth dependency.

## 3. Files inspected

- `docs/pushup-tracker-plan.md`, `docs/decisions.md`, `CReview1.md`, and the prior `handoff.md`.
- Figma file `wPPxgWD5AAUPs7UUL2CmB0`, especially Wake 3 `47:1885`, Wake 4 `48:1933`, Progress `51:1983`, and history states listed in the plan. The remote design-context connector still reports lack of edit access, but the desktop Figma file opens.
- Xcode 26.4.1, compiled app Info.plist, and generated app bundle.

## 4. Files modified

- `Package.swift`; `ZuZu/Core/*`; `ZuZu/App/*`; `ZuZu/Resources/CompletionHero.png`; `ZuZu.xcodeproj/project.pbxproj`; `tools/make_xcodeproj.py`; `Tests/ZuZuCoreTests/CoreTests.swift`.
- `README.md`, `docs/camera-validation.md`, `docs/decisions.md`, and this handoff.
- Prior Figma edits remain: Progress three-stat row removed; Wake 4 uses solid background; Saved Sessions/history/deletion screens added. This implementation turn exported the Wake 4 Hero illustration through the Figma desktop UI and added an export setting to that Hero group.

## 5. Important implementation decisions

- App uses AVFoundation front-camera sample buffers and Vision body pose; an elbow-angle state machine detects a down/up cycle. It selects a front wide camera, checks supported presets at runtime, uses native frame output, and handles camera interruption. Frames remain in memory and no video/photo output is configured.
- `WorkoutController` owns transient state and elapsed clock. `SessionStore` writes saved results atomically as JSON in Application Support and refuses to overwrite a file that failed to load. `ProgressCalculator` derives totals, chart, streak, and milestones from saved results.
- `SessionRecord` stores the completion day string and time-zone ID to keep travel from moving a saved session to another day.
- The completion sloth illustration is a PNG directly bundled as a resource because asset-catalog compilation in this environment fails when no Simulator runtime is available.
- Decisions DEC-0032 through DEC-0042 capture new user answers in the append-only ledger. No code or docs have been committed; the repo has no HEAD commit.

## 6. Current state of the code

The Xcode project and app compile for generic iPhone. Start, setup, live camera/tap session, pause/resume, correction, goal review, save/discard, completion, Progress, saved history, and confirmed deletion are implemented. The camera counter is a prototype until the physical test matrix passes. The Snoozy race bar advances with the user's accepted count. The completion screen uses actual Figma artwork.

## 7. Tests run and results

- `swift test --disable-sandbox` with caches under `/private/tmp`: six core tests passed, including rep-cycle, uncertain-frame, same-day/partial totals, grace-day reset, and time-zone-stable completion day.
- `xcodebuild` generic iPhone device and generic iOS Simulator builds with signing disabled: both exit 0 after the runtime capture changes. No simulator could be launched because the service reports no installed runtimes.
- Compiled app Info.plist verified: `MinimumOSVersion=17.0`, `UIDeviceFamily=[1]`, and camera purpose text included. Compiled app bundle contains `CompletionHero.png`.
- Asset-catalog compilation failed earlier because CoreSimulatorService reports no installed runtimes; bundling the PNG directly permits successful generic builds. `devicectl list devices` could not connect to CoreDeviceService, so no physical run was performed.
- Decision ledger new entries recorded and verified via the decisiontracker writer; a final full validation should be rerun before handoff.

## 8. Known bugs, gaps, or risks

- Camera accuracy has not been measured on a real iPhone. The user requires zero observed count errors at the agreed gate; the app is not release-validated.
- Only iPhone 14 Plus is currently available for real-device testing. Source and build settings permit all iOS 17-compatible iPhones, but camera-count accuracy on other models is not yet measured.
- The Figma remote design-context connector still reports an edit-access error, so exact layout and token verification against every screen was unavailable. Desktop Figma was used to export the completion Hero.
- No simulator runtime or accessible attached iPhone was available to run the full UI flow. Device installation will require a signing team.
- `docs/pushup-tracker-plan.md` still contains older open-question wording; current choices are in `docs/decisions.md`, code, README, and this handoff.

## 9. Exact next steps

1. Install `ZuZu.xcodeproj` on the available iPhone 14 Plus; walk through the session, interruption, history, and deletion flows and fix issues found.
2. Run the ten-session camera matrix in `docs/camera-validation.md` on each model for which camera-count accuracy will be claimed. Keep manual ground-truth counts; iterate the detector and rerun the full matrix if any count error appears.
3. If Figma connector access is restored, compare screen dimensions, colors, typography, and exported assets and refine the SwiftUI views.
4. Rerun tests/build/decision-ledger validation and hand off the build and remaining release risks.
