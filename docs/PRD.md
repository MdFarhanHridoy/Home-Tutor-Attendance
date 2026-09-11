# Home Tutor Attendance — Product Requirements Document (PRD)

**Document Version:** 1.1  
**Status:** Implementation-ready product specification  
**Target Platform:** Flutter mobile application (Android first; iOS-compatible architecture preferred)  
**Primary Development Environment:** VS Code + Kilo Code multi-agent/orchestrator workflow  
**Primary User:** A private/home tutor managing attendance for multiple students  
**Initial Scale:** ~4 students  
**Expected Scale:** Small personal workload, designed to support dozens of active students without redesign

**v1.1 Change Summary:** Added requirements — (1) all user data always stored locally, app fully offline, cloud backup/sync as a future feature; (2) week always starts on Friday; (3) weekly attendance cap per student with carry-over recovery of missed days; (4) dark theme for Version 1, light theme deferred to a future version.

**v1.2 Change Summary (2026-09-11, user-approved product amendment):** Simplified the routine model — (1) routine weekday selection is OPTIONAL; the routine is defined by "days per week" only, and the tutor may record attendance for any student on ANY calendar date; (2) the weekly attendance cap and carry-over mechanism are REMOVED — there is no per-week limit; (3) the monthly goal denominator is a FLAT `weekly_days × 4` for every month the student's teaching period overlaps (the start date within the month does not prorate it), superseding the weekday-occurrence calculation; (4) over-attendance displays uncapped, e.g. `14 / 12`. Where any older section (§10.6, §13 denominators, BR-10, AC-09/AC-14/AC-15/AC-22/AC-23, Edge Cases 5/6/9/11/12/13/14 in their cap/goal aspects) conflicts with this amendment, v1.2 supersedes. Unchanged: Friday-first calendar layout (BR-11), one-record-per-date-per-student, historical teaching/routine periods, six-month goal window with month-overlap visibility, dark-only theme, fully offline local data.

---

## 1. Product Overview

### 1.1 Product Name

Working name: **Home Tutor Attendance**

The product is a simple, fast attendance-management app for a home tutor who visits multiple students on different days of the week. The tutor currently maintains a manual routine and manually records which students were taught on which dates, then counts monthly attendance totals.

The app replaces that manual process with a **calendar-first attendance workflow**:

- The **monthly calendar is always the home screen**.
- Each calendar date displays the students taught on that date.
- Each student has an assigned color for fast visual recognition.
- Tapping a date opens its attendance details.
- A floating `+` action lets the tutor add already-created students to that date.
- Students can be removed from a date just as easily.
- A student/tuition record stores the recurring weekly routine and other details.
- A monthly attendance-goal screen summarizes the last 6 months, including the current month.
- Historical attendance remains available even when a student stops being currently taught.
- All user data is stored exclusively in a local on-device database; the app is fully offline. Cloud backup/sync is a planned future feature.
- The calendar week always starts on **Friday** (Fri–Thu teaching week).
- Weekly attendance per student is capped at the student's routine days per week, plus recoverable carry-over from missed weeks.
- Version 1 ships with a **dark theme**; a light theme is planned for a future version.

The app is intentionally designed around **minimal data entry and fast daily use** rather than a large school-management system.

---

# 2. Problem Statement

The tutor currently has to perform several manual tasks:

1. Remember each student's weekly visiting schedule.
2. Maintain a manual list/routine for each student.
3. Write down every date a student was taught.
4. Count monthly attended days manually.
5. Track whether a student is still currently being taught.
6. Recalculate monthly totals when attendance is added or removed.
7. Preserve historical information when a student leaves.
8. Respect each student's weekly visit limit while still recovering missed visits in later weeks.

This is error-prone and inefficient, especially as the student count grows.

### Product goal

Provide a personal attendance tool where the tutor can record attendance in **1–3 taps after opening a date**, while the app automatically calculates monthly totals and presents the information visually through a familiar calendar interface.

---

# 3. Goals and Success Criteria

## 3.1 Primary Goals

### G1 — Calendar-first attendance

The monthly calendar must be the default screen whenever the app opens.

### G2 — Fast attendance entry

A tutor should be able to:

`Open app → tap date → tap + → select student`

and have attendance saved immediately.

### G3 — Easy visual scanning

Student names shown under dates must use their assigned color, allowing the tutor to identify students quickly without opening each date.

### G4 — Automatic monthly calculation

The app must automatically calculate:

- actual attended days,
- scheduled/expected days,
- attendance ratio,
- progress relative to the student's routine.

### G5 — Historical accuracy

If a student stops being taught, the student's historical attendance must not disappear from previous months.

### G6 — Simple student management

Adding, viewing, editing, activating, and archiving a student/tuition record must be straightforward.

### G7 — Small, personal, fully offline product

The entire app must work without internet access because attendance entry is a personal local activity and must not depend on network availability.

Additional v1.1 requirements:

- All user data (the database) is **always stored locally on the device**.
- Version 1 is **fully offline**: no network calls, no accounts, no backend.
- A **cloud backup/sync system is a planned future feature**; the architecture must allow adding it later without ever moving the source of truth away from the local database.

---

# 4. Non-Goals for Version 1

The following are intentionally outside the MVP unless later requested:

- Student login/account system.
- Parent login/account system.
- Cloud-based multi-device synchronization (planned future feature — see Section 35; Version 1 stores all data locally and is fully offline).
- Online payment collection.
- Salary/income management.
- Automated messaging to students/parents.
- SMS/WhatsApp/Email integration.
- School/classroom management.
- Student grades/marks management.
- Exam management.
- GPS tracking.
- Facial recognition attendance.
- Automatic geolocation attendance.
- Complex reporting dashboards.
- Multi-user permissions.
- Light theme and theme switching (Version 1 ships dark-only; the light theme is planned for a future version).

The architecture should avoid blocking these features in the future, but they should not complicate Version 1.

---

# 5. Core Product Concepts

## 5.1 Student vs Tuition

For Version 1, one record can represent one **tuition assignment** for one student.

Recommended domain terminology:

- **Student:** The person being taught.
- **Tuition:** The tutor's teaching arrangement for that student.
- **Attendance:** A record that the tutor taught the student on a specific calendar date.
- **Routine:** The weekly recurring days assigned to that tuition.
- **Monthly Goal/Progress:** The student's actual attendance compared with the number of scheduled teaching days in a selected month.
- **Week:** A teaching week always runs **Friday through Thursday**.
- **Weekly Allowance:** The maximum number of attendance days a student may receive in one week: the routine's days-per-week plus any recoverable carry-over from missed earlier weeks (see Section 10.6).

A future version may support multiple tuition arrangements for the same student, but Version 1 should keep the UX simple.

---

# 6. User Stories

## 6.1 Student/Tuition Management

### US-01
As a tutor, I want to add a new student/tuition so that I can include them in attendance records.

### US-02
As a tutor, I want to specify how many days per week I visit a student so that expected monthly visits can be calculated.

### US-03
As a tutor, I want to choose exact weekdays for a student's routine so that the routine is clearly documented.

### US-04
As a tutor, I want to assign a custom color to each student so that calendar entries are easy to recognize.

### US-05
As a tutor, I want to mark a tuition as currently active/inactive so that the active student list stays accurate.

### US-06
As a tutor, I want to edit a student's information without losing historical attendance.

### US-07
As a tutor, I want to archive/stop a tuition without deleting historical data.

## 6.2 Attendance

### US-08
As a tutor, I want the current month calendar to appear immediately when I open the app.

### US-09
As a tutor, I want today's date to be visually highlighted.

### US-10
As a tutor, I want to tap any date to see which students I taught that day.

### US-11
As a tutor, I want to add a student to a date using a `+` button.

### US-12
As a tutor, I want to remove a mistakenly added attendance record.

### US-13
As a tutor, I want a date to show multiple student names when I taught multiple students on that day.

## 6.3 Monthly Progress

### US-14
As a tutor, I want to see the current month's attendance count for each currently active tuition.

### US-15
As a tutor, I want to see the previous five months as well, for a total of six months.

### US-16
As a tutor, I want a student who stopped teaching in September to remain visible for August history but not appear in September's active monthly list.

## 6.4 Weekly limits, recovery, and data storage (v1.1)

### US-17
As a tutor, I want the calendar week to start on Friday, so that weeks match my Friday-to-Thursday teaching cycle.

### US-18
As a tutor, I want the app to stop me from recording more attendance days in one week than a student's weekly routine allows, so that accidental over-recording cannot happen.

### US-19
As a tutor, I want missed days from one week to become recoverable carry-over, so that I can make up a missed visit in a later week without exceeding my real weekly capacity.

### US-20
As a tutor, I want all of my data saved locally on my device with the app working fully offline, so that I never depend on internet or a server.

