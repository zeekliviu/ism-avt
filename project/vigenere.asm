; ===================== Vigenere Encryption =====================
; Usage: VIGENERE.EXE <password> <inputfile> <outputfile>
; Implementation using 8086 assembly with stack frame and procedures
; Authors: Gabriel Zăvoianu & Liviu-Ioan Zecheru
; =============================================================

.model small
.stack 256h
; BP-1:   Argument count
; BP-31:  Password storage
; BP-32:  Password length
; BP-63:  Input filename
; BP-64: Input filename length
; BP-95:  Output filename
; BP-96: Output filename length
; BP-97:  Input file handle
; BP-99:  Output file handle
; BP-101: Key index
; BP-103: Character buffer

.code
Main proc
    push bp
    mov bp, sp

    mov ah, 62h ; get PSP segment
    int 21h
    mov es, bx

    mov bx, 81h ; point to the first byte of the command line
    ; create stack frame
    sub sp, 100h ; allocate space for arguments
    mov byte ptr [bp - 1], 0; set first byte to 0
    lea si, [bp - 31] ; point to the first byte of the counters
    mov ah, 32 
    mov di, 1
    xor cx, cx

NextToken:
    call SkipDelims
    mov al, byte ptr es:[bx]
    cmp al, 0Dh
    je ArgDone

StoreToken:
    mov al, byte ptr es:[bx]
    call IsDelimiter
    jz TokenEnded

    ; transform it to lowercase
    call ToLower

    mov byte ptr ss:[si], al
    inc si
    inc bx
    inc cx
    jmp StoreToken

TokenEnded:
    mov byte ptr ss:[si], 0; null terminate
    inc si
    inc byte ptr [bp - 1] ; increment arg count
    
    push si
    push ax
    push di
    
    ; place the size of the string on the stack
    xchg ah, al
    mov ah, 0
    mov si, ax
    neg si
    lea di, [bp + si]
    mov byte ptr ss:[di], cl
    
    pop di    
    pop ax
    pop si

    xor cx, cx

    cmp di, 1
    jne Arg2Check
    lea si, byte ptr [bp - 63]
    mov ah, 64
    mov di, 2
    jmp NextToken

Arg2Check:
    cmp di, 2
    jne Arg3Check
    lea si, byte ptr [bp - 95]
    mov ah, 96
    mov di, 3
    jmp NextToken

Arg3Check:
    jmp NextToken

ArgDone:
    cmp byte ptr ss:[bp - 1], 3
    jne NotThreeArgs
    jmp OpenInputFile

NotThreeArgs:
    call NotThreeArgsProc
    jmp ExitProgram
    
OpenInputFile:
    ; open input file (arg2) read-only
    push ds
    mov ax, ss
    mov ds, ax
    lea dx, [bp - 63]
    mov ah, 3Dh        ; DOS function: Open file
    mov al, 0          ; Read-only
    int 21h
    pop ds
    jc OpenInFail
    mov word ptr [bp - 97], ax ; input handle
    jmp OpenOutputFile

OpenInFail:
    call OpenInFailProc
    jmp ExitProgram

OpenOutputFile:
    ; create / truncate output file (arg3)
    push ds
    mov ax, ss
    mov ds, ax
    lea dx, [bp - 95]
    mov cx, 0          ; File attribute: Normal
    mov ah, 3Ch        ; DOS function: Create file
    int 21h
    pop ds
    jc CreateOutFail
    mov word ptr [bp - 99], ax ; output handle
    jmp InitEncryption

CreateOutFail:
    call CreateOutFailProc
    jmp ExitProgram

InitEncryption:
    mov word ptr [bp - 101], 0; initialize keyindex = 0
    mov byte ptr [bp - 103], 0; one byte buffer
