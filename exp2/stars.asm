section .data
    stars TIMES 9 db '*'
    starLen equ $-stars

section .text
    global _start
_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, stars
    mov edx, starLen
    int 80h      

    mov eax, 1
    mov ebx, 0
    int 80h
