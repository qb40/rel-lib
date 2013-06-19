MODEL MEDIUM, BASIC
.STACK 20H
.386
.CODE


;RELLINE(BYVAL DESTSEG%,BYVAL X1%,BYVAL Y1%,BYVAL X2%,BYVAL Y2%,BYVAL C%)
;STACK
;DEST SEG       =26
;X1             =24
;Y1             =22
;X2             =20
;Y2             =18
;C              =16
;QB RET SEG     =14
;QB RET OFF     =12
;DS             =10
;BP             =8
;DEX            =6
;DEY            =4
;INCF HORZ      =2
;INCF VERT      =0

;ES:DI          =DEST SEG


PUBLIC RELLINE
RELLINE PROC

        PUSH    DS              ;SAVE IMPORTANT REGS AND PUSH SOME NEEDED
        PUSH    BP              ;TEMPORARY VALUES TO THE STACK
        PUSH    EAX
        PUSH    EBX

        MOV     BP,SP           ;REFERENCE BP WITH SP

;=====================CLIPPING TIME!!!!!

;=====XXXXXXXXXXXXXX
        MOV     AX,[BP+24]      ;X1
        CMP AX,0
JGE LBL_NO_CLIP_X1_L
        XOR AX,AX
        MOV [BP+24],AX          ;SAVE NEW VALUE TO STACK
LBL_NO_CLIP_X1_L:
        CMP AX,319
JLE LBL_NO_CLIP_X1_R
        MOV AX,319
        MOV [BP+24],AX          ;SAVE NEW VALUE TO STACK
LBL_NO_CLIP_X1_R:

        MOV BX,[BP+20]          ;X2
        CMP BX,0
JGE LBL_NO_CLIP_X2_L
        XOR BX,BX
        MOV [BP+20],BX          ;SAVE NEW VALUE TO STACK
LBL_NO_CLIP_X2_L:
        CMP BX,319
JLE LBL_NO_CLIP_X2_R
        MOV BX,319
        MOV [BP+20],BX          ;SAVE NEW VALUE TO STACK
LBL_NO_CLIP_X2_R:

;=====YYYYYYYYYYYYYYYYY
        MOV CX,[BP+22]         ;Y1
        CMP CX,0
JGE LBL_NO_CLIP_Y1_L
        XOR CX,CX                
        MOV [BP+22],CX          ;SAVE NEW VALUE TO STACK
LBL_NO_CLIP_Y1_L:
        CMP CX,199
JLE LBL_NO_CLIP_Y1_R
        MOV CX,199
        MOV [BP+22],CX          ;SAVE NEW VALUE TO STACK
LBL_NO_CLIP_Y1_R:

        MOV DX,[BP+18]          ;Y2
        CMP DX,0
JGE LBL_NO_CLIP_Y2_L
        XOR DX,DX
        MOV [BP+18],DX          ;SAVE NEW VALUE TO STACK
LBL_NO_CLIP_Y2_L:
        CMP DX,199
JLE LBL_NO_CLIP_Y2_R
        MOV DX,199
        MOV [BP+18],DX          ;SAVE NEW VALUE TO STACK
LBL_NO_CLIP_Y2_R:

;=============END CLIP=================
;REGS:
;AX=X1
;BX=X2
;CX=Y1
;DX=Y2


        SUB     BX,AX           ;GET DELTA X
        MOV     [BP+6], BX      ;SAVE IT TO STACK
        SUB     DX,CX           ;GET DELTA Y
        MOV     [BP+4], DX      ;SAVE IT TO STACK

        ;TYPE OVERIDE  TO SAVE TICKS
        MOV     WORD PTR [BP+2], 1      ;INCF1  HORIZONTAL
        MOV     WORD PTR [BP], 320      ;INCF2  VERTICAL

;COMPARE VALUES NO XCHG NEEDED ;-)

        MOV     BX,[BP+20]      ;X2
        CMP     AX,BX           ;COMPARE WHICH IS HIGHER
        JLE     LBL_COMP_Y      ;IF OKAY THEN SKIP NEGS

        ;THEN AGAIN...OVERRIDE. OH I LOVE THIS NEW COMMAND!!!!
        NEG     WORD PTR [BP+2] ;SET HORIZ INCF TO -1
        NEG     WORD PTR [BP+6] ;DELTAX=-DELTAX (SPIFFY HUH?)
               
