MODEL MEDIUM, BASIC
.STACK 200H
.386
.CODE

;RELGET(BYVAL LAYER%,BYVAL X1%,BYVAL Y1%,BYVAL X2%,BYVAL Y2%,BYVAL SPRSEG%,BYVAL SPROFF%)
;STACK
;DEST SEG       =20
;X1             =18
;Y1             =16
;X2             =14
;Y2             =12
;SPR SEG        =10
;SPR OFF        =8
;QB RET SEG     =6
;QB RET OFF     =4
;DS             =2
;BP             =0
;WIDTH          =-2
;HEIGHT         =-4

;ES:DI          =ARRAY
;DS:SI          =LAYER

PUBLIC RELGET
RELGET PROC

PUSH DS                 ;SAVE DS
PUSH BP                 ;SAVE BP
MOV BP,SP               ;POINT SP TO BP
MOV DS,[BP+20]          ;POINT LAYER SEG TO ES
MOV ES,[BP+10]          ;ARRAY SEG
MOV DI,[BP+8]           ;ARRAY OFFSET

XOR EDX,EDX
PUSH EDX

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
SHL CX,3                ;CX*8(KEWBIE USES THIS AS A FORMAT)
MOV ES:[DI],CX          ;SAVE IT TO  FIRST WORD

SUB DX,BX               ;HEIGHT OF BOX
INC DX
MOV [BP-4],DX
MOV ES:[DI+2],DX           ;SAVE HEIGHT

XCHG BH,BL              ;SHL 8=Y*256
MOV SI,BX               ;POINT Y OFFSET TO DI
SHR SI,2                ;DIVIDE SI BY 4=64
ADD SI,BX               ;Y=64+256=320
ADD SI,AX               ;STARTING OFFSET(X1,Y1)

MOV BX,320
SUB BX,[BP-2]


ADD DI,4
LBL_GET_HEIGHT_LOOP:
        MOV CX,[BP-2]           ;WIDTH
        SHR CX,2                ;W/4
        REP MOVSD               ;MOV DWORDS
        MOV CX,[BP-2]           ;REAL WIDTH FOR REMAINDER
        AND CX,3                ;REMAINDER
        REP STOSB
        ADD SI,BX               ;ADD TO OFFSET
        DEC DX                  ;DECREASE HEIGHT COUNTER
JNZ LBL_GET_HEIGHT_LOOP         ;IS IT ZERO YET?


LBL_END_IT:
ADD SP,4
POP BP
POP DS

RET 14


RELGET ENDP

END





