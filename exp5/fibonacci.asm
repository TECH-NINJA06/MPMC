section .data
    fmt db "%d ", 0

section .bss
    num1 resd 1
    num2 resd 1
    num3 resd 1
    counter resd 1

section .text
    global _start

%macro PRINT_NUM 1
    mov eax, %1
    call itoa
    mov eax, 4          ; sys_write
    mov ebx, 1          ; file descriptor (stdout)
    mov ecx, esp        ; buffer to write (top of the stack)
    mov edx, edi        ; number of bytes
    int 0x80
    add esp, edi        ; clean up the stack
%endmacro

itoa:
    push ebp
    mov ebp, esp
    sub esp, 12         ; reserve space on the stack
    mov edi, 0          ; character count
    mov ebx, 10
    .convert:
        xor edx, edx
        div ebx
        add dl, '0'
        push edx
        inc edi
        test eax, eax
        jnz .convert
    mov eax, edi
    leave
    ret

_start:
    mov dword [num1], 0
    mov dword [num2], 1
    mov dword [counter], 9

    PRINT_NUM [num1]
    PRINT_NUM [num2]

    .loop:
        mov eax, [num1]
        add eax, [num2]
        mov [num3], eax

        PRINT_NUM [num3]

        mov eax, [num2]
        mov [num1], eax

        mov eax, [num3]
        mov [num2], eax

        sub dword [counter], 1
        cmp dword [counter], 0
        jne .loop

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80