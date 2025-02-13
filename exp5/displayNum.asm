section .data
    num db '2', 0

section .bss

%macro write 3
    mov eax, 4
    mov ebx, %1
    mov ecx, %2
    mov edx, %3
    int 80h
%endmacro

section .text
    global _start
_start:
    write 1, num, 5

    mov eax, 1
    xor ebx, ebx
    int 80h
