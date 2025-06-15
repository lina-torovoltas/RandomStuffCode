; This program only works on Linux!!!

format ELF64 executable 3
entry start



segment readable executable

macro clr reg { xor reg,reg }

macro exit {
    mov rax, 60
    clr rdi
    syscall
}

start:
    clr rax
    clr rdi
    mov rsi, input1
    mov rdx, 20
    syscall

    call atoi
    mov rbx, rax 

    clr rax
    mov rsi, input2
    mov rdx, 20
    syscall

    call atoi
    add rax, rbx

    mov rcx, result + 20
    mov rbx, 10

.convert:
    clr rdx
    div rbx
    dec rcx
    add dl, '0'
    mov [rcx], dl
    test rax, rax
    jnz .convert

    clr rax
    inc rax
    clr rdi
    inc rdi
    mov rsi, rcx
    mov rdx, result + 20
    sub rdx, rcx
    syscall

    clr rax
    inc rax
    mov rsi, newline
    clr rdx
    inc rdx
    syscall

    exit

atoi:
    clr rax
    clr rcx

.next_char:
    mov cl, [rsi]
    cmp cl, 10  
    je .done
    cmp cl, 13 
    je .done
    cmp cl, 0
    je .done
    sub cl, '0'
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp .next_char

.done:
    ret



segment readable writeable

input1  rb 20
input2  rb 20
result  rb 20
newline db 10