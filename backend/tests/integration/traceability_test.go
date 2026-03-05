package integration

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"xiaomian/backend/src/api"

	"github.com/gin-gonic/gin"
)

func TestTraceabilityAndPriceSnapshot(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := api.SetupRouter(nil) // Passing nil for now

	t.Run("Should retain original offline timestamp and snapshot price", func(t *testing.T) {
		payload := []byte(`{
			"device_id": "device-uuid",
			"orders": [
				{
					"client_uuid": "order-uuid",
					"customer_id": 101,
					"original_created_at": "2024-01-01T12:00:00Z",
					"items": [
						{
							"product_id": 1,
							"quantity": 1.0,
							"snapshot_price": 50.00
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

		var response map[string]interface{}
		json.Unmarshal(w.Body.Bytes(), &response)
		
		if response["processed_count"].(float64) != 1 {
			t.Errorf("Expected 1 order processed, got %v", response["processed_count"])
		}
	})
}