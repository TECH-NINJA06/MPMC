section .data
    name resb 10        

section .text
    global _start
_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 10
    int 80h

	mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, 10
    int 80h

mov eax, 1
mov ebx, 0
int 80h
