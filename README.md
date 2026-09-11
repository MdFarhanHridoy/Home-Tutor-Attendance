# Home Tutor Attendance

A personal, fully offline, dark-themed Flutter attendance tracker for a home
tutor. The monthly calendar (Friday-start weeks) is the home screen;
attendance is recorded per student per date with duplicate protection, and a
six-month goal view summarizes attended days against each student's monthly
target.

## Product behavior (v1.2)

- **Routine = days per week.** Weekday selection is optional (informational
  only). Attendance can be recorded for any student on **any** calendar
  date — there is no weekly cap.
- **Monthly target = days per week × 4** for every month the student's
  teaching period overlaps, regardless of the start date within the month.
  Over-attendance displays uncapped (e.g. `14 / 12`).
- **History is never rewritten.** Stopping teaching closes the student's
  teaching/routine periods (they stay visible in historical months);
  resuming opens new ones. Changing days-per-week keeps past months on the
  old rate.
- One attendance record per student per date, enforced at UI, service, and
  database level.
- Friday-first calendar layout, today highlight, month arrows/swipe, and a
  Today shortcut.
- All data lives in a local on-device database (Drift/SQLite). The app is
  fully offline — the release build requests no Android permissions.

## Requirements

- Flutter 3.47.x (Dart 3.13), Android SDK 36, JDK 21 (Android Studio JBR).

## Development

```bash
flutter pub get           # fetch dependencies
dart run build_runner build  # regenerate drift code (after schema edits)
dart format .             # format code (run before every phase gate)
flutter analyze           # static analysis (must report no issues)
flutter test              # run unit + widget tests
flutter build apk --debug # build the debug APK
flutter build apk --release # build the release APK
```

Debug APK output: `build/app/outputs/flutter-apk/app-debug.apk`
Release APK output: `build/app/outputs/flutter-apk/app-release.apk`

The release APK is signed with the local debug keystore (sufficient for
personal sideloading; configure an upload keystore before any store
distribution).

## Testing

The suite covers domain services, database/repositories (in-memory SQLite),
and full-app widget tests including a cross-feature journey (create student
→ record attendance → calendar chip → goal row), fresh-install empty states,
and a 40-student volume smoke test. Run everything with `flutter test`.

## Known limitations (Version 1)

- Launcher icon is the Flutter default (no custom artwork in v1).
- No backup/export yet (planned future feature; the repository layer is the
  seam where it will attach).
- Light theme and theme toggle are future work (v1 is dark-only).
- Attendance notes, search in the student picker, and cloud sync are future
  work.

## Documentation

- `docs/PRD.md` — authoritative product requirements (incl. v1.1/v1.2
  change summaries).
- `docs/implementation.md` — authoritative phase-gated execution plan.
- `docs/architecture.md` — architecture and technology decisions.
- `docs/acceptance.md` — acceptance-criteria and edge-case verification
  matrix.
- `docs/samsung calendar UI screenshot.jpg` — primary calendar UI reference.
- `docs/google calendar UI screenshot.jpg` — date-detail interaction
  reference.
