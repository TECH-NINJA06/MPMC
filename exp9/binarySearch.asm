section .data
    size db 10                                   
    key db 4                                     
    found db 0                                   
    msg_found db "Element found at index: ", 0xA  
    msg_not_found db "Element not found", 0xA
    newLine db 10, 0     
    index db 0                                     
    prompt_array db "Enter 10 elements: ", 0xA, 0
    prompt_key db "Enter the key to search: ", 0xA, 0

section .bss
    array resb 10                                 
    input_buffer resb 32                          
    index_str resb 4  

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_array
    mov edx, 38
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 32
    int 0x80

    xor esi, esi
    xor edi, edi
parse_array:
    mov al, byte [input_buffer + esi]
    cmp al, 0x20     
    je skip_space
    cmp al, 0xA   
    je done_parsing
    sub al, '0' 
    mov [array + edi], al
    inc edi
skip_space:
    inc esi
    jmp parse_array
done_parsing:

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_key
    mov edx, 26
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 2
    int 0x80

    mov al, byte [input_buffer]
    sub al, '0'
    mov [key], al

    movzx ecx, byte [size]  
    xor esi, esi           
    mov al, [key]         

    mov ebx, 0            
    dec ecx               

binary_search:
    cmp ebx, ecx
    jg not_found          

    mov edx, ebx
    add edx, ecx
    shr edx, 1            

    mov bl, [array + edx]
    cmp al, bl
    je found_element      

    jb search_right        
    mov ecx, edx
    dec ecx               
    jmp binary_search

search_right:
    mov ebx, edx
    inc ebx             
    jmp binary_search

found_element:
    mov byte [found], 1     
    mov [index], edx         

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