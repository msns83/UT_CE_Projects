#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"

int
main(void)
{
  uint start_ticks, end_ticks;
  struct rtcdate start_time, end_time;
  int sleep_ticks = 500; // Sleep for 5 seconds (assuming 100 ticks per second)
  
  printf(1, "Testing set_sleep with a long duration...\n");
  
  // Get starting time using uptime syscall
  start_ticks = uptime();
  
  // Get starting time using cmostime
  if (getcmostime(&start_time) < 0) {
    printf(2, "getcmostime failed\n");
    exit();
  }
  
  printf(1, "Starting sleep at tick: %d, time: %d:%d:%d\n", 
         start_ticks, start_time.hour, start_time.minute, start_time.second);
  
  // Call our custom sleep function
  printf(1, "Sleeping for %d ticks (about 5 seconds)...\n", sleep_ticks);
  set_sleep(sleep_ticks);
  
  // Get ending time
  end_ticks = uptime();
  
  // Get ending time using cmostime
  if (getcmostime(&end_time) < 0) {
    printf(2, "getcmostime failed\n");
    exit();
  }
  
  printf(1, "Woke up at tick: %d, time: %d:%d:%d\n", 
         end_ticks, end_time.hour, end_time.minute, end_time.second);
  
  printf(1, "\n--- Results ---\n");
  printf(1, "Requested sleep duration: %d ticks\n", sleep_ticks);
  printf(1, "Actual sleep duration: %d ticks\n", end_ticks - start_ticks);
  
  // Calculate elapsed seconds
  int start_secs = start_time.hour * 3600 + start_time.minute * 60 + start_time.second;
  int end_secs = end_time.hour * 3600 + end_time.minute * 60 + end_time.second;
  int elapsed_secs = end_secs - start_secs;
  if (elapsed_secs < 0) {
    elapsed_secs += 24 * 3600; // Adjust for day wrap
  }
  
  printf(1, "Elapsed real time: %d seconds\n", elapsed_secs);
  
  // Estimate ticks per second
  if (elapsed_secs > 0) {
    printf(1, "Estimated ticks per second: %d\n", (end_ticks - start_ticks) / elapsed_secs);
  }
  
  printf(1, "\nIf you see a non-zero seconds difference, the system is working correctly.\n");
  printf(1, "CMOS time measures in whole seconds, while ticks provide finer granularity.\n");
  
  exit();
} 