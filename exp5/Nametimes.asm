section .bss
    input resb 100

section .data
    prompt db 'Enter your name: ', 0
    newline db 10, 0

section .text
    global _start

%macro PRINT_NAME 0
    mov eax, 4
    mov ebx, 1
    mov ecx, input
    mov edx, 100
    int 0x80
%endmacro

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 17
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 100
    int 0x80

    mov ecx, 7
print_loop:
    PRINT_NAME
    loop print_loop

    mov eax, 1
    xor ebx, ebx
    int 0x80
