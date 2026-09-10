# Architecture & Technology Decisions — Home Tutor Attendance

**Status:** Phase 0 decision record (supplements `docs/implementation.md`, it does not replace it).
**Product source of truth:** `docs/PRD.md`.
**Execution source of truth:** `docs/implementation.md`.

---

## 1. Toolchain snapshot (verified 2026-09-10)

| Item | Value |
|---|---|
| Flutter SDK | 3.7.11 stable (`C:\flutter`), framework `f72efea43c` |
| Dart SDK | 2.19.6 |
| Android SDK | 36.1.0 (`C:\Users\Hridoy\AppData\Local\Android\sdk`), platform android-36, build-tools 36.1.0 |
| Java | JDK 17.0.12 (`C:\Program Files\Java\jdk-17`) |
| Licenses | All Android licenses accepted |
| Android config | `applicationId dev.hometutor.home_tutor_attendance`, compileSdk 33, targetSdk 33, minSdk 16 (Flutter defaults for 3.7.11) |

Constraints accepted with this toolchain:

- **Dart 2.19 only** — no Dart 3 language features (records, patterns, sealed
  classes). All dependency versions are resolved by `pub` against
  `sdk: '>=2.19.6 <3.0.0'`; upgrading the Flutter SDK later may allow newer
  package majors, but versions are re-resolved deliberately, never silently.
- Android Studio "bundled Java not found" and missing Visual Studio are
  irrelevant to Android APK builds from the CLI.

## 2. Layered architecture

Layering follows `docs/implementation.md` §4:

```text
lib/
├── app/         app widget, router, theme
├── core/        constants, errors, extensions, utils, shared widgets
├── data/        database (Drift), models, repositories implementations, datasources
├── domain/      entities, repository interfaces, services (pure business logic)
├── features/    calendar / attendance / students / monthly_goal / settings UI
└── main.dart
```

Responsibilities:

- **Presentation** (`features/`, `app/`, `core/widgets/`): widgets, navigation,
  state consumers. No business calculations in widgets.
- **Domain** (`domain/`): immutable entities (`Student`, `TeachingPeriod`,
  `RoutinePeriod`, `AttendanceRecord`), repository interfaces, and pure
  services (scheduled-day generation, monthly totals, Friday–Thursday weekly
  allowance with carry-over, teaching/routine-period resolution). Domain code
  must stay Flutter-free and independently unit-testable.
- **Data** (`data/`): Drift database, table definitions, mappers, repository
  implementations. UI never touches the database directly.

## 3. Technology choices (task 0.4)

| Concern | Choice | Resolved version | Rationale |
|---|---|---|---|
| Local database | `drift` + `sqlite3_flutter_libs` (+ `path`, `path_provider`) | 2.8.0 / 0.5.42 | PRD §22 recommends Drift + SQLite for relational constraints and explicit queries. Gives real SQL `UNIQUE(student_id, attendance_date)`, indexes, and step-by-step migrations. In-memory `NativeDatabase` makes repository tests fast and hermetic. Local file stays the source of truth (future sync is additive only). |
| State management | `flutter_riverpod` | 2.3.7 | Compile-safe providers, testable without BuildContext, minimal boilerplate, works well with repository interfaces. |
| Routing | `go_router` | 12.1.1 | Declarative route map; supports the drawer-based navigation and future deep links without redesign. |
| ID generation | `uuid` | 4.1.0 | v4 string IDs for students/periods/attendance; IDs are the only relationship keys (PRD Edge Case 10). |
| Injectable time | `clock` | 1.1.1 | Weekly carry-over and "today" logic must be deterministic in tests; `clock.now()` is overridable via `withClock` in tests. |
| Calendar UI | custom-built grid | — | PRD §26 requires a Samsung-inspired dense monthly grid with fixed Friday-first weeks (BR-11) and student-colored chips; a hand-built grid is fully controllable and widget-testable. `table_calendar` is deliberately NOT used. |
| Date utilities | Dart `DateTime` (date-only convention) | — | Date-only semantics per implementation.md §6.2: normalize to midnight-local, store as `YYYY-MM-DD` TEXT in SQLite. No timezone-sensitive timestamps for business dates. `intl` deferred until localization is actually needed. |
| Testing | `flutter_test` (+ Drift in-memory DB) | sdk | Unit tests for domain services; repository tests against in-memory SQLite; widget tests per feature. `mocktail` deferred until a concrete need exists (Phase 2+). |

## 4. Data-integrity contract for Phase 2 (decided now, implemented later)

- `attendance_records`: `UNIQUE(student_id, attendance_date)` database
  constraint in addition to UI-level duplicate prevention (PRD §11.5).
- `teaching_periods` and `routine_periods` history tables preserve historical
  months against later status/routine changes (PRD §31 Level B, §32).
- `app_settings` singleton row: `theme_mode = dark` (fixed in v1),
  `first_day_of_week = friday` (fixed in v1, BR-11/BR-12).
- All records carry `created_at` / `updated_at` timestamps for future
  backup/sync conflict resolution (PRD §47).
- Migration policy: step-by-step Drift `schemaVersion` migrations, never
  destructive (PRD §40).

## 5. Test & build pipeline (task 0.6)

Every phase gate runs, in order:

```bash
dart format .              # 80-column formatting, applied before analysis
flutter analyze            # must exit 0 with no issues
flutter test               # unit + widget tests must pass
flutter build apk --debug  # (release in Phase 10)
```

The APK artifact is verified to exist with non-zero size at
`build\app\outputs\flutter-apk\app-debug.apk` before a phase is reported
complete.

Test placement: `test/` mirrors `lib/` structure as it grows
(e.g. `test/domain/services/`, `test/data/repositories/`,
`test/features/...`).

## 6. UI references

The two JPG screenshots in `docs/` are the visual references. The AI tooling
in this project cannot read image files, so the PRD's textual UI
specifications (§9.1 calendar grid, §26 Samsung-inspired UX, §27 Google-style
date details) are treated as the authoritative description of what those
references contribute. No branding, logos, or proprietary assets are copied.

## 7. Non-goals respected

No networking, accounts, backend, analytics, or cloud sync in Version 1
(PRD §4, BR-09). The repository layer is the seam where a future sync system
may attach without moving data off-device.
