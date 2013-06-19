.MODEL MEDIUM, BASIC
.386
.STACK 200H
.CODE

;===========================================================================
;RELADDHI(BYVAL SEGINTVAL%,BYVAL OFFINTVAL%,BYVAL BYTEVAL%)
;STACK
;SEGINTVAL      =8
;OFFINTVAL      =6
;BYTEVAL        =4
;QB RET SEG     =2
;QB RET OFF     =0

PUBLIC RELADDHI
RELADDHI PROC

MOV BX,BP               ;SAVE BP
MOV BP,SP               ;POINT SP TO BP
MOV AX,[BP+8]           ;INT SEG
MOV DI,[BP+6]
MOV ES,AX
MOV AL,[BP+4]
MOV ES:[DI+1],AL

MOV BP,BX               ;RESTORE BP
RET 6

RELADDHI ENDP

;===========================================================================
;RELADDLOW(BYVAL SEGINTVAL%,BYVAL OFFINTVAL%,BYVAL BYTEVAL%)
;STACK
;SEGINTVAL      =8
;OFFINTVAL      =6
;BYTEVAL        =4
;QB RET SEG     =2
;QB RET OFF     =0

PUBLIC RELADDLOW
RELADDLOW PROC

MOV BX,BP               ;SAVE BP
MOV BP,SP               ;POINT SP TO BP
MOV AX,[BP+8]           ;INT SEG
MOV DI,[BP+6]
MOV ES,AX
MOV AL,[BP+4]
MOV ES:[DI],AL

MOV BP,BX               ;RESTORE BP
RET 6

RELADDLOW ENDP

;===========================================================================
;RELGETHI(BYVAL INTVAL%)
;STACK
;INTVAL         =4
;QB RET SEG     =2
;QB RET OFF     =0

PUBLIC RELGETHI
RELGETHI PROC

MOV BX,BP               ;SAVE BP
MOV BP,SP               ;POINT SP TO BP
MOV AX,[BP+4]           ;INTVAL
MOV AL,AH
XOR AH,AH
MOV BP,BX               ;RESTORE BP
RET 2

RELGETHI ENDP

;===========================================================================
;RELGETLOW(BYVAL INTVAL%)
;STACK
;INTVAL         =4
;QB RET SEG     =2
;QB RET OFF     =0

PUBLIC RELGETLOW
RELGETLOW PROC

MOV BX,BP               ;SAVE BP
MOV BP,SP               ;POINT SP TO BP
MOV AX,[BP+4]           ;INT 
XOR AH,AH
MOV BP,BX               ;RESTORE BP
RET 2

RELGETLOW ENDP

;===========================================================================
END





