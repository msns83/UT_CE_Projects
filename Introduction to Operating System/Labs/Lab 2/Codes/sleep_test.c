#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"

int
main(int argc, char *argv[])
{
  int time_ticks;
  uint start_ticks, end_ticks;
  struct rtcdate start_time, end_time;
  
  if(argc != 2){
    printf(2, "Usage: sleep_test <time_in_ticks>\n");
    exit();
  }
  
  time_ticks = atoi(argv[1]);
  printf(1, "Putting process to sleep for %d ticks...\n", time_ticks);
  
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
  set_sleep(time_ticks);
  
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
  printf(1, "Requested sleep duration: %d ticks\n", time_ticks);
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
  
  printf(1, "\nNote: Any difference between requested and actual sleep time\n");
  printf(1, "may be due to scheduler latency and timer resolution.\n");
  
  exit();
} 