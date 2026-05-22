# ADR 0001: Phase 1 Product Scope

Status: Accepted
Date: 2026-05-22

## Context

fLOBster is intended to become a Flutter-based line of business framework. The initial idea includes desktop, web, mobile, multiple persistence modes, reports, dashboards, realtime chat, notifications, Supabase, and Serverpod.

Building all of that at once would make the framework hard to validate and hard for AI agents to implement safely.

## Decision

Phase 1 will focus on Contact Management as a desktop/web vertical slice.

The selected stack is:

- Flutter desktop/web.
- Serverpod.
- PostgreSQL.
- Email/password authentication.

Phase 1 explicitly excludes:

- Offline sync.
- Native mobile app.
- Supabase adapter.
- Reports.
- Report designer.
- Realtime chat.
- Advanced dashboards.

## Consequences

The first implementation can concentrate on core line of business patterns: list, search, preview, form, validation, save state, soft delete, restore, and audit.

Future capabilities remain possible, but they must not shape the first implementation more than necessary.
