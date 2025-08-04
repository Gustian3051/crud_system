package handler

import (
	"net/http"
	"tes-app/internal/services"
	"tes-app/internal/utils"

	"github.com/gin-gonic/gin"
)

type UserRequest struct {
	FirstName string `json:"first_name" binding:"required"`
	LastName  string `json:"last_name" binding:"required"`
	Email     string `json:"email" binding:"required"`
	Password  string `json:"password" binding:"required"`
}

func CreateUserHandler(c *gin.Context) {
	var req UserRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.ResponseError(c, http.StatusBadRequest, "invalid input: "+err.Error())
		return
	}

	user, err := services.CreateUserServices(c, req.FirstName, req.LastName, req.Email, req.Password)
	if err != nil {
		utils.ResponseError(c, http.StatusBadRequest, err.Error())
		return
	}

	utils.ResponseSuccess(c, http.StatusCreated, gin.H{
		"message": "create user successfully!",
		"user_id": user.ID,
		"name":    user.FirstName + " " + user.LastName,
		"email":   user.Email,
	})
}

func UpdateUserHandler(c *gin.Context) {}

func DeleteUserHandler(c *gin.Context) {}

// ! Buatkan fungsi handler untuk menampilkan semua user