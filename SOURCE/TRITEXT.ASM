
;;;Fix point Textured triangle routine. :*)
;;;Call with:
;;;Declare sub (Byval Layer%, Byval x1%, Byval y1%,Byval u1%,Byval v1%, Byval x2%,_
;;; 	Byval y2%,Byval u2%,Byval v2%, Byval x3%, Byval y3%,Byval u3%,Byval v3%, Byval TSEG%, Byval TOFF%)

.Model Medium, BASIC
.386
.Code

align 2

;;*****************Near procedure for preclipped Textured Hline*****************************************
HTline     Proc  near\
            x1:word, x2:word, y:word, lu:dword, ru:dword, lv:dword, rv:dword, Tsize:word

			Local udelta:   dword
			Local vdelta:   dword
			Local u: 		dword
			Local v: 		dword
			Local dy:		word
			Local TsizeM1:	word
			Local Toff:		word
			Local wid:		word

			;GS = Xshift


    mov ax, x1
    mov bx, x2
    cmp ax,bx
    jle Short @Postswapx
    	xchg ax, bx
    	mov ecx, lu
    	mov edx, ru
    	xchg ecx, edx
    	mov x1, ax
    	mov x2, bx
    	mov eax, lv
    	mov ebx, rv
    	xchg eax, ebx
    	mov lu, ecx
    	mov ru, edx
    	mov lv, eax
    	mov rv, ebx
@PostSwapX:



	mov ecx, lu
	mov edx, lv
	mov u, ecx
	mov v, edx
	;U
    mov ax, x1
    mov bx, x2
    mov edx, ru
    mov ecx, lu
    								;Gdx% = (Gx2% - Gx1%) + 1       'Get Xdelta(+1) for the Div by 0 error
    								;Cdx& = Clr2& - Clr1&           'Color delta    								;deltac& = Cdx& \ Gdx%          'Interpolate
    								;col& = Clr1&                   'save orig color to be safe
    sub edx, ecx

    sub bx, ax
    jz  @NolineH
    mov dy, bx				;save ydelta
    mov ax, bx
    cwde					;eax = gdx
    mov ecx, edx			;ecx = cdx
    xchg eax, ecx			;eax = cdx  : ecx = gdx
    cdq						;eax:edx = cdx

    idiv ecx				                ;eax = edxedx\ecx
    mov udelta, eax


	;V
	mov edx, rv
    mov ecx, lv
    								;Gdx% = (Gx2% - Gx1%) + 1       'Get Xdelta(+1) for the Div by 0 error
    								;Cdx& = Clr2& - Clr1&           'Color delta    								;deltac& = Cdx& \ Gdx%          'Interpolate
    								;col& = Clr1&                   'save orig color to be safe
    sub edx, ecx
    mov ax, dy
    cwde					;eax = gdx
    mov ecx, edx			;ecx = cdx
    xchg eax, ecx			;eax = cdx  : ecx = gdx
    cdq						;eax:edx = cdx

    idiv ecx				                ;eax = edxedx\ecx
    mov vdelta, eax



    mov ax, x1
    mov bx, x2


;;;;;;;;;;
    cmp ax,319
    jg @NolineH
    cmp ax,0
    jl  @clipLeft
@PostclipLeft:
    cmp bx,0
    jl  @NolineH
    cmp bx,319
    jg  @clipRight
@PostclipRight:



	mov cx, Tsize
    mov dx, bx							;dx = (bx - ax)+1
    inc dx
    dec cx
    mov TsizeM1, cx
    sub dx, ax
    jz   @NolineH
    mov cx, y				;put in y value
    xchg ch, cl				;y = y *256 ;di& = cx * 320& + ax
    mov di, cx				;di = 256
    shr di, 2				;di = 64
    add di, cx				;di = 256+64 = 320
    add di, ax				;di = y*320+x


    									;FOR l% = Gx1% TO Gx2%                   'Rasterizer loop
    									;    PSET (l%, yy%), col& \ FIXPOINT     'Use poke for speed
    									;    col& = col& + deltac&               'DDA
    									;NEXT l%


;;xloop okay
Mov Toff, fs
mov bx, dx				;do divide
cmp bx, 4
jle @Less4
and bl, 3
shr dx, 2
mov ch, bl				;odd pixels I used dy to conserve mem. :*)
mov wid, dx
mov ax, gs				;shift counter
mov cl, al				;use cl
mov ebx, u				;save u and v
mov edx, v

