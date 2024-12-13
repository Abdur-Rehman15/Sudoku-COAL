[org 0x0100]

    JMP start

%include "src\number_cards.asm"
%include "src\grid.asm"
%include "src\options_box.asm"
%include "src\scrolled_grid.asm"
%include "src\ending_screen.asm"
%include "src\display_difficulty.asm"
%include "src\opening_screen.asm"
%include "src\grid_navigation.asm"
%include "src\timer.asm"
%include "src\melody.asm"
%include "src\input.asm"
%include "src\erase_&_undo.asm"
%include "src\gameover.asm"
%include "src\successful.asm"
%include "src\notes_input.asm"
%include "src\difficulty_boards.asm"
%include "src\RCcom.asm"


;----------TEXT TO DISPLAY IN GAME------------

difficulty_text: db 'DIFFICULTY:'
size22: dw size22-difficulty_text
difficulty_easy: db 'EASY'
size1: dw size1-difficulty_easy
difficulty_medium: db 'MEDIUM'
size2: dw size2-difficulty_medium
difficulty_hard: db 'HARD'
size3: dw size3-difficulty_hard
score: db 'SCORE :'
size4: dw size4-score
timerr: db '00:11'
size5: dw size5-timerr
time_display: db 'TIMER:'
size61: dw size61-time_display
button_go_down: db 'PRESS `S` FOR   '
button_go_up:   db 'PRESS `W` FOR   '
grid_flag: dw 0   ; 0 for upper portion of grid and 1 for lower portion of grid
ending_screen_flag: dw 0
score_count: dw 0


grid_locations: dw   18,   22,   26,    30,   34,   38,    42,   46,   50 
                dw   90,  110,  130,   150,  170,  190,   210,  230,  250 
                dw 2700, 3300, 3900,  4500, 5100, 5700,  6300, 6900, 7500

                dw 1800, 2200, 2600,  3000, 3400, 3800,  4200, 4600, 5000 
                dw  306,  374,  442,   510,  578,  646,   714,  782,  850 
                dw 1818, 2222, 2626,  3030, 3434, 3838,  4242, 4646, 5050 
                
                dw  630,  770,  910,  1050, 1190, 1330,  1470, 1610, 1750
                dw   72,   88,  104,   120,  136,  152,   168,  184,  200
                dw  144,  176,  208,   240,  272,  304,   336,  368,  400

;row 9    150
;row 13   100
;row 21   101
;row 0    35


;---------------------------------------------

delay:
	push cx
	mov cx,0xFFF
	
lop11: 
	loop lop11

	mov cx,0xFFF
	
lop22: 
	loop lop22

pop cx 
ret


; subroutine to clear the screen

clrscreen:

 push es
 push cx
 push di

 mov ax, 0xb800
 mov es, ax ; point es to video base
 xor di, di ; point di to top left column
 mov al, 0x20 ; space char in normal attribute
 mov cx, 2000 ; number of screen locations
 cld ; auto increment mode
 rep stosw ; clear the whole screen
 
 pop di
 pop cx
 pop es

 ret

section .text
        call hide_cursor

check_key_press:

    mov ah, 0x00
    int 16h

    cmp al, 0x0D ;it is used for "press any key to start"
    je enter_key_for_startingScreen

    cmp ah, 0x48
    je up_key

    cmp ah, 0x50
    je down_key

    jmp key_wait

up_key:
    cmp byte [pointer_flag], 1
    jle wrap_to_bottom
    dec byte [pointer_flag]
    call clrscreen
    call menu_printing
    jmp key_wait

down_key:
    cmp byte [pointer_flag], 3
    jge wrap_to_top
    inc byte [pointer_flag]
    call clrscreen
    call menu_printing
    jmp key_wait

wrap_to_top:
    mov byte [pointer_flag], 1
    call clrscreen
    call menu_printing
    jmp key_wait

wrap_to_bottom:
    mov byte [pointer_flag], 3
    call clrscreen
    call menu_printing
    jmp key_wait

enter_key_for_startingScreen:
    mov bl, byte [pointer_flag]
    mov byte [option], bl

    call clrscreen

    jmp next_start  

