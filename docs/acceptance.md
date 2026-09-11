# Acceptance Criteria & Edge-Case Verification — Home Tutor Attendance

**Status:** Phase 8 regression report. Source of truth: `docs/PRD.md`
(§42–§43 acceptance criteria, §52 edge cases). Every criterion below maps to
an automated test in the suite (`flutter test`) or an explicit manual check.

**Suite totals at Phase 8:** see the phase report; run `flutter test` to
re-verify.

---

## Acceptance criteria (PRD §42–§43)

| AC | Requirement | Automated coverage | Status |
|---|---|---|---|
| AC-01 | App opens on the current month's calendar | `home_screen_test` "opens on the current month…" | PASS |
| AC-02 | Today's date visibly highlighted | `home_screen_test`, `monthly_calendar_test` "today is marked…" | PASS |
| AC-03 | Tapping a date opens its attendance list | `home_screen_test` "tapping a date opens the date details screen" | PASS |
| AC-04 | `+` + student adds them to the date | `date_detail_screen_test` "add via picker…" | PASS |
| AC-05 | Calendar chip shows name in student color after add | `date_detail_screen_test` add test (chip assertion), `journey_test` | PASS |
| AC-06 | Three students on one date all shown (overflow handled) | `monthly_calendar_test` chips + overflow; `date_detail_screen_test` bars | PASS |
| AC-07 | Remove updates details + recalculation | `date_detail_screen_test` remove flow; goal/calendar streams recompute | PASS |
| AC-08 | No two records for same student/date | repo UNIQUE test, workflow duplicate test, UI duplicate test | PASS |
| AC-09 | Routine requires exactly N weekdays to save | SUPERSEDED by v1.2: weekday selection optional — `student_form_screen_test` "routine weekday selection is optional"; `student_management_service_test` optional weekdays | PASS |
| AC-10 | Non-routine weekday attendance allowed | `attendance_workflow_service_test` "ANY weekday, no weekly limit"; `date_detail_screen_test` 7-day recording test | PASS |
| AC-11 | Turning teaching off keeps past attendance | `student_management_service_test` deactivate; detail tests | PASS |
| AC-12 | Inactive student appears in historical months only | `monthly_goal_service_test` visibility; `monthly_goal_screen_test` | PASS |
| AC-13 | New student appears from start month, not retroactively | `monthly_goal_service_test` visibility rule | PASS |
| AC-14 | Denominator from real weekday occurrences in active period | SUPERSEDED by v1.2: flat `weekly_days × 4` — `monthly_goal_service_test` flat-target + user case tests | PASS |
| AC-15 | Mid-month start has no scheduled days before start | SUPERSEDED by v1.2: the flat monthly target does not prorate for start dates | N/A |
| AC-16 | Attendance may exceed scheduled (12/10 display) | `monthly_summary_service_test` never-capped; `monthly_goal_service_test` 14/12 → 117% | PASS |
| AC-17 | Goal screen always shows six consecutive months | `monthly_goal_service_test` six months; `monthly_goal_screen_test` | PASS |
| AC-18 | Dark theme throughout; persists after restart | `app_shell_test` dark tests; `theme_settings_test` persistence | PASS |
| AC-19 | Add/remove/manage works offline | Main manifest declares **no permissions** (INTERNET exists only in the debug overlay for dev tooling); all data operations are local DB calls. Manual check: airplane mode | PASS |
| AC-20 | All data local; no network calls | Same as AC-19; no network code exists in the dependency tree | PASS |
| AC-21 | Friday week start (calendar layout) | `monthly_calendar_test` Friday-first grid layout | PASS |
| AC-22 | Weekly attendance cap | SUPERSEDED by v1.2: the weekly cap was removed — attendance is recordable on any day | N/A |
| AC-23 | Carry-over recovery | SUPERSEDED by v1.2: no weekly cap, hence no carry-over mechanism | N/A |
| AC-24 | Dark-only v1, no light theme/toggle present | `app_shell_test`; drawer has no theme control | PASS |

**v1.2 amendment (2026-09-11, user-approved):** AC-09 now reads "routine
weekday selection is optional; only days-per-week is required"; AC-14 now
reads "the monthly goal denominator is a flat `weekly_days × 4` for every
month the teaching period overlaps". See `docs/PRD.md` v1.2 Change Summary.

