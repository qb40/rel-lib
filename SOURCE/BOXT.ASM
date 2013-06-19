.Model Medium, BASIC
.386
.Code

Public  RelBoxTrans
RelBoxTrans Proc  Uses es di,\
            Layer:word, x1:word, y1:word, x2:word, y2:word, clr:word

            Local ClipL:    Word
            Local ClipR:    Word
            Local ClipT:    Word
            Local ClipB:    Word
            Local Offs:     Word
            Local Wid:      Word
            Local Hie:      Word

            Mov ClipL,0
            Mov ClipR,0
            Mov ClipT,0
            Mov ClipB,0

            Mov cx,y1
            mov dx,y2
            cmp cx,dx
            jg @swapY
@PostSwapY:
            cmp cx,199
            jg @exit
            cmp cx,0
            jl @clipTop
@PostclipTop:
            cmp dx,0
            jl @exit
            cmp dx,199
            jg @clipBottom
@PostClipBottom:
            sub dx,cx
            inc dx             ;dx=height,cx=Y1
            ;jz @exit

            ;; calc offset
            xchg ch,cl
            mov di,cx
            shr di,2
            add di,cx           ;di=320*y1

            ;;
            ;;

            mov ax,x1
            mov bx,x2
            cmp ax,bx
            jg @swapx
@PostSwapX:
            cmp ax,319
            jg @exit
            cmp ax,0
            jl @clipLeft
@PostclipLeft:
            cmp bx,0
            jl @exit
            cmp bx,319
            jg @clipRight
@PostclipRight:
            sub bx,ax
            inc bx              ;bx=width,ax=X1

            ;;;
            ;;;
            add di,ax           ;di=320*y+x
            mov offs,di         ;save offset

            ;;ax=free
            ;;bx=width
            ;;cx=free
            ;;dx=height


            Mov ax,bx
            dec ax
            cmp ax,0
            Jg @PostErrorCorrector1
                mov ClipT,1
                Mov ClipB,1
@PostErrorCorrector1:
            mov Wid,ax
            Mov Hie,dx

            ;; error corrector2
            mov cx,Hie
            dec cx
            cmp cx,0
            Jg @PostErrorCorrector2
                mov ClipR,1
                Mov ClipL,1
@PostErrorCorrector2:
            Mov Hie,Cx             ;Save hie-1
            ;store color
            Mov dx,Clr
            xor dh,dh
            mov dh,dl
            and dh,15
            sub dh,dl
            neg dh                 ;dh=base color
            and dl,15              ;dl,color AND 15
            ;;
            ;;
            mov es,Layer

            Cmp ClipT,1
            Je  @TestRight
            Mov cx,wid
            inc cx
@Toploop:
            mov ah,es:[di]              ;color of dest
            and ah,15
            mov al,dl
            add ah,al
            shr ah,1
            add ah,dh
            mov es:[di],ah
            inc di
            dec cx
            Jnz @TopLoop
@TestRight:
            Cmp ClipR,1
            Je @TestLeft
            Mov Di,Offs
            add Di,Wid
            Mov cx,Hie
            inc cx
@RightLoop:
            mov ah,es:[di]              ;color of dest
            and ah,15
            mov al,dl
            add ah,al
            shr ah,1
            add ah,dh
            mov es:[di],ah
            add di,320
            dec cx
            Jnz @RightLoop
@TestLeft:
            Cmp ClipL,1
            Je @TestBottom
            Mov cx,Hie
            inc cx
            Mov Di,Offs
@LeftLoop:
            mov ah,es:[di]              ;color of dest
            and ah,15
            mov al,dl
            add ah,al
            shr ah,1
            add ah,dh
            mov es:[di],ah
            add di,320
            dec cx
            Jnz @LeftLoop
@TestBottom:
            Cmp ClipB,1
            Je @exit
            Mov di,Offs
            mov cx,Hie
@BottomLoop:
            add di,320
            dec cx
            Jnz @BottomLoop
            Mov cx,wid
            inc cx
@BottomLoop2:
            mov ah,es:[di]              ;color of dest
            and ah,15
            mov al,dl
            add ah,al
            shr ah,1
            add ah,dh
            mov es:[di],ah
            inc di
            dec cx
            Jnz @BottomLoop2
@exit:
ret

;;;;;;Subs
;;;;;;
@swapY:
    xchg cx,dx
    Jmp @PostSwapY


@clipTop:
    mov ax,dx
    sub ax,cx
    add cx,ax
    cmp cx,0
    jl @exit
        xor cx,cx
        Mov ClipT,1
    Jmp @PostclipTop

@clipBottom:
    mov dx,199
    Mov ClipB,1
    Jmp @PostClipBottom

@swapx:
    xchg ax,bx
    Jmp @PostSwapX

@clipLeft:
    mov cx,bx
    sub cx,ax
    add ax,cx
    cmp ax,0
    jl @exit
        xor ax,ax
        Mov ClipL,1
    Jmp @PostclipLeft

@clipRight:
    mov bx,319
    Mov ClipR,1
    Jmp @PostclipRight
endp

END





