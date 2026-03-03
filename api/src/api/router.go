package api

import (
	"net/http"
	"xiaomian/api/src/services"

	"github.com/gin-gonic/gin"
)

// SetupRouter initializes the API routes.
func SetupRouter() *gin.Engine {
	r := gin.Default()

	v1 := r.Group("/v1")
	{
		orders := v1.Group("/orders")
		{
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
