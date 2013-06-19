.MODEL MEDIUM,BASIC
.STACK 30H
.386
.CODE

;SUB RelRefrac(BYVAL DESTSEG%,BYVAL SourceSeg%, byval TextSeg%)
;STACK
;DEST SEG       =12
;SourceSeg      =10
;TextSeg        =8  
;RET SEG        =6
;RET OFF        =4
;BP             =2
;DS             =0
;temp           =-2
;temp           =-4

;ES:DI      =Dest SEG:Dest OFF       Vpage
;DS:SI      =source SEG:source OFF   buffer 1
;fS:bx      =Text SEG:Text OFF       texture 1


ALIGN 2

PUBLIC RelRefrac
RelRefrac PROC

PUSH BP
PUSH DS


MOV BP,SP       ;Save BP

Mov ax,[Bp+12]  ;Put address of Vpage to ES
Mov bx,[Bp+10]  ;Put address of Buffer to DS
mov cx,[bp+8]
Mov es,ax
Mov ds,bx
mov fs,cx
Mov si,320
Mov di,320

Xor Eax,Eax
push Eax

;Cx=Xloop

xor dx,dx
xor cx,cx


Lbl_Y_loop:
    xor cx,cx
Lbl_Main_loop:

    mov al,ds:[si-1]            ;xoff
    sub al,ds:[si+1]                     
    mov ah,ds:[si-320]          ;yoff
    sub ah,ds:[si+320]
    shr al,2                    ;al= xoff\4
    shr ah,2                    ;ah= yoff\4
    mov [bp-2],ax               ;save ax
    xchg ah,al                  ;swap so we could use ax
    xor ah,ah                   ;zero out high byte
    mov bx,ax                   ;put value in dx
    add bx,cx                   ;bx=Xt = X + Yoff \ 4
    mov [bp-4],cx               ;save counter
    mov ax,[bp-2]               ;restore
    xor ah,ah                   ;zero out ah
    mov cx,ax                   ;mov Y to cx
    xor dh,dh
    add cx,dx                   ;cx=yt = y + xoff \ 4
    mov gs,bx                   ;save yt
                                ;cx=yt;dx=xt
                                ;calc offset in texture
    xchg ch,cl                  ;shl cx,8
    mov bx,cx                   ;si=Y*256
    shr bx,2                    ;si=Y*256/4=64
    add bx,cx                   ;si=64+256 =320 :P
    mov cx,gs                   ;add X
    add bx,cx                   ;si=Y*320+X

    mov dh,fs:[bx]              ;get texture 

    mov es:[di],dh              ;plot to layer
        
    mov cx,[bp-4]               ;restore cx
    inc si
    inc di
    inc cx
    cmp cx,319
Jbe Lbl_Main_loop
    inc dl
    cmp dl,197
Jbe Lbl_Y_loop



add sp,4

POP DS      ;RESTORE DS
POP BP      ;RESTORE BP


RET 6


RelRefrac ENDP

END

