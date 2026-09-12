package main

import (
	"fmt"
	"math"
	"runtime"
	"strings"
	"sync"
	"time"
)

const totalTasks = 1024

var (
	mu sync.Mutex
	sharedCounter int
)

func cpuBoundTask() {
	sum := 0.0
	
	for i := 0; i < 100000; i++ {
		sum += math.Sqrt(float64(i))
	}
	_ = sum
}

func mixedTask() {
	sum := 0.0
	for i := 0; i < 5000; i++ {
		sum += math.Sqrt(float64(i))

		if i%500 == 0 {
			mu.Lock()
			sharedCounter++
			mu.Unlock()
		}
	}

	time.Sleep(500 * time.Microsecond)
	_ = sum
}

func main() {
	numCPU := runtime.NumCPU()

	procsConfig := []int{1, 2, numCPU}
	goroutinesConfig := []int{1, 2, 4, 8, 16, 32, 64}
	workloads := []string{"CPU-Bound", "Mixed-Contention"}

	fmt.Println("Starting Concurrency & Context-Switching Benchmark")
	fmt.Printf("System CPUs detected: %d\n", numCPU)

	fmt.Println(strings.Repeat("-", 115))
	fmt.Printf("%-10s | %-10s | %-18s | %-12s | %-12s | %-12s | %-12s | %-12s\n",
		"GOMAXPROCS", "Goroutines", "Workload", "TotalTime", "Throughput/s", "AvgLat(ms)", "MinLat(ms)", "MaxLat(ms)")
	fmt.Println(strings.Repeat("-", 115))

	for _, procs := range procsConfig {
		for _, grts := range goroutinesConfig {
			for _, wType := range workloads {
				
				runtime.GOMAXPROCS(procs)
				tasksPerGrt := totalTasks / grts
				
				latencies := make([]time.Duration, totalTasks)
				
				var wg sync.WaitGroup
				sharedCounter = 0

				startTotal := time.Now()
				for i := 0; i < grts; i++ {
					wg.Add(1)
					
					go func(gIndex int) {
						defer wg.Done()
						for j := 0; j < tasksPerGrt; j++ {
							taskIdx := gIndex*tasksPerGrt + j
							
							startTask := time.Now()
							if wType == "CPU-Bound" {
								cpuBoundTask()
							} else {
								mixedTask()
							}
							latencies[taskIdx] = time.Since(startTask)
						}
					}(i)
				}

				
				wg.Wait()
				
				totalExeTime := time.Since(startTotal)

				var sumLat time.Duration
				minLat := latencies[0]
				maxLat := latencies[0]

				for _, lat := range latencies {
					sumLat += lat
					if lat < minLat {
						minLat = lat
					}
					if lat > maxLat {
						maxLat = lat
					}
				}

				avgLat := sumLat / time.Duration(totalTasks)
				throughput := float64(totalTasks) / totalExeTime.Seconds()

				fmt.Printf("%-10d | %-10d | %-18s | %-12s | %-12.2f | %-12.4f | %-12.4f | %-12.4f\n",
					procs, grts, wType,
					totalExeTime.Round(time.Millisecond),
					throughput,
					float64(avgLat.Microseconds())/1000.0,
					float64(minLat.Microseconds())/1000.0,
					float64(maxLat.Microseconds())/1000.0)
			}
		}
		
		fmt.Println(strings.Repeat("-", 115))
	}
}
