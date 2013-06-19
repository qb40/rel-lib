.Model Medium, BASIC
.386
.Code

;Lens Effect
;Es:di=Layer
;Ds:si=Texture
;Fs:bx=Sqr Data

Public  xRelLensTrans
xRelLensTrans   Proc  Uses es di ds si,\
                Dest:word, Src:word, x:word, y:word,\
                Radius:word, Sheight:word,\
                SqrSeg:word, SqrOff:word

            Local t20Mw:            Word
            Local RadiusSquared:    Word
            Local RadiusSquaredMC:  Word
            Local xsize:            Word
            Local ySize:            Word
            Local minx:             Word
            Local miny:             Word
            Local xt:               Word
            Local yt:               Word
            Local x1:               Word
            Local y1:               Word
            Local sx:               Word
            Local sy:               Word


mov ax, sheight
shl ax, 3               ;cleaner=ax
mov bx, radius
Imul bx, bx
mov RadiusSquared, bx
sub bx, ax
mov RadiusSquaredMC, bx


mov ax, radius
shl ax, 1
mov xSize, ax

mov ySize, ax

mov minx, 0
mov miny, 0


mov dx, ysize
mov bx, xsize

        Mov ax,x
        Cmp ax,319              
        Jg @exit
        Cmp ax,0                
        Jl @ClipLeft
@PostClipLeft:
        Mov cx,y
        Cmp cx,199
        Jg @exit
        Cmp cx,0                
        Jl @ClipTop
@PostClipTop:
        Add bx,ax               ;Add X to WID and see if its over *BX is destroyed
        Cmp bx,319              ;If X+Width > 319,  crop it
        Jg  @ClipRight
        Sub bx,ax               ;Restore bx
@PostClipRight:

        Add dx,cx   
        Cmp dx,199  
        Jg  @ClipDown 
        Sub dx,cx               ;Restore dx
@PostClipDown:

                                ;ax=X, cx=Y, bx=NewWidth, dx=NewHeight


        mov x, ax
        mov y, cx
        Mov xsize,bx              ;Save wid
        Mov ysize,dx              ;Save height
        
        ;;;;;calc offset.....
        
        Xchg ch,cl
        Mov bx,320
        
        Mov di,cx      
        Sub bx,xsize              ;get 320-Width
        
        Shr di,2   
        Add di,cx               ;Y*64+Y*256=Y*320  :)
        Mov T20Mw,bx
        
        Add di,ax               ;Offset done!!!=Y*320+X

            ;;
            ;;
            mov ds, Src
            mov fs, SqrSeg
            mov es, Dest

    mov yt, 0
@yloop:
    mov xt, 0
@xloop:
        mov ax, xt
        mov bx, yt
        sub ax, radius
        sub bx, radius
        add ax, minx
        add bx, miny 
      mov x1, ax
      mov y1, bx
      Imul ax, ax
      Imul bx, bx
      add ax, bx            ;pythag
      cmp ax, RadiusSquaredMC
      jge @noPlot
            mov bx, RadiusSquared
            sub bx, ax
            ;shl bx, 1
            xor cx, cx
            mov cl, Fs:[bx]
            mov ax, sheight
            sub ax, cx
            mov sx, ax
            mov sy, ax

            mov ax, x1
            mov bx, y1
       ;sx
            xor dx, dx
            sal ax, 7
            cwd
            idiv cx
            imul ax, sx
            sar ax, 7
            mov sx, ax
       ;sy
            xor dx, dx
            mov ax, bx
            sal ax, 7
            cwd
            idiv cx
            imul ax, sy
            sar ax, 7
            ;mov sy, ax
       ;py
            add ax, y
            add ax, yt
            ;and ax, yTextSizeM1
            cmp ax, 0
            jl @NoPlot
            cmp ax, 199
            jg @NoPlot
            xchg al, ah
            mov si, ax
            shr si, 2
            add si, ax
       ;px
            mov bx, sx
            add bx, x
            add bx, xt
            cmp bx, 0
            jl @NoPlot
            cmp bx, 319
            jg @NoPlot
            ;and bx, xTextSizeM1
            add si, bx
            mov al, ds:[si]
            or al, al
            jz @NoPlot
                mov bl,al
                and bl,15           ;and it by 15
                mov bh,bl
                sub bh,al           ;bh=base color
                neg bh
                mov al,bl
                mov ah,es:[di]
                and ah,15
                add ah,al
                shr ah,1
                add ah,bh
                mov es:[di],ah
@NoPlot:                           
        inc di
        mov ax, xsize
        inc xt
        cmp xt, ax
        jl @xloop
            add di, T20Mw
            mov bx, ysize
            inc yt
            cmp yt, bx
            jl @yloop

@exit:
ret

;;;;;;Subs
;;;;;;

@ClipLeft:
        Neg ax          ;-ax=+ax
        Sub bx,ax       ;sub clipped width to real width
        Jle @Exit       ;Negative result = outa here
        mov minx, ax
        Xor ax,ax       ;zero out coord
        Jmp @PostClipLeft


@ClipTop:
        Neg cx          
        Sub dx,cx
        Jle @exit
        mov miny, cx
        xor cx, cx
     Jmp @PostClipTop

@ClipRight:
       Mov bx,320       ;Correct bx to clipX2+1
       Sub bx,ax        ;Subract ax to bx to correct width(0 TO 319)
       Jmp @PostClipRight

@ClipDown:
       Add cx,dx        ;add height to Y
       Sub cx,200       ;Correct it
       Sub dx,cx        ;Crop out height
       Mov cx,y         ;Restore Y
       Jmp @PostClipDown

endp

END



