# Camera-counting release check

## Required gate

For each tested iPhone, complete ten sessions with a target of 15 reps. Compare the app's count with a human's manual ground truth after every rep. **Pass only with zero missed reps and zero extra reps across all 150 reps per phone.** Corrective taps must not be used to make a camera run pass.

Use these ten runs so both placements and lighting conditions are covered:

| Lighting | Placement | Runs |
| --- | --- | ---: |
| Bright | Phone on floor about 3 feet away | 3 |
| Bright | Phone propped at low angle about 3 feet away | 2 |
| Dim | Phone on floor about 3 feet away | 3 |
| Dim | Phone propped at low angle about 3 feet away | 2 |

Fit the exerciser's upper body and arms in frame before each run. Include natural rep speeds and brief holds at the top and bottom. Record iPhone model, iOS version, lighting, placement, human count, app count, missed count, extra count, and any tracking-warning state. Do not save camera frames or video as part of this check.

The tracker has no iPhone model allowlist for devices running iOS 17 or later. Its front-camera path uses runtime hardware selection and capture-preset checks, and tap counting remains available if capture cannot run. The currently available physical test device is an iPhone 14 Plus. Passing the gate on that phone establishes observed camera-count accuracy only on that tested phone; additional models require their own ten-session runs before making the same accuracy claim for them.

## Functional checks on device

1. Start a camera session and complete exactly 15 reps. Confirm the counter stops at 15 and opens final review.
2. Correct the final rep down by one, resume, and perform a replacement rep. Confirm only one 15-rep result is saved.
3. Pause, lock the phone, return, and verify counting and elapsed time resume only after tapping Resume.
4. Step out of frame, return, and verify no rep is accepted from an incomplete observation. Check the amber warning and switch to tap counting.
5. Deny camera access and verify Settings recovery and the tap fallback.
6. Save a partial session, delete it through the visible menu, and confirm its reps leave Progress.

If any camera run fails, adjust the detector and rerun the entire ten-session matrix for each affected device before release.
