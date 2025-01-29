section .data
    msg db 'Multiples of 3 from 0 to 9:', 10, 0  ; Message with newline
    newline db 10, 0                            ; Newline character
    current db 0                                ; Start with 0
    max db 9                                    ; Maximum number (9)

section .bss
    output resb 1                               ; Reserve 1 byte for output

section .text
    global _start

_start:
    ; Print the message
    mov eax, 4          
    mov ebx, 1          
    mov ecx, msg        
    mov edx, 26         ; Length of message
    int 80h
    ; Print newline
    mov eax, 4          
    mov ebx, 1          
    mov ecx, newline    
    mov edx, 1          
    int 80h

    ; Initialize loop
    mov al, [current]   ; Start with 0

check_multiple:
    ; Check if the number is a multiple of 3 (current % 3 == 0)
    mov ah, 0           
    mov bl, 3           ; Divide by 3
    div bl              
    cmp ah, 0           ; Check if remainder is 0
    jne skip_number     ; If not, skip to the next number

    ; Convert the number to ASCII
    mov al, [current]   
    add al, '0'         
    mov [output], al    

    ; Print the number
    mov eax, 4          
    mov ebx, 1          
    mov ecx, output     
    mov edx, 1          
    int 80h

    ; Print newline
    mov eax, 4          
    mov ebx, 1          
    mov ecx, newline    
    mov edx, 1          
    int 80h

skip_number:
    ; Move to the next number
    mov al, [current]   
    inc al              
    mov [current], al   

    ; Check if we've reached the maximum (9)
    cmp al, [max]       
    jg end_program      

    jmp check_multiple  

end_program:
    mov eax, 1          
    mov ebx, 0          
    int 80h
