jmp tone

; Define music data and length
music_length: dw 999       ; Set the length of the binary file (actual size)
music_data: incbin "C:\COAL_new\Code\music.imf"  ; Include binary music data
melody: 
    dw 800, 900, 1000, 1100, 1200, 1300, 1400, 1500 ; Ascending victory tones
    dw 1500, 1400, 1300, 1200, 1100, 1000, 900, 800 ; Descending back for effect

tempo: dw 2       

; Music playback routine
music:
    ;push si
    push dx
    push ax
    push bx
    push cx
    
.next_note:
    ; Check if we've reached the end of the music data
    cmp si, [music_length]  
    jae end_music           ; Exit if beyond music length

    ; Play the current note
    mov dx, 388h
    mov al, [si + music_data + 0]
    out dx, al
    mov dx, 389h
    mov al, [si + music_data + 1]
    out dx, al
    mov bx, [si + music_data + 2] ; Load delay for current note
    add si, 4                  ; Move to the next note

.repeat_delay:
    mov cx, 610                ; Adjust delay timing as needed
.delay:
    ; Handle keypress during playback
    mov ah, 1
    int 16h
    jnz stop_music
    loop .delay
    dec bx
    jg .repeat_delay
    jmp .next_note             ; Play the next note

stop_music:
    ; Exit immediately if a key is pressed
    jmp end_music

end_music:
    ; Turn off the AdLib chip
    mov dx, 388h
    mov al, 0xFF
    out dx, al
    mov dx, 389h
    out dx, al
    pop cx
    pop bx
    pop ax
    pop dx
    ;pop si
    ret

; Program start
tone:
    ; Initialize speaker (if necessary)
    mov al, 0xB6          ; Command for channel 2, mode 3 (square wave)
    out 0x43, al          ; Send command byte to port 0x43

    ; Enable the speaker
    in al, 0x61
    or al, 0x03
    out 0x61, al

    ; Call music playback routine
    xor si, si
    call music

    ; Disable the speaker
    in al, 0x61
    and al, 0xFC
    out 0x61, al
       
ret

delay1:
    push cx
    push dx
    mov dx, [tempo] ; Use tempo for dynamic delay control
l2:
    mov cx, 0xafff ; Reduced loop for shorter delay
l1: 
    loop l1
    dec dx
    cmp dx, 0
    jne l2
    pop dx
    pop cx
    ret

play_note:
    push ax         ; Save registers
    push bx
    push dx
    mov bx, [melody + si] ; Access the divisor for the current note
    call sound      ; Call the sound function to play the note

    pop dx          ; Restore registers
    pop bx
    pop ax
    ret

sound:
    ; Save current state of port 0x61 (speaker state)
    in al, 61h
    push ax         ; Save the AL value (mode of port 0x61)

    ; Enable the speaker and connect it to channel 2
    or al, 3h
    out 61h, al

    ; Set channel 2 (PIT)
    mov al, 0b6h    ; Select mode 3 (square wave) for channel 2
    out 43h, al

    ; Send the divisor to the PIT
    mov ax, bx      ; Load the divisor into AX
    out 42h, al     ; Send the LSB (lower byte)
    mov al, ah      ; Get the MSB (higher byte)
    out 42h, al     ; Send the MSB (higher byte)

    call delay1      ; Play the sound for a duration based on delay

    ; Restore the previous state of port 0x61
    pop ax          ; Restore speaker state
    out 61h, al
    ret

play_sound:
    mov cx, 16      ; Number of notes in the melody
    mov si, 0       ; Start with the first note in the array
    .playy:
    call play_note  ; Play the current note
    add si, 2       ; Move to the next note
    loop .playy ; Repeat until all notes are played

    ret


musical_Score11: dw 262, 294, 330, 349, 392, 440, 494, 523, 587, 659, 698, 784
           dw 262, 294, 330, 349, 392, 440, 494, 523, 587, 659, 698, 784
delay11: push cx
push dx
mov dx, 10
l211:
mov cx,0xffff
l111: loop l111
dec dx
cmp dx, 0
jne l211
pop dx 
pop cx
ret

play_note11:
    push ax         ; Save registers
    push bx
    push dx
    mov bx, [musical_Score11 + si] ; Access the divisor for the current note (using SI as index)
    call sound11     ; Call the sound function to play the note using the divisor

    pop dx          ; Restore registers
    pop bx
    pop ax
    ret

; Sound function that sends the divisor to the PIT and enables the speaker
sound11:
    ; Save current state of port 0x61 (speaker state)
    in al, 61h
    push ax         ; Save the AL value (mode of port 0x61)
    
    ; Enable the speaker and connect it to channel 2
    or al, 3h
    out 61h, al

    ; Set channel 2 (PIT)
    mov al, 0b6h    ; Select mode 3 (square wave) for channel 2
    out 43h, al

    ; Send the divisor to the PIT
    mov ax, bx      ; Load the divisor into AX
    out 42h, al     ; Send the LSB (lower byte)
    mov al, ah      ; Get the MSB (higher byte)
    out 42h, al     ; Send the MSB (higher byte)

	call delay11

    ; Restore the previous state of port 0x61
    pop ax;restore Speaker state
	out 61h, al
    ret

; Main loop to play a sequence of notes
click_sound:
    pusha
    mov si, 0       ; Start with the first note in the array (C4)
play_loop11:
    call play_note11  ; Play the current note
    add si, 2        ; Move to the next note in the array
    cmp si, 2	; Check if we've reached the end of the array (B4 is the 7th note)
	jne play_loop11
    popa
    ret