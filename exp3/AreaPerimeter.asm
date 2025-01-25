section .data
    length resb 10 
    width resb 10 
    resultArea resb 10 
    resultPerimeter resb 10
    newline db 10, 0 

section .text
    global _start

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, length
    mov edx, 10
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, width
    mov edx, 10
    int 80h

    mov eax, [length]
    sub eax, '0'

    mov ebx, [width]
    sub ebx, '0'

    mov ecx, eax   
    mul ebx       
    add eax, '0'  
    mov [resultArea], eax


    mov eax, 4
    mov ebx, 1
    mov ecx, resultArea
    mov edx, 1   
    int 80h

    mov eax, ecx   
    add eax, ebx  
    add eax, eax     
    add eax, '0'   
    mov [resultPerimeter], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, resultPerimeter
    mov edx, 1   
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    mov eax, [length]
    sub eax, '0'
    mov ebx, [width]
    sub ebx, '0'

    mul ebx  
    shr eax, 1      
    add eax, '0'   
    mov [resultArea], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, resultArea
    mov edx, 1  
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h
