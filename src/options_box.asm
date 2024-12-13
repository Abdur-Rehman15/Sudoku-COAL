; ------Options Box On The Right------------

mistakes: db ' MISTAKES:'
size6: dw size6-mistakes
mistakes_out_of: db '  / 3'
size55: dw size55-mistakes_out_of
notes: db ' NOTES '

size7: dw size7-notes
notes_extend: db 'Press > N'
size8: dw size8-notes_extend
undo: db ' UNDO '
size9: dw size9-undo
undo_extend: db 'Press > U'
size10: dw size10-undo_extend
erase: db ' ERASE '
size11: dw size11-erase
erase_extend: db 'Press > E'
size12: dw size12-erase_extend

options_box:

    pusha

    mov ah,00110101b
    mov di,916
    mov si,0

    .mistakes_display: ;mistakes text display

    mov al,[mistakes+si]
    mov [es:di],AX
    add di,2
    inc si
    cmp si,[size6]
    jnz .mistakes_display

    mov ah, 00110001b
    mov si, 0
    add di, 4
    .mistakes_outof_display: ;mistakes text display

    mov al,[mistakes_out_of + si]
    mov [es:di],AX
    add di,2
    inc si
    cmp si,[size55]
    jnz .mistakes_outof_display
   
    mov di,1394 ;starting of line (top left corner of box)
    mov ah,00110000b
    mov cx,20 ;width of box for upper line comparison
    mov al,218 ;top left corner
    mov [es:di],ax
    add di,2
    mov al, 196
    rep stosw

    mov al,191 ;top right corner
    mov [es:di],ax
    add di,2
    

    mov di,1554 ;starting of second line

    mov cx, 2

    other_lines: ;right and left vertical line of box


    mov al,179 ;vertical bar
    mov [es:di],ax
    add di,42
    mov al,179
    mov [es:di],ax
    add di,120
    sub cx,2
    cmp cx,0
    jnz other_lines

    mov di, 1714
    mov al,192 ;bottom left corner
    mov [es:di],ax

    mov cx,20 ;width of box for upper line comparison
    add di,2
    mov al, 196
    rep stosw

    mov al, 217
    stosw


    ;--------Options In Box--------------


    mov ah,00010110b
    mov di, 1558
    mov si,0

    mov ah,00011110b


    .notes_text: ;-----------
        mov al,[notes+si]
        mov [es:di],ax
        add di,2
        inc si
        cmp si,[size7]
        jnz .notes_text


    mov ah,00110100b
    mov si,0
    add di, 4


    .notes_buttons:
        mov al,[notes_extend+si]
        mov [es:di],ax
        add di,2
        inc si
        cmp si,[size8]
        jnz .notes_buttons


    mov di,2034 ;starting of line (top left corner of box)
    mov ah,00110000b
    mov cx,20 ;width of box for upper line comparison
    mov al,218 ;top left corner
    mov [es:di],ax
    add di,2
    mov al, 196
    rep stosw

    mov al,191 ;top right corner
    mov [es:di],ax
    add di,2
    

    mov di,2194 ;starting of second line

    mov cx, 2

    other_lines1: ;right and left vertical line of box


    mov al,179 ;vertical bar
    mov [es:di],ax
    add di,42
    mov al,179
    mov [es:di],ax
    add di,120
    sub cx,2
    cmp cx,0
    jnz other_lines1

    mov di, 2354
    mov al,192 ;bottom left corner
    mov [es:di],ax

    mov cx,20 ;width of box for upper line comparison
    add di,2
    mov al, 196
    rep stosw

    mov al, 217
    stosw
    
    mov di, 2194
    add di,4

    mov si,0
    mov ah,00011110b


    .undo_text:;-----------
        mov al,[undo+si]
        mov [es:di],ax
        add di,2
        inc si
        cmp si,[size9]
        jnz .undo_text


    mov ah,00110100b
    mov si,0
    add di, 6

    .undo_button:
        mov al,[undo_extend+si]
        mov [es:di],ax
        add di,2
        inc si
        cmp si,[size10]
        jnz .undo_button


    mov di,2674 ;starting of line (top left corner of box)
    mov ah,00110000b
    mov cx,20 ;width of box for upper line comparison
    mov al,218 ;top left corner
    mov [es:di],ax
    add di,2
    mov al, 196
    rep stosw

    mov al,191 ;top right corner
    mov [es:di],ax
    add di,2
    

    mov di,2834 ;starting of second line

    mov cx, 2

    other_lines2: ;right and left vertical line of box


    mov al,179 ;vertical bar
    mov [es:di],ax
    add di,42
    mov al,179
    mov [es:di],ax
    add di,120
    sub cx,2
    cmp cx,0
    jnz other_lines2

    mov di, 2994
    mov al,192 ;bottom left corner
    mov [es:di],ax

    mov cx,20 ;width of box for upper line comparison
    add di,2
    mov al, 196
    rep stosw

    mov al, 217
    stosw

    mov di, 2834

    add di,4

    mov si,0

    mov ah,00011110b


    .erase_text:;-----------
        mov al,[erase+si]
        mov [es:di],ax
        add di,2
        inc si
        cmp si,[size11]
        jnz .erase_text


    mov ah,00110100b
    mov si,0
    add di, 4

    .erase_button:
        mov al,[erase_extend+si]
        mov [es:di],ax
        add di,2
        inc si
        cmp si,[size12]
        jnz .erase_button



    popa


ret

