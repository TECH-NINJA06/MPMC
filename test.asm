section .bss
    x_input resb 10
    result resb 11

section .data
    prompt db "Enter x: ", 0
    newline db 10, 0

section .text
    global _start

_start:
    ; Prompt for x
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 9
    int 80h

    ; Read x input
    mov eax, 3
    mov ebx, 0
    mov ecx, x_input
    mov edx, 10
    int 80h
    mov byte [ecx + eax - 1], 0  ; Null terminate

    ; Convert ASCII x_input to integer -> EAX
    xor eax, eax
    xor ebx, ebx
    mov esi, x_input

convert_x:
    mov bl, [esi]
    cmp bl, 0
    je done_convert_x
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc esi
    jmp convert_x
done_convert_x:

    ; EAX = x
    mov ebx, eax    ; Save x
    mov ecx, eax           ; ECX = x
    imul ecx, eax          ; ECX = x²
    mov edx, ecx           ; EDX = x²
    imul edx, ebx          ; EDX = x³

    add edx, ecx     ; x³ + x²
    add edx, 12      ; x³ + x² + 12

    ; Convert EDX to string and store in result
    mov esi, result + 10
    mov byte [esi], 0
    dec esi

convert_result:
    xor eax, eax
    mov eax, edx
    xor edx, edx
    mov ecx, 10
    div ecx
    add dl, '0'
    mov [esi], dl
    dec esi
    mov edx, eax
    cmp eax, 0
    jne convert_result
    inc esi

    ; Print result
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, result + 10
    sub edx, esi
    int 80h

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
