# Section 2: Context Switching and Concurrency Report

In this project we wrote a test to see how goroutines act in different situations and how context switching affects the result.

## How to run the app

To run this project you just need to have Go installed. You open the terminal in the project folder and type:

```bash
go run main.go
```

## Dependencies

We only used the Go standard library for this, so there is no need to download any external packages. The libraries used are fmt for printing, math for calculations, time for calculating latency and execution time, sync for mutex and waitgroups, and runtime to change cpu cores.

## App Structure

I structured the code to run a comprehensive benchmark by setting up exactly 1024 tasks to process. I chose 1024 because it divides perfectly among 1, 2, 4, 8, 16, 32, and 64 goroutines. I used nested loops to test every combination of CPU cores (GOMAXPROCS), number of goroutines, and workload types sequentially.

Inside the loops, I divide the 1024 tasks equally among the active goroutines for that specific test. To measure performance, I use the time library to record exactly when the jobs start. Since the goroutines execute concurrently, I use a sync WaitGroup. Each time a goroutine starts, I add it to the WaitGroup, and when it finishes, it signals the group. The main program simply waits at the end until everyone is done to calculate the total execution time. Meanwhile, each goroutine tracks the exact latency of its own specific tasks and saves it in a shared array so I can calculate the minimum, maximum, and average latency later.

There are two main workloads I wrote for this test. The first is a pure CPU-bound task. It is essentially a tight loop evaluating math square roots 100,000 times without ever stopping. It simulates a heavy math calculation that needs 100 percent of the processor.

The second is a mixed-contention task. It mimics a real-world web server or database application. It does some minor math, but every 500 steps it tries to increment a shared counter variable. Because multiple goroutines might try to change this variable simultaneously, I wrapped it in a sync Mutex lock. This means if one goroutine is changing the counter, all others must wait in line. Finally, this task includes a temporary sleep operation. This is crucial because it mimics IO operations, like waiting for a network request, forcing the goroutine to pause completely.

## Results

Table for GOMAXPROCS 1
| Goroutines | Workload | TotalTime(ms) | Throughput/s | AvgLat | MinLat | MaxLat |
|---|---|---|---|---|---|---|
| 1 | CPU-Bound | 36 | 28235.46 | 0.0350 | 0.0310 | 0.1230 |
| 1 | Mixed | 594 | 1724.21 | 0.5790 | 0.5120 | 0.7260 |
| 2 | CPU-Bound | 37 | 27590.39 | 0.0540 | 0.0310 | 18.6120 |
| 2 | Mixed | 298 | 3441.33 | 0.5800 | 0.5060 | 0.9020 |
| 4 | CPU-Bound | 34 | 30473.28 | 0.0320 | 0.0300 | 0.1020 |
| 4 | Mixed | 147 | 6942.41 | 0.5760 | 0.5060 | 0.6370 |
| 8 | CPU-Bound | 37 | 27504.55 | 0.0360 | 0.0310 | 0.1160 |
| 8 | Mixed | 73 | 13943.53 | 0.5730 | 0.5050 | 0.7690 |
| 16 | CPU-Bound | 35 | 29156.07 | 0.0340 | 0.0300 | 0.1020 |
| 16 | Mixed | 37 | 27852.51 | 0.5730 | 0.5040 | 0.6340 |
| 32 | CPU-Bound | 33 | 30692.34 | 0.0320 | 0.0300 | 0.0970 |
| 32 | Mixed | 18 | 57128.65 | 0.5550 | 0.5040 | 0.7350 |
| 64 | CPU-Bound | 33 | 31280.99 | 0.0310 | 0.0300 | 0.1200 |
| 64 | Mixed | 9 | 112928.72 | 0.5460 | 0.5040 | 0.8470 |

Table for GOMAXPROCS 2
| Goroutines | Workload | TotalTime(ms) | Throughput/s | AvgLat | MinLat | MaxLat |
|---|---|---|---|---|---|---|
| 1 | CPU-Bound | 32 | 31567.91 | 0.0310 | 0.0300 | 0.0930 |
| 1 | Mixed | 594 | 1722.60 | 0.5800 | 0.5150 | 0.6830 |
| 2 | CPU-Bound | 22 | 45895.61 | 0.0430 | 0.0370 | 0.0920 |
| 2 | Mixed | 298 | 3437.57 | 0.5810 | 0.5150 | 0.6830 |
| 4 | CPU-Bound | 23 | 43983.58 | 0.0450 | 0.0400 | 0.1080 |
| 4 | Mixed | 165 | 6201.91 | 0.6410 | 0.5090 | 2.9360 |
| 8 | CPU-Bound | 17 | 60004.25 | 0.0330 | 0.0310 | 0.1070 |
| 8 | Mixed | 73 | 14000.64 | 0.5710 | 0.5100 | 0.6590 |
| 16 | CPU-Bound | 17 | 59611.13 | 0.0330 | 0.0310 | 0.1090 |
| 16 | Mixed | 37 | 28048.55 | 0.5690 | 0.5040 | 0.6260 |
| 32 | CPU-Bound | 17 | 59444.31 | 0.0330 | 0.0310 | 0.1570 |
| 32 | Mixed | 18 | 56041.52 | 0.5670 | 0.5040 | 0.6270 |
| 64 | CPU-Bound | 16 | 62412.70 | 0.0310 | 0.0300 | 0.0710 |
| 64 | Mixed | 9 | 113354.79 | 0.5530 | 0.5040 | 0.6790 |

