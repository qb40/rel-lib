'''Rellib Smooth Demo
'''using a smoothing algo for feedback effect.

DEFINT A-Z
REM $INCLUDE: 'RelLib.BI'

'$DYNAMIC


CONST PI = 3.141593
CONST FACTOR = PI / 180

RANDOMIZE TIMER

DIM Vpage1%(0 TO 31999)             'display page
DIM Vpage2%(0 TO 31999)             'zoom page

'$STATIC
DIM zoomx%(0 TO 319), zoomy&(0 TO 199)  'fast lookup for zooming

DIM Lsin(-10 TO 370) AS SINGLE          'sin LUT
DIM Lcos(-10 TO 370) AS SINGLE
                                        '"meteors"

MAXSTARS = 128                  'Stars from dav's demo
DIM starsx%(MAXSTARS), starsy%(MAXSTARS), starsnx%(MAXSTARS), starsny%(MAXSTARS)

DIM Layer1%
DIM Layer2%

Layer1% = VARSEG(Vpage1%(0))            'set reference
Layer2% = VARSEG(Vpage2%(0))

FOR i% = -10 TO 370                 'calc LUT
    ax! = i% * 3.141593 / 180
    Lsin(i%) = SIN(ax!)
    Lcos(i%) = COS(ax!)
NEXT i%

xx! = 0
FOR x% = 0 TO 319                   'Xzoom
    Xscale! = (84 / 100)
    zoomx%(x%) = INT((160 + ((x% - 160) * Xscale!)))
NEXT x%
yy! = 0
FOR y% = 0 TO 199
    Yscale! = (83 / 100)            'Yzoom
    zoomy&(y%) = 320& * INT((100 + ((y% - 100) * Yscale!)))
NEXT y%


FOR s% = 0 TO MAXSTARS              'Init Stars
  starsx%(s%) = RND * 65536 - 32768
  starsy%(s%) = RND * 65536 - 32768
NEXT s%



RelFFix         'Speed stuff
CLS
SCREEN 13



'Tilted sinus "rope"
Radius = 25
TiltMag = 5


'"Flower" parameters
Xrad% = 25              'Radius
Yrad% = 22
Freq% = 6
FoldLeng! = 6           'Magnitude
Fdir! = .3
rotdir% = 3             'rotation
T# = TIMER
DO
    F& = (F& + 1) AND &H7FFFFFFF


    'rotate our "flower"
    ang% = (ang% + rotdir%)
    IF ang% < 0 THEN
        rotdir% = -rotdir%
    ELSEIF ang% > 360 THEN
        rotdir% = -rotdir%
    END IF

    'increase/decrease magnitude of fold
    FoldLeng! = (FoldLeng! + Fdir!)
    IF FoldLeng! < -16 THEN
        Fdir! = -Fdir!
    ELSEIF FoldLeng! > 16 THEN
        Fdir! = -Fdir!
    END IF

    'move the "flower"
    xx% = SIN(F& / 10) * 40 + 152
    yy% = COS(F& / 20) * 30 + 92

    'Draw it
    FOR Angle% = 0 TO 360 STEP 3
        a% = ((Freq% * Angle%) MOD 360)
        b% = (Angle% + ang%) MOD 360
        x% = (Xrad% + FoldLeng! * Lsin((a%))) * Lsin((b%)) + xx%
        y% = (Yrad% + FoldLeng! * Lsin((a%))) * Lcos((b%)) + yy%
        RelPset Layer1%, x%, y%, 255
    NEXT Angle%

    x% = SIN(F& / 20) * 60
    y% = COS(F& / 40) * 30
    xlis% = x% + 160
    ylis% = y% + 100

    RI = (RI + TiltMag) MOD 360
    aa2! = RI * FACTOR
        FOR Angle = 0 TO 359 STEP 5
            a! = Angle * FACTOR
            a2! = a! - aa2!
            a2! = a! + RI * FACTOR
            x! = COS(Angle * FACTOR + a!) * Radius
            y! = SIN((x!) * FACTOR + a2!) * Radius
            x! = COS(y! * FACTOR + a!) * Radius
            y! = SIN((x!) * FACTOR + a2!) * Radius
            x2! = -y!
            y2! = x!
            xx1% = xlis% + x!
            yy1% = ylis% + y!
            xx2% = xlis% + x2!
            yy2% = ylis% + y2!

            RelPset Layer1%, xlis% + x!, ylis% + y!, 255
            RelPset Layer1%, xlis% + x2!, ylis% + y2!, 255
        NEXT Angle


    'zoom it and copy to Layer2%(our zoom layer)
    DEF SEG = Layer1%
    FOR y% = 0 TO 199
         FOR x% = 0 TO 319
            RelPset Layer2%, x%, y%, PEEK(zoomy&(y%) + zoomx%(x%))
         NEXT x%
    NEXT y%

    'copy the zoomed image to our draw page
    RelPcopy Layer1%, Layer2%

    'smooth for cooler effect
    '2 smooths for a cleaner effect
    RelSmooth Layer1%, 0, 0, 319, 199
    RelSmooth Layer1%, 0, 0, 319, 199
    RelBox Layer1%, 0, 0, 319, 199, 0         'erase ugly pixels

    'starzzzzz
    'dav's code
    FOR s% = 0 TO MAXSTARS
        k% = (s% + v%) AND 127
        c% = 255 - k%
        k% = k% + k% + 2
        starsnx%(s%) = 160 + starsx%(s%) \ k%
        starsny%(s%) = 100 + starsy%(s%) \ k%
        sx1% = starsnx%(s%)
        sy1% = starsny%(s%)
        RelPset Layer1%, sx1%, sy1%, c%
        RelPset Layer1%, sx1%, sy1% - 1, c%
        RelPset Layer1%, sx1%, sy1% + 1, c%
        RelPset Layer1%, sx1% + 1, sy1%, c%
        RelPset Layer1%, sx1% - 1, sy1%, c%
    NEXT
    v% = v% - 3

    'Blit our page to screen
    RelPcopy VIDEO, Layer1%
    GOSUB CalcNewGrad           'change the colors
LOOP UNTIL INKEY$ <> ""


DEF SEG     'return segment
CLS
SCREEN 0
WIDTH 80
PRINT "FPS:"; F& / (TIMER - T#)
PRINT "RelLib Smooth demo. ;*)"
c$ = INPUT$(1)
END

CalcNewGrad:
    CurrentTime& = TIMER * 64
    r% = INT(32 + 31 * COS(F& * PI / 256 + CurrentTime& / 74))
    g% = INT(32 + 31 * COS(F& * PI / 256 + CurrentTime& / 63))
    b% = INT(32 + 31 * COS(F& * PI / 256 + CurrentTime& / 81))
    FOR i% = 0 TO 127
        RelWriteRGB i%, r% * i% / 128, g% * i% / 128, b% * i% / 128
        RelWriteRGB 128 + i%, r% + (63 - r%) * i% / 128, g% + (63 - g%) * i% / 128, b% + (63 - b%) * i% / 128
    NEXT i%
RETURN



