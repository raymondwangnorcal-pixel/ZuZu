# Pushup tracker — draft feature plan

> Implementation update, 2026-09-30: The standalone SwiftUI app is built in `ZuZu.xcodeproj`. Current behavior and build instructions are in `README.md`; the physical camera release gate is in `docs/camera-validation.md`. The open questions below were resolved in `docs/decisions.md` through DEC-0042. On-device camera accuracy testing is still outstanding. Every iOS 17-compatible iPhone model may run the tracker; no model or TrueDepth gate is used.

## Goal and boundary

Build a standalone SwiftUI pushup tracker based on the current ZuZu Figma design: choose a rep target, count actual reps with the front camera, recover from camera problems, complete a session, and see saved progress. A user can start a session without an alarm. The alarm, sound, weather, friends, and general settings features are outside this build. The tracker may expose a small entry and completion interface so an alarm feature can connect later.

This repository currently contains design review and decision documents but no application source or Xcode project. Create the SwiftUI project in this repository for iOS 17 and later, iPhone only. The sequence below is a product and delivery plan. Exact source paths and build commands can be set when the Xcode project is created.

## Decisions already settled

- A user starts a standalone session without an alarm.
- SwiftUI on iOS 17 and later, iPhone only, is the application target; working front-camera rep counting is required in the first release.
- The target defaults to 15 reps, offers 10, 15, 20, and 30 as presets, and the stepper allows 5 through 100 reps.
- A camera rep counts after a clear down-and-up cycle. Depth and body-alignment enforcement are not part of the initial rep rule.
- The user can switch to tap-to-count and correct a missed or false count manually.
- Stopping before the target opens a choice to save or discard that partial session. This prompt needs a design because no matching Figma screen exists.
- A user-saved partial session contributes its accepted reps to lifetime and seven-day Progress totals.
- Camera frames are processed strictly on the device and are never recorded or uploaded.
- Camera, tap, and corrected reps all contribute to the same lifetime and daily totals once accepted into a saved session.
- Session history is stored only on the iPhone for the first release; no account or cloud sync is required.
- The standalone counter shows remaining reps and elapsed time. Keep the sloth race and a streak celebration, with copy and streak rules adapted to standalone use.
- Support every iPhone model that can run the iOS 17 deployment target. The user requires zero counting errors; the release gate still needs a finite device, placement, and lighting test matrix. Uncertain camera observations continue with in-session correction available.
- Automatic and tap counting stop at the selected goal. Only a completed goal earns a streak day; a saved partial session does not. One missed calendar day receives grace rather than immediately resetting the streak.
- A call, lock, or move to the background pauses both camera counting and elapsed time until the user resumes.
- Closing or terminating the app before a session is saved discards that in-progress session. The next launch starts a new session; saved results remain available.
- Users may delete saved sessions but may not edit saved totals. Snoozy's race advances alongside the user's accepted reps.
- Later sessions on the same calendar day add reps to the lifetime total and that day's seven-day bar; the day appears once in day-based statistics and streak calculations.
- Two consecutive missed calendar days reset the streak after the single grace day.
- Reaching the target stops count inputs and opens a review state where the user can correct a mistaken final rep before saving.
- Progress keeps the lifetime total, seven-day chart, and milestone card. The three-stat row is removed from Figma, and milestones occur every 500 lifetime reps, including reps from user-saved partial sessions.

## Figma screens used

| Surface | Figma node | Use in this feature |
| --- | --- | --- |
| Pick mission | [Onboarding 3](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=148-3169) | Target stepper and 10/15/20/30 presets |
| Camera setup | [Onboarding 4](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=137-2497) | Placement guidance, permission, tap fallback |
| Live camera count | [Wake 3](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=47-1885) | Count ring, pose feedback, progress segments, remaining reps |
| Tap count | [Wake 3B](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=150-2669) | Large tap target and shared counter state |
| Camera cannot see user | [Visibility error](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=148-2461) | Pause camera counting, give placement tips, allow mode switch |
| Camera denied | [Permission error](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=148-2940) | Settings recovery and tap fallback |
| Session complete | [Wake 4](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=48-1933) | Completed rep count and return action |
| Saved progress | [Progress](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=51-1983) | Lifetime total, last seven days, 500-rep milestones |
| Saved sessions | [History](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=171-2717) | Completed and saved-partial results, reached from Progress |
| Session options | [Delete menu](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=177-2796) | Visible per-session options control and Delete action |
| Confirm deletion | [Confirmation](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=178-2861) | Confirm or cancel removal before recalculating Progress |
| No saved sessions | [Empty history](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=178-2990) | Empty state after first launch or deleting the final saved session |

