package services

import (
	"xiaomian/backend/src/models"
)

// ResolvePrice determines the price for a specific product and customer.
// It returns the custom price if a mapping exists, otherwise the default product price.
func ResolvePrice(product models.Product, customerID uint, priceMaps []models.CustomerProductPrice) float64 {
	for _, mapping := range priceMaps {
		if mapping.ProductID == product.ID && mapping.CustomerID == customerID {
			return mapping.CustomPrice
		}
	}
	return product.DefaultPrice
}
