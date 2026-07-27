format ELF64 executable 3
entry start

segment readable executable

start:
    mov rax, 2
    mov rdi, filename
    mov rsi, 0x242
    mov rdx, 0x1A4
    syscall
    mov r12, rax

    mov rax, 77
    mov rdi, r12
    mov rsi, 4096
    syscall

    mov rax, 9
    xor rdi, rdi
    mov rsi, 4096
    mov rdx, 3
    mov r10, 1
    mov r8, r12
    xor r9, r9
    syscall
    mov r13, rax

    mov rax, 77
    mov rdi, r12
    xor rsi, rsi
    syscall

    mov rax, [r13]

segment readable writeable

filename db '/tmp/sigbus_x', 0