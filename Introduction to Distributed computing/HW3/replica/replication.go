package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"time"
)

type Replicator struct {
	config  *ReplicaConfig
	store   *Store
	peers   []string
	delay   time.Duration
	mode    string
	client  *http.Client
	metrics *Metrics
}

func NewReplicator(config *ReplicaConfig, store *Store, delay time.Duration, mode string, metrics *Metrics) *Replicator {
	return &Replicator{
		config:  config,
		store:   store,
		peers:   config.Peers,
		delay:   delay,
		mode:    mode,
		client:  &http.Client{Timeout: 5 * time.Second},
		metrics: metrics,
	}
}

func (r *Replicator) ReplicateAsync(record Record) {
	go func() {
		time.Sleep(r.delay)
		for _, peer := range r.peers {
			go r.sendReplication(peer, record)
		}
	}()
}

func (r *Replicator) ReplicateSync(record Record) (int, error) {
	ackCount := 1
	ackChan := make(chan bool, len(r.peers))

	for _, peer := range r.peers {
		go func(p string) {
			success := r.sendReplication(p, record)
			ackChan <- success
		}(peer)
	}

	for i := 0; i < len(r.peers); i++ {
		if <-ackChan {
			ackCount++
		}
	}

	majority := (len(r.peers)+1)/2 + 1
	if ackCount >= majority {
		return ackCount, nil
	}
	return ackCount, fmt.Errorf("failed to achieve majority: got %d/%d acks", ackCount, len(r.peers))
}

func (r *Replicator) sendReplication(peer string, record Record) bool {
	data, err := json.Marshal(record)
	if err != nil {
		log.Printf("[%s] Failed to marshal replication data: %v", r.config.ID, err)
		return false
	}

	resp, err := r.client.Post(peer+"/replicate", "application/json", bytes.NewReader(data))
	if err != nil {
		log.Printf("[%s] Failed to replicate to %s: %v", r.config.ID, peer, err)
		return false
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	var result map[string]bool
	if err := json.Unmarshal(body, &result); err != nil {
		log.Printf("[%s] Invalid response from %s: %v", r.config.ID, peer, err)
		return false
	}

	return result["success"]
}

func (r *Replicator) HandleReplicate(w http.ResponseWriter, req *http.Request) {
	if req.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var record Record
	if err := json.NewDecoder(req.Body).Decode(&record); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	current, exists := r.store.Get(record.Key)

	accept := false
	if !exists {
		accept = true
	} else if record.Version > current.Version {
		accept = true
	} else if record.Version == current.Version && record.Timestamp > current.Timestamp {
		accept = true
	}

	if accept {
		r.store.Put(record)
		log.Printf("[%s] Replicated key=%s value=%s version=%d from %s",
			r.config.ID, record.Key, record.Value, record.Version, record.UpdatedBy)
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]bool{"success": true})
	} else {
		log.Printf("[%s] Ignored stale replication for key=%s (received version=%d ts=%d, current version=%d ts=%d)",
			r.config.ID, record.Key, record.Version, record.Timestamp, current.Version, current.Timestamp)
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]bool{"success": false})
	}
}
