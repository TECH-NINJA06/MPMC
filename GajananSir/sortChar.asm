section .data
    array db "e", "c", "h", "a", "b", "i", "d", "g", "f"  
    size equ 9                           
    newline db 0xA                        

section .bss
    buffer resb 1                         

section .text
    global _start

_start:
    mov ecx, size
    dec ecx        
    xor esi, esi  

sort_loop:
    cmp esi, ecx
    jge print_sorted 

    mov edi, esi 
    mov ebx, esi
    inc ebx     

inner_loop:
    cmp ebx, size
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
    je skip_swap 

    mov al, [array + esi]
    mov dl, [array + edi]
    mov [array + esi], dl
    mov [array + edi], al

skip_swap:
    inc esi
    jmp sort_loop

print_sorted:
    xor esi, esi

print_loop:
    cmp esi, size
    jge exit_program 

    movzx eax, byte [array + esi]              
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
