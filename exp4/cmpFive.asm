section .data
    prompt1 db "Enter the number: ", 0
    promLen equ $-prompt1
    greater db 'The number is greater than 5', 0
    g_len equ $-greater
    lesser db 'The number is less than 5', 0
    l_len equ $-lesser
    equal db 'The number is equal to 5', 0
    e_len equ $-equal

section .bss
    num resb 1

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, promLen
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 1
    int 80h

    sub byte [num], '0'

    mov al, [num]
    cmp al, 5
    je equal
    jl less
    jg greater

greater:
    mov eax, 4
    mov ebx, 1
    mov ecx, greater
    mov edx, g_len
    int 80h
    jmp exit

less:
    mov eax, 4
    mov ebx, 1
    mov ecx, lesser
    mov edx, l_len
    int 80h
    jmp exit

equal:
    mov eax, 4
    mov ebx, 1
    mov ecx, equal
    mov edx, e_len
    int 80h
    jmp exit

exit:
    mov eax, 1
    xor ebx, ebx
    int 80h
