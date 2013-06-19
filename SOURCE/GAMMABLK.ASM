MODEL MEDIUM, BASIC
.STACK 20H
.386
.CODE

;RELGAMMABLOCK(BYVAL DESTSEG%,BYVAL X1%,BYVAL Y1%,BYVAL X2%,BYVAL Y2%,BYVAL GAMMAVAL%)
;STACK
;DEST SEG       =18
;X1             =16
;Y1             =14
;X2             =12
;Y2             =10
;GAMMAVAL       =8
;QB RET SEG     =6
;QB RET OFF     =4
;DS             =2
;BP             =0
;WIDTH          =-2
;HEIGHT         =-4
;320-WIDTH      =-6

;ES:DI          =DEST SEG

PUBLIC RELGAMMABLOCK
RELGAMMABLOCK PROC
PUSH DS                 ;SAVE DS
PUSH BP                 ;SAVE BP
MOV BP,SP               ;POINT SP TO BP
MOV ES,[BP+18]          ;POINT DEST SEG ES

XOR EDX,EDX
PUSH EDX
PUSH DX

;AX=X1
;CX=X2
;BX=Y1
;DX=Y2

        MOV AX,[BP+16]         ;X1
        MOV CX,[BP+12]         ;X2
        CMP AX,CX
        JLE LBL_NO_SWAP_X
        XCHG AX,CX
LBL_NO_SWAP_X:
        MOV BX,[BP+14]          ;Y1
        MOV DX,[BP+10]          ;Y2
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
MOV DI,BX               ;POINT Y OFFSET TO DI
SHR DI,2                ;DIVIDE DI BY 4=64
ADD DI,BX               ;Y=64+256=320
ADD DI,AX               ;STARTING OFFSET(X1,Y1)

MOV DH,[BP-4]           ;HEIGHT OF BOX
MOV BX,320
SUB BX,[BP-2]
MOV [BP-6],BX


MOV AH,[BP+8]           ;GAMMA VAL

LBL_Y_LOOP:

        MOV CX,[BP-2]                   ;WIDTH

LBL_X_LOOP:

        MOV AL,ES:[DI]          ;MOV COLOR
        
        CMP AL,0                ;IF C<>0 THEN
        JE LBL_SKIP_0           ;ELSE
                                ;CALCULATE NEW COLOR FOR GAMMA
           MOV BL,AL            ;SAVE COLOR
           AND AL,15            ;16 COLOR GRAD
           SUB BL,AL            ;LOWER BOUNDS
           ADD AL,AH            ;GAMMA COL
           ADD AL,BL            ;GET COL
        CMP AL,BL
        JA LBL_LIMIT_TOP
                MOV ES:[DI],BL
                JMP LBL_SKIP_0
        LBL_LIMIT_TOP:
           ADD BL,15            ;UPPER BOUNDS
        CMP AL,BL
        JB LBL_PLOT_GAMMA
                MOV ES:[DI],BL
                JMP LBL_SKIP_0
        LBL_PLOT_GAMMA:
           MOV ES:[DI],AL       ;PLOT IT
        LBL_SKIP_0:

        INC DI
        DEC CX

JNZ LBL_X_LOOP

        ADD DI,[BP-6]             ;ADD TO OFFSET
        DEC DH                  ;DECREASE HEIGHT COUNTER
JNZ LBL_Y_LOOP                  ;IS IT ZERO YET?


LBL_END_IT:

ADD SP,6
POP BP
POP DS

RET 12


RELGAMMABLOCK ENDP

END





