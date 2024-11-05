.model large
include fisio.h
.stack 10h

.data
  ;file_name db 30 dup(0)
  file_name db 'sem.txt',0
  hand dw ? ;handler
  ;afisstr1 db 'Nume Fisier:',0
  ;buf db 1024 dup(?) ;buffer pentru citire
  buf db 16 dup(2) ;buffer pentru citire
  rez dw ? ;rezultat operatii asupra fisierelor
  OctCit dw ?
  eror db 'Eroare la operatii de intrare/iesire',13,10,'$'
.code
start:
 mov ax, @data
 mov ds, ax
 ;mov file_name,30

 ;puts file_name
 ;gets file_name
 
 DeschideFisier file_name,0,hand,rez
 cmp rez,0
 jnz eroare
  
bucla:
 CitesteDinFisier hand,buf,16,OctCit,rez
 cmp rez,0
 jnz eroare
 mov SI, OctCit
 mov byte ptr buf[SI], '$'
 
 puts buf
 cmp OctCit, 16
 jb gata
jmp bucla

gata:
  InchideFisier hand,rez
  jmp iesire ; de lene nu s-a mai verificat rezultatul intors
eroare: 
 puts eror
iesire:
 exit_dos
end start

; assignment:
; hardcored matrix; make a procedure that make the sum of an array
; call the procedure for each line of the matrix; obtain an array with the sums
; write the sums in a file (first can be binary, then in string) is this the assignment ?