<!--
Sync Impact Report
Version change: [NONE] → 1.0.0
List of modified principles:
- I. Library-First (Added)
- II. API-First (Added)
- III. Test-Driven Development (Added)
- IV. Traceability (Added)
- V. Accessibility & Large Fonts (Added)
Added sections:
- Technology Stack
- Development Workflow
Removed sections: [NONE]
Templates requiring updates:
- .specify/templates/plan-template.md (✅ updated)
- .specify/templates/spec-template.md (✅ updated)
- .specify/templates/tasks-template.md (✅ updated)
Follow-up TODOs: [NONE]
-->

# xiaomian Constitution

## Core Principles

### I. Library-First
Every feature starts as a standalone library; Libraries must be self-contained, independently testable, documented; Clear purpose required - no organizational-only libraries.

### II. API-First
Backend functionality must be exposed via clean APIs (REST or gRPC); Support JSON and consistent error formats; Mini-program and PC clients must consume these APIs.

### III. Test-Driven Development (NON-NEGOTIABLE)
TDD mandatory: Tests written → User approved → Tests fail → Then implement; Red-Green-Refactor cycle strictly enforced.

### IV. Traceability
Every order must record the exact price and customer data at the time of creation for subsequent traceability and audit. Prices should be captured at the moment of transaction to ensure historical accuracy.

### V. Accessibility & Large Fonts
The system MUST support large font designs and maintain high usability for operators in fast-paced retail environments. Logic MUST be clear and operations concise to minimize cognitive load.

## Technology Stack

- **Backend**: Golang
- **PC Management**: React
- **Frontend Ordering**: WeChat Mini Program
- **Hardware**: Bluetooth Receipt Printer Support (WeChat Mini Program)

## Development Workflow

All changes MUST be backed by a Feature Specification and an Implementation Plan. Pull requests MUST pass automated tests and compliance reviews before approval.

## Governance

This constitution supersedes all other practices; Amendments require documentation, version increment, and a migration plan for existing artifacts. All PRs/reviews must verify compliance with these principles.

**Version**: 1.0.0 | **Ratified**: 2026-03-02 | **Last Amended**: 2026-03-02
