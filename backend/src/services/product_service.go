package services

import (
	"xiaomian/backend/src/models"
	"gorm.io/gorm"
)

type ProductService struct {
	DB *gorm.DB
}

func (s *ProductService) SearchProducts(query string) []models.Product {
	var products []models.Product
	s.DB.Where("name LIKE ? OR alias LIKE ? OR pinyin_abbreviation LIKE ?", 
		"%"+query+"%", "%"+query+"%", "%"+query+"%").Find(&products)
	return products
}
