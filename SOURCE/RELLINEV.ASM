MODEL MEDIUM, BASIC
.STACK 20H
.386
.CODE

;DECLARE SUB RELLINEV(BYVAL DESTSEG%,BYVAL X1%,BYVAL Y1%,BYVAL Y2%,BYVAL C%)
;STACK
;DEST SEG       =16
;X1             =14
;Y1             =12
;Y2             =10
;C              =8
;RET SEG        =6
;RET OFF        =4
;BP             =2
;DS             =0

PUBLIC RELLINEV
RELLINEV PROC

PUSH BP
PUSH DS

MOV BP,SP
MOV ES,[BP+16]          ;POINT TO DEST SEG

;DX=X1
;BX=Y1
;CX=Y2
MOV DX,[BP+14]          ;X1
MOV BX,[BP+12]          ;Y1
MOV CX,[BP+10]          ;Y2

        CMP DX,319
        JG LBL_END_IT
        CMP DX,0
        JL LBL_END_IT
        
        CMP BX,199
        JG LBL_END_IT
        CMP BX,0
        JGE LBL_NO_FIX_Y1
        XOR BX,BX
LBL_NO_FIX_Y1:
        CMP CX,0
        JL LBL_END_IT
        CMP CX,199
        JLE LBL_NO_FIX_Y2
        MOV CX,199
LBL_NO_FIX_Y2:
        CMP BX,CX
        JLE LBL_NO_SWAP_Y
        XCHG BX,CX                
LBL_NO_SWAP_Y:

SUB CX,BX
INC CX

MOV AL,[BP+8]           ;COLOR


;CALCULATE THE OFFSET
;BX=Y1
;CX=LINE HEIGHT
;DX=X
;AL=COLOR


XCHG BL,BH              ;SHL 8  MUL BY 256
MOV DI,BX
SHR DI,2                ;DIV  BY 4
ADD DI,BX               ;256+64=320
ADD DI,DX               ;ADD X

;FREE REGS = BX,DX,CX
LBL_HEIGHT_LOOP:
        MOV ES:[DI],AL    ;PLOT IT
        ADD DI,320
        DEC CX
JNZ LBL_HEIGHT_LOOP



LBL_END_IT:
POP DS
POP BP
RET 10

RELLINEV ENDP

END


