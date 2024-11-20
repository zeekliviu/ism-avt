.model small
.stack 100h

.code
; checking the command line arguments
    sub sp, 2
    call check_args
    pop ax
    mov ax, 4c00h
    int 21h
check_args proc
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push si
    push dx

    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si, si

    mov si, 80h
    check_loop:
        mov al, byte ptr ds:[si]
        cmp al, 20h
        jne not_space
        add cx, 1
    not_space:
        inc si
        cmp al, 0dh
        je after_loop
        jmp check_loop

    after_loop:
        xor cx, 03h
        mov ax, cx
    
    mov [bp+4], ax
    pop dx
    pop si
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret

endp


end