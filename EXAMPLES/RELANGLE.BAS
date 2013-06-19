'This Proggie demonstrates how to do autoaiming bullets using
'RelAngle and 2 component vectors. I left it unoptimized for
'readability.

DEFINT A-Z


REM $INCLUDE: 'RelLib.BI'


CONST PI = 3.141593

DIM SHARED Coslut!(359), Sinlut!(359)
REDIM SHARED Vpage(31999)
DIM SHARED Layer AS INTEGER

'Bullet Attrib
DIM BulletX AS SINGLE
DIM BulletY AS SINGLE
DIM BulletXV AS SINGLE
DIM BulletYV AS SINGLE

Layer = VARSEG(Vpage(0))

'LUTS
FOR I = 0 TO 359
        Coslut!(I) = COS(I * PI / 180)
        Sinlut!(I) = SIN(I * PI / 180)
NEXT I

CLS
SCREEN 13

Size = RelSize(0, 0, 15, 15)
DIM Array(Size)
'Our Sprite
O = 0
FOR Rad = 7 TO 0 STEP -1
  C = 30 - Rad
  CIRCLE (8 + O, 8 + O), Rad, C, , , 1 / 2
  CIRCLE (8 + O, 8 + O), Rad, C, , , 2 / 1
  PAINT (8 + O, 8 + O), C
  O = O - .1
NEXT Rad


RelGet VIDEO, 0, 0, 15, 15, VARSEG(Array(0)), VARPTR(Array(0))

RelSprite VIDEO, 100, 100, VARSEG(Array(0)), VARPTR(Array(0))

        'IF RelMouseDetect THEN RelMouseShow
DIM XV AS SINGLE
DIM YV AS SINGLE
RelFfix

CenterX = 150
CenterY = 100
LineLen = 40       'Length of line

BulletON = FALSE   'if we are firing
BSpeed = 4         'Speed of bullets
DO
        RelCLS VARSEG(Vpage(0)), 0
        Angle = RelAngle(CenterX, CenterY, RelMouseX, RelMouseY)

        'if LeftMouse Click then fire
        IF RelMouseClick = 1 AND NOT BulletON THEN
                GOSUB InitBullet
                BulletON = TRUE
        END IF
        'if firing then move bullet
        IF BulletON THEN
                BulletX = BulletX + BulletXV
                BulletY = BulletY + BulletYV
                RelPset Layer, BulletX, BulletY, 15
                IF NOT RelInside(BulletX, BulletY, 0, 0, 319, 199) THEN
                        BulletON = FALSE
                END IF
        END IF


        'use this: Readable
                Anglerad! = Angle * 3.141593 / 180
                XV = COS(Anglerad!) * LineLen
                YV = SIN(Anglerad!) * LineLen

        'or this: FASTER
                'XV = COSlut!(Angle) * LineLen
                'YV = SINlut!(Angle) * LineLen

        'You could use Reline but this is better looking :*)  
        GOSUB PlotGradLine
        'Rotate our Sprite
        RelSpriteRotate Layer, CenterX - 8, CenterY - 8, Angle, VARSEG(Array(0)), VARPTR(Array(0))
        'Print Status
        RelPrint Layer, 0, 0, "RelAngle: " + STR$(Angle), 24, FALSE
        RelPrint Layer, 0, 10, "RelMouseX:" + STR$(RelMouseX), 24, FALSE
        RelPrint Layer, 0, 20, "RelMouseY:" + STR$(RelMouseY), 24, FALSE
        RelPrint Layer, RelMouseX - 4, RelMouseY - 3, "+", 24, FALSE
        RelPrint Layer, 0, 30, "Firing:" + STR$(BulletON), 24, FALSE

        'Instructions
        RelPrint Layer, 0, 180, "Move the Mouse", 24, TRUE
        RelPrint Layer, 0, 190, "Press Left Mouse Button to Fire", 24, TRUE
        RelWait
        RelPCopy VIDEO, VARSEG(Vpage(0))
LOOP UNTIL INKEY$ <> ""


CLS
SCREEN 0
WIDTH 80

END

'Plots multicolored lines
PlotGradLine:
        XXV! = XV / LineLen  'Normalize the vectors
        YYV! = YV / LineLen
        YY! = 0
        XX! = 0
        FOR I = 0 TO LineLen
                RelPset Layer, CenterX + XX!, CenterY + YY!, 50 + I
                XX! = XX! + XXV!       'Bresenham
                YY! = YY! + YYV!
        NEXT I
RETURN

'Calculate the bullets' vectors and initial position
InitBullet:
        BulletXV = Coslut!(Angle) * BSpeed
        BulletYV = Sinlut!(Angle) * BSpeed
        BulletX = CenterX + Coslut!(Angle) * LineLen
        BulletY = CenterY + Sinlut!(Angle) * LineLen
RETURN

