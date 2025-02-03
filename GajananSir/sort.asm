section .data
    array db 5, 3, 8, 1, 2, 9, 4, 7, 6, 0  ; Array of 10 numbers
    size equ 10                            ; Array size
    newline db 0xA                         ; Newline character

section .bss
    buffer resb 1                          ; Buffer to store ASCII number

section .text
    global _start

_start:
    ; Initialize selection sort
    mov ecx, size
    dec ecx         ; ecx = size - 1
    xor esi, esi    ; i = 0

sort_loop:
    cmp esi, ecx
    jge print_sorted  ; If i >= size - 1, sorting is done

    mov edi, esi  ; min_index = i
    mov ebx, esi
    inc ebx       ; j = i + 1

inner_loop:
    cmp ebx, size
    jge swap_elements  ; If j >= size, move to swap

    mov al, [array + edi]
    mov dl, [array + ebx]
    cmp al, dl
    jle no_swap

    mov edi, ebx  ; Update min_index

no_swap:
    inc ebx
    jmp inner_loop

swap_elements:
    cmp esi, edi
    je skip_swap  ; If min_index == i, no swap needed

    mov al, [array + esi]
    mov dl, [array + edi]
    mov [array + esi], dl
    mov [array + edi], al

skip_swap:
    inc esi
    jmp sort_loop

; =====================
; PRINT SORTED ARRAY
; =====================
print_sorted:
    xor esi, esi

print_loop:
    cmp esi, size
    jge exit_program  ; Exit after printing all numbers

    movzx eax, byte [array + esi]  ; Load value from array
    add eax, '0'                   ; Convert number to ASCII
    mov [buffer], al

    mov eax, 4                      ; syscall: sys_write
    mov ebx, 1                      ; stdout
    mov ecx, buffer                 ; Address of buffer
    mov edx, 1                      ; Print 1 character
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    inc esi
    jmp print_loop

; =====================
; EXIT PROGRAM
; =====================
exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
