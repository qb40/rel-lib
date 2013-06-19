'/RelSpriteFlip,RelSpriteFlipT,RelSpriteFlipG and RelSpriteFlipC
'/Examples. ;*)

DECLARE SUB AF.LoadPalPp256 (File$)
REM $INCLUDE: 'RelLib.BI'

DEFINT A-Z


CLS
SCREEN 13
DIM Vpage(31999) AS INTEGER

Layer = VARSEG(Vpage(0))
Size = 63
MemSize = ((Size + 1) * (Size + 1) + 4) \ 2
DIM Array(0 TO MemSize) AS INTEGER

SprSeg = VARSEG(Array(0))
SprOff = VARPTR(Array(0))

FOR I = 0 TO Size
  FOR J = 0 TO Size
    RelPset Layer, J, I, (I OR J) + 90
  NEXT
NEXT

RelGet Layer, 0, 0, Size, Size, SprSeg, SprOff

RESTORE FJPALDATA                       'Set up Pal
AF.LoadPalPp256 ""

xv = -1
yv = -1

X = 10
Y = 100


DO
    X = X + xv
    IF X < -(Size + 30) THEN
        xv = -xv
    ELSEIF X > 320 + 30 THEN
        xv = -xv
    END IF
    Y = Y + yv
    IF Y < -(Size + 30) THEN
        yv = -yv
    ELSEIF Y > 230 THEN
        yv = -yv
    END IF
    RelCls Layer, 0
    FOR I = 0 TO 100
        RelBox Layer, I, I, 319 - I, 199 - I, I + 100
    NEXT I
    RelSpriteFlip Layer, 135, 70, SprSeg, SprOff, FlipNone
    RelSpriteFlip Layer, X, Y, SprSeg, SprOff, FlipH
    RelSpriteFlip Layer, (320 - Size) - X, (200 - Size) - Y, SprSeg, SprOff, FlipV
    RelSpriteFlip Layer, (320 - Size) - X, Y, SprSeg, SprOff, FlipVH
    RelSpriteFlip Layer, X, (200 - Size) - Y, SprSeg, SprOff, FlipNone
    RelPrint Layer, 0, 0, "Mode:Normal/Flip 0,1,2,3", 240, FALSE
    RelWait
    RelPcopy VIDEO, Layer
LOOP UNTIL INKEY$ <> ""

DO
    X = X + xv
    IF X < -(Size + 30) THEN
        xv = -xv
    ELSEIF X > 320 + 30 THEN
        xv = -xv
    END IF
    Y = Y + yv
    IF Y < -(Size + 30) THEN
        yv = -yv
    ELSEIF Y > 230 THEN
        yv = -yv
    END IF
    RelCls Layer, 0
    FOR I = 0 TO 100
        RelBox Layer, I, I, 319 - I, 199 - I, I + 100
    NEXT I
    RelSpriteFlip Layer, 135, 70, SprSeg, SprOff, FlipNone
    RelSpriteFlipT Layer, X, Y, SprSeg, SprOff, FlipH
    RelSpriteFlipT Layer, (320 - Size) - X, (200 - Size) - Y, SprSeg, SprOff, FlipV
    RelSpriteFlipT Layer, (320 - Size) - X, Y, SprSeg, SprOff, FlipVH
    RelSpriteFlipT Layer, X, (200 - Size) - Y, SprSeg, SprOff, FlipNone
    RelPrint Layer, 0, 0, "Mode:Translucent/Flip 0,1,2,3", 240, FALSE
    RelWait
    RelPcopy VIDEO, Layer
LOOP UNTIL INKEY$ <> ""

