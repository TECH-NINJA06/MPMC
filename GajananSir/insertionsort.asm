section .data
    array db 5, 3, 8, 1, 2, 9, 4, 7, 6, 0  ; Array of 10 numbers
    size equ 10                            ; Array size
    newline db 0xA                         ; Newline character

section .bss
    buffer resb 1                          ; Buffer to store ASCII number

section .text
    global _start

_start:
    mov esi, 1            ; Start from the second element (index 1)

insertion_outer_loop:
    cmp esi, size
    jge print_sorted      ; If i >= size, sorting is done

    mov al, [array + esi] ; key = array[i]
    mov edi, esi
    dec edi               ; j = i - 1

insertion_inner_loop:
    cmp edi, -1           ; If j < 0, stop shifting
    jl insert_key

    mov dl, [array + edi] ; Load array[j]
    cmp dl, al            ; Compare array[j] with key
    jle insert_key        ; If array[j] <= key, stop shifting

    mov [array + edi + 1], dl ; Shift array[j] to the right
    dec edi               ; j = j - 1
    jmp insertion_inner_loop

insert_key:
    mov [array + edi + 1], al ; Insert key at the correct position
    inc esi                   ; Move to next element
    jmp insertion_outer_loop

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
