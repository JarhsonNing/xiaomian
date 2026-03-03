# Research Report: Offline Ordering Support

## Decision: Mobile Framework Selection
**Decision**: Flutter (Dart 3.x)
**Rationale**: 
1. **Performance**: Flutter's native compilation provides smoother performance for large-font, high-contrast UI (Accessibility focus).
2. **Offline-first Architecture**: Direct access to SQLite via optimized FFI (Foreign Function Interface) allows for 100% reliable local persistence for the required 500 orders.
3. **Hardware Integration**: Superior handling of Bluetooth receipt printers via platform-specific plugins, which is more stable than React Native's bridge-based approach for continuous retail operations.
4. **Consistency**: Provides identical pixel-perfect rendering across Android and iOS, crucial for accessibility and large font layouts.

## Decision: Synchronization Mechanism
**Decision**: Exponential Backoff + Bulk Sync (API-First)
**Rationale**: 
- **Reliability**: Using exponential backoff ensures the app doesn't drain the battery or crash during intermittent network transitions.
- **Atomic Operations**: Bulk sync (REST API `POST /orders/sync`) allows all local changes to be sent in a single transaction, reducing the risk of partial sync failures.

## Decision: Local Storage Engine
**Decision**: SQLite (via `sqflite` or `moor/drift`)
**Rationale**: 
- **Standardization**: Industry standard for mobile local persistence.
- **Traceability**: Allows for complex relational queries when auditing offline history ("traceability" principle).
- **Size**: Sufficient for the 500-order limit without performance degradation.

## Alternatives Considered
- **React Native**: Rejected despite the team's PC React experience due to the potential "bridge" bottleneck in high-frequency offline transactions and less consistent UI scaling for large fonts.
- **PWA**: Rejected due to unreliable background sync and limited access to native Bluetooth hardware.
