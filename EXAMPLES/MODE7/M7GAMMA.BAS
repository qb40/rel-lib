DECLARE SUB RelHlineG (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL GammaVal%)
DECLARE SUB Rel.LoadPalPP256 (File$)
DECLARE SUB InitImageData (FileName$, ImageArray%())
DECLARE SUB MakeImageIndex (ImageArray%(), IndexArray%())
'This the the No map example 32*32
'you can use 16*32, 32*16, 128*64, etc
'Faster than mapmode but only supports one tile
'useful for:
'1. Floors in fighting games
'2. eye candies
'3. endings and intros
'4. ????
'Controls...
'    Arrows = move
'    A/Z    = Scale z/height
'    S/X    = scale x
'    D/C    = scale y
'    F/V    = Horizon/Eyeview

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
CONST TSIZE = 64                            'tilesize try to change this...
CONST TSIZESQUARED = TSIZE * TSIZE
CONST MAPTILEXMAX = 128
CONST MAPMAXPIXELX = MAPTILEXMAX * TSIZE
CONST MAPTILEYMAX = 64
CONST MAPMAXPIXELY = MAPTILEYMAX * TSIZE


'$DYNAMIC

DIM SHARED Vpage%(0 TO 31999)           'our buffer
DIM SHARED Layer%

'$STATIC
DIM SHARED Lcos!(359)                   'fast Lookups
DIM SHARED Lsin!(359)
REDIM SHARED Texture%(1)                  'calc array size for
                                         'GET array
REDIM SHARED TextureIndex%(1)


Layer% = VARSEG(Vpage%(0))                          'set layer address
                                                    'for reference

DIM SHARED Mario AS KartType                        'needs a better name


Mario.x = MAPMAXPIXELX \ 2                  'center our camera
Mario.y = MAPMAXPIXELY \ 2
Mario.dx = 0
Mario.dy = 0
Mario.Angle = 0
Mario.accel = .05                        'acceleration
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


'CHANGE THIS TO WHERE YOU UNZIPPED THE ARCHIVE
Path$ = "C:\qbasic\Rellib\Examples\Mode7\"
'Path$ = ""
InitImageData Path$ + "cloud.Put", Texture%()
MakeImageIndex Texture%(), TextureIndex%()


RESTORE
Rel.LoadPalPP256 ""


x1 = 0              'window dimensions for Mode7
y1 = 100
x2 = 319
y2 = 199
size% = RelSize(x1, y1, x2, y2)
DIM Ceiling%(size%)

'mode 7 parameters
Angle = 0               'Look forward
Scalex = 200            '200 looks good
Scaley = 200
Scalez = 15             'height
Horz = 10               'eyeview
camx! = 0
camy! = 0
gi& = 16 * 256& \ ((y2 - y1) + 1)
Bright% = 3
RelKeyBoardON         'activate keyboard handler
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
    RelMode7 Layer%, x1, y1, x2, y2, Angle%, Scalex, Scaley, Scalez, Horz, px!, py!, Texture%(), TextureIndex%(1)
    gvs& = (-16 + Bright%) * 256
    FOR i = 0 TO 99
        yy = i + 100
        gv% = gvs& \ 256
        RelGammaBlock Layer%, 0, yy%, 319, yy%, gv%
        gvs& = gvs& + gi&
    NEXT i
    RelGET Layer%, x1, y1, x2, y2, VARSEG(Ceiling%(0)), VARPTR(Ceiling%(0))
    RelSpriteFlip Layer%, 0, 0, VARSEG(Ceiling%(0)), VARPTR(Ceiling%(0)), FlipV
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

