package api

import (
	"net/http"
	"xiaomian/backend/src/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type PriceMapHandler struct {
	DB *gorm.DB
}

func (h *PriceMapHandler) GetCustomerPrices(c *gin.Context) {
	customerID := c.Param("id")
	var prices []models.CustomerProductPrice
	h.DB.Where("customer_id = ?", customerID).Find(&prices)
	c.JSON(http.StatusOK, prices)
}

func (h *PriceMapHandler) SetPrice(c *gin.Context) {
	var mapping models.CustomerProductPrice
	if err := c.ShouldBindJSON(&mapping); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	h.DB.Save(&mapping)
	c.JSON(http.StatusOK, mapping)
}
