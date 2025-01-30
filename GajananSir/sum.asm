section .data
    numbers db 10h, 20h, 15h, 25h, 30h, 5h, 10h, 40h, 35h, 20h 
    result dw 0 
    msg db 'Sum is: ', 0
    len equ $ - msg

section .bss
    sum resb 4

section .text
    global _start

_start:
    mov cx, 10        
    lea si, [numbers]   
    xor ax, ax          

add_loop:
    mov al, [si]       
    add ah, al          
    inc si              
    loop add_loop      

    mov [result], ax  

    mov eax, [result]
    call int_to_ascii

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 80h

    ; Print the sum
    mov eax, 4
    mov ebx, 1
    mov ecx, sum
    mov edx, 4
    int 80h

    mov eax, 1         
    mov ebx, 0       
    int 80h

int_to_ascii:
    mov ecx, sum + 3
    mov byte [ecx], 0
    dec ecx
.convert_loop:
    xor edx, edx
    div byte 10
    add dl, '0'
    mov [ecx], dl
    dec ecx
    test eax, eax
    jnz .convert_loop
    ret
