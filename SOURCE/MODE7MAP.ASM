.Model Medium, BASIC
.386
.Code

Public  xRelMode7Map
xRelMode7Map    Proc  Uses es di ds si,\
                Layer:word, x1:word, y1:word, x2:word, y2:word, scalex:word, scaley:word, scalez:word, horz:word,\
                cosa: word, sina: word, camx: Dword, camy: Dword, TextSeg: word, TextOff: word, Mapseg:Word, MapOff: word, xMapsize:word,yMapsize: word

            Local xv:           Dword
            Local yv:           DWord
            Local Ldx:          Dword
            Local Ldy:          DWord
            Local sx:           Dword
            Local sy:           DWord
            Local tsl:          Dword
            Local ya:           Word
            Local xa:           Word
            Local xTsize:       Word
            Local yTsize:       Word
            Local xTsizeM1:     Word
            Local yTsizeM1:     Word
            Local t20Mw:        Word
            Local wid:          Word
            Local Hei:          Word
            Local widd2:        DWord
            Local xMapsizeM1:   Word
            Local yMapsizeM1:   Word
            Local TileSize:     Word
            Local xShift:       Byte
            Local yShift:       Byte
            Local mShift:       Byte            ;map size


;ES: DI = DEST
;DS: SI = Texture
;Fs: Bx = Map


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


mov Fs, Mapseg
mov ax, xMapSize
dec ax
mov xMapSizeM1, ax

mov bx, yMapSize
dec bx
mov yMapSizeM1, bx

;;Calc tilesize

    mov bx, xTsize
    imul bx, yTsize
    add bx, 4
    mov Tilesize, bx

;;;check xmapsize
mov ax, xMapsize
    cmp ax, 2
    jne @mpow4
        mov mShift, 1
        jmp @checkx
@mpow4:
    cmp ax, 4
    jne @mpow8
        mov mShift, 2
        jmp @checkx
@mpow8:
    cmp ax, 8
    jne @mpow16
        mov mShift, 3
        jmp @checkx
@mpow16:
    cmp ax, 16
    jne @mpow32
        mov mShift, 4
        jmp @checkx
@mpow32:
    cmp ax, 32
    jne @mpow64
        mov mShift, 5
        jmp @checkx
@mpow64:
    cmp ax, 64
    jne @mpow128
        mov mShift, 6
        jmp @checkx
@mpow128:
    cmp ax, 128
    jne @mpow256
        mov mShift, 7
        jmp @checkx
@mpow256:
    cmp ax, 256
    jne @exit
    mov mShift, 8

;;check tilesize
;;xxxxxxx
@checkx:
mov ax, xTsize
    cmp ax, 2
    jne @xpow4
        mov xShift, 1
        jmp @checky
@xpow4:
    cmp ax, 4
    jne @xpow8
        mov xShift, 2
        jmp @checky
@xpow8:
    cmp ax, 8
    jne @xpow16
        mov xShift, 3
        jmp @checky
@xpow16:
    cmp ax, 16
    jne @xpow32
        mov xShift, 4
        jmp @checky
@xpow32:
    cmp ax, 32
    jne @xpow64
        mov xShift, 5
        jmp @checky
@xpow64:
    cmp ax, 64
    jne @xpow128
        mov xShift, 6
        jmp @checky
@xpow128:
    cmp ax, 128
    jne @xpow256
        mov xShift, 7
        jmp @checky
@xpow256:
    cmp ax, 256
    jne @exit
    mov xShift, 8
;;;yyyyyyyyy
@checky:
mov ax, yTsize
    cmp ax, 2
    jne @ypow4
        mov yShift, 1
        jmp @yloop
@ypow4:
    cmp ax, 4
    jne @ypow8
        mov yShift, 2
        jmp @yloop
@ypow8:
    cmp ax, 8
    jne @ypow16
        mov yShift, 3
        jmp @yloop
@ypow16:
    cmp ax, 16
    jne @ypow32
        mov yShift, 4
        jmp @yloop
@ypow32:
    cmp ax, 32
    jne @ypow64
        mov yShift, 5
        jmp @yloop
@ypow64:
    cmp ax, 64
    jne @ypow128
        mov yShift, 6
        jmp @yloop
@ypow128:
    cmp ax, 128
    jne @ypow256
        mov yShift, 7
        jmp @yloop
@ypow256:
    cmp ax, 256
    jne @exit
    mov yShift, 8

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
        mov bx, wid
        mov xa, bx
@xloop:

        mov cl, xshift              ;fast shifts
        mov ch, yshift
        
        mov eax, sx
        sar eax, 16
        mov edx, eax                ;save it
        and ax, xTsizeM1
                                        

        mov ebx,sy
        sar ebx,16
        and bx, yTsizeM1

                                     ;y*xTsize
        sal bx, cl                   ;XXXXXXXX

        mov si, bx
        add si, ax                  ;toff=toff+x
        add si, TextOff


        ;tx% = (ABS(xx% \ xtsize)) AND Mapx-1            'Tilex tilesize/ymax=64
        ;ty% = (ABS(yy% \ ytsize)) AND Mapy-1

        mov ax, dx                 ;sx
                                   ;sx\xTsize
        sar ax, cl                 ;XXXXXXXX
        and ax, xMapSizeM1

        mov bx,ax                  ;bx=tx

        ;Tnum% = Map%(tx%, ty%)
        ;xx% = xx% AND 63
        ;yy% = yy% AND 63

        mov eax, sy
        sar eax, 16
                                    ;sy\yTsize
        xchg ch, cl                 ;yshift= cl, xshift= ch.
        sar ax, cl                  ;YYYYYYYYY
        and ax, yMapSizeM1
        mov cl, mShift
        sal ax, cl                  ;ty*xmax


        add bx,ax                   ;ty*xmax+tx
        shl bx, 1                   ;map offset=offset*2  Integer maps ;*)
        mov ax, Fs:[bx]             ;ax = Tilenum
        dec ax

        ;Toff& = ((Tnum% - 1) * (TSIZESQUARED)) + 4
        ;Scanline%(xa%) = PEEK((yy% * 64) + xx% + Toff&)

        mov bx,TileSize
        imul bx, ax
        add si,4
        mov al, ds:[si+bx]          ;texel
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
xor ax,ax
mov al, mshift
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





