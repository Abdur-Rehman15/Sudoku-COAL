
%include "src\checks.asm"

blink_box: dw 34
non_blink_box: dw 10110100b
blink_number: dw 0
temp_location: dw 0


  numbers_card_function:
    ;--------Print Number Cards----------
    pusha
    MOV AH, 00110000b

    MOV BX,496
    MOV DI,484
    MOV CX,4
    MOV dl,0x31

    print_cards:
    
    CALL number_cards
    MOV DI,BX
    INC DL
    CALL number_cards
    INC DL
    ADD di,468
    ADD bx,480

    dec cx
    cmp cx,0
    jnz print_cards
    CALL number_cards
    popa
    ret


numbers_card_navigation:

    ;call erase_notes

  mov word [blink_number], 1
  call numbers_card_function
  sttart:
    
    mov ah, 0x00
    int 16h
    
    CMP AH, 0x4D       
    JE rightt ; Jump if right arrow key is pressed

    CMP AH, 0x4B       
    JE leftt ; Jump if left arrow key is pressed

    CMP AH, 0x48      
    JE upp ; Jump if up arrow key is pressed

    CMP AH, 0x50       
    JE downn ; Jump if down arrow key is pressed  
    
    CMP AL, 0x0D       ; Check for Enter key (ASCII 13)
    JE savee
    
    jmp sttart

    rightt:
    mov bx, word [blink_number]
    cmp bx, 9
    jge righttt
    add bx, 1
    jmp startt1
    righttt:
    mov bx, 1
    startt1:
    mov word [blink_number], bx
    call numbers_card_function
    jmp sttart   

    leftt:
    mov bx, word [blink_number]
    cmp bx, 1
    jle lefttt
    sub bx, 1
    jmp startt2
    lefttt:
    mov bx, 9
    startt2:
    mov word [blink_number], bx
    call numbers_card_function
    jmp sttart

    upp:
    mov bx, word [blink_number]
    cmp bx, 2
    jle uppp
    sub bx, 2
    jmp startt3
    uppp:
    mov bx, 9
    startt3:
    mov word [blink_number], bx
    call numbers_card_function
    jmp sttart      


    downn:
    mov bx, word [blink_number]
    cmp bx, 8
    jge downnn
    add bx, 2
    jmp startt4
    downnn:
    mov bx, 1
    startt4:
    mov word [blink_number], bx
    call numbers_card_function
    jmp sttart   

savee:

    call click_sound

    mov ax, 0xb800
    mov es, ax
    xor ax, ax

    call return_location_on_grid
    xor bx, bx
    mov bx, word [blink_number]
    mov si, save_count
    add si, bx
    dec si
    inc word [si]             ; Increment save count for the current number

    mov di, word [temp_location]

    push si
    push bx
    mov bx, word [grid + di]
    mov si, undo_value_array
    push si
    mov si, bx
    push si
    call insertAtStart

    mov si, undo_location_array
    push si
    mov si, di
    push si
    call insertAtStart

    mov di, word [temp]     
    mov si, undo_temp_array
    push si
    mov si, di
    push si
    call insertAtStart
    pop bx
    pop si
    
    mov di, word [temp_location]    
    mov bx, word [blink_number]
    
    mov word [grid + di], bx
    add bl, 0x30
    mov bh, 0x30
    mov di, word [temp]
    mov [es: di], bx
    mov bx, 0
    mov word [blink_number], bx

    call numbers_card_function
    ret


zeroo:
mov ax, 35
jmp aga

nine:
mov ax, 150
jmp aga

thirteen:
mov ax, 100
jmp aga

twenty_one:
mov ax, 101
jmp aga



return_location_on_grid:
pusha
    mov ax, [current_row]
    cmp ax, 0
    je zeroo
    cmp ax, 9
    je nine
    cmp ax, 13
    je thirteen
    cmp ax, 21
    je twenty_one
    
    aga:
    mov bx, [current_col]
    xor dx, dx
    mul bx
    xor si, si
    xor di, di
    
search_loop:
    mov bx, [grid_locations + si]
    cmp ax, bx
    je found_value
    add si, 2
    add di, 2
    cmp si, 162
    jl search_loop
    found_value:
    mov word [temp_location], di
popa
    ret

