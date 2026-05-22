# Product Decisions

Status: Active
Date: 2026-05-22

This file captures product-owner decisions that should guide the next planning and implementation work. These decisions override broader options listed in the initial framework plan until explicitly changed.

## Locked Phase 1 Decisions

| Area | Decision |
| --- | --- |
| First reference module | Contact Management |
| Primary deployment target | macOS desktop first, Windows second, web later |
| Backend mode | Serverpod plus PostgreSQL |
| Authentication | Email and password |
| Offline support | Not required for Phase 1 |
| Reports | Not required for Phase 1 |
| Core records | Person, Company, and Organization are separate models |
| Field inspiration | Use Apple Contacts-style fields as the starting vocabulary |
| Tags/categories | Include lightweight tags and categories |
| Restore permission | Admin users only |
| Delete permission | Admin users only |
| Person relationship scope | One Person links to at most one Company and one Organization in Phase 1 |
| Audit visibility | Admin users only |

## Interpretation

### Contact Management

The first vertical slice should model people, companies, and organizations as separate records. This keeps the design understandable for business users while allowing future CRM, service, and operations modules to reuse the same relationship model.

Phase 1 should include:

- Person list.
- Company list.
- Organization list.
- Contact search across people, companies, and organizations.
- Preview sheets for each record type.
- Create/edit forms for each record type.
- Admin-only soft delete for each record type.
- Admin-only restore.
- Basic audit fields.
- Email/password authentication.
- Tags/categories for lightweight grouping.

Phase 1 should not include:

- Sales pipeline.
- Marketing automation.
- Advanced duplicate merging.
- Report designer.
- Offline sync.
- Native mobile application.

### Apple Contacts-Inspired Fields

The field vocabulary should start from the practical fields users already understand in Apple Contacts on macOS and iOS: name, organization/company, job title, phone, email, address, birthday, notes, photo, nickname, phonetic name/company, pronouns, and profile/social-style fields.

fLOBster should adapt these into business-friendly models instead of copying Apple Contacts exactly.

### Separate Person, Company, And Organization Models

Phase 1 should treat Person, Company, and Organization as separate models:

- Person: an individual human contact.
- Company: a business/legal commercial entity.
- Organization: a non-company entity such as department, association, government office, school, community, or internal unit.

Relationships should be explicit and expandable. For Phase 1, a Person may optionally link to one Company and one Organization. Multiple company and multiple organization relationships are deferred.

### Tags And Categories

Include lightweight classification:

- Category: a controlled, single primary grouping for a record.
- Tags: flexible labels for filtering and discovery.

Avoid custom fields in Phase 1 unless required later.

### Admin-Only Delete And Restore

Only administrators can soft delete or restore Person, Company, or Organization records in Phase 1.

### macOS Desktop First

The primary UI should target macOS desktop first:

- Dense table views.
- Keyboard-friendly forms.
- Multi-pane navigation.
- Right-side preview sheet.
- Native macOS packaging path.
- Windows desktop after macOS is proven.
- Web platform after the desktop workflow is proven.

Web and mobile remain future companion experiences.

### Admin-Only Audit Visibility

Audit metadata is recorded for business integrity, but audit history views should be visible only to administrators in Phase 1.

### Serverpod Plus PostgreSQL

Serverpod and PostgreSQL are the default system of record. Client code should access data through repositories and Serverpod client services, not direct database access.

Supabase remains a future adapter option, not part of Phase 1.

### Email And Password Authentication

Phase 1 should implement basic email/password authentication using the selected Serverpod-compatible approach. Enterprise SSO and social login are future concerns.

### No Offline Requirement

Phase 1 does not need offline create/edit/sync. Local form draft recovery can still be considered as crash/session recovery, but it must not expand into offline synchronization.

### No Report Priority

Reports and report designer work are deferred. The Contact Management vertical slice should not wait on report infrastructure.

## Open Decisions For Next Review

- Exact required fields for Person, Company, and Organization forms.
- Whether normal users can create and edit all records, or whether create/edit also needs role separation.
