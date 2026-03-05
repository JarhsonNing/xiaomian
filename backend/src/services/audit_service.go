package services

import (
	"log"
	"time"
)

// LogPriceOverride records price discrepancies or overrides
func LogPriceOverride(orderID string, productID uint, expectedPrice, snapshotPrice float64) {
	if expectedPrice != snapshotPrice {
		log.Printf("[AUDIT] Price Override Detected - Order: %s | Product: %d | Expected: %.2f | Snapshot: %.2f | Time: %s\n",
			orderID, productID, expectedPrice, snapshotPrice, time.Now().Format(time.RFC3339))
	}
}
