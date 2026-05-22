# Phase 1 Roadmap

Status: Draft
Date: 2026-05-22

## Phase 1 Goal

Deliver a working Contact Management vertical slice for desktop and web using Flutter, Serverpod, PostgreSQL, and email/password authentication.

## Scope Guardrails

Phase 1 includes:

- Flutter desktop/web app shell.
- Serverpod backend.
- PostgreSQL database.
- Email/password sign in.
- Contact list, search, preview, create, edit, soft delete, restore.
- Basic audit events.
- Automated tests around the reference workflow.

Phase 1 excludes:

- Offline sync.
- Native mobile app.
- Supabase adapter.
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

- A user can sign in, reach the Contact list shell, refresh the web app, and sign out.

### 3. Contact Backend

Deliverables:

- Contact model.
- Audit event model.
- PostgreSQL migration.
- Serverpod endpoints.
- Validation.
- Soft delete and restore behavior.
- Endpoint tests.

Done when:

- Backend tests prove create, read, update, soft delete, restore, and audit event creation.

### 4. Contact List And Preview

Deliverables:

- Contact list ViewModel.
- Contact repository interface.
- Serverpod repository implementation.
- Search and sort behavior.
- Right-side preview sheet.
- Loading, empty, error, and selected states.
- Widget tests.

Done when:

- A signed-in user can browse, search, select, and preview contacts.

### 5. Contact Form

Deliverables:

- Create/edit form.
- Field validation.
- Dirty state.
- Save status.
- Conflict handling using `rowVersion`.
- Save failure recovery.
- Widget and ViewModel tests.

Done when:

- A signed-in user can create and edit contacts with validation and visible save status.

### 6. Soft Delete And Restore UI

Deliverables:

- Delete confirmation.
- Deleted contacts filter/view.
- Restore action.
- Permission-ready UI hooks.
- Tests for delete and restore flows.

Done when:

- A permitted user can soft delete and restore contacts from the UI.

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
- Flutter data grid choice for desktop/web density and keyboard behavior.
- Web and desktop layout differences.
- Concurrency behavior around `rowVersion`.
- Avoiding premature framework extraction before the first module is real.

## Next Required Product Inputs

Before implementation, confirm:

- Required contact fields for the first version.
- Whether organization/company should be a separate model now or just a text field.
- Whether tags are needed in Phase 1.
- Which desktop runtime matters first after web: macOS or Windows.
- Whether normal users can restore deleted contacts or only administrators.
