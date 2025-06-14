; This program only works on Linux!!!

format ELF64 executable 3
entry start



segment readable executable

start:
    xor rax, rax
    xor rdi, rdi
    mov rsi, input1
    mov rdx, 20
    syscall

    call atoi
    mov rbx, rax 

    xor rax, rax
    mov rsi, input2
    mov rdx, 20
    syscall

    call atoi
    add rax, rbx

    mov rcx, result + 20
    mov rbx, 10


.convert:
    xor rdx, rdx
    div rbx
    dec rcx
    add dl, '0'
    mov [rcx], dl
    test rax, rax
    jnz .convert

    xor rax, rax
    inc rax
    xor rdi, rdi
    inc rdi
    mov rsi, rcx
    mov rdx, result + 20
    sub rdx, rcx
    syscall

    xor rax, rax
    inc rax
    mov rsi, newline
    xor rdx, rdx
    inc rdx
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall


atoi:
    xor rax, rax
    xor rcx, rcx


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