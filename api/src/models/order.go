package models

import (
	"time"

	"github.com/google/uuid"
)

// Order represents the canonical record on the backend.
type Order struct {
	ID                uint      `gorm:"primaryKey" json:"id"`
	ClientUUID        uuid.UUID `gorm:"type:uuid;not null;index" json:"client_uuid"`
	CustomerID        int       `gorm:"not null" json:"customer_id"`
	TotalPrice        float64   `gorm:"type:decimal(10,2);not null" json:"total_price"`
	IsOfflineOrigin   bool      `gorm:"default:false" json:"is_offline_origin"`
	OriginalCreatedAt time.Time `gorm:"not null" json:"original_created_at"`
	SyncedAt          time.Time `gorm:"autoCreateTime" json:"synced_at"`
	Items             []OrderItem `gorm:"foreignKey:OrderID" json:"items"`
}

// OrderItem represents a specific item within an order.
type OrderItem struct {
	ID            uint    `gorm:"primaryKey" json:"id"`
	OrderID       uint    `json:"order_id"`
	ProductID     int     `gorm:"not null" json:"product_id"`
	Quantity      float64 `gorm:"type:decimal(10,2);not null" json:"quantity"`
	SnapshotPrice float64 `gorm:"type:decimal(10,2);not null" json:"snapshot_price"`
}