FJPALDATA: 'Pp256 palette data(16 color gradient pal.
DATA 0,2752512,10752,2763264,42,2752554,5418,2763306
DATA 1381653,4134165,1392405,4144917,1381695,4134207,1392447,4144959
DATA 0,328965,526344,723723,921102,1118481,1315860,1579032
DATA 1842204,2105376,2368548,2631720,2960685,3289650,3684408,4144959
DATA 0,4,8,12,16,21,25,29
DATA 33,37,42,46,50,54,58,63
DATA 0,262144,524288,786432,1048576,1376256,1638400,1900544
DATA 2162688,2424832,2752512,3014656,3276800,3538944,3801088,4128768
DATA 0,1024,2048,3072,4096,5376,6400,7424
DATA 8448,9472,10752,11776,12800,13824,14848,16128
DATA 0,262148,524296,786444,1048592,1376277,1638425,1900573
DATA 2162721,2424869,2752554,3014702,3276850,3538998,3801146,4128831
DATA 0,263168,526336,789504,1052672,1381632,1644800,1907968
DATA 2171136,2434304,2763264,3026432,3289600,3552768,3815936,4144896
DATA 0,1028,2056,3084,4112,5397,6425,7453
DATA 8481,9509,10794,11822,12850,13878,14906,16191
DATA 0,516,1032,1548,2064,2581,3097,3613
DATA 4385,4901,5418,5934,6450,6966,7482,8255
DATA 0,131076,262152,393228,524304,655381,786457,917533
DATA 1114145,1245221,1376298,1507374,1638450,1769526,1900602,2097215
DATA 0,262656,525312,787968,1050624,1378816,1641472,1904128
DATA 2167040,2429696,2757888,3020544,3283200,3545856,3808512,4136960
DATA 0,131844,263688,395532,527376,659477,791321,923165
DATA 1120545,1252389,1384490,1516334,1648178,1780022,1911866,2109503
DATA 0,131588,263176,394764,526352,657941,789529,921117
DATA 1118497,1250085,1381674,1513262,1644850,1776438,1908026,2105407
DATA 0,515,1030,1545,2060,2575,3090,3605
DATA 4376,4891,5406,5921,6436,6951,7466,8238
DATA 63,2103,4143,6183,8223,10008,12048,14088
DATA 16128,13833,11538,9243,6948,4653,2358,63
DATA 32,1058,2084,3110,4136,5418,6444,7470
DATA 8496,9522,10804,11830,12856,13882,14908,16191

SUB InitImageData (FileName$, ImageArray())

    IF FileName$ <> "" THEN
        '***** Read image data from file *****

        'Establish size of integer array required.
        FileNo = FREEFILE
        OPEN FileName$ FOR BINARY AS #FileNo
        Ints = (LOF(FileNo) - 7) \ 2
        CLOSE #FileNo
        REDIM ImageArray(1 TO Ints)

        'Load image data directly into array memory.
        DEF SEG = VARSEG(ImageArray(1))
        BLOAD FileName$, 0
        DEF SEG
    ELSE
        '***** Read image data from DATA statements *****

        'Establish size of integer array required.
        READ IntCount
        REDIM ImageArray(1 TO IntCount)

        'READ image DATA into array.
        FOR n = 1 TO IntCount
            READ x
            ImageArray(n) = x
        NEXT n
    END IF

END SUB

SUB MakeImageIndex (ImageArray(), IndexArray())

    'The index will initially be built in a temporary array, allowing
    'for the maximum 1000 images per file.
    DIM Temp(1 TO 1000)
    Ptr& = 1: IndexNo = 1: LastInt = UBOUND(ImageArray)
    DO
        Temp(IndexNo) = Ptr&
        IndexNo = IndexNo + 1

        'Evaluate descriptor of currently referenced image to
        'calculate the beginning of the next image.
        x& = (ImageArray(Ptr&) \ 8) * (ImageArray(Ptr& + 1)) + 4
        IF x& MOD 2 THEN x& = x& + 1
        Ptr& = Ptr& + (x& \ 2)
    LOOP WHILE Ptr& < LastInt

    LastImage = IndexNo - 1

    'Copy the image index values into the actual index array.
    REDIM IndexArray(1 TO LastImage)
    FOR n = 1 TO LastImage
        IndexArray(n) = Temp(n)
    NEXT n

END SUB

SUB Rel.LoadPalPP256 (File$) STATIC

'Loads a pp256 palette
'Changes the VGA palette on the fly
'if File$="" the data statement is used

IF File$ = "" OR File$ = " " THEN
    FOR n = 0 TO 255
        READ c&
        B = c& \ 65536: c& = c& - B * 65536
        G = c& \ 256: c& = c& - G * 256
        R = c&
        OUT &H3C8, n
        OUT &H3C9, R
        OUT &H3C9, G
        OUT &H3C9, B
     NEXT
ELSE
    FR = FREEFILE
    IF INSTR(File$, ".") = 0 THEN File$ = LEFT$(File$, 8) + ".Pal"
    OPEN File$ FOR BINARY AS #FR
        FOR n = 0 TO 255
            GET #FR, , c&
            B = c& \ 65536: c& = c& - B * 65536
            G = c& \ 256: c& = c& - G * 256
            R = c&
            OUT &H3C8, n
            OUT &H3C9, R
            OUT &H3C9, G
            OUT &H3C9, B
         NEXT
    CLOSE #FR
END IF


END SUB

