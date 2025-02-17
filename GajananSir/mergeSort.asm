section .data
    array db 5, 3, 8, 1, 2, 9, 4, 7, 6, 0
    size equ 10
    newline db 0xA

section .bss
    temp_array resb size    ; Temporary array for merging
    buffer resb 1

section .text
    global _start

_start:
    ; Initialize for merge sort
    push dword 0           ; left index
    push dword size-1      ; right index
    call merge_sort
    add esp, 8            ; Clean up stack

    jmp print_sorted

merge_sort:
    push ebp
    mov ebp, esp
    
    ; Get parameters
    mov eax, [ebp + 8]     ; left index
    mov ebx, [ebp + 12]    ; right index
    
    ; Check if we need to sort (if left < right)
    cmp eax, ebx
    jge merge_sort_end
    
    ; Calculate middle point
    mov ecx, eax
    add ecx, ebx
    shr ecx, 1             ; middle = (left + right) / 2
    
    ; Save registers
    push eax
    push ebx
    push ecx
    
    ; Sort left half
    push eax               ; left
    push ecx               ; middle
    call merge_sort
    add esp, 8
    
    ; Sort right half
    pop ecx
    push ecx
    inc ecx
    push ecx               ; middle + 1
    push ebx               ; right
    call merge_sort
    add esp, 8
    
    ; Merge the sorted halves
    pop ecx
    pop ebx
    pop eax
    
    ; Parameters for merge: left, middle, right
    push eax
    push ecx
    push ebx
    call merge
    add esp, 12
    
merge_sort_end:
    pop ebp
    ret

merge:
    push ebp
    mov ebp, esp
    
    mov esi, [ebp + 16]    ; left
    mov edi, [ebp + 12]    ; middle
    mov ebx, [ebp + 8]     ; right
    
    ; Copy to temp array
    mov ecx, esi           ; counter
copy_loop:
    mov al, [array + ecx]
    mov [temp_array + ecx], al
    inc ecx
    cmp ecx, ebx
    jle copy_loop
    
    mov ecx, esi           ; Initialize array index
    mov edx, esi           ; Initialize left index
    mov esi, edi
    inc esi                ; Initialize right index
    
merge_loop:
    cmp edx, edi
    jg copy_remaining_right
    cmp esi, ebx
    jg copy_remaining_left
    
    mov al, [temp_array + edx]
    mov ah, [temp_array + esi]
    cmp al, ah
    jle copy_left
    
copy_right:
    mov [array + ecx], ah
    inc esi
    jmp next_merge
    
copy_left:
    mov [array + ecx], al
    inc edx
    
next_merge:
    inc ecx
    jmp merge_loop
    
copy_remaining_left:
    cmp edx, edi
    jg merge_end
    mov al, [temp_array + edx]
    mov [array + ecx], al
    inc edx
    inc ecx
    jmp copy_remaining_left
    
copy_remaining_right:
    cmp esi, ebx
    jg merge_end
    mov al, [temp_array + esi]
    mov [array + ecx], al
    inc esi
    inc ecx
    jmp copy_remaining_right
    
merge_end:
    pop ebp
    ret

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
