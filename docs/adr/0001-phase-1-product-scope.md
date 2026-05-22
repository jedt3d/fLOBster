# ADR 0001: Phase 1 Product Scope

Status: Accepted
Date: 2026-05-22

## Context

fLOBster is intended to become a Flutter-based line of business framework. The initial idea includes desktop, web, mobile, multiple persistence modes, reports, dashboards, realtime chat, notifications, Supabase, and Serverpod.

Building all of that at once would make the framework hard to validate and hard for AI agents to implement safely.

## Decision

Phase 1 will focus on Contact Management as a macOS desktop vertical slice. Contact Management will include separate Person, Company, and Organization models.

The selected stack is:

- Flutter macOS desktop first.
- Serverpod.
- PostgreSQL.
- Email/password authentication.
- Lightweight categories and tags.
- Admin-only soft delete and restore for records.
- Admin-only audit history visibility.
- One company and one organization per person in Phase 1.

Phase 1 explicitly excludes:

- Offline sync.
- Native mobile app.
- Web platform.
- Windows desktop.
- Supabase adapter.
- Reports.
- Report designer.
- Realtime chat.
- Advanced dashboards.
- Custom fields.

## Consequences

The first implementation can concentrate on core line of business patterns: list, search, preview, form, validation, save state, admin-only soft delete, admin-only restore, and admin-only audit history.

Future capabilities remain possible, but they must not shape the first implementation more than necessary.
