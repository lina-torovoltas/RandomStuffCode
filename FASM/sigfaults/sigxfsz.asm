format ELF64 executable 3
entry start

segment readable executable

start:
    mov rax, 160
    mov rdi, 1
    mov rsi, rlim
    syscall

    mov rax, 2
    mov rdi, filename
    mov rsi, 0x242
    mov rdx, 0x1A4
    syscall
    mov r12, rax

    mov rax, 1
    mov rdi, r12
    mov rsi, buf
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, r12
    mov rsi, buf
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

segment readable writeable

filename db '/tmp/sigxfsz_x', 0
rlim dq 1, 1
buf rb 4096