package services

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"tes-app/database"
	"tes-app/internal/models"
	"tes-app/internal/utils"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

func CreateUserServices(ctx context.Context, firstName, lastName, email, password string) (*models.User, error) {
	db := database.DB
	email = strings.ToLower(strings.TrimSpace(email))

	var existing models.User
	if err := db.WithContext(ctx).Where("email = ?", email).First(&existing).Error; err == nil {
		return nil, errors.New("user already exists")
	}

	hashedPassword, err := utils.HashPassword(password)
	if err != nil {
		return nil, fmt.Errorf("failed to hash password: %v", err)
	}

	user := &models.User{
		ID:        uuid.New(),
		FirstName: firstName,
		LastName:  lastName,
		Email:     email,
		Password:  hashedPassword,
	}

	if err := db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(user).Error; err != nil {
			return fmt.Errorf("failed to create user: %v", err)
		}
		return nil
	}); err != nil {
		return nil, fmt.Errorf("transaction failed: %v", err)
	}
	return user, nil
}

func UpdateUserServices(ctx context.Context, id uuid.UUID, firstName, lastName, email, password string) (*models.User, error) {
	return nil, nil
}

func DeleteUserServices(ctx context.Context, id uuid.UUID) error {
	return nil
}

// ! Buatkan fungsi services untuk menampilkan semua user