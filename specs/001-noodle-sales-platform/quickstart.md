# Quickstart: Noodle Shop Sales Platform

## Development Setup

### Backend (Golang)
```bash
cd backend
go mod download
go run main.go
```

### PC Frontend (React)
```bash
cd frontend-pc
npm install
npm run dev
```

### Mobile Frontend (WeChat Mini Program)
1. Open "WeChat DevTools".
2. Import project from `frontend-mobile`.
3. Configure `AppID` and backend API URL in `config.js`.

## Manual Test Flow
1. **Configure Data**: Use the PC terminal to add a product "牛肉面" (Default Price: 15.00).
2. **Set Mapping**: Assign a custom price of 12.00 for "Customer A" on the PC terminal.
3. **Place Order**: 
   - Open Mini Program.
   - Select "Customer A".
   - Search "NRM" (Pinyin).
   - Verify price is 12.00.
   - Change price to 13.00 and confirm.
4. **Verify Persistence**: 
   - Check Order History on PC; verify original price was 13.00.
   - Start a new order for "Customer A"; verify default price is now 13.00.
5. **Print**: Confirm receipt prints correctly via Bluetooth.
