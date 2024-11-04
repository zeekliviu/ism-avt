.model small
.stack 32
.data
	sum dw 0
	filter dw 10
	filteredSum dw 0
	array dw 13,7,6,24
	anotherArray dw 100 dup (1) ; duplicate 1 for 100 times
	msg db 'Hello$'
	vb db 'How are you?$'
.code
	mov ax, @data
	mov ds, ax
	
	mov al, msg ; copy ASCII code of H
	mov ax, word ptr vb ; copy Ho

	mov ah, 09h
	mov dx, offset msg
	int 21h
	
	xor ax, ax ; use ax for computing the sum
	xor bx, bx ; use bx for the filteredSum
	mov si, offset array
	
	mov cx, 4
do_iteration:
	add ax, [si]
	mov dx, [si]
	cmp dx, filter
	jl ignore
	add bx, [si]
ignore:
	inc si
	inc si
	loop do_iteration
	
	mov sum, ax
	mov filteredSum, bx

	mov ax, 4c00h
	int 21h

end