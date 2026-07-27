format ELF64 executable 3
entry start

segment readable executable

start:
    xor rdx, rdx
    xor rcx, rcx
    div rcx