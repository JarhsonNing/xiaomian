package api

import (
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	// CORS or other middleware can be added here
	
	v1 := r.Group("/v1")
	{
		// Product routes
		products := v1.Group("/products")
		{
			products.GET("/", func(c *gin.Context) { c.JSON(200, gin.H{"message": "pong"}) })
		}
		
		// Order routes
		orders := v1.Group("/orders")
		{
			orders.POST("/", func(c *gin.Context) { c.JSON(201, gin.H{"id": 1}) })
		}
	}

	return r
}
