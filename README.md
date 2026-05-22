# fLOBster

fLOBster is planned as a Flutter-based line of business application framework inspired by the approachable data-app workflow of Claris FileMaker, but designed for modern engineering practices: GitHub, specs, tests, reusable packages, Serverpod, PostgreSQL, and AI-agent-friendly documentation.

The first planning artifact is here:

- [Line of Business Flutter Framework Plan](docs/lob-flutter-framework-plan.md)
- [Product Decisions](docs/product/DECISIONS.md)
- [Contact Management Vertical Slice](docs/product/contact-management-vertical-slice.md)
- [Phase 1 Roadmap](docs/engineering/phase-1-roadmap.md)

Current Phase 1 scope: start with Contact Management for separate Person, Company, and Organization records on Flutter macOS desktop plus Serverpod/PostgreSQL, then target Windows and web after the workflow is proven.

## Repository Layout

- `apps/flobster_desktop` - Flutter macOS-first desktop app.
- `server/flobster_server` - Serverpod backend scaffold.
- `server/flobster_client` - generated Serverpod client package.
- `docs` - product, architecture, and implementation planning.

## Local Setup

Install dependencies from the repository root:

```sh
flutter pub get
```

Run the macOS desktop app:

```sh
cd apps/flobster_desktop
flutter run -d macos
```

Run Flutter checks:

```sh
flutter analyze apps/flobster_desktop
flutter test apps/flobster_desktop
```

Run Serverpod static analysis:

```sh
dart analyze server/flobster_server server/flobster_client
```

Serverpod integration tests require the local Docker database services:

```sh
cd server/flobster_server
cp config/passwords.example.yaml config/passwords.yaml
docker compose up -d postgres_test redis_test
flutter test .
```
