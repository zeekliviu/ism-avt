.model large

mydataseg segment
	sum dw ?
	vect dw 7, -2, 9, 11
	n dw 4
mydataseg ends ; end segment

mystack segment
	dw 16 dup (3)
	endstack label word
mystack ends

mymain segment
	assume cs:mymain, ds:mydataseg, ss:mystack
start:
	mov ax, seg mydataseg
	mov ds, ax
 
	mov ax, seg mystack
	mov ss, ax
	mov sp, offset endstack
	
	; prepare procedure call by pushing params on the stack
	; void addv(short int* sum, short int n, short int* vect)
	mov ax, seg vect
	push ax
	mov ax, offset vect
	push ax
   
	mov ax, n
	push ax
   
	mov ax, seg sum
	push ax
	mov ax, offset sum
	push ax
	
	call far ptr addv
	
	mov ax, 4c00h
	int 21h
mymain ends

myprocs segment
	assume cs:myprocs
	
	addv proc far
	push bp
	mov bp, sp
	push ax
	push cx
	push si
	push bx
	push dx
	; [val dx], [val bx], [val si], [val cx], [val ax] , **[val bp], ret@[off after call, seg mymain], [off sum, seg sum], [val n], [off vect, seg vect]
	
	xor ax, ax
	mov cx, ss:[bp+10]
    xor si, si
    ; prepare pointer vect = @vect from stack = seg:off = ds:[bx]
    mov bx, ss:[bp+12]
    mov ax, ss:[bp+14]
    mov ds, ax
     
    xor ax, ax
label_while:
	add ax, ds:[bx][si]
	add si, 2
	loop label_while
	
	mov bx, ss:[bp+6]
	mov dx, ss:[bp+8]
	mov ds, dx
	mov ds:[bx], ax
	
	pop dx
	pop bx
	pop si
	pop cx
	pop ax
	
	pop bp
	retf 10
	addv endp
myprocs ends

end start