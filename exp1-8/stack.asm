section .data
    prompt_menu db "Stack Operations: ", 10
                db "1. Push", 10
                db "2. Pop", 10
                db "3. Display", 10
                db "4. Exit", 10
                db "Enter your choice: "
    prompt_menu_len equ $ - prompt_menu
    prompt_push db "Enter a number to push (0-9): "
    prompt_push_len equ $ - prompt_push
    prompt_pop db "Popped value: "
    prompt_pop_len equ $ - prompt_pop
    prompt_display db "Stack contents: "
    prompt_display_len equ $ - prompt_display
    newline db 10
    stack_empty_msg db "Stack is empty", 10
    stack_empty_len equ $ - stack_empty_msg
    stack_full_msg db "Stack is full", 10
    stack_full_len equ $ - stack_full_msg
    space db ' '

section .bss
    choice resb 2
    input resb 2
    stack resb 10
    top resd 1

section .text
global _start

%macro write 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro read 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

_start:
    mov dword [top], stack

menu_loop:
    write prompt_menu, prompt_menu_len
    read choice, 2
    mov al, [choice]
    sub al, '0'

    cmp al, 1
    je push_item
    cmp al, 2
    je pop_item
    cmp al, 3
    je display_stack
    cmp al, 4
    je exit_program
    jmp menu_loop

push_item:
    mov eax, [top]
    sub eax, stack
    cmp eax, 10
    je stack_full

    write prompt_push, prompt_push_len
    read input, 2

    mov al, [input]
    sub al, '0'
    mov ebx, [top]
    mov [ebx], al
    add dword [top], 1

    jmp menu_loop

pop_item:
    mov eax, [top]
    cmp eax, stack
    je stack_empty

    sub dword [top], 1
    mov ebx, [top]
    mov al, [ebx]
    add al, '0'
    mov [input], al

    write prompt_pop, prompt_pop_len
    write input, 1
    write newline, 1

    jmp menu_loop

display_stack:
    mov eax, [top]
    cmp eax, stack
    je stack_empty

    write prompt_display, prompt_display_len

    mov ecx, stack
display_loop:
    cmp ecx, [top]
    je display_done
    mov al, [ecx]
    add al, '0'
    mov [input], al
    push ecx
    write input, 1
    write space, 1
    pop ecx
    inc ecx
    jmp display_loop

display_done:
    write newline, 1
    jmp menu_loop

stack_full:
    write stack_full_msg, stack_full_len
    jmp menu_loop

stack_empty:
    write stack_empty_msg, stack_empty_len
    jmp menu_loop

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
