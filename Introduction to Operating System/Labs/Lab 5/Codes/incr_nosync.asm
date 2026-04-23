
_incr_nosync:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#define ID     1
#define NITER  1000

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int *p = (int*)open_shared_mem(ID);
   f:	83 ec 0c             	sub    $0xc,%esp
  12:	6a 01                	push   $0x1
  14:	e8 8a 03 00 00       	call   3a3 <open_shared_mem>
  if(p == (int*)-1){
  19:	83 c4 10             	add    $0x10,%esp
  1c:	83 f8 ff             	cmp    $0xffffffff,%eax
  1f:	74 49                	je     6a <main+0x6a>
  21:	89 c3                	mov    %eax,%ebx
    printf(1, "open_shared_mem failed\n");
    exit();
  }
  *p = 0;
  23:	31 c0                	xor    %eax,%eax
  25:	89 03                	mov    %eax,(%ebx)
  if(fork() == 0){
  27:	e8 8f 02 00 00       	call   2bb <fork>
  2c:	85 c0                	test   %eax,%eax
  2e:	75 0b                	jne    3b <main+0x3b>
    for(int i = 0; i < NITER; i++){
  30:	81 03 e8 03 00 00    	addl   $0x3e8,(%ebx)
      *p = *p + 1;      
    }
    exit();
  36:	e8 88 02 00 00       	call   2c3 <exit>
  }
  for(int i = 0; i < NITER; i++){
  3b:	81 03 e8 03 00 00    	addl   $0x3e8,(%ebx)
    *p = *p + 1;
  }
  wait();
  41:	e8 85 02 00 00       	call   2cb <wait>
  printf(1,"nosync final = %d (expected %d)\n", *p, 2*NITER);
  46:	68 d0 07 00 00       	push   $0x7d0
  4b:	ff 33                	push   (%ebx)
  4d:	68 a8 07 00 00       	push   $0x7a8
  52:	6a 01                	push   $0x1
  54:	e8 27 04 00 00       	call   480 <printf>
  close_shared_mem(ID);
  59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  60:	e8 46 03 00 00       	call   3ab <close_shared_mem>
  exit();
  65:	e8 59 02 00 00       	call   2c3 <exit>
    printf(1, "open_shared_mem failed\n");
  6a:	52                   	push   %edx
  6b:	52                   	push   %edx
  6c:	68 88 07 00 00       	push   $0x788
  71:	6a 01                	push   $0x1
  73:	e8 08 04 00 00       	call   480 <printf>
    exit();
  78:	e8 46 02 00 00       	call   2c3 <exit>
  7d:	66 90                	xchg   %ax,%ax
  7f:	90                   	nop

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  80:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  81:	31 c0                	xor    %eax,%eax
{
  83:	89 e5                	mov    %esp,%ebp
  85:	53                   	push   %ebx
  86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  90:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  94:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  97:	83 c0 01             	add    $0x1,%eax
  9a:	84 d2                	test   %dl,%dl
  9c:	75 f2                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a1:	89 c8                	mov    %ecx,%eax
  a3:	c9                   	leave
  a4:	c3                   	ret
  a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ac:	00 
  ad:	8d 76 00             	lea    0x0(%esi),%esi

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 55 08             	mov    0x8(%ebp),%edx
  b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ba:	0f b6 02             	movzbl (%edx),%eax
  bd:	84 c0                	test   %al,%al
  bf:	75 17                	jne    d8 <strcmp+0x28>
  c1:	eb 3a                	jmp    fd <strcmp+0x4d>
  c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  cc:	83 c2 01             	add    $0x1,%edx
  cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  d2:	84 c0                	test   %al,%al
  d4:	74 1a                	je     f0 <strcmp+0x40>
  d6:	89 d9                	mov    %ebx,%ecx
  d8:	0f b6 19             	movzbl (%ecx),%ebx
  db:	38 c3                	cmp    %al,%bl
  dd:	74 e9                	je     c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  df:	29 d8                	sub    %ebx,%eax
}
  e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  e4:	c9                   	leave
  e5:	c3                   	ret
  e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ed:	00 
  ee:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
  f0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  f4:	31 c0                	xor    %eax,%eax
  f6:	29 d8                	sub    %ebx,%eax
}
  f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  fb:	c9                   	leave
  fc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  fd:	0f b6 19             	movzbl (%ecx),%ebx
 100:	31 c0                	xor    %eax,%eax
 102:	eb db                	jmp    df <strcmp+0x2f>
 104:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 10b:	00 
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000110 <strlen>:

