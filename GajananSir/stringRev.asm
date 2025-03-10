section .data
    msg_input db "Enter a string: ", 0
    msg_output db "Reversed string: ", 0
    newline db 10, 0

section .bss
    buffer resb 100 
    length resb 1      

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_input
    mov edx, 16
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 100
    int 0x80

    mov byte [length], al
    dec byte [length]

    call reverse_string

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_output
    mov edx, 18
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, [length]
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

reverse_string:
    mov esi, buffer     
    mov ecx, [length]      
    shr ecx, 1           
    jz done               

    mov edi, buffer    
    add edi, [length]
    dec edi             

swap_loop:
    mov al, [esi]     
    mov ah, [edi]    
    mov [esi], ah     
    mov [edi], al     

    inc esi            
    dec edi            
    loop swap_loop      

done:
    ret
