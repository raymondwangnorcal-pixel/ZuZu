# Snoozy Design Review 1

## Product Principle

The sloth is a primary motivational feature, not decorative branding. It should remain prominent and communicate the user's current wake-up status, progress, and next useful action.

## Recommended Improvements

### 1. Strengthen the sloth status hero

- Keep the sloth prominent on the Home screen.
- Pair every visual state with a clear message and relevant action.
- Example: “Resting until 7:00” with an “Edit alarm” action.
- Show why the sloth is in its current state, such as completing a mission, protecting a streak, snoozing, or missing an alarm.
- Let the character visibly evolve with streaks, consistency, milestones, and missed goals.

### 2. Make the next alarm immediately actionable

- Place the next alarm directly beneath the sloth status hero.
- Show its time, countdown, mission, enabled state, and Edit action together.
- Remove duplicated alarm information elsewhere on the Home screen.
- Make contextual actions explicit. For example, replace “Move to 6:50” with “Change alarm to 6:50.”

### 3. Clarify the Home screen hierarchy

Use the following content order:

1. Sloth and motivational status
2. Next alarm and primary action
3. Contextual weather advice
4. Upcoming alarms

Add section headings so secondary cards do not appear equally important.

### 4. Rename “Count”

- Rename the tab and screen to “Progress” or “Stats.”
- “Count” sounds like a live counting tool, while the current screen presents historical totals, trends, averages, and milestones.

### 5. Simplify the bottom navigation

- Consider using four primary tabs: Home, Alarms, Progress, and Friends.
- Move Settings behind the profile or avatar.
- If Settings remains a tab, order the tabs according to usage frequency and product importance.

### 6. Use colors consistently

- Reserve red for risks, snoozes, penalties, destructive actions, and other negative states.
- Use the gold brand color or a neutral accent for normal totals and selected states.
- Avoid styling the total-pushups card in a way that resembles a warning.
- Ensure status meaning is not communicated through color alone.

### 7. Prioritize alarms over promotions

- Move the “Try the new squat mission” promotion below the alarm list or make it dismissible.
- Keep disabled alarm times and labels readable instead of fading all their content.
- Make alarm-card behavior predictable: tapping the card edits it, the toggle enables or disables it, and the overflow menu handles actions such as duplicate or delete.
- Move the add button so it does not overlap an alarm card or the bottom navigation.

### 8. Simplify alarm editing

- Replace the close icon with “Cancel” or a back button so the save and discard behavior is explicit.
- Replace the redundant Weekdays checkbox and individual day controls with Weekdays, Weekends, and Custom presets.
- Only show individual day selection when Custom is chosen.
- Rename “1/3” to “1 of 3 missions selected.”
- Use a more explicit action such as “Add mission” for empty mission slots.
- Collapse advanced settings such as sound, rep checking, and snooze penalties until the user needs them.
- Retain the fixed Save button, while ensuring it does not obscure scrollable content.

### 9. Focus Friends on social motivation

- Move “Friend rules” into Settings because they are personal preferences.
- Use the freed space for recent friend activity, shared challenges, or a leaderboard.
- Keep the streak visible, but reduce the card height so the friend list appears sooner.
- Rename “Invite” to “Invite friends” for clarity.

### 10. Reduce density on Progress

- Combine the three summary tiles and milestone into a more compact weekly summary.
- Keep the seven-day chart and its Today highlight.
- Visually distinguish positive progress, neutral statistics, and snooze penalties.
- Use a neutral or brand treatment for the lifetime total rather than a warning color.

### 11. Improve Settings organization

- Move Sign out to the bottom of the full page in a separated danger section.
- Keep notification controls grouped together.
- Retain chevrons for rows that open another screen and toggles for settings that change immediately.
- Use the profile row as the Settings entry point if Settings is removed from the bottom navigation.

## Highest-Priority Changes

If only a small first iteration is possible, prioritize these changes:

1. Strengthen the sloth status hero and connect it to a relevant action.
2. Reorganize Home around the sloth, next alarm, weather context, and upcoming alarms.
3. Rename Count to Progress or Stats.
4. Move Friend rules into Settings.
5. Establish consistent semantic color usage.
