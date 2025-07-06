section .data
    array db 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 
    size db 10                                   
    key db 40                                      
    found db 0                                      
    msg_found db "Element found at index: ", 0xA  
    msg_not_found db "Element not found", 0xA     
    index db 0                                     

section .bss
    index_str resb 4  

section .text
    global _start

_start:
    movzx ecx, byte [size]  
    xor esi, esi           
    mov al, [key]         

search_loop:
    cmp esi, ecx          
    je not_found       

    mov bl, [array + esi] 
    cmp bl, al            
    je found_element        

    inc esi                 
    jmp search_loop         

found_element:
    mov byte [found], 1     
    mov [index], esi         

    mov eax, [index]
    add eax, '0'
    mov [index_str], eax

    mov eax, 4            
    mov ebx, 1          
    mov ecx, msg_found      
    mov edx, 23            
    int 0x80              

    mov eax, 4
    mov ebx, 1
    mov ecx, index_str
    mov edx, 1
    int 0x80

    jmp end_program       

not_found:
    mov byte [found], 0     
    mov eax, 4             
    mov ebx, 1              
    mov ecx, msg_not_found  
    mov edx, 18           
    int 0x80   

end_program:   
    mov eax, 1             
    xor ebx, ebx         
    int 0x80 