### US-21
As a tutor, I want a dark-themed app now, with a light theme coming later.

---

# 7. Information Architecture

The app contains three primary navigation destinations plus a reserved future theme control:

1. **Home** — monthly calendar
2. **Students List** — active/inactive student/tuition records
3. **Monthly Attendance Goal** — six-month attendance overview
4. **Theme Toggle** — *future*; Version 1 is dark-only, so no toggle is shown in the drawer yet

Navigation is opened through a **hamburger menu in the top-left** of the home screen.

---

# 8. Navigation Structure

```text
App
└── Home (default)
    ├── Monthly Calendar
    │   └── Date Attendance
    │       └── Add Attendance
    │           └── Student Picker
    ├── Navigation Drawer
    │   ├── Home
    │   ├── Students List
    │   │   ├── Student Details
    │   │   └── Add/Edit Student
    │   ├── Monthly Attendance Goal
    │   └── Theme Toggle (future — Version 1 is dark-only)
    └── App Settings / Future
```

---

# 9. Screen Specifications

# 9.1 Home Screen — Monthly Calendar

## Purpose

Provide the main daily attendance workflow and act as the application's visual dashboard.

## Required behavior

- The home screen is always the monthly calendar.
- On first launch, show the current month.
- On reopening the app, show the current month unless the last navigation state is explicitly retained in a future version.
- Today's date must be highlighted.
- The calendar must show all dates in the current month.
- Dates belonging to the previous/next month may be shown in the calendar grid if needed for standard month-grid layout, but they must be visually secondary.
- The UI should visually resemble the simplicity and density of Samsung Calendar's monthly calendar experience.
- The experience should not require a full-screen custom dashboard before reaching dates.

## Header

Top app bar:

- hamburger menu icon on the left;
- current month + year prominently displayed;
- month navigation controls (previous/next) are recommended;
- a `Today` action is recommended when viewing another month.

Example:

```text
☰       September 2026                 ‹  ›

Fri   Sat   Sun   Mon   Tue   Wed   Thu
...
```

The calendar week **always starts on Friday** for Version 1: `Fri, Sat, Sun, Mon, Tue, Wed, Thu`. This is a fixed product rule (see BR-11) and must not depend on the device locale. Any future configurability must keep Friday as the default.

## Calendar grid

Each date cell should contain:

- date number;
- optional student attendance chips/rectangles;
- today's highlight;
- adequate touch target.

### Attendance item appearance

Each student entry under a date should appear as a compact rounded rectangle/chip using the student's assigned color.

Example:

```text
9
┌────────────┐
│ Student X  │
└────────────┘
┌────────────┐
│ Student B  │
└────────────┘
```

Requirements:

- Use student-specific color as the background or primary visual accent.
- Student name should remain readable.
- If possible, dynamically choose dark/light text based on color contrast.
- Prevent the layout from becoming unusably tall when many students are assigned to one date.
- For overflow, show a limited number of attendance chips and an indicator such as `+2 more`.
- Tapping the date should open the complete attendance list.

## Today's date

Today's cell must have a clear visual indicator. It should remain visible in both themes and must not rely on color alone.

Recommended visual treatment:

- subtle filled/outlined circle around the day number;
- secondary background tint for the whole cell;
- stronger border or accent.

The implementation should avoid over-styling every date.

## Calendar interactions

### Tap date

Open **Date Attendance Screen** for the selected date.

### Swipe month

Recommended behavior:

- swipe left → next month;
- swipe right → previous month.

Buttons should also be available for accessibility and discoverability.

### Month boundaries

Any number of months should be viewable unless the product later limits historical/future navigation.

---

# 9.2 Date Attendance Screen

## Purpose

Show and manage every attendance record for one calendar date.

## Example flow

```text
Today: 10 September

User taps 9 September
        ↓
Date Attendance Screen
        ↓
Shows students taught on 9 September
        ↓
User taps +
        ↓
Student Picker opens
        ↓
User selects Student X
        ↓
Student X is added immediately
```

## Header

Display:

- full date;
- optional weekday;
- back navigation to calendar.

Example:

```text
‹  Tuesday, 9 September 2026
```

## Attendance list

Each row/card should show:

- student color indicator;
- student name;
- optional routine indicator such as `Scheduled today` or `Not scheduled today`;
- remove action.

Example:

```text
● Student X                 Scheduled today
● Student B                 Scheduled today

                         +
```

## Important rule: manual attendance is allowed

The tutor must be able to add a student to any date, even if that date is not one of the student's scheduled weekdays.

Reason:

The routine represents an expectation or preferred schedule, not a hard validation rule. The user explicitly stated that any chosen three days can be used and that monthly minimum coverage is not mandatory.

Therefore:

- scheduled day ≠ mandatory attendance;
- unscheduled day ≠ invalid attendance;
- the app must not block attendance because of **which weekday** the date is.

The app may visually indicate whether a selected date is part of the routine, but it must not prevent the tutor from adding the attendance.

### Weekly count limit (v1.1)

The routine does not restrict **which** days may be used, but it does limit **how many** days per week can be used:

- attendance for one student in one Friday–Thursday week is capped at the student's `weekly_days` plus recoverable carry-over from missed earlier weeks;
- see Section 10.6 for the authoritative rule, formulas, and examples.

## Duplicate rule

A student can appear **at most once per date**.

Attempting to add a student already present on that date should:

- either prevent selection in the picker;
- or show `Already added`.

Do not create duplicate attendance records for the same student/date pair.

## Remove attendance

Removing attendance must require a clear user action.

Recommended:

- swipe-to-delete;
- delete/remove icon;
- optional confirmation for accidental deletion.

Deletion must not delete the student itself.

## Floating Action Button

A circular `+` FAB should appear at the bottom-right.

Tapping it opens the **Student Picker**.

---

# 9.3 Student Picker

## Purpose

Allow the tutor to add an existing student to the selected date.

## Required behavior

- Show created students.
- Prioritize currently active students.
- Students already added to the selected date should be disabled or filtered.
- Search should be included once the list becomes moderately large; it is recommended from Version 1 even with four students.
- Tapping a student adds attendance immediately or after a lightweight confirmation.

## Suggested UI

```text
Add attendance

Search students...

☐ Student A
☐ Student B
☐ Student C
☐ Student X (Already added)
```

The picker should close after selection if adding one student. A multi-select mode may be introduced later, but Version 1 can use single selection for maximum simplicity.

---

# 9.4 Navigation Drawer

## Purpose

Provide the primary navigation.

## Required items

```text
┌───────────────────────────────┐
│ Home                           │
│ Students List                  │
│ Monthly Attendance Goal        │
│                               │
│                               │
│ ----------------------------- │
│ Theme: dark (future toggle)   │
└───────────────────────────────┘
```

## Drawer requirements

- Hamburger icon always available on primary screens where applicable.
- Current route should be visually selected.
- The drawer bottom area is reserved for a future theme toggle; Version 1 shows none (dark-only).
- Drawer should close automatically after selecting a destination.

---

# 9.5 Students List Screen

## Purpose

Manage all student/tuition records.

## Header

Title: `Students`

Recommended top-level actions:

- search icon;
- add student button.

## Student list requirements

Each list item should show at least:

- student color indicator;
- student name;
- active/currently teaching status;
- routine summary, e.g. `3 days/week · Mon, Wed, Fri`;
- optional short note.

Example:

```text
● Student A
  3 days/week · Sun, Tue, Thu
  Currently teaching
```

## List grouping

Recommended:

### Currently teaching

Show active students first.

### Not currently teaching

Show inactive/archived students below, collapsed or visually secondary.

However, inactive students must remain accessible because their historical attendance may exist.

## Add Student FAB / button

The screen must provide a prominent `Add Student` action.

---

# 9.6 Add/Edit Student Screen

## Purpose

Create or edit a tuition/student record.

## User-facing fields

See detailed schema in Section 11.

Required core fields:

1. Student name
2. Weekly visit count
3. Exact routine weekdays
4. Student color
5. Currently teaching status

Recommended additional fields:

6. Start date
7. End date / stopped date
8. Address
9. Phone/contact
10. Guardian/contact name
11. Monthly target (optional)
12. Notes

The form should clearly distinguish mandatory and optional fields.

## Weekly visit count rules

The user described examples such as:

- 3 visits per week;
- choose any 3 weekdays.

Therefore:

```text
weeklyVisitDaysCount = number of selected weekdays
```

In Version 1, the simplest and safest rule is:

> The number of selected weekdays must exactly match the weekly visit count.

Example:

```text
Weekly days: 3
Selected: Sunday, Tuesday, Thursday
→ valid
```

If weekly days is `3` but only two weekdays are selected, saving should be blocked.

## Color picker

The tutor should be able to select a color.

Recommended UX:

- small palette of accessible predefined colors;
- optional custom color in a future version.

