.model large
.stack 10h

; strcpy/memcpy (char *dest, char *src)

exit_dos macro
    mov ax, 4c00h
    int 21h
endm

srcseg segment
    src db 'ASM x86 on bits$'
    dimsrc dw $ - src
srcseg ends

dstseg segment
    dst db '111111111111111$'
    dimdst dw $ - dst
dstseg ends

mainprogseg segment
    assume cs:mainprogseg, ds:srcseg, es:dstseg
    start:
        mov ax, seg src
        mov ds, ax

        mov ax, seg dst
        mov es, ax

        cld
        mov si, offset src
        mov di, offset dst
        mov cx, dimsrc

        rep movsb
        exit_dos
mainprogseg ends

end start