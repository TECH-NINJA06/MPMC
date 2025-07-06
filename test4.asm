section .data 
    input_msg db 'Enter a number: ', 0 
    greater_msg db 'Numbers greater than 50: ', 0 
    lesser_msg db 'Numbers less than or equal to 50: ', 0 
    newline db 10, 0 
 
section .bss 
    array resd 10 
    input resb 16 
    greater_count resd 1 
    lesser_count resd 1 
 
section .text 
    global _start 
 
_start: 
    mov esi, 0 
    mov dword [greater_count], 0 
    mov dword [lesser_count], 0 
 
loop_input: 
    cmp esi, 5 
    jge end_input 
     
    mov eax, 4 
    mov ebx, 1 
    mov ecx, input_msg 
    mov edx, 14 
    int 0x80 
     
    mov eax, 3 
    mov ebx, 0 
    mov ecx, input 
    mov edx, 16 
    int 0x80 
     
    xor eax, eax 
    mov edi, input 
     
convert_number: 
    mov bl, byte [edi] 
    cmp bl, 10 
    je number_ready 
    cmp bl, 0 
    je number_ready 
     
    sub bl, '0' 
    imul eax, 10 
    add eax, ebx 
    inc edi 
    jmp convert_number 
     
number_ready: 
    mov [array + esi*4], eax 
     
    cmp eax, 50 
    jg greater_than_50 
     
    inc dword [lesser_count] 
    jmp continue_input 
     
greater_than_50: 
    inc dword [greater_count] 
     
continue_input: 
    inc esi 
    jmp loop_input 
 
end_input: 
    mov eax, 4 
    mov ebx, 1 
    mov ecx, greater_msg 
    mov edx, 26 
    int 0x80 
     
    mov eax, [greater_count] 
    add eax, '0' 
    mov [input], al 
     
    mov eax, 4 
    mov ebx, 1 
    mov ecx, input 
    mov edx, 1 
    int 0x80 
     
    mov eax, 4 
    mov ebx, 1 
    mov ecx, newline 
    mov edx, 1 
    int 0x80 
     
    mov eax, 4 
    mov ebx, 1 
    mov ecx, lesser_msg 
    mov edx, 32 
    int 0x80 
     
    mov eax, [lesser_count] 
    add eax, '0' 
    mov [input], al 
     
    mov eax, 4 
    mov ebx, 1 
    mov ecx, input 
    mov edx, 1 
    int 0x80 
     
    mov eax, 4 
    mov ebx, 1 
    mov ecx, newline 
    mov edx, 1 
    int 0x80 
mov eax, 1 
mov ebx, 0 
int 0x80