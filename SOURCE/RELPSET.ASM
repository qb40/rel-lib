MODEL MEDIUM, BASIC
.STACK 20H
.386
.CODE

;RELPSET(BYVAL DESTSEG,BYVAL X,BYVAL Y,BYVAL C)
;STACK
;DEST SEG       =10
;X              =8
;Y              =6
;C              =4
;QB RET SEG     =2
;QB RET OFF     =0
;ES:DI          =DEST SEG

PUBLIC RELPSET
RELPSET PROC

MOV AX,BP               ;SAVE BP
MOV BP,SP               ;POINT SP TO BP
MOV ES,[BP+10]          ;POINT ES TO DEST
MOV DX,[BP+6]           ;Y
        JL LBL_END_PSET
CMP DX,199
        JG LBL_END_PSET
MOV BX, [BP+8]          ;X

CMP BX,0                ;CLIP X
        JL LBL_END_PSET
CMP BX,319
        JG LBL_END_PSET

LEA EDX,[EDX+EDX*4]     ;Y=Y*5
SHL DX,6                ;Y=5*64=320
MOV DI,DX               ;POINT DX TO DI(DI=320)
ADD DI,BX               ;ADD X, DI=Y*320+X
MOV CL,[BP+4]           ;STORE COLOR
MOV ES:[DI],CL          ;PLOT IT

LBL_END_PSET:
MOV BP,AX               ;RESTORE BP

RET 8

RELPSET ENDP
END





