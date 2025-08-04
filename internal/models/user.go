package models

import "github.com/google/uuid"

type User struct {
	ID        uuid.UUID `gorm:"type:uuid;primary_key" json:"id"`
	FirstName string    `gorm:"type:varchar(255)" json:"first_name"`
	LastName  string    `gorm:"type:varchar(255)" json:"last_name"`
	Email     string    `gorm:"type:varchar(255)" json:"email"`
	Password  string    `gorm:"type:varchar(255)" json:"password"`
}