@xloop:
	;1.
	;;v
    mov eax, edx
    shr eax, 16
    and ax, TsizeM1
    shl ax, cl
    mov si, ax
    add si, Toff
    ;;u
    mov eax, ebx
    shr eax, 16
    and ax, TsizeM1
    add si, ax
    mov al,[si+4]
    mov es:[di], al
    add ebx, udelta
    add edx, vdelta
    ;2.
	;;v
    mov eax, edx
    shr eax, 16
    and ax, TsizeM1
    shl ax, cl
    mov si, ax
    add si, Toff
    ;;u
    mov eax, ebx
    shr eax, 16
    and ax, TsizeM1
    add si, ax
    mov al,[si+4]
    mov es:[di+1], al
    add ebx, udelta
    add edx, vdelta
    ;3.
	;;v
    mov eax, edx
    shr eax, 16
    and ax, TsizeM1
    shl ax, cl
    mov si, ax
    add si, Toff
    ;;u
    mov eax, ebx
    shr eax, 16
    and ax, TsizeM1
    add si, ax
    mov al,[si+4]
    mov es:[di+2], al
    add ebx, udelta
    add edx, vdelta
    ;4.
	;;v
    mov eax, edx
    shr eax, 16
    and ax, TsizeM1
    shl ax, cl
    mov si, ax
    add si, Toff
    ;;u
    mov eax, ebx
    shr eax, 16
    and ax, TsizeM1
    add si, ax
    mov al,[si+4]
    mov es:[di+3], al
    add ebx, udelta
    add edx, vdelta
    add di, 4
    dec wid
    jnz @xloop

test ch,ch
jz short @NolineH
@xloop2:
	;1.
	;;v
    mov eax, edx
    shr eax, 16
    and ax, TsizeM1
    shl ax, cl
    mov si, ax
    add si, Toff
    ;;u
    mov eax, ebx
    shr eax, 16
    and ax, TsizeM1
    add si, ax
    mov al,[si+4]
    mov es:[di], al
    add ebx, udelta
    add edx, vdelta
    inc di
    dec ch
    jnz @xloop2

@NolineH:

Ret

@clipLeft:
	mov cx, ax							;save in cx
	neg cx								;cx = clipped width
    mov dx,bx
    sub dx,ax
    add ax,dx
    cmp ax,0
    jl short @NolineH
    	xor eax, eax
    	mov ax, cx
    	imul eax, udelta				;eax=wid*udelta
    	add u, eax	    				;add to u to clip
        xor eax,eax
        mov ax, cx
        imul eax, vdelta				;eax=wid*vdelta
    	add v, eax						;add to v to clip
    	xor eax,eax
    Jmp  @PostclipLeft

@clipRight:
    mov bx,319
    Jmp  @PostclipRight


;Less then 4
@Less4:
mov wid, dx
mov ax, gs				;shift counter
mov cl, al				;use cl
mov ebx, u				;save u and v
mov edx, v

@xloopLess4:
	;;v
    mov eax, edx
    shr eax, 16
    and ax, TsizeM1
    shl ax, cl
    mov si, ax
    add si, Toff
    ;;u
    mov eax, ebx
    shr eax, 16
    and ax, TsizeM1
    add si, ax
    mov al,[si+4]
    mov es:[di], al
    add ebx, udelta
    add edx, vdelta
    inc di
    dec wid
    jnz short @xloopLess4
Ret

EndP


;;*****************Procedure for Textured Triangle Filler**************************************************

Public  RelTriT
RelTriT     Proc  Uses es di ds si,\
            Layer:word, x1:word, y1:word, u1:word, v1:word, x2:word, y2:word, u2:word, v2:word,\
            x3:word, y3:word, u3:word, v3:word, Tseg: word, Toff: word

            Local delta1:   dword
            Local delta2:   dword
            Local delta3:   dword
            Local Lx:       dword
            Local Rx:       dword
            Local udelta1:  dword
            Local udelta2:  dword
            Local udelta3:  dword
            Local Lu:       dword
            Local Ru:       dword
            Local vdelta1:  dword
            Local vdelta2:  dword
            Local vdelta3:  dword
            Local Lv:       dword
            Local Rv:       dword
            Local ycounter: word
            Local Tsize:	word
            Local xshift:	word

mov ax, y1
mov bx, y2
cmp bx, ax			;cmp y2, y1
jge short @noswapy1
	xchg ax, bx		;xchg y1, y2
	mov cx, x1
	mov dx, x2
	xchg cx, dx		;xchg x1, x2
	mov y1, ax
	mov y2, bx
	mov x1, cx
	mov x2, dx
	mov cx, u1
	mov dx, u2
	xchg cx, dx
	mov u1, cx
	mov u2, dx
	mov cx, v1
	mov dx, v2
	xchg cx, dx
	mov v1, cx
	mov v2, dx
