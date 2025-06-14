# Exiter

These programs are written in assembly using FASM (Flat Assembler) for Linux.  
The programs are successfully terminated by invoking exit system calls.

## Building

1. Clone the repository
2. Navigate to the project folder
3. To install FASM on Arch Linux, run the following commands:
    ```bash
    sudo pacman -Sy
    sudo pacman -S fasm
    ```
4. Compile the program using FASM:
    ```bash
    fasm exiter32.asm
    fasm exiter64.asm
    ```
5. And run:
    ```
    ./exiter32
    ./exiter64
    ```