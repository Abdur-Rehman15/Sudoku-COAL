
index2: dw 108

last_3_rows:
   
   mov si, 0
   mov di, 0

    mov cx,3 ;loop counter for 3 rows
    mov dx,66 ;160 will be added evertime...used for checking line end
    mov si,24 ;horizontal line change after every 3 boxes
    mov bx,1760


    add di,34;for positioning...yahan mul wala formula lgana he
    add dx,di;same as above
    add bx,di


    add si,di ;adjust after positioning


    three_times:


    mov al,186 ;vertical bar (changed to thick bar)
    mov [es:di],ax
    add di,2


    vertical_bars_3:


    add di,6


    cmp di,si
    jnz next1


    mov al,186 ;vertical bar
    mov [es:di],ax
    add di,2
    add si,24
    jmp no_next1


    next1:
    mov al,179 ;vertical bar
    mov [es:di],ax
    add di,2


    no_next1:
    cmp di,dx ;================
    jnz vertical_bars_3
    add dx,160


    add di,6


    mov al,186 ;vertical bar
    mov [es:di],ax
    add di,2


    add di,86


    mov si,di
    add si,24


    mov al,186 ;vertical bar
    mov [es:di],ax
    add di,2


    second_line_3:


    add di,2


    push bx
    push si
    mov si, [index2]
    mov bx, word[grid + si]
    cmp bx, 0
    je qq3
    add bx, 0x30
    mov ax, bx                   ;number 5
    MOV AH, 00110000b
    mov [es:di],ax
    qq3:
    add si, 2
    mov [index2], si
    pop si
    pop bx
    add di,4


    cmp di,si ;================


    jnz next2
    mov al,186 ;vertical bar
    mov [es:di],ax
    add di,2
    add si,24
    jmp no_next2


    next2:
    mov al,179 ;vertical bar
    mov [es:di],ax
    add di,2


    no_next2:
    cmp di,dx ;================
    jnz second_line_3
    add dx,160


    add di,2


    push bx
    push si
    mov si, [index2]
    mov bx, word[grid + si]
    cmp bx, 0
    je qq4
    add bx, 0x30
    mov ax, bx                   ;number 5
    MOV AH, 00110000b
    mov [es:di],ax
    qq4:
    add si, 2
    mov [index2], si
    pop si
    pop bx
    add di,4


    mov al,186 ;vertical bar
    mov [es:di],ax
    add di,2


    add di,86


    mov si,di
    add si,24


    mov al,186 ;vertical bar
    mov [es:di],ax
    add di,2


    third_line_3:


    add di,6


    cmp di,si
    jnz next3
    mov al,186 ;vertical bar
    mov [es:di],ax
    add di,2
    add si,24
    jmp no_next3


    next3:
    mov al,179 ;vertical bar
    mov [es:di],ax
    add di,2


    no_next3:
    cmp di,dx ;================


    jnz third_line_3
    add dx,160
    add di,6


    mov al,186 ;vertical bar
    mov [es:di],ax
    add di,2


    add di,86


    mov si,di
    add si,24


    ;yahan comparing krty hain ky 2lines wali me bhejna ha ya 3r line wali me...


    cmp di,bx ;================
    jz fourth_3rdline_3


    fourth_line_3:


    fourth_2lines_3:


    mov al,199 ;horizontal bar (in place of bottom left corner)
    mov [es:di],ax
    add di,2


    two_lines_next_3:


    mov al,196 ;horizontal bar
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2


    cmp si,di
    jnz next5


    mov al,215 ;horizontal bar
    mov [es:di],ax
    add di,2
    add si,24
    jmp no_next5


    next5:


    mov al,197 ;horizontal bar
    mov [es:di],ax
    add di,2
       
    no_next5:


    cmp di, dx
    jnz two_lines_next_3


    add dx,160


    mov al,196 ;horizontal bar
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2


    mov al,182 ;horizontal bar (in place of bottom right corner)
    mov [es:di],ax
    add di,2


    add di,86


    mov si,di
    add si,24


    jmp loop_check_3


    fourth_3rdline_3:


    mov al,200 ;horizontal bar (in place of bottom left corner)
    mov [es:di],ax
    add di,2


    third_line_next_3:


    mov al,205 ;horizontal bar
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2


    cmp di,si
    jnz next4


    mov al,202 ;horizontal bar (in place of bottom left corner)
    mov [es:di],ax
    add di,2
    add si,24
    jmp no_next4


    next4:
    mov al,207 ;horizontal bar (in place of bottom left corner)
    mov [es:di],ax
    add di,2


    no_next4:
    cmp di, dx
    jnz third_line_next_3


    add dx,160


    mov al,205 ;horizontal bar
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2


    mov al,188 ;horizontal bar (in place of bottom right corner)
    mov [es:di],ax
    add di,2


    add di,86


    mov si,di
    add si,24


    add bx,1920


    loop_check_3:
    dec cx
    cmp cx,0
    jnz three_times

    mov word [index2], 108

;---------BUTTON INSTRUCTIONS FOR GOING DOWN------------

    pusha
    .we_go_up:

        mov di, 596
        mov cx, 14
        mov si, button_go_up
        mov ah, 00110110b

        .going_up:

        mov al, [si]
        mov [es:di], ax
        add di, 2
        add si, 1
        dec cx
        jnz .going_up

        mov al, 24
        mov [es:di], ax

    popa


ret