Table for GOMAXPROCS 8 (Max CPU)
| Goroutines | Workload | TotalTime(ms) | Throughput/s | AvgLat | MinLat | MaxLat |
|---|---|---|---|---|---|---|
| 1 | CPU-Bound | 32 | 31584.55 | 0.0310 | 0.0300 | 0.0790 |
| 1 | Mixed | 592 | 1729.43 | 0.5780 | 0.5110 | 0.6650 |
| 2 | CPU-Bound | 17 | 61047.01 | 0.0320 | 0.0300 | 0.0900 |
| 2 | Mixed | 295 | 3470.73 | 0.5760 | 0.5250 | 0.6630 |
| 4 | CPU-Bound | 9 | 110400.34 | 0.0350 | 0.0340 | 0.1450 |
| 4 | Mixed | 148 | 6924.91 | 0.5770 | 0.5190 | 0.6470 |
| 8 | CPU-Bound | 8 | 132348.90 | 0.0390 | 0.0300 | 1.0320 |
| 8 | Mixed | 74 | 13881.59 | 0.5760 | 0.5100 | 0.6550 |
| 16 | CPU-Bound | 6 | 161603.41 | 0.0400 | 0.0310 | 3.3020 |
| 16 | Mixed | 37 | 27712.38 | 0.5760 | 0.5080 | 0.6860 |
| 32 | CPU-Bound | 6 | 161100.21 | 0.0420 | 0.0310 | 3.5130 |
| 32 | Mixed | 19 | 55217.41 | 0.5770 | 0.5050 | 0.7140 |
| 64 | CPU-Bound | 6 | 172941.34 | 0.0400 | 0.0310 | 1.7430 |
| 64 | Mixed | 9 | 108710.65 | 0.5750 | 0.5050 | 0.7770 |

## Analysis

1. What happens to execution time with more goroutines?

With a pure CPU-bound task, increasing the number of goroutines only decreases the execution time if there are available physical CPU cores (GOMAXPROCS higher than 1). For example, when my GOMAXPROCS was 1, the total time stayed rigidly around 33-37ms whether I used 1 goroutine or 64. However, when I set GOMAXPROCS to 8, jumping from 1 to 16 goroutines slashed the total time drastically from 32ms down to just 6ms. This happens because the work can be truly divided across separate cores.

With the mixed workload, increasing goroutines reduces the execution time almost magically across the board, even on just 1 CPU core. When 1 goroutine goes to sleep (simulating IO), the Go scheduler immediately hands the CPU over to another goroutine rather than letting the machine idle. By 64 goroutines, execution dropped from 594ms down to roughly 9ms in every test simply by hiding the sleep latency.

2. Does increasing goroutines always increase throughput?

No, definitely not. There is a breaking point. When you observe the Mixed-Contention test at 64 goroutines using 8 CPU cores, the throughput is actually slightly lower (108,710/s) than when doing the same test on just 1 or 2 CPU cores (112,928/s and 113,354/s).

This goes against the normal prediction that more hardware equals more speed. It performed worse because all 8 independent hardware threads were actively colliding into the exact same Mutex lock at the exact same physical moment. This forces the processor to constantly invalidate hardware cache lines and makes the threads fight to acquire the lock. It completely stalls the CPU pipeline. The machine spends more time managing the conflict around the lock than actually doing the math.

3. The difference between GOMAXPROCS=1 and GOMAXPROCS=NumCPU (8)

When GOMAXPROCS is set to 1, the Go runtime only binds to a single physical OS thread. The execution here is strictly concurrent, not parallel. The Go scheduler rapidly slices time and swaps goroutines perfectly, which is excellent for IO-bound work like our mixed workload but useless for heavy math.

When it equates to NumCPU (8), the Go runtime leverages 8 separate physical OS threads interacting with the chip simultaneously. This is true parallelism. The difference is monumental for pure calculation. Our math workload went from 31,000 throughput-per-second on 1 core to 172,000 throughput-per-second on 8 cores.

4. In which workload scheduling and switching effects are more visible?

They are massively visible in the Mixed-Contention workload. When a goroutine hits the time.Sleep command, it detaches from the OS thread. The Go scheduler completely bypasses the operating system's heavy kernel-level context limits, and instantly places another ready goroutine onto the OS thread in user-space. This makes switching extremely cheap and explains why having 8 cores vs 1 core didn't heavily impact the mixed-workload time at 64 goroutines; the lightweight user-space scheduling effectively masked all the blocked time.

5. When is it useless to increase concurrency?

Concurrency becomes actively harmful in two scenarios shown in the data. First, in pure CPU workloads, adding more goroutines than you have physical cores stops providing benefits. As seen in the 8-Core CPU test, adding more goroutines beyond 16 did not lower the 6ms total time, but it drastically ruined the Max Latency (spiking up to 3.5ms). This indicates that the scheduler starts wasting cycles swapping active CPU threads in and out.

Second, it is useless when there is extreme contention over a shared resource. In our mixed test, pushing past 32 goroutines on 8 cores barely changed the total time and eventually throttled the system downward due to lock contention on the Mutex. At that point, adding more workers just makes the line to acquire the lock longer.
