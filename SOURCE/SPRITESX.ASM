MODEL MEDIUM, BASIC
.STACK 20H
.386
.CODE

;RELSPRITESOLIDX(BYVAL DESTSEG%,BYVAL SRCSEG%,BYVAL X1%,BYVAL Y1%,BYVAL X2%,BYVAL Y2%,BYVAL NEWX%,BYVAL NEWY%)
;WARNING!!!!! NO CLIPPING DONE!!!!(AT LEAST FOR NEWX AND NEWY) :-)
;STACK
;DEST SEG       =22
;SRC  SEG       =20
;X1             =18
;Y1             =16
;X2             =14
;Y2             =12
;NEWX           =10
;NEWY           =8
;QB RET SEG     =6
;QB RET OFF     =4
;DS             =2
;BP             =0
;WIDTH          =-2
;HEIGHT         =-4
;DOUBLEWORD     =-6

;ES:DI          =DEST SEG
;DS:SI          =SRC SEG

PUBLIC RELSPRITESOLIDX
RELSPRITESOLIDX PROC
PUSH DS                 ;SAVE DS
PUSH BP                 ;SAVE BP
MOV BP,SP               ;POINT SP TO BP
MOV ES,[BP+22]          ;POINT DEST SEG TO ES
MOV DS,[BP+20]          ;POINT SRC SEG TO DS

XOR EDX,EDX
PUSH EDX
PUSH DX

;AX=X1
;CX=X2
;BX=Y1
;DX=Y2
        MOV AX,[BP+18]         ;X1
        MOV CX,[BP+14]         ;X2
        CMP AX,CX
        JLE LBL_NO_SWAP_X
        XCHG AX,CX
LBL_NO_SWAP_X:
        MOV BX,[BP+16]          ;Y1
        MOV DX,[BP+12]          ;Y2
        CMP BX,DX
        JLE LBL_NO_SWAP_Y
        XCHG BX,DX
LBL_NO_SWAP_Y:
        CMP AX,319
        JG LBL_END_IT
        CMP BX,199
        JG LBL_END_IT
        CMP AX,0
        JGE LBL_NO_FIX_X1
        XOR AX,AX
LBL_NO_FIX_X1:
        CMP BX,0
        JGE LBL_NO_FIX_Y1
        XOR BX,BX
LBL_NO_FIX_Y1:
        CMP CX,0
        JL LBL_END_IT
        CMP DX,0
        JL LBL_END_IT
        CMP CX,319
        JLE LBL_NO_FIX_X2
        MOV CX,319
LBL_NO_FIX_X2:
        CMP DX,199
        JLE LBL_NO_FIX_Y2
        MOV DX,199
LBL_NO_FIX_Y2:

SUB CX,AX               ;WIDTH OF BOX
INC CX
MOV [BP-2],CX

SUB DX,BX               ;HEIGHT OF BOX
INC DX
MOV [BP-4],DX

XCHG BH,BL              ;SHL 8=Y*256
MOV SI,BX               ;POINT Y OFFSET TO DI
SHR SI,2                ;DIVIDE DI BY 4=64
ADD SI,BX               ;Y=64+256=320
ADD SI,AX               ;STARTING OFFSET(X1,Y1)

MOV DX,[BP-4]           ;HEIGHT OF BOX
MOV BX,320
SUB BX,[BP-2]

MOV CX,[BP-2]
SHR CX,2                ;DIV BY 4
MOV [BP-6],CX           ;DAMN!!!! NO MORE REGS!!!!! :(

;NOW LETS CALCULATE NEWY
;SI=NEWY+NEWX
;FREE REG TO USE:AX
MOV AX,[BP+8]           ;NEWY
XCHG AL,AH
MOV DI,AX
SHR AX,2
ADD DI,AX
ADD DI,[BP+10]          ;NEWX

LBL_DOUBLE_WORD:
        MOV CX,[BP-6]
        REP MOVSD               ;DRAW 1 LINE
        MOV CX,[BP-2]           ;REAL WIDTH FOR REMAINDER
        AND CX,3                ;REMAINDER
        REP MOVSB
        ADD DI,BX               ;ADD TO OFFSET
        ADD SI,BX
        DEC DX                  ;DECREASE HEIGHT COUNTER
JNZ LBL_DOUBLE_WORD             ;IS IT ZERO YET?


LBL_END_IT:
ADD SP,6
POP BP
POP DS

RET 16


RELSPRITESOLIDX ENDP

END





