.Model Medium, BASIC
.386
.Code

Public  xRelMode7
xRelMode7   Proc  Uses es di ds si,\
            Layer:word, x1:word, y1:word, x2:word, y2:word, scalex:word, scaley:word, scalez:word, horz:word,\
            cosa: word, sina: word, camx: Dword, camy: Dword, TextSeg: word, TextOff: word

            Local xv:       Dword
            Local yv:       DWord
            Local Ldx:      Dword
            Local Ldy:      DWord
            Local sx:       Dword
            Local sy:       DWord
            Local tsl:      Dword
            Local ya:       Word
            Local xa:       Word
            Local xTsize:   Word
            Local yTsize:   Word
            Local xTsizeM1: Word
            Local yTsizeM1: Word
            Local t20Mw:    Word
            Local wid:      Word
            Local Hei:      Word
            Local widd2:    DWord
            Local xShift:   Byte            


;ES: DI = DEST
;DS: SI = Texture


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
            mov wid, bx
            shr bx, 1
            mov ax, bx
            cwde
            mov widd2, eax       ;center
            mov hei, dx
            

mov ax, cosa
cwde               ;eax=ax
mov xv, eax
mov ax, sina
cwde
mov yv, eax
xor eax, eax
mov ax, scalez
mov bx, scaley
imul ax, bx
Shl eax, 8
mov Tsl, eax    

mov ya, 0             ;ya =word


mov es, Layer
mov ds, TextSeg
mov si, TextOff
mov ax, ds:[si]
shr ax, 3             ;width \8
mov xTsize, ax
dec ax
mov xTsizeM1 ,ax

mov ax, ds:[si+2]
mov yTsize, ax
dec ax
mov yTsizeM1 ,ax


mov ax, xTsize
    cmp ax, 2
    jne @xpow4
        mov xShift, 1
        jmp @yloop
@xpow4:
    cmp ax, 4
    jne @xpow8
        mov xShift, 2
        jmp @yloop
@xpow8:
    cmp ax, 8
    jne @xpow16
        mov xShift, 3
        jmp @yloop
@xpow16:
    cmp ax, 16
    jne @xpow32
        mov xShift, 4
        jmp @yloop
@xpow32:
    cmp ax, 32
    jne @xpow64
        mov xShift, 5
        jmp @yloop
@xpow64:
    cmp ax, 64
    jne @xpow128
        mov xShift, 6
        jmp @yloop
@xpow128:
    cmp ax, 128
    jne @xpow256
        mov xShift, 7
        jmp @yloop
@xpow256:
    cmp ax, 256
    jne @exit
    mov xShift, 8

@yloop:                             
        mov ax, ya
        add ax, horz
        cwde
        mov ebx, eax            ;copy
        mov eax, tsl
        xor edx,edx             ;just to be sure
        idiv ebx                ;eax=distance&

                                ;eax=eax\(ya%+horz%)
        mov ebx, eax            ;save distance
        mov ecx, eax            ;copy
        xor edx, edx            ;yeah
        mov ax, scalex
        cwde                    ;eax=scalex
        xchg eax, ecx           ;eax = dist              ;swap for idiv
                                ;ecx = scalex
        idiv ecx                ;eax = Horizscale

        mov ecx, eax            ;ecx=horizscale&
        mov edx, ecx
        neg edx
        imul edx, yv
        mov ldx, edx
        imul ecx, xv
        mov ldy, ecx

        mov eax,ebx            ;we saved it above
                               ;eax and ebx = distance

        ;ebx=distance
        ;edx=ldx

        imul ebx, xv
        imul edx, widd2           ;edx=wid\2*Ldx&
        sub ebx, edx              ;distance&*xv&-160*ldx&
        mov sx, ebx
        mov edx, camx
        add sx, edx

        ;eax=distnce
        ;ecx=ldy

        imul eax, yv
        imul ecx, widd2            ;wid\2*Ldy&
        sub eax, ecx               ;distance&*yv&-160*ldy&
        mov sy, eax
        mov ecx, camy
        add sy, ecx
        mov cl, xshift
        mov bx, wid                ;cx=counter%
        mov xa, bx
@xloop:  
        mov eax, sx
        sar eax, 16
        and ax, xTsizeM1
                                        

        mov ebx,sy
        sar ebx,16
        and bx, yTsizeM1

        ;imul bx, xTsize             ;y*xTsize
        sal bx, cl
        mov si, bx
        add si, ax                  ;toff=toff+x
        add si, TextOff
        mov al, ds:[si+4]           ;texel
        mov es:[di], al             ;*;)


        mov edx,ldx
        mov eax,ldy
        add sx,edx
        add sy,eax
        inc di
        dec xa
        jnz @xloop
            add di, t20Mw
            mov ax, hei
            add ya,1
    cmp ya, ax
    jl @yloop

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

Endp

END





