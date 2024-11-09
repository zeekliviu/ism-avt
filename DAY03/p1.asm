.model small

add2 macro op1, op2, sum
    mov ax, op1
    add ax, op2
    mov sum, ax
endm

exit_dos macro
    mov ax, 4c00h
    int 21h
endm

.stack 10h

.data
    a dw 9
    b dw -2
    sum dw ?

.code

start:
    mov ax, @data
    mov ds, ax

    add2 a, b, sum

    exit_dos
end start