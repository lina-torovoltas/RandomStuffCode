format ELF64 executable 3
entry start



segment readable executable

start:
    lea rbx, [p]
    lea rcx, [n]

    mov byte [rbx], 1000b
    mov byte [rcx], 0110b
    
    mov byte [rbx+1], 1000b
    mov byte [rcx+1], 0110b

    mov rax, 60
    xor rdi, rdi
    syscall



segment readable writable

p dq 0
n dq 0
