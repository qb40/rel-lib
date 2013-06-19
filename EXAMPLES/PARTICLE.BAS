DECLARE SUB Load.Pal ()
DECLARE SUB DoParts (V AS ANY, Particles() AS ANY)
DECLARE SUB ProcessPoint (P AS ANY)
REM $INCLUDE: 'RelLib.BI'
DEFINT A-Z
RANDOMIZE TIMER

TYPE ParticleType
        X       AS INTEGER
        Y       AS INTEGER
        XV      AS INTEGER
        YV      AS INTEGER
        RX      AS INTEGER
        RY      AS INTEGER
        Life    AS INTEGER
END TYPE


TYPE PointType
        Index           AS INTEGER
        X               AS INTEGER
        Y               AS INTEGER
        XV              AS INTEGER
        YV              AS INTEGER
        Speed           AS INTEGER
        TX              AS INTEGER
        TY              AS INTEGER
        Dot             AS INTEGER
        Angle           AS INTEGER
        AngleStep       AS INTEGER
        NewTarget       AS INTEGER
        Animate         AS INTEGER
        C               AS INTEGER
END TYPE


CONST PI = 3.141593
CONST MaxParts = 50             'maxparticles per point
CONST MaxVector = 13            'Change this to how many points you want


DIM SHARED CosLut(359), SinLut(359)
DIM SHARED Part(MaxParts, MaxVector) AS ParticleType
DIM SHARED Vector(MaxVector) AS PointType
REDIM SHARED Vpage(31999)
DIM SHARED Layer AS INTEGER
DIM SHARED RGBpal AS STRING * 768


'Create Table *256   FixPoint
FOR I = 0 TO 359
        CosLut(I) = COS(I * PI / 180) * 256
        SinLut(I) = SIN(I * PI / 180) * 256
NEXT I


Layer = VARSEG(Vpage(0))

CLS
SCREEN 13
RelFfix

'Init Vectors,etc
FOR I = 0 TO UBOUND(Vector)
        Vector(I).Index = I
        Vector(I).X = INT(RND * 320)
        Vector(I).Y = INT(RND * 200)
        Vector(I).Angle = 0
        Vector(I).AngleStep = 8
        Vector(I).Speed = 3
        Vector(I).C = (1 + INT(RND * 16)) * 16
        TempColor = Vector(I).C
        TempColor = TempColor AND 15
        Vector(I).C = Vector(I).C - TempColor  'Base Color of 16 Grad Pal
NEXT I

'Init Particles
FOR J = 0 TO UBOUND(Vector)
FOR I = 0 TO UBOUND(Part)
        Part(I, J).X = Vector(J).X
        Part(I, J).Y = Vector(J).Y
        Part(I, J).XV = (-1 + (RND * 2)) * 256
        Part(I, J).YV = (-1 + (RND * 2)) * 256
        Part(I, J).Life = INT(RND * 16)
        Part(I, J).RX = (-1 + INT(RND * 2)) * 256
        Part(I, J).RY = (-1 + INT(RND * 2)) * 256
NEXT I
NEXT J

Load.Pal

DO
        RelCLS Layer, 0
        FOR I = 0 TO UBOUND(Vector)
                ProcessPoint Vector(I)
        NEXT I
        FOR I = 0 TO UBOUND(Vector)
                DoParts Vector(I), Part()
                'Draw Vectors' points
                RelPset Layer, Vector(I).X, Vector(I).Y, 31     'center
                RelPset Layer, Vector(I).X, Vector(I).Y - 1, 25 'top
                RelPset Layer, Vector(I).X, Vector(I).Y + 1, 25 'Bottom
                RelPset Layer, Vector(I).X - 1, Vector(I).Y, 25 'Left
                RelPset Layer, Vector(I).X + 1, Vector(I).Y, 25 'Right
        NEXT I
        FPS = FPS + 1
        IF StartTime& + 1 < TIMER THEN
         FPS2 = FPS
         FPS = 0
         StartTime& = TIMER
        END IF

        RelPrint Layer, 0, 0, "FPS:" + STR$(FPS2), 25, FALSE
        RelWait
        RelPCopy VIDEO, Layer
LOOP UNTIL INKEY$ <> ""

CLS
SCREEN 0
WIDTH 80


END


PaletteData: ' palette data. FJ pal this is.... :*)
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

SUB DoParts (V AS PointType, Particles() AS ParticleType) STATIC
V.Animate = NOT V.Animate
        FOR I = 0 TO MaxParts
            IF V.Animate THEN
                IF Particles(I, V.Index).Life > 0 THEN
                        Particles(I, V.Index).Life = Particles(I, V.Index).Life - 1
                        Particles(I, V.Index).X = Particles(I, V.Index).X + Particles(I, V.Index).XV / 256
                        Particles(I, V.Index).Y = Particles(I, V.Index).Y + Particles(I, V.Index).YV / 256
                        RX = RND * Particles(I, V.Index).RX - RND * Particles(I, V.Index).RX
                        RY = RND * Particles(I, V.Index).RY - RND * Particles(I, V.Index).RY
                        Particles(I, V.Index).X = Particles(I, V.Index).X + (RX / 256)
                        Particles(I, V.Index).Y = Particles(I, V.Index).Y + (RY / 256)
                ELSE
                        Particles(I, V.Index).Life = 16
                        Particles(I, V.Index).X = V.X
                        Particles(I, V.Index).Y = V.Y
                        Particles(I, V.Index).XV = (-1 + (RND * 2)) * 256
                        Particles(I, V.Index).YV = (-1 + (RND * 2)) * 256
                        Particles(I, V.Index).RX = (-1 + INT(RND * 2)) * 256
                        Particles(I, V.Index).RY = (-1 + INT(RND * 2)) * 256
                END IF
          END IF
                'Draw Parts
                RelPset Layer, Particles(I, V.Index).X, Particles(I, V.Index).Y, V.C + Particles(I, V.Index).Life
        NEXT I
END SUB

SUB Load.Pal

RESTORE PaletteData
    FOR N = 0 TO 255
        READ C&
        B = C& \ 65536: C& = C& - B * 65536
        G = C& \ 256: C& = C& - G * 256
        R = C&
        OUT &H3C8, N
        OUT &H3C9, R
        OUT &H3C9, G
        OUT &H3C9, B
     NEXT N

END SUB

SUB ProcessPoint (P AS PointType) STATIC

        IF P.NewTarget THEN
                P.TX = INT(RND * 320)
                P.TY = INT(RND * 200)
                P.NewTarget = FALSE
        END IF

        'move the Points
        P.XV = (CosLut(P.Angle) / 256) * P.Speed
        P.YV = (SinLut(P.Angle) / 256) * P.Speed

        P.X = P.X + P.XV
        P.Y = P.Y + P.YV

        'Circle based Inside Function of Radius 15
        IF RelInsideC(P.X, P.Y, P.TX, P.TY, 15) THEN
                P.NewTarget = TRUE
        END IF

        'Check if Result>0 then Dec else Inc(Cosine of Angle) :*)
        'Not Normalized so it does away with 2 divsions and 2 muls.
        'the actual angle is not important

        P.Dot = ((P.YV * (P.TX - P.X)) - (P.XV * (P.TY - P.Y)))
        IF P.Dot > 0 THEN
                P.Angle = (P.Angle - P.AngleStep)
                IF P.Angle < 0 THEN P.Angle = P.Angle + 360
        ELSE
                P.Angle = (P.Angle + P.AngleStep) MOD 360
        END IF

END SUB

