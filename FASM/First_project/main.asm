; This program only works on Linux!!!

format ELF64 executable
entry main
segment readable executable



; The main function calls compute length to get the string's length, prints it using the write system call, and then ends the program
main:
    lea   rdi, [msg]
    call  compute_length
    mov   rdx, rax
    mov   rsi, rdi
    mov   rdi, 1
    mov   rax, 1
    syscall
    xor   rdi, rdi
    mov   rax, 60
    syscall


; The compute_length function calculates the length of a string
compute_length:
    push  rdi
    push  rcx
    xor   rcx, rcx
    mov   rbx, [rdi]


; A loop function that searches for the end of a string (null byte)
.loop:
    cmp   byte [rdi+rcx], 0
    je    .found_end
    inc   rcx
    jmp   .loop


; The found_end function returns the length of the string
.found_end:
    mov   rax, rcx
    pop   rcx
    pop   rdi
    ret



segment readable writable 

; The message that will be output to the console
msg  db 'Yeeaahh, this is my first program on FASM:3', 10, 0
