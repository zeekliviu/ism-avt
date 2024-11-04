.model small
.stack 10h ;asks for a 16 byte stack
.data
	;define global variables
	; db - define byte - 1 byte
	; dw - define word - 2 byte
	; dd - define double - 4 byte
	; dq - define quad - 8 byte
	; dt - define tera - 16 byte
	a db 14 ; 14 in decimal
	b db 14h ; 14 in hexa ~ 20 in decimal
	result db ? ; 1 byte
	x dw 1234h ; 2 bytes
	y dd 33445566h ; 4 bytes
	z dq 1122112211221122h ; 8 bytes
	w dt 0 ; 10 bytes
	; paragraph - 16 bytes
	; segment - 64 KB
.code
the_main:
	mov ax, @data
	mov ds, ax

	xor ax, ax ; mov ax, 0
	
	mov al, a
	add al, b
	mov result, al
	
	push ax;
	
	mov ax, 4c00h
	int 21h
the_end:
	mov ax, offset the_end
end the_main