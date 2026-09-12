package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

func main() {
	configPath := flag.String("config", "", "Path to replica configuration file")
	mode := flag.String("mode", "eventual", "Consistency mode: eventual or strong")
	delayMs := flag.Int("delay", 0, "Artificial replication delay in milliseconds")
	flag.Parse()

	if *configPath == "" {
		fmt.Fprintln(os.Stderr, "Usage: go run main.go -config <path> -mode <eventual|strong> [-delay <ms>]")
		os.Exit(1)
	}

	config, err := LoadConfig(*configPath)
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	delay := time.Duration(*delayMs) * time.Millisecond
	store := NewStore()
	metrics := NewMetrics()
	repl := NewReplicator(config, store, delay, *mode, metrics)
	cm := NewConsistencyManager(config, store, repl, *mode, metrics)

	http.HandleFunc("/put", cm.HandlePut)
	http.HandleFunc("/get", cm.HandleGet)
	http.HandleFunc("/replicate", repl.HandleReplicate)
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, `{"status":"ok","id":"%s","mode":"%s"}`, config.ID, *mode)
	})

	addr := fmt.Sprintf(":%d", config.Port)
	log.Printf("[%s] Starting replica on %s (mode=%s, delay=%v, peers=%v)",
		config.ID, addr, *mode, delay, config.Peers)

	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatalf("[%s] Server failed: %v", config.ID, err)
	}
}
