section .data
    array db 5, 3, 8, 1, 2, 9, 4, 7, 6, 0  ; Array of 10 numbers
    size equ 10                            ; Array size
    newline db 0xA                         ; Newline character

section .bss
    buffer resb 1                          ; Buffer to store ASCII number

section .text
    global _start

_start:
    ; Initialize bubble sort
    mov ecx, size
    dec ecx         ; ecx = size - 1 (outer loop counter)
    xor esi, esi    ; i = 0

bubble_outer_loop:
    cmp esi, ecx
    jge print_sorted  ; If i >= size - 1, sorting is done

    xor ebx, ebx    ; j = 0 (inner loop counter)

bubble_inner_loop:
    mov al, [array + ebx]    ; Load array[j]
    mov dl, [array + ebx + 1]; Load array[j+1]
    cmp al, dl
    jle no_swap              ; If array[j] <= array[j+1], no swap needed

    mov [array + ebx], dl    ; Swap array[j] and array[j+1]
    mov [array + ebx + 1], al

no_swap:
    inc ebx
    mov eax, size
    sub eax, esi
    dec eax                    ; Limit inner loop to (size - i - 1)
    cmp ebx, eax
    jl bubble_inner_loop        ; Continue inner loop

    inc esi
    jmp bubble_outer_loop       ; Continue outer loop

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
