package api

import (
	"net/http"
	"xiaomian/backend/src/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type CustomerHandler struct {
	DB *gorm.DB
}

func (h *CustomerHandler) GetCustomers(c *gin.Context) {
	var customers []models.Customer
	h.DB.Find(&customers)
	c.JSON(http.StatusOK, customers)
}

func (h *CustomerHandler) CreateCustomer(c *gin.Context) {
	var customer models.Customer
	if err := c.ShouldBindJSON(&customer); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	h.DB.Create(&customer)
	c.JSON(http.StatusCreated, customer)
}
