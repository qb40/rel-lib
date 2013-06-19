
;;;Pixel to triangle collision detection
;;;Call with:
;;;Declare sub RelInsideTri(Byval x%, Byval y%,Byval x1%, Byval y1%, Byval x2%, Byval y2%, Byval x3%, Byval y3%)

.Model Medium, BASIC
.386
.Code

align 2

;;*****************Near procedure for which side**********************************************************
Whichside      Proc  Near
				Local x:		word
				Local y:		word
				Local x1: 		word
				Local y1: 		word
				Local x2: 		word
				Local y2: 		word
				Local Wside: 	byte

		;expects
		;ax = y2
		;bx = x2
		;cx = x1
		;dx = y1
		;fs = x
		;gs = y
		mov y2, ax
		mov x2, bx
		mov x1, cx
		mov y1, dx

		mov ax, fs
		mov dx, gs
		mov x, ax
		mov y, dx


		mov wside, 0
        mov bx, x2							;bx% = x2%
        mov cx, x1
        sub bx, cx							;bx% = bx% - x1%
        									;IF bx% <> 0 THEN

        jnz @dxNot0

            mov dx, x						;dx% = x%
            cmp bx, dx						;IF bx% > dx% THEN
            Jle @noside1
                mov wside, -1

                jmp @Texit

@noside1:
                mov wside, 0

                jmp @Texit

@dxNot0:
        mov ax, y2							;ax% = y2%
        mov dx, y1
        sub ax, dx							;ax% = ax% - y1%
        									;IF ax% <> 0 THEN
        jnz @dyNot0

            mov cx, y						;cx% = y%
            cmp ax, cx						;IF ax% > cx% THEN
            Jle @Noside2
                mov wside, -1

                jmp @Texit

@Noside2:
                mov wside, 0

                jmp @Texit


@dyNot0:
    ;ax = ady
    ;bx = adx
    ;cx = y
    ;dx = x
                ;dx% = (x2% - x1%)
                ;dy& = (y2% - y1%) * 256&

                shl eax, 16					;xeax& = ax% * 256&       'dy*256
                cdq							;edxeax& = eax&          'cdq
                movsx ecx, bx				;ebx& = bx%              'movsx ebx, bx
                idiv ecx					;eax& = edxeax& \ ebx&   'idiv ebx          'vg&=eax

                							;Vg& = dy& \ dx%
                							;ddx% = (x% - x1%)
                mov cx, x					;cx% = x%
                sub cx, x1					;cx% = cx% - x1%
                movsx ebx, cx
                imul eax, ebx				;eax& = eax& * cx%       'imul eax, cx
                mov dx, y1					;dx% = y1%

                shl edx, 16					;edx& = dx% * 256&
                							;cy& = Vg& * ddx% + (y1% * 256&)
                add eax, edx				;eax& = eax& + edx&
                							;whichside = (y% * 256&) < cy&
                mov bx, y					;bx% = y%

                shl ebx, 16					;ebx& = bx% * 256&
                cmp eax, ebx				;IF eax& > ebx& THEN
                jle @noside3
                    mov wside, 0
                    jmp @Texit

@noside3:
                    mov wside, -1


@Texit:
mov al, wside

Ret


EndP


;;*****************Procedure for InsideTri*****************************************************************

Public  RelInsideT
RelInsideT proc \
            x:word, y:word, x1:word, y1:word, x2:word, y2:word,x3:word, y3:word

            Local sideA1:   Byte
            Local sideA2:   Byte
            Local SideA3:   Byte
            Local sideB1:   Byte
            Local sideB2:   Byte
            Local SideB3:   Byte
            Local cenx:		word
            Local ceny:		word


         	;clip
            mov ax, x1
            cmp ax, x2
            jle @noswapx1
				mov ax, x2
@noswapx1:
			cmp ax, x3
			jle @noswapx2
				mov ax, x3
@noswapx2:
            mov bx, x1
            cmp bx, x2
            jge @noswapx3
				mov bx, x2
