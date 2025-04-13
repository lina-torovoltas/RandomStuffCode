# My First FASM Program

This is an example program written in assembly using FASM (Flat Assembler).  
The program calculates the length of a string and outputs it to the console.

## Building

1. Clone the repository
2. Navigate to the project folder
3. To install FASM on Debian/Ubuntu, run the following commands:
    ```bash
    sudo apt update
    sudo apt install fasm
    ```
4. Compile the Program using FASM:
    ```bash
    fasm main.asm hello_world
    ```
5. And run:
    ```
    ./hello_world
    ```