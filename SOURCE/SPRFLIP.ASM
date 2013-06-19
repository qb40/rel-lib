;SUB RelSpriteFlip(BYVAL Layer%,BYVAL X%,BYVAL Y%,BYVAL SprSeg%,BYVAL SPROff%,Byval Flipmode%)
;;;;;                                                                                        
;;;;;
;;
;0=NoFlip
;1=FlipH
;2=FlipV
;3=FlipVH
;Else=No Flip
;;
;;
.Model Medium,BASIC
.386
.Code

Align 2


PUBLIC RelSpriteFlip

RelSpriteFlip  PROC uses Ds Es Si di,\
            Layer:Word, X:Word, Y:Word, SprSeg:Word, SprOff:Word, FlipMode:Word

            Local SiOff:    Word
            Local Wid:      Word
            Local Hei:      Word
            Local t20Mw:    Word
            Local OldWid:   Word
            Local OldHei:   Word
            Local ClipT:    Word            ;Clipping offsets
            Local ClipR:    Word
            Local ClipL:    Word
            Local ClipD:    Word


    Mov ds,SprSeg
    Mov es,Layer
    Mov si,SprOff                  
    Mov bx,ds:[si]                      ;Width of spr
    Shr bx,3
    Mov Wid,bx
    Mov OldWid,bx
    Mov dx,ds:[si+2]                   ;Height
    Mov Hei,dx
    Mov OldHei,Dx
    Mov Sioff,0
    Mov t20mW,0
    mov clipT,0
    mov clipR,0
    mov clipD,0
    mov clipL,0
    
    Add si,4                            ;1st color


                                        ;Note!!!!  After the clips
                                        ;Ax=X       Clipped
                                        ;Cx=Y       Clipped
                                        ;Bx=Width   New
                                        ;Dx=Height  New

        Mov ax,X
        Cmp ax,319              
        Jg @exit
        Cmp ax,0                
        Jl @ClipLeft
@PostClipLeft:
        Mov cx,Y
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

        Mov Wid,bx              ;Save wid
        
        ;;;;;calc offset.....
        
        Xchg ch,cl
        Mov bx,320
        
        Mov di,cx      
        Sub bx,Wid              ;get 320-Width
        
        Shr di,2   
        Add di,cx               ;Y*64+Y*256=Y*320  :)
        Mov T20Mw,bx
        
        Add di,ax               ;Offset done!!!=Y*320+X
        
        ;;;;
        ;;;;
        ;;;;
        ;;;;
        ;;;;Check here for our flipmode

        cmp FlipMode,1
            Je @FlipH
        cmp FlipMode,2
            Je @FlipV
        cmp FlipMode,3
            Je @FlipVH

        Mov bx,Wid              ;restore bx

@Yloop:

        Mov cx,bx               ;Clipped width to counter

@Xloop:

        Mov al,ds:[si]          ;color
        Inc si                  ;Next color
        Or al,al                ;check for color 0

        JZ @Skipcolor
           Mov es:[di],al 
        @Skipcolor:

        Inc di
        Dec cx                  ;Check width

        Jnz @Xloop

    Add di,T20MW                    ;Add to di 320-ClipWidth
    Add si,SiOff                    ;Si Offset clipped corrector
    
    dec dx                          ;Check Height

    Jnz @Yloop

@exit:
Ret


@ClipLeft:
        Neg ax          ;-ax=+ax
        Sub bx,ax       ;sub clipped width to read width
        Jle @Exit       ;Negative result = outa here
        Add si,ax       ;clip our sprite offset
                        ;bx is the new clipped width
        Mov Sioff,ax    ;save si offset corrector
        mov ClipL,ax    ;for clip of flipH
        Xor ax,ax       ;zero out coord
        Jmp @PostClipLeft


@ClipTop:
        Neg cx          
        Sub dx,cx       
        Jle @exit
        mov ClipT,cx    ;How much to clip down if flipped V

     @HeightLoop:
        Add si,Wid      ;add width to get to next scanline
        Dec cx
     Jnz @HeightLoop    ;Loop until we get to offset.cx=0
     Jmp @PostClipTop

