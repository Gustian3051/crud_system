package main

import (
	"fmt"
	"tes-app/database"
	"tes-app/internal/config"
	"tes-app/internal/routes"
)

func main() {
	config.LoadConfig()
	database.ConnectPostgres()

	r := routes.InitRoutes()
	
	port := ":8080"
	
	fmt.Printf("Server running at: http://localhost:%s\n", port)
	
	r.Run(port)
}