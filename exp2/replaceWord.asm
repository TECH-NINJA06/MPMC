section .data
    name db 'abc def  ,'
    namelen equ $-name

section .text
    global _start
    
_start:
    ; Print initial string
    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, namelen
    int 80h

    ; Replace "abc" with "xyz"
    mov dword [name], dword 'xyz '

    ; Print modified string
    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, namelen
    int 80h

    ; Exit call
    mov eax, 1
    mov ebx, 0
    int 80h
