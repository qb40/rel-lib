'Move the mouse
'is this what you want?
DEFINT A-Z

'$INCLUDE: 'RelLib.Bi'


REDIM SHARED Vpage(31999) AS INTEGER
REDIM SHARED Vpage2(31999) AS INTEGER

ArraySize = RelSize(0, 0, 32, 32)
REDIM SHARED Test(ArraySize) AS INTEGER

DIM SHARED Layer AS INTEGER
DIM SHARED Layer2 AS INTEGER


CLS
SCREEN 13

Layer = VARSEG(Vpage(0))
Layer2 = VARSEG(Vpage2(0))

FOR X = 0 TO 127
 OUT &H3C8, X
 OUT &H3C9, X * (127 / 63)
 OUT &H3C9, X * (127 / 63)
 OUT &H3C9, X * (127 / 63)
NEXT X


FOR Y = 0 TO 32
 FOR X = 0 TO 32
 d = SQR((X - 16) ^ 2 + (Y - 16) ^ 2) * 8
 IF d > 0 THEN PSET (X, Y), d ELSE PSET (X, Y), 0
 NEXT X
NEXT Y

GET (0, 0)-(32, 32), Test(0)


DEF SEG = &HA000
FOR X& = 0 TO 63999
  POKE X&, RND * 128
NEXT X&
DEF SEG = &HA000
FOR X& = 0 TO 63999
  POKE X&, (PEEK(X& + 1) + PEEK(X& - 1) + PEEK(X& + 320) + PEEK(X& - 320)) \ 4
NEXT X&

DEF SEG

RelSprite VIDEO, 0, 0, VARSEG(Test(0)), VARPTR(Test(0))

RelPcopy Layer2, VIDEO

DO
X = RelMouseX%
Y = RelMouseY%
RelPcopy Layer, Layer2
RelPrint Layer, 50, 0, "Shadow Put ", 200, FALSE
RelSpriteShadow Layer, X, Y, VARSEG(Test(0)), VARPTR(Test(0)), 1
RelPcopy VIDEO, Layer

LOOP UNTIL INKEY$ <> ""

DO
X = RelMouseX%
Y = RelMouseY%
RelPcopy Layer, Layer2
RelPrint Layer, 50, 0, "HiLite Put ", 224, FALSE
RelSpriteHiLite Layer, X, Y, VARSEG(Test(0)), VARPTR(Test(0)), 1
RelPcopy VIDEO, Layer

LOOP UNTIL INKEY$ <> ""

C$ = INPUT$(1)

