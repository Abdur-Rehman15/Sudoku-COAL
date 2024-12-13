    ;-------------Opening Screen Related Code------------------


    buffer: times 1000 dw 0


    ; in:
    ;   si = number of 55.56 ms to wait
    sleep:
            mov ah, 0
            int 1ah
            mov bx, dx
        .wait:
            mov ah, 0
            int 1ah
            sub dx, bx
            cmp dx, si
            jl .wait
            ret


    clrscr1:


            pusha
            mov di,0
            mov ax,0xb800
            mov es,ax
            mov al,0x20
            mov ah,00110000b


            nextt:
            mov [es:di],ax
            add di,2
            cmp di,4000
            jnz nextt


            popa


            ret


    hide_cursor:
            mov ah, 02h
            mov bh, 0
            mov dh, 25
            mov dl, 0
            int 10h
            ret


    clear_keyboard_buffer:
            mov ah, 1
            int 16h
            jz .end
            mov ah, 0h ; retrieve key from buffer
            int 16h
            jmp clear_keyboard_buffer
        .end:
            ret


    exit_process:
            mov ah, 4ch
            int 21h
            ret


    buffer_clear:
            mov bx, 0
        .next:  
            mov byte [buffer + bx], ' '
            inc bx
            cmp bx, 2000
            jnz .next
            ret
       
    ; in:
    ;   bl = char
    ;   cx = col
    ;   dl = row
    buffer_write:
        mov di, buffer
        mov al, 80
        mul dl
        add ax, cx
        add di, ax
        mov byte [di], bl
        ret
   
    ; in:
    ;   cx = col
    ;   dx = row
    ; out:
    ;   bl = char
    buffer_read:
        mov di, buffer
        mov al, 80
        mul dl
        add ax, cx
        add di, ax
        mov bl, [di]
        ret
   
    ; in:
    ;   si = string address
    ;   di = buffer destination offset
    buffer_print_string:
        .next:
            mov al, [si]
            cmp al, 0
            jz .end
            mov byte [buffer + di], al
            inc di
            inc si
            jmp .next
        .end:
            ret




    buffer_render:
            mov ax, 0b800h
            mov es, ax
            mov di, buffer
            mov si, 0


        .write:
            mov bl,[di]
            mov byte [es:si], bl
            inc di
            add si, 2
            cmp si, 4000
            jnz .write
            ret


    show_title:
            call buffer_clear
            call buffer_render
            mov si, 18
            call sleep
            mov si, 0
        .next:
            mov bx, [.title + si]
            mov byte [buffer + bx], 219
            push si
            call buffer_render
            mov si, 1
            call sleep
            pop si
            add si, 2
            cmp si, 310
            jl .next
            mov si, .text_2
            mov di, 1620
            call buffer_print_string
            mov si, .text_5
            mov di, 1772
            call buffer_print_string
            call clear_keyboard_buffer
            ; mov si, .text_5
            ; mov di, 1934
            ; call buffer_print_string
            ; call clear_keyboard_buffer


        .wait_for_key:
            mov si, .text_4
            mov di, 1388
            call buffer_print_string
            call buffer_render
            mov si, 5
            call sleep
            mov ah, 1
            int 16h
            jnz .continue
            mov si, .text_3
            mov di, 1388
            call buffer_print_string
            call buffer_render
            mov si, 10
            call sleep
            mov ah, 1
            int 16h
            jz .wait_for_key


        .continue:
            
            ret


        .title:
            ;----S-----
            dw 0336, 0335, 0334, 0333, 0332, 0331, 0330, 0329, 0409, 0489
            dw 0569, 0649, 0650, 0651, 0652, 0653, 0654, 0655, 0656, 0736
            dw 0816, 0896, 0976, 0975, 0974, 0973, 0972, 0971, 0970, 0969
            ;----U-----
            dw 0339,0419,0499,0579,0659,0739,0819,0899,0979,0980,0981,0982
            dw 0983,0984,0985,0986,0906,0826,0746,0666,0586,0506,0426,0346
            ;----D-----
            dw 0989,0909,0829,0749,0669,0589,0509,0429,0349,0350,0351,0352
            dw 0353,0354,0435,0436,0516,0596,0676,0756,0836,0916,0915,0994
            dw 0993,0992,0991,0990,0989
            ;----O-----
            dw 0361,0362,0363,0364,0365,0366,0447,0527,0607,0687,0767,0847
            dw 0927,1006,1005,1004,1003,1002,1001,0920,0840,0760,0680,0600
            dw 0520,0440
            ;----K-----
            dw 0372,0452,0532,0612,0692,0772,0852,0932,1012,0379,0458,0537
            dw 0616,0615,0694,0693,0775,0776,0857,0938,1019
            ;----U-----
            dw 0383,0463,0543,0623,0703,0783,0863,0943,1023,1024,1025,1026
            dw 1027,1028,1029,1030,0950,0870,0790,0710,0630,0550,0470,0390
           
        .text_1:
            db " DEVELOPED BY ABDUR AND RIZWAN ", 0
        .text_2:
            db " # USE ARROW KEYS TO NAVIGATE THE GRID # ", 0
        .text_3:
            db "Press Any Key To Start", 0
        .text_4:
            db "                      ", 0
        .text_5:
            db "         # PRESS `ENTER` TO ACCESS NUMBER CARD #       ", 0
