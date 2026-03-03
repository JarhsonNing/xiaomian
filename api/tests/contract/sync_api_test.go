package contract

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"
	
	myapi "xiaomian/api/src/api"

	"github.com/gin-gonic/gin"
)

func TestBulkSyncOrdersContract(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := myapi.SetupRouter()

	t.Run("Should return 201 Created for valid sync payload", func(t *testing.T) {
		payload := []byte(`{
			"device_id": "test-device-uuid",
			"orders": [
				{
					"client_uuid": "550e8400-e29b-41d4-a716-446655440000",
					"customer_id": 101,
					"original_created_at": "2026-03-03T08:30:00Z",
					"items": [
						{
							"product_id": 1,
							"quantity": 2.0,
							"snapshot_price": 12.50
						}
					]
				}
			]
		}`)

		req, _ := http.NewRequest("POST", "/v1/orders/bulk-sync", bytes.NewBuffer(payload))
		req.Header.Set("Content-Type", "application/json")

		w := httptest.NewRecorder()
		router.ServeHTTP(w, req)

		if w.Code != http.StatusCreated {
			t.Errorf("Expected status 201, got %v", w.Code)
		}
	})
}
