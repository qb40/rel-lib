.Model Medium, BASIC
.386
.Code

Align 2
Public  RelSmooth
RelSmooth   Proc  Uses es di,\
            Layer:word, x1:word, y1:word, x2:word, y2:word

            Local Hei:      word
            Local wid:      word
            Local t20Mw:    word


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
            mov hei, dx
            mov wid, bx

            ;;
            ;;
            mov es,Layer

@yloop:
            Mov cx, wid               ;width
@xloop:
            ;corners
            xor ax, ax
            xor bx, bx
            mov al, es:[di-321]
            mov bl, es:[di+321]
            add ax, bx
            mov bl, es:[di-319]
            add ax, bx
            mov bl, es:[di+319]
            add ax, bx
            shr ax, 4               ;div 16
            mov dx, ax

            ;sides
            xor ax, ax
            xor bx, bx
            mov al, es:[di-320]
            mov bl, es:[di+320]
            add ax, bx
            mov bl, es:[di-1]
            add ax, bx
            mov bl, es:[di+1]
            add ax, bx
            shr ax, 3               ;div 8
            add dx, ax

            ;center
            xor ax, ax
            mov al, es:[di]
            shr ax, 2               ;div 4
            add al, dl

            mov es:[di], al
            inc di
            dec cx
            jnz @xloop
            add di,t20Mw
            dec hei
            jnz @yloop
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





