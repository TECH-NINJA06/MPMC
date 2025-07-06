; Removed print and read_stdin macros

%macro exit 0
    mov eax, 1
    xor ebx, ebx
    int 0x80
%endmacro

section .data
    prompt_size db "Enter the number of elements: ", 0
    prompt_element db "Enter element: ", 0
    prompt_target db "Enter the target number to search: ", 0
    msg_found db "Element found at index: ", 0
    msg_not_found db "Element not found", 0
    msg_iteration db "Iteration ", 0
    msg_checking db ", Checking index: ", 0
    msg_value db ", Value: ", 0
    newline db 10, 0

section .bss
    array resd 100
    size resd 1
    target resd 1
    buffer resb 10
    current resd 1

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_size
    mov edx, 30
    int 0x80
    call read_int
    mov [size], eax
    xor ebx, ebx

input_loop:
    cmp ebx, [size]
    jge input_done
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_element
    mov edx, 15
    int 0x80
    call read_int
    mov [array + ebx*4], eax
    inc ebx
    jmp input_loop
input_done:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_target
    mov edx, 34
    int 0x80
    call read_int
    mov [target], eax
    xor ebx, ebx
search_loop:
    cmp ebx, [size]
    jge not_found
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_iteration
    mov edx, 10
    int 0x80
    mov eax, ebx
    inc eax
    call print_int
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_checking
    mov edx, 18
    int 0x80
    mov eax, ebx
    call print_int
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_value
    mov edx, 9
    int 0x80
    mov eax, [array + ebx*4]
    mov [current], eax
    call print_int
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    mov eax, [current]
    cmp eax, [target]
    je found
    inc ebx
    jmp search_loop
found:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_found
    mov edx, 24
    int 0x80
    mov eax, ebx
    call print_int
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    jmp exit_program
not_found:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_not_found
    mov edx, 17
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
exit_program:
    exit
read_int:
    push ebx
    push ecx
    push edx
    push esi
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 10
    int 0x80
    dec eax
    mov ecx, eax
    mov esi, buffer
    xor eax, eax
convert_loop:
    test ecx, ecx
    jz convert_done
    movzx edx, byte [esi]
    inc esi
    cmp dl, 10
    je convert_skip
    sub dl, '0'
    cmp dl, 9
    ja convert_skip
    imul eax, 10
    add eax, edx
convert_skip:
    dec ecx
    jmp convert_loop
convert_done:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
print_int:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    test eax, eax
    jnz non_zero
    mov byte [buffer], '0'
    mov byte [buffer+1], 0
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 0x80
    jmp print_int_done
non_zero:
    mov ecx, 10
    mov edi, buffer
    add edi, 9
    mov byte [edi], 0
    mov esi, edi
digit_loop:
    dec edi
    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi], dl
    test eax, eax
    jnz digit_loop
    mov ecx, edi
    mov edx, esi
    sub edx, edi
    mov eax, 4
    mov ebx, 1
    int 0x80
print_int_done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret