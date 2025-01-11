.model tiny
.code

org 100h
HOST:
  mov AH, 9
  mov DX, offset HI
  int 21h

  mov AX, 4c00h
  int 21h

  HI db 'Program COM 02!$'
end HOST