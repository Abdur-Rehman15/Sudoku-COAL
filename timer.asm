jmp print_text_end

tickcount:        dw   0
seconds:          dw   0
minutes:          dw   0
zero:             dw   0
oldisr:           dd   0
timer:            db '0:00'
mode_text:        dw 0
ncs_flag:         dw 0
colon:            db ':', 0

; Print Text End
print_text_end:
  pop si
  pop di
  pop es
  pop dx
  pop cx
  pop ax
  add sp, 2
  pop bp
  ret 10

; Print Text Function
print_text:
  push bp
  mov  bp, sp
  sub sp, 2
  mov word [bp - 2], 10
  
  push ax
  push cx
  push dx
  push es
  push di
  push si

  cmp word [bp + 12], 0
  je text_mode

number_mode:
  mov si, [bp + 10]
  mov ax, [si]
  xor cx, cx

stack_push_loop:
  div byte [bp - 2]
  mov dl, ah
  xor dh, dh
  add dx, '0'
  push dx
  xor ah, ah
  inc cx
  cmp ax, 0
  jne stack_push_loop

  mov ax, sp
  mov dx, cx

number_print_loop:
  push word [mode_text]
  push ax
  push word [bp + 8]
  push word [bp + 6]
  inc word [bp + 6]
  push word [bp + 4]
  call print_text
  add ax, 2
  loop number_print_loop

  sub word [bp + 6], dx
  shl dx, 1
  add sp, dx
  jmp print_text_end

text_mode:
  mov ax, 0xb800
  mov es, ax

  mov ax, 80
  mul byte [bp + 4] 
  add ax, [bp + 6]
  shl ax, 1
  mov di, ax
  add di, 4        

  mov si, [bp + 10]
  mov ax, [bp + 8]

text_print_loop:
  mov al, [si]
  stosw
  inc si
  cmp byte [si], 0
  jne text_print_loop
  jmp print_text_end

; Draw Timer Function
draw_timer:
  push bp
  mov bp, sp

  mov cx, [bp + 6]
  add cx, 3

  cmp word [seconds], 9
  jg skip

  push 1
  push word zero
  push 0011000100000000b
  push cx
  push word [bp + 4]
  call print_text
  inc cx

skip:
 
  push 1
  push word minutes
  push 0011000100000000b
  push word [bp + 6]   ; Y
  push word [bp + 4]   ; X
  call print_text

  add word [bp + 6], 2

  push 0
  push word colon
  push 0011000100000000b
  push word [bp + 6]   ; Y
  push word [bp + 4]   ; X
  call print_text
  
  push 1
  push word seconds
  push 0011000100000000b
  push cx
  push word [bp + 4]
  call print_text

 
  pop bp
  ret 4

; Timer Interrupt Service Routine
timer_isr:
  push bp
  mov bp, sp


  inc word [tickcount]
  cmp word [tickcount], 18
  jne skip_drawing_timer

  inc word [seconds]
  mov word [tickcount], 0

  cmp word [seconds], 60
  jne call_draw_timer

  mov word [seconds], 0
  inc word [minutes]

call_draw_timer:
  cmp word [ncs_flag], 0
  jne skip_drawing_timer

  push word 6
  push word 1
  call draw_timer
skip_drawing_timer:
  mov al, 0x20
  out 0x20, al
  pop bp
  iret

; Hook Timer Interrupt
hook_timer_interrupt:
  push bp
  mov bp, sp

  push ds
  push es
  push ax
  push bx

  mov ax, 3508h
  int 21h
  mov word [oldisr], bx
  mov word [oldisr+2], es

  xor ax, ax
  mov es, ax

  cli
  mov word [es:8*4], timer_isr
  mov [es:8*4+2], cs
  sti

  pop bx
  pop ax
  pop es
  pop ds
  pop bp
  ret

last_time:
    pusha
    mov ax, 0xb800 
    mov es, ax

    mov di, 2962

    mov ax, [minutes]
    mov bx, 10
    xor dx, dx
    div bx
    add ax, 0x30
    mov ah, 0x34
    mov [es:di], ax
    add di, 2
    mov al, dl
    add al, 0x30
    mov ah, 0x34
    mov [es:di], ax
    add di, 2

    mov ax, ':' | 0x3400
    mov [es:di], ax
    add di, 2

    mov ax, [seconds]
    mov bx, 10
    xor dx, dx
    div bx
    add ax, 0x30
    mov ah, 0x34
    mov [es:di], ax
    add di, 2
    mov al, dl
    add al, 0x30
    mov ah, 0x34
    mov [es:di], ax
    add di, 2

    popa
    ret


unhook_timer_interrupt:
  push bp
  mov bp, sp

  push ds
  push ax
  push dx

  cli
  push ds
  mov ax, 2508h      ; DOS function 25h to set interrupt vector for interrupt 08h
  mov dx, [oldisr]   ; Load original ISR offset
  mov ds, [oldisr+2] ; Load original ISR segment
  int 21h
  pop ds
  sti

  pop dx
  pop ax
  pop ds
  pop bp
  ret

