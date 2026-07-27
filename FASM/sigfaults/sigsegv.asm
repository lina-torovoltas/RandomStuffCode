format ELF64 executable 3
entry start

segment readable executable

start:
    xor rax, rax
    mov [rax], rax