section .data
    prompt1 db 'Enter first input: ', 0
    prompt1_len equ $ - prompt1
    prompt2 db 'Enter second input: ', 0
    prompt2_len equ $ - prompt2
    msg1 db 'First input: ', 0
    msg1_len equ $ - msg1
    msg2 db 'Second sinput: ', 0
    msg2_len equ $ - msg2

section .bss
    input1 resb 100
    input2 resb 100

%macro write 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro read 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

section .text
    global _start

_start:
    write prompt1, prompt1_len
    read input1, 100

    write prompt2, prompt2_len
    read input2, 100

    write msg1, msg1_len
    write input1, 100
    write msg2, msg2_len
    write input2, 100

    mov eax, 1
    mov ebx, 0
    int 80h