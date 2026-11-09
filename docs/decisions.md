# Project Decisions

## DEC-0001 — Treat the sloth as a primary motivational status system

- Date: 2026-09-29
- Owner: user
- Status at record: active
- Decision: The sloth character and its current status will remain a primary, prominent element of the app experience rather than decorative secondary content.
- Rationale: The character is intended to motivate users by making their progress and current wake-up status emotionally engaging and immediately visible.
- Scope: Home-screen hierarchy, motivational feedback, status presentation, and future character-state interactions.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: Product clarification in the current Figma design review conversation.
- Privacy waivers: none

## DEC-0002 — Build pushup tracking as a standalone session

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: The initial pushup tracker lets a user start a session independently of an alarm.
- Rationale: The user selected a standalone session as the first build.
- Scope: Pushup tracker entry, counting, completion, and progress; alarm integration is outside the initial delivery.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0003 — Build the pushup tracker in SwiftUI

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: The pushup tracker will be built as a SwiftUI iOS feature.
- Rationale: The user specified SwiftUI as the implementation stack.
- Scope: Pushup tracker application architecture and screen implementation.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0004 — Include front camera rep counting in the first release

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: The first pushup tracker release must actually count repetitions with the front camera.
- Rationale: The user selected working camera counting for the initial release.
- Scope: Camera setup, on-device pose evaluation, live counting, and failure recovery.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0005 — Count clear down-and-up camera cycles

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: A camera-counted pushup requires a clear down-and-up movement cycle without initial depth or body-alignment enforcement.
- Rationale: The user selected motion counting as the first-release rep rule.
- Scope: Camera rep detection and live feedback.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0006 — Permit tap fallback and manual count correction

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: A user may switch from camera counting to tap counting and manually correct the session count.
- Rationale: Counting must remain usable when camera tracking is lost or inaccurate.
- Scope: Session state, counting controls, and recovery screen.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0007 — Ask whether to save a stopped partial session

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Stopping before the pushup target prompts the user to save or discard the partial session.
- Rationale: The user chose a decision at session end rather than automatic saving or discarding.
- Scope: Session completion flow and Progress persistence.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0008 — Create the iPhone app project in this repository

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Create the SwiftUI project in this repository with iOS 17 as the minimum and iPhone as the supported device family.
- Rationale: The user specified the project location and device target for the first release.
- Scope: Project setup, build configuration, and device testing.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0009 — Process camera frames only on the iPhone

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Process front-camera frames on-device without recording or uploading them.
- Rationale: The user confirmed the Figma privacy statement as a strict requirement.
- Scope: Camera capture, pose evaluation, logging, and data handling.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0010 — Include accepted reps from all counting modes in Progress

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Camera, tap, and manually corrected reps from saved sessions, including user-saved partial sessions, contribute to lifetime and seven-day Progress totals.
- Rationale: The user chose one combined total and chose to count saved partial results.
- Scope: Session persistence, lifetime total, and seven-day chart.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0011 — Keep the Figma target default and presets

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Default a standalone pushup session to 15 reps and offer 10, 15, 20, and 30-rep presets.
- Rationale: The user chose to keep the target controls shown in the Figma onboarding screen.
- Scope: Standalone Start Session target selection.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0012 — Show elapsed time and retain sloth motivation

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Show remaining reps with elapsed time in standalone sessions and retain the sloth race and streak celebration with adapted wording.
- Rationale: The user selected these counter and motivational elements for the standalone flow.
- Scope: Live counter, completion screen, and standalone copy.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0013 — Store first-release session history on the iPhone

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Store first-release pushup session history locally on the iPhone without account or cloud sync.
- Rationale: The user selected local-only history for the first release.
- Scope: Persistence and Progress data source.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0014 — Support all iOS 17-compatible iPhones

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Support any iPhone model that can run the app's iOS 17 minimum deployment target.
- Rationale: The user did not want a narrower iPhone model list.
- Scope: Camera prototype, compatibility, and release testing.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0015 — Require zero counting errors as the release target

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: No missed or false pushup counts are acceptable as a release target.
- Rationale: The user requires accurate front-camera rep counting.
- Scope: Camera detection, uncertainty handling, and release acceptance testing.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md; the finite validation matrix remains open.
- Privacy waivers: none

