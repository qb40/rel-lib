MODEL MEDIUM, BASIC
.STACK 20H
.386
.CODE

;DECLARE SUB RELLINETRANSH(BYVAL DESTSEG%,BYVAL X1%,BYVAL Y1%,BYVAL X2%,BYVAL C%)
;STACK
;DEST SEG       =16
;X1             =14
;Y1             =12
;X2             =10
;C              =8
;RET SEG        =6
;RET OFF        =4
;BP             =2
;DS             =0

PUBLIC RELLINETRANSH
RELLINETRANSH PROC

PUSH BP
PUSH DS

MOV BP,SP
MOV ES,[BP+16]          ;POINT TO DEST SEG

;DX=Y1
;BX=X1
;CX=X2


MOV DX,[BP+12]          ;Y1
MOV BX,[BP+14]          ;X1
MOV CX,[BP+10]          ;X2

        CMP DX,199
        JG LBL_END_IT
        CMP DX,0
        JL LBL_END_IT
        
        CMP BX,319
        JG LBL_END_IT
        CMP BX,0
        JGE LBL_NO_FIX_X1
        XOR BX,BX
LBL_NO_FIX_X1:
        CMP CX,0
        JL LBL_END_IT
        CMP CX,319
        JLE LBL_NO_FIX_X2
        MOV CX,319
LBL_NO_FIX_X2:
        CMP BX,CX
        JLE LBL_NO_SWAP_X
        XCHG BX,CX                
LBL_NO_SWAP_X:

SUB CX,BX
INC CX

MOV AL,[BP+8]


;CALCULATE THE OFFSET
;BX=X1
;CX=LINE LENGTH
;DX=Y1
;EAX=COLOR


XCHG DL,DH              ;SHL 8  MUL BY 256
MOV DI,DX
SHR DI,2                ;DIV  BY 4
ADD DI,DX               ;256+64=320
ADD DI,BX               ;ADD X


;FREE REGS = BX,DX,CX
MOV BL,AL
MOV BH,AL
AND BH,15

LBL_WIDTH_LOOP:
        MOV AL,BH
        MOV AH,ES:[DI]       ;GET DEST COLOR
        AND AH,15            ;AND IT
        ADD AH,AL            ;ADD THEM COLORS 2GETHER
        SHR AH,1             ;DIV THEM BY 2   
        SUB AL,BL            ;GET THE BASE COLOR
        NEG AL
        ADD AL,AH            ;ADD THEM TO D BASE COLOR
        MOV ES:[DI],AL       ;PLOT IT   
        INC DI
        DEC CX
JNZ LBL_WIDTH_LOOP


LBL_END_IT:
POP DS
POP BP
RET 10

RELLINETRANSH ENDP

END


