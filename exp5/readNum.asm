section .bss
    num resb 10

section .text
    global _start

%macro read_num 0
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 10
    int 0x80
%endmacro

%macro display_num 0
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 10
    int 0x80
%endmacro

_start:
    read_num
    display_num

    mov eax, 1
    xor ebx, ebx
    int 0x80
