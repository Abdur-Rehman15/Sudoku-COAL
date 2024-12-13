jmp navigate_grid

current_row: dw 0
current_col: dw 0
current_row_index: dw 0
current_col_index: dw 0
max_rows: dw 0
max_cols: dw 0
min_rows: dw 0
min_cols: dw 0
save_previous_data: dw 0, 0, 0, 0, 0, 0, 0, 0, 0
location_for_previous_data: dw 0
temp: dw 0


navigate_grid:

    pusha

    mov ax, 0xb800
    mov es, ax
    xor ax, ax
    mov al, 80
    mul word [current_row]
    add ax, [current_col]
    shl ax, 1

    mov word [location_for_previous_data], ax

    mov si, ax ;for saving previous data
    mov cx, 0
    mov bx, 3
    mov di, 0

    .save:
    mov dx, [es:si]
    mov word [save_previous_data + di], dx
    add si, 2
    add di, 2
    inc cx
    dec bx
    jnz .save
    add si, 154
    mov bx, 3
    cmp cx, 9
    jnz .save

    mov di, ax ;now di points to the starting of box to be highlighted
    mov bx, 3 ;count for rows highligting

    mov ah, 10110000b

    mov al, 218
    stosw
    mov al, 196
    stosw
    mov al, 191
    stosw

    add di, 154

    mov al, 179
    stosw
    mov word [temp], di
    add di, 2
    mov al, 179
    stosw

    add di, 154

    mov al, 192
    stosw
    mov al, 196
    stosw
    mov al, 217
    stosw

    popa

ret


print_saved_data:

    pusha 
    ;load starting location in si
    mov cx, 0
    mov bx, 3
    mov di, 0 
    mov ax, 0xb800
    mov es, ax
    mov di, 0

    .print_previous:
    
    mov dx, [save_previous_data + di]
    mov word [es: si], dx
    add si, 2
    add di, 2
    inc cx
    dec bx
    jnz .print_previous
    add si, 154
    mov bx, 3
    cmp cx, 9
    jnz .print_previous
    cmp word [display_flag], 1
    jne kk
    mov di, word [temp1]
    mov ax, 0x3020
    mov word [es: di], ax
    kk:
    mov word [display_flag], 0    
    mov si, 0
    mov di, 0
    mov bx, word [grid_flag]
    cmp bx, 1
    je ee
    call print_boxes
    jmp ea
    ee:
    MOV ah,00110000b
    call last_3_rows
    ea:
    popa

ret