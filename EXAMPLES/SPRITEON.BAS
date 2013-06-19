REM $INCLUDE: 'RelLib.BI'

DEFINT A-Z
RANDOMIZE TIMER

CONST Xmax = 255, Ymax = 159

BuffX = 25              'Variables to put our DestBuffer
BuffY = 15

CLS
SCREEN 13

DIM SHARED Vpage(31999)                 'our page
Size = RelSize(0, 0, Xmax, Ymax)
DIM DestSpr(Size)                       'QB array buffer
Size = RelSize(0, 0, 15, 15)
DIM Spr(Size)                           'another Sprite

'Draw some cheesy lines
FOR I = 0 TO 8
        LINE (I, I)-(15 - I, 15 - I), 23 + I, B
NEXT I
GET (0, 0)-(15, 15), Spr(0)             'put it on a 16*16 array

FOR Y = 0 TO 200 STEP 16
FOR X = 0 TO 320 STEP 16
        RelSprite VIDEO, X, Y, VARSEG(Spr(0)), VARPTR(Spr(0))
NEXT X
NEXT Y

'get our Sprite buffer
RelGet VIDEO, 0, 0, Xmax, Ymax, VARSEG(DestSpr(0)), VARPTR(DestSpr(0))

CLS

'change our original 16*16 sprite
FOR I = 0 TO 8
        LINE (I, I)-(15 - I, 15 - I), 56 + I, B
NEXT I

'Just to Show that U can use RelGet :*)
RelGet VIDEO, 0, 0, 15, 15, VARSEG(Spr(0)), VARPTR(Spr(0))   'get it

CLS

'Put some Sprites
DO

RelSpriteOnSprite VARSEG(DestSpr(0)), VARPTR(DestSpr(0)), -20 + INT(RND * Xmax + 10), -20 + INT(RND * Ymax + 10), VARSEG(Spr(0)), VARPTR(Spr(0))
RelSpriteSolid VIDEO, BuffX, BuffY, VARSEG(DestSpr(0)), VARPTR(DestSpr(0))
LOOP UNTIL INKEY$ <> ""


YV = 1
XV = 1
'Put some Dots
DO
RelCls VARSEG(Vpage(0)), 35
RelPrint VARSEG(Vpage(0)), 0, 0, "You can move the buffer", 56, FALSE
RelPrint VARSEG(Vpage(0)), 0, 10, "Without worries!!!!", 56, FALSE
RelPrint VARSEG(Vpage(0)), 0, 20, "All AutoClipped :*)", 56, FALSE
RelSpriteOnSpriteS VARSEG(DestSpr(0)), VARPTR(DestSpr(0)), -20 + INT(RND * Xmax + 10), -20 + INT(RND * Ymax + 10), VARSEG(Spr(0)), VARPTR(Spr(0))
RelPsetOnSprite VARSEG(DestSpr(0)), VARPTR(DestSpr(0)), -10 + INT(RND * Xmax + 10), -10 + INT(RND * Ymax + 10), INT(RND * 256)
RelPsetOnSpriteT VARSEG(DestSpr(0)), VARPTR(DestSpr(0)), -10 + INT(RND * Xmax + 10), -10 + INT(RND * Ymax + 10), INT(RND * 256)
RelSpriteSolid VARSEG(Vpage(0)), BuffX, BuffY, VARSEG(DestSpr(0)), VARPTR(DestSpr(0))

'Move the Sprite Buffer
BuffX = BuffX + XV
IF BuffX > 300 THEN
        XV = -XV
ELSEIF BuffX < -200 THEN
        XV = -XV
END IF
BuffY = BuffY + YV
IF BuffY > 150 THEN
        YV = -YV
ELSEIF BuffY < -100 THEN
        YV = -YV
END IF
RelWait
RelPcopy VIDEO, VARSEG(Vpage(0))
LOOP UNTIL INKEY$ <> ""


BuffX = 25              'Variables to put our DestBuffer
BuffY = 15




DO
        RelCls VARSEG(Vpage(0)), 0

        X = RelMouseX
        Y = RelMouseY
        PointX = X - BuffX              'Correct coords as we'll put the
        PointY = Y - BuffY              'buffer at center

        C = RelPointOnSprite(VARSEG(DestSpr(0)), VARPTR(DestSpr(0)), PointX, PointY)
        RelSpriteSolid VARSEG(Vpage(0)), BuffX, BuffY, VARSEG(DestSpr(0)), VARPTR(DestSpr(0))

        'Print returned color
        RelPrint VARSEG(Vpage(0)), 0, 190, "Pixel Color:" + STR$(C), 56, FALSE

        'Crosshair
        RelLineH VARSEG(Vpage(0)), X - 10, Y, X + 10, 5
        RelLineV VARSEG(Vpage(0)), X, Y - 10, Y + 10, 5
        RelPset VARSEG(Vpage(0)), X, Y, 15

        'Try to Draw pixels if user presses left mouse
        IF RelMouseClick = 1 THEN
                RelPsetOnSprite VARSEG(DestSpr(0)), VARPTR(DestSpr(0)), PointX, PointY, INT(RND * 256)
        END IF

        RelPrint VARSEG(Vpage(0)), 0, 0, "Press Left Mouse Button", 56, FALSE
        RelPrint VARSEG(Vpage(0)), 0, 8, "to put a pixel.", 56, FALSE
        RelPcopy VIDEO, VARSEG(Vpage(0))
LOOP UNTIL INKEY$ <> ""


CLS
SCREEN 0: WIDTH 80
END





