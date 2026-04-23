
_barbershop_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    for(int i = 0; i < cycles; i++) {
        asm volatile("nop");
    }
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
  11:	83 ec 70             	sub    $0x70,%esp
    int barber_pid;
    int customer_pids[NUM_CUSTOMERS];
    struct stat st;
    
    printf(1, "=== Sleeping Barber Problem Simulation ===\n");
  14:	68 88 09 00 00       	push   $0x988
  19:	6a 01                	push   $0x1
  1b:	e8 60 06 00 00       	call   680 <printf>
    printf(1, "Barbershop has 5 waiting chairs\n");
  20:	59                   	pop    %ecx
  21:	5b                   	pop    %ebx
  22:	68 b4 09 00 00       	push   $0x9b4
  27:	6a 01                	push   $0x1
    printf(1, "Testing with %d customers\n\n", NUM_CUSTOMERS);
    
    if(stat("barber", &st) < 0) {
  29:	8d 5d ac             	lea    -0x54(%ebp),%ebx
    printf(1, "Barbershop has 5 waiting chairs\n");
  2c:	e8 4f 06 00 00       	call   680 <printf>
    printf(1, "Testing with %d customers\n\n", NUM_CUSTOMERS);
  31:	83 c4 0c             	add    $0xc,%esp
  34:	6a 0a                	push   $0xa
  36:	68 38 0c 00 00       	push   $0xc38
  3b:	6a 01                	push   $0x1
  3d:	e8 3e 06 00 00       	call   680 <printf>
    if(stat("barber", &st) < 0) {
  42:	5e                   	pop    %esi
  43:	5f                   	pop    %edi
  44:	53                   	push   %ebx
  45:	68 54 0c 00 00       	push   $0xc54
  4a:	e8 a1 03 00 00       	call   3f0 <stat>
  4f:	83 c4 10             	add    $0x10,%esp
  52:	85 c0                	test   %eax,%eax
  54:	0f 88 47 01 00 00    	js     1a1 <main+0x1a1>
        printf(1, "Make sure 'barber' is compiled and available.\n");
        printf(1, "Try running: make clean && make\n");
        exit();
    }
    
    if(stat("customer", &st) < 0) {
  5a:	57                   	push   %edi
  5b:	57                   	push   %edi
  5c:	53                   	push   %ebx
  5d:	68 5b 0c 00 00       	push   $0xc5b
  62:	e8 89 03 00 00       	call   3f0 <stat>
  67:	83 c4 10             	add    $0x10,%esp
  6a:	85 c0                	test   %eax,%eax
  6c:	0f 88 ea 00 00 00    	js     15c <main+0x15c>
        printf(1, "Make sure 'customer' is compiled and available.\n");
        printf(1, "Try running: make clean && make\n");
        exit();
    }
    
    printf(1, "Both programs found. Starting simulation...\n\n");
  72:	50                   	push   %eax
  73:	50                   	push   %eax
  74:	68 a8 0a 00 00       	push   $0xaa8
  79:	6a 01                	push   $0x1
  7b:	e8 00 06 00 00       	call   680 <printf>
    
    barber_pid = fork();
  80:	e8 26 04 00 00       	call   4ab <fork>
    if(barber_pid == 0) {
  85:	83 c4 10             	add    $0x10,%esp
    barber_pid = fork();
  88:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(barber_pid == 0) {
  8b:	85 c0                	test   %eax,%eax
  8d:	0f 84 72 01 00 00    	je     205 <main+0x205>
        char *args[] = {"barber", 0};
        if(exec("barber", args) < 0) {
            printf(1, "Error: Could not exec barber (exec failed)\n");
            exit();
        }
    } else if(barber_pid < 0) {
  93:	8d 5d c0             	lea    -0x40(%ebp),%ebx
  96:	0f 88 56 01 00 00    	js     1f2 <main+0x1f2>
        printf(1, "Error: Could not fork barber process\n");
        exit();
    }
    
    printf(1, "Barber process started (PID: %d)\n", barber_pid);
  9c:	51                   	push   %ecx
  9d:	ff 75 94             	push   -0x6c(%ebp)
  a0:	68 2c 0b 00 00       	push   $0xb2c
  a5:	6a 01                	push   $0x1
  a7:	e8 d4 05 00 00       	call   680 <printf>
  ac:	83 c4 10             	add    $0x10,%esp
  af:	b8 a0 86 01 00       	mov    $0x186a0,%eax
        asm volatile("nop");
  b4:	90                   	nop
  b5:	90                   	nop
    for(int i = 0; i < cycles; i++) {
  b6:	83 e8 02             	sub    $0x2,%eax
  b9:	75 f9                	jne    b4 <main+0xb4>
    
    delay(CUSTOMER_DELAY);
    
    for(int i = 0; i < NUM_CUSTOMERS; i++) {
  bb:	31 f6                	xor    %esi,%esi
  bd:	8d 76 00             	lea    0x0(%esi),%esi
        customer_pids[i] = fork();
  c0:	e8 e6 03 00 00       	call   4ab <fork>
  c5:	89 04 b3             	mov    %eax,(%ebx,%esi,4)
  c8:	89 c7                	mov    %eax,%edi
        
        if(customer_pids[i] == 0) {
            char *args[] = {"customer", 0};
            if(exec("customer", args) < 0) {
                printf(1, "Error: Could not exec customer %d (exec failed)\n", i+1);
  ca:	83 c6 01             	add    $0x1,%esi
        if(customer_pids[i] == 0) {
  cd:	85 c0                	test   %eax,%eax
  cf:	0f 84 e3 00 00 00    	je     1b8 <main+0x1b8>
                exit();
            }
        } else if(customer_pids[i] < 0) {
  d5:	0f 88 b0 00 00 00    	js     18b <main+0x18b>
            printf(1, "Error: Could not fork customer %d\n", i+1);
            continue;
        }
        
        printf(1, "Customer %d process started (PID: %d)\n", i+1, customer_pids[i]);
  db:	57                   	push   %edi
  dc:	56                   	push   %esi
  dd:	68 a8 0b 00 00       	push   $0xba8
  e2:	6a 01                	push   $0x1
  e4:	e8 97 05 00 00       	call   680 <printf>
  e9:	83 c4 10             	add    $0x10,%esp
  ec:	b8 50 c3 00 00       	mov    $0xc350,%eax
        asm volatile("nop");
  f1:	90                   	nop
  f2:	90                   	nop
    for(int i = 0; i < cycles; i++) {
  f3:	83 e8 02             	sub    $0x2,%eax
  f6:	75 f9                	jne    f1 <main+0xf1>
    for(int i = 0; i < NUM_CUSTOMERS; i++) {
  f8:	83 fe 0a             	cmp    $0xa,%esi
  fb:	75 c3                	jne    c0 <main+0xc0>
        
        delay(CUSTOMER_DELAY / 2);
    }
    
    printf(1, "\nAll customers dispatched. Waiting for completion...\n\n");
  fd:	50                   	push   %eax
  fe:	8d 7d e8             	lea    -0x18(%ebp),%edi
    
    int completed_customers = 0;
 101:	31 f6                	xor    %esi,%esi
    printf(1, "\nAll customers dispatched. Waiting for completion...\n\n");
 103:	50                   	push   %eax
 104:	68 d0 0b 00 00       	push   $0xbd0
 109:	6a 01                	push   $0x1
 10b:	e8 70 05 00 00       	call   680 <printf>
    for(int i = 0; i < NUM_CUSTOMERS; i++) {
 110:	83 c4 10             	add    $0x10,%esp
 113:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        if(customer_pids[i] > 0) {
 118:	8b 03                	mov    (%ebx),%eax
 11a:	85 c0                	test   %eax,%eax
 11c:	7e 08                	jle    126 <main+0x126>
            wait();
 11e:	e8 98 03 00 00       	call   4bb <wait>
            completed_customers++;
 123:	83 c6 01             	add    $0x1,%esi
    for(int i = 0; i < NUM_CUSTOMERS; i++) {
 126:	83 c3 04             	add    $0x4,%ebx
 129:	39 fb                	cmp    %edi,%ebx
 12b:	75 eb                	jne    118 <main+0x118>
        }
    }
    
    printf(1, "\n%d customers completed. Terminating barber...\n", completed_customers);
 12d:	50                   	push   %eax
 12e:	56                   	push   %esi
 12f:	68 08 0c 00 00       	push   $0xc08
 134:	6a 01                	push   $0x1
 136:	e8 45 05 00 00       	call   680 <printf>
    
    kill(barber_pid);
 13b:	5a                   	pop    %edx
 13c:	ff 75 94             	push   -0x6c(%ebp)
 13f:	e8 9f 03 00 00       	call   4e3 <kill>
    wait();
 144:	e8 72 03 00 00       	call   4bb <wait>
    
    printf(1, "=== Simulation Complete ===\n");
 149:	59                   	pop    %ecx
 14a:	5b                   	pop    %ebx
 14b:	68 64 0c 00 00       	push   $0xc64
 150:	6a 01                	push   $0x1
 152:	e8 29 05 00 00       	call   680 <printf>
    exit();
 157:	e8 57 03 00 00       	call   4b3 <exit>
        printf(1, "Error: customer program not found!\n");
 15c:	51                   	push   %ecx
 15d:	51                   	push   %ecx
 15e:	68 50 0a 00 00       	push   $0xa50
 163:	6a 01                	push   $0x1
 165:	e8 16 05 00 00       	call   680 <printf>
        printf(1, "Make sure 'customer' is compiled and available.\n");
 16a:	5b                   	pop    %ebx
 16b:	5e                   	pop    %esi
 16c:	68 74 0a 00 00       	push   $0xa74
 171:	6a 01                	push   $0x1
 173:	e8 08 05 00 00       	call   680 <printf>
        printf(1, "Try running: make clean && make\n");
 178:	58                   	pop    %eax
 179:	5a                   	pop    %edx
 17a:	68 2c 0a 00 00       	push   $0xa2c
 17f:	6a 01                	push   $0x1
 181:	e8 fa 04 00 00       	call   680 <printf>
        exit();
 186:	e8 28 03 00 00       	call   4b3 <exit>
            printf(1, "Error: Could not fork customer %d\n", i+1);
 18b:	50                   	push   %eax
 18c:	56                   	push   %esi
 18d:	68 84 0b 00 00       	push   $0xb84
 192:	6a 01                	push   $0x1
 194:	e8 e7 04 00 00       	call   680 <printf>
            continue;
 199:	83 c4 10             	add    $0x10,%esp
 19c:	e9 57 ff ff ff       	jmp    f8 <main+0xf8>
        printf(1, "Error: barber program not found!\n");
 1a1:	50                   	push   %eax
 1a2:	50                   	push   %eax
 1a3:	68 d8 09 00 00       	push   $0x9d8
 1a8:	6a 01                	push   $0x1
 1aa:	e8 d1 04 00 00       	call   680 <printf>
        printf(1, "Make sure 'barber' is compiled and available.\n");
 1af:	58                   	pop    %eax
 1b0:	5a                   	pop    %edx
 1b1:	68 fc 09 00 00       	push   $0x9fc
 1b6:	eb b9                	jmp    171 <main+0x171>
            char *args[] = {"customer", 0};
 1b8:	31 c0                	xor    %eax,%eax
            if(exec("customer", args) < 0) {
 1ba:	52                   	push   %edx
            char *args[] = {"customer", 0};
 1bb:	89 45 a8             	mov    %eax,-0x58(%ebp)
            if(exec("customer", args) < 0) {
 1be:	8d 45 a4             	lea    -0x5c(%ebp),%eax
 1c1:	52                   	push   %edx
 1c2:	50                   	push   %eax
 1c3:	68 5b 0c 00 00       	push   $0xc5b
            char *args[] = {"customer", 0};
 1c8:	c7 45 a4 5b 0c 00 00 	movl   $0xc5b,-0x5c(%ebp)
            if(exec("customer", args) < 0) {
 1cf:	e8 17 03 00 00       	call   4eb <exec>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	85 c0                	test   %eax,%eax
 1d9:	0f 89 fc fe ff ff    	jns    db <main+0xdb>
                printf(1, "Error: Could not exec customer %d (exec failed)\n", i+1);
 1df:	50                   	push   %eax
 1e0:	56                   	push   %esi
 1e1:	68 50 0b 00 00       	push   $0xb50
 1e6:	6a 01                	push   $0x1
 1e8:	e8 93 04 00 00       	call   680 <printf>
                exit();
 1ed:	e8 c1 02 00 00       	call   4b3 <exit>
        printf(1, "Error: Could not fork barber process\n");
 1f2:	53                   	push   %ebx
 1f3:	53                   	push   %ebx
 1f4:	68 04 0b 00 00       	push   $0xb04
 1f9:	6a 01                	push   $0x1
 1fb:	e8 80 04 00 00       	call   680 <printf>
        exit();
 200:	e8 ae 02 00 00       	call   4b3 <exit>
        if(exec("barber", args) < 0) {
 205:	8d 5d c0             	lea    -0x40(%ebp),%ebx
 208:	50                   	push   %eax
        char *args[] = {"barber", 0};
 209:	31 ff                	xor    %edi,%edi
        if(exec("barber", args) < 0) {
 20b:	50                   	push   %eax
 20c:	53                   	push   %ebx
 20d:	68 54 0c 00 00       	push   $0xc54
        char *args[] = {"barber", 0};
 212:	c7 45 c0 54 0c 00 00 	movl   $0xc54,-0x40(%ebp)
 219:	89 7d c4             	mov    %edi,-0x3c(%ebp)
        if(exec("barber", args) < 0) {
 21c:	e8 ca 02 00 00       	call   4eb <exec>
 221:	83 c4 10             	add    $0x10,%esp
 224:	85 c0                	test   %eax,%eax
 226:	0f 89 70 fe ff ff    	jns    9c <main+0x9c>
            printf(1, "Error: Could not exec barber (exec failed)\n");
 22c:	56                   	push   %esi
 22d:	56                   	push   %esi
 22e:	68 d8 0a 00 00       	push   $0xad8
 233:	6a 01                	push   $0x1
 235:	e8 46 04 00 00       	call   680 <printf>
            exit();
 23a:	e8 74 02 00 00       	call   4b3 <exit>
 23f:	90                   	nop

00000240 <delay>:
void delay(int cycles) {
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 55 08             	mov    0x8(%ebp),%edx
    for(int i = 0; i < cycles; i++) {
 246:	85 d2                	test   %edx,%edx
 248:	7e 1f                	jle    269 <delay+0x29>
 24a:	31 c0                	xor    %eax,%eax
 24c:	f6 c2 01             	test   $0x1,%dl
 24f:	74 0f                	je     260 <delay+0x20>
        asm volatile("nop");
 251:	90                   	nop
    for(int i = 0; i < cycles; i++) {
 252:	b8 01 00 00 00       	mov    $0x1,%eax
 257:	83 fa 01             	cmp    $0x1,%edx
 25a:	74 0d                	je     269 <delay+0x29>
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        asm volatile("nop");
 260:	90                   	nop
 261:	90                   	nop
    for(int i = 0; i < cycles; i++) {
 262:	83 c0 02             	add    $0x2,%eax
 265:	39 c2                	cmp    %eax,%edx
 267:	75 f7                	jne    260 <delay+0x20>
}
 269:	5d                   	pop    %ebp
 26a:	c3                   	ret
 26b:	66 90                	xchg   %ax,%ax
 26d:	66 90                	xchg   %ax,%ax
 26f:	90                   	nop

00000270 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 270:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 271:	31 c0                	xor    %eax,%eax
{
 273:	89 e5                	mov    %esp,%ebp
 275:	53                   	push   %ebx
 276:	8b 4d 08             	mov    0x8(%ebp),%ecx
 279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 280:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 284:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 287:	83 c0 01             	add    $0x1,%eax
 28a:	84 d2                	test   %dl,%dl
 28c:	75 f2                	jne    280 <strcpy+0x10>
    ;
  return os;
}
 28e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 291:	89 c8                	mov    %ecx,%eax
 293:	c9                   	leave
 294:	c3                   	ret
 295:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 29c:	00 
 29d:	8d 76 00             	lea    0x0(%esi),%esi

000002a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
 2a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2aa:	0f b6 02             	movzbl (%edx),%eax
 2ad:	84 c0                	test   %al,%al
 2af:	75 17                	jne    2c8 <strcmp+0x28>
 2b1:	eb 3a                	jmp    2ed <strcmp+0x4d>
 2b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2bc:	83 c2 01             	add    $0x1,%edx
 2bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2c2:	84 c0                	test   %al,%al
 2c4:	74 1a                	je     2e0 <strcmp+0x40>
 2c6:	89 d9                	mov    %ebx,%ecx
 2c8:	0f b6 19             	movzbl (%ecx),%ebx
 2cb:	38 c3                	cmp    %al,%bl
 2cd:	74 e9                	je     2b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2cf:	29 d8                	sub    %ebx,%eax
}
 2d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2d4:	c9                   	leave
 2d5:	c3                   	ret
 2d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2dd:	00 
 2de:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 2e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2e4:	31 c0                	xor    %eax,%eax
 2e6:	29 d8                	sub    %ebx,%eax
}
 2e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2eb:	c9                   	leave
 2ec:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 2ed:	0f b6 19             	movzbl (%ecx),%ebx
 2f0:	31 c0                	xor    %eax,%eax
 2f2:	eb db                	jmp    2cf <strcmp+0x2f>
 2f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2fb:	00 
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000300 <strlen>:

uint
strlen(const char *s)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 306:	80 3a 00             	cmpb   $0x0,(%edx)
 309:	74 15                	je     320 <strlen+0x20>
 30b:	31 c0                	xor    %eax,%eax
 30d:	8d 76 00             	lea    0x0(%esi),%esi
 310:	83 c0 01             	add    $0x1,%eax
 313:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 317:	89 c1                	mov    %eax,%ecx
 319:	75 f5                	jne    310 <strlen+0x10>
    ;
  return n;
}
 31b:	89 c8                	mov    %ecx,%eax
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret
 31f:	90                   	nop
  for(n = 0; s[n]; n++)
 320:	31 c9                	xor    %ecx,%ecx
}
 322:	5d                   	pop    %ebp
 323:	89 c8                	mov    %ecx,%eax
 325:	c3                   	ret
 326:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 32d:	00 
 32e:	66 90                	xchg   %ax,%ax

00000330 <memset>:

void*
memset(void *dst, int c, uint n)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 337:	8b 4d 10             	mov    0x10(%ebp),%ecx
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 d7                	mov    %edx,%edi
 33f:	fc                   	cld
 340:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 342:	8b 7d fc             	mov    -0x4(%ebp),%edi
 345:	89 d0                	mov    %edx,%eax
 347:	c9                   	leave
 348:	c3                   	ret
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000350 <strchr>:

char*
strchr(const char *s, char c)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 35a:	0f b6 10             	movzbl (%eax),%edx
 35d:	84 d2                	test   %dl,%dl
 35f:	75 12                	jne    373 <strchr+0x23>
 361:	eb 1d                	jmp    380 <strchr+0x30>
 363:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 368:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 36c:	83 c0 01             	add    $0x1,%eax
 36f:	84 d2                	test   %dl,%dl
 371:	74 0d                	je     380 <strchr+0x30>
    if(*s == c)
 373:	38 d1                	cmp    %dl,%cl
 375:	75 f1                	jne    368 <strchr+0x18>
      return (char*)s;
  return 0;
}
 377:	5d                   	pop    %ebp
 378:	c3                   	ret
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 380:	31 c0                	xor    %eax,%eax
}
 382:	5d                   	pop    %ebp
 383:	c3                   	ret
 384:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 38b:	00 
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 395:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 398:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 399:	31 db                	xor    %ebx,%ebx
{
 39b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 39e:	eb 27                	jmp    3c7 <gets+0x37>
    cc = read(0, &c, 1);
 3a0:	83 ec 04             	sub    $0x4,%esp
 3a3:	6a 01                	push   $0x1
 3a5:	56                   	push   %esi
 3a6:	6a 00                	push   $0x0
 3a8:	e8 1e 01 00 00       	call   4cb <read>
    if(cc < 1)
 3ad:	83 c4 10             	add    $0x10,%esp
 3b0:	85 c0                	test   %eax,%eax
 3b2:	7e 1d                	jle    3d1 <gets+0x41>
      break;
    buf[i++] = c;
 3b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3b8:	8b 55 08             	mov    0x8(%ebp),%edx
 3bb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3bf:	3c 0a                	cmp    $0xa,%al
 3c1:	74 10                	je     3d3 <gets+0x43>
 3c3:	3c 0d                	cmp    $0xd,%al
 3c5:	74 0c                	je     3d3 <gets+0x43>
  for(i=0; i+1 < max; ){
 3c7:	89 df                	mov    %ebx,%edi
 3c9:	83 c3 01             	add    $0x1,%ebx
 3cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3cf:	7c cf                	jl     3a0 <gets+0x10>
 3d1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 3da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3dd:	5b                   	pop    %ebx
 3de:	5e                   	pop    %esi
 3df:	5f                   	pop    %edi
 3e0:	5d                   	pop    %ebp
 3e1:	c3                   	ret
 3e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3e9:	00 
 3ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	56                   	push   %esi
 3f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f5:	83 ec 08             	sub    $0x8,%esp
 3f8:	6a 00                	push   $0x0
 3fa:	ff 75 08             	push   0x8(%ebp)
 3fd:	e8 f1 00 00 00       	call   4f3 <open>
  if(fd < 0)
 402:	83 c4 10             	add    $0x10,%esp
 405:	85 c0                	test   %eax,%eax
 407:	78 27                	js     430 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 409:	83 ec 08             	sub    $0x8,%esp
 40c:	ff 75 0c             	push   0xc(%ebp)
 40f:	89 c3                	mov    %eax,%ebx
 411:	50                   	push   %eax
 412:	e8 f4 00 00 00       	call   50b <fstat>
  close(fd);
 417:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 41a:	89 c6                	mov    %eax,%esi
  close(fd);
 41c:	e8 ba 00 00 00       	call   4db <close>
  return r;
 421:	83 c4 10             	add    $0x10,%esp
}
 424:	8d 65 f8             	lea    -0x8(%ebp),%esp
 427:	89 f0                	mov    %esi,%eax
 429:	5b                   	pop    %ebx
 42a:	5e                   	pop    %esi
 42b:	5d                   	pop    %ebp
 42c:	c3                   	ret
 42d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 430:	be ff ff ff ff       	mov    $0xffffffff,%esi
 435:	eb ed                	jmp    424 <stat+0x34>
 437:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 43e:	00 
 43f:	90                   	nop

00000440 <atoi>:

int
atoi(const char *s)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	53                   	push   %ebx
 444:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 447:	0f be 02             	movsbl (%edx),%eax
 44a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 44d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 450:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 455:	77 1e                	ja     475 <atoi+0x35>
 457:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 45e:	00 
 45f:	90                   	nop
    n = n*10 + *s++ - '0';
 460:	83 c2 01             	add    $0x1,%edx
 463:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 466:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 46a:	0f be 02             	movsbl (%edx),%eax
 46d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 470:	80 fb 09             	cmp    $0x9,%bl
 473:	76 eb                	jbe    460 <atoi+0x20>
  return n;
}
 475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 478:	89 c8                	mov    %ecx,%eax
 47a:	c9                   	leave
 47b:	c3                   	ret
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000480 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	8b 45 10             	mov    0x10(%ebp),%eax
 487:	8b 55 08             	mov    0x8(%ebp),%edx
 48a:	56                   	push   %esi
 48b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48e:	85 c0                	test   %eax,%eax
 490:	7e 13                	jle    4a5 <memmove+0x25>
 492:	01 d0                	add    %edx,%eax
  dst = vdst;
 494:	89 d7                	mov    %edx,%edi
 496:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 49d:	00 
 49e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 4a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4a1:	39 f8                	cmp    %edi,%eax
 4a3:	75 fb                	jne    4a0 <memmove+0x20>
  return vdst;
}
 4a5:	5e                   	pop    %esi
 4a6:	89 d0                	mov    %edx,%eax
 4a8:	5f                   	pop    %edi
 4a9:	5d                   	pop    %ebp
 4aa:	c3                   	ret

000004ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ab:	b8 01 00 00 00       	mov    $0x1,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <exit>:
SYSCALL(exit)
 4b3:	b8 02 00 00 00       	mov    $0x2,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <wait>:
SYSCALL(wait)
 4bb:	b8 03 00 00 00       	mov    $0x3,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <pipe>:
SYSCALL(pipe)
 4c3:	b8 04 00 00 00       	mov    $0x4,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <read>:
SYSCALL(read)
 4cb:	b8 05 00 00 00       	mov    $0x5,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <write>:
SYSCALL(write)
 4d3:	b8 10 00 00 00       	mov    $0x10,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <close>:
SYSCALL(close)
 4db:	b8 15 00 00 00       	mov    $0x15,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <kill>:
SYSCALL(kill)
 4e3:	b8 06 00 00 00       	mov    $0x6,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <exec>:
SYSCALL(exec)
 4eb:	b8 07 00 00 00       	mov    $0x7,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <open>:
SYSCALL(open)
 4f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <mknod>:
SYSCALL(mknod)
 4fb:	b8 11 00 00 00       	mov    $0x11,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <unlink>:
SYSCALL(unlink)
 503:	b8 12 00 00 00       	mov    $0x12,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <fstat>:
SYSCALL(fstat)
 50b:	b8 08 00 00 00       	mov    $0x8,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <link>:
SYSCALL(link)
 513:	b8 13 00 00 00       	mov    $0x13,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <mkdir>:
SYSCALL(mkdir)
 51b:	b8 14 00 00 00       	mov    $0x14,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <chdir>:
SYSCALL(chdir)
 523:	b8 09 00 00 00       	mov    $0x9,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <dup>:
SYSCALL(dup)
 52b:	b8 0a 00 00 00       	mov    $0xa,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <getpid>:
SYSCALL(getpid)
 533:	b8 0b 00 00 00       	mov    $0xb,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <sbrk>:
SYSCALL(sbrk)
 53b:	b8 0c 00 00 00       	mov    $0xc,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <sleep>:
SYSCALL(sleep)
 543:	b8 0d 00 00 00       	mov    $0xd,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <uptime>:
SYSCALL(uptime)
 54b:	b8 0e 00 00 00       	mov    $0xe,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <make_user>:
SYSCALL(make_user)
 553:	b8 16 00 00 00       	mov    $0x16,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <login>:
SYSCALL(login)
 55b:	b8 17 00 00 00       	mov    $0x17,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <logout>:
SYSCALL(logout)
 563:	b8 18 00 00 00       	mov    $0x18,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <get_log>:
SYSCALL(get_log)
 56b:	b8 19 00 00 00       	mov    $0x19,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <diff>:
SYSCALL(diff)
 573:	b8 1a 00 00 00       	mov    $0x1a,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <set_sleep>:
SYSCALL(set_sleep)
 57b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <getcmostime>:
SYSCALL(getcmostime)
 583:	b8 1c 00 00 00       	mov    $0x1c,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <next_palindrome>:
SYSCALL(next_palindrome)
 58b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <rt_fork>:
SYSCALL(rt_fork)
 593:	b8 1e 00 00 00       	mov    $0x1e,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <set_class>:
SYSCALL(set_class)
 59b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <ps>:
SYSCALL(ps)
 5a3:	b8 20 00 00 00       	mov    $0x20,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <barber_sleep>:
SYSCALL(barber_sleep)
 5ab:	b8 21 00 00 00       	mov    $0x21,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <customer_arrive>:
SYSCALL(customer_arrive)
 5b3:	b8 22 00 00 00       	mov    $0x22,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret

000005bb <cut_hair>:
SYSCALL(cut_hair)
 5bb:	b8 23 00 00 00       	mov    $0x23,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret

000005c3 <customer_wait_haircut>:
SYSCALL(customer_wait_haircut)
 5c3:	b8 24 00 00 00       	mov    $0x24,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret

000005cb <init_rw_lock>:
SYSCALL(init_rw_lock)
 5cb:	b8 25 00 00 00       	mov    $0x25,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret

000005d3 <get_rw_pattern>:
 5d3:	b8 26 00 00 00       	mov    $0x26,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret
 5db:	66 90                	xchg   %ax,%ax
 5dd:	66 90                	xchg   %ax,%ax
 5df:	90                   	nop

000005e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5e8:	89 d1                	mov    %edx,%ecx
{
 5ea:	83 ec 3c             	sub    $0x3c,%esp
 5ed:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 5f0:	85 d2                	test   %edx,%edx
 5f2:	0f 89 80 00 00 00    	jns    678 <printint+0x98>
 5f8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5fc:	74 7a                	je     678 <printint+0x98>
    x = -xx;
 5fe:	f7 d9                	neg    %ecx
    neg = 1;
 600:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 605:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 608:	31 f6                	xor    %esi,%esi
 60a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 610:	89 c8                	mov    %ecx,%eax
 612:	31 d2                	xor    %edx,%edx
 614:	89 f7                	mov    %esi,%edi
 616:	f7 f3                	div    %ebx
 618:	8d 76 01             	lea    0x1(%esi),%esi
 61b:	0f b6 92 e0 0c 00 00 	movzbl 0xce0(%edx),%edx
 622:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 626:	89 ca                	mov    %ecx,%edx
 628:	89 c1                	mov    %eax,%ecx
 62a:	39 da                	cmp    %ebx,%edx
 62c:	73 e2                	jae    610 <printint+0x30>
  if(neg)
 62e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 631:	85 c0                	test   %eax,%eax
 633:	74 07                	je     63c <printint+0x5c>
    buf[i++] = '-';
 635:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 63a:	89 f7                	mov    %esi,%edi
 63c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 63f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 642:	01 df                	add    %ebx,%edi
 644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 648:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 64b:	83 ec 04             	sub    $0x4,%esp
 64e:	88 45 d7             	mov    %al,-0x29(%ebp)
 651:	8d 45 d7             	lea    -0x29(%ebp),%eax
 654:	6a 01                	push   $0x1
 656:	50                   	push   %eax
 657:	56                   	push   %esi
 658:	e8 76 fe ff ff       	call   4d3 <write>
  while(--i >= 0)
 65d:	89 f8                	mov    %edi,%eax
 65f:	83 c4 10             	add    $0x10,%esp
 662:	83 ef 01             	sub    $0x1,%edi
 665:	39 c3                	cmp    %eax,%ebx
 667:	75 df                	jne    648 <printint+0x68>
}
 669:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66c:	5b                   	pop    %ebx
 66d:	5e                   	pop    %esi
 66e:	5f                   	pop    %edi
 66f:	5d                   	pop    %ebp
 670:	c3                   	ret
 671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 678:	31 c0                	xor    %eax,%eax
 67a:	eb 89                	jmp    605 <printint+0x25>
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000680 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	56                   	push   %esi
 685:	53                   	push   %ebx
 686:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 689:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 68c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 68f:	0f b6 1e             	movzbl (%esi),%ebx
 692:	83 c6 01             	add    $0x1,%esi
 695:	84 db                	test   %bl,%bl
 697:	74 67                	je     700 <printf+0x80>
 699:	8d 4d 10             	lea    0x10(%ebp),%ecx
 69c:	31 d2                	xor    %edx,%edx
 69e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 6a1:	eb 34                	jmp    6d7 <printf+0x57>
 6a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 6a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6ab:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6b0:	83 f8 25             	cmp    $0x25,%eax
 6b3:	74 18                	je     6cd <printf+0x4d>
  write(fd, &c, 1);
 6b5:	83 ec 04             	sub    $0x4,%esp
 6b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6bb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6be:	6a 01                	push   $0x1
 6c0:	50                   	push   %eax
 6c1:	57                   	push   %edi
 6c2:	e8 0c fe ff ff       	call   4d3 <write>
 6c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6ca:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6cd:	0f b6 1e             	movzbl (%esi),%ebx
 6d0:	83 c6 01             	add    $0x1,%esi
 6d3:	84 db                	test   %bl,%bl
 6d5:	74 29                	je     700 <printf+0x80>
    c = fmt[i] & 0xff;
 6d7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6da:	85 d2                	test   %edx,%edx
 6dc:	74 ca                	je     6a8 <printf+0x28>
      }
    } else if(state == '%'){
 6de:	83 fa 25             	cmp    $0x25,%edx
 6e1:	75 ea                	jne    6cd <printf+0x4d>
      if(c == 'd'){
 6e3:	83 f8 25             	cmp    $0x25,%eax
 6e6:	0f 84 04 01 00 00    	je     7f0 <printf+0x170>
 6ec:	83 e8 63             	sub    $0x63,%eax
 6ef:	83 f8 15             	cmp    $0x15,%eax
 6f2:	77 1c                	ja     710 <printf+0x90>
 6f4:	ff 24 85 88 0c 00 00 	jmp    *0xc88(,%eax,4)
 6fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 700:	8d 65 f4             	lea    -0xc(%ebp),%esp
 703:	5b                   	pop    %ebx
 704:	5e                   	pop    %esi
 705:	5f                   	pop    %edi
 706:	5d                   	pop    %ebp
 707:	c3                   	ret
 708:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 70f:	00 
  write(fd, &c, 1);
 710:	83 ec 04             	sub    $0x4,%esp
 713:	8d 55 e7             	lea    -0x19(%ebp),%edx
 716:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 71a:	6a 01                	push   $0x1
 71c:	52                   	push   %edx
 71d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 720:	57                   	push   %edi
 721:	e8 ad fd ff ff       	call   4d3 <write>
 726:	83 c4 0c             	add    $0xc,%esp
 729:	88 5d e7             	mov    %bl,-0x19(%ebp)
 72c:	6a 01                	push   $0x1
 72e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 731:	52                   	push   %edx
 732:	57                   	push   %edi
 733:	e8 9b fd ff ff       	call   4d3 <write>
        putc(fd, c);
 738:	83 c4 10             	add    $0x10,%esp
      state = 0;
 73b:	31 d2                	xor    %edx,%edx
 73d:	eb 8e                	jmp    6cd <printf+0x4d>
 73f:	90                   	nop
        printint(fd, *ap, 16, 0);
 740:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 743:	83 ec 0c             	sub    $0xc,%esp
 746:	b9 10 00 00 00       	mov    $0x10,%ecx
 74b:	8b 13                	mov    (%ebx),%edx
 74d:	6a 00                	push   $0x0
 74f:	89 f8                	mov    %edi,%eax
        ap++;
 751:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 754:	e8 87 fe ff ff       	call   5e0 <printint>
        ap++;
 759:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 75c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 75f:	31 d2                	xor    %edx,%edx
 761:	e9 67 ff ff ff       	jmp    6cd <printf+0x4d>
        s = (char*)*ap;
 766:	8b 45 d0             	mov    -0x30(%ebp),%eax
 769:	8b 18                	mov    (%eax),%ebx
        ap++;
 76b:	83 c0 04             	add    $0x4,%eax
 76e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 771:	85 db                	test   %ebx,%ebx
 773:	0f 84 87 00 00 00    	je     800 <printf+0x180>
        while(*s != 0){
 779:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 77c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 77e:	84 c0                	test   %al,%al
 780:	0f 84 47 ff ff ff    	je     6cd <printf+0x4d>
 786:	8d 55 e7             	lea    -0x19(%ebp),%edx
 789:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 78c:	89 de                	mov    %ebx,%esi
 78e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 790:	83 ec 04             	sub    $0x4,%esp
 793:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 796:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 799:	6a 01                	push   $0x1
 79b:	53                   	push   %ebx
 79c:	57                   	push   %edi
 79d:	e8 31 fd ff ff       	call   4d3 <write>
        while(*s != 0){
 7a2:	0f b6 06             	movzbl (%esi),%eax
 7a5:	83 c4 10             	add    $0x10,%esp
 7a8:	84 c0                	test   %al,%al
 7aa:	75 e4                	jne    790 <printf+0x110>
      state = 0;
 7ac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 7af:	31 d2                	xor    %edx,%edx
 7b1:	e9 17 ff ff ff       	jmp    6cd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 7b6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7b9:	83 ec 0c             	sub    $0xc,%esp
 7bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7c1:	8b 13                	mov    (%ebx),%edx
 7c3:	6a 01                	push   $0x1
 7c5:	eb 88                	jmp    74f <printf+0xcf>
        putc(fd, *ap);
 7c7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 7ca:	83 ec 04             	sub    $0x4,%esp
 7cd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 7d0:	8b 03                	mov    (%ebx),%eax
        ap++;
 7d2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 7d5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7d8:	6a 01                	push   $0x1
 7da:	52                   	push   %edx
 7db:	57                   	push   %edi
 7dc:	e8 f2 fc ff ff       	call   4d3 <write>
        ap++;
 7e1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7e4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7e7:	31 d2                	xor    %edx,%edx
 7e9:	e9 df fe ff ff       	jmp    6cd <printf+0x4d>
 7ee:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 7f0:	83 ec 04             	sub    $0x4,%esp
 7f3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7f6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7f9:	6a 01                	push   $0x1
 7fb:	e9 31 ff ff ff       	jmp    731 <printf+0xb1>
 800:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 805:	bb 81 0c 00 00       	mov    $0xc81,%ebx
 80a:	e9 77 ff ff ff       	jmp    786 <printf+0x106>
 80f:	90                   	nop

00000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	a1 a8 0f 00 00       	mov    0xfa8,%eax
{
 816:	89 e5                	mov    %esp,%ebp
 818:	57                   	push   %edi
 819:	56                   	push   %esi
 81a:	53                   	push   %ebx
 81b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 81e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	39 c8                	cmp    %ecx,%eax
 82c:	73 32                	jae    860 <free+0x50>
 82e:	39 d1                	cmp    %edx,%ecx
 830:	72 04                	jb     836 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 832:	39 d0                	cmp    %edx,%eax
 834:	72 32                	jb     868 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 836:	8b 73 fc             	mov    -0x4(%ebx),%esi
 839:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 83c:	39 fa                	cmp    %edi,%edx
 83e:	74 30                	je     870 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 843:	8b 50 04             	mov    0x4(%eax),%edx
 846:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 849:	39 f1                	cmp    %esi,%ecx
 84b:	74 3a                	je     887 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 84d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 84f:	5b                   	pop    %ebx
  freep = p;
 850:	a3 a8 0f 00 00       	mov    %eax,0xfa8
}
 855:	5e                   	pop    %esi
 856:	5f                   	pop    %edi
 857:	5d                   	pop    %ebp
 858:	c3                   	ret
 859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	39 d0                	cmp    %edx,%eax
 862:	72 04                	jb     868 <free+0x58>
 864:	39 d1                	cmp    %edx,%ecx
 866:	72 ce                	jb     836 <free+0x26>
{
 868:	89 d0                	mov    %edx,%eax
 86a:	eb bc                	jmp    828 <free+0x18>
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 870:	03 72 04             	add    0x4(%edx),%esi
 873:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	8b 10                	mov    (%eax),%edx
 878:	8b 12                	mov    (%edx),%edx
 87a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 87d:	8b 50 04             	mov    0x4(%eax),%edx
 880:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 883:	39 f1                	cmp    %esi,%ecx
 885:	75 c6                	jne    84d <free+0x3d>
    p->s.size += bp->s.size;
 887:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 88a:	a3 a8 0f 00 00       	mov    %eax,0xfa8
    p->s.size += bp->s.size;
 88f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 892:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 895:	89 08                	mov    %ecx,(%eax)
}
 897:	5b                   	pop    %ebx
 898:	5e                   	pop    %esi
 899:	5f                   	pop    %edi
 89a:	5d                   	pop    %ebp
 89b:	c3                   	ret
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ac:	8b 15 a8 0f 00 00    	mov    0xfa8,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	8d 78 07             	lea    0x7(%eax),%edi
 8b5:	c1 ef 03             	shr    $0x3,%edi
 8b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8bb:	85 d2                	test   %edx,%edx
 8bd:	0f 84 8d 00 00 00    	je     950 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8c5:	8b 48 04             	mov    0x4(%eax),%ecx
 8c8:	39 f9                	cmp    %edi,%ecx
 8ca:	73 64                	jae    930 <malloc+0x90>
  if(nu < 4096)
 8cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8d1:	39 df                	cmp    %ebx,%edi
 8d3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8d6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8dd:	eb 0a                	jmp    8e9 <malloc+0x49>
 8df:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8e2:	8b 48 04             	mov    0x4(%eax),%ecx
 8e5:	39 f9                	cmp    %edi,%ecx
 8e7:	73 47                	jae    930 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e9:	89 c2                	mov    %eax,%edx
 8eb:	3b 05 a8 0f 00 00    	cmp    0xfa8,%eax
 8f1:	75 ed                	jne    8e0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 8f3:	83 ec 0c             	sub    $0xc,%esp
 8f6:	56                   	push   %esi
 8f7:	e8 3f fc ff ff       	call   53b <sbrk>
  if(p == (char*)-1)
 8fc:	83 c4 10             	add    $0x10,%esp
 8ff:	83 f8 ff             	cmp    $0xffffffff,%eax
 902:	74 1c                	je     920 <malloc+0x80>
  hp->s.size = nu;
 904:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 907:	83 ec 0c             	sub    $0xc,%esp
 90a:	83 c0 08             	add    $0x8,%eax
 90d:	50                   	push   %eax
 90e:	e8 fd fe ff ff       	call   810 <free>
  return freep;
 913:	8b 15 a8 0f 00 00    	mov    0xfa8,%edx
      if((p = morecore(nunits)) == 0)
 919:	83 c4 10             	add    $0x10,%esp
 91c:	85 d2                	test   %edx,%edx
 91e:	75 c0                	jne    8e0 <malloc+0x40>
        return 0;
  }
}
 920:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 923:	31 c0                	xor    %eax,%eax
}
 925:	5b                   	pop    %ebx
 926:	5e                   	pop    %esi
 927:	5f                   	pop    %edi
 928:	5d                   	pop    %ebp
 929:	c3                   	ret
 92a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 930:	39 cf                	cmp    %ecx,%edi
 932:	74 4c                	je     980 <malloc+0xe0>
        p->s.size -= nunits;
 934:	29 f9                	sub    %edi,%ecx
 936:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 939:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 93c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 93f:	89 15 a8 0f 00 00    	mov    %edx,0xfa8
}
 945:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 948:	83 c0 08             	add    $0x8,%eax
}
 94b:	5b                   	pop    %ebx
 94c:	5e                   	pop    %esi
 94d:	5f                   	pop    %edi
 94e:	5d                   	pop    %ebp
 94f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 950:	c7 05 a8 0f 00 00 ac 	movl   $0xfac,0xfa8
 957:	0f 00 00 
    base.s.size = 0;
 95a:	b8 ac 0f 00 00       	mov    $0xfac,%eax
    base.s.ptr = freep = prevp = &base;
 95f:	c7 05 ac 0f 00 00 ac 	movl   $0xfac,0xfac
 966:	0f 00 00 
    base.s.size = 0;
 969:	c7 05 b0 0f 00 00 00 	movl   $0x0,0xfb0
 970:	00 00 00 
    if(p->s.size >= nunits){
 973:	e9 54 ff ff ff       	jmp    8cc <malloc+0x2c>
 978:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 97f:	00 
        prevp->s.ptr = p->s.ptr;
 980:	8b 08                	mov    (%eax),%ecx
 982:	89 0a                	mov    %ecx,(%edx)
 984:	eb b9                	jmp    93f <malloc+0x9f>
