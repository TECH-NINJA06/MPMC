section .data
    array db 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ; Array of 10 elements
    size db 10                                      ; Size of the array
    key db 40                                       ; Element to search for
    found db 0                                      ; Flag to indicate if the element is found
    msg_found db "Element found", 0xA              ; Message if found (newline added)
    msg_not_found db "Element not found", 0xA      ; Message if not found

section .text
    global _start

_start:
    movzx ecx, byte [size]  ; Load size of the array into ECX (zero-extend)
    xor esi, esi            ; Initialize ESI to 0 (array index)
    mov al, [key]           ; Load the key to search for into AL

search_loop:
    cmp esi, ecx            ; Compare index with size
    je not_found            ; If index equals size, element is not found

    mov bl, [array + esi]   ; Load array element into BL
    cmp bl, al              ; Compare array element with key
    je found_element        ; If they are equal, element is found

    inc esi                 ; Increment index
    jmp search_loop         ; Repeat the loop

found_element:
    mov byte [found], 1     ; Set found flag to 1
    mov eax, 4              ; sys_write
    mov ebx, 1              ; File descriptor (stdout)
    mov ecx, msg_found      ; Address of "Element found"
    mov edx, 14             ; Length of the message
    int 0x80                ; Call kernel
    jmp end_program         ; End the program

not_found:
    mov byte [found], 0     ; Set found flag to 0
    mov eax, 4              ; sys_write
    mov ebx, 1              ; File descriptor (stdout)
    mov ecx, msg_not_found  ; Address of "Element not found"
    mov edx, 18             ; Length of the message
    int 0x80   
end_program:    ; Call kernel
 mov eax, 1              ; System call number (sys_exit)
    xor ebx, ebx            ; Exit code 0
    int 0x80 