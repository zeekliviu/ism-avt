.model small
; AX(16) -> EAX(32) -> RAX(64)
; ARM       R0-(32) -> X0(64) 
.data
	a dw 1
	b dw 65535  ; 0FFFFh ; 65535 <=> -1
	c dw -1
	d dw -2
	max dw ?
.code
start:
	mov AX,@data
	mov DS,AX
	
	mov AX, a
	cmp AX, b         ; temp = AX - b => Flags (RF)
	jle false         ; ZF = 1 OR SF != OF
	true:
		mov max, AX
		jmp final
	false:
		mov AX, b
		mov max, AX
final:
	nop
	
	mov AX, 4c00h
	int 21h
end start