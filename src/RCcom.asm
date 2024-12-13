

well_done_text: db 'WELL-DONE'
superb_text: db 'SUPERB'
wow_text: db 'WOW'
sizeW: dw well_done_text-sizeW 
store_before_text: times 9 db 0

display_horizontally:

    pusha

    xor si, si
    xor di, di

    mov ax, 0xb800
    mov es, ax
    
    cmp word [grid_flag], 0
    JNE .one_down

    .two_down:
    mov di, 358

    .start_displaying:
    xor ax, ax
    mov ax, 640
    mov dx, [current_roww_index]
    mul word dx
    add di, ax
    push di
    mov si, well_done_text
    mov cx, 9
    mov ah, 10110001b
    mov bx, 0

    .print_wellDone_text:
        mov dl, [es:di]
        mov byte [store_before_text + bx], dl
        mov al, [si]
        mov [es:di], ax
        add bx, 1
        add di, 8
        add si, 1
        dec cx
        jnz .print_wellDone_text

    mov cx, 0x300
    .stay_there:
    call delay
    loop .stay_there
   
    pop di
    mov bx, 0
    mov cx, 9
    mov ah, 00110000b

    .print_previous_again:
        mov al, [store_before_text + bx]
        mov [es:di], ax
        add di, 8
        add bx, 1
        dec cx
        jnz .print_previous_again

    popa
    ret


.one_down:
    mov di, 198
    
    xor ax, ax
    mov ax, 640
    mov dx, [current_roww_index]
    sub dx, 6
    mul word dx
    add di, ax
    push di
    mov si, well_done_text
    mov cx, 9
    mov ah, 10110001b
    mov bx, 0

    .print_wellDone_text0:
        mov dl, [es:di]
        mov byte [store_before_text + bx], dl
        mov al, [si]
        mov [es:di], ax
        add bx, 1
        add di, 8
        add si, 1
        dec cx
        jnz .print_wellDone_text0

    mov cx, 0x300
    .stay_there0:
    call delay
    loop .stay_there0
   
    pop di
    mov bx, 0
    mov cx, 9
    mov ah, 00110000b

    .print_previous_again0:
        mov al, [store_before_text + bx]
        mov [es:di], ax
        add di, 8
        add bx, 1
        dec cx
        jnz .print_previous_again0

    popa
    ret



display_vertically:

    pusha

    xor si, si
    xor di, di

    mov ax, 0xb800
    mov es, ax
    
    cmp word [grid_flag], 0
    JNE .one_down1 ;if scrolled, then we've to display WOW

    .two_down1:
    mov di, 358 ;skip 0th and 1st row

    .start_displaying1:
    
    mov ax, 8
    mov dx, [current_coll_index]
    mul dx
    add di, ax
    push di
    mov si, superb_text
    mov cx, 6
    mov ah, 10110001b
    mov bx, 0

    .print_wellDone_text1:
        mov dl, [es:di]
        mov byte [store_before_text + bx], dl
        mov al, [si]
        mov [es:di], ax
        add bx, 1
        add di, 640
        add si, 1
        dec cx
        jnz .print_wellDone_text1

    mov cx, 0x300

    .stay_there1:
    call delay
    loop .stay_there1

    pop di
    mov bx, 0
    mov cx, 9
    mov ah, 00110000b

    .print_previous_again1:
        mov al, [store_before_text + bx]
        mov [es:di], ax
        add di, 640
        add bx, 1
        dec cx
        jnz .print_previous_again1

    popa
    ret

.one_down1:

    mov di, 198 ;skip 0th row

    mov ax, 8
    mov dx, [current_coll_index]
    mul dx
    add di, ax
    push di
    mov si, wow_text
    mov cx, 3
    mov ah, 10110001b
    mov bx, 0

    .print_wellDone_text2:
        mov dl, [es:di]
        mov byte [store_before_text + bx], dl
        mov al, [si]
        mov [es:di], ax
        add bx, 1
        add di, 640
        add si, 1
        dec cx
        jnz .print_wellDone_text2

    mov cx, 0x300

    .stay_there2:
    call delay
    loop .stay_there2

    pop di
    mov bx, 0
    mov cx, 3
    mov ah, 00110000b

    .print_previous_again2:
        mov al, [store_before_text + bx]
        mov [es:di], ax
        add di, 640
        add bx, 1
        dec cx
        jnz .print_previous_again2

popa
ret