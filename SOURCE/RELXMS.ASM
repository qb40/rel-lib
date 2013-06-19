.MODEL MEDIUM, BASIC
.386
.STACK 200H
        XMSBLOCKSTRUCT  STRUC
                BYTES           DD ?            ;IN BYTES
                SHANDLE         DW ?            ;SOURCE HANDLE
                SOFFSET         DD ?            ;SOURCE OFFSET
                DHANDLE         DW ?            ;DEST   HANDLE
                DOFFSET         DD ?            ;DEST   OFFSET
        XMSBLOCKSTRUCT  ENDS
        EXTRN   RELSPRITEFLIP:FAR
        EXTRN   RELSPRITEFLIPT:FAR
        EXTRN   RELSPRITEFLIPG:FAR
        EXTRN   RELSPRITEFLIPC:FAR
        EXTRN   RELSPRITESOLID:FAR

.DATA
        ALIGN 2
        XMSDUDE         DD ?               ;XMS CONTROL DRIVER ADDRESS
        XMSBLOCK        XMSBLOCKSTRUCT <>  ;XMS MEMMOVE STRUCT
.CODE
PUBLIC RELXMSINIT
PUBLIC RELXMSGETFREE
PUBLIC RELXMSGETTOTAL
PUBLIC RELXMSALLOCATE
PUBLIC RELXMSDEALLOCATE
PUBLIC RELXMSFROMBASE
PUBLIC RELXMSTOBASE
PUBLIC RELXMSPUT
PUBLIC RELXMSPUTT
PUBLIC RELXMSPUTG
PUBLIC RELXMSPUTC
PUBLIC RELXMSPUTS

