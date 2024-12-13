
jmp number_cards

save_count: db 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Counter for numbers 1-9 initialized to 0

number_cards:
    pusha
    mov bl, byte [blink_number]
    add bl, 0x30
    cmp bl, dl
    jne ooo1
    mov ah, 10110100b
    jmp oo1
ooo1:
    mov ah, 00110100b  
oo1:

    mov al, 201 ; Top left corner
    mov [es:di], ax
    add di, 2
    mov al, 205 ; Horizontal bar
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov al, 187 ; Top right corner
    mov [es:di], ax
    add di, 2

    add di, 150

    mov al, 186 ; Vertical bar
    mov [es:di], ax
    add di, 4

    mov al, dl
    sub al, 0x31
    mov si, save_count
    add si, ax
    sub si, 1
    mov al, [si]
    cmp al, 9
    je skip_display

    mov al, dl
    mov [es:di], ax
    add di, 4

skip_display:
    mov al, 186
    mov [es:di], ax
    add di, 2

    add di, 150

    mov al, 200 ; Bottom left corner
    mov [es:di], ax
    add di, 2
    mov al, 205
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov al, 188 ; Bottom right corner
    mov [es:di], ax
    add di, 2

    add di, 150

    popa
    ret