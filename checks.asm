is_valid: dw 0
is_row_or_col_complete: dw 0

mistakes_count: dw 0

current_roww_index: dw 0
current_coll_index: dw 0
max_roww_index: dw 0
max_coll_index: dw 0
min_roww_index: dw 0
min_coll_index: dw 0

is_position_valid:

    pusha

    mov ax, 0xb800
    mov es, ax

    xor di, di
    xor si, si

    ; row * 9 + col (assuming row started from 0)
    ; row * 36 to get the starting location of current row
    
; [si] will have entered number so it can be compared with other numbers in its row + column + 3 by 3 subgrid
    mov ax, 18
    mul word [current_roww_index]
    mov si, ax ; now si has the starting location of row
    mov ax, grid
    mov bx, ax
    push bx ; save starting address of grid for further use
    add si, ax ; add grid address to get exact number
    mov bx, si ; now bx also has starting location of row in grid

    mov ax, word [current_coll_index]
    shl ax, 1
    add si, ax

    mov cx, 9

    .check_row:

        cmp si, bx
        jz .updateR
        mov ax, [si]
        cmp ax, [bx]
        jz .invaliddd

        .updateR:
        add bx, 2
        dec cx
        cmp cx, 0
        jnz .check_row

    pop bx ;load starting address of grid to reach till column top


    mov ax, [current_coll_index]
    shl ax, 1
    add bx, ax ; now bx points to the top col value
    push bx

    mov cx, 9

    .check_col:

        cmp si, bx
        jz .updateC
        mov ax, [si]
        cmp ax, [bx]
        jz .invaliddd

        .updateC:
            add bx, 18
            dec cx
            cmp cx, 0
            jnz .check_col

    mov bx, grid ; starting of grid

    .check_subGrid:

        cmp word [current_coll_index], 2
        jbe .first_3C

        cmp word [current_coll_index], 5
        jbe .second_3C

        cmp word [current_coll_index], 8
        jbe .third_3C

        .first_3C:
            add bx, 0
            cmp word [current_roww_index], 2
            jbe .first_3R
            cmp word [current_roww_index], 5
            jbe .second_3R
            cmp word [current_roww_index], 8
            jbe .third_3R

        .second_3C:
            add bx, 6
            cmp word [current_roww_index], 2
            jbe .first_3R
            cmp word [current_roww_index], 5
            jbe .second_3R
            cmp word [current_roww_index], 8
            jbe .third_3R

        .third_3C:
            add bx, 12
            cmp word [current_roww_index], 2
            jbe .first_3R
            cmp word [current_roww_index], 5
            jbe .second_3R
            cmp word [current_roww_index], 8
            jbe .third_3R

        .first_3R:
            add bx, 0
            jmp .validate_subgrid

        .second_3R:
            add bx, 54
            jmp .validate_subgrid

        .third_3R:
            add bx, 108
            jmp .validate_subgrid

; now bx has the starting address of specific sub grid

    .validate_subgrid:

        mov cx, 9
        mov dx, 3

        .subgrid_check:

            cmp si, bx
            jz .update_subgrid_check

            mov ax, [si]
            cmp ax, [bx]
            jz .invaliddd

            .update_subgrid_check:

                add bx, 2
                dec cx
                jz .validate_from_soultion ; the position is valid
                dec dx
                jz .next_row
                jmp .subgrid_check

                    .next_row:
                        add bx, 12
                        mov dx, 3

                jmp .subgrid_check


    .validate_from_soultion:

            mov ax, 18
            mul word [current_roww_index]
            mov di, ax ; now si has the starting location of row
            mov ax, solution
            add di, ax ; add grid address to get exact number

            mov ax, word [current_coll_index]
            shl ax, 1
            add di, ax

            mov dx, [di]
            cmp dx, [si]
            JE .return_validationn
    
.invaliddd:
    
    push ax
    push si

    xor ax, ax
    mov al, 80
    mul word [current_row]
    add ax, [current_col]
    shl ax, 1

    mov di, ax
    add di, 162

    pop si
    pop ax


    mov ah, 00110100b
    mov al, [si]
    add al, 48
    mov [es:di], ax

    cmp word [score_count], 20
    JB .dont_subtract_score
    sub word [score_count], 20

    push word [score_count]
    call printnum

    .dont_subtract_score:

    mov word [is_valid], 0
    add word [mistakes_count], 1
    cmp word [mistakes_count], 3
    JE display_ending_screen

    popa

    jmp check_arrow_keys

.return_validationn:

    add word [score_count], 10

    push word [score_count]
    call printnum

    mov word [is_valid], 1
    jmp .check_row_complete

    .check_row_complete:

        mov ax, 18
        mul word [current_roww_index]
        mov si, ax ; now si has the starting location of row
        mov ax, grid
        add si, ax ; add grid address to get exact number
        mov bx, si

        mov cx, 9

    .row_loop: ;checks if row is complete
        
        cmp byte [bx], 0
        JE .not_complete
        add bx, 2
        dec cx
        cmp cx, 0
        jnz .row_loop

    popa

    mov si, grid
    mov cx, 81
    .check_is_full1:
        cmp word [si], 0
        JE .row_music
        add si, 2
        dec cx
        jnz .check_is_full1

;---------------CALL WINNING SCREEN HERE-------------
       
        call successful_game
        call ending_screen

     .row_music: 

    add word [score_count], 40

    push word [score_count]
    call printnum

    call play_sound
    call display_horizontally

    jmp .end_validation

    .not_complete:

    pop bx
    pop bx

    mov cx, 9

    .col_loop: ; checks if col is complete

        cmp word [bx], 0
        JE .end_validation
        add bx, 18
        dec cx
        jnz .col_loop

        popa

        mov si, grid
        mov cx, 81

        .check_is_full2:
        cmp word [si], 0
        JE .col_music
        add si, 2
        dec cx
        jnz .check_is_full2

;---------------CALL WINNING SCREEN HERE-------------
        
        call successful_game
        call ending_screen

        .col_music:

        add word [score_count], 40

        push word [score_count]
        call printnum
        
        call play_sound
        call display_vertically
        

        jmp .end_validation

        mov word [is_row_or_col_complete], 0

    .end_validation:

        popa
        jmp check_arrow_keys