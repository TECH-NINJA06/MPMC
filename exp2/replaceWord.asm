section .data
    input db 'I like apples.', 0
    old_word db 'apples', 0
    new_word db 'oranges', 0
    output db 50 DUP(0)  ; Buffer for the modified string

section .text
    org 100h
start:
    ; Load source and destination strings
    lea si, input         ; Source string
    lea di, output        ; Destination string
    lea bx, old_word      ; Word to replace
    lea cx, new_word      ; Replacement word

    mov al, 0             ; Initialize AL for end of string check

replace_loop:
    lodsb                 ; Load a byte from input string
    cmp al, 0             ; End of string?
    je done               ; If yes, jump to done
    cmp al, 'a'           ; Check for the word 'apples'
    jne copy_char         ; If not, just copy the character

    ; Replace the word
    lea si, new_word      ; Load replacement word into SI
    replace_word:
        lodsb             ; Load bytes from replacement
        stosb             ; Store in output
        cmp al, 0         ; Check if replacement is done
        jne replace_word  ; Repeat if not done
        jmp replace_loop  ; Continue with the rest of the string

copy_char:
    stosb                 ; Copy original character to output
    jmp replace_loop

done:
    ; Display the output string
    mov dx, offset output
    mov ah, 09h
    int 21h

    mov ah, 4Ch           ; Exit program
    int 21h