@ClipRight:
       Sub Bx,320       ;Bx is now clipped right
       Add Sioff,bx     ;Add to si corrector
       mov ClipR,bx     ;for clip of flipH
       Mov bx,320       ;Correct bx to clipX2+1
       Sub bx,ax        ;Subract ax to bx to correct width(0 TO 319)
       Jmp @PostClipRight

@ClipDown:
       Add cx,dx        ;add height to Y
       Sub cx,200       ;Correct it
       Sub dx,cx        ;Crop out height
       mov cx,OldHei    ;put in OldHeight
       mov ClipD,cx     ;
       sub ClipD,dx     ;cropped down height
       Mov cx,Y         ;Restore Y
       Jmp @PostClipDown


;;==========Horizontal Flip clips perfectly!!!
@FlipH:
       add si,ClipR                 ;if clipped right then correct start offset
   @YloopFh:
       mov cx,Wid                   ;put width to counter 
       mov bx,cx                    ;copy it to bx for the 'hack'
       dec bx
       sub bx,ClipL                 ;if Clipped Left 
    
        @XloopFH:
    
            mov al,ds:[si+bx]
            or al,al
            jz @skipFh
               mov es:[di],al
            @skipFh:
            inc di
            dec bx
            dec cx

        jnz @XloopFH
        add di,t20Mw
        add si,oldWid
        dec dx

    jnz @YloopFh


Jmp @Exit


;;==========Vertical Flip clips perfectly!!!

@FlipV:

    mov cx,320                
    mov bx,dx                 ;bx=height
    dec bx
    Imul cx,bx                ;cx=Xy+di offset
    add di,cx                 ;Correct offset now
    ;;;
    ;;;clipT
    mov cx,OldWid             ;mov oldWid to counter if 
    mov bx,ClipT              ;cropped height at top
    imul cx,bx                ;mutiply by width to get correct offset
    sub si,cx                 ;correct offset

    ;;;
    ;;;ClipD
    mov ax,OldWid             ;mov oldWid to counter if 
    mov bx,ClipD              ;cropped height at top
    imul ax,bx                ;mutiply by width to get correct offset
    add si,ax                 ;correct offset

    
    @YloopV:
    
        mov cx,wid
    
    @XloopV:
    
            mov al,ds:[si]
            inc si        
            or al,al
            jz @skipFv
               mov es:[di],al
            @skipFv:
            
            inc di
            dec cx
    jnz @XloopV
    
        sub di,wid                      ;subract width
        sub di,320                      ;sub TO DI 320
        add si,SiOff
        dec dx    
    jnz @YloopV

Jmp @Exit

;;==========Vertical & Horizontal  clips perfectly!!!
@FlipVH:

    ;Recalculate Si
    ;Si=Si+(Height)*Width
    
    mov cx,OldWid
    
    mov bx,dx           ;Height
    imul cx,bx          ;Offset
    add si,cx
    dec si              ;Si= Last pixel on sprite

    ;;;
    ;;;clipT
    mov cx,OldWid             ;mov oldWid to counter if 
    mov bx,ClipT              ;cropped height at top
    imul cx,bx                ;mutiply by width to get correct offset
    sub si,cx                 ;correct offset

    ;;;
    ;;;ClipD
    mov ax,OldWid             ;mov oldWid to counter if 
    mov bx,ClipD              ;cropped height at top
    imul ax,bx                ;mutiply by width to get correct offset
    add si,ax                 ;correct offset

    ;;;
    ;;;ClipL
    sub si,ClipL              ;correct startoff
        
    @YloopVH:
        mov cx,Wid
        sub si,ClipL          ;add corrector
    @XloopVH:
    
            mov al,ds:[si]
            dec si
            or al,al
            jz @skipVH
               mov es:[di],al
            @skipVH:
            
            inc di
            dec cx
    jnz @XloopVH    
    
        add di,t20Mw
        sub si,ClipR            ;clipRight
        dec dx
    
    jnz @YloopVH    

Jmp @Exit

EndP

END

