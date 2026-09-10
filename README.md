# Home Tutor Attendance

A personal, fully offline, dark-themed Flutter attendance tracker for a home
tutor. The monthly calendar (Friday-start weeks) is the home screen; students
are recorded per date within a weekly routine cap with carry-over recovery,
and a six-month goal view summarizes attended vs scheduled days.

Status: Phase 0 baseline (project foundation). The phase-gated execution plan
lives in `docs/implementation.md`; product requirements live in `docs/PRD.md`.

## Development

Requirements: Flutter 3.7.x (Dart 2.19), Android SDK, JDK 17.

```bash
flutter pub get           # fetch dependencies
dart format .             # format code (run before every phase gate)
flutter analyze           # static analysis (must report no issues)
flutter test              # run unit and widget tests
flutter build apk --debug # build the debug APK
```

## Documentation

- `docs/PRD.md` — authoritative product requirements.
- `docs/implementation.md` — authoritative phase-gated execution plan.
- `docs/architecture.md` — architecture and technology decisions.
- `docs/samsung calendar UI screenshot.jpg` — primary calendar UI reference.
- `docs/google calendar UI screenshot.jpg` — date-detail interaction reference.
