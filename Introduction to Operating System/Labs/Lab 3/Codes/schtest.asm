
_schtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    int x = 2;
    for(volatile int i = 0 ; i < LBUSYLOOP; i++)
        x = (x*x)-(x*2) * 33 ;
}

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 38             	sub    $0x38,%esp
    int pid_count = getpid() + 1 ;
  14:	e8 0a 05 00 00       	call   523 <getpid>
    int rel_deadlines[N_EDF] = {100, 3, 20};

    printf(1,"User changed schedule class\n");
  19:	83 ec 08             	sub    $0x8,%esp
    int rel_deadlines[N_EDF] = {100, 3, 20};
  1c:	c7 45 dc 64 00 00 00 	movl   $0x64,-0x24(%ebp)
    printf(1,"User changed schedule class\n");
  23:	68 48 09 00 00       	push   $0x948
    int pid_count = getpid() + 1 ;
  28:	89 c7                	mov    %eax,%edi
  2a:	8d 58 01             	lea    0x1(%eax),%ebx
    printf(1,"User changed schedule class\n");
  2d:	6a 01                	push   $0x1
  2f:	83 c7 04             	add    $0x4,%edi
    int rel_deadlines[N_EDF] = {100, 3, 20};
  32:	c7 45 e0 03 00 00 00 	movl   $0x3,-0x20(%ebp)
  39:	c7 45 e4 14 00 00 00 	movl   $0x14,-0x1c(%ebp)
    printf(1,"User changed schedule class\n");
  40:	e8 fb 05 00 00       	call   640 <printf>
    set_class(getpid(),1); 
  45:	e8 d9 04 00 00       	call   523 <getpid>
  4a:	5a                   	pop    %edx
  4b:	59                   	pop    %ecx
  4c:	6a 01                	push   $0x1
  4e:	50                   	push   %eax
  4f:	e8 37 05 00 00       	call   58b <set_class>
    printf(1,"Main process -> real-time, deadline: 1, pid: %d \n", getpid());
  54:	e8 ca 04 00 00       	call   523 <getpid>
  59:	83 c4 0c             	add    $0xc,%esp
  5c:	50                   	push   %eax
  5d:	68 d4 09 00 00       	push   $0x9d4
  62:	6a 01                	push   $0x1
  64:	e8 d7 05 00 00       	call   640 <printf>

    for(int i = 0; i < N_RR; i++){
  69:	83 c4 10             	add    $0x10,%esp
        printf(1,"New Noraml process (going to be Critical) -> pid: %d\n", pid_count++);
  6c:	83 ec 04             	sub    $0x4,%esp
  6f:	89 d8                	mov    %ebx,%eax
  71:	83 c3 01             	add    $0x1,%ebx
  74:	50                   	push   %eax
  75:	68 08 0a 00 00       	push   $0xa08
  7a:	6a 01                	push   $0x1
  7c:	e8 bf 05 00 00       	call   640 <printf>
        int pid = fork();
  81:	e8 15 04 00 00       	call   49b <fork>
        if(pid < 0){
  86:	83 c4 10             	add    $0x10,%esp
        int pid = fork();
  89:	89 c6                	mov    %eax,%esi
        if(pid < 0){
  8b:	85 c0                	test   %eax,%eax
  8d:	0f 88 a2 01 00 00    	js     235 <main+0x235>
            printf(1,"classtest: fork failed\n");
            exit();
        }
        if(pid == 0){
  93:	0f 84 c4 00 00 00    	je     15d <main+0x15d>
    for(int i = 0; i < N_RR; i++){
  99:	39 fb                	cmp    %edi,%ebx
  9b:	75 cf                	jne    6c <main+0x6c>
  9d:	8d 7d dc             	lea    -0x24(%ebp),%edi
            exit();
        }
    }

    for(int i = 0; i < N_EDF; i++) {
        printf(1,"New real-time process -> pid: %d, deadline: %d\n", pid_count++, rel_deadlines[i]);
  a0:	8b 07                	mov    (%edi),%eax
  a2:	89 de                	mov    %ebx,%esi
  a4:	83 c3 01             	add    $0x1,%ebx
  a7:	50                   	push   %eax
  a8:	56                   	push   %esi
  a9:	68 40 0a 00 00       	push   $0xa40
  ae:	6a 01                	push   $0x1
  b0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  b3:	e8 88 05 00 00       	call   640 <printf>
        int pid = rt_fork(rel_deadlines[i]);
  b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  bb:	89 04 24             	mov    %eax,(%esp)
  be:	e8 c0 04 00 00       	call   583 <rt_fork>

        if(pid < 0){
  c3:	83 c4 10             	add    $0x10,%esp
        int pid = rt_fork(rel_deadlines[i]);
  c6:	89 c2                	mov    %eax,%edx
        if(pid < 0){
  c8:	85 c0                	test   %eax,%eax
  ca:	0f 88 78 01 00 00    	js     248 <main+0x248>
            printf(1, "classtest: rt_fork failed\n");
            exit();
        }   

        if(pid == 0){
  d0:	0f 84 e5 00 00 00    	je     1bb <main+0x1bb>
    for(int i = 0; i < N_EDF; i++) {
  d6:	83 c7 04             	add    $0x4,%edi
  d9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  dc:	39 f8                	cmp    %edi,%eax
  de:	75 c0                	jne    a0 <main+0xa0>
            exit();
        }

    }

    ps();
  e0:	e8 ae 04 00 00       	call   593 <ps>
    for(int i = 0; i < N_EDF + N_RR; i++){
        wait();
  e5:	83 c6 04             	add    $0x4,%esi
  e8:	e8 be 03 00 00       	call   4ab <wait>
  ed:	e8 b9 03 00 00       	call   4ab <wait>
  f2:	e8 b4 03 00 00       	call   4ab <wait>
  f7:	e8 af 03 00 00       	call   4ab <wait>
  fc:	e8 aa 03 00 00       	call   4ab <wait>
 101:	e8 a5 03 00 00       	call   4ab <wait>
    }

    for(int i = 0; i < N_FCFS; i++){
        printf(1,"New Noraml process -> pid: %d\n", pid_count++);
 106:	83 ec 04             	sub    $0x4,%esp
 109:	89 d8                	mov    %ebx,%eax
 10b:	83 c3 01             	add    $0x1,%ebx
 10e:	50                   	push   %eax
 10f:	68 70 0a 00 00       	push   $0xa70
 114:	6a 01                	push   $0x1
 116:	e8 25 05 00 00       	call   640 <printf>
        int pid = fork();
 11b:	e8 7b 03 00 00       	call   49b <fork>
        if(pid < 0){
 120:	83 c4 10             	add    $0x10,%esp
        int pid = fork();
 123:	89 c7                	mov    %eax,%edi
        if(pid < 0){
 125:	85 c0                	test   %eax,%eax
 127:	0f 88 08 01 00 00    	js     235 <main+0x235>
            printf(1,"classtest: fork failed\n");
            exit();
        }
        if(pid == 0){
 12d:	0f 84 c4 00 00 00    	je     1f7 <main+0x1f7>
    for(int i = 0; i < N_FCFS; i++){
 133:	39 f3                	cmp    %esi,%ebx
 135:	75 cf                	jne    106 <main+0x106>
            ps();
            exit();
        }
    }

    ps();
 137:	e8 57 04 00 00       	call   593 <ps>
    for(int i = 0; i < N_FCFS; i++){
        wait();
 13c:	e8 6a 03 00 00       	call   4ab <wait>
 141:	e8 65 03 00 00       	call   4ab <wait>
 146:	e8 60 03 00 00       	call   4ab <wait>
    }

    ps();
 14b:	e8 43 04 00 00       	call   593 <ps>
    exit();
 150:	e8 4e 03 00 00       	call   4a3 <exit>
            for(int j = 0; j < ITERS; j++){
 155:	83 c6 01             	add    $0x1,%esi
 158:	83 fe 03             	cmp    $0x3,%esi
 15b:	74 ee                	je     14b <main+0x14b>
                printf(1, "NORMAL pid %d  iter %d\n", getpid(), j);
 15d:	e8 c1 03 00 00       	call   523 <getpid>
 162:	56                   	push   %esi
    for(volatile int i = 0; i < BUSYLOOP; i++);
 163:	31 db                	xor    %ebx,%ebx
                printf(1, "NORMAL pid %d  iter %d\n", getpid(), j);
 165:	50                   	push   %eax
 166:	68 7d 09 00 00       	push   $0x97d
 16b:	6a 01                	push   $0x1
 16d:	e8 ce 04 00 00       	call   640 <printf>
    for(volatile int i = 0; i < BUSYLOOP; i++);
 172:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 175:	8b 45 d0             	mov    -0x30(%ebp),%eax
 178:	83 c4 10             	add    $0x10,%esp
 17b:	3d 7f 96 98 00       	cmp    $0x98967f,%eax
 180:	7f d3                	jg     155 <main+0x155>
 182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 188:	8b 45 d0             	mov    -0x30(%ebp),%eax
 18b:	83 c0 01             	add    $0x1,%eax
 18e:	89 45 d0             	mov    %eax,-0x30(%ebp)
 191:	8b 45 d0             	mov    -0x30(%ebp),%eax
 194:	3d 7f 96 98 00       	cmp    $0x98967f,%eax
 199:	7e ed                	jle    188 <main+0x188>
 19b:	eb b8                	jmp    155 <main+0x155>
 19d:	8d 76 00             	lea    0x0(%esi),%esi
    for(volatile int i = 0 ; i < LBUSYLOOP; i++)
 1a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1a3:	83 c0 01             	add    $0x1,%eax
 1a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1ac:	3d ff c1 eb 0b       	cmp    $0xbebc1ff,%eax
 1b1:	7e ed                	jle    1a0 <main+0x1a0>
            for(int j = 0; j < LITERS; j++){
 1b3:	83 c2 01             	add    $0x1,%edx
 1b6:	83 fa 03             	cmp    $0x3,%edx
 1b9:	74 90                	je     14b <main+0x14b>
 1bb:	89 55 c4             	mov    %edx,-0x3c(%ebp)
                printf(1, "REAL-TIME pid %d  iter %d\n", getpid(), j);
 1be:	e8 60 03 00 00       	call   523 <getpid>
 1c3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 1c6:	52                   	push   %edx
 1c7:	50                   	push   %eax
 1c8:	68 b0 09 00 00       	push   $0x9b0
 1cd:	6a 01                	push   $0x1
 1cf:	e8 6c 04 00 00       	call   640 <printf>
    for(volatile int i = 0 ; i < LBUSYLOOP; i++)
 1d4:	31 d2                	xor    %edx,%edx
 1d6:	83 c4 10             	add    $0x10,%esp
 1d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 1dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1df:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 1e2:	3d ff c1 eb 0b       	cmp    $0xbebc1ff,%eax
 1e7:	7e b7                	jle    1a0 <main+0x1a0>
 1e9:	eb c8                	jmp    1b3 <main+0x1b3>
            for(int j = 0; j < ITERS; j++){
 1eb:	83 c7 01             	add    $0x1,%edi
 1ee:	83 ff 03             	cmp    $0x3,%edi
 1f1:	0f 84 54 ff ff ff    	je     14b <main+0x14b>
                printf(1, "NORMAL pid %d  iter %d\n", getpid(), j);
 1f7:	e8 27 03 00 00       	call   523 <getpid>
 1fc:	57                   	push   %edi
 1fd:	50                   	push   %eax
 1fe:	68 7d 09 00 00       	push   $0x97d
 203:	6a 01                	push   $0x1
 205:	e8 36 04 00 00       	call   640 <printf>
    for(volatile int i = 0; i < BUSYLOOP; i++);
 20a:	31 c0                	xor    %eax,%eax
 20c:	83 c4 10             	add    $0x10,%esp
 20f:	89 45 d8             	mov    %eax,-0x28(%ebp)
 212:	8b 45 d8             	mov    -0x28(%ebp),%eax
 215:	3d 7f 96 98 00       	cmp    $0x98967f,%eax
 21a:	7f cf                	jg     1eb <main+0x1eb>
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 220:	8b 45 d8             	mov    -0x28(%ebp),%eax
 223:	83 c0 01             	add    $0x1,%eax
 226:	89 45 d8             	mov    %eax,-0x28(%ebp)
 229:	8b 45 d8             	mov    -0x28(%ebp),%eax
 22c:	3d 7f 96 98 00       	cmp    $0x98967f,%eax
 231:	7e ed                	jle    220 <main+0x220>
 233:	eb b6                	jmp    1eb <main+0x1eb>
            printf(1,"classtest: fork failed\n");
 235:	56                   	push   %esi
 236:	56                   	push   %esi
 237:	68 65 09 00 00       	push   $0x965
 23c:	6a 01                	push   $0x1
 23e:	e8 fd 03 00 00       	call   640 <printf>
            exit();
 243:	e8 5b 02 00 00       	call   4a3 <exit>
            printf(1, "classtest: rt_fork failed\n");
 248:	51                   	push   %ecx
 249:	51                   	push   %ecx
 24a:	68 95 09 00 00       	push   $0x995
 24f:	6a 01                	push   $0x1
 251:	e8 ea 03 00 00       	call   640 <printf>
            exit();
 256:	e8 48 02 00 00       	call   4a3 <exit>
 25b:	66 90                	xchg   %ax,%ax
 25d:	66 90                	xchg   %ax,%ax
 25f:	90                   	nop

00000260 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 260:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 261:	31 c0                	xor    %eax,%eax
{
 263:	89 e5                	mov    %esp,%ebp
 265:	53                   	push   %ebx
 266:	8b 4d 08             	mov    0x8(%ebp),%ecx
 269:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 270:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 274:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 277:	83 c0 01             	add    $0x1,%eax
 27a:	84 d2                	test   %dl,%dl
 27c:	75 f2                	jne    270 <strcpy+0x10>
    ;
  return os;
}
 27e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 281:	89 c8                	mov    %ecx,%eax
 283:	c9                   	leave
 284:	c3                   	ret
 285:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 28c:	00 
 28d:	8d 76 00             	lea    0x0(%esi),%esi

00000290 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 55 08             	mov    0x8(%ebp),%edx
 297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 29a:	0f b6 02             	movzbl (%edx),%eax
 29d:	84 c0                	test   %al,%al
 29f:	75 17                	jne    2b8 <strcmp+0x28>
 2a1:	eb 3a                	jmp    2dd <strcmp+0x4d>
 2a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2a8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2ac:	83 c2 01             	add    $0x1,%edx
 2af:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2b2:	84 c0                	test   %al,%al
 2b4:	74 1a                	je     2d0 <strcmp+0x40>
 2b6:	89 d9                	mov    %ebx,%ecx
 2b8:	0f b6 19             	movzbl (%ecx),%ebx
 2bb:	38 c3                	cmp    %al,%bl
 2bd:	74 e9                	je     2a8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2bf:	29 d8                	sub    %ebx,%eax
}
 2c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c4:	c9                   	leave
 2c5:	c3                   	ret
 2c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2cd:	00 
 2ce:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 2d0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2d4:	31 c0                	xor    %eax,%eax
 2d6:	29 d8                	sub    %ebx,%eax
}
 2d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2db:	c9                   	leave
 2dc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 2dd:	0f b6 19             	movzbl (%ecx),%ebx
 2e0:	31 c0                	xor    %eax,%eax
 2e2:	eb db                	jmp    2bf <strcmp+0x2f>
 2e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2eb:	00 
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002f0 <strlen>:

uint
strlen(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2f6:	80 3a 00             	cmpb   $0x0,(%edx)
 2f9:	74 15                	je     310 <strlen+0x20>
 2fb:	31 c0                	xor    %eax,%eax
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
 300:	83 c0 01             	add    $0x1,%eax
 303:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 307:	89 c1                	mov    %eax,%ecx
 309:	75 f5                	jne    300 <strlen+0x10>
    ;
  return n;
}
 30b:	89 c8                	mov    %ecx,%eax
 30d:	5d                   	pop    %ebp
 30e:	c3                   	ret
 30f:	90                   	nop
  for(n = 0; s[n]; n++)
 310:	31 c9                	xor    %ecx,%ecx
}
 312:	5d                   	pop    %ebp
 313:	89 c8                	mov    %ecx,%eax
 315:	c3                   	ret
 316:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 31d:	00 
 31e:	66 90                	xchg   %ax,%ax

00000320 <memset>:

void*
memset(void *dst, int c, uint n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 327:	8b 4d 10             	mov    0x10(%ebp),%ecx
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 d7                	mov    %edx,%edi
 32f:	fc                   	cld
 330:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 332:	8b 7d fc             	mov    -0x4(%ebp),%edi
 335:	89 d0                	mov    %edx,%eax
 337:	c9                   	leave
 338:	c3                   	ret
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000340 <strchr>:

char*
strchr(const char *s, char c)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 34a:	0f b6 10             	movzbl (%eax),%edx
 34d:	84 d2                	test   %dl,%dl
 34f:	75 12                	jne    363 <strchr+0x23>
 351:	eb 1d                	jmp    370 <strchr+0x30>
 353:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 358:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 35c:	83 c0 01             	add    $0x1,%eax
 35f:	84 d2                	test   %dl,%dl
 361:	74 0d                	je     370 <strchr+0x30>
    if(*s == c)
 363:	38 d1                	cmp    %dl,%cl
 365:	75 f1                	jne    358 <strchr+0x18>
      return (char*)s;
  return 0;
}
 367:	5d                   	pop    %ebp
 368:	c3                   	ret
 369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 370:	31 c0                	xor    %eax,%eax
}
 372:	5d                   	pop    %ebp
 373:	c3                   	ret
 374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 37b:	00 
 37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000380 <gets>:

char*
gets(char *buf, int max)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 385:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 388:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 389:	31 db                	xor    %ebx,%ebx
{
 38b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 38e:	eb 27                	jmp    3b7 <gets+0x37>
    cc = read(0, &c, 1);
 390:	83 ec 04             	sub    $0x4,%esp
 393:	6a 01                	push   $0x1
 395:	56                   	push   %esi
 396:	6a 00                	push   $0x0
 398:	e8 1e 01 00 00       	call   4bb <read>
    if(cc < 1)
 39d:	83 c4 10             	add    $0x10,%esp
 3a0:	85 c0                	test   %eax,%eax
 3a2:	7e 1d                	jle    3c1 <gets+0x41>
      break;
    buf[i++] = c;
 3a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3a8:	8b 55 08             	mov    0x8(%ebp),%edx
 3ab:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3af:	3c 0a                	cmp    $0xa,%al
 3b1:	74 10                	je     3c3 <gets+0x43>
 3b3:	3c 0d                	cmp    $0xd,%al
 3b5:	74 0c                	je     3c3 <gets+0x43>
  for(i=0; i+1 < max; ){
 3b7:	89 df                	mov    %ebx,%edi
 3b9:	83 c3 01             	add    $0x1,%ebx
 3bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3bf:	7c cf                	jl     390 <gets+0x10>
 3c1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 3ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3cd:	5b                   	pop    %ebx
 3ce:	5e                   	pop    %esi
 3cf:	5f                   	pop    %edi
 3d0:	5d                   	pop    %ebp
 3d1:	c3                   	ret
 3d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3d9:	00 
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e5:	83 ec 08             	sub    $0x8,%esp
 3e8:	6a 00                	push   $0x0
 3ea:	ff 75 08             	push   0x8(%ebp)
 3ed:	e8 f1 00 00 00       	call   4e3 <open>
  if(fd < 0)
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	85 c0                	test   %eax,%eax
 3f7:	78 27                	js     420 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3f9:	83 ec 08             	sub    $0x8,%esp
 3fc:	ff 75 0c             	push   0xc(%ebp)
 3ff:	89 c3                	mov    %eax,%ebx
 401:	50                   	push   %eax
 402:	e8 f4 00 00 00       	call   4fb <fstat>
  close(fd);
 407:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 40a:	89 c6                	mov    %eax,%esi
  close(fd);
 40c:	e8 ba 00 00 00       	call   4cb <close>
  return r;
 411:	83 c4 10             	add    $0x10,%esp
}
 414:	8d 65 f8             	lea    -0x8(%ebp),%esp
 417:	89 f0                	mov    %esi,%eax
 419:	5b                   	pop    %ebx
 41a:	5e                   	pop    %esi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret
 41d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 420:	be ff ff ff ff       	mov    $0xffffffff,%esi
 425:	eb ed                	jmp    414 <stat+0x34>
 427:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 42e:	00 
 42f:	90                   	nop

00000430 <atoi>:

int
atoi(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	53                   	push   %ebx
 434:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 437:	0f be 02             	movsbl (%edx),%eax
 43a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 43d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 440:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 445:	77 1e                	ja     465 <atoi+0x35>
 447:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 44e:	00 
 44f:	90                   	nop
    n = n*10 + *s++ - '0';
 450:	83 c2 01             	add    $0x1,%edx
 453:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 456:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 45a:	0f be 02             	movsbl (%edx),%eax
 45d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 460:	80 fb 09             	cmp    $0x9,%bl
 463:	76 eb                	jbe    450 <atoi+0x20>
  return n;
}
 465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 468:	89 c8                	mov    %ecx,%eax
 46a:	c9                   	leave
 46b:	c3                   	ret
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000470 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	8b 45 10             	mov    0x10(%ebp),%eax
 477:	8b 55 08             	mov    0x8(%ebp),%edx
 47a:	56                   	push   %esi
 47b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47e:	85 c0                	test   %eax,%eax
 480:	7e 13                	jle    495 <memmove+0x25>
 482:	01 d0                	add    %edx,%eax
  dst = vdst;
 484:	89 d7                	mov    %edx,%edi
 486:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 48d:	00 
 48e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 490:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 491:	39 f8                	cmp    %edi,%eax
 493:	75 fb                	jne    490 <memmove+0x20>
  return vdst;
}
 495:	5e                   	pop    %esi
 496:	89 d0                	mov    %edx,%eax
 498:	5f                   	pop    %edi
 499:	5d                   	pop    %ebp
 49a:	c3                   	ret

0000049b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 49b:	b8 01 00 00 00       	mov    $0x1,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <exit>:
SYSCALL(exit)
 4a3:	b8 02 00 00 00       	mov    $0x2,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <wait>:
SYSCALL(wait)
 4ab:	b8 03 00 00 00       	mov    $0x3,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <pipe>:
SYSCALL(pipe)
 4b3:	b8 04 00 00 00       	mov    $0x4,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <read>:
SYSCALL(read)
 4bb:	b8 05 00 00 00       	mov    $0x5,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <write>:
SYSCALL(write)
 4c3:	b8 10 00 00 00       	mov    $0x10,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <close>:
SYSCALL(close)
 4cb:	b8 15 00 00 00       	mov    $0x15,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <kill>:
SYSCALL(kill)
 4d3:	b8 06 00 00 00       	mov    $0x6,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <exec>:
SYSCALL(exec)
 4db:	b8 07 00 00 00       	mov    $0x7,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <open>:
SYSCALL(open)
 4e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <mknod>:
SYSCALL(mknod)
 4eb:	b8 11 00 00 00       	mov    $0x11,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <unlink>:
SYSCALL(unlink)
 4f3:	b8 12 00 00 00       	mov    $0x12,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <fstat>:
SYSCALL(fstat)
 4fb:	b8 08 00 00 00       	mov    $0x8,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <link>:
SYSCALL(link)
 503:	b8 13 00 00 00       	mov    $0x13,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <mkdir>:
SYSCALL(mkdir)
 50b:	b8 14 00 00 00       	mov    $0x14,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <chdir>:
SYSCALL(chdir)
 513:	b8 09 00 00 00       	mov    $0x9,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <dup>:
SYSCALL(dup)
 51b:	b8 0a 00 00 00       	mov    $0xa,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <getpid>:
SYSCALL(getpid)
 523:	b8 0b 00 00 00       	mov    $0xb,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <sbrk>:
SYSCALL(sbrk)
 52b:	b8 0c 00 00 00       	mov    $0xc,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <sleep>:
SYSCALL(sleep)
 533:	b8 0d 00 00 00       	mov    $0xd,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <uptime>:
SYSCALL(uptime)
 53b:	b8 0e 00 00 00       	mov    $0xe,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <make_user>:
SYSCALL(make_user)
 543:	b8 16 00 00 00       	mov    $0x16,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <login>:
SYSCALL(login)
 54b:	b8 17 00 00 00       	mov    $0x17,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <logout>:
SYSCALL(logout)
 553:	b8 18 00 00 00       	mov    $0x18,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <get_log>:
SYSCALL(get_log)
 55b:	b8 19 00 00 00       	mov    $0x19,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <diff>:
SYSCALL(diff)
 563:	b8 1a 00 00 00       	mov    $0x1a,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <set_sleep>:
SYSCALL(set_sleep)
 56b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <getcmostime>:
SYSCALL(getcmostime)
 573:	b8 1c 00 00 00       	mov    $0x1c,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <next_palindrome>:
SYSCALL(next_palindrome)
 57b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <rt_fork>:
SYSCALL(rt_fork)
 583:	b8 1e 00 00 00       	mov    $0x1e,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <set_class>:
SYSCALL(set_class)
 58b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <ps>:
 593:	b8 20 00 00 00       	mov    $0x20,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret
 59b:	66 90                	xchg   %ax,%ax
 59d:	66 90                	xchg   %ax,%ax
 59f:	90                   	nop

000005a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5a8:	89 d1                	mov    %edx,%ecx
{
 5aa:	83 ec 3c             	sub    $0x3c,%esp
 5ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 5b0:	85 d2                	test   %edx,%edx
 5b2:	0f 89 80 00 00 00    	jns    638 <printint+0x98>
 5b8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5bc:	74 7a                	je     638 <printint+0x98>
    x = -xx;
 5be:	f7 d9                	neg    %ecx
    neg = 1;
 5c0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 5c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5c8:	31 f6                	xor    %esi,%esi
 5ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5d0:	89 c8                	mov    %ecx,%eax
 5d2:	31 d2                	xor    %edx,%edx
 5d4:	89 f7                	mov    %esi,%edi
 5d6:	f7 f3                	div    %ebx
 5d8:	8d 76 01             	lea    0x1(%esi),%esi
 5db:	0f b6 92 e8 0a 00 00 	movzbl 0xae8(%edx),%edx
 5e2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 5e6:	89 ca                	mov    %ecx,%edx
 5e8:	89 c1                	mov    %eax,%ecx
 5ea:	39 da                	cmp    %ebx,%edx
 5ec:	73 e2                	jae    5d0 <printint+0x30>
  if(neg)
 5ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5f1:	85 c0                	test   %eax,%eax
 5f3:	74 07                	je     5fc <printint+0x5c>
    buf[i++] = '-';
 5f5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 5fa:	89 f7                	mov    %esi,%edi
 5fc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 5ff:	8b 75 c0             	mov    -0x40(%ebp),%esi
 602:	01 df                	add    %ebx,%edi
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 608:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 60b:	83 ec 04             	sub    $0x4,%esp
 60e:	88 45 d7             	mov    %al,-0x29(%ebp)
 611:	8d 45 d7             	lea    -0x29(%ebp),%eax
 614:	6a 01                	push   $0x1
 616:	50                   	push   %eax
 617:	56                   	push   %esi
 618:	e8 a6 fe ff ff       	call   4c3 <write>
  while(--i >= 0)
 61d:	89 f8                	mov    %edi,%eax
 61f:	83 c4 10             	add    $0x10,%esp
 622:	83 ef 01             	sub    $0x1,%edi
 625:	39 c3                	cmp    %eax,%ebx
 627:	75 df                	jne    608 <printint+0x68>
}
 629:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62c:	5b                   	pop    %ebx
 62d:	5e                   	pop    %esi
 62e:	5f                   	pop    %edi
 62f:	5d                   	pop    %ebp
 630:	c3                   	ret
 631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 638:	31 c0                	xor    %eax,%eax
 63a:	eb 89                	jmp    5c5 <printint+0x25>
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000640 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 649:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 64c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 64f:	0f b6 1e             	movzbl (%esi),%ebx
 652:	83 c6 01             	add    $0x1,%esi
 655:	84 db                	test   %bl,%bl
 657:	74 67                	je     6c0 <printf+0x80>
 659:	8d 4d 10             	lea    0x10(%ebp),%ecx
 65c:	31 d2                	xor    %edx,%edx
 65e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 661:	eb 34                	jmp    697 <printf+0x57>
 663:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 668:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 66b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 670:	83 f8 25             	cmp    $0x25,%eax
 673:	74 18                	je     68d <printf+0x4d>
  write(fd, &c, 1);
 675:	83 ec 04             	sub    $0x4,%esp
 678:	8d 45 e7             	lea    -0x19(%ebp),%eax
 67b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 67e:	6a 01                	push   $0x1
 680:	50                   	push   %eax
 681:	57                   	push   %edi
 682:	e8 3c fe ff ff       	call   4c3 <write>
 687:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 68a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 68d:	0f b6 1e             	movzbl (%esi),%ebx
 690:	83 c6 01             	add    $0x1,%esi
 693:	84 db                	test   %bl,%bl
 695:	74 29                	je     6c0 <printf+0x80>
    c = fmt[i] & 0xff;
 697:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 69a:	85 d2                	test   %edx,%edx
 69c:	74 ca                	je     668 <printf+0x28>
      }
    } else if(state == '%'){
 69e:	83 fa 25             	cmp    $0x25,%edx
 6a1:	75 ea                	jne    68d <printf+0x4d>
      if(c == 'd'){
 6a3:	83 f8 25             	cmp    $0x25,%eax
 6a6:	0f 84 04 01 00 00    	je     7b0 <printf+0x170>
 6ac:	83 e8 63             	sub    $0x63,%eax
 6af:	83 f8 15             	cmp    $0x15,%eax
 6b2:	77 1c                	ja     6d0 <printf+0x90>
 6b4:	ff 24 85 90 0a 00 00 	jmp    *0xa90(,%eax,4)
 6bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c3:	5b                   	pop    %ebx
 6c4:	5e                   	pop    %esi
 6c5:	5f                   	pop    %edi
 6c6:	5d                   	pop    %ebp
 6c7:	c3                   	ret
 6c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6cf:	00 
  write(fd, &c, 1);
 6d0:	83 ec 04             	sub    $0x4,%esp
 6d3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6d6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6da:	6a 01                	push   $0x1
 6dc:	52                   	push   %edx
 6dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6e0:	57                   	push   %edi
 6e1:	e8 dd fd ff ff       	call   4c3 <write>
 6e6:	83 c4 0c             	add    $0xc,%esp
 6e9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6ec:	6a 01                	push   $0x1
 6ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 6f1:	52                   	push   %edx
 6f2:	57                   	push   %edi
 6f3:	e8 cb fd ff ff       	call   4c3 <write>
        putc(fd, c);
 6f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6fb:	31 d2                	xor    %edx,%edx
 6fd:	eb 8e                	jmp    68d <printf+0x4d>
 6ff:	90                   	nop
        printint(fd, *ap, 16, 0);
 700:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 703:	83 ec 0c             	sub    $0xc,%esp
 706:	b9 10 00 00 00       	mov    $0x10,%ecx
 70b:	8b 13                	mov    (%ebx),%edx
 70d:	6a 00                	push   $0x0
 70f:	89 f8                	mov    %edi,%eax
        ap++;
 711:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 714:	e8 87 fe ff ff       	call   5a0 <printint>
        ap++;
 719:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 71c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71f:	31 d2                	xor    %edx,%edx
 721:	e9 67 ff ff ff       	jmp    68d <printf+0x4d>
        s = (char*)*ap;
 726:	8b 45 d0             	mov    -0x30(%ebp),%eax
 729:	8b 18                	mov    (%eax),%ebx
        ap++;
 72b:	83 c0 04             	add    $0x4,%eax
 72e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 731:	85 db                	test   %ebx,%ebx
 733:	0f 84 87 00 00 00    	je     7c0 <printf+0x180>
        while(*s != 0){
 739:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 73c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 73e:	84 c0                	test   %al,%al
 740:	0f 84 47 ff ff ff    	je     68d <printf+0x4d>
 746:	8d 55 e7             	lea    -0x19(%ebp),%edx
 749:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 74c:	89 de                	mov    %ebx,%esi
 74e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
 753:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 756:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 759:	6a 01                	push   $0x1
 75b:	53                   	push   %ebx
 75c:	57                   	push   %edi
 75d:	e8 61 fd ff ff       	call   4c3 <write>
        while(*s != 0){
 762:	0f b6 06             	movzbl (%esi),%eax
 765:	83 c4 10             	add    $0x10,%esp
 768:	84 c0                	test   %al,%al
 76a:	75 e4                	jne    750 <printf+0x110>
      state = 0;
 76c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 76f:	31 d2                	xor    %edx,%edx
 771:	e9 17 ff ff ff       	jmp    68d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 776:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 779:	83 ec 0c             	sub    $0xc,%esp
 77c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 781:	8b 13                	mov    (%ebx),%edx
 783:	6a 01                	push   $0x1
 785:	eb 88                	jmp    70f <printf+0xcf>
        putc(fd, *ap);
 787:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 78a:	83 ec 04             	sub    $0x4,%esp
 78d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 790:	8b 03                	mov    (%ebx),%eax
        ap++;
 792:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 795:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 798:	6a 01                	push   $0x1
 79a:	52                   	push   %edx
 79b:	57                   	push   %edi
 79c:	e8 22 fd ff ff       	call   4c3 <write>
        ap++;
 7a1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7a4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7a7:	31 d2                	xor    %edx,%edx
 7a9:	e9 df fe ff ff       	jmp    68d <printf+0x4d>
 7ae:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 7b0:	83 ec 04             	sub    $0x4,%esp
 7b3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7b6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7b9:	6a 01                	push   $0x1
 7bb:	e9 31 ff ff ff       	jmp    6f1 <printf+0xb1>
 7c0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 7c5:	bb cb 09 00 00       	mov    $0x9cb,%ebx
 7ca:	e9 77 ff ff ff       	jmp    746 <printf+0x106>
 7cf:	90                   	nop

000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d1:	a1 90 0d 00 00       	mov    0xd90,%eax
{
 7d6:	89 e5                	mov    %esp,%ebp
 7d8:	57                   	push   %edi
 7d9:	56                   	push   %esi
 7da:	53                   	push   %ebx
 7db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	39 c8                	cmp    %ecx,%eax
 7ec:	73 32                	jae    820 <free+0x50>
 7ee:	39 d1                	cmp    %edx,%ecx
 7f0:	72 04                	jb     7f6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f2:	39 d0                	cmp    %edx,%eax
 7f4:	72 32                	jb     828 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7fc:	39 fa                	cmp    %edi,%edx
 7fe:	74 30                	je     830 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 800:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 803:	8b 50 04             	mov    0x4(%eax),%edx
 806:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 809:	39 f1                	cmp    %esi,%ecx
 80b:	74 3a                	je     847 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 80d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 80f:	5b                   	pop    %ebx
  freep = p;
 810:	a3 90 0d 00 00       	mov    %eax,0xd90
}
 815:	5e                   	pop    %esi
 816:	5f                   	pop    %edi
 817:	5d                   	pop    %ebp
 818:	c3                   	ret
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	39 d0                	cmp    %edx,%eax
 822:	72 04                	jb     828 <free+0x58>
 824:	39 d1                	cmp    %edx,%ecx
 826:	72 ce                	jb     7f6 <free+0x26>
{
 828:	89 d0                	mov    %edx,%eax
 82a:	eb bc                	jmp    7e8 <free+0x18>
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 830:	03 72 04             	add    0x4(%edx),%esi
 833:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 836:	8b 10                	mov    (%eax),%edx
 838:	8b 12                	mov    (%edx),%edx
 83a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 83d:	8b 50 04             	mov    0x4(%eax),%edx
 840:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 843:	39 f1                	cmp    %esi,%ecx
 845:	75 c6                	jne    80d <free+0x3d>
    p->s.size += bp->s.size;
 847:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 84a:	a3 90 0d 00 00       	mov    %eax,0xd90
    p->s.size += bp->s.size;
 84f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 852:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 855:	89 08                	mov    %ecx,(%eax)
}
 857:	5b                   	pop    %ebx
 858:	5e                   	pop    %esi
 859:	5f                   	pop    %edi
 85a:	5d                   	pop    %ebp
 85b:	c3                   	ret
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000860 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	57                   	push   %edi
 864:	56                   	push   %esi
 865:	53                   	push   %ebx
 866:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 869:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 86c:	8b 15 90 0d 00 00    	mov    0xd90,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 872:	8d 78 07             	lea    0x7(%eax),%edi
 875:	c1 ef 03             	shr    $0x3,%edi
 878:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 87b:	85 d2                	test   %edx,%edx
 87d:	0f 84 8d 00 00 00    	je     910 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 883:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 885:	8b 48 04             	mov    0x4(%eax),%ecx
 888:	39 f9                	cmp    %edi,%ecx
 88a:	73 64                	jae    8f0 <malloc+0x90>
  if(nu < 4096)
 88c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 891:	39 df                	cmp    %ebx,%edi
 893:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 896:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 89d:	eb 0a                	jmp    8a9 <malloc+0x49>
 89f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8a2:	8b 48 04             	mov    0x4(%eax),%ecx
 8a5:	39 f9                	cmp    %edi,%ecx
 8a7:	73 47                	jae    8f0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a9:	89 c2                	mov    %eax,%edx
 8ab:	3b 05 90 0d 00 00    	cmp    0xd90,%eax
 8b1:	75 ed                	jne    8a0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 8b3:	83 ec 0c             	sub    $0xc,%esp
 8b6:	56                   	push   %esi
 8b7:	e8 6f fc ff ff       	call   52b <sbrk>
  if(p == (char*)-1)
 8bc:	83 c4 10             	add    $0x10,%esp
 8bf:	83 f8 ff             	cmp    $0xffffffff,%eax
 8c2:	74 1c                	je     8e0 <malloc+0x80>
  hp->s.size = nu;
 8c4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8c7:	83 ec 0c             	sub    $0xc,%esp
 8ca:	83 c0 08             	add    $0x8,%eax
 8cd:	50                   	push   %eax
 8ce:	e8 fd fe ff ff       	call   7d0 <free>
  return freep;
 8d3:	8b 15 90 0d 00 00    	mov    0xd90,%edx
      if((p = morecore(nunits)) == 0)
 8d9:	83 c4 10             	add    $0x10,%esp
 8dc:	85 d2                	test   %edx,%edx
 8de:	75 c0                	jne    8a0 <malloc+0x40>
        return 0;
  }
}
 8e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8e3:	31 c0                	xor    %eax,%eax
}
 8e5:	5b                   	pop    %ebx
 8e6:	5e                   	pop    %esi
 8e7:	5f                   	pop    %edi
 8e8:	5d                   	pop    %ebp
 8e9:	c3                   	ret
 8ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8f0:	39 cf                	cmp    %ecx,%edi
 8f2:	74 4c                	je     940 <malloc+0xe0>
        p->s.size -= nunits;
 8f4:	29 f9                	sub    %edi,%ecx
 8f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8fc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8ff:	89 15 90 0d 00 00    	mov    %edx,0xd90
}
 905:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 908:	83 c0 08             	add    $0x8,%eax
}
 90b:	5b                   	pop    %ebx
 90c:	5e                   	pop    %esi
 90d:	5f                   	pop    %edi
 90e:	5d                   	pop    %ebp
 90f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 910:	c7 05 90 0d 00 00 94 	movl   $0xd94,0xd90
 917:	0d 00 00 
    base.s.size = 0;
 91a:	b8 94 0d 00 00       	mov    $0xd94,%eax
    base.s.ptr = freep = prevp = &base;
 91f:	c7 05 94 0d 00 00 94 	movl   $0xd94,0xd94
 926:	0d 00 00 
    base.s.size = 0;
 929:	c7 05 98 0d 00 00 00 	movl   $0x0,0xd98
 930:	00 00 00 
    if(p->s.size >= nunits){
 933:	e9 54 ff ff ff       	jmp    88c <malloc+0x2c>
 938:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 93f:	00 
        prevp->s.ptr = p->s.ptr;
 940:	8b 08                	mov    (%eax),%ecx
 942:	89 0a                	mov    %ecx,(%edx)
 944:	eb b9                	jmp    8ff <malloc+0x9f>
