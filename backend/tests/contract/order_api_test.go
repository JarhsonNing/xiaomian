package contract

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"
	"xiaomian/backend/src/api"

	"github.com/gin-gonic/gin"
)

func TestOrderCreationContract(t *testing.T) {
	gin.SetMode(gin.TestMode)
	r := api.SetupRouter()

	body := []byte(`{"customer_id": 1, "items": [{"product_id": 1, "quantity": 2, "final_price": 12.0}]}`)
	req, _ := http.NewRequest("POST", "/v1/orders/", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	if w.Code != http.StatusCreated {
		t.Errorf("Expected 201 Created, got %d", w.Code)
	}
}
