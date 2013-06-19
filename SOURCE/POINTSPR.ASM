.MODEL MEDIUM, BASIC
.STACK 100H
.386
.CODE
    
;RELPOINTONSPRITE(BYVAL DESTSEG,BYVAL DESTOFF,BYVAL X,BYVAL Y)
;RETURNS THE COLOR OF THE PIXEL FROM THE SPRITE
;STACK
;DEST SEG       =10
;DEST OFF       =8
;X              =6
;Y              =4
;QB RET SEG     =2
;QB RET OFF     =0
;ES:DI          =DEST SEG

ALIGN 2

PUBLIC RELPOINTONSPRITE
RELPOINTONSPRITE PROC

        MOV CX,BP
        MOV BP,SP               ;POINT SP TO BP
        MOV ES,[BP+10]          ;POINT ES TO DEST
        MOV DI,[BP+8]           ;DEST OFF
        
        MOV AX,[BP+4]           ;Y
        CMP AX,0
JL LBL_END_POINT
        CMP AX,ES:[DI+2]        ;CLIP Y
JG LBL_END_POINT
        MOV BX,[BP+6]           ;X
        CMP BX,0                ;CLIP X
JL LBL_END_POINT
        MOV DX,ES:[DI]          ;WIDTH
        SHR DX,3
        CMP BX,DX
JG LBL_END_POINT

        IMUL AX,DX              ;AX=Y*WIDTH
        ADD DI,4                ;FIRST COLOR
        ADD DI,AX               ;Y
        ADD DI,BX               ;AX=AX+X
        XOR AH,AH
        MOV AL,ES:[DI]
        MOV BP,CX               ;RESTORE BP
        RET 8

LBL_END_POINT:

XOR AX,AX                  ;CLEAR RETURN
MOV BP,CX                  ;RESTORE BP
RET 8

RELPOINTONSPRITE ENDP

END





