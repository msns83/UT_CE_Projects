package main

import (
	"encoding/json"
	"os"
)

type ReplicaConfig struct {
	ID    string   `json:"id"`
	Port  int      `json:"port"`
	Peers []string `json:"peers"`
}

func LoadConfig(path string) (*ReplicaConfig, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var cfg ReplicaConfig
	if err := json.Unmarshal(data, &cfg); err != nil {
		return nil, err
	}
	return &cfg, nil
}
