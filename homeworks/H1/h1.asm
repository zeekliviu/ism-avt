.model small
.stack 100h

.data
    arr1 dw 5, 4, 3, 2, -1              
    arr1size dw 5                     
    arr2 dw 1, 3, -5, 2, 2, 9           
    arr2size dw 6                      
    arr3 dw 0, 1, -1, 1, 1, 1, 1, 1, 1, 2 
    arr3size dw 10                     
    max dw ?
    min dw ?

.code

start:
    mov ax, @data
    mov ds, ax

    mov ax, offset arr1
    push ax
    mov ax, arr1size
    push ax
    mov ax, offset max
    push ax
    mov ax, offset min
    push ax
    call minmax

    mov ax, offset arr2
    push ax
    mov ax, arr2size
    push ax
    mov ax, offset max
    push ax
    mov ax, offset min
    push ax
    call minmax

    mov ax, offset arr3
    push ax
    mov ax, arr3size
    push ax
    mov ax, offset max
    push ax
    mov ax, offset min
    push ax
    call minmax

    mov ax, 4c00h
    int 21h

; the stack for the first call: [arr1], arr1size, [max], [min], ip, **[bp], cx, ax, di, si
; Parameters:
; - [bp+10] = Array base address
; - [bp+8]  = Array size
; - [bp+6]  = Address of max
; - [bp+4]  = Address of min
minmax proc
    push bp
    mov bp, sp
    push cx
    push ax
    push di                   
    push si                   

    mov si, [bp+10]           
    mov cx, [bp+8]            
    mov di, [bp+6]            
    mov bx, [bp+4]            

    mov ax, [si]              
    mov [di], ax              
    mov [bx], ax              
    add si, 2                 

find_min_max_loop:
    dec cx                    
    cmp cx, 0                 
    je end_minmax             

    mov ax, [si]              
    cmp ax, [di]              
    jle check_min             
    mov [di], ax             

check_min:
    cmp ax, [bx]              
    jge skip_update_min       
    mov [bx], ax              

skip_update_min:
    add si, 2                 
    jmp find_min_max_loop     

end_minmax:
    pop si                    
    pop di                    
    pop ax
    pop cx
    mov sp, bp
    pop bp
    ret 8                     
minmax endp

end start