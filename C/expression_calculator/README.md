# Expression Calculator

This is a C program that evaluates mathematical expressions containing numbers, operators, and parentheses.  
It supports basic operations such as addition, subtraction, multiplication, division, exponentiation, and parentheses for grouping expressions.

## Features

- Accepts and calculates mathematical expressions.
- Validates the expression for correctness before evaluation.
- Handles parentheses for controlling operation precedence.
- Outputs the result formatted to four decimal places.

## Supported Operators

- Addition: `+`
- Subtraction: `-`
- Multiplication: `*`
- Division: `/`
- Exponentiation: `^`

## Building

1. Clone the repository.
2. Navigate to the project folder.
3. To install GCC on Debian/Ubuntu, run the following commands:
    ```bash
    $ sudo apt update
    $ sudo apt install gcc
    ```
4. Compile the Program using GCC:
    ```bash
    $ gcc -o calculator expression_calculator.c -lm
    ```
5. And run:
    ```bash
    $ ./calculator
    ```
