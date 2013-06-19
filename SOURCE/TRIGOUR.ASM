
;;;Fix point Gouraud triangle routine. :*)
;;;Call with:
;;;Declare sub (Byval Layer%, Byval x1%, Byval y1%,Byval c1%, Byval x2%, Byval y2%,Byval c2%, Byval x3%, Byval y3%,Byval c3%)

.Model Medium, BASIC
.386
.Code

align 2

;;*****************Near procedure for preclipped Gouraud Hline*****************************************
HGline      Proc  Near
		Local cdelta:   dword
		Local x1:	word
		Local x2:	word
		Local Col: 	dword

    ;ax = x1
    ;bx = x2
    ;ecx = col1
    ;edx = col2
    ;gs = y

    ;mov x1, ax						;save x1
    ;mov ax, gs
    ;cmp ax, 0
    ;jl @NolineH
    ;cmp ax, 199
    ;jg @NolineH
    ;mov ax, x1						;restore x1
;;;
    cmp ax,bx
    jle short @Postswapx
    	xchg ax, bx
    	xchg ecx, edx

@PostSwapX:
    mov x1, ax
    mov x2, bx



    mov col, ecx
    								;Gdx% = (Gx2% - Gx1%) + 1
    								;Cdx& = Clr2& - Clr1&
    								;deltac& = Cdx& \ Gdx%
    								;col& = Clr1&
    sub edx, ecx

    sub bx, ax
    jz  @NolineH
    mov ax, bx
    cwde					;eax = gdx
    mov ecx, edx			;ecx = cdx
    xchg eax, ecx			;eax = cdx  : ecx = gdx
    cdq						;eax:edx = cdx
    mov cdelta,0			;temp
    idiv ecx				                ;eax = edxedx\ecx
    mov cdelta, eax




    mov ax, x1
    mov bx, x2


;;;;;;;;;;
    cmp ax,319
    jg @NolineH
    cmp ax,0
    jl @clipLeft
@PostclipLeft:
    cmp bx,0
    jl @NolineH
    cmp bx,319
    jg @clipRight
@PostclipRight:



    mov dx, bx							;dx = (bx - ax)+1
    inc dx
    sub dx, ax
    jz  @NolineH
    mov cx, gs				;put in y value
    xchg ch, cl				;y = y *256 ;di& = cx * 320& + ax
    mov di, cx				;di = 256
    shr di, 2				;di = 64
    add di, cx				;di = 256+64 = 320
    add di, ax				;di = y*320+x

    ;ax = x1
    ;bx = x2
    ;gs = color
    ;cx = free
    ;dx = width

    									;FOR l% = Gx1% TO Gx2%                   'Rasterizer loop
    									;    PSET (l%, yy%), col& \ FIXPOINT     'Use poke for speed
    									;    col& = col& + deltac&               'DDA
    									;NEXT l%

mov ebx, col
mov cx, dx
cmp cx, 4
jbe @Less4Loop
mov dx, cx
shr cx, 2
and dx, 3
@xloop1:
	;1.
    mov eax, ebx
    sar eax, 16
    mov es:[di], al
    add ebx, cdelta
    ;2.
    mov eax, ebx
    sar eax, 16
    mov es:[di+1], al
    add ebx, cdelta
    ;3.
    mov eax, ebx
    sar eax, 16
    mov es:[di+2], al
    add ebx, cdelta
    ;4.
    mov eax, ebx
    sar eax, 16
    mov es:[di+3], al
    add ebx, cdelta
    add di, 4
    dec cx
    jnz short @xloop1

test dx, dx
jz @NolineH
@Xloop2:
	mov eax, ebx
    sar eax, 16
    mov es:[di], al
    add ebx, cdelta
    inc di
    dec dx
    jnz short @Xloop2

@NolineH:

Ret

@clipLeft:
	mov cx, ax							;save in cx
	neg cx								;cx = clipped width
    mov dx,bx
    sub dx,ax
    add ax,dx
    cmp ax,0
    jl @NolineH
    	xor eax, eax
    	mov ax, cx
    	imul eax, cdelta				;eax=wid*cdelta
    	add col, eax					;add to col to clip
        xor eax,eax
    Jmp @PostclipLeft

@clipRight:
    mov bx,319
    Jmp @PostclipRight


@Less4Loop:
	mov eax, ebx
    sar eax, 16
    mov es:[di], al
    add ebx, cdelta
    inc di
    dec cx
    jnz short @Less4Loop
Ret
EndP


;;*****************Procedure for Gouraud Triangle Filler**************************************************

Public  RelTriG
RelTriG     Proc  Uses es di,\
            Layer:word, x1:word, y1:word, c1:word, x2:word, y2:word, c2:word ,x3:word, y3:word, c3:word

            Local delta1:   dword
            Local delta2:   dword
            Local delta3:   dword
            Local Lx:       dword
            Local Rx:       dword
            Local cdelta1:  dword  ;
            Local cdelta2:  dword  ;  color grads
            Local cdelta3:  dword  ;
            Local Lc:       dword  ;
            Local Rc:       dword  ;
            Local ycounter: word

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
	mov cx, c1
	mov dx, c2
	xchg cx, dx
	mov c1, cx
	mov c2, dx
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
	mov cx, c3
	mov dx, c1
	xchg cx, dx
	mov c3, cx
	mov c1, dx
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
	mov cx, c3
	mov dx, c2
	xchg cx, dx
	mov c3, cx
	mov c2, dx
