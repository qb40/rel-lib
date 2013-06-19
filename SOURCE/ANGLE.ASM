.MODEL MEDIUM, BASIC
.386
.STACK 200H
.CODE

;RELANGLE(BYVAL X1%,BYVAL Y1%,BYVAL X2%,,BYVAL Y2%)
;FUNCTION
;RETURNS AN ANGLE IN DEGREES
;STACK
;X1             =12
;Y1             =10
;X2             =8
;Y2             =6
;QB RET SEG     =4
;QB RET OFF     =2
;BP             =0
;ST             =-2
;ST             =-4


PUBLIC RELANGLE
RELANGLE PROC

    PUSH BP
    MOV BP,SP
    XOR EAX,EAX
    XOR EBX,EBX
    SUB SP,4

    MOV AX,[BP+12]          ;X1
    MOV BX,[BP+10]          ;Y1
    MOV CX,[BP+8]           ;X2
    MOV DX,[BP+6]           ;Y2

;SPECIAL CASES

;X
    CMP CX,AX               ;IF X1=X2 THEN
    JNE SHORT LBL_GET_ANGLE
    CMP BX,DX
    JGE SHORT LBL_ZERO_ANGLE	
    MOV AX,180
    JMP LBL_END_ANGLE	
LBL_ZERO_ANGLE:
    SUB AX,AX
    JMP LBL_END_ANGLE
LBL_GET_ANGLE:
    SUB CX,AX               ;CX=DELTAX
    SUB DX,BX               ;DX=DELTAY
    MOV AX,CX
    CWDE                    ;CONVERT TO DOUBLE WORD
    MOV EBX,EAX             ;EBX=DELTAX
    MOV AX,DX
    CWDE                        ;EAX=DELTAY
    FNINIT                      ;INIT FPU
    MOV DWORD PTR [BP-4],180    ;ST2 TO BE MULT BY SLOPE/PI
    FILD DWORD PTR [BP-4]       ;ST(1)
    MOV DWORD PTR [BP-4],EAX    ;EAX
    FILD DWORD PTR [BP-4]       ;ST(1)
    MOV DWORD PTR [BP-4],EBX    ;EBX
    FILD DWORD PTR [BP-4]       ;ST(0)
    FDIV                        ;ST(1)/ST(0)
    FLD1                        ;TEMP ST(1)/1.0
    FPATAN                      ;ATN(DELTAX/DELTAY)  THIS WILL BE ST(1)
    FLDPI                       ;LOAD PI
    FDIV                        ;SLOPE/PI
    FMUL                        ;RESULT*180
    FISTP DWORD PTR [BP-4]      ;SAVE
    FWAIT
    MOV EAX, DWORD PTR [BP-4]
    ADD AX,90
    MOV BX,[BP+8]               ;X2
    CMP BX,[BP+12]              ;IS X2<=X1?
    JGE LBL_END_ANGLE
    ADD AX,180

LBL_END_ANGLE:
    SUB AX,90
    CMP AX,0
    JGE SHORT LBL_NO_FIX
    ADD AX,360
LBL_NO_FIX:
    ADD SP,4
    POP BP
    RET 8

RELANGLE ENDP
END

