format ELF64 executable 3
entry start


segment readable executable

start:
    mov rax, 0          
    mov rdi, 0          
    mov rsi, buffer     
    mov rdx, buf_len   
    syscall

    mov rdx, rax
    mov rax, 1          
    mov rdi, 1          
    mov rsi, buffer
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

segment readable writeable

buffer rb 256        
buf_len = 256