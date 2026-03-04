# Feature Specification: Noodle Shop Sales Platform

**Feature Branch**: `001-noodle-sales-platform`  
**Created**: 2026-03-02  
**Status**: Draft  
**Input**: User description: "这是一个小面用品销售管理平台。包含后台管理系统和前台下单系统。后台管理系统使用PC，前台下单系统使用微信小程序（支持蓝牙连接小票打印机），包含商品管理、客户管理、订单管理、下单页面等多个模块。商品管理负责管理系统所有商品，商品信息包含名称、别名、价格、拼音、进价（选）等多个字段，如果有别的必须字段，你可以自行设计。客户管理，负责管理客户以及对应的商品价格。订单管理，每个订单应该记住当时的价格，方便后续追溯。下单页面，放便进行下单，选择客户后展示客户对应的商品价格，点击对应的商品弹出数量选择和价格选项。此时可以更改价格，点击确认下单后将价格修改成最新价格，方便后序记录。要求操作简洁，逻辑清晰。最好能兼容大字体设计"

## User Scenarios & Testing

### User Story 1 - Centralized Product & Customer Management (Priority: P1)

As a manager, I want to manage all product information and customer-specific price mappings on a PC, so that the ordering system has accurate data to work with.

**Why this priority**: Essential foundation for any transaction in the system.

**Independent Test**: Can be tested by creating a product and a customer price rule on the PC and verifying they are stored correctly.

**Acceptance Scenarios**:

1. **Given** the product management page, **When** I add a product with Name, Alias, Price, Pinyin, and Cost Price, **Then** it is saved and searchable by Pinyin.
2. **Given** a customer, **When** I set a custom price for a specific product for them, **Then** that rule is persisted and overrides the default product price.

---

### User Story 2 - Fast Mobile Ordering & Bluetooth Printing (Priority: P1)

As a worker, I want to quickly place an order on a WeChat Mini Program, selecting a customer and printing a receipt via Bluetooth, so that I can serve customers efficiently in a high-font, accessible interface.

**Why this priority**: Core revenue-generating flow and primary operational task.

**Independent Test**: Can be tested by selecting a customer on the Mini Program, adding items, and triggering a print command to a mock or real Bluetooth printer.

**Acceptance Scenarios**:

1. **Given** the ordering page, **When** I select a customer, **Then** the list of products displays the customer's specific prices.
2. **Given** an order summary, **When** I confirm the order, **Then** a receipt is sent to the connected Bluetooth printer and the order is saved.

---

### User Story 3 - Dynamic Pricing & Auditability (Priority: P2)

As a worker, I want to adjust product prices on-the-fly during ordering, and have the system remember those prices for that order and future orders for that customer.

**Why this priority**: Necessary for business flexibility and historical price tracking.

**Independent Test**: Can be tested by changing a price during ordering and verifying both the order record and the customer's price rule are updated.

**Acceptance Scenarios**:

1. **Given** a product added to the cart, **When** I tap it to change the price and confirm, **Then** the current order total updates.
2. **Given** a completed order where the price was changed, **When** I view the order later, **Then** it reflects the price at that time, and the system **automatically updates the permanent price mapping** for that customer so the next order defaults to the new price.

---

## Clarifications

### Session 2026-03-03

- Q: 在下单页面修改价格并确认后，系统应该如何处理这个“最新价格”？ → A: 自动更新：永久修改该客户对应此商品的定价映射，后续订单默认使用此新价格。
- Q: 如果在下单确认时蓝牙打印机未连接或打印失败，系统应如何处理？ → A: 延后重试：先保存订单，打印失败则在订单详情或提示中点击“重新打印”。
- Q: 当 PC 端修改商品价格或客户映射时，正在使用小程序下单的工作人员应如何感知？ → A: 实时查询：每次在小程序选择客户时，都向服务器查询该客户当前最新的商品价格。
- Q: 当多个商品具有相同的拼音缩写（如“牛肉面”和“牛肉末”都是 NRM）时，搜索结果应如何展示？ → A: 列表点选：展示所有匹配的商品列表，用户点击其中一项进入详情或加入购物车。
- Q: 为了兼容“大字体设计”，系统应如何处理 UI 的缩放？ → A: 自适应系统：UI 默认大按钮大间距，且能够响应微信或系统的字体缩放设置。

## Edge Cases

- **Connectivity**: If the Bluetooth printer is disconnected or out of paper, the system MUST save the order successfully and prompt the user with a "Print Failed" warning. A "Re-print" button must be available in the order details or confirmation screen.
- **Sync Conflict**: The Mini Program MUST fetch the latest customer-specific pricing at the moment of customer selection to minimize stale price risks. If a price is updated on the PC while an order is in progress, the order will use the price fetched at selection unless manually updated.
- **Pinyin Collision**: When a search query matches multiple products' Pinyin or Name/Alias, the Mini Program MUST display a selection list containing all candidates. The user must manually tap the correct item to proceed.

## Requirements

### Functional Requirements

- **FR-001**: System MUST provide a PC interface for managing Product master data (Name, Alias, Default Price, Pinyin, Cost Price).
- **FR-002**: System MUST allow defining Customer-Product price mappings that override default prices.
- **FR-003**: Mini Program MUST allow searching products by Name, Alias, or Pinyin and MUST present a disambiguation list for multiple matches.
- **FR-004**: Ordering system MUST automatically load customer-specific prices upon customer selection.
- **FR-005**: System MUST support quantity selection and manual price overrides during the ordering flow.
- **FR-006**: System MUST persist the specific price of each item at the moment of order confirmation.
- **FR-007**: Mini Program MUST integrate with Bluetooth receipt printers (ESC/POS protocol) and provide a manual "Re-print" function for past orders.
- **FR-008**: UI MUST support a "Large Font" mode or be designed with large, high-contrast elements by default (min 20px for labels).

### Non-Functional Requirements

- **NFR-001**: UI MUST be responsive to system-level font scale settings (e.g., WeChat font sizing) and remain functional at 1.5x zoom.
- **NFR-002**: Critical touch targets (buttons, list items) MUST be at least 48x48px for accessibility.
- **NFR-003**: Bluetooth printing SHOULD be triggered immediately upon order confirmation.

### Key Entities

- **Product**: Master record for items sold. Attributes: ID, Name, Alias, DefaultPrice, PinyinSearch, CostPrice (optional).
- **Customer**: Profile for regular buyers. Attributes: ID, Name, Contact, Status.
- **CustomerPriceMap**: Links Customer to Product with a specific Price.
- **Order**: Record of transaction. Attributes: ID, CustomerID, TotalAmount, CreatedAt, PrintStatus.
- **OrderItem**: Specific items in an order. Attributes: OrderID, ProductID, SnapshotPrice, Quantity.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Workers can complete a 5-item order from customer selection to "Confirm" in under 30 seconds.
- **SC-002**: Bluetooth printing starts within 1 second of order confirmation.
- **SC-003**: Order history retrieval displays the original transaction price with 100% accuracy regardless of subsequent price changes.
- **SC-004**: UI elements remain fully visible and usable when system font scale is set to 1.5x.
