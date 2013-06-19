'/This is a very fast water simulation program that I added to RelLib.
'/Use the mouse to move the water. Or just sit back and relax. :*)
'/I've commented this as much as possible but if you feel that you have to
'/ask me something, I'm usually at:
'1. Qbasicnews.com----->Forums
'2. Irc: Server: Espernet, Channel: #QBrpg
'/USE yer MOUSE

DEFINT A-Z

REM $DYNAMIC
REM $INCLUDE: 'RelLib.Bi'

CONST PI = 3.14151693#


DIM Vpage(31999) AS INTEGER             'The Screen
DIM TextPage(31999) AS INTEGER          'Texture
DIM Wpage1(31999) AS INTEGER            'Ripple
DIM Wpage2(31999) AS INTEGER            'Ripple

DIM Lsin1%(-1024 TO 1024)               'For plasma
DIM Lsin2%(-1024 TO 1024)
DIM Lsin3%(-1024 TO 1024)



Layer = VARSEG(Vpage(0))                'Setup segments for
TextSeg = VARSEG(TextPage(0))           'Easy reference
wseg1 = VARSEG(Wpage1(0))
wseg2 = VARSEG(Wpage2(0))


 FOR i% = -1024 TO 1024
    Lsin1%(i%) = SIN(i% / (128)) * 128      'Movement to left
    Lsin2%(i%) = SIN(i% / (64)) * 128       'Horiz bands
    Lsin3%(i%) = SIN(i% / (32)) * 64        'Vertical bands
 NEXT i%

CLS
SCREEN 13
RANDOMIZE TIMER


FOR i% = 0 TO 255
    OUT &H3C8, i%
    OUT &H3C9, INT(32 - 31 * SIN(i% * PI / 32))
    OUT &H3C9, INT(32 - 31 * SIN(i% * PI / 64))
    OUT &H3C9, INT(32 - 31 * SIN(i% * PI / 128))
NEXT i%


'Generate our Nasty Texture

GOSUB GenerateBG





'I REMmed this but you could Use any BMP you want
'Path$ = "C:\Qbasic\RelLib\Strikers\afbg1.bmp"
'RelLoadBMP TextSeg, Path$ + Filer$, TRUE               'Load it

Frames& = 0                 'Frame counter
 DO

  Frames& = Frames& + 1
  IF Frames& AND 3 THEN                     'Poke a pixel to
    X% = RelMouseX                          'Generate a ripple
    Y% = RelMouseY
    IF Y% > 1 AND Y% < 199 THEN             'Be careful not to go at the
      RelPset wseg1, X%, Y%, 255            'Top row and bottom row.
    END IF

    T! = TIMER                              'Ditto. Just a polar movement
    wX% = INT(COS(T! * .3) * COS(T!) * 160 + 96)
    wY% = INT(SIN(T! + .8) * 85 + 100)

    IF wY% > 1 AND wY% < 199 THEN                   'Poke a ripple
      RelPset wseg1, wX%, wY%, 255
      RelPset wseg1, 320 - wX%, 200 - wY%, 255
    END IF


  END IF

  '/This is the Water simulation block

      SWAP wseg1, wseg2                         'Magic
      RelWater wseg2, wseg1                     'Dest water 2
      RelRefrac Layer, wseg1, TextSeg              'Bump map

  '/End if block. Yes, it's that easy. :*) 3 lines!!!!

  RelWait
  RelPCopy VIDEO, Layer
 LOOP UNTIL LEN(INKEY$)


CLS
SCREEN 0
WIDTH 80
END




GenerateBG:
    FOR Y% = 0 TO 199
        FOR X% = 0 TO 318
            c% = Lsin3%(X% + Y%) + Lsin1%(X%) + Lsin2%(Y%)
            RelPset TextSeg, X%, Y%, c%
        NEXT X%
    NEXT Y%

RETURN

