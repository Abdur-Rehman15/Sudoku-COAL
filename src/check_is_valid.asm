[org 0x0100]

jmp is_position_valid

row: db 0
col: db 0

grid: db 0, 0, 0, 0, 0, 0, 0, 0, 0
      db 0, 0, 0, 0, 0, 0, 0, 0, 0
      db 0, 0, 0, 0, 0, 0, 0, 0, 0
      db 0, 0, 0, 0, 0, 0, 0, 0, 0
      db 0, 0, 0, 0, 0, 0, 0, 0, 0
      db 0, 0, 0, 0, 0, 0, 0, 0, 0
      db 0, 0, 0, 0, 0, 0, 0, 0, 0
      db 0, 0, 0, 0, 0, 0, 0, 0, 0
      db 0, 0, 0, 0, 0, 0, 0, 0, 0



is_position_valid:

    mov ax, 0xb800
    mov es, ax
    xor di, di

    mov si, 0

    ;row * 9 + col (assuming row started from 0)
    ;row * 9 to get the starting of current row
    






mov ax, 0x4c00
int 21h