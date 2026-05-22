# Contact Management Vertical Slice

Status: Draft
Date: 2026-05-22

## Objective

Build the first fLOBster reference module around Contact Management. The goal is to prove the framework's core line of business workflow: list, search, preview, create, edit, validate, save, soft delete, admin-only restore, and audit.

This is not yet a full CRM. It is the smallest useful business module that can validate fLOBster's architecture and UI patterns.

## Product Decisions

- People, companies, and organizations are separate models.
- The first field vocabulary is inspired by Apple Contacts on macOS/iOS.
- Tags and categories are included lightly in Phase 1.
- Only administrators can restore deleted records.
- A person can link to only one company in Phase 1.
- A person can link to only one organization in Phase 1.
- Only administrators can delete records.
- Audit history is visible only to administrators.
- macOS desktop is the first deployment target, followed by Windows, then web.
- Offline sync and reports are out of scope for Phase 1.

## Users

- Business user: searches, views, creates, and edits people, companies, and organizations.
- Power user: filters lists and corrects data.
- Administrator: manages access, restores deleted records, and reviews audit history.
- Developer: uses this module as the example for future modules.

## Scope

### In Scope

- Email/password sign in.
- Authenticated app shell.
- Person, Company, and Organization models.
- Separate list views for people, companies, and organizations.
- Unified contact search across people, companies, and organizations.
- Search by name, email, phone, company, organization, category, and tag.
- Sort by name, organization/company, last updated, and created date.
- Right-side preview sheet.
- Full create/edit forms.
- Lightweight category and tag support.
- Required field validation.
- Email format validation.
- Phone field normalization rules to be decided during implementation.
- Admin-only soft delete.
- Admin-only restore.
- Basic audit metadata.
- Serverpod endpoint tests.
- Flutter ViewModel tests.
- Flutter widget tests for core UI states.

### Out Of Scope

- Offline sync.
- Native mobile app.
- Windows desktop.
- Web platform.
- Report designer.
- PDF/HTML reports.
- Supabase adapter.
- Enterprise SSO.
- Marketing automation.
- Sales pipeline.
- Advanced duplicate detection/merge.
- Import/export.
- Custom fields.

## Field Inspiration

Apple's Contacts documentation describes user-facing contact fields such as name, company, phone, email, address, birthday, notes, photo, nickname, phonetic names/company, pronouns, and profile/social-style fields. fLOBster should use that familiar field vocabulary, but adapt it into business models with server-side validation, audit, and soft-delete behavior.

Sources:

