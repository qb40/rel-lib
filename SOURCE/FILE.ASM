.Model Medium, BASIC
.386

    ;;;
    ;;; Disk Transfer Address 43 byte buffer. 
DTAstruct struc
    Reserved        db  21 dup(?)   ;20h reserved for subsequent search
    Attrib          db  ?           ;File Attribute
    FileTime        dw  ?           ;Yeah
    FileDate        dw  ?           ;Right...
    FileSize        dd  ?           ;guess...
    FileName        db  13 dup(?)   ;8char+.+type. followed by Hex0(20h)
DTAstruct Ends


.Data
    Align 2
    DTA     DTAstruct<>             ;huh?    


.Code

Public  xRelFindFile
XRelFindFile    Proc  Uses Ds si es di,\
                MaskSeg:Word, MaskOff:Word, FileSeg:Word, FileOff:Word, Attribute: Word


    mov ds, MaskSeg
    mov si, MaskOff
    mov dl, ds:[si]
    or dl, dl
    jz  @NextFile
                                ;;
                                ;;Int 21h Dta
                                ;;ah=1ah
                                ;;DS:DX= pointer to DTA in memory 
    mov ax, @data               ;DTA seg
    mov ds, ax
    mov dx, offset DTA
    mov ah, 1ah                 ;Set disk transfer addy
    xor al,al
    Int 21h                     ;do it

                                ;;;ah= 4eh
                                ;;;cx= attrib
                                ;;;ds:dx =addy of the fiename
                                ;;;Carry Flag=return value
    mov ds, MaskSeg
    mov dx, MaskOff
    mov cx, Attribute
    mov ax, 4e00h               ;load subfunction and clear al
    Int 21h                     ;Fill DTA
    jc @Error
    jmp @WritetoString
@NextFile:
                                ;;;Find Next matching file
                                ;;;ah=4fh
                                ;;;don't touch dta
                                ;;;for subsequent search ie. reserved
    mov ax, 4f00h               ;load subfunction and clear al
    Int 21h                     ;Fill DTA
    jc @Error

@WritetoString:

    mov ax, @data
    mov ds, ax
    mov si, offset DTA
    add si, 30              ;offset at filename in DTA type
    mov es, FileSeg
    mov di, FileOff
    mov cx,13
@NextByte:
    mov al, ds:[si]
    or al,al
    jz @EndWrite
    mov es:[di],al
    inc si
    inc di
    dec cx
    jnz @nextByte

@EndWrite:

                            ;Fill DTA.Filename with 20h for subsequent search
    mov ax, @data
    mov es, ax
    mov di, offset DTA
    mov al, 20h
    add di, 30
    mov cx, 13
    rep stosb
Ret

@Error:
    mov es, FileSeg
    mov di, FileOff
    sub al,al
    Stosb
Ret    

endp

END





