# Feature Specification: Offline Ordering Support

**Feature Branch**: `002-offline-ordering`  
**Created**: 2026-03-03  
**Status**: Draft  
**Input**: User description: "如果下单页面网络不好，应该将数据存在本地，方便后续无网络追查，其实你使用APP做也行，不一定使用小程序，"

## Clarifications

### Session 2026-03-03

- Q: 您希望继续使用微信小程序实现离线功能，还是切换到开发原生 App（Android/iOS）？ → A: 原生/跨平台 App：支持强大的本地数据库和可靠板的后台同步，用户体验更稳。
- Q: 如果同一客户的同一商品在 PC 端已修改价格，但 App 端的离线订单仍使用旧价格并尝试同步，系统应如何处理？ → A: 接受快照：同步时直接接受该订单的快照价格，不进行价格校验或拦截。
- Q: 为了保证 App 运行流畅，系统应如何处理本地长期积累的已同步订单数据？ → A: 仅存离线：一旦同步成功，立即从本地数据库中删除该订单数据。

## User Scenarios & Testing

### User Story 1 - Seamless Offline Ordering (Priority: P1)

As a delivery worker in areas with poor network coverage, I want to be able to place orders and have them saved locally so that I can continue my work without interruption.

**Why this priority**: Core business continuity requirement. Without this, the system is unusable in low-signal environments.

**Independent Test**: Can be tested by disabling network connectivity, placing an order, and verifying that it is stored in the local database and can be retrieved for viewing.

**Acceptance Scenarios**:

1. **Given** no internet connection, **When** I confirm an order, **Then** the system saves the order locally and shows a "Saved Offline" status.
2. **Given** a locally saved order, **When** I view the "Offline Order List", **Then** I can see the order details and the exact time it was created.

---

### User Story 2 - Automatic Data Synchronization (Priority: P1)

As a worker, I want my locally saved orders to automatically upload to the server once I regain internet access, so that the office staff can process them and records remain consistent.

**Why this priority**: Essential for data integrity and ensuring that all sales are eventually recorded in the central system.

**Independent Test**: Can be tested by creating an offline order, then enabling network connectivity and verifying that the order is sent to the server and its local status updates to "Synced".

**Acceptance Scenarios**:

1. **Given** locally stored unsynced orders, **When** a stable network connection is detected, **Then** the system automatically uploads these orders to the server in the background.
2. **Given** a successful sync, **When** I check the order on the server (PC side), **Then** all details match the original offline order.

---

### User Story 3 - Offline Audit & Traceability (Priority: P2)

As a manager, I want to be able to trace orders that were created while offline, including their original creation time and any local modifications, to ensure accountability.

**Why this priority**: Necessary for resolving disputes and tracking sales performance in remote areas.

**Independent Test**: Can be tested by reviewing a synced order on the PC and checking for "Original Creation Time" and "Sync Time" timestamps.

**Acceptance Scenarios**:

1. **Given** a synced order, **When** viewing details, **Then** both the actual creation time (offline) and the upload time are clearly displayed.

---

## Edge Cases

- **Storage Full**: If the local device storage is full, the App MUST prevent new orders from being created and alert the user to free up space or sync existing data.
- **Sync Conflict**: In case of a price mismatch between the offline App and the PC backend during synchronization, the system MUST prioritize the price snapshot recorded in the offline order to ensure the integrity of the original transaction. No automatic correction or rejection will occur.
- **Long-term Offline**: Since synced orders are deleted immediately (per clarification), the local database will only grow with *unsynced* orders. A hard limit of 500 unsynced orders will be enforced to prevent performance degradation.

## Requirements

### Functional Requirements

- **FR-001**: System MUST provide a dedicated mobile client (Native or Cross-platform App, e.g., Android/iOS via Flutter/React Native) to support robust offline storage and background synchronization.
- **FR-002**: Mobile client MUST detect network status and automatically switch to "Offline Mode" when the connection is unstable or unavailable.
- **FR-003**: System MUST persist unsynced orders in a local database (SQLite or equivalent) to survive application restarts or device reboots.
- **FR-004**: System MUST record the precise timestamp of order creation during offline mode.
- **FR-005**: System MUST attempt to sync pending orders automatically when a network connection is established, accepting all prices as specified in the local snapshot.
- **FR-006**: System MUST provide a manual "Sync Now" button for users to trigger data upload.
- **FR-007**: System MUST provide an "Offline History" view to browse and verify orders that haven't been synced yet.
- **FR-008**: System MUST immediately delete an order from the local database once it is confirmed as successfully synced to the server to maintain a slim local footprint.

### Key Entities

- **OfflineOrder**: Represents an order created without an active connection. Attributes: TempID, CustomerID, Items (JSON), CreatedAt, SyncStatus (Pending), SyncAt (Optional).

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of orders created offline are successfully persisted to local storage without data loss.
- **SC-002**: Background synchronization starts within 5 seconds of regaining a stable network connection.
- **SC-003**: Users can search and view any locally stored order in under 1 second.
- **SC-004**: Order sync process maintains 100% data integrity, with zero discrepancies between local and server records.
