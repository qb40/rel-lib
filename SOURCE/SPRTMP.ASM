.Model Medium,BASIC
.386
.Code

Align 2


PUBLIC RelSprite2

RelSprite2  PROC uses Ds Es Si di,\
            Layer:Word, X:Word, Y:Word, SprSeg:Word, SprOff:Word

            Local Wid:      Word
            Local Sioff:    Word
            Local t20Mw:    Word


    Mov ds,SprSeg
    Mov es,Layer
    Mov si,SprOff                  
    Mov bx,ds:[si]                      ;Width of spr
    Shr bx,3
    Mov dx,ds:[si+2]                   ;Height
    Mov Sioff,0
    Mov t20mW,0
    
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
        
        Xor ax,ax       ;zero out coord
        Jmp @PostClipLeft


@ClipTop:
        Neg cx          
        Sub dx,cx       
        Jle @exit

     @HeightLoop:
        Add si,Wid      ;add width to get to next scanline
        Dec cx
     Jnz @HeightLoop    ;Loop until we get to offset.cx=0
     Jmp @PostClipTop

@ClipRight:
       Sub Bx,320       ;Bx is now clipped right
       Add Sioff,bx     ;Add to si corrector
       Mov bx,320       ;Correct bx to clipX2+1
       Sub bx,ax        ;Subract ax to bx to correct width(0 TO 319)
       Jmp @PostClipRight

@ClipDown:
       Add cx,dx        ;add height to Y
       Sub cx,200       ;Correct it
       Sub dx,cx        ;Crop out height
       Mov cx,Y         ;Restore Y
       Jmp @PostClipDown


EndP

END

