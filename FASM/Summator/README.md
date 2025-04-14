# My First FASM Program

This program adds 2 input numbers and outputs the result.

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
    fasm main.asm summator
    ```
5. And run:
    ```
    ./summator
    ```