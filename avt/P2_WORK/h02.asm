.model tiny
.code
org 100h
HOST:
	MOV DX, offset message1
	MOV AH, 09h
	INT 21h
	
	mov AX, 4c00h
	int 21h
message1	DB	"I am Host 02!", '$'
end HOST