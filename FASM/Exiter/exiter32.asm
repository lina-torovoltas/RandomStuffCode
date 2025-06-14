; This program only works on Linux!!!

format ELF executable 3
entry start

start:
    inc eax
    xor ebx, ebx
    int 0x80