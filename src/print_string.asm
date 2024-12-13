; Function to print a string at specified x, y with attribute
print_string:
    push bp
    mov bp, sp
    push es
    push ax
    push cx
    push si
    push di


    mov ax, 0xb800
    mov es, ax


    mov al, 80
    mul byte [bp + 10]        ; AL * y
    add ax, [bp + 12]         ; Add x position
    shl ax, 1            
    mov di, ax


    mov si, [bp + 6]          ; string memory
    mov cx, [bp + 4]          ; string length
    mov ah, [bp + 8]          ; attribute


printing:
    mov al, [si]              
    mov [es:di], ax          
    add di, 2                
    add si, 1                    
    sub cx, 1                    
    jnz printing


    pop di
    pop si
    pop cx
    pop ax
    pop es
    pop bp
    ret 10  



printnum: 
 push bp
 mov bp, sp
 push es
 push ax
 push bx
 push cx
 push dx
 push di
 mov ax, 0xb800
 mov es, ax ; point es to video base
 mov ax, [bp+4] ; load number in ax
 mov bx, 10 ; use base 10 for division
 mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
 div bx ; divide by 10
 add dl, 0x30 ; convert digit into ascii value
 push dx ; save ascii value on stack
 inc cx ; increment count of values
 cmp ax, 0 ; is the quotient zero
 jnz nextdigit ; if no divide it again
 mov di, 300 ; point di to top left column
 nextpos: pop dx ; remove a digit from the stack
 mov dh, 00110001b ; use normal attribute
 mov [es:di], dx ; print char on screen
 add di, 2 ; move to next screen location
 loop nextpos ; repeat for all digits on stack
 pop di
 pop dx
 pop cx
 pop bx
 pop ax
 pop es
 pop bp
 ret