Color must be stored as data, not derived from list position, so it remains stable.

## Currently teaching

This checkbox/toggle indicates whether the tuition is active **now**.

Important: the checkbox alone is not sufficient to reconstruct historical month membership. The data model must also preserve active-period history through start/end dates or an equivalent status history mechanism.

Recommended UI:

```text
Currently teaching       [ ON ]
```

When switched OFF:

- ask for stopped date if not already known;
- default stopped date to today;
- preserve all previous attendance records.

When switched ON again:

- allow a new effective start date or default to today;
- do not overwrite prior inactive periods.

---

# 9.7 Student Details Screen

## Purpose

Provide a readable view of a student's tuition details and historical attendance context.

## Display

- student name;
- color;
- current status;
- weekly days/week;
- selected weekdays;
- teaching start date;
- teaching end date if inactive;
- contact information if present;
- notes;
- recent attendance summary;
- edit action.

## Recommended sections

```text
Student A
● Currently teaching

Routine
3 days/week
Sun · Tue · Thu

Started
1 August 2026

Contact
...

Notes
...

Recent attendance
August: 8/10
September: 10/12
```

---

# 9.8 Monthly Attendance Goal Screen

## Purpose

Show monthly attendance performance for the latest six months, including the current month.

## Time window

Always display exactly **six calendar months**:

```text
Month 1 = current month
Month 2 = previous month
...
Month 6 = five months ago
```

Example in September 2026:

- September 2026
- August 2026
- July 2026
- June 2026
- May 2026
- April 2026

## Month sections

Each month shows the relevant students and attendance progress.

Example:

```text
September 2026

Student B                 10 / 12
██████████░░

Student C                 12 / 12
████████████

August 2026

Student A                  8 / 10
████████░░

Student B                 12 / 12
████████████
```

## Critical historical-status requirement

A student's display in a month must be determined from whether that tuition was active during that month—not merely from its current checkbox state.

This is necessary to satisfy the example:

- August: A and B were active → A and B appear.
- September: A stopped, B continued, C started → A does not appear; B and C appear.
- Opening August later must still show A.

Therefore, the underlying data must preserve effective teaching periods.

## What does `8/10` mean?

The recommended interpretation is:

```text
Actual attended days / Scheduled routine days in that month
```

Where:

- **Actual attended days** = count of unique attendance records for the student in the month.
- **Scheduled routine days** = count of weekday occurrences in that month that fall within the student's active teaching period and match their selected routine weekdays.

Example:

Student A:

- routine = 3 days/week;
- 10 scheduled weekday occurrences in August;
- attendance entered = 8 dates;
- display = `8/10`.

The denominator must not simply be `weeklyVisitCount × 4`, because calendar months have different numbers of weekday occurrences.

## Attendance above scheduled amount

It is valid for actual attendance to exceed the scheduled count because the tutor may teach on unscheduled days.

Example:

```text
Scheduled = 10
Attended = 12
Display = 12/10
```

The UI may show `12 / 10` and optionally a small label such as `120%`.

The app must not cap the **monthly display** at the scheduled amount.

Note (v1.1): exceeding the schedule is only possible through the weekly carry-over/recovery mechanism (Section 10.6). Weekly entry is validated per week; the monthly screen simply displays the resulting totals.

## Students shown for each month

Recommended rule:

A student appears when their teaching period overlaps that month.

For a complete day-level model, calculate monthly active overlap as:

```text
activeFrom <= monthEnd
AND
(activeTo IS NULL OR activeTo >= monthStart)
```

Then only scheduled occurrences inside the overlap window contribute to the denominator.

### Why this is important

If a student starts on September 15, the denominator should not count September 1–14 scheduled days.

Similarly, if a student stops on September 10, scheduled days after September 10 should not be counted.

## Zero-attendance case

If a student was active during a month but attendance is zero:

```text
0 / 12
```

The student should still appear in that month.

## Empty month

If there were no active students in a month, show:

`No active tuition records for this month.`

---

# 10. Attendance Logic

## 10.1 Attendance Record Definition

One attendance record represents:

> One student was taught on one specific date.

Primary uniqueness constraint:

```text
(studentId, attendanceDate)
```

must be unique.

## 10.2 Attendance Date

Store attendance dates as a calendar date rather than a timestamp where possible.

Recommended conceptual type:

```text
LocalDate / YYYY-MM-DD
```

Do not make attendance calculations dependent on timezone-sensitive UTC timestamps.

### User timezone context (note for implementation)

The primary user is based in Bangladesh (GMT+6, Asia/Dhaka). Consequences:

