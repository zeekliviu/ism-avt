.model small

.stack 16

.data
a db 7
b db 9
c dw ?

.code
start:

	mov AX, @data
	mov DS, AX
	
	mov BX, AX
	mov AX, AX

	mov AX, 4C00h
	int 21h
end start