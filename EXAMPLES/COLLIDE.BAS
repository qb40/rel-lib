'Example of a pixel-perfect collision detection
'try to ruun this on a 486 to see the speed!!!!

'Bencmarks(486 ,WIN 95, 32*32 Solid Sprite)
'RelCollideSpr=44,444.8888888/Second(Pixel-Perfect)
'RelCollideSprB=45,003.00058/Second(Bounding-Box)
'QB's STR$(A)=47,000/Second
'This goes to show how FAST this routine is.

REM $INCLUDE: 'RelLib.BI'

DEFINT A-Z
RANDOMIZE TIMER


TYPE SpriteType
        X       AS INTEGER
        Y       AS INTEGER
        XV      AS INTEGER
        YV      AS INTEGER
        ox      AS INTEGER
        oy      AS INTEGER
        id      AS INTEGER   'unused
        Mode    AS INTEGER   'unused
END TYPE

'$DYNAMIC
CLS
SCREEN 13
RANDOMIZE TIMER
DIM SHARED Vpage(31999)
Size = RelSize(0, 0, 31, 31)
DIM Spr(Size)

DIM SHARED Balls(20) AS SpriteType

CLS

'Draw our Ball and GET it
O = 0
FOR Rad = 14 TO 0 STEP -1
  C = 31 - Rad
  CIRCLE (15 + O, 15 + O), Rad, C
  PAINT (15 + O, 15 + O), C
  O = O - .1
NEXT Rad

GET (0, 0)-(31, 31), Spr(0)

'Initialize vectors

FOR I = 0 TO UBOUND(Balls)
        X = INT(RND * 291)
        Y = INT(RND * 171)
        XV = -3 + INT(RND * 6)
        YV = -3 + INT(RND * 6)
        id = INT(RND * 3)
        Mode = INT(RND * 5)
        Balls(I).X = X
        Balls(I).Y = Y
        Balls(I).XV = XV
        Balls(I).YV = YV
        Balls(I).id = id
        Balls(I).Mode = Mode
NEXT I


DO
        RelCLS VARSEG(Vpage(0)), 32            'BG color=BLUE
        RelPrint VARSEG(Vpage(0)), 0, 0, "Bouncing Balls!!!!!!", 23, FALSE
        RelPrint VARSEG(Vpage(0)), 0, 10, "Using RelLib's Pixel-Perfect", 23, FALSE
        RelPrint VARSEG(Vpage(0)), 0, 20, "Collision Detection", 23, FALSE
        'Move the balls
        FOR I = 0 TO UBOUND(Balls)
                Balls(I).ox = Balls(I).X
                Balls(I).oy = Balls(I).Y
                Balls(I).X = Balls(I).X + Balls(I).XV
                Balls(I).Y = Balls(I).Y + Balls(I).YV
                FOR J = 0 TO UBOUND(Balls)
                        IF RelCollideSpr(Balls(I).X, Balls(I).Y, VARSEG(Spr(0)), VARPTR(Spr(0)), Balls(J).X, Balls(J).Y, VARSEG(Spr(0)), VARPTR(Spr(0))) THEN
                                Balls(J).ox = Balls(J).X
                                Balls(J).oy = Balls(J).Y

                                SWAP Balls(I).XV, Balls(J).XV
                                SWAP Balls(I).YV, Balls(J).YV

                                Balls(I).X = Balls(I).ox
                                Balls(I).Y = Balls(I).oy
                                Balls(J).X = Balls(J).ox
                                Balls(J).Y = Balls(J).oy
                        END IF
                NEXT J

                IF Balls(I).X > 320 THEN
                        Balls(I).XV = -ABS(Balls(I).XV)
                ELSEIF Balls(I).X < -32 THEN
                        Balls(I).XV = ABS(Balls(I).XV)
                END IF
                IF Balls(I).Y > 200 THEN
                        Balls(I).YV = -ABS(Balls(I).YV)
                ELSEIF Balls(I).Y < -32 THEN
                        Balls(I).YV = ABS(Balls(I).YV)
                END IF
                'Plot it
                RelSprite VARSEG(Vpage(0)), Balls(I).X, Balls(I).Y, VARSEG(Spr(0)), VARPTR(Spr(0))
        NEXT I

        RelWait
        RelPCopy VIDEO, VARSEG(Vpage(0))
LOOP UNTIL INKEY$ <> ""

