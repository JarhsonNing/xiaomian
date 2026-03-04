package api

import (
	"net/http"
	"xiaomian/backend/src/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type OrderHandler struct {
	DB *gorm.DB
}

func (h *OrderHandler) CreateOrder(c *gin.Context) {
	var input struct {
		CustomerID uint `json:"customer_id"`
		Items      []struct {
			ProductID  uint    `json:"product_id"`
			Quantity   float64 `json:"quantity"`
			FinalPrice float64 `json:"final_price"`
		} `json:"items"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	tx := h.DB.Begin()
	order := models.Order{
		CustomerID:  input.CustomerID,
		TotalAmount: 0,
	}
	tx.Create(&order)

	for _, item := range input.Items {
		var product models.Product
		tx.First(&product, item.ProductID)
		
		orderItem := models.OrderItem{
			OrderID:       order.ID,
			ProductID:     item.ProductID,
			SnapshotName:  product.Name,
			SnapshotPrice: item.FinalPrice,
			Quantity:      item.Quantity,
		}
		tx.Create(&orderItem)
		order.TotalAmount += item.FinalPrice * item.Quantity

		// T025: Update permanent price mapping for the customer
		var mapping models.CustomerProductPrice
		mapping.CustomerID = input.CustomerID
		mapping.ProductID = item.ProductID
		mapping.CustomPrice = item.FinalPrice
		tx.Save(&mapping)
	}
	
	tx.Save(&order)
	tx.Commit()

	c.JSON(http.StatusCreated, order)
}