;============================================================================
;RELXMSINIT
;DECLARE FUNCTION RELXMSINIT%()
;DES: CHECKS IF AN XMS DRIVER IS INSTALLED AND INITIALIZES IT IF FOUND :*)
;RETURNS:
;-1 IF AN XMS DRIVER IS INSTALLED 0 IF OTHERWISE
;============================================================================
RELXMSINIT PROC
        MOV AX,4300H                    ;LIM SPECS :*)
        INT 2FH                         ;STANDARD INT
        CMP AL,80H                      ;WILL BE 80H IF THERE IS AN XMS DRIVER
        JNE LBL_NOXMSDRIVER             ;NO DRIVER PRESENT
        MOV AX,4310H                    ;GET ADDRESS OF XMSDUDE
        INT 2FH                         ;ES:BX(ADDRESS RETURNED
        MOV WORD PTR [XMSDUDE],BX       ;BLAST THE DAMN VALUES
        MOV WORD PTR [XMSDUDE+2],ES     ;INTEL'S BACKWARD DWORD NOTATION
        MOV AL,-1
        SUB AH,AH
        RET
LBL_NOXMSDRIVER:
SUB AX,AX
RET
RELXMSINIT ENDP

;============================================================================
;RELXMSGETFREE
;DECLARE FUNCTION RELXMSGETFREE&()
;DES: QUERIES FREE EXTENDED MEMORY
;RETURNS:
;A LONG INTEGER OF LARGEST FREE XMS MEM IN KB
;============================================================================

RELXMSGETFREE PROC
        MOV AX,0800H            ;AH=08H
        CALL [XMSDUDE]
        XOR DX,DX               ;CLEAR TOTAL
        RET
RELXMSGETFREE ENDP

;============================================================================
;RELXMSGETTOTAL
;DECLARE FUNCTION RELXMSGETTOTAL&()
;DES: QUERIES FREE EXTENDED MEMORY
;RETURNS:
;A LONG INTEGER OF TOTAL FREE XMS MEM IN KB
;============================================================================

RELXMSGETTOTAL PROC
        MOV AX,0800H            ;AH=08H
        CALL [XMSDUDE]
        MOV AX,DX               ;MOV THE DX TO AX SINCE QB EXPECTS IT
        XOR DX,DX
        RET
RELXMSGETTOTAL ENDP

;============================================================================
;RELXMSALLOCATE
;DECLARE FUNCTION RELXMSALLOCATE%(KB&)
;PARAMS:AMOUNT IN KB TO ALLOCATE(LONG INT)
;DES: ALLOCATES AN XMS MEMORY FOR USE
;RETURNS:
;THE XMS HANDLE OF THE XMSBLOCK(SHORT INT)
;STACK
;KB&            =4
;CS             =2
;IP             =0
;============================================================================

RELXMSALLOCATE PROC
        MOV CX,BP               ;USE CX SINCE ITS THE ONLY REG FREE AFTER
                                ;CALL TO XMS DUDE
        MOV BP,SP
        MOV DX,[BP+4]           ;AMOUNT IN KB
        MOV AX,0900H            ;FUNCTION NUMBER
                                ;ON RETURN:
                                ;DX=XMS HANDLE(16 BIT)
                                ;AX=ERRORFLAG
        CALL [XMSDUDE]
        OR AX,AX                ;CHECK IF UNSUCCESSFUL
        JZ LBL_XMS_ALLOC_FAIL   ;0=FAIL
        MOV AX,DX               ;PUT HANDLE TO AX
        MOV BP,CX
        RET 4
LBL_XMS_ALLOC_FAIL:
MOV BP,CX
RET 4
RELXMSALLOCATE ENDP

;============================================================================
;RELXMSDEALLOCATE
;DECLARE SUB RELXMSDEALLOCATE()
;PARAMS:XMSHANDLE(SHORT INT)
;DES: ALLOCATES AN XMS MEMORY FOR USE
;RETURNS:NONE
;STACK
;HANDLE         =4
;CS             =2
;IP             =0
;============================================================================

RELXMSDEALLOCATE PROC
        MOV CX,BP               ;USE CX SINCE ITS THE ONLY REG FREE AFTER
                                ;CALL TO XMS DUDE
        MOV BP,SP
        MOV DX,[BP+4]           ;HANDLE
        MOV AX,0A00H            ;FUNCTION NUMBER
                                ;ON RETURN:
                                ;DX=XMS HANDLE(16 BIT)
                                ;AX=ERRORFLAG
        CALL [XMSDUDE]
        MOV BP,CX
        RET 2
RELXMSDEALLOCATE ENDP


;============================================================================
;RELXMSFROMBASE
;DECLARE SUB RELXMSFROMBASE (BYVAL BaseSEG%, BYVAL BaseOFF&, BYVAL XmsHandle%,
; _BYVAL XMSOffset&, BYVAL Length&)
;PARAMS:
        ;BaseSEG=BaseLayer SEGment(Varseg) Short Int
        ;BaseOFF=Baselayer OFFset(Varptr) Long Int as QB wraps things
        ;XmsHandle=Handle returned by RelXMSAllocate (Short Int)
        ;XmsOffSet=32 bit Offset in XMS data (Long Int)
        ;Length=32 bit Length(IN BYTES) of data to copy(Long Int)
;DES: COPIES A BLOCK OF DATA FROM BASE/CONVENTIONAL MEMORY TO XMS
;RETURNS:NONE
;STACK
;BaseSEG        =18     >20
;BaseOFF        =14     >18
;XmsHandle      =12     >14
;XmsOff         =8      >12
;Length         =4      >8
;CS             =2
;IP             =0
;============================================================================

RELXMSFROMBASE PROC
  MOV CX,BP                     ;SAVE BP
  MOV DX,DS                     ;SAVE DS
  MOV BP,SP
  XOR AX,AX                     ;MUST BE 0
  MOV XMSBLOCK.SHandle, AX      ;TO TREAT IT AS SEG:OFF PAIR
  MOV EAX, [bp+16]              ;BASE SEGMENTOFFSET(32 BIT)
  MOV XMSBLOCK.SOffset, EAX     ;REDUNDANT BUT FASTER
  MOV AX, [bp+12]               ;XMS HANDLE(16 BIT)
  MOV XMSBLOCK.DHandle, AX
  MOV EAX, [BP+8]               ;32 BIT XMS OFFSET
  MOV XMSBLOCK.DOffset, EAX
  MOV EBX, [BP+4]
  MOV XMSBLOCK.BYTES, EBX
  MOV AX, SEG XMSBLOCK
  MOV DS, AX
  MOV SI, OFFSET XMSBLOCK
  MOV AX, 0B00H
  CALL [XMSDUDE]
  MOV DS,DX
  MOV BP,CX
  RET 16

RELXMSFROMBASE ENDP

;============================================================================
;RELXMSTOBASE
;DECLARE SUB RELXMSTOBASE (BYVAL BaseSEG%, BYVAL BaseOFF&, BYVAL XmsHandle%,
; _BYVAL XMSOffset&, BYVAL Length&)
;PARAMS:
        ;BaseSEG=BaseLayer SEGment(Varseg) Short Int
        ;BaseOFF=Baselayer OFFset(Varptr) Long Int as QB wraps things
        ;XmsHandle=Handle returned by RelXMSAllocate (Short Int)
        ;XmsOffSet=32 bit Offset in XMS data (Long Int)
        ;Length=32 bit Length(IN BYTES) of data to copy(Long Int)
;DES: COPIES A BLOCK OF DATA FROM BASE/CONVENTIONAL MEMORY TO XMS
;RETURNS:NONE
;STACK
;BaseSEG        =18     >20
;BaseOFF        =14     >18
;XmsHandle      =12     >14
;XmsOff         =8      >12
;Length         =4      >8
;CS             =2
;IP             =0
;============================================================================

RELXMSTOBASE PROC
  MOV CX,BP                     ;SAVE BP
  MOV DX,DS                     ;SAVE DS
  MOV BP,SP
  XOR AX,AX                     ;MUST BE 0
  MOV XMSBLOCK.DHandle, AX      ;TO TREAT IT AS SEG:OFF PAIR
  MOV EAX, [BP+16]              ;BASE SEGMENT:OFFSET(32 BIT)
  MOV XMSBLOCK.DOffset, EAX     ;REDUNDANT BUT FASTER
  MOV AX, [BP+12]               ;XMS HANDLE(16 BIT)
  MOV XMSBLOCK.SHandle, AX
  MOV EAX, [BP+8]               ;32 BIT XMS OFFSET
  MOV XMSBLOCK.SOffset, EAX
  MOV EBX, [BP+4]
  MOV XMSBLOCK.BYTES, EBX
  MOV AX, SEG XMSBLOCK
  MOV DS, AX
  MOV SI, OFFSET XMSBLOCK
  MOV AX, 0B00H
  CALL [XMSDUDE]
  MOV DS,DX
  MOV BP,CX
  RET 16

RELXMSTOBASE ENDP



;Type SprXmsIndex
;   bytes   as Long
;   offset  as long
;Endtype
;****************************************************************************************
;Normal call with flip
;****************************************************************************************

RelXmsPut PROC Uses Ds Si Es di,\
          Layer:Word, X:Word, Y:Word, SprIndexSeg:Word, SprIndexOff:Word,\
          FlipMode:word, DummySeg:Word, XmsHandle:Word


		  mov es, sprindexseg
		  mov di, sprindexoff

		  XOR AX,AX                     ;MUST BE 0
		  MOV XMSBLOCK.DHandle, AX      ;TO TREAT IT AS SEG:OFF PAIR
		  MOV AX, DummySeg              ;BASE SEGMENT:OFFSET(32 BIT)
		  shl eax,16					;this is the problem!!!!!
		  xor ax, ax
		  MOV XMSBLOCK.DOffset, EAX     ;REDUNDANT BUT FASTER
		  MOV AX, xmshandle             ;XMS HANDLE(16 BIT)
		  MOV XMSBLOCK.SHandle, AX
		  MOV EAX, es:[di+4]            ;32 BIT XMS OFFSET		'Offset
		  MOV XMSBLOCK.SOffset, EAX
		  MOV EBX, es:[di]				;size in bytes
		  MOV XMSBLOCK.BYTES, EBX
		  MOV AX, SEG XMSBLOCK
		  MOV DS, AX
		  MOV SI, OFFSET XMSBLOCK
		  MOV AX, 0B00h
		  CALL [XMSDUDE]


          ;;; Do a RelSprite Call
          xor dx, dx
          mov si, dx                    ;dummy offset
          mov ax,Layer                  ;LAYER SEG
          mov bx,X                      ;X
          mov cx,Y                      ;Y
          mov dx, DummySeg              ;DUMMY SEG
          push ax			    	    ;layer
          push bx                       ;x
          push cx                       ;y
          push dx                       ;seg
          xor ax, ax
          mov bx, flipmode
          push ax                       ;off
          push bx                       ;flip

          call RelSpriteFlip
Ret
EndP

;****************************************************************************************
;Translucent call with flip
;****************************************************************************************
RelXmsPutT PROC Uses Ds Si Es di,\
          Layer:Word, X:Word, Y:Word, SprIndexSeg:Word, SprIndexOff:Word,\
          FlipMode:word, DummySeg:Word, XmsHandle:Word


		  mov es, sprindexseg
		  mov di, sprindexoff

		  XOR AX,AX                     ;MUST BE 0
		  MOV XMSBLOCK.DHandle, AX      ;TO TREAT IT AS SEG:OFF PAIR
		  MOV AX, DummySeg              ;BASE SEGMENT:OFFSET(32 BIT)
		  shl eax,16					;this is the problem!!!!!
		  xor ax, ax
		  MOV XMSBLOCK.DOffset, EAX     ;REDUNDANT BUT FASTER
		  MOV AX, xmshandle             ;XMS HANDLE(16 BIT)
		  MOV XMSBLOCK.SHandle, AX
		  MOV EAX, es:[di+4]            ;32 BIT XMS OFFSET		'Offset
		  MOV XMSBLOCK.SOffset, EAX
		  MOV EBX, es:[di]				;size in bytes
		  MOV XMSBLOCK.BYTES, EBX
		  MOV AX, SEG XMSBLOCK
		  MOV DS, AX
		  MOV SI, OFFSET XMSBLOCK
		  MOV AX, 0B00h
		  CALL [XMSDUDE]


          ;;; Do a RelSprite Call
          xor dx, dx
          mov si, dx                    ;dummy offset
          mov ax,Layer                  ;LAYER SEG
          mov bx,X                      ;X
          mov cx,Y                      ;Y
          mov dx, DummySeg              ;DUMMY SEG
          push ax			    	    ;layer
          push bx                       ;x
          push cx                       ;y
          push dx                       ;seg
          xor ax, ax
          mov bx, flipmode
          push ax                       ;off
          push bx                       ;flip

          call RelSpriteFlipT
Ret
EndP

;****************************************************************************************
;Color call with flip
;****************************************************************************************
RelXmsPutC PROC Uses Ds Si Es di,\
          Layer:Word, X:Word, Y:Word, SprIndexSeg:Word, SprIndexOff:Word,\
          FlipMode:word,Clr:word, DummySeg:Word, XmsHandle:Word


		  mov es, sprindexseg
		  mov di, sprindexoff

		  XOR AX,AX                     ;MUST BE 0
		  MOV XMSBLOCK.DHandle, AX      ;TO TREAT IT AS SEG:OFF PAIR
		  MOV AX, DummySeg              ;BASE SEGMENT:OFFSET(32 BIT)
		  shl eax,16					;this is the problem!!!!!
		  xor ax, ax
		  MOV XMSBLOCK.DOffset, EAX     ;REDUNDANT BUT FASTER
		  MOV AX, xmshandle             ;XMS HANDLE(16 BIT)
		  MOV XMSBLOCK.SHandle, AX
		  MOV EAX, es:[di+4]            ;32 BIT XMS OFFSET		'Offset
		  MOV XMSBLOCK.SOffset, EAX
		  MOV EBX, es:[di]				;size in bytes
		  MOV XMSBLOCK.BYTES, EBX
		  MOV AX, SEG XMSBLOCK
		  MOV DS, AX
		  MOV SI, OFFSET XMSBLOCK
		  MOV AX, 0B00h
		  CALL [XMSDUDE]


          ;;; Do a RelSprite Call
          xor dx, dx
          mov si, dx                    ;dummy offset
          mov ax,Layer                  ;LAYER SEG
          mov bx,X                      ;X
          mov cx,Y                      ;Y
          mov dx, DummySeg              ;DUMMY SEG
          push ax			    	    ;layer
          push bx                       ;x
          push cx                       ;y
          push dx                       ;seg
          xor ax, ax
          mov bx, flipmode
          mov cx, clr
          push ax                       ;off
          push bx                       ;flip
          Push cx

          call RelSpriteFlipC
Ret
EndP
;****************************************************************************************
;Gamma call with flip
;****************************************************************************************
RelXmsPutG PROC Uses Ds Si Es di,\
          Layer:Word, X:Word, Y:Word, SprIndexSeg:Word, SprIndexOff:Word,\
          FlipMode:word, gamma:word, DummySeg:Word, XmsHandle:Word


		  mov es, sprindexseg
		  mov di, sprindexoff

		  XOR AX,AX                     ;MUST BE 0
		  MOV XMSBLOCK.DHandle, AX      ;TO TREAT IT AS SEG:OFF PAIR
		  MOV AX, DummySeg              ;BASE SEGMENT:OFFSET(32 BIT)
		  shl eax,16					;this is the problem!!!!!
		  xor ax, ax
		  MOV XMSBLOCK.DOffset, EAX     ;REDUNDANT BUT FASTER
		  MOV AX, xmshandle             ;XMS HANDLE(16 BIT)
		  MOV XMSBLOCK.SHandle, AX
		  MOV EAX, es:[di+4]            ;32 BIT XMS OFFSET		'Offset
		  MOV XMSBLOCK.SOffset, EAX
		  MOV EBX, es:[di]				;size in bytes
		  MOV XMSBLOCK.BYTES, EBX
		  MOV AX, SEG XMSBLOCK
		  MOV DS, AX
		  MOV SI, OFFSET XMSBLOCK
		  MOV AX, 0B00h
		  CALL [XMSDUDE]


          ;;; Do a RelSprite Call
          xor dx, dx
          mov si, dx                    ;dummy offset
          mov ax,Layer                  ;LAYER SEG
          mov bx,X                      ;X
          mov cx,Y                      ;Y
          mov dx, DummySeg              ;DUMMY SEG
          push ax			    	    ;layer
          push bx                       ;x
          push cx                       ;y
          push dx                       ;seg
          xor ax, ax
          mov bx, flipmode
          mov cx, gamma
          push ax                       ;off
          push bx                       ;flip
          Push cx

          call RelSpriteFlipG
Ret
EndP

;****************************************************************************************
;Solid call without  flip
;****************************************************************************************
RelXmsPutS PROC Uses Ds Si Es di,\
          Layer:Word, X:Word, Y:Word, SprIndexSeg:Word, SprIndexOff:Word,\
          DummySeg:Word, XmsHandle:Word


		  mov es, sprindexseg
		  mov di, sprindexoff

		  XOR AX,AX                     ;MUST BE 0
		  MOV XMSBLOCK.DHandle, AX      ;TO TREAT IT AS SEG:OFF PAIR
		  MOV AX, DummySeg              ;BASE SEGMENT:OFFSET(32 BIT)
		  shl eax,16					;this is the problem!!!!!
		  xor ax, ax
		  MOV XMSBLOCK.DOffset, EAX     ;REDUNDANT BUT FASTER
		  MOV AX, xmshandle             ;XMS HANDLE(16 BIT)
		  MOV XMSBLOCK.SHandle, AX
		  MOV EAX, es:[di+4]            ;32 BIT XMS OFFSET		'Offset
		  MOV XMSBLOCK.SOffset, EAX
		  MOV EBX, es:[di]				;size in bytes
		  MOV XMSBLOCK.BYTES, EBX
		  MOV AX, SEG XMSBLOCK
		  MOV DS, AX
		  MOV SI, OFFSET XMSBLOCK
		  MOV AX, 0B00h
		  CALL [XMSDUDE]


          ;;; Do a RelSprite Call
          xor dx, dx
          mov si, dx                    ;dummy offset
          mov ax,Layer                  ;LAYER SEG
          mov bx,X                      ;X
          mov cx,Y                      ;Y
          mov dx, DummySeg              ;DUMMY SEG
          push ax			    	    ;layer
          push bx                       ;x
          push cx                       ;y
          push dx                       ;seg
          xor ax, ax
          push ax                       ;off

          call RelSpriteSolid
Ret
EndP


END








