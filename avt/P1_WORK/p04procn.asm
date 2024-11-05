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

    ; call proc - addv(&sum1, dimv1, &vect1);
    mov AX, offset vect1
    push AX
    mov AX, dimv1
    push AX
    mov AX, offset sum1
    push AX
    
    call NEAR PTR addv
    
    
    ; call proc - addv(&sum2, dimv2, &vect2);
    mov AX, offset vect2
    push AX
    mov AX, dimv2
    push AX
    mov AX, offset sum2
    push AX
    
    call NEAR PTR addv

    mov AX, 4c00h
    int 21h
    
; decl: void addv(short int* s, short int dim, short int* v)
addv PROC NEAR
	push BP
	mov BP, SP
	; reg save
	push CX
	
	; business logic:
	xor AX, AX ; <=> mov AX, 0
    mov SI, 0

    mov CX, SS:[BP+6] 
    shr CX, 1
    mov BX, [BP+8]
    lwhile1:
        add AX, DS:[BX][SI]  
        add SI, 2
    loop lwhile1
    
    mov BX, [BP + 4]
    mov [BX], AX
	
	; reg restore
	pop CX
	pop BP  
	ret 6       ; ???
addv ENDP
    
end start









