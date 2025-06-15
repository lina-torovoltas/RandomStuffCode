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

macro repeat_print times, str, str_len {
    push rax,rbx,rdi,rsi,rdx

    local .loop

    mov rbx, times
  .loop:
    clr rax
    inc rax
    clr rdi
    inc rdi
    mov rsi, str
    mov rdx, str_len
    syscall

    dec rbx
    jnz .loop

    pop rdx, rsi, rdi, rbx, rax
}


start:
    repeat_print 2, msg1, msg1_len
    repeat_print 3, msg2, msg2_len

    exit



segment readable writeable

msg1 db 'This message will be repeated two times', 10
msg1_len = $ - msg1

msg2 db 'This message will be repeated three times', 10
msg2_len = $ - msg2