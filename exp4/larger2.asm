section .bss
    num1 resb 4
    num2 resb 4

section .data
    prompt1 db "Enter first number: ", 0
    prompt2 db "Enter second number: ", 0
    larger db "The larger number is: ", 0
    newline db 10, 0

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, 21
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 4
    int 80h

    mov eax, [num1]
    sub eax, '0'
    mov [num1], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, 22
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 4
    int 80h

    mov eax, [num2]
    sub eax, '0'
    mov [num2], eax

    mov eax, [num1]
    mov ebx, [num2]
    cmp eax, ebx
    jg num1_larger
    jl num2_larger

num1_larger:
    mov eax, 4
    mov ebx, 1
    mov ecx, larger
    mov edx, 23
    int 80h

    mov eax, [num1]
    add eax, '0'
    mov [num1], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, num1
    mov edx, 1
    int 80h
    jmp done

num2_larger:
    mov eax, 4
    mov ebx, 1
    mov ecx, larger
    mov edx, 23
    int 80h

    mov eax, [num2]
    add eax, '0'
    mov [num2], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, num2
    mov edx, 1
    int 80h

done:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    mov eax, 1
    xor ebx, ebx
    int 80h