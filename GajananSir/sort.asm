section .data
    array db 1, 3, 2, 5, 4, 6, 7, 8, 9, 0 
    size db 10                                                                        
    newline db 0xA

section .bss
    buffer resb 3

section .text
    global _start

_start:
    movzx ecx, byte [size]
    xor esi, esi

sort_array:
    cmp esi, ecx
    jge done_sorting

    mov edi, esi
    mov ebx, esi
    inc ebx

inner_loop:
    cmp ebx, ecx
    jge swap_elements

    mov al, [array + edi]
    mov dl, [array + ebx]
    cmp al, dl
    jle no_swap

    mov edi, ebx

no_swap:
    inc ebx
    jmp inner_loop

swap_elements:
    cmp esi, edi
    je no_swap_needed

    mov al, [array + esi]
    mov dl, [array + edi]
    mov [array + esi], dl
    mov [array + edi], al

no_swap_needed:
    inc esi
    jmp sort_array

done_sorting:
    movzx ecx, byte [size]
    xor esi, esi

print_array:
    cmp esi, ecx
    jge exit_program

    movzx eax, byte [array + esi]
    call print_number

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    inc esi
    jmp print_array

print_number:
    mov ebx, 10
    mov edi, buffer + 2
    mov byte [edi], 0

convert_loop:
    dec edi
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    test eax, eax
    jnz convert_loop

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, 3
    sub edx, edi
    add edx, buffer
    sub edx, buffer
    int 0x80

    ret

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
