section .data
    msg_input db "Enter a string: ", 0
    msg_output db "Reversed string: ", 0
    newline db 10, 0

section .bss
    buffer resb 100    ; Input buffer (max 100 chars)
    length resb 1      ; Store input length

section .text
    global _start

_start:
    ; Display input prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_input
    mov edx, 16
    int 0x80

    ; Read user input
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 100
    int 0x80

    ; Store length (subtract newline)
    mov byte [length], al
    dec byte [length]

    ; Call string reversal function
    call reverse_string

    ; Display output message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_output
    mov edx, 18
    int 0x80

    ; Print reversed string
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, [length]
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

reverse_string:
    mov esi, buffer        ; Start of string
    mov ecx, [length]      ; Length of string
    shr ecx, 1             ; Divide by 2 for swapping
    jz done                ; If empty, skip

    mov edi, buffer        ; End pointer
    add edi, [length]
    dec edi                ; Move to last character

swap_loop:
    mov al, [esi]          ; Load first character
    mov ah, [edi]          ; Load last character
    mov [esi], ah          ; Swap
    mov [edi], al          ; Swap

    inc esi                ; Move forward
    dec edi                ; Move backward
    loop swap_loop         ; Repeat

done:
    ret
