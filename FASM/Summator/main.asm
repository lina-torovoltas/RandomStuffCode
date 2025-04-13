; This program only works on Linux!!!

format ELF64 executable
entry main
segment readable executable



main:
    mov rax, 0
    mov rdi, 0 
    mov rsi, input1
    mov rdx, 20
    syscall

    call atoi
    mov rbx, rax 

    mov rax, 0
    mov rdi, 0
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

    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, result + 20
    sub rdx, rcx
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
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
