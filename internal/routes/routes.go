package routes

import (
	"log"
	"tes-app/internal/handler"

	"github.com/gin-gonic/gin"
)

func InitRoutes() *gin.Engine {
	gin.SetMode(gin.ReleaseMode)
	
	r := gin.New()

	r.Use(gin.Recovery())

	err := r.SetTrustedProxies([]string{"127.0.0.1"})
	if err != nil {
		log.Panicf("Failed to set trusted proxies: %v", err)
	}

	r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "API Test",
		})
	})

	user := r.Group("/api")
	{
		user.POST("/user", handler.CreateUserHandler)
	}

	return r
}