check_key_press1:
    mov ah, 0x00
    int 16h

    cmp al, 0x0D  ; Enter key
    je enter_key

    cmp ah, 0x48  ; Up arrow key
    je up_key1

    cmp ah, 0x50  ; Down arrow key
    je down_key1

    jmp check_key_press1

up_key1:
    cmp byte [pointer_flag], 1
    jle wraping_to_bottom
    dec byte [pointer_flag]
    call ending_screen
    jmp check_key_press1

down_key1:
    cmp byte [pointer_flag], 2
    jge wraping_to_top
    inc byte [pointer_flag]
    call ending_screen
    jmp check_key_press1

wraping_to_top:
    mov byte [pointer_flag], 1
    call ending_screen
    jmp check_key_press1

wraping_to_bottom:
    mov byte [pointer_flag], 2
    call ending_screen
    jmp check_key_press1

enter_key:
    mov bl, byte [pointer_flag]
    mov byte [option], bl


;---here we will board and its solution according to selected difficulty---


;====================START==========================


start:

    call clrscr1

    ;initialize row and col for navigating grid
    mov word [current_row], 1
    mov word [current_col], 18
    mov word [max_rows], 21
    mov word [max_cols], 50 
    mov word [min_rows], 1
    mov word [min_cols], 18
    mov word [current_roww_index], 0
    mov word [current_coll_index], 0
    mov word [grid_flag], 0
    mov word [mistakes_count], 0
    mov word [is_row_or_col_complete], 0
    mov word[score_count], 0

    pusha
    call show_title
    popa

    MOV ah,0x1 ;interrupt ------idhr enter key bhi aaskti
    INT 0x21

    CALL clrscreen

    MOV AX, 0xB800
    MOV ES, AX
    MOV SI, 0

    MOV DI, 0
    MOV al,0x20
    MOV ah,00110111b

    call clrscreen

    call menu_printing

key_wait:

    call check_key_press
    jmp key_wait

next_start:

    CALL clrscreen
    call hook_timer_interrupt    ; Hook the timer interrupt


    ;-------Blue Background---------   

    call load_board_difficulty 


draw_grid:

    MOV [ES:DI], AX
    ADD DI, 2

    CMP DI, 4000
    JNZ draw_grid

    MOV AH, 0x47
    MOV DI,360

    call numbers_card_function

    ;-----Display Difficulty----------

    pusha

    mov si, difficulty_text
    mov bx, 0
    mov di, 594
    mov ah, 00110101b

    .display_difficulty_textt:
        mov al, [si]
        mov [es:di], ax
        inc si
        add di, 2
        inc bx
        cmp bx, [size22]
        jnz .display_difficulty_textt

    CMP byte [pointer_flag], 1
    JE .display_easy
    CMP byte [pointer_flag], 2
    JE .display_medium
    CMP byte [pointer_flag], 3
    JE .display_hard

    .display_easy:

    MOV si,difficulty_easy
    MOV dx, [size1]
    jmp .display_difficulty_text

    .display_medium:

    MOV si,difficulty_medium
    MOV dx, [size2]
    jmp .display_difficulty_text

    .display_hard:

    MOV si,difficulty_hard
    MOV dx, [size3]
    jmp .display_difficulty_text

    .display_difficulty_text:

    MOV di,620
    MOV ah,00110001b
    mov bx, 0

    difficulty_display:

    MOV AL, [si]
    MOV [ES:DI], AX
    ADD DI, 2
    inc bx
    INC SI
    CMP bx, dx
    JNZ difficulty_display

    popa

    ;---------Display Score-----------

    MOV ah,00110101b
    MOV si,0
    MOV di,282

    score_display:

    MOV AL, [score + SI]
    MOV [ES:DI], AX
    ADD DI, 2

    INC SI
    CMP SI, [size4]
    JNZ score_display

    push word [score_count]
    call printnum

    ;--------------Display Timer Text---------------

    push di
    push si
    push cx
    push ax
    mov di, 162
    mov si, time_display
    mov cx, 0
    mov bx, 0
    mov ah, 00110101b

        .display_time_text:
            mov al, [si]
            mov [es:di], ax
            add di, 2
            inc bx
            inc si
            inc cx
            cmp cx, word [size61]
            jnz .display_time_text
    
    pop ax
    pop cx
    pop si
    pop di

    ;--------------Display Grid------------------

    MOV si,0
    MOV di,0

    CALL print_boxes

    ;---------BUTTON INSTRUCTION FOR GOING UP------------

    pusha

        mov di, 3954
        mov cx, 14
        mov si, button_go_down
        mov ah, 00110110b

        .going_down:

        mov al, [si]
        mov [es:di], ax
        add di, 2
        add si, 1
        dec cx
        jnz .going_down

        mov al, 25
        mov [es:di], ax

    popa
