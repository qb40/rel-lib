.Model Medium, BASIC
.386
.Code

Public  RelBoxF
RelBoxF     Proc  Uses es di,\
            Layer:word, x1:word, y1:word, x2:word, y2:word, clr:word

            Local wid4:     word
            Local t20Mw:    Word


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
            jz @exit

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

            mov cx,320
            sub cx,bx
            mov t20Mw,cx        ;320-width

            ;;ax=free
            ;;bx=width
            ;;cx=free
            ;;dx=height

            ;store color
            mov ax,clr
            mov ah,al
            mov cx,ax
            shl eax,16
            mov ax,cx           ;eax=color(all the bytes)

            mov cx,bx
            shr cx,2            ;w\4
            mov wid4,cx
            and bx,3            ;remainder
            ;;
            ;;
            mov es,Layer

@Yloop:
            Mov cx,wid4
            rep stosd
            mov cx,bx
            rep stosb
            add di,t20Mw

            dec dx
            jnz @Yloop


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
    Jmp @PostclipTop
    Jmp @PostClipTop

@clipBottom:
    mov dx,199
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
    Jmp @PostclipLeft

@clipRight:
    mov bx,319
    Jmp @PostclipRight
endp

END