EncryptLoop:
    ; read 1 byte from input file
    push ds
    mov ax, ss
    mov ds, ax
    mov bx, word ptr [bp - 97]
    mov ah, 3Fh ; dos func: read from file
    lea dx, ss:[bp - 103]
    mov cx, 1 ; read 1 byte
    int 21h
    pop ds
    jc ReadError

    cmp ax, 0 ; ax = 0 => EOF
    je EncDone

    ; load the byte into AL
    mov al, byte ptr [bp - 103]
    call ToLower

    ; encrypt the byte
    lea si, ss:[bp - 31] ; arg 1 - password
    push si
    xor cx, cx
    mov cl, byte ptr ss:[bp - 32] ; arg2 - password length
    push cx
    xor cx, cx
    lea di, ss:[bp - 101] ; arg3 - key index 
    push di
    call EncryptOneChar

    ; store the encrypted byte back
    mov byte ptr ss:[bp - 103], al
    
    ; write the byte to the output file
    push ds
    mov ax, ss
    mov ds, ax
    mov bx, word ptr [bp - 99]
    mov ah, 40h
    lea dx, ss:[bp - 103]
    mov cx, 1
    int 21h
    pop ds
    jc WriteError

    jmp EncryptLoop
EncDone:
    mov cx, 99h
    jmp ExitProgram

ReadError:
    jmp ExitProgram

WriteError:
    jmp ExitProgram

ExitProgram:
    mov ax, 4c00h
    int 21h
Main endp

SkipDelims:
SkipLoop:
    mov al, byte ptr es:[bx]
    cmp al, 0Dh
    je DoneSkip
    call IsDelimiter
    jz IncBx
    jmp DoneSkip

IncBx:
    inc bx
    jmp SkipLoop

DoneSkip:
    ret

IsDelimiter proc near
    cmp al, 20h ; Space
    jz Delim
    cmp al, 2Ch ; ','
    jz Delim
    cmp al, 09h ; Tab
    jz Delim
    cmp al, 3Bh ; ';'
    jz Delim
    cmp al, 3Dh ; '='
    jz Delim
    cmp al, 0Dh ; CR

Delim:
    ret
IsDelimiter endp

print_string proc near 
    push bp
    mov bp, sp

    push si
    push cx

    mov si, [bp + 6]
    xor cx, cx
    mov cx, [bp + 4]
    
print_loop:
    mov ah, 02h
    mov dl, byte ptr ss:[si]
    int 21h
    inc si
    loop print_loop

    pop cx
    pop si
    pop bp
    ret
print_string endp

NotThreeArgsProc proc near
    push bp
    mov  bp, sp

    sub  sp, 50

    mov byte ptr [bp - 50], 'U'
    mov byte ptr [bp - 49], 's'
    mov byte ptr [bp - 48], 'a'
    mov byte ptr [bp - 47], 'g'
    mov byte ptr [bp - 46], 'e'
    mov byte ptr [bp - 45], ':'
    mov byte ptr [bp - 44], ' '
    mov byte ptr [bp - 43], 'V'
    mov byte ptr [bp - 42], 'I'
    mov byte ptr [bp - 41], 'G'
    mov byte ptr [bp - 40], 'E'
    mov byte ptr [bp - 39], 'N'
    mov byte ptr [bp - 38], 'E'
    mov byte ptr [bp - 37], 'R'
    mov byte ptr [bp - 36], 'E'
    mov byte ptr [bp - 35], '.'
    mov byte ptr [bp - 34], 'E'
    mov byte ptr [bp - 33], 'X'
    mov byte ptr [bp - 32], 'E'
    mov byte ptr [bp - 31], ' '
    mov byte ptr [bp - 30], '<'
    mov byte ptr [bp - 29], 'p'
    mov byte ptr [bp - 28], 'a'
    mov byte ptr [bp - 27], 's'
    mov byte ptr [bp - 26], 's'
    mov byte ptr [bp - 25], 'w'
    mov byte ptr [bp - 24], 'o'
    mov byte ptr [bp - 23], 'r'
    mov byte ptr [bp - 22], 'd'
    mov byte ptr [bp - 21], '>'
    mov byte ptr [bp - 20], ' '
    mov byte ptr [bp - 19], '<'
    mov byte ptr [bp - 18], 'i'
    mov byte ptr [bp - 17], 'n'
    mov byte ptr [bp - 16], 'F'
    mov byte ptr [bp - 15], 'i'
    mov byte ptr [bp - 14], 'l'
    mov byte ptr [bp - 13], 'e'
    mov byte ptr [bp - 12], '>'
    mov byte ptr [bp - 11], ' '
    mov byte ptr [bp - 10], '<'
    mov byte ptr [bp - 9], 'o'
    mov byte ptr [bp - 8], 'u'
    mov byte ptr [bp - 7], 't'
    mov byte ptr [bp - 6], 'F'
    mov byte ptr [bp - 5], 'i'
    mov byte ptr [bp - 4], 'l'
    mov byte ptr [bp - 3], 'e'
    mov byte ptr [bp - 2], '>'
    mov byte ptr [bp - 1], '$'


    lea si, ss:[bp - 50]
    push si               ; 1st param
    xor cx, cx
    mov cx, 49
    push cx               ; 2nd param
    call print_string

    add sp, 4            ; clean up params from stack
    add sp, 50          ; restore space from sub sp, 50h (0x50)

    pop bp
    ret                 ; near return
