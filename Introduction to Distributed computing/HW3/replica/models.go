package main

import "time"

type Record struct {
	Key       string `json:"key"`
	Value     string `json:"value"`
	Version   int64  `json:"version"`
	UpdatedBy string `json:"updated_by"`
	Timestamp int64  `json:"timestamp"`
}

type PutRequest struct {
	Key   string `json:"key"`
	Value string `json:"value"`
}

type PutResponse struct {
	Success bool   `json:"success"`
	Error   string `json:"error,omitempty"`
}

type GetResponse struct {
	Key     string `json:"key"`
	Value   string `json:"value"`
	Version int64  `json:"version"`
	Error   string `json:"error,omitempty"`
}

func NewRecord(key, value, updatedBy string, version int64) Record {
	return Record{
		Key:       key,
		Value:     value,
		Version:   version,
		UpdatedBy: updatedBy,
		Timestamp: time.Now().UnixNano(),
	}
}
