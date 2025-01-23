section .data
    string1 db 'Hello ', 0
    string2 db 'World!', 0
    string1Len equ $-string1
    string2Len equ $-string2
    num1 equ 4
    num2 equ 1

section .text
	global _start
_start:
	mov eax, num1
	mov ebx, num2
    mov ecx, string1
    mov edx, string1Len
    int 80h
    mov ecx, string2
    mov edx, string2Len
    int 80h

    mov eax, num2
    mov ebx, 0
    int 80h
