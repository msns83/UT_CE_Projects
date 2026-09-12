package main

import (
	"encoding/json"
	"log"
	"net/http"
)

type MemoryEvent struct {
	EventType string `json:"event_type"`
	Service string `json:"service"`
	MemoryMB uint64 `json:"memory_mb"`
	Threshold uint64 `json:"threshold_mb"`
	Timestamp string `json:"timestamp"`
}

func eventHandler(w http.ResponseWriter, r *http.Request) {

	var event MemoryEvent

	err := json.NewDecoder(r.Body).Decode(&event)
	if err != nil {
		http.Error(w, "bad request", http.StatusBadRequest)
		return
	}

	if event.EventType != "HIGH_MEMORY_USAGE" {
		return
	}

	log.Println("===================================")
	log.Println("MEMORY ALERT RECEIVED")
	log.Printf("Service: %s", event.Service)
	log.Printf("Memory: %d MB", event.MemoryMB)
	log.Printf("Threshold: %d MB", event.Threshold)
	log.Printf("Time: %s", event.Timestamp)
	log.Println("===================================")

	w.WriteHeader(http.StatusOK)
}

func main() {

	http.HandleFunc("/event", eventHandler)

	log.Println("Subscriber listening on :9000")

	http.ListenAndServe(":9000", nil)
}