@noswapy1:


mov ax, y3
mov bx, y1
cmp ax, bx			;cmp y3, y1
jge short @noswapy2
	xchg ax, bx		;xchg y3, y1
	mov cx, x3
	mov dx, x1
	xchg cx, dx		;xchg x3, x1
	mov y3, ax
	mov y1, bx
	mov x3, cx
	mov x1, dx
	mov cx, u3
	mov dx, u1
	xchg cx, dx
	mov u3, cx
	mov u1, dx
	mov cx, v3
	mov dx, v1
	xchg cx, dx
	mov v3, cx
	mov v1, dx
@noswapy2:


mov ax, y3
mov bx, y2
cmp ax, bx			;cmp y3, y2
jge short @noswapy3
	xchg ax, bx		;xchg y3, y2
	mov cx, x3
	mov dx, x2
	xchg cx, dx		;xchg x3, x2
	mov y3, ax
	mov y2, bx
	mov x3, cx
	mov x2, dx
	mov cx, u3
	mov dx, u2
	xchg cx, dx
	mov u3, cx
	mov u2, dx
	mov cx, v3
	mov dx, v2
	xchg cx, dx
	mov v3, cx
	mov v2, dx
@noswapy3:

mov delta1, 0
mov udelta1, 0
mov vdelta1, 0

mov bx, y2				;bx = y2
sub bx, y1				;bx = bx - y1

jz short @delta1_is_zero		;IF bx <> 0 THEN
    mov ax, x2			;ax = x2
    sub ax, x1			;ax = ax - x1

    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&

    movsx ecx, bx		;ecx& = bx
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov delta1, eax

    					;uDelta1& = du1 * FIXPOINT \ dy1
    mov ax, u2			;ax = u2
    sub ax, u1			;ax = ax - u1

    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov udelta1, eax

    					;vDelta1& = dv1 * FIXPOINT \ dy1
    mov ax, v2			;ax = u2
    sub ax, v1			;ax = ax - u1

    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov vdelta1, eax

@delta1_is_zero:



mov delta2, 0
mov udelta2, 0
mov vdelta2, 0

mov bx, y3				;bx = y3
sub bx, y2				;bx = bx - y2

jz short @delta2_is_zero		;IF bx <> 0 THEN
    mov ax, x3			;ax = x3
    sub ax, x2			;ax = ax - x2

    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&

    movsx ecx, bx		;ecx& = bx
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov delta2, eax

        				;uDelta1& = du2 * FIXPOINT \ dy2
    mov ax, u3			;ax = u3
    sub ax, u2			;ax = ax - u3

    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov udelta2, eax

           				;vDelta1& = dv2 * FIXPOINT \ dy2
    mov ax, v3			;ax = v3
    sub ax, v2			;ax = ax - v3

    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov vdelta2, eax


@delta2_is_zero:


mov delta3, 0
mov udelta3, 0
mov vdelta3, 0

mov bx, y1				;bx = y1
sub bx, y3				;bx = bx - y3

jz short @delta3_is_zero		;IF bx <> 0 THEN
    mov ax, x1			;ax = x1
    sub ax, x3			;ax = ax - x3

    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&

    movsx ecx, bx		;ecx& = bx
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov delta3, eax

        				;uDelta1& = du3 * FIXPOINT \ dy3
    mov ax, u1			;ax = u1
    sub ax, u3			;ax = ax - u3

    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov udelta3, eax

        				;vDelta1& = dv3 * FIXPOINT \ dy3
    mov ax, v1			;ax = v1
    sub ax, v3			;ax = ax - v3

    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov vdelta3, eax

@delta3_is_zero:


Mov es, Layer
Mov ds, TSEG
mov ax, TOFF
mov fs, ax
mov si, ax
mov bx, [si]
shr bx,3 				;width
mov Tsize, bx


;calculate shifts

mov ax, bx
    cmp ax, 2
    jne short @xpow4
        mov bx, 1
        jmp short @SizeOK
@xpow4:
    cmp ax, 4
    jne short @xpow8
        mov bx, 2
        jmp short @SizeOK
@xpow8:
    cmp ax, 8
    jne short @xpow16
        mov bx, 3
        jmp short @SizeOK
@xpow16:
    cmp ax, 16
    jne short @xpow32
        mov bx, 4
        jmp short @SizeOK
@xpow32:
    cmp ax, 32
    jne short @xpow64
        mov bx, 5
        jmp short @SizeOK
@xpow64:
    cmp ax, 64
    jne short @xpow128
        mov bx, 6
        jmp short @SizeOK
