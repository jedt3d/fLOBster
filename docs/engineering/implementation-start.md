# Implementation Start Readiness

Status: Draft
Date: 2026-05-22

## Phase 1 Implementation Order

1. Establish the repository foundation: monorepo layout, Dart/Flutter baseline, Serverpod scaffold, README setup instructions, ADR template, PR template, and CI skeleton.
2. Bring up the local backend baseline: Serverpod project, PostgreSQL connection, generated protocol/model workflow, and a repeatable migration/test command path.
3. Add email/password authentication: sign-in screen, session persistence, authenticated macOS app shell, and sign-out flow.
4. Build the Contact Management backend: Person, Company, Organization, Category, Tag, and Audit Event models; validation; endpoints; soft delete/restore; admin-only audit access; endpoint tests.
5. Build the macOS list and preview workflow: people, companies, organizations, unified search, sort, repository abstraction, Serverpod repository implementation, right-side preview, and loading/empty/error/selected states.
6. Build create/edit forms: required fields, email validation, dirty state, save status, `rowVersion` conflict handling, save failure recovery, one-company-per-person, and one-organization-per-person rules.
7. Add delete/restore UI: confirmation, deleted-record filter or view, admin-only restore action, permission-aware UI hooks, and flow tests.
8. Harden tests and documentation: endpoint tests, ViewModel tests, widget tests, UI state screenshots, implementation notes, and Phase 1 review checklist.

## Immediate Environment Prerequisites

- macOS development machine, since Phase 1 proves the desktop workflow on macOS first.
- Flutter desktop tooling enabled for macOS.
- Dart SDK compatible with the selected Flutter and Serverpod versions.
- Serverpod CLI installed and available on `PATH`.
- PostgreSQL installed, running locally, and reachable by the Serverpod development configuration.
- A checked-in or documented environment setup path for database credentials, server config, and generated Serverpod artifacts.
- A repeatable command set for dependency install, code generation, database migration, backend tests, Flutter tests, and launching the macOS app.
- An initial admin-capable test user path for validating admin-only delete, restore, and audit visibility.

## First Acceptance Checks

- A fresh clone can install dependencies without undocumented manual steps.
- The empty Serverpod server starts locally and connects to PostgreSQL.
- The generated Serverpod client/protocol artifacts are reproducible from the repository setup instructions.
- The Flutter macOS app launches to an authentication entry point.
- A test user can sign in, reach the authenticated Contact Management shell, close and reopen the app, and sign out.
- The authenticated shell exposes the expected Contact Management structure: People, Companies, Organizations, search area, and preview region placeholders.
- Backend tests can be run from a clean local environment.
- Flutter tests can be run from a clean local environment.
- The scaffold keeps client data access behind repositories and Serverpod client services, with no direct client database access.
- Phase 1 scope exclusions remain absent from the scaffold: offline sync, reports, native mobile, web, Supabase adapter, import/export, and custom fields.
