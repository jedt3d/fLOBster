# Product Decisions

Status: Active
Date: 2026-05-22

This file captures product-owner decisions that should guide the next planning and implementation work. These decisions override broader options listed in the initial framework plan until explicitly changed.

## Locked Phase 1 Decisions

| Area | Decision |
| --- | --- |
| First reference module | Contact Management |
| Primary deployment target | Desktop and web first |
| Backend mode | Serverpod plus PostgreSQL |
| Authentication | Email and password |
| Offline support | Not required for Phase 1 |
| Reports | Not required for Phase 1 |

## Interpretation

### Contact Management

The first vertical slice should model people and organizations well enough to prove common line of business workflows without becoming a CRM product immediately.

Phase 1 should include:

- Contact list.
- Contact search.
- Contact preview sheet.
- Contact create/edit form.
- Contact soft delete and restore.
- Basic audit fields.
- Email/password authentication.

Phase 1 should not include:

- Sales pipeline.
- Marketing automation.
- Advanced duplicate merging.
- Report designer.
- Offline sync.
- Native mobile application.

### Desktop And Web First

The primary UI should support desktop-class usage:

- Dense table views.
- Keyboard-friendly forms.
- Multi-pane navigation.
- Right-side preview sheet.
- Browser deployment.
- Desktop deployment path after the Flutter scaffold is proven.

Mobile remains a future companion experience.

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

- Whether contacts represent only people, or both people and organizations.
- Whether organization/company records should be a separate model in Phase 1.
- Required contact fields for the first form.
- Whether tags, categories, or custom fields are needed in Phase 1.
- Whether the first desktop target should be macOS, Windows, or both after web works.
- Whether audit history is visible to normal users or only administrators.
