'Shows some smoothing stuff. ;*)


REM $INCLUDE: 'RelLib.BI'

DEFINT A-Z


REM $DYNAMIC
DIM Vpage(31999) AS INTEGER
Layer = VARSEG(Vpage(0))

RelFfix
PI! = 3.141593
Radius = 40             'Radius of the circle
TiltMag = 2


CLS
SCREEN 13

 FOR I = 0 TO 255
  OUT &H3C8, I
  OUT &H3C9, I \ 4
  OUT &H3C9, I \ 4
  OUT &H3C9, I \ 4
 NEXT I


T# = TIMER
DO
    F& = (F& + 1) AND &H7FFFFFFF
    X% = SIN(F& / 120) * 160
    Y% = COS(F& / 150) * 100
    xlis% = X% + 160
    ylis% = Y% + 100
    xlis2% = 320 - xlis%
    ylis2% = 200 - ylis%

    I = (I + TiltMag) MOD 360
    aa2! = I * PI! / 180
        FOR Angle = 0 TO 359 STEP 5
            a! = Angle * PI! / 180
            a2! = a! - aa2!
            a2! = a! + I * 3.14153 / 180
            X! = COS(Angle * 3.141593 / 180 + a!) * Radius
            Y! = SIN((X!) * 3.141593 / 180 + a2!) * Radius
            X! = COS(Y! * 3.141593 / 180 + a!) * Radius
            Y! = SIN((X!) * 3.141593 / 180 + a2!) * Radius
            x2! = -Y!
            y2! = X!
            RelPset Layer, xlis% + X!, ylis% + Y!, 255
            RelPset Layer, xlis% + x2!, ylis% + y2!, 255
            '''2nd
            RelPset Layer, xlis2% + X!, ylis2% + Y!, 255
            RelPset Layer, xlis2% + x2!, ylis2% + y2!, 255
        NEXT Angle
        'RelWait
        RelSmooth Layer, 0, 0, 319, 200
        RelBox Layer, 0, 0, 319, 199, 0         'erase ugly pixels
        RelPCopy VIDEO, Layer
LOOP UNTIL INKEY$ <> ""

Fps% = F& / (TIMER - T#)
CLS
SCREEN 0
WIDTH 80
PRINT "FPS:"; Fps%
c$ = INPUT$(1)
END

