MODEL MEDIUM, BASIC
.STACK 20H
.386
.CODE

;RELBOXTRANS(BYVAL DESTSEG%,BYVAL X1%,BYVAL Y1%,BYVAL X2%,BYVAL Y2%,BYVAL C%)
;STACK
;DEST SEG       =18
;X1             =16
;Y1             =14
;X2             =12
;Y2             =10
;C              =8
;QB RET SEG     =6
;QB RET OFF     =4
;DS             =2
;BP             =0
;WIDTH          =-2
;HEIGHT         =-4

;ES:DI          =DEST SEG

PUBLIC RELBOXTRANS
RELBOXTRANS PROC

PUSH DS                 ;SAVE DS
PUSH BP                 ;SAVE BP
MOV BP,SP               ;POINT SP TO BP
MOV ES,[BP+18]          ;POINT DEST SEG TO ES


XOR EDX,EDX
PUSH EDX

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
INC CX                  ;LENGTH =(X2-X1)+1
MOV [BP-2],CX

SUB DX,BX               ;HEIGHT OF BOX
INC DX                  ;HEIGHT =(Y2-Y1)+1
MOV [BP-4],DX

XCHG BH,BL              ;SHL 8=Y*256
MOV DI,BX               ;POINT Y OFFSET TO DI
SHR DI,2                ;DIVIDE DI BY 4=64
ADD DI,BX               ;Y=64+256=320
ADD DI,AX               ;STARTING OFFSET(X1,Y1)

MOV DL,[BP-4]           ;HEIGHT OF BOX
MOV AL,[BP+8]           ;COLOR
MOV BX,320              ;UHHHHHH........
SUB DL,2                ;JUST SOME BUG FIX I DID TO COMPENSATE FOR DI
SUB BX,[BP-2]           ;SUBTRACT LENGTH FROM 320 TO GET REAL OFFSET TO ADD
MOV DH,AL               ;COLOR TO PLOT
AND DH,15               ;GET 0 TO 15(16 COLOR GRAD)

MOV CX,[BP-2]           ;PLOT FIRSTLINE
LBL_TOP_LOOP:
        MOV AL,DH
        MOV AH,ES:[DI]          ;GET COLOR OF DEST SEG
        AND AH,15               ;16 COLOR GRADIENT
        ADD AH,AL               ;ADD THE AVE PIX
        SHR AH,1                ;DIV BY 2
        SUB AL,[BP+8]           ;BASE COLOR
        NEG AL                  ;NEGATIVE VALUE
        ADD AL,AH
        MOV ES:[DI],AL          ;PLOT IT
        INC DI
        DEC CX
JNZ LBL_TOP_LOOP

        ADD DI,BX               ;HAFTA SUB DL BY 2 SINCE I ADDED HERE

LBL_PLOTNEXTLINE:
        MOV AL,DH               ;LEFT POINT
        MOV AH,ES:[DI]          ;GET COLOR OF DEST SEG
        AND AH,15               ;16 COLOR GRADIENT
        ADD AH,AL               ;ADD THE AVE PIX
        SHR AH,1                ;DIV BY 2
        SUB AL,[BP+8]           ;BASE COLOR
        NEG AL                  ;NEGATIVE VALUE
        ADD AL,AH
        MOV ES:[DI],AL          ;PLOT IT

        ADD DI,[BP-2]           ;CALC RIGHT POINT    
        MOV AL,DH               ;RIGHT POINT
        MOV AH,ES:[DI-1]        ;GET COLOR OF DEST SEG
        AND AH,15               ;16 COLOR GRADIENT
        ADD AH,AL               ;ADD THE AVE PIX
        SHR AH,1                ;DIV BY 2
        SUB AL,[BP+8]           ;BASE COLOR
        NEG AL                  ;NEGATIVE VALUE
        ADD AL,AH
        MOV ES:[DI-1],AL        ;PLOT IT 

        ADD DI,BX               ;ADD TO OFFSET
        DEC DL                  ;DECREASE HEIGHT COUNTER
JNZ LBL_PLOTNEXTLINE            ;IS IT ZERO YET?

        MOV CX,[BP-2]           ;PLOT LAST LINE
LBL_PLOT_LAST_LINE:
        MOV AL,DH
        MOV AH,ES:[DI]          ;GET COLOR OF DEST SEG
        AND AH,15               ;16 COLOR GRADIENT
        ADD AH,AL               ;ADD THE AVE PIX
        SHR AH,1                ;DIV BY 2
        SUB AL,[BP+8]           ;BASE COLOR
        NEG AL                  ;NEGATIVE VALUE
        ADD AL,AH
        MOV ES:[DI],AL          ;PLOT IT
        INC DI
        DEC CX
JNZ LBL_PLOT_LAST_LINE

LBL_END_IT:

ADD SP,4
POP BP
POP DS

RET 12


RELBOXTRANS ENDP

END





