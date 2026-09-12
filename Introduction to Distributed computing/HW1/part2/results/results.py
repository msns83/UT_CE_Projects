import matplotlib.pyplot as plt
import pandas as pd

data = [
    # GOMAXPROCS 1
    (1, 1, 'CPU-Bound', 36, 28235.46),
    (1, 1, 'Mixed-Contention', 594, 1724.21),
    (1, 2, 'CPU-Bound', 37, 27590.39),
    (1, 2, 'Mixed-Contention', 298, 3441.33),
    (1, 4, 'CPU-Bound', 34, 30473.28),
    (1, 4, 'Mixed-Contention', 147, 6942.41),
    (1, 8, 'CPU-Bound', 37, 27504.55),
    (1, 8, 'Mixed-Contention', 73, 13943.53),
    (1, 16, 'CPU-Bound', 35, 29156.07),
    (1, 16, 'Mixed-Contention', 37, 27852.51),
    (1, 32, 'CPU-Bound', 33, 30692.34),
    (1, 32, 'Mixed-Contention', 18, 57128.65),
    (1, 64, 'CPU-Bound', 33, 31280.99),
    (1, 64, 'Mixed-Contention', 9, 112928.72),
    # GOMAXPROCS 2
    (2, 1, 'CPU-Bound', 32, 31567.91),
    (2, 1, 'Mixed-Contention', 594, 1722.60),
    (2, 2, 'CPU-Bound', 22, 45895.61),
    (2, 2, 'Mixed-Contention', 298, 3437.57),
    (2, 4, 'CPU-Bound', 23, 43983.58),
    (2, 4, 'Mixed-Contention', 165, 6201.91),
    (2, 8, 'CPU-Bound', 17, 60004.25),
    (2, 8, 'Mixed-Contention', 73, 14000.64),
    (2, 16, 'CPU-Bound', 17, 59611.13),
    (2, 16, 'Mixed-Contention', 37, 28048.55),
    (2, 32, 'CPU-Bound', 17, 59444.31),
    (2, 32, 'Mixed-Contention', 18, 56041.52),
    (2, 64, 'CPU-Bound', 16, 62412.70),
    (2, 64, 'Mixed-Contention', 9, 113354.79),
    # GOMAXPROCS 8
    (8, 1, 'CPU-Bound', 32, 31584.55),
    (8, 1, 'Mixed-Contention', 592, 1729.43),
    (8, 2, 'CPU-Bound', 17, 61047.01),
    (8, 2, 'Mixed-Contention', 295, 3470.73),
    (8, 4, 'CPU-Bound', 9, 110400.34),
    (8, 4, 'Mixed-Contention', 148, 6924.91),
    (8, 8, 'CPU-Bound', 8, 132348.90),
    (8, 8, 'Mixed-Contention', 74, 13881.59),
    (8, 16, 'CPU-Bound', 6, 161603.41),
    (8, 16, 'Mixed-Contention', 37, 27712.38),
    (8, 32, 'CPU-Bound', 6, 161100.21),
    (8, 32, 'Mixed-Contention', 19, 55217.41),
    (8, 64, 'CPU-Bound', 6, 172941.34),
    (8, 64, 'Mixed-Contention', 9, 108710.65)
]

df = pd.DataFrame(data, columns=['GOMAXPROCS', 'Goroutines', 'Workload', 'TotalTime', 'Throughput'])

df_cpu = df[df['Workload'] == 'CPU-Bound']
df_mixed = df[df['Workload'] == 'Mixed-Contention']

plt.figure(figsize=(10, 6))
for procs in [1, 2, 8]:
    subset = df_cpu[df_cpu['GOMAXPROCS'] == procs]
    plt.plot(subset['Goroutines'], subset['TotalTime'], marker='o', label=f'GOMAXPROCS={procs}')

plt.title('Total Execution Time vs Goroutines (CPU-Bound Workload)')
plt.xlabel('Number of Goroutines')
plt.ylabel('Total Time (ms)')
plt.xscale('log', base=2)
plt.xticks([1, 2, 4, 8, 16, 32, 64], ['1', '2', '4', '8', '16', '32', '64'])
plt.legend()
plt.grid(True)
plt.savefig('total_time_cpu.png')
plt.close()

plt.figure(figsize=(10, 6))
for procs in [1, 2, 8]:
    subset = df_mixed[df_mixed['GOMAXPROCS'] == procs]
    plt.plot(subset['Goroutines'], subset['TotalTime'], marker='s', linestyle='--', label=f'GOMAXPROCS={procs}')

plt.title('Total Execution Time vs Goroutines (Mixed-Contention Workload)')
plt.xlabel('Number of Goroutines')
plt.ylabel('Total Time (ms)')
plt.xscale('log', base=2)
plt.xticks([1, 2, 4, 8, 16, 32, 64], ['1', '2', '4', '8', '16', '32', '64'])
plt.legend()
plt.grid(True)
plt.savefig('total_time_mixed.png')
plt.close()

plt.figure(figsize=(10, 6))
for procs in [1, 2, 8]:
    subset = df_cpu[df_cpu['GOMAXPROCS'] == procs]
    plt.plot(subset['Goroutines'], subset['Throughput'], marker='^', label=f'GOMAXPROCS={procs}')

plt.title('Throughput vs Goroutines (CPU-Bound Workload)')
plt.xlabel('Number of Goroutines')
plt.ylabel('Throughput (tasks/sec)')
plt.xscale('log', base=2)
plt.xticks([1, 2, 4, 8, 16, 32, 64], ['1', '2', '4', '8', '16', '32', '64'])
plt.legend()
plt.grid(True)
plt.savefig('throughput_cpu.png')
plt.close()

plt.figure(figsize=(10, 6))
for procs in [1, 2, 8]:
    subset = df_mixed[df_mixed['GOMAXPROCS'] == procs]
    plt.plot(subset['Goroutines'], subset['Throughput'], marker='x', linestyle='-.', label=f'GOMAXPROCS={procs}')

plt.title('Throughput vs Goroutines (Mixed-Contention Workload)')
plt.xlabel('Number of Goroutines')
plt.ylabel('Throughput (tasks/sec)')
plt.xscale('log', base=2)
plt.xticks([1, 2, 4, 8, 16, 32, 64], ['1', '2', '4', '8', '16', '32', '64'])
plt.legend()
plt.grid(True)
plt.savefig('throughput_mixed.png')
plt.close()

print("Graphs generated successfully as PNG files.")
