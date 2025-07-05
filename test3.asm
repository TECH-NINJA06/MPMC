section .data 
    input_msg db 'Enter size: ', 0 
    input_len equ $-input_msg
    arrip db 'Enter number: ', 0
    arrlen equ $-arrip
    newline db 10, 0 
 
section .bss 
    array resd 10
    buffer resb 2 
    ip resb 2 
    num resb 2
    avg resb 2

%macro input 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro write 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

section .text 
    global _start 
 
_start: 
    write input_msg, input_len
    input ip, 2
    mov eax, [ip]
    sub eax, '0'
    mov [ip], eax
    xor esi, esi
 
input_loop:
    movzx eax, byte [ip]
    cmp esi, eax
    jge input_done
    write arrip, arrlen
    input buffer, 2
    mov eax, [buffer]
    sub eax, '0'
    mov [array+esi], eax
    inc esi
    jmp input_loop

input_done:
    xor esi, esi
    xor eax,eax
    mov [avg], eax


avg_loop:
    movzx eax, byte [ip]
    cmp esi, eax
    jge avg_done
    movzx eax, byte [array+esi]
    movzx ebx, byte [avg]
    add ebx, eax
    mov [avg], ebx
    inc esi
    jmp avg_loop

avg_done:
    xor edx, edx
    mov eax, [avg]
    movzx ecx,byte [ip]
    div ecx
    add eax,'0'
    mov [avg], eax
    write avg, 2
close:
    mov eax, 1
    mov ebx, 0
    int 80h

     
