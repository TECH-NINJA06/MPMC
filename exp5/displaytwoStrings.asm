section .data
    msg1 db "First string: ", 0
    msg2 db "Second string: ", 0
    str1 db "Hi", 0
    str2 db "World", 0

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
    write str1, 5

    write msg2, 15
    write str2, 5

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
