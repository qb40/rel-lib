.Model Medium, BASIC
.386
.Code

Public  xRelPsetWu
xRelPsetWu  Proc  Uses es di,\
            Layer:word, x:Dword, y:Dword, clr:word

            Local x1:     word
            Local y1:     word
            Local x2:     word
            Local y2:     word
            Local Temp:   Dword
            Local Col:    Dword


mov es, Layer

xor edx, edx
mov dx, clr
mov col, edx

mov eax, x
mov ecx,eax                ;save
sar eax, 8
mov x1, ax

mov ebx, y
mov edx,ebx                ;save
sar ebx, 8
mov y1, bx

inc ax
inc bx
mov x2, ax
mov y2, bx

dec ax
dec bx

;; calc offset

xchg bh, bl
;shl bx, 8
mov di, bx
shr di, 2
add di, bx
add di, ax           ;di=320*y1

and ecx, 255
and edx, 255

mov eax, 256
sub eax, ecx           ;eax=xm2

mov ebx, 256
sub ebx, edx           ;ebx = ym2

                        ;eax=xm2
                        ;ebx=ym2
                        ;ecx=xm
                        ;edx=ym

imul ecx, col
imul eax, col


mov temp, eax          ;save xm2Tcol
imul eax, ebx
sar eax, 16
    cmp x1, 0
    jl @c2
    cmp x1, 319
    jg @c2
    cmp y1, 0
    jl @c2
    cmp y1, 199
    jg @c2
    mov es:[di], al

@c2:
mov eax, ecx           ;xmTcol
imul eax, ebx
sar eax, 16
    cmp x2, 0
    jl @c3
    cmp x2, 319
    jg @c3
    cmp y1, 0
    jl @c3
    cmp y1, 199
    jg @c3
    mov es:[di+1], al


@c3:
mov eax, Temp          ;restore
imul eax, edx
sar eax, 16
    cmp x1, 0
    jl @c4
    cmp x1, 319
    jg @c4
    ;cmp y2, 0
    ;jl @c4
    ;cmp y2, 199
    ;jg @c4
    cmp y1, 0
    jl @c4
    cmp y1, 198
    jg @c4
    mov es:[di+320], al

@c4:
mov eax, ecx
imul eax, edx
sar eax, 16
    cmp x2, 0
    jl @exit
    cmp x2, 319
    jg @exit
    ;cmp y2, 0
    ;jl @exit
    ;cmp y2, 199
    ;jg @exit
    cmp y1, 0
    jl @exit
    cmp y1, 198
    jg @exit
    mov es:[di+321], al

@exit:
ret

endp

END