@noswapy3:

mov delta1, 0
mov cdelta1, 0

mov bx, y2			;bx = y2
sub bx, y1			;bx = bx - y1

jz  short @delta1_is_zero		;IF bx <> 0 THEN
    mov ax, x2			;ax = x2
    sub ax, x1			;ax = ax - x1
    ;cwde				;eax& = ax
    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&

    movsx ecx, bx		;ecx& = bx                   'movsx ecx, bx
    idiv ecx 			;delta1& = edxeax& \ ecx&        'idiv ecx
    mov delta1, eax

    					;CDelta1& = dc1 * FIXPOINT \ dy1
    mov ax, c2			;ax = c2
    sub ax, c1			;ax = ax - c1
    ;cwde				;eax& = ax
    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov cdelta1, eax

@delta1_is_zero:



mov delta2, 0
mov cdelta2, 0

mov bx, y3			;bx = y3
sub bx, y2			;bx = bx - y2

jz  short @delta2_is_zero		;IF bx <> 0 THEN
    mov ax, x3			;ax = x3
    sub ax, x2			;ax = ax - x2
    ;cwde				;eax& = ax
    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&

    movsx ecx, bx		;ecx& = bx
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov delta2, eax

        				;CDelta1& = dc2 * FIXPOINT \ dy2
    mov ax, c3			;ax = c3
    sub ax, c2			;ax = ax - c3
    ;cwde				;eax& = ax
    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov cdelta2, eax

@delta2_is_zero:


mov delta3, 0
mov cdelta3, 0

mov bx, y1				;bx = y1
sub bx, y3				;bx = bx - y3

jz  short @delta3_is_zero		;IF bx <> 0 THEN
    mov ax, x1			;ax = x1
    sub ax, x3			;ax = ax - x3
    ;cwde				;eax& = ax
    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&

    movsx ecx, bx		;ecx& = bx
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov delta3, eax

        				;CDelta1& = dc3 * FIXPOINT \ dy3
    mov ax, c1			;ax = c1
    sub ax, c3			;ax = ax - c3
    ;cwde				;eax& = ax
    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov cdelta3, eax

@delta3_is_zero:


Mov es, Layer
;Flat bottom
;Top part of triangle

mov ax, x1				;ax = x1
;cwde					;eax& = ax
shl eax, 16				;eax& = eax& * FIXPOINT
mov ebx, eax			;ebx& = eax&
mov lx, eax
mov rx, ebx

mov ax, c1				;ax = c1
;cwde					;eax& = ax
shl eax, 16				;eax& = eax& * FIXPOINT
mov ebx, eax			;ebx& = eax&
mov lc, eax
mov rc, ebx


mov cx, y1				;cx = y1
mov ycounter, cx
@Loop1:
	cmp ycounter, 0
    jl short @Noline1
    cmp ycounter, 199
    jg short @Noline1
    mov eax, lx
    mov ebx, rx
    mov ecx, lc				;col1
    mov edx, rc             ;col2
    sar	eax, 16				;ax = eax& \ FIXPOINT
    sar ebx, 16				;bx = ebx& \ FIXPOINT
    mov gs, ycounter

    call HGline

@Noline1:
    mov eax, delta1
    mov ebx, delta3
    mov ecx, cdelta1
    mov edx, cdelta3

    add lx, eax 			;eax& = eax& + delta1&
    add rx, ebx 			;ebx& = ebx& + delta3&
    add lc, ecx 			;eax& = eax& + cdelta1&
    add rc, edx 			;ebx& = ebx& + cdelta3&

    inc ycounter
    mov cx, ycounter
    cmp cx, y2
    jle short @Loop1

    mov ebx, delta3
    sub rx, ebx  			;subtexel accuracy
    mov edx, cdelta3
    sub rc, edx

;Flat top
;Lower part of triangle

mov ax, x2				;ax = x2
;cwde					;eax& = ax
shl eax, 16				;eax& = eax& * FIXPOINT
mov lx, eax

mov ax, c2				;ax = c2
;cwde					;eax& = ax
shl eax, 16				;eax& = eax& * FIXPOINT
mov lc, eax

mov cx, y2				;cx = y2
mov ycounter, cx
@Loop2:
	cmp ycounter, 0
    jl short @Noline2
    cmp ycounter, 199
    jg short @Noline2
    mov eax, lx
    mov ebx, rx
    mov ecx, lc				;col1
    mov edx, rc             ;col2
    sar	eax, 16				;ax = eax& \ FIXPOINT
    sar ebx, 16				;bx = ebx& \ FIXPOINT
    mov gs, ycounter

    call HGline

@Noline2:
    mov eax, delta2
    mov ebx, delta3
    mov ecx, cdelta2
    mov edx, cdelta3

    add lx, eax 			;eax& = eax& + delta2&
    add rx, ebx 			;ebx& = ebx& + delta3&
    add lc, ecx 			;eax& = eax& + cdelta2&
    add rc, edx 			;ebx& = ebx& + cdelta3&

    inc ycounter
    mov cx, ycounter
    cmp cx, y3
    jl short @Loop2

@exit:
Ret

EndP

End

