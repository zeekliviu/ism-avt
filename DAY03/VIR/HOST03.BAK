.model tiny
.code

org 100h
host:
    mov ah, 9
    mov dx, offset hi
    int 21h

    mov ax, 4c00h
    int 21h

hi db 'Program COM3!$'
hi2 db 'more code than 44...................................$'
end host