; This program only works on Linux!!!

format ELF64 executable 3
entry start



segment readable executable

start:
    inc rax
    inc rdi
    mov rsi, msg
    mov rdx, msg_len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall



segment readable writable 

msg  db 'Yeeaahh, this is my first program on FASM:3', 10, 0
msg_len = $ - msg