#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(make_user)
SYSCALL(login)
SYSCALL(logout)
SYSCALL(get_log)
SYSCALL(diff)
SYSCALL(set_sleep)
SYSCALL(getcmostime)
SYSCALL(next_palindrome)
SYSCALL(rt_fork)
SYSCALL(set_class)
SYSCALL(ps)
SYSCALL(barber_sleep)
SYSCALL(customer_arrive)
SYSCALL(cut_hair)
SYSCALL(customer_wait_haircut)
SYSCALL(init_rw_lock)
SYSCALL(get_rw_pattern)