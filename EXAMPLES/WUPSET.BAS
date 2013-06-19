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
    x% = SIN(F& / 120) * 160
    y% = COS(F& / 150) * 100
    xlis% = x% + 160
    ylis% = y% + 100
    xlis2% = 320 - xlis%
    ylis2% = 200 - ylis%


    RelCls Layer, 0
    'RelLineH Layer, 0, 52, 319, 100
    I = (I + TiltMag) MOD 360
    aa2! = I * PI! / 180
        FOR angle = 0 TO 359 STEP 5
            a! = angle * PI! / 180
            a2! = a! - aa2!
            a2! = a! + I * 3.14153 / 180
            x! = COS(angle * 3.141593 / 180 + a!) * Radius
            y! = SIN((x!) * 3.141593 / 180 + a2!) * Radius
            x! = COS(y! * 3.141593 / 180 + a!) * Radius
            y! = SIN((x!) * 3.141593 / 180 + a2!) * Radius
            x2! = -y!
            y2! = x!
            RelPsetWu Layer, xlis% + x!, ylis% + y!, 255
            RelPsetWu Layer, xlis% + x2!, ylis% + y2!, 255
            '''2nd
            RelPsetWu Layer, xlis2% + x!, ylis2% + y!, 255
            RelPsetWu Layer, xlis2% + x2!, ylis2% + y2!, 255
        NEXT angle
        'RelWait
        RelPcopy VIDEO, Layer
LOOP UNTIL INKEY$ <> ""

Fps% = F& / (TIMER - T#)
CLS
SCREEN 0
WIDTH 80
PRINT "FPS:"; Fps%
c$ = INPUT$(1)
END

