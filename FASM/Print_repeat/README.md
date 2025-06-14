# Print macro

This program is written in assembly using FASM (Flat Assembler) for Linux.  
The program outputs a message to the console a specified number of times using the macro.

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
    fasm main.asm print_repeat
    ```
5. And run:
    ```
    ./print_repeat
    ```