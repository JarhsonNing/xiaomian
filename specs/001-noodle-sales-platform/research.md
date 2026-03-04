# Research Report: Noodle Shop Sales Platform

## Decision: Bluetooth Printing (ESC/POS)
**Decision**: Use `wx.writeBLECharacteristicValue` with a buffer chunking utility.
**Rationale**: 
- WeChat Mini Program's Bluetooth API has a 20-byte MTU limit by default. A library or utility function must split the ESC/POS binary data into chunks.
- Standard ESC/POS commands (e.g., `0x1B 0x40` for init, `0x0A` for line feed) will be used to ensure compatibility with most thermal receipt printers.

## Decision: Pinyin Generation
**Decision**: Client-side generation (PC) using `pinyin-pro` library.
**Rationale**: 
- Generating Pinyin abbreviations (e.g., "NRM" for "牛肉面") during product creation on the PC terminal reduces backend processing.
- The abbreviation will be stored as an indexed field in the database for fast searching on the mobile terminal.

## Decision: Price Mapping Storage
**Decision**: Relational table `customer_product_prices` with composite primary key `(customer_id, product_id)`.
**Rationale**: 
- This allows O(1) lookup during order creation.
- When selecting a customer, the system will fetch the full map for that customer to minimize subsequent API calls during item selection.

## Alternatives Considered
- **Server-side Pinyin**: Rejected to simplify Go backend dependencies.
- **WebSocket for Sync**: Rejected; polling or manual refresh is sufficient for the current scale and reduces infrastructure complexity.