## Edge cases (PRD §52, as amended by v1.2)

| # | Edge case | Coverage | Status |
|---|---|---|---|
| 1 | Routine change mid-month keeps history | `monthly_goal_service_test` routine-history target split; `student_management_service_test` routine change | PASS |
| 2 | Five-occurrence weekday months | SUPERSEDED by v1.2 (flat target) — grid layout still tested in `monthly_calendar_test` | N/A |
| 3 | Leap-year February | SUPERSEDED by v1.2 (flat target) — grid layout still tested in `monthly_calendar_test` | N/A |
| 4 | Student stops mid-month | goal visibility tests (`monthly_goal_service_test` overlap rule) | PASS |
| 5 | Four- vs five-week months | SUPERSEDED by v1.2 (flat target) | N/A |
| 6 | Monthly summary across routine change | `monthly_goal_service_test` target follows routine history | PASS |
| 7 | Extra attendance beyond target display (14/12) | `monthly_goal_service_test` over-attendance uncapped | PASS |
| 8 | Reactivation creates new periods, never edits history | `student_management_service_test` reactivation | PASS |
| 9 | Carry-over recovery | SUPERSEDED by v1.2 (no weekly cap) | N/A |
| 10 | Search with no results | `students_screen_test` "No students match…" | PASS |
| 11 | Week spans a month boundary | SUPERSEDED by v1.2 (no weekly allowance) | N/A |
| 12 | Carry resets when teaching stops | SUPERSEDED by v1.2 (no carry-over) | N/A |
| 13 | Mid-week start proration | SUPERSEDED by v1.2 — any day is recordable; flat target ignores start date | N/A |
| 14 | Over-attendance without carry blocked | SUPERSEDED by v1.2 — recording is never blocked | N/A |

## Cross-feature & non-functional checks

- **Journey test** (`journey_test.dart`): create student → record via
  picker → calendar chip → goal row, all through the real UI.
- **Fresh install** (`fresh_install_test.dart`): every screen renders its
  empty state on an empty database.
- **Volume smoke** (`volume_smoke_test.dart`): 40 students × 200 records
  render and settle on the two heaviest screens.
- **Offline**: verified at the manifest level (no permissions in the release
  merge). Recommended manual check: airplane-mode walkthrough once per
  release APK.
- **Timezone**: date-only semantics + device-local "today" (PRD §10.2
  note; user in GMT+6/Asia-Dhaka). Automated via date-normalization tests.

## Phase 8 correction record

The Phase 5 implementation allowed over-cap attendance via a confirmation
dialog. The PRD is unambiguous (§10.6 "must prevent", §13.8 note, §16 flow,
BR-10, AC-22, Edge Case 14): the weekly cap is a hard block with the
weekly-limit message. Phase 8 rewrote `WeeklyAllowanceService` to the
authoritative §10.6 semantics — blocking enforcement, no carry reset at
month boundaries (only on teaching stop, per §10.6 rules), and prorated
partial weeks — and added `WeeklyLimitExceededException` at the service
layer plus the blocking snackbar in the picker.

### User-approved refinement (2026-09-11, post Phase 8 testing)

User report: a student with a Fri/Sat/Tue routine starting Wednesday
Sep 9 could not be recorded on Wednesday — the routine-weekday-occurrence
proration of Edge 13 yielded a zero allowance for the partial week, while
the tutor may in practice teach ANY N of the 7 weekdays. First fix:
prorate the weekly cap by active days.

### v1.2 product amendment (2026-09-11, supersedes the cap entirely)

After further testing the user simplified the routine model wholesale
(recorded in `docs/PRD.md` v1.2 Change Summary): routine weekday selection
is OPTIONAL, the weekly cap and carry-over mechanism are REMOVED
(`WeeklyAllowanceService` deleted — attendance is recordable for any
student on any date), and the monthly goal denominator is a flat
`weekly_days × 4` for every month the teaching period overlaps, with
over-attendance displayed uncapped (14/12). Covered by
`attendance_workflow_service_test` "ANY weekday, no weekly limit",
`date_detail_screen_test` 7-day recording test,
`monthly_goal_service_test` flat-target/over-attendance/history tests, and
`student_form_screen_test` optional-weekdays test.
