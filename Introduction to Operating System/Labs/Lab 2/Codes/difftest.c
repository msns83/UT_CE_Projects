#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
  int status;

  if(argc != 3){
    printf(2, "Usage: diff file1 file2\n");
    exit();
  }

  status = diff(argv[1], argv[2]);
  if(status == 0)
    printf(1, "Files are identical\n");
  
  exit();
} 