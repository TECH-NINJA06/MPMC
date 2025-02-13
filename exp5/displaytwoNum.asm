section .data
    msg1 db "First number: ", 0
    msg2 db "Second number: ", 0
    num1 db '5', 0
    num2 db '3', 0

section .bss

section .text
    global _start

%macro write 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

_start:
    write msg1, 14
    write num1, 1

    write msg2, 15
    write num2, 1

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