DO
    X = X + xv
    IF X < -(Size + 30) THEN
        xv = -xv
    ELSEIF X > 320 + 30 THEN
        xv = -xv
    END IF
    Y = Y + yv
    IF Y < -(Size + 30) THEN
        yv = -yv
    ELSEIF Y > 230 THEN
        yv = -yv
    END IF
    RelCls Layer, 0
    FOR I = 0 TO 100
        RelBox Layer, I, I, 319 - I, 199 - I, I + 100
    NEXT I
    RelSpriteFlip Layer, 135, 70, SprSeg, SprOff, FlipNone
    RelSpriteFlipG Layer, X, Y, SprSeg, SprOff, FlipH, 6
    RelSpriteFlipG Layer, (320 - Size) - X, (200 - Size) - Y, SprSeg, SprOff, FlipV, 6
    RelSpriteFlipG Layer, (320 - Size) - X, Y, SprSeg, SprOff, FlipVH, 6
    RelSpriteFlipG Layer, X, (200 - Size) - Y, SprSeg, SprOff, FlipNone, 6
    RelPrint Layer, 0, 0, "Mode:Gamma +6/Flip 0,1,2,3", 240, FALSE
    RelWait
    RelPcopy VIDEO, Layer
LOOP UNTIL INKEY$ <> ""

DO
    X = X + xv
    IF X < -(Size + 30) THEN
        xv = -xv
    ELSEIF X > 320 + 30 THEN
        xv = -xv
    END IF
    Y = Y + yv
    IF Y < -(Size + 30) THEN
        yv = -yv
    ELSEIF Y > 230 THEN
        yv = -yv
    END IF
    RelCls Layer, 0
    FOR I = 0 TO 100
        RelBox Layer, I, I, 319 - I, 199 - I, I + 100
    NEXT I
    RelSpriteFlip Layer, 135, 70, SprSeg, SprOff, FlipNone
    RelSpriteFlipG Layer, X, Y, SprSeg, SprOff, FlipH, -6
    RelSpriteFlipG Layer, (320 - Size) - X, (200 - Size) - Y, SprSeg, SprOff, FlipV, -6
    RelSpriteFlipG Layer, (320 - Size) - X, Y, SprSeg, SprOff, FlipVH, -6
    RelSpriteFlipG Layer, X, (200 - Size) - Y, SprSeg, SprOff, FlipNone, -6
    RelPrint Layer, 0, 0, "Mode:Gamma -6/Flip 0,1,2,3", 240, FALSE
    RelWait
    RelPcopy VIDEO, Layer
LOOP UNTIL INKEY$ <> ""

clr = 1
DO
    Counter = (Counter + 1) AND 7       'rotate colors
    IF Counter = 1 THEN
        clr = (clr + 1) AND 255
    END IF
    X = X + xv
    IF X < -(Size + 30) THEN
        xv = -xv
    ELSEIF X > 320 + 30 THEN
        xv = -xv
    END IF
    Y = Y + yv
    IF Y < -(Size + 30) THEN
        yv = -yv
    ELSEIF Y > 230 THEN
        yv = -yv
    END IF
    RelCls Layer, 0
    FOR I = 0 TO 100
        RelBox Layer, I, I, 319 - I, 199 - I, I + 100
    NEXT I
    RelSpriteFlip Layer, 135, 70, SprSeg, SprOff, FlipNone
    RelSpriteFlipC Layer, X, Y, SprSeg, SprOff, FlipH, clr
    RelSpriteFlipC Layer, (320 - Size) - X, (200 - Size) - Y, SprSeg, SprOff, FlipV, clr
    RelSpriteFlipC Layer, (320 - Size) - X, Y, SprSeg, SprOff, FlipVH, clr
    RelSpriteFlipC Layer, X, (200 - Size) - Y, SprSeg, SprOff, FlipNone, clr
    RelPrint Layer, 0, 0, "Mode:Color/Flip 0,1,2,3", 240, FALSE
    RelWait
    RelPcopy VIDEO, Layer
LOOP UNTIL INKEY$ <> ""

CLS
SCREEN 0
WIDTH 80
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

SUB AF.LoadPalPp256 (File$) STATIC

'Loads a pp256 palette
'Changes the VGA palette on the fly
'if File$="" the data statement is used

IF File$ = "" OR File$ = " " THEN
    FOR n = 0 TO 255
        READ C&
        B = C& \ 65536: C& = C& - B * 65536
        G = C& \ 256: C& = C& - G * 256
        R = C&
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
            GET #FR, , C&
            B = C& \ 65536: C& = C& - B * 65536
            G = C& \ 256: C& = C& - G * 256
            R = C&
            OUT &H3C8, n
            OUT &H3C9, R
            OUT &H3C9, G
            OUT &H3C9, B
         NEXT
    CLOSE #FR
END IF

END SUB

