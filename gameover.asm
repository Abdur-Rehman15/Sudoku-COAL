


gameOver:  db '   |||||||  |||||||  |        |  |||||||   ||||   |     |  |||||||  ||||         '
           db '   |        |     |  | |    | |  |        |    |  |     |  |        |   |        '
           db '   |  ||||  |||||||  |  |  |  |  ||||     |    |   |   |   ||||     ||||         '
           db '   |     |  |     |  |    |   |  |        |    |    | |    |        | |          '
           db '   |||||||  |     |  |        |  |||||||   ||||      |     |||||||  |   |        '


timeDelay11:
    push cx
    mov cx, 0xffff
loop11:
    sub cx, 1
    cmp cx, 0x0
    jne loop11
    mov cx, 0xffff
loop22:
    sub cx, 1
    cmp cx, 0x0
    jne loop22
    pop cx
    ret

game_is_over:
    call clearscreen
    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov di, 1760
    mov si, gameOver
    mov cx, 5

print_lines_function:
    push cx
    mov cx, 80

print_chars_function:
    mov al, [si]
    cmp al, '|'
    je draw_white_function
    cmp al, ' '
    je draw_black_function
    jmp next_char_function

draw_white_function:
    mov ah, 0x3E
    jmp store_char_function

draw_black_function:
    mov ah, 0x38
    jmp store_char_function

store_char_function:
    mov [es:di], ax
    add di, 2
    inc si

next_char_function:
    loop print_chars_function
    call timeDelay11
    pop cx
    loop print_lines_function
    mov ah, 0x00
    int 16h
ret
