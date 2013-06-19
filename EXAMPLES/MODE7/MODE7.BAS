'This the the No map example
'Faster than mapmode but only supports one tile
'useful for:
'64*64 Tilesize
'1. Floors in fighting games
'2. eye candies
'3. endings and intros
'4. ????

DEFINT A-Z

REM $INCLUDE: 'RelLib.BI'

RANDOMIZE TIMER

TYPE KartType                   'our camera
    x       AS SINGLE
    y       AS SINGLE
    dx      AS SINGLE
    dy      AS SINGLE
    Angle   AS INTEGER
    speed   AS SINGLE
    accel   AS SINGLE
END TYPE


'not needed but used for easy reference
CONST PI = 3.141593
CONST FRICTION = .016                       'for pseudo physics
CONST TSIZE = 64                            'tilesize
CONST TSIZESQUARED = TSIZE * TSIZE
CONST MAPTILEXMAX = 64
CONST MAPMAXPIXELX = MAPTILEXMAX * TSIZE
CONST MAPTILEYMAX = 64
CONST MAPMAXPIXELY = MAPTILEYMAX * TSIZE


'$DYNAMIC

DIM SHARED Vpage%(0 TO 31999)           'our buffer
DIM SHARED Layer%

'$STATIC
DIM SHARED Lcos!(359)                   'fast Lookups
DIM SHARED Lsin!(359)
DIM SHARED Map%(63, 63)
DIM SHARED Texture%((((TSIZESQUARED%) + 4) \ 2))    'calc array size for
                                                    'GET array

Layer% = VARSEG(Vpage%(0))                          'set layer address
                                                    'for reference

DIM SHARED Mario AS KartType                        'needs a better name


Mario.x = MAPMAXPIXELX \ 2                  'center our camera
Mario.y = MAPMAXPIXELY \ 2
Mario.dx = 0
Mario.dy = 0
Mario.Angle = 0
Mario.accel = .1                        'acceleration
Mario.speed = 0



'calc lookup tables

FOR i% = 0 TO 359
    RA! = i% * (3.141593 / 180)
    Lcos!(i%) = COS(RA!)
    Lsin!(i%) = SIN(RA!)
NEXT i%

RelFFix

CLS
SCREEN 13


'gray scale the pal
FOR i = 0 TO 255
 OUT &H3C8, i
 OUT &H3C9, i \ 6
 OUT &H3C9, i \ 4
 OUT &H3C9, i \ 8
NEXT i

'do some nice texture
FOR y% = 0 TO 63
FOR x% = 0 TO 63
    PSET (x%, y%), 4 * ABS((x% ^ 2 + y% ^ 2) AND 127) + 128
NEXT x%
NEXT y%

'smooth it for kicks ;*)
FOR i% = 0 TO 1
    RelSmooth VIDEO, 0, 0, 319, 64
NEXT i%
'duh!
GET (0, 0)-STEP(63, 63), Texture%(0)

x1 = 0              'window dimensions for Mode7
y1 = 100
x2 = 319
y2 = 199

'mode 7 parameters
Angle = 0               'Look forward
Scalex = 200            '200 looks good
Scaley = 200
Scalez = 15             'height
Horz = 10               'eyeview
camx! = 0
camy! = 0
RelKeyBoardON           'activate keyboard handler
Finished = FALSE
T# = TIMER
DO
    F& = (F& + 1) AND &H7FFFFFFF

    IF RelKey(KEYLEFT) THEN             'rotate angle
       Mario.Angle = (Mario.Angle - 1)
       IF Mario.Angle < 0 THEN Mario.Angle = 360 + Mario.Angle
       KoopaFrame% = 2
    END IF
    IF RelKey(KEYRIGHT) THEN            'rotate angle
       Mario.Angle = (Mario.Angle + 1)
       IF Mario.Angle > 359 THEN Mario.Angle = 360 - Mario.Angle
       KoopaFrame% = 3
    END IF
    IF RelKey(KEYDOWN) THEN             'move backwards
        Mario.speed = Mario.speed - Mario.accel
    END IF
    IF RelKey(KEYUP) THEN               'move forvard
        Mario.speed = Mario.speed + Mario.accel
    END IF

    IF RelKey(&H1E) THEN            'A  'increase height
        Scalez = Scalez + 1
    END IF
    IF RelKey(&H2C) THEN            'z  decrease height
        Scalez = Scalez - 1
    END IF
    IF RelKey(&H1F) THEN            's
        Scalex = Scalex + 1
    END IF
    IF RelKey(&H2D) THEN            'x
        Scalex = Scalex - 1
    END IF
    IF RelKey(&H20) THEN            'd
        Scaley = Scaley + 1
    END IF
    IF RelKey(&H2E) THEN            'c
        Scaley = Scaley - 1
    END IF

    IF RelKey(&H21) THEN            'F  'decrease eyeview
        Horz = Horz + 1
        y1 = y1 - 1
        IF y1 < 0 THEN y1 = 0
    END IF
    IF RelKey(&H2F) THEN            'v  increase eyeview
        Horz = Horz - 1
        y1 = y1 + 1
        IF y1 > 199 THEN y1 = 199
    END IF

    IF RelKey(KEYENTER) THEN
       Finished = TRUE
    END IF
    IF RelKey(KEYESC) THEN
        Finished = TRUE
    END IF

    'calc physics
    Mario.speed = Mario.speed - Mario.speed * FRICTION
    dx! = (Lcos!(Mario.Angle)) * Mario.speed
    dy! = (Lsin!(Mario.Angle)) * Mario.speed

    Mario.x = Mario.x + dx!
    IF Mario.x < 0 THEN
        Mario.x = 0
    ELSEIF Mario.x >= MAPMAXPIXELX THEN
        Mario.x = MAPMAXPIXELX
    END IF

    Mario.y = Mario.y + dy!
    IF Mario.y < 0 THEN
        Mario.y = 0
    ELSEIF Mario.y >= MAPMAXPIXELY THEN
        Mario.y = MAPMAXPIXELY
    END IF

    Angle% = Mario.Angle
    px! = Mario.x
    py! = Mario.y
    RelCls Layer, 0
    RelMode7 Layer%, x1, y1, x2, y2, Angle%, Scalex, Scaley, Scalez, Horz, px!, py!, Texture%(), 0
    'RelPrint is sloooooowwwwww accccck!!!!
    RelPrint Layer, 0, 0, "Camx:" + STR$(INT(px!)), 224, FALSE
    RelPrint Layer, 0, 10, "Camy:" + STR$(INT(py!)), 224, FALSE
    RelPrint Layer, 0, 20, "scalex:" + STR$(Scalex), 224, FALSE
    RelPrint Layer, 0, 30, "scaley:" + STR$(Scaley), 224, FALSE
    RelPrint Layer, 0, 40, "scalez:" + STR$(Scalez), 224, FALSE
    RelPrint Layer, 0, 50, "horz:" + STR$(Horz), 224, FALSE
    'RelWait
    RelPcopy VIDEO, Layer
LOOP UNTIL Finished

RelKeyBoardOFF

Fps% = F& / (TIMER - T#)
CLS
SCREEN 0
WIDTH 80
PRINT "FPS:"; Fps%
c$ = INPUT$(1)
END

