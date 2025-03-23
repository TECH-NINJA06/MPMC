section .data
    prompt db "Enter number: ", 0
    prompt_len equ $ - prompt
    sum_msg db "Sum of elements is: ", 0
    sum_len equ $ - sum_msg
    newline db 10, 0

section .bss
    array resw 5        
    num resb 10         ; Buffer for input
    sum resw 1    

section .text
    global _start

_start:
    mov word [sum], 0   ; Initialize sum to 0
    mov ecx, 5          ; Loop counter for 5 elements
    mov esi, array      ; Pointer to the array
    
input_loop:
    push ecx            ; Save loop counter
    
    ; Display prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 80h
    
    ; Read number input
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 10      
    int 80h
    
    ; Convert ASCII input to integer
    call atoi
    mov ax, dx    
    
    ; Store the number in the array
    mov [esi], ax      
    
    ; Add number to sum
    add word [sum], ax
    
    add esi, 2         ; Move to the next array element
    pop ecx            ; Restore counter
    loop input_loop
    
    ; Display sum message
    mov eax, 4
    mov ebx, 1
    mov ecx, sum_msg
    mov edx, sum_len
    int 80h
    
    ; Print the sum
    mov ax, [sum]
    call print_number
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 80h

; ==========================
; Function: print_number
; Prints a signed integer in decimal
; ==========================
print_number:
    push ax
    push bx
    push cx
    push dx

    mov cx, 0         ; Counter for digits
    mov bx, 10        ; Divisor for conversion

    ; Handle negative numbers
    cmp ax, 0
    jge print_loop
    mov byte [num], '-'
    
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 1
    int 80h
    
    neg ax            ; Convert negative number to positive

print_loop:
    xor dx, dx
    div bx            ; AX = AX / 10, remainder in DX
    push dx           ; Store remainder
    inc cx            ; Increment counter
    test ax, ax       ; Check if quotient is 0
    jnz print_loop  

print_digits:
    pop dx
    add dl, '0'       ; Convert to ASCII
    mov [num], dl
    
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 1
    int 80h
    loop print_digits  ; Loop until all digits are printed

    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ==========================
; Function: atoi
; Converts ASCII string to integer
; ==========================
atoi:
    xor ax, ax 
    xor dx, dx 
    xor cx, cx 

    mov esi, num

    ; Check for negative sign
    mov al, [esi]
    cmp al, '-'
    jne atoi_convert
    inc esi  
    inc cx    ; Set negative flag

atoi_convert:
    xor bx, bx  

atoi_loop:
    mov al, [esi]   
    cmp al, 10      
    je atoi_finish
    cmp al, 0        
    je atoi_finish
    cmp al, '0'     
    jb atoi_finish
    cmp al, '9'      
    ja atoi_finish

    sub al, '0'      
    imul bx, bx, 10 
    add bx, ax      

    inc esi        
    jmp atoi_loop

atoi_finish:
    cmp cx, 0      
    je atoi_store_result
    neg bx         ; If negative, negate the result

atoi_store_result:
    mov dx, bx    ; Store final result in DX
    ret
