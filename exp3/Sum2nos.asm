section .data
    number1 resb 10
    number2 resb 10 
    result resb 10       

section .text
    global _start
_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, number1
    mov edx, 10
    int 80h
    mov eax, 3
    mov ebx, 0
    mov ecx, number2
    mov edx, 10
    int 80h

    mov eax, [number1]
    sub eax, '0'
    mov ebx, [number2]
    sub ebx, '0'

    add eax, ebx
    add eax, '0'
    mov [result], eax

	mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 10
    int 80h

mov eax, 1
mov ebx, 0
int 80h