;---------------------------------------


    ;-------------Display Options Box-------------

    CALL options_box

    CALL print_notes_on_scrolling

    call navigate_grid

    ;-------------Ending Screen Code----------------

    jmp check_arrow_keys

    ;-------------check arrow keys-----------------

    check_arrow_keys:
    cmp word [grid_flag], 0
    JE print_mistakes_count

    key_input:

    MOV AH, 0x00       ; BIOS keyboard interrupt to read a key
    INT 0x16           ; Call BIOS interrupt

;------------FOR SCROLLING---------------------

    CMP AL, 119       
    JE scroll_up_action ; scroll up if 'w' is pressed

    CMP AL, 115       
    JE scroll_down_action ; scroll down if 's' is pressed

    CMP AL, 101       
    JE erase_values_in_grid_box ; erase if 'e' is pressed

    CMP AL, 117       
    JE undoo ; undo if 'u' is pressed

    CMP AL, 'n'       
    JE enable_notes ; enable notes if 'n' is pressed

;-------------FOR GRID NAVIGATION--------------------

    CMP AH, 0x4D       
    JE right_arrow_action ; Jump if right arrow key is pressed

    CMP AH, 0x4B       
    JE left_arrow_action ; Jump if left arrow key is pressed

    CMP AH, 0x48      
    JE up_arrow_action ; Jump if up arrow key is pressed

    CMP AH, 0x50       
    JE down_arrow_action ; Jump if down arrow key is pressed

;-------------ENTER FOR NUMBER NAVIGATION------

    CMP AL, 0x0D       ; Check for Enter key (ASCII 13)
    JE calling_number_cards_navigation

;------FOR GAME END / RESTART-----------------------    

    CMP AH, 0x01       
    JE end     ; Jump if Esc key is pressed


;---------IF NONE OF THE ABOVE--------------------
    

    ;saving previous data before displaying navigation box
    push si
    mov si, word [location_for_previous_data]
    call print_saved_data
    CALL navigate_grid
    pop si

    jmp check_arrow_keys ; if none of the above is compared, go back again 


; ---------CODE FOR HANDLING SCROLL UP---------

    scroll_up_action:
    CMP word [grid_flag], 1
    JNE .normal_scroll_up

    CALL saving_lower_grid

    .normal_scroll_up:

    MOV si,0
    MOV di,0  
    call clrscreen

; here we are updating the conditions to display navigation box for scroll up grid
    mov word [current_row], 1
    mov word [current_col], 18
    mov word [max_rows], 21
    mov word [max_cols], 50 
    mov word [min_rows], 1
    mov word [min_cols], 18
    mov word [grid_flag], 0  
    mov word [current_roww_index], 0
    mov word [current_coll_index], 0

    call draw_grid ;navigate grid is called inside it
   
    JMP check_arrow_keys

; ---------CODE FOR HANDLING SCROLL DOWN---------

    scroll_down_action:

    call clrscreen

    MOV ah,00110000b
    MOV si,0
    MOV di,0
    call numbers_card_function
    call last_3_rows

; here we are updating the conditions to display navigation box for scroll down grid
    mov word [current_row], 0
    mov word [current_col], 18
    mov word [max_rows], 8
    mov word [max_cols], 50 
    mov word [min_rows], 0
    mov word [min_cols], 18
    mov word [grid_flag], 1  
    mov word [current_roww_index], 6
    mov word [current_coll_index], 0

    ;call print_notes_on_scrolling
    CMP word [is_scrolled_once], 1
    JNE .dont_display
    CALL displaying_scrolled_grid

    .dont_display:
    mov word [is_scrolled_once], 1

    pusha
    MOV ah,00110101b
    MOV si,0
    MOV di,282

    score_display1:

    MOV AL, [score + SI]
    MOV [ES:DI], AX
    ADD DI, 2

    INC SI
    CMP SI, [size4]
    JNZ score_display1

    push word [score_count]
    call printnum
    popa

    push di
    push si
    push cx
    push ax
    mov di, 162
    mov si, time_display
    mov cx, 0
    mov bx, 0
    mov ah, 00110101b

        .display_time_text:
            mov al, [si]
            mov [es:di], ax
            add di, 2
            inc bx
            inc si
            inc cx
            cmp cx, word [size61]
            jnz .display_time_text
    
    pop ax
    pop cx
    pop si
    pop di

    call navigate_grid

    JMP check_arrow_keys