@xpow128:
    cmp ax, 128
    jne short @xpow256
        mov bx, 7
        jmp short @SizeOK
@xpow256:
    cmp ax, 256
    jne @exit
    mov bx, 8


@SizeOK:
;Flat bottom
;Top part of triangle

mov gs, bx				;save xshift

mov ax, x1				;ax = x1
cwde					;eax& = ax
sal eax, 16				;eax& = eax& * FIXPOINT
mov ebx, eax			;ebx& = eax&
mov lx, eax
mov rx, ebx

mov ax, u1				;ax = u1
cwde					;eax& = ax
sal eax, 16				;eax& = eax& * FIXPOINT
mov ebx, eax			;ebx& = eax&
mov lu, eax
mov ru, ebx

mov ax, v1				;ax = v1
cwde					;eax& = ax
sal eax, 16				;eax& = eax& * FIXPOINT
mov ebx, eax			;ebx& = eax&
mov lv, eax
mov rv, ebx



mov cx, y1					;cx = y1
mov ycounter, cx
@Loop1:
	cmp ycounter, 0
    jl short @Noline1
    cmp ycounter, 199
    jg short @Noline1
    mov eax, lx
    mov ebx, rx
    sar	eax, 16				;ax = eax& \ FIXPOINT
    sar ebx, 16				;bx = ebx& \ FIXPOINT
    Push ax 				;x1
    push bx	    			;x2
    mov ecx, lu				;u1
    mov edx, ru             ;u2
    mov ax, ycounter
    push ax
    Push ecx				;Lu
    push edx				;Ru
    mov eax, lv
    mov ebx, rv
    Push eax				;Lv
    push ebx				;Rv
    mov cx, Tsize
    push cx


    call HTline

@Noline1:
    mov eax, delta1
    mov ebx, delta3
    mov ecx, udelta1
    mov edx, udelta3

    add lx, eax 			;eax& = eax& + delta1&
    add rx, ebx 			;ebx& = ebx& + delta3&
    add lu, ecx 			;eax& = eax& + udelta1&
    add ru, edx 			;ebx& = ebx& + udelta3&

    mov eax, vdelta1
    mov ebx, vdelta3
    add lv, eax 			;eax& = eax& + vdelta1&
    add rv, ebx 			;ebx& = ebx& + vdelta3&


    inc ycounter
    mov cx, ycounter
    cmp cx, y2
    jle short @Loop1

    mov ebx, delta3
    sub rx, ebx  			;subtexel accuracy
    mov edx, udelta3
    sub ru, edx
    mov eax, vdelta3
    sub rv, eax


;Flat top
;Lower part of triangle

mov ax, x2				;ax = x2
cwde					;eax& = ax
sal eax, 16				;eax& = eax& * FIXPOINT
mov lx, eax

mov ax, u2				;ax = u2
cwde					;eax& = ax
sal eax, 16				;eax& = eax& * FIXPOINT
mov lu, eax

mov ax, v2				;ax = v2
cwde					;eax& = ax
sal eax, 16				;eax& = eax& * FIXPOINT
mov lv, eax


mov cx, y2				;cx = y2
mov ycounter, cx
@Loop2:
	cmp ycounter, 0
    jl short @Noline2
    cmp ycounter, 199
    jg short @Noline2
    mov eax, lx
    mov ebx, rx
    sar	eax, 16				;ax = eax& \ FIXPOINT
    sar ebx, 16				;bx = ebx& \ FIXPOINT
    Push ax	    			;x1
    push bx 				;x2
    mov ecx, lu				;u1
    mov edx, ru             ;u2
    mov ax, ycounter
    push ax
    Push ecx				;Lu
    push edx				;Ru
    mov eax, lv
    mov ebx, rv
    Push eax				;Lv
    push ebx				;Rv

    mov cx, Tsize
    push cx


    call HTline

@Noline2:
    mov eax, delta2
    mov ebx, delta3
    mov ecx, udelta2
    mov edx, udelta3

    add lx, eax 			;eax& = eax& + delta2&
    add rx, ebx 			;ebx& = ebx& + delta3&
    add lu, ecx 			;eax& = eax& + udelta2&
    add ru, edx 			;ebx& = ebx& + udelta3&

    mov eax, vdelta2
    mov ebx, vdelta3
    add lv, eax 			;eax& = eax& + vdelta2&
    add rv, ebx 			;ebx& = ebx& + vdelta3&


    inc ycounter
    mov cx, ycounter
    cmp cx, y3
    jl short @Loop2

@exit:
Ret

EndP

End

