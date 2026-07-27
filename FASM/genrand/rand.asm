format ELF64 executable 3
entry start

segment readable executable

start:

.retry:
    rdrand eax
    jnc .retry

    xor edx, edx
    mov ecx, 9000
    div ecx

    add edx, 1000

    mov eax, edx
    mov rdi, buffer + 3

.convert:
    xor edx, edx
    mov ecx, 10
    div ecx

    add dl, '0'
    mov [rdi], dl

    dec rdi
    test eax, eax
    jnz .convert

    mov byte [buffer + 4], 10

    mov eax, 1
    mov edi, 1
    mov rsi, buffer
    mov edx, 5
    syscall

    mov eax, 60
    xor edi, edi
    syscall


segment readable writeable

buffer rb 5