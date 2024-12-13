
notess: times 3645 dw 0
notess1: times 3645 dw 0
middle_location: dw 0
is_middle_5: dw 0
max_in_one_row: dw 0
is_3_reached: dw 0
is_bar: dw 0
save_lower_grid: times 18*27 dw 0
is_scrolled_once: dw 0

input_notes:

    ; press 'n' to enable notes
    ; clear the navigation box
    ; draw cursor in the middle of the grid box
    ; take keyboard input of numbers
    ; after taking input, draw that number and draw navigation box on the next grid box (if not last)
    ; the entered number will be drawn according to its position and saved in notess array as well
    ; make 9 checks and add / subtract accordingly from middle position and draw the number. (cont'd)
    ; in this way, any other number input other than numbers will also be handled


    pusha

    mov ax, 0xb800
    mov es, ax

    mov ax, 160
    mul word [current_row]
    add ax, 162
    
    add ax, [current_col]
    add ax, [current_col]
    
    push ax

    mov si, ax

    ; clear navigation box

    pusha
    mov cx, 9
    mov bx, 3
    mov di, si
    sub di, 162 ; for going to top left of grid box
    mov ax, 0xb800
    mov es, ax
    mov ah, 00110000b
    mov al, ' ' 

    .clear_box:
    
        mov word [es: di], ax
        add di, 2
        dec cx
        dec bx
        jnz .clear_box

        .update_clear:
            add di, 154
            mov bx, 3
            cmp cx, 0
            jnz .clear_box

    ; get position of middle of grid box

    popa

    pop di
    push di
    push di

    mov ah, 10110000b
    mov al, '|'
    mov word [middle_location], di

    stosw

    mov ax, 54
    mov bx, 9
    mul bx
    mul word [current_roww_index]

    mov bx, ax
    mov ax, 6
    mov cx, word [current_coll_index]
    mul cx
    add ax, bx
    ; shl bx, 1
    ; add ax, bx
    ; mul word [current_coll_index]
    ; add ax, bx 

    add ax, notess ; now we have notess array exact position in correspondence to grid box
    push ax

    pop si
    pop di
    push di
    push si

    mov cx, 9
    mov bx, 3
    ;sub si, 56
    mov ah, 01110000b
    sub di, 162

    .draw_prior:
        cmp word [si], 0
        jz .dont_draw
        mov al, [si]
        mov [es:di], ax

        .dont_draw:
            dec bx
            jnz .updatee
            dec cx
            jz .take_notes_input
            mov bx, 3
            add si, 50
            add di, 156

        jmp .draw_prior

        .updatee:
            add si, 2
            add di, 2
            dec cx
            jnz .draw_prior

    .take_notes_input:
        
        xor ax, ax
        int 16h

        xor dx, dx
        mov dl, al
        sub dl, 48 ; now dl has the entered note number
        cmp dl, 5
        JNE .middle_isnt_5

        mov word [is_middle_5], 1

        .middle_isnt_5:

            pop si
            pop di
            ;sub si, 56 ; now si points to top left of notess array for that corresponding grid box
            mov cx, 1
            mov bx, 3
            sub di, 162 ; starting position to print notes for that grid box

            .display_and_assign_notes:

                .dont_save_location:

                cmp word [si], 0
                JE .if_zero

                mov ah, 01110000b
                mov al, byte [si]
                mov [es:di], ax

                .if_zero:
                    cmp dx, cx
                    JNE .dont_assign

                    .assign_notes_value:
                        add dl, 48
                        mov word [si], dx ; now notess array has notes number
                        mov ah, 01110000b
                        mov al, [si]
                        mov [es:di], ax
                    
                    .dont_assign:
                        dec bx
                        jnz .update_notes_loop
                        inc cx
                        cmp cx, 10
                        jz .middle_print
                        mov bx, 3
                        add si, 50
                        add di, 156

                jmp .display_and_assign_notes

                .update_notes_loop:
                    add si, 2
                    add di, 2
                    inc cx
                    cmp cx, 10
                    jnz .display_and_assign_notes

        .middle_print:
        pop di
        cmp word [is_middle_5], 1
        JNE .remove_cursor

        .print_5:
            mov word [is_middle_5], 0
            mov ah, 01110000b
            mov al, '5'
            mov [es:di], ax
            jmp .exittt

        .remove_cursor:
            mov ah, 00110000b
            mov al, ' '
            mov [es:di], ax

.exittt:

    popa
    ret

erase_notes:

pusha

    mov ax, 54
    mov bx, 9
    mul bx
    mul word [current_roww_index]

    mov bx, ax
    mov ax, 6
    mov cx, word [current_coll_index]
    mul cx
    add ax, bx
    ; shl bx, 1
    ; add ax, bx
    ; mul word [current_coll_index]
    ; add ax, bx 

    add ax, notess ; now we have notess array exact position in correspondence to grid box
    mov si, ax

    mov ax, 160
    mul word [current_row]
    add ax, 162
    
    add ax, [current_col]
    add ax, [current_col]

    mov di, ax

    mov cx, 9
    mov bx, 3
    sub di, 162 ; for going to top left of grid box

    ;sub si, 56
    
    mov ah, 00110000b
    mov al, ' ' 

    .clear_notes:
        mov word [si], 0
        mov word [es: di], ax
        add di, 2
        add si, 2
        dec cx
        dec bx
        jnz .clear_notes

        .update_clear_notes:
            add di, 154
            add si, 48
            mov bx, 3
            cmp cx, 0
            jnz .clear_notes

popa

ret


print_notes_on_scrolling:
    pusha

    ; Set max_in_one_row for a full row of notes (9 grid boxes × 3 notes per grid box)
    mov word [max_in_one_row], 27
    mov di, 196              ; Starting screen position (row 0, col 0 in video memory)
    mov si, notess           ; Start of the notess array
    mov cx, 0                ; Column counter for notes
    mov bx, 0                ; Row counter for notes
    mov word [is_bar], 0     ; Reset subgrid column tracker
    mov word [is_3_reached], 0 ; Reset subgrid row tracker

    ; Check if we're displaying the first 6 rows or last 3 rows
    cmp word [grid_flag], 1
    JE .scroll_last_rows     ; If grid_flag = 0, show last 3 rows

.scroll_first_rows:
    mov dx, 54               ; Total notes for the first 6 rows (6x9 grid boxes × 9 notes)
    jmp .print_notes

.scroll_last_rows:
    ; Adjust SI to point to the last 3 rows (from the 27x27 grid)
    mov di, 36
    mov dx, 27               ; Total notes for the last 3 rows (3x9 grid boxes × 9 notes)
    mov ax, 54
    mov cx, 27
    mul cx
    add si, ax               ; Move SI to the last 3 rows
    
    jmp .print_notes

.print_notes:
    cmp word [si], 0         ; Check if a note exists at the current position
    JE .skip_zero

    ; Print the note (move it to the screen)
    mov ax, [si]             ; Load note value (word, as per `notess` definition)
    mov ah, 01110000b        ; Set text color
    mov [es:di], ax          ; Write note to video memory

.skip_zero:
    inc word [is_bar]        ; Increment subgrid column tracker
    cmp word [is_bar], 3     ; Check if we've completed 3 notes (a subgrid row)
    JE .next_subgrid_row
    add di, 2                ; Move to the next column on the screen
    add si, 2                ; Move to the next note in the `notess` array
    inc cx                   ; Increment the column counter
    cmp cx, [max_in_one_row] ; Check if the row is complete
    JE .next_visible_row
    jmp .print_notes

.next_subgrid_row:
    mov word [is_bar], 0     ; Reset subgrid column tracker
    add di, 4                ; Adjust DI for the next subgrid row
    add si, 2                ; Move SI to the next subgrid row
    inc cx                   ; Increment the column counter
    cmp cx, [max_in_one_row] ; Check if the row is complete
    JNE .print_notes

.next_visible_row:
    add di, 88               ; Move DI to the start of the next visible row (video memory layout)
    mov cx, 0                ; Reset column counter
    inc word [is_3_reached]  ; Increment the subgrid row tracker
    cmp word [is_3_reached], 9
    JNE .continue_visible_rows
    sub di, 800              ; Skip one row if the visible portion is complete
    mov word [is_3_reached], 0

.continue_visible_rows:
    inc bx                   ; Increment the overall row counter
    cmp bx, dx               ; Check if all rows for the visible portion are printed
    JNE .print_notes

    popa
    ret


saving_lower_grid:

    pusha

    mov di, 34
    mov cx, 37 ;for every iteration
    mov dx, 12
    mov bx, 0 ;bx==dx
    mov si, save_lower_grid


    .saving_scrolled_grid:

        mov ax, word [es:di]
        cmp al, 218
        jz .dont_save_navigation_box
        cmp al, 196
        jz .dont_save_navigation_box
        cmp al, 191
        jz .dont_save_navigation_box
        cmp al, 179
        jz .dont_save_navigation_box
        cmp al, 154
        jz .dont_save_navigation_box
        cmp al, 192
        jz .dont_save_navigation_box
        cmp al, 217
        jz .dont_save_navigation_box

        .save_as_it_as:

        mov word [si], ax

        add si, 2
        add di, 2
        dec cx
        jnz .saving_scrolled_grid
        mov cx, 37
        add di, 86
        inc bx
        cmp bx, dx
        jz .end_of_saving

        jmp .saving_scrolled_grid

        .dont_save_navigation_box:

            cmp ah, 10110000b
            jnz .save_as_it_as

            mov ah, 00110000b
            mov al, ' '
            mov [si], ax

        add si, 2
        add di, 2
        dec cx
        jnz .saving_scrolled_grid
        mov cx, 37
        add di, 86
        inc bx
        cmp bx, dx
        jnz .saving_scrolled_grid

    .end_of_saving:

    mov ax, 160
    mul word [current_row]
    add ax, 162
    
    add ax, [current_col]
    add ax, [current_col]
    mov di, ax
    sub di, 162

    popa
    ret

displaying_scrolled_grid:

    pusha

    mov di, 34
    mov cx, 37 ; for every iteration
    mov dx, 12
    mov bx, 0 ; bx == dx
    mov si, save_lower_grid

    .display_scrolled_grid:

        mov ax, word [si]
        ; mov al, 01000111b
        ; mov al, '-'
        mov [es:di], ax
        add di, 2
        add si, 2
        dec cx
        jnz .display_scrolled_grid
        mov cx, 37
        add di, 86
        inc bx
        cmp bx, dx
        jnz .display_scrolled_grid

    popa
    ret