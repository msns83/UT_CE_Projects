struct stat;
struct rtcdate;

// system calls
int fork(void);
int exit(void) __attribute__((noreturn));
int wait(void);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);

// LAB 2:
int make_user(int user_id, char* password);
int login_user(int user_id, char* password);
int logout_user(void);
int get_log(void);
int diff(const char* file1, const char* file2);
int set_sleep(int);
int getcmostime(struct rtcdate*);
int next_palindrome(int num);

// LAB 3:
int rt_fork(int);
int set_class(int pid, int cls);
int ps(void);

// Lab 4:
int barber_sleep(void);
int customer_arrive(void);  
int cut_hair(void);
int customer_wait_haircut(void);

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void printf(int, const char*, ...);
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);
int init_rw_lock(void);
int get_rw_pattern(int pattern);
