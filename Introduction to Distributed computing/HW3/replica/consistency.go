package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

type ConsistencyManager struct {
	config    *ReplicaConfig
	store     *Store
	repl      *Replicator
	mode      string
	metrics   *Metrics
}

func NewConsistencyManager(config *ReplicaConfig, store *Store, repl *Replicator, mode string, metrics *Metrics) *ConsistencyManager {
	return &ConsistencyManager{
		config:  config,
		store:   store,
		repl:    repl,
		mode:    mode,
		metrics: metrics,
	}
}

func (cm *ConsistencyManager) HandlePut(w http.ResponseWriter, req *http.Request) {
	if req.Method != http.MethodPut {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var putReq PutRequest
	if err := json.NewDecoder(req.Body).Decode(&putReq); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	start := time.Now()

	currentVersion := cm.store.GetVersion(putReq.Key)
	newVersion := currentVersion + 1
	record := NewRecord(putReq.Key, putReq.Value, cm.config.ID, newVersion)

	if cm.mode == "strong" {
		ackCount, err := cm.repl.ReplicateSync(record)
		if err != nil {
			log.Printf("[%s] Strong consistency PUT failed: %v", cm.config.ID, err)
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusServiceUnavailable)
			json.NewEncoder(w).Encode(PutResponse{
				Success: false,
				Error:   fmt.Sprintf("Failed to achieve majority: %s", err.Error()),
			})
			return
		}
		cm.store.Put(record)
		elapsed := time.Since(start)
		cm.metrics.RecordPUT(elapsed, ackCount)

		log.Printf("[%s] PUT key=%s value=%s version=%d (majority=%d) took %v",
			cm.config.ID, putReq.Key, putReq.Value, newVersion, ackCount, elapsed)

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(PutResponse{Success: true})
	} else {
		cm.store.Put(record)
		cm.repl.ReplicateAsync(record)
		elapsed := time.Since(start)
		cm.metrics.RecordPUT(elapsed, 1)

		log.Printf("[%s] PUT key=%s value=%s version=%d took %v",
			cm.config.ID, putReq.Key, putReq.Value, newVersion, elapsed)

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(PutResponse{Success: true})
	}
}

func (cm *ConsistencyManager) HandleGet(w http.ResponseWriter, req *http.Request) {
	if req.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	key := req.URL.Query().Get("key")
	if key == "" {
		http.Error(w, "Missing key parameter", http.StatusBadRequest)
		return
	}

	start := time.Now()

	record, ok := cm.store.Get(key)
	elapsed := time.Since(start)
	cm.metrics.RecordGET(elapsed)

	if !ok {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(GetResponse{
			Error: fmt.Sprintf("Key '%s' not found", key),
		})
		return
	}

	log.Printf("[%s] GET key=%s value=%s version=%d took %v",
		cm.config.ID, key, record.Value, record.Version, elapsed)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(GetResponse{
		Key:     record.Key,
		Value:   record.Value,
		Version: record.Version,
	})
}
