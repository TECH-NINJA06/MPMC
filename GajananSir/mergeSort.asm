section .data
    msg1 db 'Original array: ', 0
    len1 equ $ - msg1
    msg2 db 'Sorted array: ', 0
    len2 equ $ - msg2
    newline db 0xa
    space db ' '
    array db 5, 2, 8, 1, 9    
    array_len equ $ - array

section .bss
    num resb 2
    temp_array resb array_len

section .text
    global _start
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 80h
    
    call print_array
    
    mov eax, 0
    mov ebx, array_len - 1
    call merge_sort
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 80h
    
    call print_array
    
    mov eax, 1
    mov ebx, 0
    int 80h

merge_sort:
    push ebp
    mov ebp, esp
    
    cmp eax, ebx
    jge merge_sort_end
    
    mov ecx, eax
    add ecx, ebx
    shr ecx, 1
    
    push eax
    push ebx
    push ecx
    
    mov ebx, ecx
    call merge_sort
    
    pop ecx
    pop ebx
    pop eax
    
    push eax
    push ebx
    push ecx
    
    mov eax, ecx
    inc eax
    call merge_sort
    
    pop ecx
    pop ebx
    pop eax
    
    push eax
    push ebx
    push ecx
    call merge
    
merge_sort_end:
    mov esp, ebp
    pop ebp
    ret

merge:
    push ebp
    mov ebp, esp
    
    mov esi, [ebp+16]
    mov edi, [ebp+8]
    inc edi
    mov ecx, [ebp+16]
    
copy_to_temp:
    mov al, [array + ecx]
    mov [temp_array + ecx], al
    inc ecx
    cmp ecx, [ebp+12]
    jle copy_to_temp
    
    mov ecx, [ebp+16]
    
merge_loop:
    cmp esi, [ebp+8]
    jg copy_remaining_right
    
    cmp edi, [ebp+12]
    jg copy_remaining_left
    
    mov al, [temp_array + esi]
    cmp al, [temp_array + edi]
    jle copy_from_left
    
copy_from_right:
    mov al, [temp_array + edi]
    mov [array + ecx], al
    inc edi
    inc ecx
    jmp merge_loop
    
copy_from_left:
    mov al, [temp_array + esi]
    mov [array + ecx], al
    inc esi
    inc ecx
    jmp merge_loop
    
copy_remaining_left:
    cmp esi, [ebp+8]
    jg merge_end
    mov al, [temp_array + esi]
    mov [array + ecx], al
    inc esi
    inc ecx
    jmp copy_remaining_left
    
copy_remaining_right:
    cmp edi, [ebp+12]
    jg merge_end
    mov al, [temp_array + edi]
    mov [array + ecx], al
    inc edi
    inc ecx
    jmp copy_remaining_right
    
merge_end:
    mov esp, ebp
    pop ebp
    ret

print_array:
    mov ecx, 0

print_loop:
    mov al, [array + ecx]
    add al, '0'
    mov [num], al
    
    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h
    
    pop ecx
    inc ecx
    cmp ecx, array_len
    jl print_loop
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    ret