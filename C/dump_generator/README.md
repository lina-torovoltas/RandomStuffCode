# Random Dump Generator

This is a C program that generates a random memory-like dump in either hexadecimal or octal format and saves it to a file named dump.txt.

## Features

- Generates a dump of random values in either hexadecimal (-h) or octal (-o) format.
- Allows custom number of lines and number of bytes (or values) per line.

## Usage

  ```bash
  $ ./dumpgen -h
  Enter the number of lines: 10
  Enter the number of rows per line: 5
  File dump.txt has been successfully generated in hexadecimal format.
  $ cat dump.txt
  00000000 3A 1F A7 09 4C
  00000001 00 FF 23 88 7E
  ...
  ```

or

  ```bash
  $ ./dumpgen -o
  Enter the number of lines: 10
  Enter the number of rows per line: 5
  File dump.txt has been successfully generated in octal format.
  $ cat dump.txt
  0000 12 33 07 55 60
  0001 03 11 02 71 17
  ...
  ```

# Notes

- For hexadecimal (-h): max lines = 4294967296
- For octal (-o): max lines = 4096

## Building

1. Clone the repository
2. Navigate to the project folder
3. To install GCC on Debian/Ubuntu, run the following commands:
    ```bash
    sudo apt update
    sudo apt install gcc
    ```
4. Compile the Program using GCC:
    ```bash
    gcc -o dumpgen main.c
    ```
5. And run:
    ```bash
    ./dumpgen -h/-o
    ```
