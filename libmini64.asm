
    global signal_restorer:function
signal_restorer:
    mov rax, 0xf
    syscall

%macro gensys 2
    global sys_%2:function
sys_%2:
    push   r10
    mov    r10, rcx
    mov    rax, %1
    syscall
    pop    r10
    ret
%endmacro

; RDI, RSI, RDX, RCX, R8, R9

extern    errno

    section .data

    section .text

    gensys   0, read
    gensys   1, write
    gensys   2, open
    gensys   3, close
    gensys   9, mmap
    gensys  10, mprotect
    gensys  11, munmap
    gensys  13, sigaction
    gensys  14, sigprocmask
    gensys  22, pipe
    gensys  32, dup
    gensys  33, dup2
    gensys  34, pause
    gensys  35, nanosleep
    gensys  37, alarm
    gensys  57, fork
    gensys  60, exit
    gensys  79, getcwd
    gensys  80, chdir
    gensys  82, rename
    gensys  83, mkdir
    gensys  84, rmdir
    gensys  85, creat
    gensys  86, link
    gensys  88, unlink
    gensys  89, readlink
    gensys  90, chmod
    gensys  92, chown
    gensys  95, umask
    gensys  96, gettimeofday
    gensys 102, getuid
    gensys 104, getgid
    gensys 105, setuid
    gensys 106, setgid
    gensys 107, geteuid
    gensys 108, getegid
    gensys 127, sigpending

    global open:function
open:
    call   sys_open
    cmp    rax, 0
    jge    open_success     ; no error :)
open_error:
    neg    rax
%ifdef NASM
    mov    rdi, [rel errno wrt ..gotpc]
%else
    mov    rdi, [rel errno wrt ..gotpcrel]
%endif
    mov    [rdi], rax       ; errno = -rax
    mov    rax, -1
    jmp    open_quit
open_success:
%ifdef NASM
    mov    rdi, [rel errno wrt ..gotpc]
%else
    mov    rdi, [rel errno wrt ..gotpcrel]
%endif
    mov    QWORD [rdi], 0   ; errno = 0
open_quit:
    ret

    global sleep:function
sleep:
    sub    rsp, 32          ; allocate timespec * 2
    mov    [rsp], rdi       ; req.tv_sec
    mov    QWORD [rsp+8], 0 ; req.tv_nsec
    mov    rdi, rsp         ; rdi = req @ rsp
    lea    rsi, [rsp+16]    ; rsi = rem @ rsp+16
    call   sys_nanosleep
    cmp    rax, 0
    jge    sleep_quit       ; no error :)
sleep_error:
    neg    rax
    cmp    rax, 4           ; rax == EINTR?
    jne    sleep_failed
sleep_interrupted:
    lea    rsi, [rsp+16]
    mov    rax, [rsi]       ; return rem.tv_sec
    jmp    sleep_quit
sleep_failed:
    mov    rax, 0           ; return 0 on error
sleep_quit:
    add    rsp, 32
    ret

extern sigprocmask

; int setjmp(jmp_buf env); 
    global setjmp:function
setjmp:
    ; save current registers
    mov [rdi], rbx
    mov [rdi + 8], rsp
    mov [rdi + 0x10], rbp
    mov [rdi + 0x18], r12
    mov [rdi + 0x20], r13
    mov [rdi + 0x28], r14
    mov [rdi + 0x30], r15
    mov rax, [rsp]
    mov [rdi + 0x38], rax
    ; allocate space
    sub rsp, 0x10
    mov [rsp], rdi
    ; get current process signal mask
    mov rdi, 0
    mov rsi, 0
    lea rdx, [rsp + 8]
    call sigprocmask WRT ..plt
    ; save current process signal mask
    mov rdi, [rsp]
    mov rsi, [rsp + 8]
    mov [rdi + 0x40], rsi
    ; return
    mov rax, 0
    add rsp, 0x10
    ret

; void longjmp(jmp_buf env, int val);
    global longjmp:function
longjmp:
    ; restore registers
    mov rbx, [rdi]
    mov rsp, [rdi + 8]
    mov rbp, [rdi + 0x10]
    mov r12, [rdi + 0x18]
    mov r13, [rdi + 0x20]
    mov r14, [rdi + 0x28]
    mov r15, [rdi + 0x30]
    mov rax, [rdi + 0x38]
    mov [rsp], rax
    ; allocate space
    sub rsp, 0x8
    mov [rsp], rsi
    ; restore process signal mask
    mov rdx, 0
    lea rsi, [rdi + 0x40]
    mov rdi, 2 ; SIG_SETMASK
    call sigprocmask WRT ..plt
    ; return
    mov rax, [rsp]
    add rsp, 0x8
    ret
