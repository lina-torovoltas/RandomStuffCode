format ELF64 executable 3
entry start

segment readable executable

start:
    mov rax, 39
    syscall

    mov rdi, rax
    mov rsi, 6 
    mov rax, 62
    syscall