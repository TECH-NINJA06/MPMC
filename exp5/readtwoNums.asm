section .bss
    num1 resb 10
    num2 resb 10

section .data
    prompt1 db "Enter first number: ", 0
    prompt2 db "Enter second number: ", 0
    newline db 10, 0

section .text
    global _start

%macro display 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro read_input 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

_start:
    display prompt1, 17
    read_input num1, 10
    display prompt2, 18
    read_input num2, 10
    display num1, 10
    display newline, 1
    display num2, 10
    mov eax, 1
    xor ebx, ebx
    int 0x80
