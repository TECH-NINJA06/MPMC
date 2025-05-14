section .data
    prompt_menu db "Queue Operations:  ", 10
                db "1. Enqueue", 10
                db "2. Dequeue", 10
                db "3. Display", 10
                db "4. Exit", 10
                db "Enter your choice:  "
    prompt_menu_len equ $ - prompt_menu
    prompt_enqueue db "Enter a number to enqueue (0-9):  "
    prompt_enqueue_len equ $ - prompt_enqueue
    prompt_dequeue db "Dequeued value:  "
    prompt_dequeue_len equ $ - prompt_dequeue
    prompt_display db "Queue contents:  "
    prompt_display_len equ $ - prompt_display
    newline db 10
    queue_empty_msg db "Queue is empty", 10
    queue_empty_len equ $ - queue_empty_msg
    queue_full_msg db "Queue is full", 10
    queue_full_len equ $ - queue_full_msg
    space db ' '

section .bss
    choice resb 2
    input resb 2
    queue resb 10
    front resd 1
    rear resd 1

section .text
global _start

%macro write 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro read 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

_start:
    mov dword [front], queue
    mov dword [rear], queue

menu_loop:
    write prompt_menu, prompt_menu_len
    read choice, 2
    mov al, [choice]
    sub al, '0'

    cmp al, 1
    je enqueue_item
    cmp al, 2
    je dequeue_item
    cmp al, 3
    je display_queue
    cmp al, 4
    je exit_program
    jmp menu_loop

enqueue_item:
    mov eax, [rear]
    sub eax, queue
    cmp eax, 10
    je queue_full

    write prompt_enqueue, prompt_enqueue_len
    read input, 2

    mov al, [input]
    sub al, '0'
    mov ebx, [rear]
    mov [ebx], al
    inc dword [rear]

    jmp menu_loop

dequeue_item:
    mov eax, [front]
    cmp eax, [rear]
    je queue_empty

    mov ebx, [front]
    mov al, [ebx]
    add al, '0'
    mov [input], al

    write prompt_dequeue, prompt_dequeue_len
    write input, 1
    write newline, 1

    inc dword [front]

    jmp menu_loop

display_queue:
    mov eax, [front]
    cmp eax, [rear]
    je queue_empty

    write prompt_display, prompt_display_len

    mov ecx, [front]
display_loop:
    cmp ecx, [rear]
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

queue_full:
    write queue_full_msg, queue_full_len
    jmp menu_loop

queue_empty:
    write queue_empty_msg, queue_empty_len
    jmp menu_loop

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 80h