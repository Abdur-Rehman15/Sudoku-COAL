undo_value_array:    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
undo_location_array: dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
undo_temp_array:     dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
display_flag: dw 0     ;0 for display, 1 for not display
temp1:  dw 0

deleteFirst:
    push bp
    mov bp, sp
    pusha
    mov si, [bp + 4]
    mov cx, 79
    mov di, si

Lop1:
    mov ax, [si + 2]
    mov [di], ax
    add si, 2
    add di, 2
    loop Lop1
    mov bx, 0
    mov word [di], bx
    popa
    pop bp
    ret 2

insertAtStart:
    push bp
    mov bp, sp
    pusha
    mov ax, [bp + 4]
    mov si, [bp + 6]
    mov cx, 79
    mov di, cx
    shl di, 1
    add si, di

Lop2:
    mov bx, [si - 2]
    mov [si], bx
    sub si, 2
    loop Lop2

    mov [si], ax
    popa
    pop bp
    ret 4

undoo:
    pusha
    mov ax, 0xb800
    mov es, ax
    mov si, undo_value_array
    mov ax, [si]

    mov si, undo_location_array
    mov di, [si]

    mov si, undo_temp_array
    mov bx, [si]

    mov si, undo_value_array
    push si
    call deleteFirst

    mov si, undo_location_array
    push si
    call deleteFirst

    mov si, undo_temp_array
    push si
    call deleteFirst

    mov word [grid + di], ax

    mov di, bx
    cmp ax, 0
    je ll 
    add al, 0x30
    mov ah, 0x30
    mov [es: di], ax
    jmp undo_end
ll:
    mov bx, 0x3020
    mov [es: di], bx

undo_end:
    mov word [display_flag], 1
    mov ax, word [temp]
    mov word [temp1], ax
    popa
    jmp check_arrow_keys

erasee:
    pusha
    call return_location_on_grid
    mov di, word [temp_location]
    mov ax, word [grid + di]
    mov bx, 0
    mov word [grid + di], bx

    mov si, undo_value_array
    push si
    mov si, ax
    push si
    call insertAtStart
    
    mov bx, word [temp]
    mov si, undo_temp_array
    push si
    mov si, bx
    push si
    call insertAtStart

    mov si, undo_location_array
    push si
    mov si, di
    push si
    call insertAtStart

    call return_location_on_grid
    mov di, word [temp_location]
    mov ax, word [grid + di]
    mov bx, 0
    mov word [grid + di], bx

    mov bx, 0x3020
    mov di, word [temp]
    mov [es:di], bx
    mov word [display_flag], 1
    mov ax, word [temp]
    mov word [temp1], ax
    popa
    call numbers_card_function

    ; ADD word [current_col], 4
    ; ADD word [current_coll_index], 1
    

    ; CMP word [current_col], 46
    ;     JG .increment_rows1

    ;     .increment_cols1:
    ;     ADD word [current_col], 4
    ;     ADD word [current_coll_index], 1
    ;     CALL navigate_grid
    ;     JMP check_arrow_keys

    ;     .increment_rows1:
    ;     cmp word [grid_flag], 1
    ;     JE .for_scrolled_grid1

    ;     .for_scrolled_grid1:
    ;     CMP word [current_row], 8
    ;     JE .go_left1

    ;     .go_left1:
    ;     SUB word [current_col], 4
    ;     SUB word [current_coll_index], 1
    ;     CALL navigate_grid
    ;     JMP check_arrow_keys
        
    ;     ADD word [current_row], 4
    ;     ADD word [current_roww_index], 1
    ;     CALL navigate_grid
    
    ; .increment_end1:
    
    ; JMP check_arrow_keys

    call navigate_grid


    jmp check_arrow_keys
