.model small
.stack 16
.data
    sum1 dw ?
    vect1 dw 7, -2, 15, 3, -3
    dimv1 dw $ - vect1
    
    sum2 dw ?
    vect2 dw 1, 3, 7
    dimv2 dw $ - vect2
.code
start:
    mov AX, @data
    mov DS, AX
    
    ;mov AX, 1234h ;push AX ;inc AX ;push AX ;pop AX

    xor AX, AX ; <=> mov AX, 0
    mov SI, 0

    mov CX, dimv1 ; mov CX, 4
    shr CX, 1
    lwhile1:
        add AX, vect1[SI]  ; vect[SI] => DS:[SI + vect] <=> DS:[SI + vect] <=> SI[vect] aka C: v[3] <=> *(v+3) <=> 3[v]
        add SI, 2
    loop lwhile1
    mov sum1, AX
    
    xor AX, AX ; <=> mov AX, 0
    mov SI, 0

    mov CX, dimv2
    shr CX, 1
    lwhile2:
        add AX, vect2[SI] 
        add SI, 2
    loop lwhile2
    mov sum2, AX

    mov AX, 4c00h
    int 21h
end start