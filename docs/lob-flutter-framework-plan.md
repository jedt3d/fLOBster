# fLOBster Line of Business Flutter Framework Plan

Status: Draft 1
Owner perspective: CIO / Product Management
Prepared on: 2026-05-22 Asia/Bangkok
Working branch: `codex/lob-framework-plan`

## 1. Executive Summary

fLOBster should become a Flutter-based line of business application framework for teams that want the fast data-app ergonomics of Claris FileMaker-style development while keeping a modern, testable, Git-based software engineering process.

The product should not start as a visual database builder. It should start as a strongly opinionated application framework and reference application that proves common business workflows:

- Searchable list views with sortable tables and record preview sheets.
- Full form editors with validation, draft recovery, async checks, and save status.
- In-place editing for focused, low-friction changes.
- Soft delete, restore, audit history, and optimistic concurrency.
- Dashboards, reports, realtime notifications, and chat-based record sharing.
- Shared Flutter UI patterns for desktop, web, and a deliberate mobile subset.

The first goal is to build a Contact Management vertical slice, then extract reusable framework packages from that working software. This keeps the framework grounded in real workflows and gives AI agents concrete acceptance criteria, test fixtures, and working examples.

## 2. Verified Technology Baseline

This baseline was checked from primary sources on 2026-05-22.

