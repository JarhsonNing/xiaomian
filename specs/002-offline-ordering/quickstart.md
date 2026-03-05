# Quickstart: Offline Ordering Support

## Environment Setup

### 1. Mobile (Flutter)
Ensure Flutter SDK (3.x) and Android/iOS toolchains are installed.
```bash
cd mobile
flutter pub get
flutter run
```

### 2. Backend (Golang)
Ensure Go 1.21+ and PostgreSQL are installed.
```bash
cd api
go mod download
go run main.go
```

## Running Tests (TDD)
Before implementation, verify existing sync tests fail as expected.

### Mobile Tests
```bash
cd mobile
flutter test
```

### Backend Tests
```bash
cd api
go test ./tests/...
```

## Key Scenarios for Manual Verification
1. **Offline Mode & Storage Limit**: 
   - Put device in Airplane Mode. 
   - Place an order and confirm. 
   - Check local database (use `sqlite3` or Flipper).
   - *Real-world test*: Attempt to create 501 orders while offline to trigger the `StorageFullException`.
2. **Sync Recovery & Exponential Backoff**: 
   - Disable Airplane Mode. 
   - Verify `POST /v1/orders/bulk-sync` is triggered automatically.
   - Confirm record exists on Backend with correct `original_created_at`.
   - *Real-world test*: Restart the API server repeatedly during sync to observe the retry backoff interval increasing.
3. **Traceability & Audit**: 
   - Modify a price on the PC admin panel. 
   - Perform an offline order with the *old* price. 
   - Sync and verify the server saved the old snapshot price and an audit log was generated.
