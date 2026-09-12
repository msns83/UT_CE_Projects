package main

import (
	"log"
	"sync"
	"time"
)

type Metrics struct {
	mu sync.Mutex

	PUTLatencies    []time.Duration
	GETLatencies    []time.Duration
	ConvergenceTime time.Duration
	UpdatedReplicas int
	StaleReads      int
}

func NewMetrics() *Metrics {
	return &Metrics{
		PUTLatencies: make([]time.Duration, 0),
		GETLatencies: make([]time.Duration, 0),
	}
}

func (m *Metrics) RecordPUT(latency time.Duration, acks int) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.PUTLatencies = append(m.PUTLatencies, latency)
	m.UpdatedReplicas = acks
}

func (m *Metrics) RecordGET(latency time.Duration) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.GETLatencies = append(m.GETLatencies, latency)
}

func (m *Metrics) RecordConvergence(duration time.Duration) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.ConvergenceTime = duration
}

func (m *Metrics) RecordStaleRead() {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.StaleReads++
}

func (m *Metrics) AveragePUTLatency() time.Duration {
	m.mu.Lock()
	defer m.mu.Unlock()
	if len(m.PUTLatencies) == 0 {
		return 0
	}
	var total time.Duration
	for _, l := range m.PUTLatencies {
		total += l
	}
	return total / time.Duration(len(m.PUTLatencies))
}

func (m *Metrics) AverageGETLatency() time.Duration {
	m.mu.Lock()
	defer m.mu.Unlock()
	if len(m.GETLatencies) == 0 {
		return 0
	}
	var total time.Duration
	for _, l := range m.GETLatencies {
		total += l
	}
	return total / time.Duration(len(m.GETLatencies))
}

func (m *Metrics) LogMetrics(replicaID string) {
	log.Printf("[%s] Metrics - Avg PUT: %v, Avg GET: %v, Convergence: %v, Stale Reads: %d",
		replicaID, m.AveragePUTLatency(), m.AverageGETLatency(), m.ConvergenceTime, m.StaleReads)
}
