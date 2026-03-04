package api

import (
	"net/http"
	"xiaomian/backend/src/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type ProductHandler struct {
	DB *gorm.DB
}

func (h *ProductHandler) GetProducts(c *gin.Context) {
	var products []models.Product
	h.DB.Find(&products)
	c.JSON(http.StatusOK, products)
}

func (h *ProductHandler) CreateProduct(c *gin.Context) {
	var product models.Product
	if err := c.ShouldBindJSON(&product); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	h.DB.Create(&product)
	c.JSON(http.StatusCreated, product)
}