@noswapx3:
			cmp bx, x3
			jge @noswapx4
				mov bx, x3
@noswapx4:

			;ax = x1
			;bx = x2

         	;clip
            mov cx, y1
            cmp cx, y2
            jle @noswapy1
				mov cx, y2
@noswapy1:
			cmp cx, y3
			jle @noswapy2
				mov cx, y3
@noswapy2:
            mov dx, y1
            cmp dx, y2
            jge @noswapy3
				mov dx, y2
@noswapy3:
			cmp dx, y3
			jge @noswapy4
				mov dx, y3
@noswapy4:
			;cx = y1
			;dx = y2

			;test coord

			cmp x, ax
			jl @NoInside
			cmp x, bx
			jg @NoInside
			cmp y, cx
			jl @NoInside
			cmp y, dx
			jg @NoInside


			;Start insideT
            ;cx% = (x1% + x2% + x3%) \ 3
            mov ax, x1
            add ax, x2
            add ax, x3
            mov bx,3
            cwd
            idiv bx
            ;cbw
            mov cenx, ax

 			;cy% = (y1% + y2% + y3%) \ 3
 			mov ax, y1
            add ax, y2
            add ax, y3
            mov bx, 3
            cwd
            idiv bx
            ;cbw
            mov ceny, ax

 			;Whichside expects
			;ax = y2
			;bx = x2
			;cx = x1
			;dx = y1
			;fs = x
			;gs = y


 			;sideA1 = whichside(cx%, cy%, x1%, y1%, x2%, y2%)
 			mov dx, cenx
 			mov cx, ceny
 			mov fs, dx
 			mov gs, cx

 			mov ax, y2
 			mov bx, x2
 			mov cx, x1
 			mov dx, y1
 			call whichside
 				mov sideA1, al

 			;sideA2 = whichside(cx%, cy%, x1%, y1%, x3%, y3%)
 			mov dx, cenx
 			mov cx, ceny
 			mov fs, dx
 			mov gs, cx

 			mov ax, y3
 			mov bx, x3
 			mov cx, x1
 			mov dx, y1
 			call whichside
 				mov sideA2, al
 			;sideA3 = whichside(cx%, cy%, x2%, y2%, x3%, y3%)
 			mov dx, cenx
 			mov cx, ceny
 			mov fs, dx
 			mov gs, cx

 			mov ax, y3
 			mov bx, x3
 			mov cx, x2
 			mov dx, y2
 			call whichside
 				mov sideA3, al
 			;sideB1 = whichside(x%, y%, x1%, y1%, x2%, y2%)
 			mov dx, x
 			mov cx, y
 			mov fs, dx
 			mov gs, cx

 			mov ax, y2
 			mov bx, x2
 			mov cx, x1
 			mov dx, y1
 			call whichside
 				mov sideB1, al
 			;sideB2 = whichside(x%, y%, x1%, y1%, x3%, y3%)
 			mov dx, x
 			mov cx, y
 			mov fs, dx
 			mov gs, cx

 			mov ax, y3
 			mov bx, x3
 			mov cx, x1
 			mov dx, y1
 			call whichside
 				mov sideB2, al
 			;sideB3 = whichside(x%, y%, x2%, y2%, x3%, y3%)
 			mov dx, x
 			mov cx, y
 			mov fs, dx
 			mov gs, cx

 			mov ax, y3
 			mov bx, x3
 			mov cx, x2
 			mov dx, y2
 			call whichside
 				mov sideB3, al

 			;insidetri% = (sideA1 = sideB1) AND (sideA2 = sideB2) AND (sideA3 = sideB3)
 			mov al, sideA1
 			mov bl, sideB1
 			cmp al, bl
 			jne @NoInside

 				mov cl, sideA2
 				mov dl, sideB2
 				cmp cl, dl
 				jne @NoInside

        			mov al, sideA3
 					mov bl, sideB3
 					cmp al, bl
 					jne @NoInside
 						mov ax, -1


@exit:

Ret

@NoInside:
	xor ax, ax
ret

EndP

End

