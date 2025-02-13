%macro print 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro read_input 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 80h
    mov al, [%1]
    sub al, '0'
    mov [%1], al
%endmacro

section .data
    msg1 db "Enter first number: ", 0
    msg2 db "Enter second number: ", 0
    newline db 10, 0  
    resultAdd db "Sum: ", 0
    resultSub db "Difference: ", 0
    resultMul db "Product: ", 0
    resultQuo db "Quotient: ", 0
    resultRem db "Remainder: ", 0

section .bss
    number1 resb 1
    number2 resb 1
    output resb 1 

section .text
    global _start

_start:
    print msg1, 20
    read_input number1, 2

    print msg2, 21
    read_input number2, 2

    ; ---- Addition ----
    mov al, [number1]
    add al, [number2]
    add al, '0'   ; Convert to ASCII
    mov [output], al

    print resultAdd, 5
    print output, 1
    print newline, 1

    ; ---- Subtraction ----
    mov al, [number1]
    sub al, [number2]
    add al, '0'  
    mov [output], al

    print resultSub, 11
    print output, 1
    print newline, 1

    ; ---- Multiplication ----
    mov al, [number1]
    mov bl, [number2]
    mul bl
    add al, '0'   ; Convert to ASCII
    mov [output], al

    print resultMul, 9
    print output, 1
    print newline, 1

    ; ---- Division ----
    mov al, [number1]
    mov ah, 0
    mov bl, [number2]
    div bl    ; AL = quotient, AH = remainder

    add al, '0'   ; Convert quotient to ASCII
    mov [output], al

    print resultQuo, 10
    print output, 1
    print newline, 1

    ; ---- Remainder ----
    mov al, ah  ; Remainder is in AH
    add al, '0'   ; Convert remainder to ASCII
    mov [output], al

    print resultRem, 10
    print output, 1
    print newline, 1

    ; Exit program
    mov eax, 1
    mov ebx, 0
    int 80h
