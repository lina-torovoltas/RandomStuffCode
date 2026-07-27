format ELF64 executable 3
entry start

segment readable executable

start:
    mov rax, 37
    mov rdi, 1
    syscall

    mov rcx, 0xFFFFFFFFFF
    .loop:
        dec rcx
        jnz .loop

    mov rax, 60
    xor rdi, rdi
    syscall