'Uses 64*64 tiles

DEFINT A-Z

REM $INCLUDE: 'RelLib.BI'

RANDOMIZE TIMER

TYPE KartType
    x       AS SINGLE
    y       AS SINGLE
    dx      AS SINGLE
    dy      AS SINGLE
    Angle   AS INTEGER
    speed   AS SINGLE
    accel   AS SINGLE
END TYPE


TYPE LevelType
    camx        AS INTEGER
    camy        AS INTEGER
    MaxX        AS INTEGER
    MaxY        AS INTEGER
END TYPE

CONST PI = 3.141593
CONST FRICTION = .015
CONST MAXTILE = 5
CONST TSIZE = 64
CONST TSIZESQUARED = TSIZE * TSIZE
CONST MAPTILEXMAX = 64
CONST MAPMAXPIXELX = MAPTILEXMAX * TSIZE
CONST MAPTILEYMAX = 128
CONST MAPMAXPIXELY = MAPTILEYMAX * TSIZE


'$DYNAMIC

DIM SHARED Vpage%(0 TO 31999)
DIM SHARED Layer%

'$STATIC
DIM SHARED Lcos!(359)
DIM SHARED Lsin!(359)
DIM SHARED Map%(MAPTILEXMAX - 1, MAPTILEYMAX - 1)
DIM SHARED Texture%((((TSIZESQUARED%) + 4) \ 2) * MAXTILE)

Layer% = VARSEG(Vpage%(0))

DIM SHARED Mario AS KartType


Mario.x = 0
Mario.y = 0
Mario.dx = .5
Mario.dy = .5
Mario.Angle = 0
Mario.accel = .1
Mario.speed = 0


Level.camX = 0
Level.camY = 0
Level.MaxX = 2000
Level.MaxY = 1500

RelFFix

FOR y% = 0 TO MAPTILEYMAX - 1
FOR x% = 0 TO MAPTILEXMAX - 1
    Map%(x%, y%) = 2 + INT(RND * (MAXTILE - 1))
    'set to one on bounds so that you see the map bounds
    IF y% = 0 THEN Map%(x%, y%) = 1
    IF x% = 0 THEN Map%(x%, y%) = 1
    IF y% = MAPTILEYMAX - 1 THEN Map%(x%, y%) = 1
    IF x% = MAPTILEXMAX - 1 THEN Map%(x%, y%) = 1
NEXT x%
NEXT y%

FOR i% = 0 TO 359
    RA! = i% * (3.141593 / 180)
    Lcos!(i%) = COS(RA!)
    Lsin!(i%) = SIN(RA!)
NEXT i%


CLS
SCREEN 13


FOR i = 0 TO 255
 OUT &H3C8, i
 OUT &H3C9, i \ 8
 OUT &H3C9, i \ 4
 OUT &H3C9, i \ 8
NEXT i

'Textures
FOR y% = 0 TO 63
FOR x% = 0 TO 63
    PSET (x%, y%), 255 - (4 * SQR((x% - 32) ^ 2 + (y% - 32) ^ 2)) AND 255
    PSET (x% + 64, y%), 4 * ABS((x% ^ 2 + y% ^ 2) AND 63) + 31
    PSET (x% + 64 * 2, y%), 64 + (x% * RND) OR (RND * y%)
    PSET (x% + 64 * 3, y%), SIN(y% OR x%) * 127 + COS(y% OR x%) * 127
    PSET (x% + 64 * 4, y%), (4 * SQR((x% - 32) ^ 2 + (y% - 32) ^ 2)) AND 255
NEXT x%
NEXT y%
FOR i% = 0 TO 3
RelSmooth VIDEO, 0, 0, 319, 64
NEXT i%
FOR i% = 0 TO MAXTILE - 1
    GET (i% * 64, 0)-STEP(63, 63), Texture%(i% * (((TSIZESQUARED%) + 4) \ 2))
NEXT i%

x1 = 0
y1 = 100
x2 = 319
y2 = 199

Angle = 0
scalex = 200
scaley = 200
scalez = 15
Horz = 5
camx! = 0
camy! = 0
RelKeyBoardON
Finished = FALSE
F& = 0
T# = TIMER
DO
    F& = (F& + 1) AND &H7FFFFFFF

    IF RelKey(KEYLEFT) THEN
       Mario.Angle = (Mario.Angle - 1)
       IF Mario.Angle < 0 THEN Mario.Angle = 360 + Mario.Angle
       KoopaFrame% = 2
    END IF
    IF RelKey(KEYRIGHT) THEN
       Mario.Angle = (Mario.Angle + 1)
       IF Mario.Angle > 359 THEN Mario.Angle = 360 - Mario.Angle
       KoopaFrame% = 3
    END IF
    IF RelKey(KEYDOWN) THEN
        Mario.speed = Mario.speed - Mario.accel
    END IF
    IF RelKey(KEYUP) THEN
        Mario.speed = Mario.speed + Mario.accel
    END IF
    IF RelKey(KEYSPACE) THEN
        'Scalez = Scalez + 1
    END IF
    IF RelKey(&H1E) THEN            'A
        scalez = scalez + 1
    END IF
    IF RelKey(&H2C) THEN            'z
        scalez = scalez - 1
    END IF
    IF RelKey(&H1F) THEN            's
        scalex = scalex + 1
    END IF
    IF RelKey(&H2D) THEN            'x
        scalex = scalex - 1
    END IF
    IF RelKey(&H20) THEN            'd
        scaley = scaley + 1
    END IF
    IF RelKey(&H2E) THEN            'c
        scaley = scaley - 1
    END IF

    IF RelKey(&H21) THEN            'F
        Horz = Horz + 1
    END IF
    IF RelKey(&H2F) THEN            'v
        Horz = Horz - 1
    END IF



    IF RelKey(KEYENTER) THEN
       Finished = TRUE
    END IF
    IF RelKey(KEYESC) THEN
        Finished = TRUE
    END IF

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
    RelMode7Map Layer%, x1, y1, x2, y2, Angle, scalex, scaley, scalez, Horz, px!, py!, Texture%(), 0, Map%()
    'RelPrint is sloooooowwwwww accccck!!!!
    RelPrint Layer, 0, 0, "Camx:" + STR$(INT(px!)), 224, FALSE
    RelPrint Layer, 0, 10, "Camy:" + STR$(INT(py!)), 224, FALSE
    RelPrint Layer, 0, 20, "scalex:" + STR$(scalex), 224, FALSE
    RelPrint Layer, 0, 30, "scaley:" + STR$(scaley), 224, FALSE
    RelPrint Layer, 0, 40, "scalez:" + STR$(scalez), 224, FALSE
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

