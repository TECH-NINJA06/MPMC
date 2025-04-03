section .data
    prompt_msg db "Enter 5 integers separated by space: ", 0
    prompt_len equ $ - prompt_msg
    iter_msg db "Iteration ", 0
    iter_len equ $ - iter_msg
    colon_msg db ": ", 0
    colon_len equ $ - colon_msg
    space db " ", 0
    newline db 10, 0
    array times 5 dd 0
    array_size equ 5
    buffer times 100 db 0

section .bss
    iter_count resb 1
    num_buffer resb 12

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 100
    int 0x80

    mov esi, buffer
    mov edi, 0

parse_loop:
    cmp edi, array_size
    jge start_sorting
    cmp byte [esi], ' '
    je skip_space
    cmp byte [esi], 10
    je skip_space
    xor eax, eax

parse_digit:
    movzx ecx, byte [esi]
    cmp ecx, '0'
    jl store_number
    cmp ecx, '9'
    jg store_number
    sub ecx, '0'
    imul eax, 10
    add eax, ecx
    inc esi
    jmp parse_digit

store_number:
    mov [array + edi*4], eax
    inc edi
    jmp parse_loop

skip_space:
    inc esi
    jmp parse_loop

start_sorting:
    mov byte [iter_count], 0
    mov ecx, array_size - 1

outer_loop:
    test ecx, ecx
    jz exit_program
    push ecx
    inc byte [iter_count]
    mov eax, 4
    mov ebx, 1
    mov ecx, iter_msg
    mov edx, iter_len
    int 0x80
    movzx eax, byte [iter_count]
    call int_to_string
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, num_buffer
    pop edx
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, colon_msg
    mov edx, colon_len
    int 0x80
    mov ecx, 0

inner_loop:
    mov eax, [array + ecx*4]
    mov edx, [array + ecx*4 + 4]
    cmp eax, edx
    jle no_swap
    mov [array + ecx*4], edx
    mov [array + ecx*4 + 4], eax

no_swap:
    inc ecx
    cmp ecx, [esp]
    jl inner_loop
    call display_array
    pop ecx
    dec ecx
    jmp outer_loop

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

display_array:
    push ecx
    push edx
    mov ecx, 0

display_loop:
    cmp ecx, array_size
    jge display_done
    mov eax, [array + ecx*4]
    call int_to_string
    push ecx
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, num_buffer
    pop edx
    int 0x80
    pop ecx
    inc ecx
    cmp ecx, array_size
    jge skip_space_display
    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80
    pop ecx

skip_space_display:
    jmp display_loop

display_done:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    pop edx
    pop ecx
    ret

int_to_string:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    mov esi, num_buffer
    add esi, 11
    mov byte [esi], 0
    mov ebx, 10
    test eax, eax
    jnz .convert_loop
    dec esi
    mov byte [esi], '0'
    jmp .done

.convert_loop:
    test eax, eax
    jz .done
    xor edx, edx
    div ebx
    add dl, '0'
    dec esi
    mov [esi], dl
    jmp .convert_loop

.done:
    mov edi, num_buffer
    mov eax, num_buffer
    add eax, 11
    sub eax, esi
    mov ecx, eax
    cld

.copy_loop:
    cmp ecx, 0
    je .copy_done
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jmp .copy_loop

.copy_done:
    mov eax, edi
    sub eax, num_buffer
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret