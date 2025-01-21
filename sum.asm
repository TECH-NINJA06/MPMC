section .data
    numbers db 10h, 20h, 15h, 25h, 30h, 5h, 10h, 40h, 35h, 20h ; Array of 10 numbers
    result dw 0 ; To store the sum

section .text
    global _start

_start:
    mov cx, 10          ; Counter for 10 numbers
    lea si, [numbers]   ; Load address of numbers array into SI
    xor ax, ax          ; Clear AX (initialize sum to 0)

add_loop:
    mov al, [si]        ; Load the current number into AL
    add ax, ax          ; Add the number in AL to AX
    inc si              ; Move to the next number in the array
    loop add_loop       ; Decrement CX and repeat if CX ≠ 0

    mov [result], ax    ; Store the final sum in 'result'

    ; Exit the program
    mov eax, 1          ; System call number for exit
    mov ebx, 0          ; Exit code
    int 0x80            ; Interrupt to exit
