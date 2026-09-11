# Architecture & Technology Decisions — Home Tutor Attendance

**Status:** Phase 0 decision record (supplements `docs/implementation.md`, it does not replace it).
**Product source of truth:** `docs/PRD.md`.
**Execution source of truth:** `docs/implementation.md`.

---

## 1. Toolchain snapshot (verified 2026-09-10, after SDK upgrade)

| Item | Value |
|---|---|
| Flutter SDK | 3.47.3 stable (`C:\flutter`), framework `e8113bf456` (2026-09-04) |
| Dart SDK | 3.13.3 |
| DevTools | 2.60.0 |
| Android SDK | 36.1.0 (`C:\Users\Hridoy\AppData\Local\Android\sdk`), platform android-36, build-tools 36.1.0 |
| Java | JDK 21.0.9 (Android Studio JBR, resolved by `flutter config --jdk-dir`) |
| Licenses | All Android licenses accepted |
| Android config | Kotlin DSL template: AGP 9.1.0, Gradle 9.3.1, Kotlin 2.4.0; `applicationId dev.hometutor.home_tutor_attendance`; effective compileSdk 36 / targetSdk 36 / minSdk 24 (Flutter 3.47.3 defaults via `flutter.*` expressions); NDK 28.2.13676358 |

History: the project started on Flutter 3.7.11 and was upgraded to latest stable
on 2026-09-10 at the user's request. The `android/` folder was regenerated from
the Flutter 3.47.3 template (the 3.7-era AGP 7.x template cannot build modern
compileSdk levels). An earlier manual `minSdkVersion 21` fix became obsolete
with the regenerated template. During the first upgraded build, Gradle
auto-installed NDK 28.2 (r28c), build-tools 36.0.0, and CMake 3.22.1 (licenses
were pre-accepted); these are needed by the `sqlite3 3.x` native build hooks.

Constraints accepted with this toolchain:

- **Dart 3.13 / SDK `>=3.12.0 <4.0.0`** — modern Dart 3 language features are
  available; dependency constraints were re-resolved to latest majors via
  `flutter pub upgrade --major-versions` (riverpod 3.x and go_router 18.x APIs
  apply from Phase 1 onward).
- `sqlite3_flutter_libs` is an end-of-life empty stub and is deliberately NOT a
  direct dependency. Native SQLite arrives through `sqlite3 3.x` build hooks
  pulled in by `drift_flutter`.
- Android Studio "bundled Java not found" warning from the old doctor run is
  resolved; Visual Studio (C++) remains absent but is irrelevant — this project
  is Android-only.

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

## 3. Technology choices (task 0.4, versions re-resolved 2026-09-10)

| Concern | Choice | Resolved version | Rationale |
|---|---|---|---|
| Local database | `drift` + `drift_flutter` (+ `path`, `path_provider`) | 2.35.0 / 0.3.1 | PRD §22 recommends Drift + SQLite for relational constraints and explicit queries. Gives real SQL `UNIQUE(student_id, attendance_date)`, indexes, and step-by-step migrations. `drift_flutter` provides the modern lazy database setup; native SQLite ships via `sqlite3 3.x` build hooks (no EOL plugin libs needed). In-memory databases keep repository tests fast and hermetic. Local file stays the source of truth (future sync is additive only). |
| State management | `flutter_riverpod` | 3.4.3 | Compile-safe providers, testable without BuildContext, minimal boilerplate, works well with repository interfaces. Phase 1+ codes against the Riverpod 3.x API. |
| Routing | `go_router` | 18.0.1 | Declarative route map; supports the drawer-based navigation and future deep links without redesign. Phase 1+ codes against the go_router 18.x API. |
| ID generation | `uuid` | 4.6.0 | v4 string IDs for students/periods/attendance; IDs are the only relationship keys (PRD Edge Case 10). |
| Injectable time | `clock` | 1.1.3 | Weekly carry-over and "today" logic must be deterministic in tests; `clock.now()` is overridable via `withClock` in tests. |
| Theme persistence | `shared_preferences` | 2.5.5 | PRD §11.6 sanctions simple local key-value storage for the theme setting ahead of the Phase 2 `app_settings` row. Keeps the startup read fast and testable via mock initial values. |
| Calendar UI | custom-built grid | — | PRD §26 requires a Samsung-inspired dense monthly grid with fixed Friday-first weeks (BR-11) and student-colored chips; a hand-built grid is fully controllable and widget-testable. `table_calendar` is deliberately NOT used. |
| Date utilities | Dart `DateTime` (date-only convention) | — | Date-only semantics per implementation.md §6.2: all business dates normalize to **UTC midnight** (timezone/DST-safe), stored as `YYYY-MM-DD` TEXT in SQLite via a Drift `TypeConverter`. Timestamps (`created_at`/`updated_at`) remain epoch-based instants. `intl` deferred until localization is actually needed. |
| Timezone policy | device-local "today" | — | The primary user is in Bangladesh (GMT+6, Asia/Dhaka — PRD §10.2 note). "Today" is resolved from device-local time via the injectable `clock.now()` and immediately normalized to a date-only value; no timezone is hardcoded, and business dates never undergo timezone conversion. |
| Testing | `flutter_test` (+ Drift in-memory DB) | sdk | Unit tests for domain services; repository tests against in-memory SQLite; widget tests per feature. `mocktail` deferred until a concrete need exists (Phase 2+). |

