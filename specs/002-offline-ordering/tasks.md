# Tasks: Offline Ordering Support

**Input**: Design documents from `/specs/002-offline-ordering/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/api-contracts.md

**Tests**: TDD is MANDATORY per the Project Constitution (Principle III). Tests must be written and fail before implementation.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization for both Backend and Mobile

- [x] T001 Initialize Golang backend project in `api/`
- [x] T002 Initialize Flutter mobile project in `mobile/`
- [x] T003 [P] Configure linting and formatting for Go and Dart
- [x] T004 [P] Setup GitHub Actions/CI for automated testing in both `api/` and `mobile/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure for offline storage and network sensing

- [x] T005 [P] Setup PostgreSQL migration for Orders in `api/migrations/`
- [x] T006 [P] Implement SQLite schema helper in `mobile/lib/store/db_helper.dart`
- [x] T007 [P] Implement Network Connectivity service in `mobile/lib/services/network_service.dart`
- [x] T008 Define shared Order entities in `api/src/models/order.go`
- [x] T009 Define OfflineOrder entities in `mobile/lib/models/offline_order.dart`
- [x] T010 [P] Setup API base routing and Gin middleware in `api/src/api/router.go`

**Checkpoint**: Foundation ready - local storage and network sensing available.

---

## Phase 3: User Story 1 - Seamless Offline Ordering (Priority: P1) 🎯 MVP

**Goal**: Enable workers to save orders locally when the network is unavailable.

**Independent Test**: Put device in Airplane Mode, create an order, verify it exists in SQLite and the UI shows "Saved Offline".

### Tests for User Story 1 (MANDATORY) ⚠️

- [x] T011 [P] [US1] Unit test for SQLite persistence in `mobile/test/store/order_persistence_test.dart`
- [x] T012 [P] [US1] Widget test for Offline Order List UI in `mobile/test/pages/offline_orders_test.dart`

### Implementation for User Story 1

- [x] T013 [P] [US1] Implement OfflineOrder repository in `mobile/lib/store/order_repository.dart`
- [x] T014 [US1] Implement Offline Mode switching logic in `mobile/lib/services/order_manager.dart`
- [x] T015 [US1] Create Offline Orders list page in `mobile/lib/pages/offline_orders_page.dart`
- [x] T016 [US1] Implement "Saved Offline" status badge in `mobile/lib/components/status_badge.dart`
- [x] T017 [US1] Add error handling for "Storage Full" scenario in `mobile/lib/services/order_manager.dart`

**Checkpoint**: User Story 1 is functional. Orders can be placed and viewed offline.

---

## Phase 4: User Story 2 - Automatic Data Synchronization (Priority: P1)

**Goal**: Automatically upload offline orders to the server when network is restored.

**Independent Test**: Restore network, verify orders are POSTed to `/v1/orders/bulk-sync` and deleted locally.

### Tests for User Story 2 (MANDATORY) ⚠️

- [x] T018 [P] [US2] Contract test for Bulk Sync API in `api/tests/contract/sync_api_test.go`
- [x] T019 [P] [US2] Integration test for sync manager with mock server in `mobile/test/services/sync_manager_test.dart`

### Implementation for User Story 2

- [x] T020 [US2] Implement Bulk Sync endpoint in `api/src/api/order_handler.go` (per `api-contracts.md`)
- [x] T021 [US2] Implement Server-side Sync Service logic in `api/src/services/sync_service.go`
- [x] T022 [US2] Implement Sync Manager in `mobile/lib/services/sync_manager.dart` with exponential backoff
- [x] T023 [US2] Implement "Sync Now" manual trigger in `mobile/lib/pages/offline_orders_page.dart`
- [x] T024 [US2] Implement immediate local deletion after successful sync in `mobile/lib/services/sync_manager.dart`

**Checkpoint**: User Story 2 is functional. Automatic sync is active.

---

## Phase 5: User Story 3 - Offline Audit & Traceability (Priority: P2)

**Goal**: Ensure all offline orders can be traced with original timestamps and price snapshots.

**Independent Test**: Check a synced order on Backend, verify `original_created_at` matches local creation time, not sync time.

### Tests for User Story 3 (MANDATORY) ⚠️

- [x] T025 [P] [US3] Integration test for price snapshot integrity in `api/tests/integration/traceability_test.go`

### Implementation for User Story 3

- [x] T026 [US3] Update Backend Order model to include `original_created_at` and `is_offline` in `api/src/models/order.go`
- [x] T027 [US3] Enhance Order History UI to display creation vs sync timestamps in `mobile/lib/pages/order_details_page.dart`
- [x] T028 [US3] Implement audit log for price overrides in `api/src/services/audit_service.go`

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Accessibility, performance, and documentation.

- [x] T029 [P] Implement Large Font theme scaling in `mobile/lib/theme/app_theme.dart` (Constitution Principle V)
- [x] T030 [P] Optimize SQLite queries for rapid search in `mobile/lib/store/order_repository.dart`
- [x] T031 Update `quickstart.md` with real-world verification steps
- [x] T032 Final end-to-end verification of the offline-to-online lifecycle

---

## Dependencies & Execution Order

### Phase Dependencies

1. **Setup (Phase 1)**: No dependencies.
2. **Foundational (Phase 2)**: Depends on Setup. Blocks all stories.
3. **User Story 1 (Phase 3)**: Depends on Phase 2.
4. **User Story 2 (Phase 4)**: Depends on Phase 2 and API Contract from Phase 4.
5. **User Story 3 (Phase 5)**: Depends on US2 completion for synced data.
6. **Polish (Phase 6)**: Final phase.

### Parallel Opportunities

- **Setup**: T001-T004 can run in parallel.
- **Foundational**: T005, T006, T007, T010 can run in parallel.
- **User Stories**: Once Foundation is done, US1 (T013) and US2 (T020) implementation can start in parallel by different developers.
- **Tests**: All test tasks marked [P] can run simultaneously with their respective story implementation.

---

## Implementation Strategy

### MVP First (User Story 1 & 2)

- Focus on achieving a "Walkie-Talkie" sync: save locally (US1) -> detect network -> upload (US2).
- Traceability (US3) follows once the sync pipeline is stable.

### TDD Workflow

- For each task, run the corresponding test (`flutter test` or `go test`).
- Confirm failure.
- Implement logic.
- Confirm pass.
