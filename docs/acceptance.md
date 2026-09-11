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
| AC-09 | Routine requires exactly N weekdays to save | `student_form_screen_test` AC-09 test; service validation tests | PASS |
| AC-10 | Non-routine weekday attendance allowed (consumes allowance) | `weekly_allowance_service_test` "non-routine weekday…" | PASS |
| AC-11 | Turning teaching off keeps past attendance | `student_management_service_test` deactivate; detail tests | PASS |
| AC-12 | Inactive student appears in historical months only | `monthly_goal_service_test` visibility; `monthly_goal_screen_test` | PASS |
| AC-13 | New student appears from start month, not retroactively | `monthly_goal_service_test` visibility rule | PASS |
| AC-14 | Denominator from real weekday occurrences in active period | `scheduled_days_service_test` (13-not-12, leap, partial months) | PASS |
| AC-15 | Mid-month start has no scheduled days before start | `scheduled_days_service_test` partial tests | PASS |
| AC-16 | Attendance may exceed scheduled (12/10 display) | `monthly_summary_service_test`, `monthly_goal_service_test` uncapped | PASS |
| AC-17 | Goal screen always shows six consecutive months | `monthly_goal_service_test` six months; `monthly_goal_screen_test` | PASS |
| AC-18 | Dark theme throughout; persists after restart | `app_shell_test` dark tests; `theme_settings_test` persistence | PASS |
| AC-19 | Add/remove/manage works offline | Main manifest declares **no permissions** (INTERNET exists only in the debug overlay for dev tooling); all data operations are local DB calls. Manual check: airplane mode | PASS |
| AC-20 | All data local; no network calls | Same as AC-19; no network code exists in the dependency tree | PASS |
| AC-21 | Friday week start everywhere | `monthly_calendar_test` Friday-first; `weekly_allowance_service_test` week boundaries | PASS |
| AC-22 | 4th weekly attendance without carry blocked with clear message | `weekly_allowance_service_test` AC-22; `attendance_workflow_service_test` block test; `date_detail_screen_test` blocked test (weekly-limit snackbar) | PASS |
| AC-23 | Missed days become carry; 4 allowed the next week | `weekly_allowance_service_test` carry-forward (3→5) | PASS |
| AC-24 | Dark-only v1, no light theme/toggle present | `app_shell_test`; drawer has no theme control | PASS |

## Edge cases (PRD §52)

| # | Edge case | Coverage | Status |
|---|---|---|---|
| 1 | Routine change mid-month keeps history | `scheduled_days_service_test` routine change; `monthly_goal_service_test` Aug/Sep split | PASS |
| 2 | Five-occurrence weekday months | `scheduled_days_service_test` five-occurrence | PASS |
| 3 | Leap-year February | `scheduled_days_service_test` leap Feb 2028 | PASS |
| 4 | Student stops mid-month | partial-month scheduled tests; goal visibility tests | PASS |
| 5 | Four- vs five-week months | scheduled-days count tests derive from calendar | PASS |
| 6 | Monthly summary across routine change | `monthly_summary_service_test` Aug M/W/F vs Sep T/Th | PASS |
| 7 | Extra attendance beyond schedule display | `monthly_goal_service_test` uncapped (200%) | PASS |
| 8 | Reactivation creates new periods, never edits history | `student_management_service_test` reactivation | PASS |
| 9 | Carry-over recovery | `weekly_allowance_service_test` carry tests (§10.6 example) | PASS |
| 10 | Search with no results | `students_screen_test` "No students match…" | PASS |
| 11 | Week spans a month boundary — one allowance window | `weekly_allowance_service_test` month-boundary tests | PASS |
| 12 | Carry resets when teaching stops; fresh on reactivation | `weekly_allowance_service_test` stop/resume reset | PASS |
| 13 | Mid-week start/stop prorates the weekly allowance | `weekly_allowance_service_test` partial first week | PASS |
| 14 | Over-attendance without carry blocked with message | AC-22 tests above | PASS |

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
