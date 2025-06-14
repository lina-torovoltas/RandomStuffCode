; This program only works on Linux!!!

format ELF64 executable 3
entry start

start:
    mov rax, 60
    syscall