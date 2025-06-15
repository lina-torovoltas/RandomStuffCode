; This program only works on Linux!!!

format ELF64 executable 3
entry start



segment readable executable

macro clr reg { xor reg,reg }

macro push [arg] { push arg }

macro pop [arg] { pop arg }

macro exit {
    mov rax, 60
    clr rdi
    syscall
}

macro print str, str_len {
    push rax, rdi, rsi, rdx

    clr rax
    inc rax
    clr rdi
    inc rdi
    mov rsi, str
    mov rdx, str_len
    syscall

    pop rdx, rsi, rdi, rax
}


start:
    print msg, msg_len

    exit



segment readable writable 

msg  db 'Yeeaahh, this is my first program on FASM:3', 10, 0
msg_len = $ - msg