section .data
    prompt db 'Enter n: '
    prompt_len equ $ - prompt
    msg db 'Series: '
    msg_len equ $ - msg
    space db ' '
    newline db 10

section .bss
    n resb 2
    num1 resb 2
    num2 resb 2
    result resb 2

section .text
    global _start

_start:
    push prompt
    push prompt_len
    call write
    
    push n
    push 2
    call read
    
    push msg
    push msg_len
    call write
    
    movzx ecx, byte [n]
    sub ecx, '0'
    push ecx
    call fibonacci
    
    push newline
    push 1
    call write
    
    mov eax, 1
    xor ebx, ebx
    int 80h

fibonacci:
    push ebp
    mov ebp, esp
    
    mov byte [num1], '0'
    mov byte [num2], '1'
    mov ecx, [ebp + 8]    ; get n from stack

fib_loop:
    push ecx
    
    push num1
    push 1
    call write
    
    push space
    push 1
    call write

    push num1
    push num2
    call add_nums

    mov al, [num2]
    mov [num1], al
    mov al, [result]
    mov [num2], al
    
    pop ecx
    dec ecx
    jnz fib_loop
    
    mov esp, ebp
    pop ebp
    ret 4

write:
    push ebp
    mov ebp, esp
    
    mov eax, 4
    mov ebx, 1
    mov ecx, [ebp + 12]   
    mov edx, [ebp + 8]    
    int 80h
    
    mov esp, ebp
    pop ebp
    ret 8

read:
    push ebp
    mov ebp, esp
    
    mov eax, 3
    mov ebx, 0
    mov ecx, [ebp + 12]   
    mov edx, [ebp + 8]    
    int 80h
    
    mov esp, ebp
    pop ebp
    ret 8

add_nums:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 12]   
    movzx eax, byte [eax]
    sub al, '0'
    
    mov ebx, [ebp + 8]   
    movzx ebx, byte [ebx]
    sub bl, '0'
    
    add eax, ebx
    add al, '0'
    mov [result], al
    
    mov esp, ebp
    pop ebp
    ret 8