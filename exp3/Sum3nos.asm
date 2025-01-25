section .data
    num1 resb 10
    num2 resb 10
    num3 resb 10
    result db 0

section .text
    global _start

_start:

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 10
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 10
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num3
    mov edx, 10
    int 80h

    mov eax, [num1]
    sub eax, '0'
    mov ebx, [num2]
    sub ebx, '0'
    add eax, ebx
    mov ecx, [num3]
    sub ecx, '0'
    add eax, ecx
    add eax, '0'
    mov [result], al

    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
mov eax, 1
mov ebx, 0
int 80h