package config

import (
	"strings"
	"log"

	"github.com/spf13/viper"
)

type Config struct {
	DBHost    string
	DBPort    string
	DBUser    string
	DBPass    string
	DBName    string
	DBSSLMode string
}

var AppConfig *Config

func LoadConfig() {
	viper.SetConfigFile(".env")
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err != nil {
		log.Fatalf("Failed to read config file, %s", err)
	}

	AppConfig = &Config{
		DBHost:    viper.GetString("DB_HOST"),
		DBPort:    viper.GetString("DB_PORT"),
		DBUser:    viper.GetString("DB_USER"),
		DBPass:    viper.GetString("DB_PASS"),
		DBName:    viper.GetString("DB_NAME"),
		DBSSLMode: viper.GetString("DB_SSLMODE"),
	}
}