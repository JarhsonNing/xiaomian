package unit

import (
	"testing"
	"xiaomian/backend/src/models"
)

func TestProductCreation(t *testing.T) {
	product := models.Product{
		Name: "Beef Noodle",
		DefaultPrice: 15.00,
		PinyinAbbreviation: "BN",
	}
	
	if product.Name != "Beef Noodle" {
		t.Errorf("Expected Name Beef Noodle, got %s", product.Name)
	}
}
