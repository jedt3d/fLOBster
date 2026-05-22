# Phase 1 Roadmap

Status: Draft
Date: 2026-05-22

## Phase 1 Goal

Deliver a working Contact Management vertical slice for macOS desktop using Flutter, Serverpod, PostgreSQL, and email/password authentication. Windows desktop follows after macOS is proven; web is deferred until the desktop workflow is stable.

## Scope Guardrails

Phase 1 includes:

- Flutter macOS desktop app shell.
- Serverpod backend.
- PostgreSQL database.
- Email/password sign in.
- Person, Company, and Organization list/search/preview/create/edit.
- Admin-only soft delete and restore.
- Lightweight categories and tags.
- Basic audit events.
- Admin-only audit history visibility.
- Automated tests around the reference workflow.

Phase 1 excludes:

- Offline sync.
- Native mobile app.
- Supabase adapter.
- Web platform.
- Reports and report designer.
- Record-sharing chat.
- Advanced dashboard analytics.

## Work Packages

### 1. Repository Foundation

Deliverables:

- Monorepo folder structure.
- Dart/Flutter tooling baseline.
- Serverpod scaffold.
- README updates.
- ADR template.
- PR template.
- CI skeleton.

Done when:

- A developer can clone the repository, install dependencies, and run the empty app/server scaffold.

### 2. Authentication Foundation

Deliverables:

- Email/password auth decision documented.
- Sign-in screen.
- Auth session handling.
- Authenticated app shell.
- Sign-out flow.

Done when:

- A user can sign in, reach the Contact list shell, close/reopen the macOS app, and sign out.

### 3. Contact Management Backend

Deliverables:

- Person model.
- Company model.
- Organization model.
- Category model.
- Tag model.
- Audit event model.
- PostgreSQL migration.
- Serverpod endpoints.
- Validation.
- Admin-only soft delete and restore behavior.
- Admin-only audit history access.
- Endpoint tests.

Done when:

- Backend tests prove create, read, update, admin-only soft delete, admin-only restore, admin-only audit access, and audit event creation for people, companies, and organizations.

### 4. Contact Management Lists And Preview

Deliverables:

- People list ViewModel.
- Company list ViewModel.
- Organization list ViewModel.
- Unified search behavior.
- Contact repository interface.
- Serverpod repository implementation.
- Search and sort behavior.
- Right-side preview sheet.
- Loading, empty, error, and selected states.
- Widget tests.

Done when:

- A signed-in user can browse, search, select, and preview people, companies, and organizations.

### 5. Contact Management Forms

Deliverables:

- Person create/edit form.
- Company create/edit form.
- Organization create/edit form.
- Field validation.
- Dirty state.
- Save status.
- Conflict handling using `rowVersion`.
- Save failure recovery.
- One-company-per-person relationship rule.
- One-organization-per-person relationship rule.
- Widget and ViewModel tests.

Done when:

- A signed-in user can create and edit people, companies, and organizations with validation and visible save status.

### 6. Soft Delete And Restore UI

Deliverables:

- Delete confirmation.
- Deleted records filter/view.
- Admin-only restore action.
- Permission-ready UI hooks.
- Tests for delete and restore flows.

Done when:

- Only an administrator can soft delete and restore records from the UI.

### 7. Documentation And Review

Deliverables:

- Updated architecture notes.
- Contact module implementation notes.
- Test evidence.
- Screenshots for UI states.
- Phase 1 review checklist.

Done when:

- The Contact module can be used as the reference pattern for the second module.

## Suggested Order

1. Repository foundation.
2. Serverpod scaffold and PostgreSQL setup.
3. Authentication.
4. Contact backend.
5. Contact list.
6. Contact preview.
7. Contact form.
8. Soft delete/restore.
9. Tests and documentation hardening.

## Risks To Manage

- Serverpod auth package fit for the exact email/password behavior.
- Flutter data grid choice for desktop density, keyboard behavior, and future web compatibility.
- Avoiding layout assumptions that would block the later web platform.
- macOS packaging and signing decisions.
- Concurrency behavior around `rowVersion`.
- Avoiding premature framework extraction before the first module is real.

## Next Required Product Inputs

Before implementation, confirm:

- Exact required fields for Person, Company, and Organization forms.
- Whether normal users can create and edit all records, or whether create/edit also needs role separation.