- Dart: Use Dart 3.x with a minimum SDK constraint chosen after project scaffold. Dart 3.12 was released on 2026-05-18 and adds private named parameters. Source: [Dart language evolution](https://dart.dev/resources/language/evolution).
- Flutter: Target Flutter 3.44.0 as the current documentation baseline. Source: [Flutter release docs](https://docs.flutter.dev/release).
- Flutter architecture: Use Flutter's official app architecture guidance: Views, ViewModels, Repositories, Services, with optional domain/use-case layer. Source: [Flutter guide to app architecture](https://docs.flutter.dev/app-architecture/guide).
- Serverpod: Target Serverpod 3.x, currently documented as 3.4.0. Serverpod provides Dart backend endpoints, PostgreSQL-backed ORM, migrations, auth, logging, caching, file uploads, scheduled calls, and realtime streams. Source: [Serverpod overview](https://docs.serverpod.dev/overview).
- Serverpod 3 requirements: Serverpod 3.0 requires Dart SDK 3.8.0+ and Flutter SDK 3.32.0+. Source: [Serverpod upgrade to 3.0](https://docs.serverpod.dev/upgrading/upgrade-to-three).
- Relic: The web server package is spelled `Relic` in official docs. Relic 1.2.0 is published on pub.dev and is built by the Serverpod team as a typed Dart web server framework with routing, middleware, static files, WebSockets, hot reload improvements, and isolate support. Source: [Relic on pub.dev](https://pub.dev/packages/relic).
- Supabase: Supabase Flutter supports Postgres access, realtime database changes, Edge Functions, authentication, user management, and storage. Source: [Supabase Flutter reference](https://supabase.com/docs/reference/dart/introduction).
- Local SQLite: Flutter's official SQLite cookbook uses `sqflite`, but notes it supports macOS, iOS, and Android. Source: [Flutter SQLite cookbook](https://docs.flutter.dev/cookbook/persistence/sqlite). For cross-platform offline database work, evaluate Drift because its pub.dev package advertises Android, iOS, macOS, Windows, Linux, and web support. Source: [Drift on pub.dev](https://pub.dev/packages/drift).

## 3. Product Positioning

### Product Vision

Build a framework for serious business applications where developers and advanced business users can understand the application structure, data model, workflows, and UI behavior without reverse engineering custom code every time.

### Product Principles

- Opinionated defaults over blank canvas flexibility.
- CRUD workflows that are pleasant, recoverable, and auditable.
- Database-first thinking without database-coupled UI code.
- Desktop as the primary full-power experience, starting with macOS.
- Mobile as a focused companion experience, not a forced copy of desktop.
- Specification, tests, and examples are part of every feature.
- AI agents should be able to safely implement, test, and explain changes from local docs.

### Intended Users

- CIO / product manager: wants predictable delivery, maintainable architecture, and clear scope control.
- Internal software team: wants reusable patterns and faster delivery of business modules.
- Pro user / power user: wants understandable screens, predictable forms, saved views, exports, and reports.
- Future plugin author: wants stable extension points for data sources, forms, reports, and workflows.

### Non-Goals for the First Year

- A full no-code/low-code visual builder.
- A generic replacement for every Flutter UI framework.
- Direct client access to production databases as the default architecture.
- Pixel-perfect native UI per platform.
- Heavy collaborative editing like Google Docs for arbitrary forms.

## 4. Platform Strategy

### Full Experience

Desktop should receive the full line of business experience first, starting with macOS and then Windows. Web should follow after the desktop workflow is proven.

- Multi-pane shell.
- Navigation sidebar or rail.
- Dense data tables.
- Record preview sheets.
- Full form editors.
- Bulk actions.
- Reports and dashboards.
- Admin settings.
- Realtime chat and notifications.

### Mobile Subset

Mobile should prioritize high-value field work and approvals:

- Search and open records.
- View record summaries.
- Simple edits for selected fields.
- Create lightweight records.
- Upload photos/files.
- Receive notifications.
- Chat and share records.
- Approve/reject workflow steps.

Mobile should not initially include:

- Full report designer.
- Advanced dashboard layout editing.
- Complex table customization.
- Full schema administration.
- Bulk destructive operations.

## 5. Recommended Architecture

### High-Level Shape

Use Flutter for client applications and Serverpod for the primary backend. Treat Supabase as a supported cloud data provider and integration target, not the core backend for every deployment.

The default architecture should be:

```text
Flutter app
  UI layer: Views + reusable widgets
  State layer: ViewModels + Commands
  Domain layer: optional use cases for complex flows
  Data layer: Repositories + Services

Backend
  Serverpod endpoints
  Serverpod models and migrations
  PostgreSQL
  Relic custom routes where low-level HTTP control is needed
  WebSocket streams for realtime features

Optional integrations
  Supabase adapter
  Third-party REST/GraphQL adapters
  Local SQLite/Drift offline cache
```

### Monorepo Layout

Recommended initial repository structure:

```text
apps/
  flobster_desktop/          # Flutter macOS-first desktop reference app
  flobster_mobile/           # Optional later mobile-specific shell if needed
packages/
  flobster_core/             # Result, errors, IDs, permissions, audit primitives
  flobster_ui/               # App shell, list, form, sheet, notification widgets
  flobster_forms/            # Field metadata, validation, draft handling
  flobster_data/             # Repository interfaces and data source adapters
  flobster_workflow/         # CRUD lifecycle, soft delete, approvals, state machine
  flobster_reports/          # Report schema, rendering contracts, export services
  flobster_realtime/         # Chat, notification, record references, presence
server/
  flobster_server/           # Serverpod app
  flobster_client/           # Generated Serverpod client package
docs/
  adr/                       # Architecture Decision Records
  product/                   # Product specs and UX guidelines
  engineering/               # Development process and testing guidelines
```

### MVVM Rules

Use Flutter's official architecture guidance:

- View: renders state and forwards user intent.
- ViewModel: owns screen state, commands, validation coordination, loading/error state.
- Repository: source of truth for domain data.
- Service: talks to Serverpod, Supabase, SQLite, or third-party APIs.
- Use case: optional for business workflows involving multiple repositories or policies.

Do not let views directly call databases, Serverpod clients, Supabase clients, or raw HTTP clients.

## 6. Data Persistence Strategy

### Preferred Default

Use Serverpod plus PostgreSQL as the canonical system of record.

Reasons:

- Centralized business rules.
- Better security boundary.
- Server-side validation and audit.
- Built-in migrations.
- Easier realtime streams and notifications.
- Better fit for multi-user business applications.

### Direct PostgreSQL Access

Direct database access from a Flutter client should be treated as an advanced/internal deployment option only.

Allowed cases:

- Internal admin tooling on a trusted network.
- Developer utilities.
- Migration/inspection tools.
- Controlled kiosk or single-tenant deployments.

Not recommended as default:

- Public web apps.
- Mobile apps.
- Multi-tenant SaaS.
- Any environment where database credentials could be extracted from a client.

### Local SQLite

Use local SQLite for mobile offline cache, drafts, pending operations, and lookup tables.

Recommended path:

- Start with a repository interface that can support local and remote implementations.
- Evaluate Drift for cross-platform local persistence and reactive queries.
- Use mobile SQLite for drafts, offline reads, and queued writes.
- Add conflict resolution only after the online CRUD flow is proven.

### Supabase

Support Supabase as:

- A cloud PostgreSQL option.
- A direct backend-as-a-service mode for small apps.
- A realtime data source.
- An auth/storage/integration provider where useful.

For serious business apps, define clear rules:

- Supabase Row Level Security must be enabled for exposed tables.
- Client access should be limited to approved tables, views, or RPC functions.
- Serverpod remains preferred when complex business rules, workflow, audit, and integrations matter.

## 7. Core UX Guidelines

### Application Shell

The default desktop shell should have:

- Left navigation sidebar or rail.
- Top command/search area.
- Main content region.
- Optional right-side context panel.
- Global notification center.
- User/account menu.
- Environment indicator for dev/staging/prod.

The shell should avoid marketing-style layouts. A line of business app should feel dense, calm, predictable, and easy to scan.

### List View Pattern

List views are the main entry point for business records.

Required capabilities:

- Table or data grid with stable row height.
- Search and filter.
- Sort by common fields.
- Saved views.
- Column visibility control.
- Row selection.
- Bulk actions with confirmation.
- Empty, loading, error, and permission states.
- Right-side record preview sheet.
- Deep link to full record editor.

Recommended default layout:

```text
Module title / saved view selector / primary action
Search + filters + table tools
Data table
Pagination or virtual scroll
Right record preview sheet when a row is selected
```

### Record Preview Sheet

The sheet should be read-only by default and slide from the right on desktop.

It should show:

- Record title and key status.
- Important fields.
- Related records.
- Recent activity.
- Attachments.
- Comments/chat context.
- Actions: open full editor, quick edit, share, duplicate, archive/delete.

### Form View Pattern

The form view is the full editor for a model.

Required capabilities:

- Field groups and sections.
- Inline validation.
- Async validation.
- Save status.
- Draft recovery.
- Dirty state detection.
- Optimistic concurrency handling.
- Permission-aware field behavior.
- Audit trail entry after save.
- Cancel with discard confirmation.

Recommended save states:

- `clean`: no unsaved change.
- `dirty`: local changes not saved.
- `validating`: local and async validation running.
- `saving`: save request in progress.
- `saved`: server has accepted current version.
- `save_failed`: save failed but draft remains recoverable.
- `conflict`: server version changed since edit began.

### Field And Validation Pattern

Validation should be layered:

- Field-level synchronous validation: required, format, min/max, enum.
- Form-level synchronous validation: cross-field consistency.
- Async validation: uniqueness, stock availability, credit limit, external API checks.
- Server validation: final authority.

Validation display rules:

- Show inline error under the field.
- Show section-level count if a collapsed section contains errors.
- Show a summary at top only after save attempt or submit.
- Preserve user input after validation failure.
- Do not block typing for most validation. Validate after blur, debounce, or submit.

### Notification Pattern

Use notification types consistently:

- Inline field error: user can fix the field.
- Banner: page-level issue that affects the whole view.
- Toast/snackbar: transient success or minor non-blocking feedback.
- Modal dialog: destructive confirmation or blocking decision.
- Notification center: persistent async events, background job result, shared record, mention.

### Delete And Restore

All business records should use soft delete by default.

Minimum metadata:

- `deletedAt`
- `deletedBy`
- `deleteReason`
- `restoredAt`
- `restoredBy`
- `rowVersion`

Default UX:

- Delete action uses a confirmation dialog.
- After delete, show undo when possible.
- Deleted records are hidden by default.
- Administrators can view trash and restore records.
- Hard delete is a separate privileged operation, normally only for retention policies.

## 8. CRUD Workflow Design

### Standard Record Lifecycle

```text
new draft -> validating -> saved -> edited -> saved
                           -> soft deleted -> restored
                           -> archived
```

### Draft Recovery

Every full form editor should persist draft state locally.

Draft rules:

- Create a local draft record when a user starts editing.
- Save draft changes after debounce.
- Keep drafts keyed by user, model, record ID, and form version.
- On reopen, offer to restore draft, discard draft, or compare with server record.
- Clear draft only after successful save or explicit discard.

### In-Place Editing

In-place editing should be allowed only where the user can understand scope.

Rules:

- Edit one record row, sheet, or field group at a time.
- Show dirty state immediately.
- Save on explicit commit, not silent blur, for important data.
- Use keyboard-friendly controls.
- Provide escape/cancel behavior.
- Reuse the same validation rules as full forms.

### Concurrency

Use optimistic concurrency by default.

Minimum record fields:

- `id`
- `createdAt`
- `createdBy`
- `updatedAt`
- `updatedBy`
- `rowVersion`
- `deletedAt`
- `deletedBy`

If the server detects `rowVersion` mismatch:

- Keep the user's draft.
- Show what changed on the server.
- Offer reload server version, overwrite if permitted, or merge manually.

## 9. Realtime Collaboration, Chat, And Notifications

### Core Concepts

The realtime system should support:

- Direct chat.
- Team/channel chat.
- System notifications.
- Mentions.
- Record sharing.
- Record activity feed.
- Presence for currently viewed records.

### Record Sharing

Record sharing should work like sharing a social post, but inside the business app.

Use a universal record reference:

```text
recordRef:
  appId
  moduleId
  modelName
  recordId
  title
  summary
  permissionHint
  deepLink
```

When a user shares a record:

- Chat message stores the record reference.
- Recipient sees a preview card.
- Opening the card checks current permissions.
- If permitted, the app opens the preview sheet or full editor.
- If not permitted, show a permission request path instead of leaking data.

### Realtime Transport

Use Serverpod streams/WebSockets for:

- Chat messages.
- Notifications.
- Presence.
- Background job status.
- Dashboard push updates where appropriate.

Supabase realtime can be an adapter for Supabase-backed modules, but should not define the framework's core realtime abstraction.

## 10. Reports And Dashboards

### Report Designer

The report designer should be planned as a later milestone. The first version should be a developer-defined report schema with a runtime viewer.

Report concepts:

- Data source.
- Parameters.
- Layout sections.
- Tables.
- Grouping.
- Totals.
- Conditional formatting.
- Export targets.

Output formats:

- HTML preview.
- PDF export.
- CSV/Excel export later.

### Report Generator

Prefer server-side generation for official PDFs:

- Stable fonts and layout.
- Better permission checks.
- Audit trail for generated reports.
- Background job support.
- Easier storage and sharing.

### Dashboards

Dashboard data should use read models, materialized views, cached aggregates, or scheduled summaries when source data grows.

Initial widgets:

- KPI card.
- Time series chart.
- Bar chart.
- Table widget.
- Activity feed.
- Alert list.

Dashboard rules:

- Every metric has an owner and definition.
- Every widget declares refresh strategy.
- Avoid expensive live queries from the client.
- Realtime dashboards should be opt-in.

## 11. Security, Permissions, And Audit

### Permission Model

Start with role-based access control and leave room for policy-based checks.

Minimum permission dimensions:

- Module access.
- Record read.
- Record create.
- Record update.
- Record delete.
- Restore.
- Export.
- Share.
- Admin/configure.

### Audit Trail

All important business actions should emit audit events:

- Create.
- Update.
- Soft delete.
- Restore.
- Export.
- Share record.
- Permission change.
- Login/security event.

Audit records should include:

- Actor.
- Timestamp.
- Action.
- Target record.
- Before/after summary where appropriate.
- Request/session metadata.

## 12. AI-Friendly Development Process

The repository should be designed so an AI agent can work safely without relying on hidden context.

### Required Project Artifacts

Create these before heavy implementation:

```text
README.md
docs/product/PRODUCT_GUIDELINE.md
docs/product/UX_PATTERNS.md
docs/engineering/ARCHITECTURE.md
docs/engineering/TESTING_STRATEGY.md
docs/engineering/AI_AGENT_WORKFLOW.md
docs/adr/0001-technology-baseline.md
docs/adr/0002-client-architecture.md
docs/adr/0003-backend-architecture.md
```

### Feature Folder Contract

Every feature should have:

```text
features/<feature-name>/
  SPEC.md
  UX.md
  DATA.md
  ACCEPTANCE.md
  TEST_PLAN.md
```

The AI agent should implement only after these are clear enough to test.

### Definition Of Ready

A feature is ready when:

- Problem statement is clear.
- User roles are identified.
- Data model draft exists.
- UX pattern is selected.
- Acceptance criteria are testable.
- Security and permission expectations are stated.
- Migration impact is known.

### Definition Of Done

A feature is done when:

- Unit tests pass.
- Widget tests cover core UI states.
- Integration or end-to-end test covers the main path.
- Server tests cover endpoint behavior.
- Migration is generated and tested if schema changed.
- Docs updated.
- At least one example or reference screen exists.
- GitHub PR describes behavior, risks, and verification.

## 13. Testing Strategy

Flutter's official testing stack includes unit tests and widget tests using `flutter_test`; `WidgetTester` builds and interacts with widgets in test environments. Source: [Flutter widget testing](https://docs.flutter.dev/cookbook/testing/widget/introduction).

Recommended layers:

- Unit tests: domain logic, validation, ViewModels, repositories with fakes.
- Widget tests: form validation, list states, preview sheet, dialogs, permission states.
- Golden tests: key UI components and responsive layouts.
- Integration tests: login, list search, edit/save, draft recovery, soft delete/restore.
- Server tests: endpoints, permissions, migrations, audit events.
- Contract tests: data source adapters behave the same against fake, Serverpod, Supabase, and local cache.

Minimum first milestone test targets:

- ViewModel state transitions.
- Field validation rules.
- Draft save/restore.
- Soft delete/restore.
- Record sharing permission check.
- Server endpoint happy path and permission denial.

## 14. GitHub Workflow

Recommended workflow:

- `main` is protected.
- All work happens on branches prefixed with `codex/`, `feature/`, or `fix/`.
- Every change goes through pull request review.
- PR template requires summary, acceptance criteria, test evidence, screenshots for UI, migration notes, and risk notes.
- GitHub Issues track features and bugs.
- GitHub Projects or milestones track roadmap phases.
- ADRs document architecture choices.

Recommended CI checks:

- Dart format check.
- Static analysis.
- Unit tests.
- Widget tests.
- Server tests.
- Build web.
- Build one desktop target in CI if available.
- Migration validation.

## 15. Roadmap

### Phase 0: Product Definition And Repository Setup

Purpose: Convert the idea into a controlled software program.

Deliverables:

- Product guideline.
- UX pattern guide.
- Architecture baseline.
- Testing strategy.
- ADRs for stack choices.
- GitHub branch protection and PR template.
- Initial monorepo structure.

Exit criteria:

- Team can explain what fLOBster is and is not.
- First vertical slice is selected.
- Development workflow is documented.

### Phase 1: Reference App Vertical Slice

Purpose: Prove the framework through one real business module.

Selected module: Contact Management with separate Person, Company, and Organization models.

Deliverables:

- Flutter app shell.
- Person, Company, and Organization list views.
- Search and filters.
- Right-side preview sheet.
- Full create/edit forms for people, companies, and organizations.
- Field validation.
- Draft recovery.
- Serverpod backend with PostgreSQL.
- Soft delete and admin-only restore.
- Audit event creation.
- Unit, widget, and endpoint tests.

Exit criteria:

- A user can create, search, edit, delete, and inspect people, companies, and organizations.
- An administrator can restore soft-deleted records.
- A crashed or closed form can be recovered from draft.
- The same validation rules are tested outside the UI.

### Phase 2: Framework Extraction

Purpose: Turn repeated reference-app patterns into reusable packages.

Deliverables:

- `flobster_ui` list/sheet/form primitives.
- `flobster_forms` metadata and validation contracts.
- `flobster_data` repository interfaces.
- `flobster_workflow` record lifecycle helpers.
- Example module using extracted packages.

Exit criteria:

- A second module can be built faster than the first.
- Framework code is documented by examples and tests.

### Phase 3: Realtime And Record Sharing

Purpose: Add communication inside business workflows.

Deliverables:

- Chat service.
- Notification center.
- Record reference card.
- Share record action from preview sheet and full form.
- Permission check before recipient opens a shared record.
- Presence indicator for viewed records.

Exit criteria:

- User A can share a person, company, or organization record to User B in chat.
- User B can open it only if permission allows.
- Notification and activity trail record the event.

### Phase 4: Reports And Dashboards

Purpose: Add business visibility.

Deliverables:

- Developer-defined report schema.
- HTML report preview.
- Server-generated PDF.
- Basic dashboard widgets.
- Cached aggregate/read-model pattern.

Exit criteria:

- A user can generate a Contact Management summary report as HTML/PDF.
- A dashboard can show at least three metrics without direct heavy client queries.

### Phase 5: Offline Mobile Subset

Purpose: Support practical mobile workflows.

Deliverables:

- Mobile navigation shell.
- Record search and summary view.
- Simple create/edit for selected fields.
- Local draft storage.
- Offline queue for simple operations.
- Sync status and conflict UX.

Exit criteria:

- Mobile user can view cached records and submit a simple edit once online.
- Conflict state is understandable and recoverable.

### Phase 6: Supabase Adapter

Purpose: Support cloud database and BaaS deployments.

Deliverables:

- Supabase data service adapter.
- Auth integration spike.
- Realtime adapter spike.
- RLS examples.
- Documentation for when to use Supabase directly versus Serverpod.

Exit criteria:

- One module can read/write through Supabase with RLS enabled.
- Adapter passes the same repository contract tests as Serverpod where applicable.

## 16. First 30 Days

Start here:

1. Create repository foundation: README, docs folders, ADR template, PR template, CI skeleton.
2. Write `PRODUCT_GUIDELINE.md` from this plan and lock the first vertical slice.
3. Create Flutter and Serverpod proof-of-concept scaffold.
4. Define Person, Company, and Organization models with audit and soft delete fields.
5. Implement Contact Management lists, preview sheets, and forms as the reference workflow.
6. Add validation and draft recovery before adding more modules.
7. Add endpoint tests and widget tests early.
8. Review with stakeholders before extracting framework packages.

## 17. Decisions Needed From Product Owner

The next planning conversation should settle:

- Required Phase 1 form fields for Person, Company, and Organization.
- Deployment model: internal enterprise app, SaaS, or both.
- Authentication source: Serverpod auth, Supabase auth, enterprise SSO, or staged decision.
- Offline priority: mobile drafts only, or true offline sync.
- Report designer priority: developer-defined reports first, or user-facing designer sooner.
- Desktop priority: macOS first, Windows first, or both.
- Data access policy: whether direct PostgreSQL access is allowed for any production client.

## 18. Initial Recommendation

Begin with a Contact Management vertical slice on Flutter macOS desktop plus Serverpod/PostgreSQL. Model Person, Company, and Organization as separate records. Defer Windows, web, mobile offline, Supabase adapter, and visual report designer until the core CRUD workflow is proven.

This is the best starting point because it exercises the framework's most important reusable pieces: list view, preview sheet, full form, validation, drafts, save states, soft delete, admin-only restore, permissions, audit, and tests.