uint
strlen(const char *s)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 116:	80 3a 00             	cmpb   $0x0,(%edx)
 119:	74 15                	je     130 <strlen+0x20>
 11b:	31 c0                	xor    %eax,%eax
 11d:	8d 76 00             	lea    0x0(%esi),%esi
 120:	83 c0 01             	add    $0x1,%eax
 123:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 127:	89 c1                	mov    %eax,%ecx
 129:	75 f5                	jne    120 <strlen+0x10>
    ;
  return n;
}
 12b:	89 c8                	mov    %ecx,%eax
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret
 12f:	90                   	nop
  for(n = 0; s[n]; n++)
 130:	31 c9                	xor    %ecx,%ecx
}
 132:	5d                   	pop    %ebp
 133:	89 c8                	mov    %ecx,%eax
 135:	c3                   	ret
 136:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 13d:	00 
 13e:	66 90                	xchg   %ax,%ax

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 147:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 d7                	mov    %edx,%edi
 14f:	fc                   	cld
 150:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 152:	8b 7d fc             	mov    -0x4(%ebp),%edi
 155:	89 d0                	mov    %edx,%eax
 157:	c9                   	leave
 158:	c3                   	ret
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 16a:	0f b6 10             	movzbl (%eax),%edx
 16d:	84 d2                	test   %dl,%dl
 16f:	75 12                	jne    183 <strchr+0x23>
 171:	eb 1d                	jmp    190 <strchr+0x30>
 173:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 178:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 17c:	83 c0 01             	add    $0x1,%eax
 17f:	84 d2                	test   %dl,%dl
 181:	74 0d                	je     190 <strchr+0x30>
    if(*s == c)
 183:	38 d1                	cmp    %dl,%cl
 185:	75 f1                	jne    178 <strchr+0x18>
      return (char*)s;
  return 0;
}
 187:	5d                   	pop    %ebp
 188:	c3                   	ret
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 190:	31 c0                	xor    %eax,%eax
}
 192:	5d                   	pop    %ebp
 193:	c3                   	ret
 194:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 19b:	00 
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1a5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 1a8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1a9:	31 db                	xor    %ebx,%ebx
{
 1ab:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1ae:	eb 27                	jmp    1d7 <gets+0x37>
    cc = read(0, &c, 1);
 1b0:	83 ec 04             	sub    $0x4,%esp
 1b3:	6a 01                	push   $0x1
 1b5:	56                   	push   %esi
 1b6:	6a 00                	push   $0x0
 1b8:	e8 1e 01 00 00       	call   2db <read>
    if(cc < 1)
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	85 c0                	test   %eax,%eax
 1c2:	7e 1d                	jle    1e1 <gets+0x41>
      break;
    buf[i++] = c;
 1c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c8:	8b 55 08             	mov    0x8(%ebp),%edx
 1cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1cf:	3c 0a                	cmp    $0xa,%al
 1d1:	74 10                	je     1e3 <gets+0x43>
 1d3:	3c 0d                	cmp    $0xd,%al
 1d5:	74 0c                	je     1e3 <gets+0x43>
  for(i=0; i+1 < max; ){
 1d7:	89 df                	mov    %ebx,%edi
 1d9:	83 c3 01             	add    $0x1,%ebx
 1dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1df:	7c cf                	jl     1b0 <gets+0x10>
 1e1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ed:	5b                   	pop    %ebx
 1ee:	5e                   	pop    %esi
 1ef:	5f                   	pop    %edi
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret
 1f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1f9:	00 
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	6a 00                	push   $0x0
 20a:	ff 75 08             	push   0x8(%ebp)
 20d:	e8 f1 00 00 00       	call   303 <open>
  if(fd < 0)
 212:	83 c4 10             	add    $0x10,%esp
 215:	85 c0                	test   %eax,%eax
 217:	78 27                	js     240 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	ff 75 0c             	push   0xc(%ebp)
 21f:	89 c3                	mov    %eax,%ebx
 221:	50                   	push   %eax
 222:	e8 f4 00 00 00       	call   31b <fstat>
  close(fd);
 227:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 22a:	89 c6                	mov    %eax,%esi
  close(fd);
 22c:	e8 ba 00 00 00       	call   2eb <close>
  return r;
 231:	83 c4 10             	add    $0x10,%esp
}
 234:	8d 65 f8             	lea    -0x8(%ebp),%esp
 237:	89 f0                	mov    %esi,%eax
 239:	5b                   	pop    %ebx
 23a:	5e                   	pop    %esi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret
 23d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 240:	be ff ff ff ff       	mov    $0xffffffff,%esi
 245:	eb ed                	jmp    234 <stat+0x34>
 247:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 24e:	00 
 24f:	90                   	nop

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	0f be 02             	movsbl (%edx),%eax
 25a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 25d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 260:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 265:	77 1e                	ja     285 <atoi+0x35>
 267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 26e:	00 
 26f:	90                   	nop
    n = n*10 + *s++ - '0';
 270:	83 c2 01             	add    $0x1,%edx
 273:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 276:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 27a:	0f be 02             	movsbl (%edx),%eax
 27d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	76 eb                	jbe    270 <atoi+0x20>
  return n;
}
 285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 288:	89 c8                	mov    %ecx,%eax
 28a:	c9                   	leave
 28b:	c3                   	ret
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	8b 45 10             	mov    0x10(%ebp),%eax
 297:	8b 55 08             	mov    0x8(%ebp),%edx
 29a:	56                   	push   %esi
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7e 13                	jle    2b5 <memmove+0x25>
 2a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2a4:	89 d7                	mov    %edx,%edi
 2a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ad:	00 
 2ae:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2b1:	39 f8                	cmp    %edi,%eax
 2b3:	75 fb                	jne    2b0 <memmove+0x20>
  return vdst;
}
 2b5:	5e                   	pop    %esi
 2b6:	89 d0                	mov    %edx,%eax
 2b8:	5f                   	pop    %edi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret

