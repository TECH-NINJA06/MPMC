section .bss
    num resb 2         ; Reserve 2 bytes for the input number
    result resw 1      ; Variable to store the result

section .text
    global _start

_start:
    ; Read input from the user
    mov eax, 3         ; syscall: sys_read
    mov ebx, 0         ; file descriptor: stdin
    mov ecx, num       ; buffer to store input
    mov edx, 2         ; number of bytes to read
    int 0x80           ; interrupt to invoke syscall

    ; Convert input from ASCII to integer
    movzx ecx, byte [num]
    sub ecx, '0'

    mov ax, 1          ; Initialize AX register to 1 (factorial result)

factorial_loop:
    cmp ecx, 1         ; Compare CX with 1
    jle end_factorial  ; If CX <= 1, jump to end_factorial
    mul cx             ; Multiply AX by CX
    dec ecx            ; Decrement CX
    jmp factorial_loop ; Repeat the loop

end_factorial:
    mov [result], ax   ; Store the result in memory

    ; Convert result to ASCII and print it
    mov eax, [result]
    add eax, '0'
    mov [result], ax

    ; Print the result
    mov eax, 4         ; syscall: sys_write
    mov ebx, 1         ; file descriptor: stdout
    mov ecx, result    ; buffer to print
    mov edx, 2         ; number of bytes to write
    int 0x80           ; interrupt to invoke syscall

    ; Exit the program
    mov eax, 1         ; syscall: exit
    xor ebx, ebx       ; status: 0
    int 0x80           ; interrupt to invoke syscall