## DEC-0016 — Award streak days only for completed goals

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Only a session that reaches its selected rep goal can earn a streak day.
- Rationale: The user chose completed goals as the streak qualification rule.
- Scope: Session completion and streak calculation.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0017 — Stop counting at the selected goal

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Automatic and tap counting stop when a session reaches its selected rep goal.
- Rationale: The user does not want extra reps counted beyond the goal.
- Scope: Live counter and completion transition.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0018 — Pause counting and time during interruptions

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: A call, device lock, or app background transition pauses counting and elapsed time until the user resumes.
- Rationale: The user confirmed pausing both during interruptions.
- Scope: Session lifecycle and elapsed-time calculation.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0019 — Allow deletion but not editing of saved sessions

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Users may delete saved sessions but cannot edit their saved rep totals.
- Rationale: The user selected deletion as the only post-save modification.
- Scope: Local history and Progress recalculation.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0020 — Advance Snoozy alongside the user

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Snoozy's count in the standalone motivational race advances alongside the user's accepted rep count.
- Rationale: The user selected a race linked to live user progress.
- Scope: Live counter and sloth animation state.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0021 — Allow targets from five to one hundred reps

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: The pushup target stepper permits values from 5 through 100 reps.
- Rationale: The user selected a 5-to-100 target range beyond the existing presets.
- Scope: Standalone session target selection and validation.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0022 — Give the completed-goal streak one grace day

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: A completed-goal streak survives one missed calendar day, while saved partial sessions never earn streak credit.
- Rationale: The user selected one grace day and excluded partial sessions from streak qualification.
- Scope: Streak calculation and completion celebration.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0023 — Continue counting through uncertain camera observations

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: When camera observations are uncertain, keep counting and let the user correct the session count.
- Rationale: The user selected continuing with correction over pausing on uncertain frames.
- Scope: Camera detection feedback and in-session correction.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0024 — Add same-day sessions to daily and lifetime reps

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Later sessions on one calendar day add reps to the lifetime total and that day's seven-day chart bar, while the day counts once in day-based metrics and streaks.
- Rationale: The user confirmed totals and the chart should increase without creating another active day.
- Scope: Progress aggregation and streak calculation.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0025 — Reset the streak after two consecutive missed days

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: The completed-goal streak survives one missed calendar day and resets after two consecutive missed days.
- Rationale: The user confirmed the one-day grace rule.
- Scope: Streak calculation and completion celebration.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0026 — Review the goal count before saving

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Reaching the rep goal opens a review state where the user can correct the final count before the session is saved.
- Rationale: The user approved correction of a mistaken last rep without allowing counts beyond the target.
- Scope: Session completion and in-session correction.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0027 — Remove the three-stat row from Progress

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Remove the Best morning, Avg / morning, and From snoozes row from the Figma Progress screen while keeping its milestone card.
- Rationale: The user requested the entire three-stat row be removed but retained the milestone progression.
- Scope: Progress screen design and first-release statistics display.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning and the updated Figma Progress frame; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0028 — Use five-hundred-rep milestones

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Progress milestones occur at every 500 lifetime pushups.
- Rationale: The user chose a 500-rep sequence following the Figma example at 1,500.
- Scope: Progress milestone calculation and display.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker planning; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0029 — Restart sessions after app termination

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: If the app is closed or terminated before a session is saved, discard the in-progress session and start a new session on the next launch.
- Rationale: The user chose restart rather than recovery of an unfinished session.
- Scope: In-progress session lifecycle, relaunch flow, and local persistence.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification after adversarial review; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0030 — Open saved-session history from Progress

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Open Saved Sessions from a button on Progress and show each session's accepted reps, target, and local date and time without elapsed duration in the history row.
- Rationale: The user selected a Progress entry point and date/time rather than duration in the list.
- Scope: Progress navigation and saved-session history presentation.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification after adversarial review and the updated Figma history screen; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0031 — Confirm deletion from a visible session menu

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Expose Delete in a visible ellipsis menu on each saved-session row and require confirmation before removing the session.
- Rationale: The user selected a visible menu and confirmation for deletion.
- Scope: Saved-session history, deletion flow, and Progress recalculation.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification after adversarial review and the updated Figma deletion screens; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0032 — Attribute sessions to their completion day

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Assign a saved session’s reps and streak credit to the local calendar day on which that session finishes.
- Rationale: The user chose completion day for sessions crossing midnight.
- Scope: Daily aggregation and streaks.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0033 — Retain history with normal device backup

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Keep saved sessions locally until the user deletes them and allow normal iPhone backup to include the data.
- Rationale: The user chose indefinite local retention with device backup.
- Scope: Local persistence and backup policy.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0034 — Omit milestone time estimate

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Show the next 500-rep milestone and remaining reps without an estimated number of days.
- Rationale: The user chose omission until a trustworthy formula exists.
- Scope: Progress milestone card.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0035 — Allow manual workout pause

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Provide Pause and Resume controls during an active pushup session.
- Rationale: The user chose an explicit pause control.
- Scope: Session clock, camera counting, and session controls.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0036 — Allow correction until save

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Allow manual rep corrections at any point before a session is saved.
- Rationale: The user chose no correction time window for unfinished sessions.
- Scope: Counter and goal review.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0037 — Show uncertain tracking badge

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: While camera tracking is uncertain, keep the session running and show an amber Check count badge.
- Rationale: The user selected a visible uncertainty cue.
- Scope: Camera counter feedback.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0038 — Use standalone tracker copy

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Use Pushup session, reps to goal, Goal complete, and Done as the core standalone labels in place of alarm copy.
- Rationale: The user accepted the proposed standalone labels.
- Scope: Session and completion screens.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0039 — Set finite camera release gate

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Require zero missed or extra reps in ten fifteen-rep sessions per tested iPhone across bright and dim light and two placements, compared with manual ground truth.
- Rationale: The user selected the proposed finite camera test gate.
- Scope: Real-device camera validation and release.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0040 — Preserve local completion day

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Attribute saved reps and streak credit to the local calendar day shown on the iPhone when the session finishes, even if the device time zone changes later.
- Rationale: The user selected a stable completion day for travel.
- Scope: Saved session data, Progress, history, and streaks.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; ZuZu/Core/SessionRecord.swift.
- Privacy waivers: none

## DEC-0041 — Use iPhone 14 Plus for available camera validation

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Use an iPhone 14 Plus as the currently available physical device for the agreed camera-counting release test.
- Rationale: The user identified the physical model available for testing.
- Scope: Real-device camera validation.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; docs/pushup-tracker-plan.md.
- Privacy waivers: none

## DEC-0042 — Support every eligible iPhone model

- Date: 2026-09-30
- Owner: user
- Status at record: active
- Decision: Make the tracker usable on every iPhone model that can run the app's iOS 17 minimum, without a model allowlist or TrueDepth requirement; retain tap counting if camera access or capture is unavailable.
- Rationale: The user explicitly requested that iPhones of any model function with the tracker.
- Scope: Device eligibility, camera capture, and recovery behavior.
- Implementation: pending
- Recorded against HEAD: not applicable
- Supersedes: none
- Evidence: User clarification during pushup tracker implementation; ZuZu/App/CameraPoseTracker.swift.
- Privacy waivers: none
