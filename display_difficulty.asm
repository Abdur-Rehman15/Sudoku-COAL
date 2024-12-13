jmp menu_printing


; Function to print a string at specified x, y with attribute
print_string_1:
    push bp
    mov bp, sp
    push es
    push ax
    push cx
    push si
    push di


    mov ax, 0xb800
    mov es, ax


    mov al, 80
    mul byte [bp + 10]        ; AL * y
    add ax, [bp + 12]         ; Add x position
    shl ax, 1            
    mov di, ax


    mov si, [bp + 6]          ; string memory
    mov cx, [bp + 4]          ; string length
    mov ah, [bp + 8]          ; attribute


printingg:
    mov al, [si]              
    mov [es:di], ax          
    add di, 2                
    add si, 1                    
    sub cx, 1                    
    jnz printingg


    pop di
    pop si
    pop cx
    pop ax
    pop es
    pop bp
    ret 10  



length2:        dw 17
easy:           db '      EASY            ', 0
length3:        dw 17
medium:         db '     MEDIUM         ', 0
length4:        dw 17
hard:           db '      HARD            ', 0
length5:        dw 17
pointer_flag:   db 1
option:         db 1
select_level:   db '   SELECT LEVEL     ', 0


menu_printing:
    mov ax, 32
    push ax
    mov ax, 8
    push ax
    mov ax, 0x1E
    push ax
    mov ax, select_level
    push ax
    push word [length2]
    call print_string_1

    mov ax, 32
    push ax
    mov ax, 11
    push ax
    cmp byte [pointer_flag], 1
    je draw_easy_selected
    jmp draw_easy

draw_easy_selected:
    mov ax, 10001100b
    jmp draw_easy

draw_easy:
    push ax
    mov ax, easy
    push ax
    push word [length3]
    call print_string_1

    mov ax, 32
    push ax
    mov ax, 13
    push ax
    cmp byte [pointer_flag], 2
    je draw_medium_selected
    jmp draw_medium

draw_medium_selected:
    mov ax, 10001100b
    jmp draw_medium

draw_medium:
    push ax
    mov ax, medium
    push ax
    push word [length4]
    call print_string_1

    mov ax, 32
    push ax
    mov ax, 15
    push ax
    cmp byte [pointer_flag], 3
    je draw_hard_selected
    jmp draw_hard

draw_hard_selected:
    mov ax, 10001100b
    jmp draw_hard
    
draw_hard:
    push ax
    mov ax, hard
    push ax
    push word [length5]
    call print_string_1
    ret