


ddd: dw 960
fff: dw 1

khalas  :  db '                    |  |  |    |  |        |||||   ||||||                        '
           db '                    | |   |    |  |       |     |  |                             '
           db '                    ||    ||||||  |       |||||||  ||||||                        '
           db '                    | |   |    |  |       |     |       |                        '
           db '                    |  |  |    |  ||||||  |     |  ||||||                        '

you_won  : db '          |     |   ||||   |    |     |         |    ||||   ||    |              '       
           db '           |   |   |    |  |    |     |         |   |    |  | |   |              '
           db '            | |    |    |  |    |      |   |   |    |    |  |  |  |              '
           db '             |     |    |  |    |       | | | |     |    |  |   | |              '
           db '             |      ||||    ||||         |   |       ||||   |    ||              '



displayy:
    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov di, word[ddd]
    cmp word[fff], 1
    jne mm
    mov si, khalas
    jmp sss
    mm:
    mov si, you_won
    sss:
    mov cx, 5

print_lines:
    push cx
    mov cx, 80

print_chars:
    mov al, [si]
    cmp al, '|'
    je draw_white_pixel
    cmp al, ' '
    je draw_black_pixel
    jmp next_character

draw_white_pixel:
    mov ah, 0x3E
    jmp store_character

draw_black_pixel:
    mov ah, 0x38
    jmp store_character

store_character:
    mov [es:di], ax
    add di, 2
    inc si

next_character:
    loop print_chars
    call timeDelay11
    pop cx
    loop print_lines

ret


successful_game:
call clearscreen
call displayy
call timeDelay11
mov word[fff], 0
mov word [ddd], 2080
call displayy
call tone
    mov ah, 0x00
    int 16h
ret