NotThreeArgsProc endp

OpenInFailProc proc near
    push bp
    mov bp, sp

    ; print input file error
    sub sp, 40

    mov byte ptr [bp - 40], 'C'
    mov byte ptr [bp - 39], 'a'
    mov byte ptr [bp - 38], 'n'
    mov byte ptr [bp - 37], 'n'
    mov byte ptr [bp - 36], 'o'
    mov byte ptr [bp - 35], 't'
    mov byte ptr [bp - 34], ' '
    mov byte ptr [bp - 33], 'o'
    mov byte ptr [bp - 32], 'p'
    mov byte ptr [bp - 31], 'e'
    mov byte ptr [bp - 30], 'n'
    mov byte ptr [bp - 29], ' '
    mov byte ptr [bp - 28], 'i'
    mov byte ptr [bp - 27], 'n'
    mov byte ptr [bp - 26], 'p'
    mov byte ptr [bp - 25], 'u'
    mov byte ptr [bp - 24], 't'
    mov byte ptr [bp - 23], ' '
    mov byte ptr [bp - 22], 'f'
    mov byte ptr [bp - 21], 'i'
    mov byte ptr [bp - 20], 'l'
    mov byte ptr [bp - 19], 'e'
    mov byte ptr [bp - 18], '.'
    mov byte ptr [bp - 17], ' '
    mov byte ptr [bp - 16], 'C'
    mov byte ptr [bp - 15], 'h'
    mov byte ptr [bp - 14], 'e'
    mov byte ptr [bp - 13], 'c'
    mov byte ptr [bp - 12], 'k'
    mov byte ptr [bp - 11], ' '
    mov byte ptr [bp - 10], 't'
    mov byte ptr [bp - 9], 'h'
    mov byte ptr [bp - 8], 'e'
    mov byte ptr [bp - 7], ' '
    mov byte ptr [bp - 6], 'n'
    mov byte ptr [bp - 5], 'a'
    mov byte ptr [bp - 4], 'm'
    mov byte ptr [bp - 3], 'e'
    mov byte ptr [bp - 2], '!'
    mov byte ptr [bp - 1], '$'
    
    lea si, ss:[bp - 40]
    push si
    xor cx, cx
    mov cx, 39
    push cx
    call print_string

    add sp, 4 ; clean up params from stack
    add sp, 40 ; restore sp

    pop bp
    ret
OpenInFailProc endp

