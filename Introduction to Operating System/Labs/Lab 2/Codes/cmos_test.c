#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"

int
main(int argc, char *argv[])
{
  uint start_ticks, end_ticks;
  struct rtcdate time1, time2;
  int i, j, loops = 1000000000;  // Increased loops to be much longer
  
  printf(1, "Testing time measurements...\n");
  printf(1, "Running a busy loop - this will take several seconds...\n");
  
  // Measure using uptime (ticks)
  start_ticks = uptime();
  
  // Get starting CMOS time
  if (getcmostime(&time1) < 0) {
    printf(2, "getcmostime failed\n");
    exit();
  }
  
  // Busy loop with nested loops to consume more CPU time
  for(i = 0; i < 50; i++) {
    for(j = 0; j < loops; j++) {
      // Empty nested loop to consume more CPU cycles
    }
    // Print a progress indicator every few iterations
    if(i % 10 == 0) {
      printf(1, ".");
    }
  }
  printf(1, "\n");
  
  // Get ending time
  end_ticks = uptime();
  
  if (getcmostime(&time2) < 0) {
    printf(2, "getcmostime failed\n");
    exit();
  }
  
  printf(1, "Uptime measurement:\n");
  printf(1, "  Start: %d ticks\n", start_ticks);
  printf(1, "  End:   %d ticks\n", end_ticks);
  printf(1, "  Diff:  %d ticks\n", end_ticks - start_ticks);
  
  printf(1, "\nCMOS time measurement:\n");
  printf(1, "  Start: %d:%d:%d\n", time1.hour, time1.minute, time1.second);
  printf(1, "  End:   %d:%d:%d\n", time2.hour, time2.minute, time2.second);
  
  // Calculate elapsed seconds
  int start_secs = time1.hour * 3600 + time1.minute * 60 + time1.second;
  int end_secs = time2.hour * 3600 + time2.minute * 60 + time2.second;
  int elapsed_secs = end_secs - start_secs;
  if (elapsed_secs < 0) {
    elapsed_secs += 24 * 3600; // Adjust for day wrap
  }
  
  printf(1, "  Diff:  %d seconds\n", elapsed_secs);
  
  if (elapsed_secs > 0) {
    printf(1, "\nEstimated ticks per second: %d\n", (end_ticks - start_ticks) / elapsed_secs);
  } else {
    printf(1, "\nWARNING: The test completed too quickly to measure with second-level granularity.\n");
    printf(1, "Try increasing the loop count for a more meaningful test.\n");
  }
  
  printf(1, "\nDifferences explained:\n");
  printf(1, "1. Ticks are based on timer interrupts (typically 100Hz)\n");
  printf(1, "2. CMOS time is based on the hardware real-time clock\n");
  printf(1, "3. CMOS time has lower precision (1 second) but keeps time across reboots\n");
  printf(1, "4. Uptime (ticks) is more precise for short intervals\n");
  
  exit();
} 