; -------CODE FOR HANDLING RIGHT ARROW KEY PRESS----------

    right_arrow_action:

    inc word [current_col_index]
    mov ax, [max_cols]
    cmp word [current_col], ax
    jz check_arrow_keys
    add word [current_col], 4
    add word [current_coll_index], 1

; saving previous data before displaying navigation box
    push si
    mov si, word [location_for_previous_data]
    call print_saved_data
    CALL navigate_grid
    pop si

    JMP check_arrow_keys 

; -------CODE FOR HANDLING LEFT ARROW KEY PRESS----------

    left_arrow_action:

    dec word [current_col_index]
    mov ax, [min_cols]
    cmp word [current_col], ax
    jz check_arrow_keys
    sub word [current_col], 4
    sub word [current_coll_index], 1

; saving previous data before displaying navigation box
    push si
    mov si, word [location_for_previous_data]
    call print_saved_data
    CALL navigate_grid
    pop si

    JMP check_arrow_keys

; -------CODE FOR HANDLING UP ARROW KEY PRESS----------

    up_arrow_action:

    dec word [current_row_index]
    mov ax, [min_rows]
    cmp word [current_row], ax
    jz check_arrow_keys
    sub word [current_row], 4
    sub word [current_roww_index], 1

; saving previous data before displaying navigation box
    push si
    mov si, word [location_for_previous_data]
    call print_saved_data
    CALL navigate_grid
    pop si

    JMP check_arrow_keys

; -------CODE FOR HANDLING DOWN ARROW KEY PRESS----------

    down_arrow_action:

    inc word [current_row_index]
    mov ax, word [max_rows]
    cmp word [current_row], ax
    jz check_arrow_keys
    add word [current_row], 4
    add word [current_roww_index], 1

; saving previous data before displaying navigation box
    push si
    mov si, word [location_for_previous_data]
    call print_saved_data
    CALL navigate_grid
    pop si

    JMP check_arrow_keys   

    calling_number_cards_navigation: 

    CALL numbers_card_navigation
    CALL is_position_valid

    JMP check_arrow_keys

;-------------------TAKE NOTES INPUT-----------------------------

    enable_notes:
        
        CALL input_notes

    move_navigation_box:
        
        CMP word [current_col], 46
        JG .increment_rows

        .increment_cols:
        ADD word [current_col], 4
        ADD word [current_coll_index], 1
        CALL navigate_grid
        JMP check_arrow_keys

        .increment_rows:
        cmp word [grid_flag], 1
        JE .for_scrolled_grid

        .for_scrolled_grid:
        CMP word [current_row], 8
        JE .go_left

        .go_left:
        SUB word [current_col], 4
        SUB word [current_coll_index], 1
        CALL navigate_grid
        JMP check_arrow_keys
        
        ADD word [current_row], 4
        ADD word [current_roww_index], 1
        CALL navigate_grid
    
    .increment_end:
    
    JMP check_arrow_keys

;------------------ERASE GRID BOX VALUES-------------------------


    erase_values_in_grid_box:

        CALL erase_notes
        CALL erasee

        JMP check_arrow_keys


;-------------------PRINT MISTAKES COUNT-------------------------

    print_mistakes_count:

    cmp word [ending_screen_flag], 0
    JNE key_input

    mov ah, 00110001b
    mov di,940
    mov al, [mistakes_count]
    add al, 48
    stosw

    JMP key_input

;---------------------ENDING SCREEN-----------------------------

    display_ending_screen:
    mov word [ending_screen_flag], 1

    call unhook_timer_interrupt
    call ending_screen
    JMP check_arrow_keys

    end:
    call unhook_timer_interrupt
    MOV AX, 0x4C00
    INT 0x21