format ELF64 executable 3
entry start

segment readable executable

start:
    mov rax, 22
    mov rdi, fds
    syscall

    mov rax, 3
    mov edi, [fds]
    syscall

    mov rax, 1
    mov edi, [fds+4]
    mov rsi, msg
    mov rdx, 3
    syscall

segment readable writeable

fds dd 0, 0
msg db 'hi', 0