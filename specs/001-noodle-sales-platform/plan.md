# Implementation Plan: Noodle Shop Sales Platform

**Branch**: `001-noodle-sales-platform` | **Date**: 2026-03-03 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-noodle-sales-platform/spec.md`

## Summary

Build a dual-terminal sales management system. The PC terminal (React) handles product/customer data management, while the Mobile terminal (WeChat Mini Program) provides a fast ordering interface with Bluetooth receipt printing. The system prioritizes data traceability (price snapshots) and accessibility (large font support).

## Technical Context

**Language/Version**: Golang 1.21+ (Backend), React 18+ (PC), WeChat Mini Program SDK (Mobile)
**Primary Dependencies**: Gin (Web Framework), GORM (ORM), Ant Design (PC UI), `pinyin-pro` (Pinyin logic), ESC/POS library for WeChat (Printing)
**Storage**: PostgreSQL (Canonical storage)
**Testing**: Go Test (Backend), Vitest/Cypress (PC), Mini Program Automated Test
**Target Platform**: Web (Chrome/Edge), WeChat (Android/iOS)
**Project Type**: Full-stack Application
**Performance Goals**: Order confirmation < 1s, Printing latency < 1s
**Constraints**: Bluetooth ESC/POS compatibility, Pinyin-based fast search
**Scale/Scope**: Support hundreds of products and thousands of orders per day

## Constitution Check

| Principle | Status | Implementation Strategy |
|-----------|--------|-------------------------|
| I. Library-First | ✅ | Create `lib-pricing` for logic involving customer-product price resolution and `lib-printer` for ESC/POS formatting. |
| II. API-First | ✅ | Standardized RESTful endpoints for all management and ordering functions. |
| III. TDD | ✅ | Mandatory unit tests for pricing logic and API contract tests before frontend implementation. |
| IV. Traceability | ✅ | Every `OrderItem` records `SnapshotPrice` and `CustomerID` at creation time. |
| V. Accessibility | ✅ | Design a "High Contrast/Large Font" theme for the Mini Program. |

## Project Structure

### Documentation (this feature)

```text
specs/001-noodle-sales-platform/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (API definitions)
└── tasks.md             # Phase 2 output (future)
```

### Source Code (repository root)

```text
backend/                 # Golang API
├── src/
│   ├── models/
│   ├── services/        # lib-pricing, lib-printer implementation
│   └── api/             # Gin routes and handlers
└── tests/

frontend-pc/             # React App
├── src/
│   ├── components/
│   ├── pages/           # Product and Customer management
│   └── services/        # API consumption
└── tests/

frontend-mobile/         # WeChat Mini Program
├── src/
│   ├── components/
│   ├── pages/           # Fast ordering flow
│   └── services/        # Bluetooth and API logic
└── tests/
```

**Structure Decision**: Option 2 (Web application) extended to include WeChat Mini Program source directory.

## Complexity Tracking

*No violations detected.*