000002bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bb:	b8 01 00 00 00       	mov    $0x1,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <exit>:
SYSCALL(exit)
 2c3:	b8 02 00 00 00       	mov    $0x2,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <wait>:
SYSCALL(wait)
 2cb:	b8 03 00 00 00       	mov    $0x3,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <pipe>:
SYSCALL(pipe)
 2d3:	b8 04 00 00 00       	mov    $0x4,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <read>:
SYSCALL(read)
 2db:	b8 05 00 00 00       	mov    $0x5,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <write>:
SYSCALL(write)
 2e3:	b8 10 00 00 00       	mov    $0x10,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <close>:
SYSCALL(close)
 2eb:	b8 15 00 00 00       	mov    $0x15,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <kill>:
SYSCALL(kill)
 2f3:	b8 06 00 00 00       	mov    $0x6,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <exec>:
SYSCALL(exec)
 2fb:	b8 07 00 00 00       	mov    $0x7,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <open>:
SYSCALL(open)
 303:	b8 0f 00 00 00       	mov    $0xf,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <mknod>:
SYSCALL(mknod)
 30b:	b8 11 00 00 00       	mov    $0x11,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <unlink>:
SYSCALL(unlink)
 313:	b8 12 00 00 00       	mov    $0x12,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <fstat>:
SYSCALL(fstat)
 31b:	b8 08 00 00 00       	mov    $0x8,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <link>:
SYSCALL(link)
 323:	b8 13 00 00 00       	mov    $0x13,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <mkdir>:
SYSCALL(mkdir)
 32b:	b8 14 00 00 00       	mov    $0x14,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <chdir>:
SYSCALL(chdir)
 333:	b8 09 00 00 00       	mov    $0x9,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <dup>:
SYSCALL(dup)
 33b:	b8 0a 00 00 00       	mov    $0xa,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <getpid>:
SYSCALL(getpid)
 343:	b8 0b 00 00 00       	mov    $0xb,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <sbrk>:
SYSCALL(sbrk)
 34b:	b8 0c 00 00 00       	mov    $0xc,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <sleep>:
SYSCALL(sleep)
 353:	b8 0d 00 00 00       	mov    $0xd,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <uptime>:
SYSCALL(uptime)
 35b:	b8 0e 00 00 00       	mov    $0xe,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <get_log>:
SYSCALL(get_log)
 363:	b8 19 00 00 00       	mov    $0x19,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <diff>:
SYSCALL(diff)
 36b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <set_sleep>:
