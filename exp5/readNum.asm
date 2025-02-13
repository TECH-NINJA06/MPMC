section .bss
    num resb 10

section .data
    prompt1 db 'Enter the number: ', 0
    prompt1_len equ $ - prompt1
    prompt2 db 'The number is: ', 0
    prompt2_len equ $ - prompt2

section .text
    global _start

%macro read 0
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 10
    int 80h
%endmacro

%macro display 0
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 10
    int 80h
%endmacro

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, prompt1_len
    int 80h

    read

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, prompt2_len
    int 80h
    
    display

    mov eax, 1
    mov ebx, 0
    int 80h