- [Apple Support: Add people and companies to Contacts on Mac](https://support.apple.com/en-gb/guide/contacts/adrbk1080/mac)
- [Apple Support: Update contact information in Contacts on Mac](https://support.apple.com/en-euro/guide/contacts/adrbk1515/mac)
- [Apple Support: Edit contacts on iPhone](https://support.apple.com/en-lamr/guide/iphone/-iph89a9c71d8/ios)
- [Apple Support: Create or edit contacts in Contacts on iCloud.com](https://support.apple.com/en-euro/guide/icloud/create-or-edit-contacts-mmfba737da/1.0/icloud/1.0)

## Data Model Draft

### Shared Record Metadata

Every main record should include:

- `id`
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

### Person

Minimum fields:

- `id`
- `displayName`
- `givenName`
- `familyName`
- `nickname`
- `pronouns`
- `phoneticGivenName`
- `phoneticFamilyName`
- `companyId`
- `organizationId`
- `jobTitle`
- `primaryEmail`
- `primaryPhone`
- `secondaryPhone`
- `addressLine1`
- `addressLine2`
- `city`
- `region`
- `postalCode`
- `country`
- `birthday`
- `profileUrl`
- `photoUrl`
- `categoryId`
- `tags`
- `notes`
- shared record metadata

Recommended later fields:

- `preferredContactMethod`
- `website`
- `socialProfiles`
- multiple company relationships
- multiple organization relationships
- custom fields

### Company

Minimum fields:

- `id`
- `displayName`
- `legalName`
- `phoneticName`
- `primaryEmail`
- `primaryPhone`
- `website`
- `addressLine1`
- `addressLine2`
- `city`
- `region`
- `postalCode`
- `country`
- `categoryId`
- `tags`
- `notes`
- shared record metadata

Recommended later fields:

- tax identifier
- billing address
- shipping address
- industry
- company size
- parent company

### Organization

Minimum fields:

- `id`
- `displayName`
- `organizationType`
- `phoneticName`
- `primaryEmail`
- `primaryPhone`
- `website`
- `addressLine1`
- `addressLine2`
- `city`
- `region`
- `postalCode`
- `country`
- `categoryId`
- `tags`
- `notes`
- shared record metadata

Recommended later fields:

- parent organization
- department/unit hierarchy
- public/private sector flag

### Category

Minimum fields:

- `id`
- `name`
- `description`
- `recordType`
- `color`
- `sortOrder`
- `createdAt`
- `updatedAt`

Category rules:

- A record has at most one primary category.
- Categories are controlled values, not free text.
- Categories may be scoped by record type.

### Tag

Minimum fields:

- `id`
- `name`
- `color`
- `createdAt`
- `updatedAt`

Tag rules:

- A record may have multiple tags.
- Tags are flexible labels for filtering and discovery.
- Tags should not replace structured fields.

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

- `person.created`
- `person.updated`
- `person.deleted`
- `person.restored`
- `company.created`
- `company.updated`
- `company.deleted`
- `company.restored`
- `organization.created`
- `organization.updated`
- `organization.deleted`
- `organization.restored`

## User Workflows

### Sign In

1. User opens the app.
2. User enters email and password.
3. App authenticates with the backend.
4. User lands on the People list.

Acceptance criteria:

- Invalid credentials show a page-level error.
- Successful sign in loads the People list.
- Auth state survives page refresh where supported by the chosen auth package.

### People, Company, And Organization Lists

1. User opens Contact Management.
2. App shows a searchable table of active people by default.
3. User can switch between People, Companies, and Organizations.
4. User searches by name, email, phone, company, organization, category, or tag.
5. User selects a row.
6. App opens the right-side preview sheet.

Acceptance criteria:

- Loading, empty, error, and populated states are implemented.
- Deleted records are hidden by default.
- Search result updates without losing app shell state.
- Selected record remains visually clear.

### Record Preview

1. User selects a person, company, or organization in the list.
2. Preview sheet opens from the right.
3. User sees read-only record details.
4. Admin users can see audit summary.
5. User can open the full editor.

Acceptance criteria:

- Preview sheet is read-only by default.
- Preview sheet has Edit, Delete, and Close actions.
- Audit history is hidden from non-admin users.
- Delete action requires confirmation.
- Opening editor keeps the selected record context.

### Create Person, Company, Or Organization

1. User clicks the relevant Create action.
2. App opens the matching form.
3. User enters required fields.
4. App validates fields.
5. User saves.
6. Backend creates the record and audit event.
7. App returns to list or shows saved state.

Acceptance criteria:

- Required field errors are inline.
- Invalid email is rejected before save.
- Server validation remains the final authority.
- Save failure preserves user input.
- Successful save appears in the list.

### Edit Person, Company, Or Organization

1. User opens an existing record.
2. User edits fields.
3. App shows dirty state.
4. User saves.
5. Backend updates the record and increments `rowVersion`.

Acceptance criteria:

- Unsaved changes are detectable.
- Cancel with unsaved changes asks for confirmation.
- Concurrent update conflict is detected by `rowVersion`.
- Save failure preserves current form values.

### Admin-Only Soft Delete And Restore

1. Admin deletes a person, company, or organization.
2. Backend sets delete metadata instead of hard deleting.
3. Record disappears from active list.
4. Admin opens deleted records view.
5. Admin restores record.

Acceptance criteria:

- Delete action is visible only to administrators.
- Server rejects delete from non-admin users.
- Admin delete requires confirmation.
- Active lists exclude deleted records.
- Restore action is visible only to administrators.
- Server rejects restore from non-admin users.
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

- Serverpod endpoints for Person, Company, and Organization CRUD.
- PostgreSQL persistence.
- Server-side validation.
- Soft delete enforced server-side.
- Admin-only restore enforced server-side.
- Audit history access restricted to administrators.
- Audit event creation inside server-side command flow.

## Testing Requirements

Unit tests:

- Person, Company, and Organization validation.
- Contact Management ViewModel state transitions.
- Soft delete and restore command behavior.
- Conflict handling logic.

Widget tests:

- List loading/empty/error/populated states.
- Preview sheet opens on row selection.
- Form displays validation errors.
- Delete action is hidden for non-admin users.
- Delete confirmation appears for admin users.
- Restore action is hidden for non-admin users.
- Audit history is hidden for non-admin users.

Server tests:

- Create person, company, and organization.
- Update person, company, and organization.
- Reject invalid records.
- Soft delete records as admin.
- Reject soft delete as non-admin.
- Restore records as admin.
- Reject restore as non-admin.
- Return audit history to admin users.
- Reject audit history access for non-admin users.
- Exclude deleted records from active lists.
- Create audit event on create/update/delete/restore.

## Phase 1 Exit Criteria

The vertical slice is complete when a signed-in user can manage people, companies, and organizations end to end from a macOS desktop Flutter UI backed by Serverpod and PostgreSQL, with admin-only restore and audit visibility enforced server-side and tests covering the main workflows.
