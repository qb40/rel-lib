
;;;Fix point flat triangle routine. :*)
;;;Call with:
;;;Declare sub (Byval Layer%, Byval x1%, Byval y1%, Byval x2%, Byval y2%, Byval x3%, Byval y3%,Byval c%)

.Model Medium, BASIC
.386
.Code

align 2

;;*****************Near procedure for preclipped Hline**************************************************
Hline       Proc  Near
		Local clr:  word
    ;ax = x1
    ;bx = x2
    ;cx = y
    ;dx = free
    mov clr, dx

;;;
    cmp ax,bx
    jle short @Postswapx
    	xchg ax, bx
@PostSwapX:
    cmp ax,319
    jg short @NolineH
    cmp ax,0
    jl short @clipLeft
@PostclipLeft:
    cmp bx,0
    jl short @NolineH
    cmp bx,319
    jg short @clipRight
@PostclipRight:

    mov dx, bx				;dx = (bx - ax)+1
    inc dx
    sub dx, ax
    jz  short @NolineH
    xchg ch, cl				;y = y *256 ;di& = cx * 320& + ax
    mov di, cx				;di = 256
    shr di, 2				;di = 64
    add di, cx				;di = 256+64 = 320
    add di, ax				;di = y*320+x
    mov ax, clr
    mov ah, al
    mov cx, dx				;save width of line
    mov dx, ax
    shl eax, 16				;eax = color  for repstosd
    mov ax, dx				;extend color to low word
    mov bx, cx				;bx and cx = width
    shr cx, 2				;div cx by 4
    and bx, 3				;odd pixels for bx

	rep Stosd
	mov cx, bx
	rep stosb


@NolineH:

Ret

@clipLeft:
    mov dx,bx
    sub dx,ax
    add ax,dx
    cmp ax,0
    jl short @NolineH
        xor ax,ax
    Jmp @PostclipLeft

@clipRight:
    mov bx,319
    Jmp @PostclipRight


EndP


;;*****************Procedure for FlatTriangle Filler**************************************************

Public  RelTriF
RelTriF     Proc  Uses es di,\
            Layer:word, x1:word, y1:word, x2:word, y2:word,x3:word, y3:word, clr:word

            Local delta1:   dword
            Local delta2:   dword
            Local delta3:   dword


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
@noswapy3:

mov delta1, 0

mov bx, y2			;bx = y2
sub bx, y1			;bx = bx - y1

jz  short @delta1_is_zero		;IF bx <> 0 THEN
    mov ax , x2			;ax = x2
    sub ax, x1			;ax = ax - x1
    ;cwde				;eax& = ax
    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq					;edx& = eax&
    					;edxeax& = edx&

    movsx ecx, bx		;ecx& = bx
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov delta1, eax
@delta1_is_zero:



mov delta2, 0
mov bx, y3			;bx = y3
sub bx, y2			;bx = bx - y2

jz  short @delta2_is_zero		;IF bx <> 0 THEN
    mov ax, x3			;ax = x3
    sub ax, x2			;ax = ax - x2
    ;cwde				;eax& = ax
    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq				;edx& = eax&
    				;edxeax& = edx&

    movsx ecx, bx		;ecx& = bx
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov delta2, eax
@delta2_is_zero:


mov delta3, 0
mov bx, y1			;bx = y1
sub bx, y3			;bx = bx - y3
;;cmp bx, 0
jz  short @delta3_is_zero		;IF bx <> 0 THEN
    mov ax, x1			;ax = x1
    sub ax, x3			;ax = ax - x3
    ;cwde				;eax& = ax
    shl eax, 16			;eax& = eax& * FIXPOINT
    cdq				;edx& = eax&
    				;edxeax& = edx&

    movsx ecx, bx		;ecx& = bx
    idiv ecx 			;delta1& = edxeax& \ ecx&
    mov delta3, eax
@delta3_is_zero:


Mov es, Layer
;Flat bottom
;Top part of triangle

mov ax, x1				;ax = x1
;cwde					;eax& = ax
shl eax, 16				;eax& = eax& * FIXPOINT
mov ebx, eax			;ebx& = eax&

mov cx, y1				;cx = y1
@Loop1:
	cmp cx, 0
    jl short @Noline1
    cmp cx, 199
    jg short @Noline1
    push eax
    push ebx
    push cx
    sar	eax, 16				;ax = eax& \ FIXPOINT
    sar ebx, 16				;bx = ebx& \ FIXPOINT
    mov dx, clr
    call Hline
    pop cx
    pop ebx
    pop eax
@Noline1:
    add eax, delta1			;eax& = eax& + delta1&
    add ebx, delta3			;ebx& = ebx& + delta3&
    inc cx
    cmp cx, y2
    jle short @Loop1

    sub ebx, delta3			;subtexel accuracy

;Flat top
;Lower part of triangle

mov ax, x2				;ax = x2
;cwde					;eax& = ax               'cwde           'Lx
shl eax, 16				;eax& = eax& * FIXPOINT  'sal eax, 16

mov cx, y2				;cx = y2
@Loop2:
	cmp cx, 0
    jl short @Noline2
    cmp cx, 199
    jg short @Noline2
    push eax
    push ebx
    push cx
    sar eax, 16				;ax = eax& \ FIXPOINT
    sar ebx, 16				;bx = ebx& \ FIXPOINT
    mov dx, clr
    call Hline
    pop cx
    pop ebx
    pop eax
@Noline2:
    add eax, delta2			;eax& = eax& + delta2&
    add ebx, delta3			;ebx& = ebx& + delta3&
    inc cx
    cmp cx, y3
    jl short @Loop2

@exit:
Ret

EndP

End

