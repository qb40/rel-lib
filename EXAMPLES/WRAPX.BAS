REM $INCLUDE: 'RelLib.bi'
REM $DYNAMIC
SCREEN 13
CLS
CLEAR

REDIM SHARED Vpage(31999) AS INTEGER
REDIM SHARED Vpage2(31999) AS INTEGER
DIM SHARED Layer AS INTEGER
DIM SHARED Layer2 AS INTEGER

FOR Y = 0 TO 199
FOR X = 0 TO 319
    RelPset VIDEO, X, Y, X OR Y
NEXT X
NEXT Y

Layer = VARSEG(Vpage(0))
Layer2 = VARSEG(Vpage2(0))

RelPCopy Layer2, VIDEO          'save layer
RelPCopy Layer, VIDEO          'save layer

T# = TIMER
N& = 0

DO
        N& = N& + 1

        'Scroll
        Xoff = (Xoff + 1) MOD 320
        RelWrapX VIDEO, Layer2, Xoff
LOOP UNTIL INKEY$ <> ""

PRINT N& / (TIMER - T#)

C$ = INPUT$(1)

T# = TIMER
N& = 0

DO
        N& = N& + 1

        'Scroll
        Xoff = (Xoff - 1)
        IF Xoff < 0 THEN Xoff = 319
        RelWrapX VIDEO, Layer2, Xoff
LOOP UNTIL INKEY$ <> ""

PRINT N& / (TIMER - T#)
C$ = INPUT$(1)


CLS
SCREEN 0
WIDTH 80
END

