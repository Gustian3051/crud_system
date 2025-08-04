package database

import (
	"fmt"
	"log"
	"tes-app/internal/config"
	"tes-app/internal/models"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectPostgres() {
	cfg := config.AppConfig

	dsn := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=%s",
		cfg.DBHost,
		cfg.DBUser,
		cfg.DBPass,
		cfg.DBName,
		cfg.DBPort,
		cfg.DBSSLMode,
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(err)
	}

	DB = db
	log.Println("Database connected!")

	autoMigrate()
}

func autoMigrate() {
	err := DB.AutoMigrate(
		&models.User{},

	)

	if err != nil {
		log.Fatalf("Auto Migration Failed: %v", err)
	}
	log.Println("Auto Migration Complete!")
}
