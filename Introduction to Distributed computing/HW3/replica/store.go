package main

import "sync"

type Store struct {
	mu      sync.RWMutex
	data    map[string]Record
	version map[string]int64
}

func NewStore() *Store {
	return &Store{
		data:    make(map[string]Record),
		version: make(map[string]int64),
	}
}

func (s *Store) Put(record Record) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.data[record.Key] = record
	s.version[record.Key] = record.Version
}

func (s *Store) Get(key string) (Record, bool) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	record, ok := s.data[key]
	return record, ok
}

func (s *Store) GetVersion(key string) int64 {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.version[key]
}

func (s *Store) IsNewer(key string, version int64) bool {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return version > s.version[key]
}
