# Contact Management Vertical Slice

Status: Draft
Date: 2026-05-22

## Objective

Build the first fLOBster reference module around Contact Management. The goal is to prove the framework's core line of business workflow: list, search, preview, create, edit, validate, save, soft delete, restore, and audit.

This is not yet a full CRM. It is the smallest useful business module that can validate fLOBster's architecture and UI patterns.

## Users

- Business user: searches, views, creates, and edits contacts.
- Power user: filters lists, corrects data, restores deleted records if permitted.
- Administrator: manages access, restores records, and reviews audit history.
- Developer: uses this module as the example for future modules.

## Scope

### In Scope

- Email/password sign in.
- Authenticated app shell.
- Contact list view.
- Search by name, email, phone, organization, and tag if tags are included.
- Sort by name, organization, last updated, and created date.
- Right-side contact preview sheet.
- Full contact create/edit form.
- Required field validation.
- Email format validation.
- Phone field normalization rules to be decided during implementation.
- Soft delete.
- Restore deleted contact.
- Basic audit metadata.
- Serverpod endpoint tests.
- Flutter ViewModel tests.
- Flutter widget tests for core UI states.

### Out Of Scope

- Offline sync.
- Native mobile app.
- Report designer.
- PDF/HTML reports.
- Supabase adapter.
- Enterprise SSO.
- Marketing automation.
- Sales pipeline.
- Advanced duplicate detection/merge.
- Import/export.

## Data Model Draft

### Contact

Minimum fields:

- `id`
- `displayName`
- `givenName`
- `familyName`
- `organizationName`
- `jobTitle`
- `primaryEmail`
- `primaryPhone`
- `secondaryPhone`
- `notes`
- `createdAt`
- `createdBy`
- `updatedAt`
- `updatedBy`
- `deletedAt`
- `deletedBy`
- `deleteReason`
- `restoredAt`
- `restoredBy`
- `rowVersion`

Recommended later fields:

- `tags`
- `preferredContactMethod`
- `address`
- `website`
- `socialProfiles`
- `customFields`

### Audit Event

Minimum fields:

- `id`
- `actorUserId`
- `action`
- `targetType`
- `targetId`
- `summary`
- `createdAt`

Initial actions:

- `contact.created`
- `contact.updated`
- `contact.deleted`
- `contact.restored`

## User Workflows

### Sign In

1. User opens the app.
2. User enters email and password.
3. App authenticates with the backend.
4. User lands on the Contact list.

Acceptance criteria:

- Invalid credentials show a page-level error.
- Successful sign in loads the Contact list.
- Auth state survives page refresh where supported by the chosen auth package.

### Contact List

1. User opens Contact Management.
2. App shows a searchable table of active contacts.
3. User searches by name, email, phone, or organization.
4. User selects a row.
5. App opens the right-side preview sheet.

Acceptance criteria:

- Loading, empty, error, and populated states are implemented.
- Deleted contacts are hidden by default.
- Search result updates without losing app shell state.
- Selected contact remains visually clear.

### Contact Preview

1. User selects a contact in the list.
2. Preview sheet opens from the right.
3. User sees read-only contact details and audit summary.
4. User can open the full editor.

Acceptance criteria:

- Preview sheet is read-only by default.
- Preview sheet has Edit, Delete, and Close actions.
- Delete action requires confirmation.
- Opening editor keeps the selected contact context.

### Create Contact

1. User clicks Create Contact.
2. App opens the contact form.
3. User enters required fields.
4. App validates fields.
5. User saves.
6. Backend creates contact and audit event.
7. App returns to list or shows saved state.

Acceptance criteria:

- Required field errors are inline.
- Invalid email is rejected before save.
- Server validation remains the final authority.
- Save failure preserves user input.
- Successful save appears in the list.

### Edit Contact

1. User opens an existing contact.
2. User edits fields.
3. App shows dirty state.
4. User saves.
5. Backend updates contact and increments `rowVersion`.

Acceptance criteria:

- Unsaved changes are detectable.
- Cancel with unsaved changes asks for confirmation.
- Concurrent update conflict is detected by `rowVersion`.
- Save failure preserves current form values.

### Soft Delete And Restore

1. User deletes a contact.
2. Backend sets delete metadata instead of hard deleting.
3. Contact disappears from active list.
4. Permitted user opens deleted contacts view.
5. User restores contact.

Acceptance criteria:

- Delete requires confirmation.
- Active list excludes deleted contacts.
- Restore clears active deletion state and records restore metadata.
- Audit events exist for delete and restore.

## UI States To Implement

List view:

- Loading.
- Empty.
- Empty after search.
- Error.
- Populated.
- Row selected.

Preview sheet:

- Loading selected record.
- Record loaded.
- Record unavailable.
- Permission denied.

Form:

- New clean.
- Existing clean.
- Dirty.
- Validating.
- Saving.
- Saved.
- Save failed.
- Conflict.

Authentication:

- Signed out.
- Signing in.
- Invalid credentials.
- Signed in.

## Architecture Requirements

Flutter client:

- MVVM pattern.
- Views do not call Serverpod directly.
- ViewModels expose immutable screen state.
- Repositories hide backend details.
- Validation rules are testable outside widgets.

Backend:

- Serverpod endpoints for contact CRUD.
- PostgreSQL persistence.
- Server-side validation.
- Soft delete enforced server-side.
- Audit event creation inside server-side command flow.

## Testing Requirements

Unit tests:

- Contact validation.
- Contact ViewModel state transitions.
- Soft delete and restore command behavior.
- Conflict handling logic.

Widget tests:

- List loading/empty/error/populated states.
- Preview sheet opens on row selection.
- Form displays validation errors.
- Delete confirmation appears.

Server tests:

- Create contact.
- Update contact.
- Reject invalid contact.
- Soft delete contact.
- Restore contact.
- Exclude deleted contacts from active list.
- Create audit event on create/update/delete/restore.

## Phase 1 Exit Criteria

The vertical slice is complete when a signed-in user can manage contacts end to end from a desktop/web Flutter UI backed by Serverpod and PostgreSQL, with tests covering the main workflows and documentation explaining how the module should be used as a reference for future modules.
