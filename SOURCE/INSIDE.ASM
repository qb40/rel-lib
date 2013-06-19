MODEL MEDIUM, BASIC
.STACK 200H
.386
.CODE

;RELINSIDE(BYVAL X%,BYVAL Y%,BYVAL X1%,BYVAL Y1%,BYVAL X2%,BYVAL Y2%)
;STACK
;X              =14
;Y              =12
;X1             =10
;Y1             =8
;X2             =6
;Y2             =4
;QB RET SEG     =2
;QB RET OFF     =0
;CX=X
;DX=Y

PUBLIC RELINSIDE
RELINSIDE PROC

        MOV BX,BP
        MOV BP,SP
        XOR AX,AX       ;INIT TO FALSE

        MOV CX,[BP+14]  ;X
        CMP CX,[BP+10]  ;X1
        JL LBL_END_IT
        CMP CX,[BP+6]   ;X2
        JG LBL_END_IT

        MOV DX,[BP+12]  ;Y
        CMP DX,[BP+8]   ;Y1
        JL LBL_END_IT
        CMP DX,[BP+4]   ;Y2
        JG LBL_END_IT
        MOV AX,-1       ;TRUE
LBL_END_IT:  ;NOT INSIDE
MOV BP,BX
RET 12

RELINSIDE ENDP


;RELINSIDEC(BYVAL X%,BYVAL Y%,BYVAL XC%,BYVAL YC%,BYVAL RADIUS%)
;STACK
;X1             =14
;Y1             =12
;XC             =10
;YC             =8
;RADIUS         =6
;QB RET SEG     =4
;QB RET OFF     =2
;BP             =0

PUBLIC RELINSIDEC
RELINSIDEC PROC

        PUSH BP
        MOV BP,SP
        MOV AX,[BP+14]          ;X
        SUB AX,[BP+10]          ;GET DX
        CMP AX,0
        JG LBL_NO_ABS_DX
        NEG AX                  ;AX=ABS(AX)
LBL_NO_ABS_DX:
        ;GET SQUARE OF X
        MOV CX,AX               ;MUL DELTAX BY ITSELF
        MUL CX
        XOR DX,DX               ;GET VAL ONLY IN AX
        MOV CX,AX               ;CX=DELTA X
        
        MOV BX,[BP+12]          ;Y
        SUB BX,[BP+8]           ;GET DY
        CMP BX,0
        JG LBL_NO_ABS_DY
        NEG BX                  ;ABS DY
LBL_NO_ABS_DY:
        ;GET SQUARE OF Y
        MOV AX,BX
        MUL BX
        XOR DX,DX
        MOV BX,AX

;NOTES:
;CX=DELTAX*DELTAX
;BX=DELTAY*DELTAY
        ADD BX,CX       ;ADD THEM TOGETHER CX FREE



;HERE WE MULTIPLY RADIUS BY ITSELF AS WE ARE USING THE PYTHAGOREAN THEOREM
;BX=DISTANCE
        MOV AX,[BP+6]           ;RADIUS
        MOV CX,AX
        MUL CX                  ;MUL BY ITSELF
        XOR DX,DX
        MOV DX,AX               ;MOV RADIUS SQUARED TO DX
        XOR AX,AX               ;NOT INSIDE
        CMP BX,DX               ;CHECK IF Distance SQUARED<Radius Squared
        JG LBL_END_IT_C
        MOV AX,-1               ;INSIDE CIRCLE
LBL_END_IT_C:  ;NOT INSIDE
POP BP
RET 10

RELINSIDEC ENDP


END





