section .data
    number1 resb 10
    number2 resb 10 
    resultAdd resb 10 
    resultSub resb 10
    resultMul resb 5
    quotient resb 10
    remainder resb 10      

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
    mov [resultAdd], eax

	mov eax, 4
    mov ebx, 1
    mov ecx, resultAdd
    mov edx, 10
    int 80h

    mov eax, [number1]
    sub eax, '0'
    mov ebx, [number2]
    sub ebx, '0'

    sub eax, ebx
    add eax, '0'
    mov [resultSub], eax

	mov eax, 4
    mov ebx, 1
    mov ecx, resultSub
    mov edx, 10
    int 80h

    mov eax, [number1]
    sub eax, '0'
    mov ebx, [number2]
    sub ebx, '0'

    mul ebx
    add eax, '0'
    mov [resultMul], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, resultMul
    mov edx, 10
    int 80h

    mov eax, [number1]
    sub eax, '0'
    mov ebx, [number2]
    sub ebx, '0'

    xor edx, edx
    div ebx
    add eax, '0'
    add edx, '0'
    mov [remainder], eax
    mov [quotient], edx

    mov eax, 4
    mov ebx, 1
    mov ecx, quotient
    mov edx, 10
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, remainder
    mov edx, 10
    int 80h

mov eax, 1
mov ebx, 0
int 80h