CreateOutFailProc proc near
    push bp
    mov sp, bp

    add sp, 49
    mov byte ptr [bp - 49], 'C'
    mov byte ptr [bp - 48], 'a'
    mov byte ptr [bp - 47], 'n'
    mov byte ptr [bp - 46], 'n'
    mov byte ptr [bp - 45], 'o'
    mov byte ptr [bp - 44], 't'
    mov byte ptr [bp - 43], ' '
    mov byte ptr [bp - 42], 'c'
    mov byte ptr [bp - 41], 'r'
    mov byte ptr [bp - 40], 'e'
    mov byte ptr [bp - 39], 'a'
    mov byte ptr [bp - 38], 't'
    mov byte ptr [bp - 37], 'e'
    mov byte ptr [bp - 36], ' '
    mov byte ptr [bp - 35], 't'
    mov byte ptr [bp - 34], 'h'
    mov byte ptr [bp - 33], 'e'
    mov byte ptr [bp - 32], ' '
    mov byte ptr [bp - 31], 'o'
    mov byte ptr [bp - 30], 'u'
    mov byte ptr [bp - 29], 't'
    mov byte ptr [bp - 28], 'p'
    mov byte ptr [bp - 27], 'u'
    mov byte ptr [bp - 26], 't'
    mov byte ptr [bp - 25], ' '
    mov byte ptr [bp - 24], 'f'
    mov byte ptr [bp - 23], 'i'
    mov byte ptr [bp - 22], 'l'
    mov byte ptr [bp - 21], 'e'
    mov byte ptr [bp - 20], '.'
    mov byte ptr [bp - 19], ' '
    mov byte ptr [bp - 18], 'C'
    mov byte ptr [bp - 17], 'h'
    mov byte ptr [bp - 16], 'e'
    mov byte ptr [bp - 15], 'c'
    mov byte ptr [bp - 14], 'k'
    mov byte ptr [bp - 13], ' '
    mov byte ptr [bp - 12], 'd'
    mov byte ptr [bp - 11], 'i'
    mov byte ptr [bp - 10], 's'
    mov byte ptr [bp - 9], 'k'
    mov byte ptr [bp - 8], ' '
    mov byte ptr [bp - 7], 's'
    mov byte ptr [bp - 6], 'p'
    mov byte ptr [bp - 5], 'a'
    mov byte ptr [bp - 4], 'c'
    mov byte ptr [bp - 3], 'e'
    mov byte ptr [bp - 2], '!'
    mov byte ptr [bp - 1], '$'


    lea si, ss:[bp - 49]
    push si
    xor cx, cx
    mov cx, 48
    push cx
    call print_string

    add sp, 4
    add sp, 49

    pop bp
    ret
CreateOutFailProc endp

EncryptOneChar proc near
    push bp
    mov bp, sp

    ; get keyindex and arg1len
    mov si, [bp + 4] ; keyindex ptr
    mov bx, word ptr ss:[si] ; keyindex value from ptr 
    mov cx, [bp + 6] ; arg1len 
    mov si, [bp + 8] ; arg1 

    ; check if space
    cmp al, 20h
    je SkipKeyUsage

    ; check if 'a'...'z'
    cmp al, 61h
    jb NotLower
    cmp al, 7Ah
    ja NotLower

    ; its 'a'...'z' perform vigenere enc
    ; get pass char [arg1 + keyindex]
    mov di, si
    add si, bx
    mov dl, byte ptr ss:[si]

    ; calc shift (password_char - 'a')
    sub dl, 61h

    ; shift the input char (input_char - 'a') + shift
    sub al, 61h
    add al, dl

    ; wrap around if >= 26
    cmp al, 1Ah ; 26 dec
    jb NoWrap
    sub al, 1Ah
NoWrap:
    add al, 61h

    inc bx
    cmp bx, cx
    jb KeyOk
    xor bx, bx
KeyOk:
    mov si, [bp + 4]
    mov ss:[si], bx
    jmp StoreChar

NotLower:
    ; non-space, non-lowercase: consume key
    inc bx
    cmp bx, cx
    jb KeyOk2
    xor bx, bx
KeyOk2:
    mov si, [bp + 4]
    mov ss:[si], bx
    jmp StoreChar
SkipKeyUsage:
    ; space: do not consume key, do not modify AL
    ; al remains unchanged
    jmp StoreChar
StoreChar:
    pop bp
    ret
EncryptOneChar endp

ToLower proc near
    cmp al, 'A'
    jb done_to_lower
    cmp al, 'Z'
    ja done_to_lower
    add al, 20h

done_to_lower:
    ret
ToLower endp
end Main