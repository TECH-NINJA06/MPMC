section .data
    num1 db 10
    num2 db 5
    result db 0

section .text
    global _start

%macro ADD 2
    mov al, [%1]
    add al, [%2]
    mov [%1], al
%endmacro

%macro SUB 2
    mov al, [%1]
    sub al, [%2]
    mov [%1], al
%endmacro

%macro MUL 2
    mov al, [%1]
    mov bl, [%2]
    mul bl
    mov [%1], al
%endmacro

%macro DIV 2
    mov al, [%1]
    mov bl, [%2]
    div bl
    mov [%1], al
%endmacro

_start:
    ; Addition
    ADD num1, num2
    mov [result], al

    ; Subtraction
    SUB num1, num2
    mov [result], al

    ; Multiplication
    MUL num1, num2
    mov [result], al

    ; Division
    DIV num1, num2
    mov [result], al

    ; Exit
    mov eax, 60
    xor edi, edi
    syscall