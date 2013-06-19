MODEL MEDIUM,BASIC
.STACK 30H
.386
.CODE

;SUB RELwrapX(BYVAL DESTSEG,BYVAL SRCSEG,Byval X)
;STACK
;DEST SEG           =12
;SOURCE SEG         =10
;X                  =8
;QB RETURN SEG      =6
;QB RETURN OFF      =4
;BP                 =2
;Ds                 =0


;DS:SI              =SRC SEG:SRC OFF
;ES:DI              =DEST SEG:DEST OFF

PUBLIC ReLWrapX
RelWrapX  proc

    push bp
    push ds
    MOV BP,SP               ;POINT STACK POINTER TO BP
    MOV ES,[BP+12]          ;POINT ADDRESS OF DEST TO ES
    MOV DS,[BP+10]          ;POINT ADDRESS OF SRC TO DS
    mov ax,[Bp+08]          ;Xlocation
    xor di,di
    xor si,si               ;zero out dest and source
    cmp ax,0
    jge lbl_skip_zero_check
        xor ax,ax           ;zero it out
lbl_skip_zero_check:
    cmp ax,319
    Jle lbl_skip_319_check
        mov ax,319
lbl_skip_319_check:

    mov dx,320              ;whole scaline
    sub dx,ax               ;we now have the x value
    mov bl,200              ;Ycounter
    mov di,ax               ;put xcounter to di,start from top

lbl_Left:
    mov cx,dx               ;put start coord to counter
    shr cx,2                ;div by 2
    rep movsd               ;copy dwords for speed
    mov cx,dx               ;Restore
    and cx,3                ;get remainder
    rep movsb               ;copy byte

    add di,ax               
    add si,ax
    dec bl
    Jnz Lbl_Left


    mov bl,200              ;side finished restore new counter
    xor di,di
    mov si,dx

Lbl_Right:

    mov cx,ax               ;put start coord to counter
    shr cx,2                ;div by 2
    rep movsd               ;copy dwords for speed
    mov cx,ax               ;Restore
    and cx,3                ;get remainder
    rep movsb               ;copy byte

    add di,dx
    add si,dx

    dec bl
    Jnz Lbl_Right

    pop ds
    pop bp
    RET 6

RelWrapX ENDP

END


