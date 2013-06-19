;/==========================RelLib Image module============================
.Model Medium, BASIC
.386

PcxHeaderType struc     
  ValidID     db  ?                 ;id
  Ver         db  ?                 ;should be 5(ver 3)
  Encoding    db  ?                 ;normal Rle
  BPP         db  ?                 ;8 for 13h
  XMin        dw  ?                 ;Window
  YMin        dw  ?
  PcxXSize    dw  ?                 ;Absolute maxwin
  PcxYSize    dw  ?
  Xdpi        dw  ?                 ;Not needed
  Ydpi        dw  ?
  Pal4Bit     db  48 dup(?)         ;not needed actually
  Reserved2   db  64 dup(?)
PcxHeaderType ends

.Data

Align 2

PcxHeader           PcxHeaderType <>
Bytes               db  ?


Public xRelLoadPCX

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



xRelLoadPCX Proc  uses es ds si di,\
            Layer:Word, X:Word, Y:Word,FileSeg:Word,FileOff:Word,\
            PalSeg:Word, PalOff:Word, SwitchPal:Word

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
    mov ax, seg PcxHeader
    mov ds, ax
    mov dx, offset PcxHeader    ;Offset
    mov cx, Size PcxHeader      ;ByteLength
    mov ah,3fh
    xor al,al
    Int 21h
    jc @CheckError              ;carry flag set so error error in AX!!!

    ;;Okay... This only loads version 3(5 in the header)

    cmp PcxHeader.Ver,5             ;if version 3
    jne @PcxNotSupported
    cmp PcxHeader.Encoding,1
    jne @PcxNotSupported
    cmp PCXHeader.BPP, 8            ;Only screen 13
    jne @PcxNotSupported
    mov ax, PcxHeader.Xmin          
    dec ax
    sub PcxHeader.PcxXSize, ax      ;get actual width relative to zero
    mov ax, PcxHeader.Ymin
    dec ax
    sub PcxHeader.PcxYSize, ax        ;get actual height relative to zero
    xor dx, dx
    xor ax, ax
    mov si, PcxHeader.PcxYSize
    Test PcxHeader.PcxXSize, 1        ;odd bytes???
    jz  @PCXLoadLoop                  ;not
    inc PcxHeader.PcxXSize            ;odd so make it even

    ;;;;
    ;;;;
@PcxLoadLoop:
    ReadByte Bytes
    jc  @CheckError
    mov al, Bytes
    mov ah, al                    ;save color            
    and al, 192                   ;movement
    cmp al, 192                   ;if >192 then RLE Line else Pixel
    jz  @DecodePcxRle
    ;;
    ;;Pixel
    mov al, ah                    ;restore
    mov es:[di], al               ;pixel(color <> adjacent)
    inc di                        
    inc dx
    cmp dx, PcxHeader.PcxXSize
    jl  @PcxNextData
    add di, 320
    sub di, dx
    xor dx, dx
    dec si
    jmp @PcxNextData
@DecodePcxRle:
    ;;
    ;;RLE decode
    mov al, ah                    ;restore color
    and al, 63                    ;Rle counter
    mov cl, al
    ReadByte Bytes
    jc @CheckError
    mov al, Bytes                 ;color of Hline
@DecodePcxRleLoop:
    mov es:[di], al               ;put color
    inc di                          
    inc dx                        ;Xcounter
    cmp dx,PcxHeader.PcxXSize
    jl @DecodePcx                 ;Not end of line then Jump to next color
    add di, 320                   ;Next line
    sub di, dx                    ;320-RLE Hline
    xor dx, dx                    ;refresh X counter
    dec si                        ;decrease Y counter
@DecodePcx:
    dec cl                        ;if RLE counter >0 then go back
    jnz @DecodePcxRleLoop
@PcxNextData:                     ;else next color
    or  si, si                    ;Y counter =0???
    jnz @PcxLoadLoop              ;Read a byte
    ReadByte Bytes
    jc  @CheckError               ;How many times have we repeated this???
    ;;;
    ;;;
    ;;;Read palette
    mov es, PalSeg
    mov di, PalOff
    mov cx, 768                   ;768 bytes in PCX pal
@LoadPcxPal:
    ReadByte Bytes                ;read 1
    jc  @CheckError               ;Again? LOL
    mov al, Bytes                 
    shr al, 2                     ;same as in BMP \4
    stosb                         ;store it to string
    dec cx
    jnz @LoadPcxPal               ;next val
    ;;;
    ;;;If Switch Pal
    mov ax, SwitchPal
    or ax,ax                      ;Switch Pal
    jnz @SwitchPal
@PostSwitchPal:
    mov ah, 3eh                   ;Close file
    int 21h
    xor ax, ax                    ;No error
    jmp @exitLoadPcx
@PcxNotSupported:
    mov ah, 3eh
    int 21h
    mov ax, 1                     ;Wrong PCX
@ExitLoadPcx:
    ret

;/=======Subs======
@SwitchPal:
    ;;;
    ;;;Es:di PalSeg:PalOff
    ;;;Out =Dx:Port Addy, al color
    ;;; 3c8h=port WriteMode
    ;;; 3c9h=Dac
    mov fs, PalSeg
    mov si, PalOff
    xor cx,cx               ;start from zero
@ColorLoop:
    mov dx, 3c8h
    mov ax, cx
    xor ah, ah
    out dx, al              ;color index

    ;;;;
    ;;;;RED
    mov dx, 3c9h
    mov al, fs:[si]
    out dx, al
    ;;;;
    ;;;;GREEN
    mov dx, 3c9h
    mov al, fs:[si+1]
    out dx, al
    ;;;;
    ;;;;BLUE
    mov dx, 3c9h
    mov al, fs:[si+2]
    out dx, al

    add si,3                ;next 3 colors
    inc cx
    cmp cx,256
    jne @ColorLoop
Jmp @PostSwitchPal

@CheckError:
    mov ah, 3eh         ;Close File
    int 21h
    or ax,ax
    jnz @ExitLoadPcx
    Mov ax,255          ;unknown error
Jmp @ExitLoadPcx

Endp

END
