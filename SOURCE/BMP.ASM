;/==========================RelLib Bmp module============================
.Model Medium, BASIC
.386


BMPHeaderType struc
      ID              dw  ?                     ;BM
      FileSize        dd  ?                     ;Wid*Hei+Header
      Reserved1       dw  ?
      Reserved2       dw  ?
      OffBits         dd  ?                     ;1078
      HSize           dd  ?
      Wid             dd  ?
      Hei             dd  ?
      Planes          dw  ?                     ;1
      Bpp             dw  ?                     ;8
      Compression     dd  ?                     ;0
      SizeImage       dd  ?                     ;W*H
      Xres            dd  ?                     ;3790
      Yres            dd  ?                     ;ditto
      ClrUsed         dd  ?
      ClrImportant    dd  ?
BMPHeaderType ends
                            ;Pal'Order=Blue*4, Green*4, Red*4, 0 * 4


.Data

Align 2

BmpHeader           BmpHeaderType <>
Bytes               db  ?


Public xRelLoadBmp

.Code

ReadByte MACRO ByteToRead
    push ax
    push cx
    push dx

    mov dx, Offset ByteToRead
    mov ax, @data
    mov ds, ax
    mov cx,1
    mov ah, 3fh
    int 21h

    pop dx
    pop cx
    pop ax

EndM ReadByte



xRelLoadBmp Proc  uses es ds si di,\
            Layer:Word, X:Word, Y:Word,FileSeg:Word,FileOff:Word,\
            PalSeg:Word, PalOff:Word, SwitchPal:Word

            Local Hite:     Word
            Local DSSave:   Word


    Mov es, Layer
    Mov ax, Y               ;calc offset
    xchg al,ah              ;*256
    mov di,ax               ;save
    shr di,2                ;256/4=64
    add di,ax               ;64+256=320
    add di,x                ;offset=Y*320+X

    ;;
    ;; Int 21h
    ;; ah = 3dh
    ;; al = 0 for read only
    ;; DS:DX=Filename

    mov ds,FileSeg
    mov dx,FileOff
    mov ah,3dh
    xor al,al
    int 21h
    jc @CheckError              ;carry flag set so error error in AX!!!
    ;;
    ;; Return: AX=FileHandle(should be moved to BX)

    ;;3fh=Read bytes
    ;;Bx=Handle
    ;;cx=Bytes to read
    ;;dx=Offset where to put 'em. Variable or Array

    mov bx,ax                   ;Int 21h needs BX instead of AX
    mov ax, seg BmpHeader
    mov ds, ax
    mov dx, offset BmpHeader    ;Offset
    mov cx, Size BmpHeader      ;ByteLength
    mov ah,3fh
    xor al,al
    Int 21h
    jc @CheckError                  ;carry flag set so error error in AX!!!
                                    ;offset now in Pal
    ;;;
    ;;;Check for validity of file
    cmp BmpHeader.Id, 19778         ;"BM"
    jne @BmpNotSupported
    cmp BmpHeader.Planes,1
    jne @BmpNotSupported
    cmp BmpHeader.Bpp, 8            ;Only screen 13
    jne @BmpNotSupported
    cmp BmpHeader.Compression,0     ;should be 0
    jne @BmpNotSupported
    ;;;;
    ;;;;Load Pal
    mov cx,256                      ;256 colors 8Bpp
    mov Fs,PalSeg
    mov si,PalOff
@BmpLoadPal:
    ReadByte Bytes
    jc  @CheckError

    ;;;;BLUE
    mov al, Bytes
    shr al,2                        ;div by 4
    mov Fs:[si+2],al

    ;;;;GREEN
    ReadByte Bytes
    jc  @CheckError
    mov al, Bytes
    shr al,2                        ;div by 4
    mov Fs:[si+1],al

    ;;;;RED
    ReadByte Bytes
    jc  @CheckError
    mov al, Bytes
    shr al,2                        ;div by 4
    mov Fs:[si],al

    ReadByte Bytes                  ;Padding
    jc  @CheckError
    add si,3
    dec cx
    jnz @BmpLoadPal

    ;;;Switch Pal
    Cmp SwitchPal,0
    jne @BMPSwitchPal
@PostBMPSwitchPal:

    ;;
    Mov ecx,BmpHeader.Wid
    mov eax,ecx
    and eax,3
    jz @MulOfFour
    sub ecx,eax                     ;make it a multiple of four
    add ecx,4                       ;make up for lost pixels

@MulOfFour:

    mov BmpHeader.Wid,ecx
    ;;
    ;;;
    ;; calc start offset
    ;; BMP's are stored backwards (nasty developers)
    mov eax,BmpHeader.Hei
    dec ax
    xchg ah,al                      ;H*256
    mov cx,ax                       ;save
    shr cx,2                        ;256/4=64
    add cx,ax                       ;64+256=320
    add di,cx                       ;Ylayer offset+ BmpHeight

    mov ecx,BmpHeader.Hei           ;loop counter
    Mov Hite,cx

@BmpYloop:
    Mov DSSave, Ds
    ;;
    ;; Ds:si=Layer for direct from file write
    ;; ECX=Wid of one scanline
    Mov ecx, BmpHeader.Wid
    Mov ax,es                       ;layer
    mov ds,ax                       ;fileseg
    mov dx,di                       ;layer offset
    mov ah, 3fh                     ;read
    int 21h
    jc @CheckError
    mov ds,DsSave
    sub di,320                      ;next scanline
    dec Hite
    Jnz @BmpYLoop
    mov ah, 3eh                   ;Close file
    int 21h
    xor ax, ax                    ;No error
    jmp @exitLoadBmp
@BmpNotSupported:
    mov ah, 3eh
    int 21h
    mov ax, 1                     ;Unknown ver
@ExitLoadBmp:
    ret

;/=======Subs======
@BMPSwitchPal:
    ;;;
    ;;;Fs:si PalSeg:PalOff
    ;;;Out =Dx:Port Addy, al color
    ;;; 3c8h=port WriteMode
    ;;; 3c9h=Dac
    mov Fs,PalSeg
    mov si,PalOff
    xor cx,cx               ;start from zero
@BmpColorLoop:
    mov dx, 3c8h
    mov ax, cx
    xor ah, ah
    out dx, al              ;color index

    ;;;;
    ;;;;RED
    mov dx, 3c9h
    mov al, Fs:[si]
    out dx, al
    ;;;;
    ;;;;GREEN
    mov dx, 3c9h
    mov al, Fs:[si+1]
    out dx, al
    ;;;;
    ;;;;BLUE
    mov dx, 3c9h
    mov al, Fs:[si+2]
    out dx, al

    add si,3                ;next 3 colors
    inc cx
    cmp cx,256
    jne @BmpColorLoop
Jmp @PostBmpSwitchPal

@CheckError:
    mov ah, 3eh         ;Close File
    int 21h
    or ax,ax
    jnz @ExitLoadBmp
    Mov ax,255          ;unknown error
Jmp @ExitLoadBmp


Endp

END
