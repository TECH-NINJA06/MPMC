section .data
    array db 5, 3, 8, 1, 2, 9, 4, 7, 6, 0
    size equ 10
    newline db 0xA

section .bss
    buffer resb 1

section .text
    global _start

_start:
    mov ecx, size
    dec ecx
    xor esi, esi

bubble_outer_loop:
    cmp esi, ecx
    jge print_sorted

    xor ebx, ebx

bubble_inner_loop:
    mov al, [array + ebx]
    mov dl, [array + ebx + 1]
    cmp al, dl
    jle no_swap

    mov [array + ebx], dl
    mov [array + ebx + 1], al

no_swap:
    inc ebx
    mov eax, size
    sub eax, esi
    dec eax
    cmp ebx, eax
    jl bubble_inner_loop

    inc esi
    jmp bubble_outer_loop

print_sorted:
    xor esi, esi

print_loop:
    cmp esi, size
    jge exit_program

    movzx eax, byte [array + esi]
    add eax, '0'
    mov [buffer], al

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    inc esi
    jmp print_loop

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 80h