SYSCALL(set_sleep)
 373:	b8 1b 00 00 00       	mov    $0x1b,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <getcmostime>:
SYSCALL(getcmostime)
 37b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <next_palindrome>:
SYSCALL(next_palindrome)
 383:	b8 1d 00 00 00       	mov    $0x1d,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <rt_fork>:
SYSCALL(rt_fork)
 38b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <set_class>:
SYSCALL(set_class)
 393:	b8 1f 00 00 00       	mov    $0x1f,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <ps>:
SYSCALL(ps)
 39b:	b8 20 00 00 00       	mov    $0x20,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <open_shared_mem>:
SYSCALL(open_shared_mem)
 3a3:	b8 25 00 00 00       	mov    $0x25,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <close_shared_mem>:
SYSCALL(close_shared_mem)
 3ab:	b8 26 00 00 00       	mov    $0x26,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <monitor_init>:
SYSCALL(monitor_init)
 3b3:	b8 27 00 00 00       	mov    $0x27,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret

000003bb <monitor_increase_all>:
SYSCALL(monitor_increase_all)
 3bb:	b8 28 00 00 00       	mov    $0x28,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <monitor_read>:
SYSCALL(monitor_read)
 3c3:	b8 29 00 00 00       	mov    $0x29,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret

000003cb <monitor_close>:
 3cb:	b8 2a 00 00 00       	mov    $0x2a,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret
 3d3:	66 90                	xchg   %ax,%ax
 3d5:	66 90                	xchg   %ax,%ax
 3d7:	66 90                	xchg   %ax,%ax
 3d9:	66 90                	xchg   %ax,%ax
 3db:	66 90                	xchg   %ax,%ax
 3dd:	66 90                	xchg   %ax,%ax
 3df:	90                   	nop