LBL_COMP_Y:
        MOV     DX,[BP+18]       ;Y2
        CMP     CX, DX           ;CHECK IF NEED TO NEGATE
        JLE     LBL_CALCULATE    ;
        ;I KNOW, I KNOW...........
        NEG     WORD PTR [BP]    ;SET VERT INCF TO -320
        NEG     WORD PTR [BP+4]  ;REVERSE DIRECTION ;-)

LBL_CALCULATE:
        MOV     ES,[BP+26]       ;SET OUR DEST SEG
        XCHG    CL,CH            ;Y1*256
        MOV     DI,CX            ;DI=256
        SHR     DI,2             ;DI=64
        ADD     DI,CX            ;64+256=????? YA DO THE MATH ;)
        ADD     DI,AX            ;OFFSET DONE       

;CHECK IF WE DRAW HORIZ OR VERT
        MOV     AX,[BP+6]        ;DELTA X
        MOV     BX,[BP+4]        ;DELTA Y
        CMP     AX,BX            ;COMPARE
        JLE     LBL_VERTICAL              ;IF DELTAX<=DELTAY THEN DRAW VERTICAL

;;==================XLINE========================
;HORIZONTAL LINE
        XOR     BX, BX          ;ERROR TERM
        CMP     AX,0            ;IF > THAN ZERO THEN POSITIVE LINE 
        JG      LBL_POSITIVE_LINE  ;ELSE
        NEG     AX              ;MAKE IT POSITIVE

LBL_POSITIVE_LINE:
        MOV     CX,AX           ;COUNTER=DELTAX
        MOV     AL,[BP+16]      ;COLOR
        INC     CX              ;CORRECT VALUE DELTAX=DELTAX+1
LBL_DRAW_LOOP_H:  
        MOV     ES:[DI],AL      ;PLOT ONE PIXEL
        ADD     DI,[BP+2]       ;ADD DELTAX  TO OFFSET
        ADD     BX,[BP+4]       ;ADD DELTAY TO ERROR TERM
        CMP     BX,[BP+6]       ;IF ERROR TERM < DELTAX THEN PLOT ANOTHER
        JL      LBL_GO_ON_H     ;ELSE
        ADD     DI,[BP]         ;ADD INC FACTOR TO OFFSET
        SUB     BX,[BP+6]       ;SUB DELTAX FROM BX
LBL_GO_ON_H:
        DEC     CX              ;DEC DELTAX
        JNZ     LBL_DRAW_LOOP_H ;IF NOT ZERO THEN RETURN
        JMP     LBL_END_IT      ;ELSE..... GO AWAY MONKEY BOY!!!!


;;;;==================OTHER LINE====================
;BX=DELTAY

LBL_VERTICAL:                              
        XOR     AX, AX          ;ERROR TERM
        CMP     BX,0            ;IF GREATER THAN O THEN POSITIVE
        JG      LBL_POSITIVE_LINE_Y    ;ELSE
        NEG BX                  ;MAKE IT POSITIVE

LBL_POSITIVE_LINE_Y:
        MOV CX,BX               ;MOV DELTAY TO COUNTER
        
        MOV     BL,[BP+16]      ;COLOR
        INC     CX              ;CORRECT VALUE SINCE WE'LL CHECK VIA JNZ

LBL_DRAW_LOOP_V:  
        MOV     [DI],BL         ;PLOT IT
        ADD     DI,[BP]         ;ADD INCF VERTICAL TO OFFSET
        ADD     AX,[BP+6]       ;ADD DELTAX TO ERROR TERM
        CMP     AX,[BP+4]       ;IF ERROR TERM > DELTAY THEN
        JL      LBL_GO_ON_V     ;PLOT NEXT PIXEL
        ADD     DI,[BP+2]       ;ADD INC FACTOR TO THE OFFSET
        SUB     AX,[BP+4]       ;SUB DELTAY TO AX
LBL_GO_ON_V:
        DEC     CX              ;DECREMENT DELTAY
        JNZ     LBL_DRAW_LOOP_V ;IF NOT ZERO GO BACK

LBL_END_IT:
        POP     EAX             
        POP     EAX             
        POP     BP              
        POP     DS              
        RET     12              

RELLINE ENDP

END





