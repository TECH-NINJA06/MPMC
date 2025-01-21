section .data
    string1 db 'Hello ', 0
    string2 db 'World!', 0
    string1Len equ $-string1
    string2Len equ $-string2

section .text
	global _start
_start:
	mov eax, 4
	mov ebx, 1
    mov ecx, string1
    mov edx, string1Len
    int 80h
    mov ecx, string2
    mov edx, string2Len
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h
