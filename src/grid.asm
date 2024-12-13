
index1: dw 0

; ---------Print Grid---------------                


print_boxes:

   mov si, 0
   mov di, 0
        
    mov cx,6 ;loop counter for 6 rows
    mov dx,66 ;160 will be added evertime...used for checking line end
    mov si,24 ;horizontal line change after every 3 boxes
    mov bx,1920 ;used for comparison to see if 3 row is reached after every 2nd row


    add di,4
   
    MOV AH, 00110000b


    add di,30 ;for positioning--------------
    add dx,di;same as above
    add bx,di


    add si,di ;adjust after positioning


    mov al,201 ;top left corner
    mov [es:di],ax
    add di,2


    horizontal_bars:


    mov al,205 ;double horizontal bar
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2


    cmp di,si ;after every 3 boxes
    jnz .next


    mov al,203 ;double line after every 3 boxes
    mov [es:di],ax
    add di,2
    add si,24
    jmp .no_next


    .next:
    mov al,209 ;double horizontal + single vertical
    mov [es:di],ax
    add di,2


    .no_next:
    cmp di,dx
    jnz horizontal_bars
    add dx,160


    mov al,205 ;double horizontal bar
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2


    mov al,187 ;top right corner
    mov [es:di],ax
    add di,2


    add di,86 ;next line
    mov si,di
    add si,24


    nine_times:


    mov al,186 ;double vertical bar
    mov [es:di],ax
    add di,2


    vertical_bars:


    add di,6


    cmp di,si
    jnz .next1


    mov al,186 ;double vertical bar
    mov [es:di],ax
    add di,2
    add si,24
    jmp .no_next1


    .next1:
    mov al,179 ;single vertical bar
    mov [es:di],ax
    add di,2


    .no_next1:
    cmp di,dx ;================
    jnz vertical_bars


    add dx,160


    add di,6


    mov al,186 ;double vertical bar
    mov [es:di],ax
    add di,2


    add di,86


    mov si,di
    add si,24


    mov [es:di],ax
    add di,2


    second_line:


    add di,2
    
    push bx
    push si
    mov si, [index1]
    mov bx, word [grid + si]
    cmp bx, 0
    je qq1
    add bx, 0x30
    mov ax, bx                   ;number 5
    MOV AH, 00110000b
    mov [es:di],ax
    qq1:
    add si, 2
    mov [index1], si
    pop si
    pop bx
    add di,4

    cmp di,si
    jnz .next2
    mov al,186 ;double vertical bar
    mov [es:di],ax
    add di,2
    add si,24
    jmp .no_next2


    .next2:
    mov al,179 ;single vertical bar
    mov [es:di],ax
    add di,2


    .no_next2:
    cmp di,dx ;================
    jnz second_line
    add dx,160


    add di,2


    push bx
    push si
    mov si, [index1]
    mov bx, word [grid + si]
    cmp bx, 0
    je qq2
    add bx, 0x30
    mov ax, bx                   ;number 5
    MOV AH, 00110000b
    mov [es:di],ax
    qq2:
    add si, 2
    mov [index1], si
    pop si
    pop bx
    add di,4

    mov al,186 ;double vertical bar
    mov [es:di],ax
    add di,2


    add di,86


    mov si,di
    add si,24


    mov [es:di],ax
    add di,2


    third_line:


    add di,6


    cmp di,si
    jnz .next3
    mov al,186 ;double vertical bar
    mov [es:di],ax
    add di,2
    add si,24
    jmp .no_next3


    .next3:
    mov al,179 ;single vertical bar
    mov [es:di],ax
    add di,2


    .no_next3:
    cmp di,dx ;================


    jnz third_line
    add dx,160
    add di,6


    mov al,186 ;vertical bar
    mov [es:di],ax
    add di,2


    add di,86


    mov si,di
    add si,24


    ;yahan comparing krrhy hain ky 2lines wali me bhejna ha ya 3rd line wali me


    cmp di,bx ;S==============
    jz fourth_3rdline


    fourth_line:


    .fourth_2lines:


    mov al,199 ;double vertical bar + single horizontal bar
    mov [es:di],ax
    add di,2


    .two_lines_next:


    mov al,196 ;horizontal bar
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2


    cmp si,di
    jnz .next5


    mov al,215 ;cross double vertical bar + single horizontal bar
    mov [es:di],ax
    add di,2
    add si,24
    jmp .no_next5


    .next5:


    mov al,197 ;cross single bars
    mov [es:di],ax
    add di,2


    .no_next5:


    cmp di, dx
    jnz .two_lines_next


    add dx,160


    mov al,196 ;single horizontal bar
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2


    mov al,182 ;right border double vertical bar + single horizontal bar
    mov [es:di],ax
    add di,2


    add di,86


    mov si,di
    add si,24


    jmp loop_check


    fourth_3rdline:


    mov al,204 ;double bars
    mov [es:di],ax
    add di,2


    third_line_next:


    mov al,205 ;double bars
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2


    cmp di,si
    jnz .next4


    mov al,206 ;cross double bars
    mov [es:di],ax
    add di,2
    add si,24
    jmp .no_next4


    .next4:
    mov al,216 ;cross double horizontal bar + single vertical bar
    mov [es:di],ax
    add di,2


    .no_next4:
    cmp di, dx
    jnz third_line_next


    add dx,160


    mov al,205 ;double horizontal bar
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2
    mov [es:di],ax
    add di,2


    mov al,185 ;right border double horizontal bar + double vertical bar
    mov [es:di],ax
    add di,2


    add di,86


    mov si,di
    add si,24


    add bx,1920


    loop_check:
    dec cx
    cmp cx,0
    jnz nine_times
    mov word[index1], 0

ret