- "Today" (today's date highlight, default selected date) must resolve from the device's local time — on the user's device this is Bangladesh time — with no timezone hardcoded into the app.
- All business dates remain plain calendar dates (`YYYY-MM-DD`), so no timezone conversion is ever applied to attendance, teaching-period, or routine dates.
- Future features that schedule or display instants (reminder notifications, cloud sync, exports) must account for GMT+6 / Asia/Dhaka.

## 10.3 Manual Attendance Rule

The tutor controls actual attendance.

The routine only provides expected/scheduled days for monthly comparison.

The system must never automatically mark a student as attended just because the weekday matches the routine.

## 10.4 Past and Future Dates

Recommended behavior:

- past dates: fully editable;
- today: fully editable;
- future dates: allowed if the tutor wants to pre-plan attendance, but Version 1 should clearly distinguish planned entries from completed attendance if future attendance is supported.

Simpler Version 1 option:

Only allow actual attendance for today and past dates. Future-date support can be enabled later.

Because the user's main workflow is recording completed teaching, this is the recommended MVP rule.

## 10.5 Cross-month handling

Attendance belongs to its exact calendar date, so monthly totals should be derived dynamically from attendance records.

No manual monthly counter should be stored as authoritative data.

## 10.6 Weekly attendance cap and carry-over recovery (v1.1)

This subsection is the authoritative rule for how many attendance days a student may receive per week. It exists because the tutor sometimes misses a day in one week and recovers it in the following weeks; over-attendance beyond that recovery must not be possible.

### Week definition

A week always runs **Friday through Thursday** (BR-11), independent of calendar months. A week may span two calendar months; the cap still applies to the whole Friday–Thursday window.

### Base weekly allowance

```text
weekAllowance(week) = student.weekly_days
```

For a week in which the student's teaching period starts or ends mid-week, prorate:

```text
weekAllowance(week) = min(weekly_days,
                          routine-weekday occurrences inside the active part of that week)
```

### Carry-over (recovery of missed days)

```text
deficit(week)     = max(0, weekAllowance(week) - attended(week))
carryOver(next)   = carryOver(current) + deficit(current)
```

Rules:

- carry-over accrues only from weeks in which the student was actively being taught;
- carry-over does not expire while the student remains active;
- carry-over resets to 0 whenever the student is marked as not currently teaching;
- a re-activated student starts with 0 carry-over.

### Maximum attendance per week

```text
maxAttendance(week) = weekAllowance(week) + carryOver(week)
```

- The app must prevent adding attendance that would exceed `maxAttendance(week)` for that student and show the weekly-limit message (Section 18).
- Attendance on a non-routine weekday is allowed but still consumes the weekly allowance/carry-over.

### Example

```text
Student A: weekly_days = 3

Week 1 (Fri-Thu): allowed 3, attended 2  -> deficit 1
Week 2 (Fri-Thu): allowed 3 + 1 = 4, attended 4 -> deficit 0
Week 3 (Fri-Thu): allowed 3 again
```

The tutor can recover a missed visit in a later week but can never exceed the routine rate except by consuming carry-over.

---

# 11. Data Model / Database Schema

The schema is designed to support the user's current requirements while preserving historical correctness.

## 11.1 Recommended Tables / Entities

```text
students
teaching_periods
attendance_records
app_settings
```

A separate `teaching_periods` table is strongly recommended because a simple `currentlyTeaching` boolean cannot preserve status changes over time.

---

## 11.2 `students` Entity

| Field | Type | Required | Nullable | Default | Description |
|---|---|---:|---:|---|---|
| id | UUID/String | Yes | No | generated | Unique student/tuition ID |
| name | String | Yes | No | — | Student name |
| weekly_days | Integer | Yes | No | — | Number of routine days per week |
| color | String | Yes | No | generated palette color | Stored color value |
| currently_teaching | Boolean | Yes | No | true for new student | Current status toggle |
| start_date | Date | Yes | No | today | Initial teaching start date |
| phone | String | No | Yes | null | Student/guardian phone |
| guardian_name | String | No | Yes | null | Guardian/contact name |
| address | String | No | Yes | null | Student location/address |
| notes | String | No | Yes | null | Free-form notes |
| created_at | DateTime | Yes | No | now | Record creation timestamp |
| updated_at | DateTime | Yes | No | now | Last modification timestamp |
| archived_at | DateTime | No | Yes | null | Optional soft-archive timestamp |

### Validation

`name`

- required;
- trimmed;
- minimum 1 non-whitespace character;
- recommended maximum 100 characters.

`weekly_days`

- required;
- integer;
- allowed range: 1–7;
- must equal the number of selected weekdays.

`color`

- required;
- valid hexadecimal/ARGB representation;
- must be stable after creation unless user changes it.

`currently_teaching`

- required;
- boolean;
- cannot be null.

`start_date`

- required;
- valid local calendar date.

Optional fields may be null and should not use fake placeholder strings such as `N/A` in the database.

---

## 11.3 `teaching_periods` Entity

This entity preserves historical status changes.

| Field | Type | Required | Nullable | Default | Description |
|---|---|---:|---:|---|---|
| id | UUID/String | Yes | No | generated | Unique period ID |
| student_id | UUID/String | Yes | No | — | FK → students.id |
| start_date | Date | Yes | No | — | First active teaching date |
| end_date | Date | No | Yes | null | Last active teaching date; null means ongoing |
| created_at | DateTime | Yes | No | now | Creation timestamp |
| updated_at | DateTime | Yes | No | now | Modification timestamp |

### Rules

- `start_date` is required.
- `end_date` may be null for an active/open period.
- If `end_date` exists, it must be greater than or equal to `start_date`.
- A student should normally have non-overlapping teaching periods.
- When the `currently_teaching` switch changes from ON → OFF, close the current open period.
- When OFF → ON, create a new teaching period.
- Never erase old periods simply because the current status changed.

### Why not store only `start_date` and `end_date` on `students`?

Because a student could leave and later return.

Example:

```text
A: Jan 1 – Mar 15
A: Apr 20 – Jun 30
A: Aug 1 – ongoing
```

A history table can represent this correctly.

---

## 11.4 Routine Weekdays Entity

Two reasonable designs exist.

### Recommended MVP design

Store routine weekdays as a serialized list/JSON field on `students`:

```text
routine_weekdays = [0, 2, 4]
```

where enum values represent weekdays.

Suggested enum:

```text
0 = Monday
1 = Tuesday
2 = Wednesday
3 = Thursday
4 = Friday
5 = Saturday
6 = Sunday
```

Field definition:

| Field | Type | Required | Nullable |
|---|---|---:|---:|
| routine_weekdays | List<Integer> / JSON | Yes | No |

Rules:

- must contain at least 1 day;
- must contain no duplicates;
- length must equal `weekly_days`;
- values must be 0–6.

For a relational database implementation, a separate `student_routine_days` table is also acceptable, but it is unnecessary complexity for a small local personal app unless the chosen database benefits from it.

---

## 11.5 `attendance_records` Entity

| Field | Type | Required | Nullable | Default | Description |
|---|---|---:|---:|---|---|
| id | UUID/String | Yes | No | generated | Unique attendance ID |
| student_id | UUID/String | Yes | No | — | FK → students.id |
| attendance_date | Date | Yes | No | — | Date student was taught |
| created_at | DateTime | Yes | No | now | Creation time |
| updated_at | DateTime | Yes | No | now | Last modification time |
| note | String | No | Yes | null | Optional attendance note |

### Required uniqueness

Create a unique database constraint/index on:

```text
student_id + attendance_date
```

This prevents duplicate attendance entries for the same student on the same day.

---

## 11.6 `app_settings` Entity

| Field | Type | Required | Nullable | Default | Description |
|---|---|---:|---:|---|---|
| id | Integer/String | Yes | No | fixed singleton | Settings row identifier |
| theme_mode | Enum | Yes | No | dark | Theme preference; Version 1 is always `dark`; `light`/`system` reserved for future |
| first_day_of_week | Enum | Yes | No | friday | Calendar week start; **fixed to Friday** in Version 1 (BR-11) |
| created_at | DateTime | Yes | No | now | Creation timestamp |
| updated_at | DateTime | Yes | No | now | Last modification timestamp |

For MVP, theme setting is mandatory data but can be stored in simple local key-value storage instead of a relational table.

---

# 12. Nullability / Mandatory Field Matrix

## Student form

### Mandatory

- Student name
- Weekly visit count
- Routine weekdays
- Student color
- Currently teaching
- Teaching start date

### Optional / Nullable

- Phone number
- Guardian name
- Address
- Notes
- Archived timestamp

## Attendance form

### Mandatory

- Student ID
- Attendance date

### Optional / Nullable

- Attendance note

## Teaching period

### Mandatory

- Student ID
- Start date

### Optional / Nullable

- End date

## General rule

Do not store an empty string where `null` correctly expresses "no value".

Example:

```text
phone = null
```

is preferable to:

```text
phone = ""
```

---

# 13. Monthly Calculation Specification

This section is the authoritative business logic for monthly attendance goals.

## 13.1 Inputs

For each student and month:

- month start date;
- month end date;
- teaching periods;
- routine weekdays;
- attendance records.

## 13.2 Active dates

The effective teaching date range for a month is:

```text
effectiveStart = max(monthStart, teachingPeriod.startDate)
effectiveEnd   = min(monthEnd, teachingPeriod.endDate if present)
```

If:

```text
effectiveStart > effectiveEnd
```

then that teaching period contributes nothing to the month.

## 13.3 Scheduled-day calculation

For every date between `effectiveStart` and `effectiveEnd` inclusive:

```text
if weekday(date) is in routineWeekdays:
    scheduledCount += 1
```

If a student has multiple non-overlapping teaching periods in the same month, add scheduled occurrences from all periods.

## 13.4 Actual attendance calculation

Query all attendance records satisfying:

```text
studentId = X
AND attendanceDate >= monthStart
AND attendanceDate <= monthEnd
```

Count unique dates.

Because the database enforces uniqueness, normally:

```text
actualCount = number of records
```

## 13.5 Display value

```text
attendanceDisplay = "actualCount / scheduledCount"
```

Example:

```text
8 / 10
12 / 12
10 / 12
```

## 13.6 Percentage

Recommended supporting calculation:

```text
percentage = actualCount / scheduledCount * 100
```

If `scheduledCount = 0`, percentage should be undefined rather than divide-by-zero.

UI recommendation:

```text
—
```

or

```text
No scheduled days
```

## 13.7 Current-month partial progress

Do not treat future scheduled days in the current month as missed attendance.

For current month progress, the primary ratio may still display against the month's full schedule, e.g. `8/12`, but the UI should avoid misleading language such as `4 missed` while the month is still in progress.

Recommended optional label:

`8 attended · 4 upcoming`

or simply show `8/12` without a failure indicator.

## 13.8 Attendance exceeding schedule

If actual > scheduled:

```text
12 / 10
```

is valid.

This represents extra visits made by consuming carry-over from missed weeks (Section 10.6). Weekly validation is enforced at entry time per Friday–Thursday week; the monthly display shows the resulting totals without capping.

---

# 14. Important Business Rules

## BR-01 — Routine weekdays are not a hard restriction

The tutor can add attendance on any valid date regardless of the routine **weekdays**. The routine limits only the **number** of days per week (BR-10), not which weekdays may be used.

## BR-02 — One attendance per student per date

Duplicate attendance for the same student/date is prohibited.

## BR-03 — Inactivation never deletes history

Turning `currently teaching` off does not delete attendance.

## BR-04 — Historical monthly data uses historical status

A student's current active status must not rewrite past month membership.

## BR-05 — Monthly denominator uses calendar occurrences

Scheduled count must be calculated from actual weekday occurrences inside the active teaching period, not from a fixed 4-week multiplier.

## BR-06 — Partial months are prorated naturally

If teaching starts or ends during a month, only the relevant active dates count toward scheduled days.

## BR-07 — Color belongs to the student

Changing a student color changes the visual display globally going forward and historically unless a future snapshot-color system is explicitly introduced.

## BR-08 — Deleting a student is dangerous

A hard delete should not be the normal UX because it can destroy attendance history.

Preferred behavior:

`Archive / Stop Teaching`

rather than deleting.

## BR-09 — Offline-first, local-always

Core create/read/update/delete operations must work without internet.

All user data is always stored in a local on-device database. Version 1 is fully offline with no backend. Cloud backup/sync is a future feature and must never become a requirement for using the app.

## BR-10 — Weekly attendance cap with carry-over recovery

For each student, attendance in one Friday–Thursday week must not exceed the student's `weekly_days` plus recoverable carry-over from missed previous weeks (Section 10.6).

## BR-11 — Week starts on Friday

Every weekly calculation, calendar layout, and allowance window uses Friday as the first day of the week.

## BR-12 — Dark theme in Version 1

Version 1 is developed with a dark theme only. Light theme and the drawer theme toggle are future work; the data model already reserves `theme_mode` values.

---

# 15. CRUD Requirements

## Create Student

The tutor can create a new student by entering:

- name;
- weekly visit count;
- routine weekdays;
- color;
- current teaching status;
- optional details.

On save:

1. validate fields;
2. create student;
3. create initial teaching period if currently teaching;
4. return to student list or show details based on UX choice;
5. make the new student immediately available in the attendance picker.

## Read Student

The tutor can view all details from the student list.

## Update Student

The tutor can modify:

- name;
- weekly days;
- routine weekdays;
- color;
- current status;
- optional information.

Historical attendance must remain intact.

## Delete/Archive Student

Default action should be `Stop Teaching` or `Archive`.

Hard delete, if provided at all, should require explicit confirmation and should clearly warn that attendance history may be affected.

Recommended MVP: no hard-delete UI.

---

# 16. UX Flow Specifications

# 16.1 Add a new student

```text
Students List
    ↓
Add Student
    ↓
Enter Student Name
    ↓
Select Weekly Days = 3
    ↓
Select Sun + Tue + Thu
    ↓
Choose Color
    ↓
Currently Teaching = ON
    ↓
Optional details
    ↓
Save
    ↓
Student appears in list and picker
```

# 16.2 Record today's attendance

```text
Open app
    ↓
Home calendar
    ↓
Tap today's date
    ↓
Date Attendance
    ↓
Tap +
    ↓
Choose Student A
    ↓
Attendance saved
```

# 16.3 Record yesterday's attendance

```text
Home
    ↓
Tap yesterday's date
    ↓
Date Attendance
    ↓
Tap +
    ↓
Select Student X
    ↓
Saved
```

# 16.4 Remove incorrect attendance

```text
Home
    ↓
Tap date
    ↓
Find student
    ↓
Remove
    ↓
Optional confirmation
    ↓
Attendance deleted
    ↓
Calendar + monthly totals update immediately
```

# 16.5 Stop teaching a student

```text
Student Details
    ↓
Currently Teaching = OFF
    ↓
Choose/confirm stopped date
    ↓
Close active teaching period
    ↓
Student remains in history
    ↓
Student disappears from future active picker priority
```

# 16.6 Start teaching an existing inactive student again

```text
Student Details
    ↓
Currently Teaching = ON
    ↓
Choose effective start date
    ↓
Create new teaching period
    ↓
Student becomes active again
```

# 16.7 Recover a missed day in a later week (v1.1)

```text
Student A: weekly_days = 3

Week 1 (Fri-Thu)
    ↓
Only 2 attendances recorded → 1 day missed, 1 carry-over
    ↓
Week 2 (Fri-Thu)
    ↓
Open a date → + → Student A
    ↓
App allows up to 4 attendances this week (3 + 1 carry-over)
    ↓
4th attendance consumes the recovered day
    ↓
5th attendance attempt is blocked with a weekly-limit message
```

---

# 17. Empty States

## No students

Home calendar:

```text
No students added yet.
Go to Students and add your first student.
```

Students List:

```text
No students yet.
+ Add Student
```

Monthly Goal:

```text
No tuition records found for this period.
```

## Date with no attendance

```text
No students recorded for this date.

+ Add attendance
```

## No scheduled days

```text
No scheduled routine days in this period.
```

---

# 18. Error Handling

## Validation errors

Errors should be shown near the relevant field.

Examples:

```text
Student name is required.
Select at least one weekday.
Select exactly 3 weekdays for a 3-day routine.
Weekly visit count must be between 1 and 7.
```

## Weekly limit reached (v1.1)

Recommended messages:

```text
Weekly limit reached: Student A allows 3 visits this week.

Weekly limit reached: Student A allows 3 visits per week.
Recoverable from missed earlier weeks: 1.
```

The message should state the weekly allowance and, when relevant, the remaining recoverable carry-over.

## Duplicate attendance

Recommended message:

`Student A is already marked present for this date.`

## Database/save failure

Show a non-destructive error message and keep entered form data where possible.

## Invalid date ranges

Prevent:

```text
end date < start date
```

---

# 19. Theme Requirements

## Version 1: dark theme (v1.1)

Version 1 is developed with a **dark theme only**. Every screen must be designed and tested against the dark theme first.

The dark theme must be a true dark theme rather than simply inverting colors:

- readable calendar dates;
- readable student chips;
- sufficient contrast;
- no overly bright backgrounds that cause eye strain;
- maintain student color identity while adapting foreground text for contrast.

No theme toggle is shown in the navigation drawer in Version 1.

## Future: light mode

A light theme is planned for a future version and should feel like a modern Samsung/Android productivity app:

- clean white/light surfaces;
- clear hierarchy;
- restrained borders;
- readable typography;
- strong touch targets.

## Theme persistence

Theme choice must persist after app restart.

Stored values (`dark` is the only active value in Version 1):

```text
system
light
 dark
```

Version 1 is fixed to `dark` (v1.1). The user plans to add a light theme later; when it ships, the drawer toggle can expose `light`/`dark`/`system` using the already-stored setting.

---

# 20. Accessibility Requirements

Although this is a personal app, basic accessibility should be built in from the beginning.

Requirements:

- minimum comfortable touch targets;
- semantic labels for icons;
- sufficient text contrast;
- color must not be the only way to distinguish today's date or actions;
- student names must remain visible in chips;
- support system font scaling without severe clipping;
- keyboard navigation should not break forms where applicable.

Color-based attendance chips should always contain the student's name so meaning does not depend on color perception.

---

# 21. Performance Requirements

The expected data volume is small, but UI operations should still be efficient.

Target expectations:

- app launch should feel immediate on a normal modern Android device;
- month navigation should not visibly lag;
- attendance add/remove should update the UI immediately;
- monthly summary should calculate quickly for dozens of students and several years of attendance;
- database queries should be indexed appropriately.

Recommended indexes:

```text
attendance_records(student_id, attendance_date)
attendance_records(attendance_date)
teaching_periods(student_id, start_date, end_date)
```

---

# 22. Persistence / Offline Architecture

## Recommendation

Use a local persistent database for all core app data.

Suitable Flutter choices include:

- Drift;
- Isar;
- SQLite through a well-maintained Flutter abstraction.

For this use case, **Drift + SQLite** is a strong choice when relational constraints and explicit SQL-style queries are valuable.

The final technology choice should be made by the implementation agent based on current Flutter package compatibility and the project's coding standards.

## Local-always requirement (v1.1)

- All user data (the database) is **always stored locally on the device** — this remains true even after the future cloud backup/sync feature exists; the local database stays the source of truth.
- The app is **fully offline** in Version 1: no network calls, no accounts, no backend.
- Attendance creation must not require internet access.
- No mandatory backend should exist in Version 1.
- The repository layer must be designed so a future cloud backup/sync system can be added without rewriting the UI or moving data off-device.

---

# 23. Recommended Flutter Architecture

The PRD does not mandate one architecture, but the implementation should be modular and testable.

Recommended layering:

```text
Presentation
    ↓
Application / State Management
    ↓
Domain
    ↓
Data / Repository
    ↓
Local Database
```

Possible feature modules:

```text
lib/
├── core/
│   ├── theme/
│   ├── routing/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── calendar/
│   ├── attendance/
│   ├── students/
│   ├── monthly_goal/
│   └── settings/
│
├── data/
│   ├── database/
│   ├── models/
│   └── repositories/
│
└── main.dart
```

State-management technology may be Riverpod, Bloc/Cubit, Provider, or another appropriate modern Flutter approach. Prefer the option with the best maintainability and testability for the project team.

---

# 24. Suggested Domain Models

## Student

```dart
class Student {
  final String id;
  final String name;
  final int weeklyDays;
  final List<int> routineWeekdays;
  final String color;
  final bool currentlyTeaching;
  final DateTime startDate;
  final String? phone;
  final String? guardianName;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
}
```

## TeachingPeriod

```dart
class TeachingPeriod {
  final String id;
  final String studentId;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

## AttendanceRecord

```dart
class AttendanceRecord {
  final String id;
  final String studentId;
  final DateTime attendanceDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? note;
}
```

The code above is illustrative domain modeling, not a mandated implementation.

---

# 25. Calendar Rendering Requirements

The calendar is the most important UI component in the product.

## Date cell hierarchy

Recommended priority:

1. date number;
2. today indicator;
3. attendance chips;
4. overflow count.

## Dense date handling

When many students exist:

- keep the date number visible;
- show the first N students according to available vertical space;
- show `+N more` for additional records;
- do not let one day expand the entire month grid excessively.

## Student chip rules

Each chip should:

- display student name;
- use student's assigned color;
- truncate long names safely;
- preserve sufficient contrast;
- be tappable through the parent date cell even if the chip itself is not independently clickable.

---

# 26. Samsung Calendar-Inspired UX Requirements

The product should take **interaction and information-density inspiration** from Samsung Calendar's monthly calendar experience rather than becoming a visually unrelated generic calendar.

The following characteristics should be prioritized:

- month calendar is the dominant content;
- top-level navigation is compact;
- current date is visually obvious;
- dates are presented in a familiar seven-column grid;
- events/attendance appear directly inside date cells;
- tapping a day opens its detailed schedule/attendance;
- screens feel native to Android;
- actions such as adding attendance are accessible without deep navigation.

Avoid copying proprietary artwork, exact icons, or branding. Build an original implementation that follows the same usability pattern.

---

# 27. Date Attendance UX Inspired by Google Calendar

The date details screen should follow the familiar interaction model of a calendar day/details screen:

- clear date title;
- chronological/simple list of entries;
- obvious add action;
- easy back navigation;
- no unnecessary forms for selecting an existing student.

The goal is familiarity, not pixel-by-pixel duplication.

---

# 28. Monthly Goal UX Details

## Layout

A vertically scrollable screen containing six month sections.

Each month section should include:

- month heading;
- students active in that month;
- ratio `actual/scheduled`;
- optional progress visualization.

## Suggested visual hierarchy

```text
September 2026

┌─────────────────────────────────────┐
│ Student B                    10/12  │
│ ██████████░░                        │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ Student C                    12/12  │
│ ████████████                        │
└─────────────────────────────────────┘
```

Progress bars are optional but strongly recommended for quick scanning.

## Color in monthly goal

Use the student's assigned color as a small accent or icon rather than filling the entire progress bar with potentially low-contrast colors.

---

# 29. Search Requirements

## Student search

Student list and student picker should support name search.

Search should be case-insensitive.

Search should handle partial names.

Example:

`stu` → `Student X`

For only four students this is not critical, but implementing it early prevents a future redesign.

---

# 30. Sorting Rules

## Student list

Default order:

1. currently teaching students;
2. alphabetically by name inside active group;
3. inactive students below;
4. alphabetically inside inactive group.

Alternative future sorting can be added.

## Attendance list

Primary sort:

- student name alphabetical.

Because attendance records on a single day do not represent a time of visit in Version 1, chronological sorting is not meaningful.

---

# 31. Editing Routine History — Important Product Decision

Changing a student's routine today can affect how the app interprets historical months.

### Recommended MVP rule

The routine attached to the student should represent the current routine, but historical monthly calculations require routine history to be preserved for complete historical accuracy.

There are two implementation levels:

### Level A — Simple MVP

Assume routine changes only apply going forward, and when the routine is edited, create a new routine-effective period.

### Level B — Fully historical model (recommended architecture)

Create a `routine_periods` entity:

```text
routine_periods
- id
- student_id
- start_date
- end_date
- weekly_days
- routine_weekdays
```

Then monthly scheduled counts use the routine that was effective on each date.

For an app expected to be used over years, **Level B is the more robust design**.

---

# 32. Recommended Extended Schema for Historical Accuracy

If implementing the more durable model, use:

```text
students
teaching_periods
routine_periods
attendance_records
app_settings
```

## `routine_periods`

| Field | Type | Required | Nullable | Description |
|---|---|---:|---:|---|
| id | UUID/String | Yes | No | Unique routine period |
| student_id | UUID/String | Yes | No | Related student |
| start_date | Date | Yes | No | Routine effective date |
| end_date | Date | No | Yes | Routine end date |
| weekly_days | Integer | Yes | No | Expected visits per week |
| weekdays | List/JSON | Yes | No | Selected weekdays |
| created_at | DateTime | Yes | No | Created timestamp |
| updated_at | DateTime | Yes | No | Updated timestamp |

This approach means a student can have:

```text
Jan–Mar: 3 days/week
Apr–Jun: 2 days/week
Jul–ongoing: 4 days/week
```

without corrupting historical monthly calculations.

---

# 33. Recommended MVP Scope for Version 1

## Must Have

### Navigation

- [x] Home
- [x] Students List
- [x] Monthly Attendance Goal
- [x] Dark theme (light theme toggle is future work — v1.1)

### Students

- [x] Create student
- [x] View students
- [x] Edit student
- [x] Active/inactive status
- [x] Weekly number of days
- [x] Exact weekdays
- [x] Color
- [x] Optional notes/contact details

### Attendance

- [x] Monthly calendar
- [x] Today's highlight
- [x] Tap date to open details
- [x] Add attendance via plus button
- [x] Select existing student
- [x] Remove attendance
- [x] Multiple students per date
- [x] Student color chips
- [x] Duplicate prevention
- [x] Weekly attendance cap with carry-over recovery (v1.1)
- [x] Friday week start (v1.1)

### Monthly goal

- [x] Current month + previous five months
- [x] Actual/scheduled count
- [x] Historical active-student handling
- [x] Partial-month calculation

### Persistence

- [x] Local database (data always on-device — v1.1)
- [x] Fully offline use, no network dependency
- [x] Persistent theme setting (dark in Version 1)

---

# 34. Version 1 Optional Features

These may be implemented if time allows without delaying the core product:

- month swipe gestures;
- `Today` shortcut;
- student search;
- progress bars;
- attendance note;
- start/end date picker;
- light theme and system theme option (future; Version 1 is dark-only);
- export attendance as CSV/PDF;
- backup/restore local database.

---

# 35. Future Features

Potential later improvements:

- cloud backup/sync (planned future feature — the local database remains the source of truth);
- light theme and drawer theme toggle;
- Google Drive backup;
- multiple devices;
- biometric app lock;
- monthly income calculation;
- payment tracking;
- reminder notifications;
- planned future attendance;
- automatic reminder based on routine;
- attendance statistics;
- yearly reports;
- configurable minimum monthly target;
- multiple tuition records per student;
- parent information;
- student profile photos.

---

# 36. Security and Privacy

Since this is a personal tutor app, the minimum privacy baseline should include:

- no unnecessary network transmission;
- no analytics required for Version 1;
- local storage by default;
- avoid logging phone/address data in debug logs;
- safe handling of database backups;
- if app lock is added later, use platform-secure storage for credentials/keys.

---

# 37. Testing Requirements

Testing should cover the business logic more heavily than visual details.

## Unit tests

Must cover:

### Calendar

- month boundaries;
- leap year February;
- weekday calculation;
- current date handling.

### Routine calculation

- 1 day/week;
- 2 days/week;
- 3 days/week;
- 7 days/week;
- month with five occurrences of a selected weekday;
- month with four occurrences.

### Teaching periods

- starts on first day of month;
- starts mid-month;
- ends mid-month;
- spans complete month;
- multiple historical periods.

### Attendance

- add attendance;
- duplicate prevention;
- remove attendance;
- multiple students same date;
- attendance outside routine;
- attendance within weekly allowance;
- attendance blocked when weekly allowance + carry-over is exceeded.

### Weekly limit and carry-over (v1.1)

- week runs Friday–Thursday: attendance on Thursday and on the following Friday falls into different weeks;
- weekly_days = 3 with no carry-over → 4th attendance in the same week is rejected;
- miss 1 day in week 1 → 4 attendances allowed in week 2;
- carry-over accumulates across multiple missed weeks;
- carry-over resets when a student stops teaching;
- partial first/last week of a teaching period is prorated;
- unscheduled weekday attendance consumes the weekly allowance;
- a week spanning a calendar-month boundary still enforces a single allowance.

### Monthly goal

Examples:

```text
August:
A = 8/10
B = 12/12

September:
B = 10/12
C = 12/12
A absent from September section
```

### Routine modification

If historical routine support is implemented:

```text
A used 3 days/week in August.
A changed to 2 days/week in September.
August calculation must remain based on 3 days/week.
```

## Widget/UI tests

At minimum:

- home opens to current month;
- hamburger drawer opens;
- student can be created;
- student appears in picker;
- attendance can be added;
- attendance appears on calendar;
- attendance can be removed;
- monthly goal updates after attendance change;
- app renders in the dark theme and the stored theme setting survives restart (toggle itself is future).

---

# 38. Acceptance Criteria

The MVP is accepted only when all of the following are true.

## AC-01 — App startup

Given the app is launched, the user sees the current month's calendar as the first screen.

## AC-02 — Today's date

Given today is September 10, 2026, the September 10 cell is visibly highlighted.

## AC-03 — Open date

Given the user taps September 9, the app opens the attendance list for September 9.

## AC-04 — Add attendance

Given Student X exists, tapping `+` and selecting Student X adds Student X to September 9.

## AC-05 — Calendar update

After adding Student X to September 9, the September 9 calendar cell displays Student X's name using Student X's assigned color.

## AC-06 — Multiple students

Given three students are added to the same date, all three are shown within the date details screen, and the calendar displays them within the available date-cell area using overflow handling if necessary.

## AC-07 — Remove attendance

Removing a student from a date updates the date details immediately and the calendar/monthly statistics recalculate.

## AC-08 — Duplicate prevention

The same student cannot have two attendance records for the same date.

## AC-09 — Routine creation

A student with `weekly_days = 3` cannot be saved until exactly three routine weekdays are selected.

## AC-10 — Routine does not block attendance

A student can be manually added to a date that is not one of their routine weekdays.

## AC-11 — Active status

Turning a student off as currently teaching removes the student from future active lists but does not remove previous attendance.

## AC-12 — Historical monthly status

If Student A is active in August and inactive in September, A appears in August's monthly section but not September's.

## AC-13 — New active student

If Student C starts in September, C appears in September's section and is not retroactively added to August.

## AC-14 — Monthly scheduled count

The denominator is calculated from actual weekday occurrences within the student's active teaching period.

## AC-15 — Partial month

A student starting on September 10 is not assigned scheduled days before September 10.

## AC-16 — Extra attendance

Attendance may exceed scheduled days and must display correctly, e.g. `12/10`.

## AC-17 — Six months

The Monthly Attendance Goal screen always shows six consecutive calendar months including the current month.

## AC-18 — Theme

The app renders with the dark theme throughout, and the stored theme setting persists after app restart. (Light theme toggle is future work — v1.1.)

## AC-19 — Offline

The user can add/remove attendance and manage students without network connectivity.

## AC-20 — Local-only data (v1.1)

All user data is stored in the local on-device database; the app performs no network calls.

## AC-21 — Friday week start (v1.1)

The calendar grid and all weekly calculations treat Friday as the first day of the week.

## AC-22 — Weekly attendance cap (v1.1)

Given a student with `weekly_days = 3` and no carry-over, adding a 4th attendance for that student within the same Friday–Thursday week is blocked with a clear message.

## AC-23 — Carry-over recovery (v1.1)

Given a student with `weekly_days = 3` attended only 2 days in one week, the app allows up to 4 attendance days in a following week.

## AC-24 — Dark theme (v1.1)

All screens are readable and styled in the dark theme; no light theme or theme toggle is present in Version 1.

---

# 39. Data Integrity Rules

The following should be enforced at both domain and database levels where possible:

```text
student.id is unique
student.name is not blank
weekly_days ∈ [1, 7]
number(routine_weekdays) = weekly_days
routine_weekdays contains unique values
attendance.student_id references existing student
attendance.attendance_date is valid
(student_id, attendance_date) is unique
teaching period date ranges are valid
routine period date ranges are valid
attendance per student per week <= weekly allowance + carry-over (BR-10)
```

Deleting/archiving a student must not create orphan attendance records.

---

# 40. Migration / Database Versioning

The database layer should support schema migrations from the beginning even for a personal application.

Reason:

The product may later add:

- routine history;
- cloud backup;
- attendance notes;
- income/payment information;
- multiple tuition arrangements.

Avoid direct destructive database changes during normal app upgrades.

---

# 41. Suggested Agent-Friendly Development Breakdown

This section is specifically intended to help a Kilo Code orchestrator coordinate multiple agents.

## Agent 1 — Product / Domain Modeling

Responsibilities:

- convert PRD into domain entities;
- finalize business rules;
- define validation rules;
- define monthly calculation algorithm;
- define weekly allowance + carry-over algorithm (Section 10.6);
- document edge cases.

Output:

- domain model;
- business-rule specification;
- unit-test scenarios.

## Agent 2 — Database / Persistence

Responsibilities:

- set up local database;
- create tables;
- implement migrations;
- indexes;
- unique attendance constraint;
- repositories/DAO;
- seed/test data.

Output:

- persistence layer;
- migration tests;
- repository tests.

## Agent 3 — Flutter App Shell / Navigation / Theme

Responsibilities:

- Flutter project setup;
- app theme (dark-only in Version 1);
- routing;
- navigation drawer;
- theme persistence;
- reusable app shell.

Output:

- navigable app skeleton;
- dark theme (light reserved for future).

## Agent 4 — Calendar Feature

Responsibilities:

- monthly calendar;
- Friday-first week layout (BR-11);
- current date highlight;
- month navigation;
- date-cell rendering;
- student attendance chips;
- overflow behavior.

Output:

- production calendar screen;
- calendar widget tests.

## Agent 5 — Attendance Feature

Responsibilities:

- date attendance screen;
- attendance list;
- add button;
- student picker;
- add/remove operations;
- duplicate prevention UX;
- weekly-limit and carry-over blocking UX (BR-10);

Output:

- attendance workflow;
- integration tests.

## Agent 6 — Student Management

Responsibilities:

- students list;
- add/edit form;
- details page;
- active/inactive handling;
- color picker;
- routine weekday selector;
- optional fields.

Output:

- student CRUD feature;
- validation tests.

## Agent 7 — Monthly Attendance Goal

Responsibilities:

- six-month screen;
- scheduled-day algorithm integration;
- actual/scheduled calculations;
- progress UI;
- historical active-period filtering.

Output:

- monthly goal feature;
- calculation tests.

## Agent 8 — QA / Integration

Responsibilities:

- run all unit/widget/integration tests;
- test cross-feature flows;
- identify state inconsistencies;
- verify offline behavior;
- verify theme persistence;
- verify weekly cap + carry-over behavior;
- verify Friday-first week layout;
- regression testing.

Output:

- QA report;
- bug list;
- fixes for P0/P1 issues.

## Agent 9 — UI Polish

Responsibilities:

- compare implementation against the PRD UX;
- polish Android-native spacing/typography;
- improve date-cell density;
- verify dark/light theme;
- improve empty/loading/error states;
- accessibility checks.

---

# 42. Recommended Orchestrator Dependency Graph

```text
                  ┌─────────────────────┐
                  │ Domain / Business   │
                  │ Rules Agent         │
                  └──────────┬──────────┘
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
      ┌──────────────────┐      ┌────────────────────┐
      │ Database Agent   │      │ App Shell Agent    │
      └────────┬─────────┘      └─────────┬──────────┘
               │                           │
               └────────────┬──────────────┘
                            │
         ┌──────────────────┼───────────────────┐
         │                  │                   │
         ▼                  ▼                   ▼
┌────────────────┐ ┌────────────────┐ ┌────────────────────┐
│ Student Agent  │ │ Attendance     │ │ Calendar Agent     │
│                │ │ Agent          │ │                    │
└───────┬────────┘ └───────┬────────┘ └──────────┬─────────┘
        │                  │                     │
        └──────────────────┼─────────────────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │ Monthly Goal Agent  │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │ QA / Integration    │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │ UI Polish / Review  │
                └─────────────────────┘
```

Agents should not independently invent business rules. The PRD/domain specification should be treated as the source of truth.

---

# 43. Important Implementation Guidance for Kilo Code

When using an orchestrator/multi-agent workflow:

## Source of truth

The root-level PRD should be treated as the product contract.

Agents should not change business behavior silently.

## Shared domain terms

Use one vocabulary consistently:

- `Student`
- `TeachingPeriod`
- `RoutinePeriod`
- `AttendanceRecord`
- `MonthlyAttendanceSummary`

## Avoid feature duplication

One agent should own each major feature module.

## Interfaces first

Before parallel implementation, establish:

- domain entities;
- repository interfaces;
- calculation service interfaces;
- routing names;
- theme tokens.

This reduces merge conflicts.

## Test before handoff

Each agent should provide unit/widget tests for the functionality it owns before another agent depends on it.

---

# 44. Suggested Domain Services

A clean implementation can expose services such as:

```text
AttendanceService
StudentService
TeachingPeriodService
RoutineService
MonthlySummaryService
CalendarService
ThemeService
```

## `MonthlySummaryService`

Primary responsibility:

```text
getLastSixMonthsSummary(referenceDate)
```

Output concept:

```dart
class MonthlyAttendanceSummary {
  final YearMonth month;
  final List<StudentMonthlySummary> students;
}

class StudentMonthlySummary {
  final String studentId;
  final int attendedCount;
  final int scheduledCount;
  final double? percentage;
}
```

This keeps complex calculation logic away from UI widgets.

---

# 45. Loading States

The UI should provide sensible loading behavior even with a local database.

Examples:

- app launch → small calendar skeleton/loading indicator if required;
- student list → lightweight loading state;
- monthly summary → section-level loading state if calculations are asynchronous.

Do not introduce long splash screens just to show branding.

---

# 46. No-Network Behavior

The app must remain useful when:

- Wi-Fi is off;
- mobile data is off;
- airplane mode is enabled.

Core features that must work offline:

- open calendar;
- add student;
- edit student;
- stop/start teaching;
- add attendance;
- remove attendance;
- view monthly goal.

Version 1 contains no feature that depends on network connectivity — the app is fully offline and all data stays on-device (v1.1).

---

# 47. Backup Recommendation

Backup is not required for MVP but is strongly recommended as a future feature because all attendance data is local.

The user has confirmed (v1.1) that a **cloud backup/sync system will be developed in the future**. Design so it can be added without schema rework: keep persistence behind repositories, keep records timestamped (`created_at`/`updated_at`) for future conflict resolution, and keep the local database as the source of truth after sync is introduced.

Potential future feature:

```text
Settings
→ Backup
→ Export local database / JSON
```

Later:

```text
Google Drive / iCloud / cloud sync
```

The architecture should keep persistence behind repositories so backup/sync can be added without rewriting the UI.

---

# 48. Analytics Recommendation

No analytics are required in Version 1.

Because this is a personal utility app, simplicity and privacy are more valuable than tracking user behavior.

---

# 49. UX Tone

The app should feel:

- fast;
- personal;
- calm;
- practical;
- familiar;
- uncluttered.

It should avoid feeling like a complex school ERP.

The user's main objective is only:

> "Who did I teach on which date, and how many times did I teach each student this month?"

Every major UX decision should support that goal.

---

# 50. Primary User Journey

The ideal daily experience is:

```text
Open app
   ↓
Current monthly calendar
   ↓
See today's highlighted date
   ↓
Tap today / any completed date
   ↓
See attendance already recorded
   ↓
Tap +
   ↓
Select student(s)
   ↓
Done
```

The tutor should not need to:

- manually type the student name every day;
- manually count monthly visits;
- manually calculate scheduled days;
- manually update a monthly total.

---

# 51. Example End-to-End Dataset

This example should be used as seed/test data during development.

## Student A

```text
Name: Student A
Weekly days: 3
Routine: Sunday, Tuesday, Thursday
Color: User-selected color
Currently teaching: OFF as of September 1, 2026
Teaching period: August 1, 2026 – August 31, 2026
```

Attendance:

```text
August 2026:
8 attendance records
```

August result:

```text
A = 8/10
```

## Student B

```text
Name: Student B
Weekly days: 3
Routine: Sunday, Tuesday, Thursday
Currently teaching: ON
Teaching period: August 1, 2026 – ongoing
```

Attendance:

```text
August = 12
September = 10
```

Expected display:

```text
August: 12/12
September: 10/12
```

## Student C

```text
Name: Student C
Weekly days: 3
Routine: Monday, Wednesday, Saturday
Currently teaching: ON
Teaching start: September 1, 2026
```

Attendance:

```text
September = 12
```

Expected display:

```text
September: 12/12
```

Expected monthly screen:

```text
September 2026

Student B      10/12
Student C      12/12

August 2026

Student A       8/10
Student B      12/12
```

Student A must **not** appear in the September section under the stated example because the tuition ended before September.

---

# 52. Edge Cases

## Edge Case 1 — Student starts mid-month

Start: September 10  
Routine: Mon/Wed/Fri

Only dates on or after September 10 count toward scheduled days.

## Edge Case 2 — Student stops mid-month

End: September 17

Only dates on or before September 17 count toward scheduled days.

## Edge Case 3 — Student taught on an unscheduled day

Attendance should be accepted.

Scheduled denominator does not increase because of the unscheduled date.

Actual attendance does increase.

## Edge Case 4 — Student not taught on a scheduled day

No attendance record is created automatically.

Scheduled denominator remains unchanged.

## Edge Case 5 — Four-week vs five-week month

Calculate based on real calendar dates.

## Edge Case 6 — Leap year

February 2028 must calculate correctly.

## Edge Case 7 — Routine changed

If routine history is implemented, use the routine effective on each date.

## Edge Case 8 — Inactive student with old attendance

Old calendar dates must still show the student's attendance.

## Edge Case 9 — Re-activated student

Create a new teaching period rather than changing the historical one.

## Edge Case 10 — Duplicate student name

Two students may technically have the same name.

The database must use IDs, not names, for relationships.

The UI may display an optional identifying subtitle later if duplicate names become common.

## Edge Case 11 — Week spans a month boundary (v1.1)

A Friday–Thursday week can cross two calendar months. Weekly allowance and carry-over apply to the whole week, while monthly totals split records by calendar date.

## Edge Case 12 — Carry-over when a student stops teaching

Carry-over resets to 0 when a student is marked not currently teaching; re-activation starts fresh at 0.

## Edge Case 13 — Student starts or stops mid-week

Prorate the weekly allowance to routine-weekday occurrences inside the active teaching period for that week (Section 10.6).

## Edge Case 14 — Attempted over-attendance without carry-over

Adding attendance beyond `weekly_days` in one week with no recoverable carry-over must be blocked with the weekly-limit message.

---

# 53. Product Decisions That Must Not Be Changed Accidentally

The following decisions are critical:

1. **Calendar is the home screen.**
2. **Attendance is manually entered.**
3. **Routine does not block attendance.**
4. **Monthly denominator is based on real scheduled weekday occurrences.**
5. **Historical attendance is never deleted when a student stops.**
6. **Monthly history must use historical active periods.**
7. **One student can only have one attendance record per date.**
8. **The app is local/offline-first: data always on-device, fully offline; cloud backup/sync is future-only.**
9. **Monthly goal always covers six months including current month.**
10. **Student color is persistent and visible on calendar attendance chips.**
11. **The calendar week always starts on Friday.**
12. **Weekly attendance per student is capped at routine days per week plus carry-over from missed weeks.**
13. **All user data always lives in the local on-device database; the app is fully offline; cloud backup/sync is future-only.**
14. **Version 1 is dark-themed; the light theme is future work.**

---

# 54. Definition of Done

The feature set is considered complete when:

- the Flutter project builds successfully;
- all core screens are navigable;
- student CRUD works;
- teaching-period history works;
- routine weekdays work;
- attendance add/remove works;
- duplicate attendance is prevented;
- monthly calendar renders attendance;
- today's date is highlighted;
- student colors appear on calendar entries;
- six-month monthly goal works;
- historical inactive students remain visible in past months where applicable;
- current inactive students do not appear in active monthly sections;
- partial-month calculations are correct;
- dark theme is applied consistently across all screens;
- offline operation works;
- all data is stored locally on-device;
- weekly attendance cap with carry-over recovery works;
- calendar week starts on Friday;
- unit/widget/integration tests for critical paths pass;
- no P0/P1 bugs remain.

---

# 55. Final Product Summary

This application is a **personal, calendar-first attendance tracker for a home tutor**.

The most important product experience is not a traditional attendance table. It is the calendar itself:

```text
                 HOME
                  │
          Monthly Calendar
                  │
       ┌──────────┴──────────┐
       │                     │
    Tap date             Month view
       │                     │
       ▼                     ▼
Date Attendance       Student chips
       │
       ▼
      + FAB
       │
       ▼
 Student Picker
       │
       ▼
Attendance Saved
       │
       ├───────────────┐
       ▼               ▼
Calendar Update   Monthly Goal Update
```

The product should make the tutor feel that attendance tracking is almost automatic: **create a student once, choose their routine and color, then record visits directly from the calendar.**

The most important technical requirement is preserving historical truth. A simple `currentlyTeaching` boolean is not enough. The system must track effective teaching periods—and preferably routine periods as well—so that future changes do not corrupt past monthly calculations.

The final implementation should therefore prioritize:

**Calendar UX + attendance simplicity + historical data integrity + automatic monthly calculation + offline reliability + weekly allowance discipline (Friday weeks, cap with carry-over) + dark theme.**

---

# Appendix A — Recommended Initial Folder / Module Ownership for Multi-Agent Development

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── calendar/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── attendance/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── students/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── monthly_goal/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── settings/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

---

# Appendix B — Priority Labels for Orchestrator Tasks

## P0 — Must work

- app opens to current calendar;
- add/edit student;
- weekly days + weekday selection;
- currently teaching status;
- add attendance;
- remove attendance;
- calendar chips;
- today's highlight;
- historical teaching periods;
- six-month monthly goal;
- correct scheduled-day calculation;
- local persistence;
- local-only data and fully offline app;
- Friday-first week layout;
- weekly attendance cap with carry-over recovery;
- dark theme.

## P1 — Important

- search;
- progress visualization;
- month swipe;
- `Today` shortcut;
- strong empty/error states;
- widget/integration test coverage.

## P2 — Nice to have

- export;
- backup;
- attendance notes;
- custom color picker;
- analytics/statistics;
- cloud sync.

---

# Appendix C — One-Sentence Product Requirement

> **Build a fast, fully offline, dark-themed Flutter attendance app where all data is stored locally, the monthly calendar is the home screen, weeks always start on Friday, attendance is manually recorded per student per date within a weekly cap of the routine's days plus recoverable carry-over from missed weeks, student routines provide the monthly expected count without restricting which weekdays may be used, and six months of historically accurate attendance progress are calculated automatically.**
