section .data
    prompt_msg db "Enter 5 integers separated by space (Insertion): ", 0
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
    num_buffer resb 12

section .text
    global _start

_start:
    ; Prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, prompt_len
    int 0x80

    ; Read input
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 100
    int 0x80

    ; Parse space-separated integers
    mov esi, buffer
    mov edi, 0
parse_loop:
    cmp edi, array_size
    jge start_sorting
    xor eax, eax
.skip_spaces:
    cmp byte [esi], ' '
    je .advance
    cmp byte [esi], 10
    je .advance
    jmp .parse_digit
.advance:
    inc esi
    jmp .skip_spaces

.parse_digit:
    movzx ecx, byte [esi]
    cmp ecx, '0'
    jb .store
    cmp ecx, '9'
    ja .store
    sub ecx, '0'
    imul eax, eax, 10
    add eax, ecx
    inc esi
    jmp .parse_digit

.store:
    mov [array + edi*4], eax
    inc edi
    jmp parse_loop

; --------------------
; Insertion Sort
; --------------------
start_sorting:
    mov ecx, 1 ; current index

outer_loop:
    cmp ecx, array_size
    jge exit_program

    ; Print "Iteration X: "
    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, iter_msg
    mov edx, iter_len
    int 0x80

    pop eax
    call int_to_string
    call print_num_buffer

    mov eax, 4
    mov ebx, 1
    mov ecx, colon_msg
    mov edx, colon_len
    int 0x80

    ; Perform insertion
    mov eax, [array + ecx*4]  ; key = array[i]
    mov edx, ecx
    dec edx

shift_loop:
    cmp edx, -1
    jl insert_key
    mov ebx, [array + edx*4]
    cmp ebx, eax
    jle insert_key
    mov [array + edx*4 + 4], ebx
    dec edx
    jmp shift_loop

insert_key:
    mov [array + edx*4 + 4], eax
    call display_array
    inc ecx
    jmp outer_loop

; --------------------
; Display array
; --------------------
display_array:
    push ecx
    mov ecx, 0
.display_loop:
    cmp ecx, array_size
    jge .done
    mov eax, [array + ecx*4]
    call int_to_string
    call print_num_buffer
    cmp ecx, array_size - 1
    jge .no_space
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80
.no_space:
    inc ecx
    jmp .display_loop
.done:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    pop ecx
    ret

; --------------------
; Print num_buffer (string form of EAX)
; --------------------
print_num_buffer:
    mov eax, 4
    mov ebx, 1
    mov ecx, num_buffer
    mov edx, 12
    int 0x80
    ret

; --------------------
; Convert integer in EAX to string in num_buffer
; --------------------
int_to_string:
    mov edi, num_buffer
    add edi, 11
    mov byte [edi], 0
    mov ebx, 10
    test eax, eax
    jnz .convert
    dec edi
    mov byte [edi], '0'
    jmp .copy

.convert:
    xor edx, edx
.loop:
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .loop

.copy:
    mov esi, edi
    mov edi, num_buffer
.copy_loop:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp byte [esi], 0
    jne .copy_loop
    mov byte [edi], 0
    ret

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
