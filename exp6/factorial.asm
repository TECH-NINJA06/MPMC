section .data
    msg db "Enter the number: ", 0


section .bss
    num resb 2        
    result resw 1      

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 18
    int 80h

    mov eax, 3       
    mov ebx, 0        
    mov ecx, num     
    mov edx, 2       
    int 80h        

    movzx ecx, byte [num]
    sub ecx, '0'
    
    push ecx
    call factorial

    mov eax, 4       
    mov ebx, 1         
    mov ecx, result    
    mov edx, 2       
    int 80h           

    mov eax, 1         
    xor ebx, ebx       
    int 80h           

factorial:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebp + 8]
    mov ax, 1    

factorial_loop:
    cmp ecx, 1        
    jle end_factorial 
    mul cx        
    dec ecx        
    jmp factorial_loop
    ret 

end_factorial:
    mov [result], ax  
    mov eax, [result]
    add eax, '0'
    mov [result], ax
    
    mov esp, ebp
    pop ebp
    ret 