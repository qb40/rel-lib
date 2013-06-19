.MODEL MEDIUM,BASIC
.STACK 30H
.386
.CODE

;SUB RelWater(BYVAL DESTSEG%,BYVAL SourceSeg%,)
;STACK
;DEST SEG       =10
;SourceSeg      =8  
;RET SEG        =6
;RET OFF        =4
;BP             =2
;DS             =0


;DS:SI      =Source SEG:Source OFF   buffer 1
;ES:DI      =DEST SEG:DEST OFF       buffer 2

ALIGN 2

PUBLIC RelWater
RelWater PROC

PUSH BP
PUSH DS


MOV BP,SP       ;Save BP

Mov ax,[Bp+10]  ;Put address of dest to ES
Mov bx,[Bp+08]  ;Put address of source to DS
Mov es,ax
Mov ds,bx
Mov si,320      ;non-edge pixel
Mov di,320
Mov cx,320

Lbl_Main_loop:
    xor bx,bx
    mov bl,ds:[si+1]
    mov ax,bx
    mov bl,ds:[si-1]
    add ax,bx
    mov bl,ds:[si+320]
    add ax,bx
    mov bl,ds:[si-320]
    add ax,bx
    mov bl,ds:[si-319]
    add ax,bx
    mov bl,ds:[si+319]
    add ax,bx
    mov bl,ds:[si-321]
    add ax,bx
    mov bl,ds:[si+321]
    add ax,bx


    shr ax,2
    mov bl,es:[di]
    sub ax,bx
    mov dx,ax
    sar dx,8
    sub ax,dx
    jle Lbl_Neg
Lbl_Post_Neg:
    mov es:[di],al

    inc si
    inc di
    inc cx
    cmp cx,63680           ;63358                 ;63678

Jbe Lbl_Main_loop



POP DS      ;RESTORE DS
POP BP      ;RESTORE BP


RET 4


Lbl_Neg:
    neg ax
Jmp Lbl_Post_Neg

RelWater ENDP

END

