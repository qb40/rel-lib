MODEL MEDIUM, BASIC
.STACK 20H
.386
.CODE

;RELPSETONSPRITET(BYVAL DESTSEG,BYVAL DESTOFF,BYVAL X,BYVAL Y,BYVAL C)
;DRAWS A TRANSLUCENT PIXEL ON A SPRITE
;STACK
;DEST SEG       =12
;DEST OFF       =10
;X              =8
;Y              =6
;C              =4
;QB RET SEG     =2
;QB RET OFF     =0
;ES:DI          =DEST SEG

PUBLIC RELPSETONSPRITET
RELPSETONSPRITET PROC

        MOV AX,BP
        MOV BP,SP               ;POINT SP TO BP
        MOV ES,[BP+12]          ;POINT ES TO DEST
        MOV DI,[BP+10]          ;DEST OFF
        
        MOV DX,[BP+6]           ;Y
        CMP DX,0
JL LBL_END_PSET
        CMP DX,ES:[DI+2]        ;CLIP Y
JG LBL_END_PSET
        MOV BX,[BP+8]           ;X
        CMP BX,0                ;CLIP X
JL LBL_END_PSET
        MOV CX,ES:[DI]
        SHR CX,3
        CMP BX,CX
JG LBL_END_PSET

        IMUL DX,CX
        ADD DI,4
        MOV CL,ES:[DI]          ;DEST COLOR
        ADD DI,DX
        MOV CH,[BP+4]           ;COLOR
        AND CL,15
        ADD DI,BX
        MOV DL,CH
        AND CH,15
        SUB DL,CH
        ADD CH,CL               ;BASE COLOR
        SHR CH,1                ;AVERAGE
        ADD DL,CH               ;ADD TO BASE


        MOV ES:[DI],DL          ;PLOT IT

LBL_END_PSET:

MOV BP,AX                  ;RESTORE BP

RET 10

RELPSETONSPRITET ENDP
END





