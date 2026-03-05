package api

import (
	"net/http"
	"xiaomian/backend/src/services"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupRouter(db *gorm.DB) *gin.Engine {
	r := gin.Default()

	productHandler := &ProductHandler{DB: db}
	customerHandler := &CustomerHandler{DB: db}
	priceMapHandler := &PriceMapHandler{DB: db}
	orderHandler := &OrderHandler{DB: db}

	v1 := r.Group("/v1")
	{
		// Product routes
		products := v1.Group("/products")
		{
			products.GET("/", productHandler.GetProducts)
			products.POST("/", productHandler.CreateProduct)
		}

		// Customer routes
		customers := v1.Group("/customers")
		{
			customers.GET("/", customerHandler.GetCustomers)
			customers.POST("/", customerHandler.CreateCustomer)
			customers.GET("/:id/prices", priceMapHandler.GetCustomerPrices)
		}

		// Price Mapping
		v1.POST("/prices", priceMapHandler.SetPrice)

		// Order routes
		orders := v1.Group("/orders")
		{
			orders.POST("/", orderHandler.CreateOrder)
			orders.POST("/bulk-sync", BulkSyncOrders)
		}
	}

	return r
}

type SyncRequest struct {
	DeviceID string                   `json:"device_id"`
	Orders   []services.SyncOrderDTO  `json:"orders"`
}

func BulkSyncOrders(c *gin.Context) {
	var req SyncRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "INVALID_SNAPSHOT",
			"message": err.Error(),
		})
		return
	}

	svc := services.NewSyncService()
	result, err := svc.ProcessBulkSync(req.DeviceID, req.Orders)
	
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, result)
}