The [ringing screen](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=46-1879), [snooze confirmation](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=46-1946), and [alarm editor](https://www.figma.com/design/wPPxgWD5AAUPs7UUL2CmB0/Snoozy?node-id=6-2) provide possible future integration context. They are not part of the standalone tracker. Alarm-dependent copy on the counter and completion screens needs a standalone wording pass; the Figma mockups do not yet define that copy.

## Standalone screen adaptation

| Figma element | Proposed standalone behavior |
| --- | --- |
| Alarm name chip | Show “Pushup session” or the user's session name if naming is added later. |
| “6 more to turn off the alarm” | Show “6 reps to goal.” |
| `0:48` on the counter | Label as `0:48 elapsed` and compute from the session clock. |
| “Nice! Chest to the floor” | Replace with feedback such as “Rep counted” that matches motion-only detection. |
| Sloth at 8 while user is at 9 | Keep the motivational race, but define whether the sloth's count follows time, the user's count, or a scripted animation. |
| “You're up!” and “Start my day” | Use standalone completion copy such as “Goal complete!” and “Done”; agree final wording before visual signoff. |
| Three-stat row on Progress | Removed from the Figma frame; retain the milestone card beneath the seven-day chart. |
| “Across 71 mornings” | Rename to active days or sessions after choosing the aggregation label. |

Additional designs needed: a standalone launch screen, a save/discard partial-session prompt, manual correction controls, and a zero-data Progress state. The saved-session history and its empty state are now shown in Figma.

**Goal review:** When the accepted count reaches the goal, stop all count inputs and show a short review state before saving. The user may confirm the total or correct a false last rep; a correction below the goal returns to counting. Exact wording and visual design are still open.

## Proposed delivery sequence

### 1. Settle the product contract

Create an iPhone SwiftUI Xcode project targeting iOS 17 or later in this repository. Define a standalone Start Session entry, the camera reliability threshold, manual correction limits, the save/discard prompt, and remaining Progress definitions. A clear down-and-up cycle is the accepted rep rule. Resolve these details before fixing the pose algorithm or persistence schema.

**Exit:** One agreed session flow, a defined rep rule, and a definition for each displayed statistic.

### 2. Prove the counting method on a real device

Make a real-device prototype using AVFoundation to receive front-camera frames and Vision body-pose observations as an initial technical candidate. Test the floor/three-foot placement pictured in Figma across iOS 17-compatible iPhones, including dim rooms, partial bodies, different body sizes, and fast or incomplete reps. Measure missed and duplicate counts against ground-truth video-free manual observations. Define the down/up state transition and fallback trigger. Replace the Figma “chest to the floor” feedback with wording that reflects the agreed motion-only rule. Process frames only in memory on the device; do not record, upload, or log images. Treat zero counting errors as a required outcome on the agreed test matrix, not as an unprovable guarantee for every real-world condition. When a body is still detected but pose observations are uncertain, continue counting and make correction available; when the person is out of frame, use the Figma paused recovery state.

**Exit:** A demonstrated camera rep-counting rule, agreed reliability threshold, and documented conditions in which counting pauses or uses the fallback.

### 3. Ship one complete counting session

Build a SwiftUI Start Session and target-selection flow, one session state machine, the live count display with remaining reps and elapsed time, tap fallback, manual plus/minus correction, goal review, the stop-early save/discard prompt, completion, and durable storage of saved results on the iPhone. A session should keep its count when switching from camera to tap mode. Count each accepted rep once, stop counting at the selected goal, let the user correct the final count before saving, and save one completed or user-approved partial result once. A call, lock, or background transition pauses the count and elapsed clock until explicit resume while the app remains open. If the app closes or is terminated before saving, discard the in-progress count and return to Start Session on next launch. The session model should distinguish camera-accepted, tap-added, and corrected reps for debugging while presenting one combined accepted-rep total in Progress.

**Exit:** A user can start, correct, finish or stop early, and view a saved result without losing or duplicating saved reps. An interrupted but unsaved session restarts after app termination.

**Proposed persisted result:** A stable session ID, target, start/end timestamps, final accepted rep total, camera/tap/correction contributions, completion versus saved-partial status, and elapsed duration. Use the session ID to make completion saves idempotent. Keep camera frames out of the result.

### 4. Add camera mode and recovery

Add permission onboarding, pose feedback, automatic pause when the person is out of frame, placement tips, denied-permission recovery, and switching to tap mode. Camera mode and tap mode must feed the same session counter. The screen should never imply a rep was accepted until the session state records it. Recheck permission after returning from iOS Settings.

**Exit:** Each Figma camera state has a working transition and the user can complete the target when camera access or tracking fails.

### 5. Make Progress use real session data

Derive lifetime reps, active days, the trailing seven calendar days, streak days, and the next 500-rep milestone from saved sessions. Include user-saved partial sessions and combine camera, tap, and corrected accepted reps in lifetime and seven-day aggregates. Sum later same-day sessions into that day's seven-day bar and lifetime total while representing that calendar day once in day-based calculations. Only goal-completed sessions qualify for a streak day; one missed day has grace and two consecutive missed days reset the streak. Add the Saved Sessions button to Progress and a history list with completed and saved-partial sessions, accepted reps versus target, and local date/time; omit elapsed duration from list rows. Each row exposes a visible ⋯ menu with Delete. Show a confirmation naming the selected session before deletion; Cancel leaves it intact, while Delete removes it and recomputes all Progress and streak values. Saved totals themselves cannot be edited. Show the designed empty-history state when no saved sessions remain. The three-stat row has been removed from the Figma Progress screen while the milestone card remains. Add a zero-data Progress state, which the current Figma set does not show. Make chart bars and the Today highlight accessible with text labels. Decide which local day receives a session crossing midnight before implementing aggregates.

**Exit:** The Progress screen reflects saved sessions and remains correct after relaunch, a new day, and a time-zone change.

### 6. Connect to the surrounding app

Expose a start input such as target reps and an optional future alarm context, plus a completion result such as completed reps, elapsed time, completion time, and count modes used. Keep alarm integration as a later contract. Keep the Figma sloth race and streak celebration; Snoozy's displayed count advances alongside the user's accepted count. Friends and sound logic remain outside the tracker.

**Exit:** The tracker can be launched and its result consumed without pulling other ZuZu features into scope.

## Suggested acceptance checks

- A selected target appears consistently in the counter, remaining-reps message, and completion result.
- Elapsed time starts with the session, pauses on a call, lock, or background transition, and resumes only when the user chooses to resume.
- Closing the app before Save discards the unfinished session; the next launch starts a new session and does not add its reps to Progress. Previously saved sessions remain unchanged.
- A rep is added once per valid count event; rapid repeated taps or repeated camera frames do not inflate the result.
- Camera and tap counting stop at the selected goal, including when further frames or taps arrive.
- At the goal, the user reviews the count before saving; reducing an incorrect final count below the goal returns to counting.
- Manual corrections change the displayed count without going below zero; the saved session preserves the corrected total and its provenance.
- Stopping early offers Save and Discard; Discard adds nothing to Progress and Save creates one partial result.
- Leaving camera view pauses automatic counting and shows the recovery screen; returning to view resumes without resetting progress.
- Denied camera permission offers a working route to system settings and a working tap fallback.
- Switching modes keeps the existing accepted reps and does not save two sessions.
- Completing the target saves exactly one result; reopening Progress reflects it in the total and correct local-calendar day. A user-saved partial result also appears in both totals.
- Only goal-completed sessions earn streak days. One missed calendar day has grace; two consecutive missed days reset the streak. Deleting a session removes its reps from Progress and recalculates dependent values.
- Progress opens Saved Sessions. The list includes completed and user-saved partial sessions with reps, target, and local date/time. The visible ⋯ menu offers Delete, which requires confirmation; Cancel preserves the session and Delete updates the list, totals, chart, milestone, and streak. Deleting the last saved session shows the empty state.
- Later sessions on the same day raise both the lifetime total and that day's seven-day bar without creating an extra day in day-based metrics or streaks.
- The seven-day bars, lifetime count, active-day count, and next 500-rep milestone are computed from one agreed set of definitions.
- Camera frames are processed in memory on-device without recording, upload, or image logging.
- The count, progress, errors, and controls remain understandable with VoiceOver, large text, and reduced motion.

## Decisions needed before an executable engineering plan

1. What finite device, placement, and lighting matrix must show zero observed count errors for release? How should the UI show that the camera is ready to count?
2. When a body is visible but pose observations are uncertain, counting continues with correction available; what visual cue should show this uncertainty?
3. Can the user pause a session, and should manual correction be limited by a count or time window?
4. What should replace the alarm chip, “turn off the alarm,” and “Start my day” on standalone screens? The timer becomes elapsed time.
5. Which local day receives a session crossing midnight?
6. How long should local session history be retained? Deletion is supported, and saved totals are read-only.
7. Milestones occur every 500 lifetime reps; how should the estimated number of active days to the next one be calculated?

Once these choices are answered, turn each delivery step into a file-specific implementation plan with exact build and verification commands for the selected stack.

## Technical references for the camera prototype

- [Apple AVFoundation video data output](https://developer.apple.com/documentation/avfoundation/avcapturevideodataoutput) supplies camera frames for processing.
- [Apple Vision human body pose request](https://developer.apple.com/documentation/vision/vndetecthumanbodyposerequest) produces body-pose observations. It does not itself decide whether a pushup rep is valid; the app must define and test that state rule.