000003e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3e8:	89 d1                	mov    %edx,%ecx
{
 3ea:	83 ec 3c             	sub    $0x3c,%esp
 3ed:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 3f0:	85 d2                	test   %edx,%edx
 3f2:	0f 89 80 00 00 00    	jns    478 <printint+0x98>
 3f8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3fc:	74 7a                	je     478 <printint+0x98>
    x = -xx;
 3fe:	f7 d9                	neg    %ecx
    neg = 1;
 400:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 405:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 408:	31 f6                	xor    %esi,%esi
 40a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 410:	89 c8                	mov    %ecx,%eax
 412:	31 d2                	xor    %edx,%edx
 414:	89 f7                	mov    %esi,%edi
 416:	f7 f3                	div    %ebx
 418:	8d 76 01             	lea    0x1(%esi),%esi
 41b:	0f b6 92 24 08 00 00 	movzbl 0x824(%edx),%edx
 422:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 426:	89 ca                	mov    %ecx,%edx
 428:	89 c1                	mov    %eax,%ecx
 42a:	39 da                	cmp    %ebx,%edx
 42c:	73 e2                	jae    410 <printint+0x30>
  if(neg)
 42e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 431:	85 c0                	test   %eax,%eax
 433:	74 07                	je     43c <printint+0x5c>
    buf[i++] = '-';
 435:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 43a:	89 f7                	mov    %esi,%edi
 43c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 43f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 442:	01 df                	add    %ebx,%edi
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 448:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 44b:	83 ec 04             	sub    $0x4,%esp
 44e:	88 45 d7             	mov    %al,-0x29(%ebp)
 451:	8d 45 d7             	lea    -0x29(%ebp),%eax
 454:	6a 01                	push   $0x1
 456:	50                   	push   %eax
 457:	56                   	push   %esi
 458:	e8 86 fe ff ff       	call   2e3 <write>
  while(--i >= 0)
 45d:	89 f8                	mov    %edi,%eax
 45f:	83 c4 10             	add    $0x10,%esp
 462:	83 ef 01             	sub    $0x1,%edi
 465:	39 c3                	cmp    %eax,%ebx
 467:	75 df                	jne    448 <printint+0x68>
}
 469:	8d 65 f4             	lea    -0xc(%ebp),%esp
 46c:	5b                   	pop    %ebx
 46d:	5e                   	pop    %esi
 46e:	5f                   	pop    %edi
 46f:	5d                   	pop    %ebp
 470:	c3                   	ret
 471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 478:	31 c0                	xor    %eax,%eax
 47a:	eb 89                	jmp    405 <printint+0x25>
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000480 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
 486:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 489:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 48c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 48f:	0f b6 1e             	movzbl (%esi),%ebx
 492:	83 c6 01             	add    $0x1,%esi
 495:	84 db                	test   %bl,%bl
 497:	74 67                	je     500 <printf+0x80>
 499:	8d 4d 10             	lea    0x10(%ebp),%ecx
 49c:	31 d2                	xor    %edx,%edx
 49e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 4a1:	eb 34                	jmp    4d7 <printf+0x57>
 4a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 4a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4ab:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 4b0:	83 f8 25             	cmp    $0x25,%eax
 4b3:	74 18                	je     4cd <printf+0x4d>
  write(fd, &c, 1);
 4b5:	83 ec 04             	sub    $0x4,%esp
 4b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4bb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4be:	6a 01                	push   $0x1
 4c0:	50                   	push   %eax
 4c1:	57                   	push   %edi
 4c2:	e8 1c fe ff ff       	call   2e3 <write>
 4c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 4ca:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4cd:	0f b6 1e             	movzbl (%esi),%ebx
 4d0:	83 c6 01             	add    $0x1,%esi
 4d3:	84 db                	test   %bl,%bl
 4d5:	74 29                	je     500 <printf+0x80>
    c = fmt[i] & 0xff;
 4d7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4da:	85 d2                	test   %edx,%edx
 4dc:	74 ca                	je     4a8 <printf+0x28>
      }
    } else if(state == '%'){
 4de:	83 fa 25             	cmp    $0x25,%edx
 4e1:	75 ea                	jne    4cd <printf+0x4d>
      if(c == 'd'){
 4e3:	83 f8 25             	cmp    $0x25,%eax
 4e6:	0f 84 04 01 00 00    	je     5f0 <printf+0x170>
 4ec:	83 e8 63             	sub    $0x63,%eax
 4ef:	83 f8 15             	cmp    $0x15,%eax
 4f2:	77 1c                	ja     510 <printf+0x90>
 4f4:	ff 24 85 cc 07 00 00 	jmp    *0x7cc(,%eax,4)
 4fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 500:	8d 65 f4             	lea    -0xc(%ebp),%esp
 503:	5b                   	pop    %ebx
 504:	5e                   	pop    %esi
 505:	5f                   	pop    %edi
 506:	5d                   	pop    %ebp
 507:	c3                   	ret
 508:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 50f:	00 
  write(fd, &c, 1);
 510:	83 ec 04             	sub    $0x4,%esp
 513:	8d 55 e7             	lea    -0x19(%ebp),%edx
 516:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 51a:	6a 01                	push   $0x1
 51c:	52                   	push   %edx
 51d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 520:	57                   	push   %edi
 521:	e8 bd fd ff ff       	call   2e3 <write>
 526:	83 c4 0c             	add    $0xc,%esp
 529:	88 5d e7             	mov    %bl,-0x19(%ebp)
 52c:	6a 01                	push   $0x1
 52e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 531:	52                   	push   %edx
 532:	57                   	push   %edi
 533:	e8 ab fd ff ff       	call   2e3 <write>
        putc(fd, c);
 538:	83 c4 10             	add    $0x10,%esp
      state = 0;
 53b:	31 d2                	xor    %edx,%edx
 53d:	eb 8e                	jmp    4cd <printf+0x4d>
 53f:	90                   	nop
        printint(fd, *ap, 16, 0);
 540:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 543:	83 ec 0c             	sub    $0xc,%esp
 546:	b9 10 00 00 00       	mov    $0x10,%ecx
 54b:	8b 13                	mov    (%ebx),%edx
 54d:	6a 00                	push   $0x0
 54f:	89 f8                	mov    %edi,%eax
        ap++;
 551:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 554:	e8 87 fe ff ff       	call   3e0 <printint>
        ap++;
 559:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 55c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 55f:	31 d2                	xor    %edx,%edx
 561:	e9 67 ff ff ff       	jmp    4cd <printf+0x4d>
        s = (char*)*ap;
 566:	8b 45 d0             	mov    -0x30(%ebp),%eax
 569:	8b 18                	mov    (%eax),%ebx
        ap++;
 56b:	83 c0 04             	add    $0x4,%eax
 56e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 571:	85 db                	test   %ebx,%ebx
 573:	0f 84 87 00 00 00    	je     600 <printf+0x180>
        while(*s != 0){
 579:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 57c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 57e:	84 c0                	test   %al,%al
 580:	0f 84 47 ff ff ff    	je     4cd <printf+0x4d>
 586:	8d 55 e7             	lea    -0x19(%ebp),%edx
 589:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 58c:	89 de                	mov    %ebx,%esi
 58e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 590:	83 ec 04             	sub    $0x4,%esp
 593:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 596:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 599:	6a 01                	push   $0x1
 59b:	53                   	push   %ebx
 59c:	57                   	push   %edi
 59d:	e8 41 fd ff ff       	call   2e3 <write>
        while(*s != 0){
 5a2:	0f b6 06             	movzbl (%esi),%eax
 5a5:	83 c4 10             	add    $0x10,%esp
 5a8:	84 c0                	test   %al,%al
 5aa:	75 e4                	jne    590 <printf+0x110>
      state = 0;
 5ac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 5af:	31 d2                	xor    %edx,%edx
 5b1:	e9 17 ff ff ff       	jmp    4cd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 5b6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5b9:	83 ec 0c             	sub    $0xc,%esp
 5bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5c1:	8b 13                	mov    (%ebx),%edx
 5c3:	6a 01                	push   $0x1
 5c5:	eb 88                	jmp    54f <printf+0xcf>
        putc(fd, *ap);
 5c7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5ca:	83 ec 04             	sub    $0x4,%esp
 5cd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 5d0:	8b 03                	mov    (%ebx),%eax
        ap++;
 5d2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 5d5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5d8:	6a 01                	push   $0x1
 5da:	52                   	push   %edx
 5db:	57                   	push   %edi
 5dc:	e8 02 fd ff ff       	call   2e3 <write>
        ap++;
 5e1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5e4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e7:	31 d2                	xor    %edx,%edx
 5e9:	e9 df fe ff ff       	jmp    4cd <printf+0x4d>
 5ee:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5f6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5f9:	6a 01                	push   $0x1
 5fb:	e9 31 ff ff ff       	jmp    531 <printf+0xb1>
 600:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 605:	bb a0 07 00 00       	mov    $0x7a0,%ebx
 60a:	e9 77 ff ff ff       	jmp    586 <printf+0x106>
 60f:	90                   	nop

00000610 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 610:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	a1 c4 0a 00 00       	mov    0xac4,%eax
{
 616:	89 e5                	mov    %esp,%ebp
 618:	57                   	push   %edi
 619:	56                   	push   %esi
 61a:	53                   	push   %ebx
 61b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 61e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 628:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62a:	39 c8                	cmp    %ecx,%eax
 62c:	73 32                	jae    660 <free+0x50>
 62e:	39 d1                	cmp    %edx,%ecx
 630:	72 04                	jb     636 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 632:	39 d0                	cmp    %edx,%eax
 634:	72 32                	jb     668 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 636:	8b 73 fc             	mov    -0x4(%ebx),%esi
 639:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 63c:	39 fa                	cmp    %edi,%edx
 63e:	74 30                	je     670 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 640:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 643:	8b 50 04             	mov    0x4(%eax),%edx
 646:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 649:	39 f1                	cmp    %esi,%ecx
 64b:	74 3a                	je     687 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 64d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 64f:	5b                   	pop    %ebx
  freep = p;
 650:	a3 c4 0a 00 00       	mov    %eax,0xac4
}
 655:	5e                   	pop    %esi
 656:	5f                   	pop    %edi
 657:	5d                   	pop    %ebp
 658:	c3                   	ret
 659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 660:	39 d0                	cmp    %edx,%eax
 662:	72 04                	jb     668 <free+0x58>
 664:	39 d1                	cmp    %edx,%ecx
 666:	72 ce                	jb     636 <free+0x26>
{
 668:	89 d0                	mov    %edx,%eax
 66a:	eb bc                	jmp    628 <free+0x18>
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 670:	03 72 04             	add    0x4(%edx),%esi
 673:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 676:	8b 10                	mov    (%eax),%edx
 678:	8b 12                	mov    (%edx),%edx
 67a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 67d:	8b 50 04             	mov    0x4(%eax),%edx
 680:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 683:	39 f1                	cmp    %esi,%ecx
 685:	75 c6                	jne    64d <free+0x3d>
    p->s.size += bp->s.size;
 687:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 68a:	a3 c4 0a 00 00       	mov    %eax,0xac4
    p->s.size += bp->s.size;
 68f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 692:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 695:	89 08                	mov    %ecx,(%eax)
}
 697:	5b                   	pop    %ebx
 698:	5e                   	pop    %esi
 699:	5f                   	pop    %edi
 69a:	5d                   	pop    %ebp
 69b:	c3                   	ret
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ac:	8b 15 c4 0a 00 00    	mov    0xac4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b2:	8d 78 07             	lea    0x7(%eax),%edi
 6b5:	c1 ef 03             	shr    $0x3,%edi
 6b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6bb:	85 d2                	test   %edx,%edx
 6bd:	0f 84 8d 00 00 00    	je     750 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6c5:	8b 48 04             	mov    0x4(%eax),%ecx
 6c8:	39 f9                	cmp    %edi,%ecx
 6ca:	73 64                	jae    730 <malloc+0x90>
  if(nu < 4096)
 6cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6d1:	39 df                	cmp    %ebx,%edi
 6d3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6d6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6dd:	eb 0a                	jmp    6e9 <malloc+0x49>
 6df:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6e2:	8b 48 04             	mov    0x4(%eax),%ecx
 6e5:	39 f9                	cmp    %edi,%ecx
 6e7:	73 47                	jae    730 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e9:	89 c2                	mov    %eax,%edx
 6eb:	3b 05 c4 0a 00 00    	cmp    0xac4,%eax
 6f1:	75 ed                	jne    6e0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 6f3:	83 ec 0c             	sub    $0xc,%esp
 6f6:	56                   	push   %esi
 6f7:	e8 4f fc ff ff       	call   34b <sbrk>
  if(p == (char*)-1)
 6fc:	83 c4 10             	add    $0x10,%esp
 6ff:	83 f8 ff             	cmp    $0xffffffff,%eax
 702:	74 1c                	je     720 <malloc+0x80>
  hp->s.size = nu;
 704:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 707:	83 ec 0c             	sub    $0xc,%esp
 70a:	83 c0 08             	add    $0x8,%eax
 70d:	50                   	push   %eax
 70e:	e8 fd fe ff ff       	call   610 <free>
  return freep;
 713:	8b 15 c4 0a 00 00    	mov    0xac4,%edx
      if((p = morecore(nunits)) == 0)
 719:	83 c4 10             	add    $0x10,%esp
 71c:	85 d2                	test   %edx,%edx
 71e:	75 c0                	jne    6e0 <malloc+0x40>
        return 0;
  }
}
 720:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 723:	31 c0                	xor    %eax,%eax
}
 725:	5b                   	pop    %ebx
 726:	5e                   	pop    %esi
 727:	5f                   	pop    %edi
 728:	5d                   	pop    %ebp
 729:	c3                   	ret
 72a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 730:	39 cf                	cmp    %ecx,%edi
 732:	74 4c                	je     780 <malloc+0xe0>
        p->s.size -= nunits;
 734:	29 f9                	sub    %edi,%ecx
 736:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 739:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 73c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 73f:	89 15 c4 0a 00 00    	mov    %edx,0xac4
}
 745:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 748:	83 c0 08             	add    $0x8,%eax
}
 74b:	5b                   	pop    %ebx
 74c:	5e                   	pop    %esi
 74d:	5f                   	pop    %edi
 74e:	5d                   	pop    %ebp
 74f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 750:	c7 05 c4 0a 00 00 c8 	movl   $0xac8,0xac4
 757:	0a 00 00 
    base.s.size = 0;
 75a:	b8 c8 0a 00 00       	mov    $0xac8,%eax
    base.s.ptr = freep = prevp = &base;
 75f:	c7 05 c8 0a 00 00 c8 	movl   $0xac8,0xac8
 766:	0a 00 00 
    base.s.size = 0;
 769:	c7 05 cc 0a 00 00 00 	movl   $0x0,0xacc
 770:	00 00 00 
    if(p->s.size >= nunits){
 773:	e9 54 ff ff ff       	jmp    6cc <malloc+0x2c>
 778:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 77f:	00 
        prevp->s.ptr = p->s.ptr;
 780:	8b 08                	mov    (%eax),%ecx
 782:	89 0a                	mov    %ecx,(%edx)
 784:	eb b9                	jmp    73f <malloc+0x9f>
