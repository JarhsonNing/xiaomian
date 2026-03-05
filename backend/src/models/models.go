package models

import (
	"time"

	"github.com/google/uuid"
)

type Product struct {
	ID                 uint      `gorm:"primaryKey" json:"id"`
	Name               string    `gorm:"not null" json:"name"`
	Alias              string    `json:"alias"`
	DefaultPrice       float64   `gorm:"type:decimal(10,2);not null" json:"default_price"`
	PinyinAbbreviation string    `gorm:"index;not null" json:"pinyin_abbreviation"`
	CostPrice          float64   `gorm:"type:decimal(10,2)" json:"cost_price"`
	CreatedAt          time.Time `json:"created_at"`
}

type Customer struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	Name      string    `gorm:"not null" json:"name"`
	Phone     string    `json:"phone"`
	IsActive  bool      `gorm:"default:true" json:"is_active"`
	CreatedAt time.Time `json:"created_at"`
}

type CustomerProductPrice struct {
	CustomerID  uint    `gorm:"primaryKey" json:"customer_id"`
	ProductID   uint    `gorm:"primaryKey" json:"product_id"`
	CustomPrice float64 `gorm:"type:decimal(10,2);not null" json:"custom_price"`
}

type Order struct {
	ID                uint        `gorm:"primaryKey" json:"id"`
	ClientUUID        uuid.UUID   `gorm:"type:uuid;not null;index" json:"client_uuid"`
	CustomerID        uint        `gorm:"not null" json:"customer_id"`
	TotalAmount       float64     `gorm:"type:decimal(10,2);not null" json:"total_amount"`
	PrintCount        int         `gorm:"default:0" json:"print_count"`
	IsOfflineOrigin   bool        `gorm:"default:false" json:"is_offline_origin"`
	OriginalCreatedAt time.Time   `gorm:"not null" json:"original_created_at"`
	CreatedAt         time.Time   `json:"created_at"`
	SyncedAt          time.Time   `gorm:"autoCreateTime" json:"synced_at"`
	Items             []OrderItem `gorm:"foreignKey:OrderID" json:"items"`
}

type OrderItem struct {
	ID            uint    `gorm:"primaryKey" json:"id"`
	OrderID       uint    `json:"order_id"`
	ProductID     uint    `gorm:"not null" json:"product_id"`
	SnapshotName  string  `gorm:"not null" json:"snapshot_name"`
	SnapshotPrice float64 `gorm:"type:decimal(10,2);not null" json:"snapshot_price"`
	Quantity      float64 `gorm:"type:decimal(10,2);not null" json:"quantity"`
}
