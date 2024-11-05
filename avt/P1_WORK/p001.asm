.model large

MyDataSeg SEGMENT
   sum dw ?
   vect dw 7, -2, 9, 11
   n dw 4
MyDataSeg ENDS

MyStack SEGMENT
   dw 16 dup(3)
   endstack label word
MyStack ENDS

MyMainP SEGMENT
   ASSUME CS:MyMainP, DS:MyDataSeg, SS:MyStack
start:
   ; init segments registers
   mov AX, seg MyDataSeg
   mov DS, AX
   
   mov AX, seg MyStack
   mov SS, AX
   mov SP, offset endstack
   
   ; prepare procedure call by pushing params on the stack
   ; void addv(short int* sum, short int n, short int* vect)
   mov AX, seg vect
   push AX
   mov AX, offset vect
   push AX
   
   mov AX, n
   push AX
   
   mov AX, seg sum
   push AX
   mov AX, offset sum
   push AX
   ; off sum, seg sum, val n, off vect, seg vect
   CALL FAR PTR addv
   ; off IPcurr, seg MyMainP, off sum, seg sum, val n, off vect, seg vect
   
   mov AX, 4c00h
   int 21h

MyMainP ENDS

MyProcs SEGMENT
   ASSUME CS:MyProcs
   
   addv PROC FAR
     ; off IPcurr, seg MyMainP, off sum, seg sum, val n, off vect, seg vect
     ; std. prolog
     push BP
     mov BP, SP
     ;  BP, off IPcurr, seg MyMainP, off sum, seg sum, val n, off vect, seg vect
     ;  ^                           ^
     ;  |                           |    
     ;SS:[BP+0]                  SS:[BP+6]
     
     ; save regs
     push AX
     push CX
     push SI
     push BX
     push DX
     
     ;  valBX, valSI, valCX, valAX, BP, off IPcurr, seg MyMainP, off sum, seg sum, val n, off vect, seg vect
     xor AX, AX
     mov CX, SS:[BP+10]
     mov SI, 0
     ; prepare pointer vect = @vect from stack = seg:off = DS:[BX]
     mov BX, SS:[BP+12]
     mov AX, SS:[BP+14]
     mov DS, AX
     
     xor AX, AX
     while_lable:
         add AX, DS:[BX][SI] ; add AX, DS:[BX + SI]
         add SI, 2
     loop while_lable
     
     mov BX, SS:[BP+6]
     mov DX, SS:[BP+8]
     mov DS, DX
     mov DS:[BX], AX
     
     pop DX
     pop BX
     pop SI
     pop CX
     pop AX
     
     ; std. epilog
     pop BP
     retf 10
   addv ENDP
MyProcs ENDS
end start

























