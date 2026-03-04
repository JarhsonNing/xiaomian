# Tasks: Noodle Shop Sales Platform

**Input**: Design documents from `/specs/001-noodle-sales-platform/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/api-contracts.md

**Tests**: TDD is MANDATORY per the Project Constitution (Principle III). Tests must be written and fail before implementation.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization for Backend, PC, and Mobile

- [x] T001 Initialize Golang backend project in `backend/`
- [x] T002 Initialize React (Vite) PC project in `frontend-pc/`
- [x] T003 Initialize WeChat Mini Program project in `frontend-mobile/`
- [x] T004 [P] Configure shared linting and formatting rules for Go, TS, and CSS
- [x] T005 [P] Setup PostgreSQL database schema per `data-model.md` in `backend/migrations/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core logic libraries and base API routing

- [x] T006 [P] Implement `lib-pricing` for customer price resolution logic in `backend/src/services/pricing_service.go`
- [x] T007 [P] Implement `lib-printer` for ESC/POS formatting in `frontend-mobile/src/services/printer_formatter.js`
- [x] T008 Define core GORM models (Product, Customer, PriceMap, Order) in `backend/src/models/`
- [x] T009 Setup base Gin router and error handling middleware in `backend/src/api/router.go`

**Checkpoint**: Foundation ready - pricing logic and database models available.

---

## Phase 3: User Story 1 - Centralized Product & Customer Management (Priority: P1)

**Goal**: Enable managers to manage products and customer-specific prices on PC.

**Independent Test**: Create a product and a customer mapping on PC, verify via direct API call or DB query.

### Tests for US1 (MANDATORY)

- [x] T010 [P] [US1] Unit tests for Product CRUD logic in `backend/tests/unit/product_test.go`
- [x] T011 [P] [US1] Component tests for Product Form in `frontend-pc/src/components/__tests__/ProductForm.test.tsx`

### Implementation for US1

- [x] T012 [US1] Implement Product management endpoints (GET/POST/PATCH) in `backend/src/api/product_handler.go`
- [x] T013 [US1] Implement Customer management endpoints in `backend/src/api/customer_handler.go`
- [x] T014 [US1] Implement Price Mapping endpoints in `backend/src/api/price_map_handler.go`
- [x] T015 [US1] Create Product Management page with Pinyin generation in `frontend-pc/src/pages/ProductList.tsx`
- [x] T016 [US1] Create Customer-Product price mapping UI in `frontend-pc/src/pages/CustomerPriceMap.tsx`

---

## Phase 4: User Story 2 - Fast Mobile Ordering & Bluetooth Printing (Priority: P1)

**Goal**: Workers can place orders and print receipts via Mini Program.

**Independent Test**: Select customer, search product by Pinyin, confirm order, and verify Bluetooth print output.

### Tests for US2 (MANDATORY)

- [x] T017 [P] [US2] Contract test for Order Creation API in `backend/tests/contract/order_api_test.go`
- [x] T018 [P] [US2] Integration test for Bluetooth chunking logic in `frontend-mobile/tests/unit/printer_service.test.js`

### Implementation for US2

- [x] T019 [US2] Implement Order Creation endpoint with price snapshot logic in `backend/src/api/order_handler.go`
- [x] T020 [US2] Implement Product search (Name/Alias/Pinyin) in `backend/src/services/product_service.go`
- [x] T021 [US2] Create Mobile Ordering page with Customer selection in `frontend-mobile/src/pages/order/index.js`
- [x] T022 [US2] Implement Pinyin-based fast search and list disambiguation in `frontend-mobile/src/pages/order/search.js`
- [x] T023 [US2] Implement Bluetooth printer connection and ESC/POS chunked printing in `frontend-mobile/src/services/bluetooth_service.js`

---

## Phase 5: User Story 3 - Dynamic Pricing & Auditability (Priority: P2)

**Goal**: Adjust prices on-the-fly and update permanent customer mappings.

**Independent Test**: Override price during ordering, verify new price appears as default in the next order for the same customer.

### Tests for US3 (MANDATORY)

- [x] T024 [P] [US3] Unit test for Atomic Price Update logic in `backend/tests/unit/pricing_sync_test.go`

### Implementation for US3

- [x] T025 [US3] Update Order Creation handler to trigger `CustomerProductPrice` update upon confirmation in `backend/src/api/order_handler.go`
- [x] T026 [US3] Create Quantity & Price adjustment popup in `frontend-mobile/src/components/OrderItemEditor.js`
- [x] T027 [US3] Implement Order History view with original price snapshots in `frontend-pc/src/pages/OrderHistory.tsx`

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Accessibility, UI consistency, and final validation.

- [x] T028 [P] Implement Large Font theme using CSS Variables in `frontend-mobile/src/app.wxss`
- [x] T029 [P] Optimize database indices for `pinyin_abbreviation` and `customer_id`
- [x] T030 Final E2E manual walkthrough per `quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

1. **Setup (Phase 1)**: No dependencies.
2. **Foundational (Phase 2)**: Depends on Setup.
3. **User Story 1 (Phase 3)**: Depends on Phase 2.
4. **User Story 2 (Phase 4)**: Depends on US1 (for data) and Phase 2.
5. **User Story 3 (Phase 5)**: Depends on US2 completion.
6. **Polish (Phase 6)**: Final phase.

### Parallel Opportunities

- **T004, T005**: Can run while T001-T003 are initializing.
- **T010, T011**: Tests for US1 can be written simultaneously by Backend and Frontend developers.
- **T017, T018**: Contract tests and local mobile logic can start as soon as US1 is stable.

---

## Implementation Strategy

### MVP Scope
- User Story 1 (Product/Customer Management)
- User Story 2 (Basic Ordering & Printing)

### TDD Workflow
1. Write the test (Go or TS).
2. Run test, confirm failure.
3. Implement minimal code.
4. Run test, confirm pass.
5. Refactor and repeat.
