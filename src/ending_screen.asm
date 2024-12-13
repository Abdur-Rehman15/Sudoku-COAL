;---------Ending Screen Display Subroutine-------------

jmp ending_screen

%include "C:\COAL_new\Code\print_string.asm"


print_number_at_position:
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    mov ax, 0xb800
    mov es, ax
    mov ax, [bp+4]
    mov bx, 80
    mul bx
    add ax, [bp+6]
    shl ax, 1
    mov di, ax
    mov ax, [bp+8]
    mov bx, 10
    mov cx, 0
convert_to_digits:
    mov dx, 0
    div bx
    add dl, 0x30
    push dx
    inc cx
    cmp ax, 0
    jnz convert_to_digits
print_digits:
    pop dx
    mov dh, 0x34
    mov [es:di], dx
    add di, 2
    loop print_digits
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp
    ret 6


failed:         db 'Failed', 0
length6:        dw 6
game_completed: db 'Game Completed', 0
length7:        dw 14
successful:     db 'Successful', 0
length8:        dw 10
score_last:          db 'Score', 0
length9:        dw 5
time:           db 'Time', 0
length10:       dw 4
mistakes_last:       db 'Mistakes', 0
length11:       dw 8
new_game:       db 'Press 1 for New Game', 0
length12:       dw 20
exit:           db 'Press Esc for Exit', 0
length13:       dw 18
time_value:     db '12:45', 0
length14:       dw 5
score_value:    db '1234', 0
length15:       dw 4
mistakes_value: db '3', 0
length16:       dw 1
           
timeDelay:

push cx
mov cx, 0xffff

loop1:

sub cx, 1
cmp cx, 0x0
jne loop1

pop cx

ret


Draw_border2:
    push es
    push ax
    push di

    mov ax, 0xb800
    mov es, ax

    mov bx, 4
    mov ax, 160
    mul bx
    add ax, 34
    mov di, ax
    mov cx, 40


top_border2:
    mov word [es:di], 0x1F3D
    add di, 2
    call timeDelay
    dec cx
    jnz top_border2
    
    call timeDelay

    mov bx, 5
    mov ax, 160
    mul bx
    add ax, 112
    mov di, ax
    mov cx, 11


right_border2:
    mov word [es:di], 0x1F3D
    add di, 160
    call timeDelay
    dec cx
    jnz right_border2
    call timeDelay

mov bx, 15
    mov ax, 160
    mul bx
    add ax, 32
    mov di, ax
    add di, 80
    mov cx, 40
    

bottom_border2:
    mov word [es:di], 0x1F3D
    sub di, 2
    call timeDelay
    dec cx
    jnz bottom_border2
    call timeDelay

    mov bx, 15
    mov ax, 160
    mul bx
    add ax, 34
    mov di, ax
    mov cx, 11


left_border2:
    mov word [es:di], 0x1F3D
    sub di, 160
    call timeDelay
    dec cx
    jnz left_border2
    call timeDelay

    pop di
    pop ax
    pop es


ret

ending_screen:
    cmp word [mistakes_count], 3
    jne zz
    call game_is_over
    zz:
    call clearscreen
    call Draw_border2
    
    ; Print "Game Completed"
    mov ax, 30
    push ax
    mov ax, 9
    push ax
    mov ax, 0x3A
    push ax
    mov ax, game_completed
    push ax
    push word [length7]
    call print_string

    ; Print "Score"
    mov ax, 11
    push ax
    mov ax, 18
    push ax
    mov ax, 0x1B
    push ax
    mov ax, score_last
    push ax
    push word [length9]
    call print_string
 
    ; Print Score Value
    mov ax, word [score_count]
    push ax
    mov ax, 18
    push ax
    mov ax, 18
    push ax
    call print_number_at_position  
    
    ; Print "Time"
    mov ax, 35
    push ax
    mov ax, 18
    push ax
    mov ax, 0x1B
    push ax
    mov ax, time
    push ax
    push word [length10]
    call print_string

    call last_time

    ; Print "Mistakes"
    mov ax, 55
    push ax
    mov ax, 18
    push ax
    mov ax, 0x1B
    push ax
    mov ax, mistakes_last
    push ax
    push word [length11]
    call print_string

    ; Print Mistakes Value
    mov ax, word [mistakes_count]
    push ax
    mov ax, 65
    push ax
    mov ax, 18
    push ax
    call print_number_at_position  

    ; Print "New Game"
    mov ax, 28
    push ax
    mov ax, 20
    push ax
    mov ax, 0x3B
    push ax
    mov ax, new_game
    push ax
    push word [length12]
    call print_string

    ; Print "Exit"
    mov ax, 29
    push ax
    mov ax, 22
    push ax
    mov ax, 0x3B
    push ax
    mov ax, exit
    push ax
    push word [length13]
    call print_string
    bb:
    MOV AH, 0x00       ; BIOS keyboard interrupt to read a key
    INT 0x16           ; Call BIOS interrupt
    mov word [ending_screen_flag], 0
    CMP AH, 0x01       
    JE end     ; Jump if Esc key is pressed

    CMP AH, 0x02       
    JE start     ; Jump if 1 is pressed
    jmp bb

    ret

clearscreen:
    push es
    push ax
    push di

    mov ax, 0xb800          
    mov es, ax              
    xor di, di


clear_loop:
    mov word [es:di], 0x3820
    add di, 2
    cmp di, 4000
    jne clear_loop


    pop di
    pop ax
    pop es
    ret