Dev tooling: `flutter_lints` 6.0.0 (via `analysis_options.yaml`),
`drift_dev` 2.35.0 + `build_runner` 2.16.1 for Drift codegen (first used in
Phase 2).

**Theme decision (Phase 1):** `implementation.md`'s Phase 1 text lists a
light/dark toggle (pre-v1.1 wording). The PRD v1.1 supersedes it (BR-12,
§19): Version 1 ships **dark-only**, no theme control is shown, and the
drawer's bottom area is merely reserved for the future toggle. The persisted
`theme_mode` value is `dark`; reserved values (`light`, `system`) map to dark
until the light theme ships.

## 4. Data-integrity contract (implemented in Phase 2)

- `attendance_records`: `UNIQUE(student_id, attendance_date)` database
  constraint plus repository-level `DuplicateAttendanceException`; foreign
  keys reference `students.id` with `PRAGMA foreign_keys = ON` (PRD §11.5).
- `students` carries the CURRENT routine snapshot (`weekly_days`,
  `routine_weekdays`) for fast UI reads; `teaching_periods` and
  `routine_periods` are the authoritative history used by all monthly
  calculations, so later edits never rewrite history (PRD §31 Level B, §32).
- `app_settings` singleton row (id = 1): `theme_mode = 'dark'`,
  `first_day_of_week = 'friday'` (fixed in v1, BR-11/BR-12). Note: the
  shared_preferences store from Phase 1 remains the fast startup read for
  the theme; the database row is the canonical persisted setting — both hold
  `dark` in v1, and the DB becomes the single source once the light theme
  ships.
- All records carry `created_at` / `updated_at` timestamps for future
  backup/sync conflict resolution (PRD §47).
- Migration policy: step-by-step Drift `schemaVersion` migrations (v1),
  never destructive (PRD §40).

## 5. Test & build pipeline (task 0.6)

Every phase gate runs, in order:

```bash
dart format .              # formatting, applied before analysis
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

## 8. Release notes (Phase 10, 2026-09-11)

- **Identity:** display name `Home Tutor Attendance`, applicationId
  `dev.hometutor.home_tutor_attendance`, version 1.0.0+1, dark-only Material 3.
- **Launcher icon:** Flutter default in v1 (custom artwork is future work;
  no proprietary assets copied per PRD §53).
- **Signing:** the release APK is signed with the local debug keystore —
  fine for personal installation; define a dedicated keystore before any
  store distribution.
- **Database safety:** schemaVersion 1 with a single additive `onCreate`
  path and `PRAGMA foreign_keys = ON`; no destructive migrations exist, and
  future migrations must stay step-by-step and additive (PRD §40). Fresh
  install and reopen-persistence are covered by automated tests
  (`app_database_test`).
- **Permissions:** the release/main manifest declares none (INTERNET exists
  only in the debug overlay) — the app is fully offline.
- **v1.2 model:** routine weekdays optional, no weekly cap, flat
  `weekly_days × 4` monthly targets (see PRD v1.2 Change Summary).
