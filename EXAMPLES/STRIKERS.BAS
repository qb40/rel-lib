DECLARE FUNCTION Inside% (X%, Y%, X1%, Y1%, X2%, Y2%)
DECLARE SUB DrawDyna (X%, Y%, I%)
DECLARE SUB CreateStars ()
DECLARE SUB MoveStars ()
DECLARE SUB CreateOptionTable ()
DECLARE SUB PutGradius (X%, Y%)
DECLARE SUB PutDrone (X%, Y%)
DECLARE SUB DrawExp (X%, Y%)
DECLARE SUB DrawOptLaser (X%, Y%)
DECLARE SUB InitImageData (FileName$, ImageArray%())
DECLARE SUB MakeImageIndex (ImageArray%(), IndexArray%())
DECLARE SUB CreateTable ()

REM $INCLUDE: 'RelLib.BI'


REM $DYNAMIC
DEFINT A-Z

ON ERROR GOTO ERRHAND

TYPE ShotType
        X AS INTEGER
        Y AS INTEGER
        Firing AS INTEGER
        Idx AS INTEGER
END TYPE

TYPE Startype
        X AS INTEGER
        Y AS INTEGER
        Speed AS INTEGER
        Clr AS INTEGER
END TYPE


CONST maxstars = 50
                  



CONST MaxShot = 99
CONST ShotSpd = 15
                   
CONST RockX = 200
CONST RockY = 40
CONST RockWidth = 45
CONST RockHeight = 75


DIM Shot(2, MaxShot) AS ShotType
DIM SHARED Stars(maxstars) AS Startype
DIM SHARED Vpage(31999) AS INTEGER

DIM SHARED Sine(640), Cosine(640)
DIM SHARED OptionTable(3, 360) AS INTEGER

CLS
RelInitVGA13

CreateTable
CreateStars
CreateOptionTable

ShipX = 20
ShipY = 100



'Option Laser
REDIM SHARED Laser(1 TO 1)
REDIM SHARED LaserIndex(1 TO 1)
FileName$ = ""
InitImageData FileName$, Laser()
MakeImageIndex Laser(), LaserIndex()

'Dyna

REDIM SHARED Dyna(1 TO 1)
REDIM SHARED DynaIndex(1 TO 1)
FileName$ = ""
InitImageData FileName$, Dyna()
MakeImageIndex Dyna(), DynaIndex()

'Lashit

REDIM SHARED LasHit(1 TO 1)
REDIM SHARED LasHitIndex(1 TO 1)
FileName$ = ""
InitImageData FileName$, LasHit()
MakeImageIndex LasHit(), LasHitIndex()

'DroneSprite

REDIM SHARED Drone(1 TO 1)
REDIM SHARED DroneIndex(1 TO 1)
FileName$ = ""
InitImageData FileName$, Drone()
MakeImageIndex Drone(), DroneIndex()

'GradiusSprite

REDIM SHARED Gradius(1 TO 1)
REDIM SHARED GradiusIndex(1 TO 1)
FileName$ = ""
InitImageData FileName$, Gradius()
MakeImageIndex Gradius(), GradiusIndex()

Fire = FALSE

Finished = FALSE
A = 0
SFlags = 0

RelKeyBoardON

        DO
                SFlags = (SFlags MOD 3) + 1
                'WAIT &H3DA, 8
                'RelWait
                PP = RelPoint(VARSEG(Vpage(0)), ShipX - 5, ShipY - 15)
                'RelPset VARSEG(Vpage(0)), ShipX - 5, ShipY - 15, 15
                RelPrint VARSEG(Vpage(0)), 100, 0, STR$(PP), 25, FALSE

                RelPCopy &HA000, VARSEG(Vpage(0))

                RelCLS VARSEG(Vpage(0)), 0
                MoveStars
                IF RelKey(KEYLEFT) THEN ShipX = ShipX - 2
                IF RelKey(KEYRIGHT) THEN ShipX = ShipX + 2
                IF RelKey(KEYDOWN) THEN ShipY = ShipY + 2
                IF RelKey(KEYUP) THEN ShipY = ShipY - 2
                IF RelKey(KEYSPACE) AND SFlags = 1 THEN
                        Fire = TRUE
                END IF
                IF RelKey(KEYENTER) THEN
                        Finished = TRUE
                END IF
                IF RelKey(KEYESC) THEN Finished = TRUE

                RelBoxF VARSEG(Vpage(0)), RockX, RockY, RockX + RockWidth, RockY + RockHeight, 86

                A = (A MOD 360) + 5
                'A = 90
                
                'Option1
                PutDrone ShipX + OptionTable(0, A), ShipY + OptionTable(1, A)
                'Option2
                PutDrone ShipX + OptionTable(2, A), ShipY + OptionTable(3, A)
                'Ship
                RelSpriteColorX VARSEG(Vpage(0)), 100, 100, VARSEG(Gradius(1)), VARPTR(Gradius(GradiusIndex(1))), 49, 1

                IF RelCollide(VARSEG(Vpage(0)), ShipX - 5, ShipY - 10, VARSEG(Gradius(1)), VARPTR(Gradius(GradiusIndex(1)))) > 20 THEN
                        IF RelCollideSprB%(ShipX - 5, ShipY - 10, VARSEG(Gradius(1)), VARPTR(Gradius(GradiusIndex(1))), 100, 100, VARSEG(Gradius(1)), VARPTR(Gradius(GradiusIndex(1)))) THEN
                                SOUND 300, .1
                                RelPrint VARSEG(Vpage(0)), 0, 0, "Hit", 24, TRUE
                        END IF
                END IF


                PutGradius ShipX, ShipY

                GOSUB DoShot

        LOOP UNTIL Finished

RelKeyBoardOFF

RelInitText

CLS

COLOR 15

PRINT "Back to screen 0"



END

DoShot:

   IF Fire THEN

        FOR I = 0 TO MaxShot
                'Option 1
                IF NOT Shot(0, I).Firing THEN
                        Shot(0, I).Firing = TRUE
                        Shot(0, I).X = (ShipX + 7) + OptionTable(0, A)
                        Shot(0, I).Y = ShipY + OptionTable(1, A)
                        EXIT FOR
                END IF
        NEXT I
        FOR I = 0 TO MaxShot
                'option 2
                IF NOT Shot(1, I).Firing THEN
                        Shot(1, I).Firing = TRUE
                        Shot(1, I).X = (ShipX + 7) + OptionTable(2, A)
                        Shot(1, I).Y = ShipY + OptionTable(3, A)
                        EXIT FOR
                END IF
        NEXT I
        FOR I = 0 TO MaxShot
                'Ship
                IF NOT Shot(2, I).Firing THEN
                        Shot(2, I).Firing = TRUE
                        Shot(2, I).X = ShipX + 7
                        Shot(2, I).Y = ShipY
                        DynaI = (DynaI MOD 2) + 1
                        Shot(2, I).Idx = DynaI
                        EXIT FOR
                END IF
        NEXT I
        Fire = FALSE
   END IF

        FOR J = 0 TO MaxShot
        'Option 1
        IF Shot(0, J).Firing THEN
                IF Shot(0, J).X > 320 THEN
                        DrawExp Shot(0, J).X, Shot(0, J).Y
                        Shot(0, J).Firing = FALSE
                END IF
                IF RelCollide(VARSEG(Vpage(0)), Shot(0, J).X, Shot(0, J).Y - 2, VARSEG(Laser(1)), VARPTR(Laser(LaserIndex(1)))) > 50 THEN
                        DrawExp Shot(0, J).X, Shot(0, J).Y
                        Shot(0, J).Firing = FALSE
                        SOUND 500, .1
                END IF

                DrawOptLaser Shot(0, J).X, Shot(0, J).Y
                Shot(0, J).X = Shot(0, J).X + ShotSpd
        END IF
        'Option2
        IF Shot(1, J).Firing THEN
                IF Shot(1, J).X > 320 THEN
                        DrawExp Shot(1, J).X, Shot(1, J).Y
                        Shot(1, J).Firing = FALSE
                END IF
                IF RelCollide(VARSEG(Vpage(0)), Shot(1, J).X, Shot(1, J).Y - 2, VARSEG(Laser(1)), VARPTR(Laser(LaserIndex(1)))) > 50 THEN
                        DrawExp Shot(1, J).X, Shot(1, J).Y
                        Shot(1, J).Firing = FALSE
                        SOUND 500, .1
                END IF

                DrawOptLaser Shot(1, J).X, Shot(1, J).Y
                Shot(1, J).X = Shot(1, J).X + ShotSpd

        END IF
        'Ship
        IF Shot(2, J).Firing THEN

                IF Shot(2, J).X > 320 THEN
                        Shot(2, J).Firing = FALSE
                END IF
                IF RelCollide(VARSEG(Vpage(0)), Shot(2, J).X + 20, Shot(2, J).Y - 7, VARSEG(Dyna(1)), VARPTR(Dyna(DynaIndex(1)))) > 50 THEN
                        DrawExp Shot(2, J).X + 23, Shot(2, J).Y + 1
                        Shot(2, J).Firing = FALSE
                        SOUND 400, .1
                END IF

                IF RelCollide(VARSEG(Vpage(0)), Shot(2, J).X + 20, Shot(2, J).Y - 7, VARSEG(Dyna(1)), VARPTR(Dyna(DynaIndex(1)))) > 20 THEN
                        IF RelCollideSprB%(Shot(2, J).X + 20, Shot(2, J).Y + 1, VARSEG(Dyna(1)), VARPTR(Dyna(DynaIndex(1))), 100, 100, VARSEG(Gradius(1)), VARPTR(Gradius(GradiusIndex(1)))) THEN
                                DrawExp Shot(2, J).X + 23, Shot(2, J).Y + 1
                                Shot(2, J).Firing = FALSE
                                SOUND 300, .1
                        END IF
                END IF


                        DrawDyna Shot(2, J).X, Shot(2, J).Y, Shot(2, J).Idx
                        Shot(2, J).X = Shot(2, J).X + ShotSpd

        END IF

        NEXT J


RETURN

LaserData: 'GRADLAS.PUT image data.
DATA 80
DATA 120,5,9252,0,9728,38,0,0,0,0,9290,9764,2827,18982,19018,39,0,19018,11275,11308
DATA 11308,2827,11308,11308,44,9290,9764,2827,18982,19018,39,0,9252,0,9728,38,0,0,0,0
DATA 120,5,0,-1,255,-256,-1,-1,-1,-1,0,0,0,0,0,-256,-1,0,0,0
DATA 0,0,0,0,-256,0,0,0,0,0,-256,-1,0,-1,255,-256,-1,-1,-1,255

DynaData: ' image data.
DATA 404
DATA 160,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,4608,5394,5397,5397,4629,18,0,0,0,4608,5397,6168,6680,6170,6168,5397
DATA 18,0,0,5394,6165,6682,7196,7196,6682,5400,4629,0,4608,5394,6680,7194,7966,7711,6684,6170
DATA 4629,18,4608,5394,6680,7194,7966,7711,6684,6170,4629,18,0,5394,6165,6682,7196,7196,6682,5400
DATA 4629,0,0,4608,5394,6168,6168,6168,6168,4629,18,0,0,0,4608,4626,5397,5397,4626,18
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,160,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,4352,-8687,-8482,-8482,4574,17,0,0,0,4352,-8482,-26729,-20585,-26705
DATA -26729,-8482,17,0,0,-8687,-26658,-20561,-21332,-21332,-20561,-8553,4574,0,4352,-8687,-20585,-21329,20280,14415
DATA -20564,-26705,4574,17,4352,-8687,-20585,-21329,20280,14415,-20564,-26705,4574,17,0,-8687,-26658,-20561,-21332,-21332
DATA -20561,-8553,4574,0,0,4352,-8687,-26729,-26729,-26729,-26729,4574,17,0,0,0,4352,4369,-8482,-8482
DATA 4369,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0


LasHitData: ' image data.
DATA 94
DATA 72,10,3840,0,15,3840,0,3840,3840,3840,0,0,3840,3855,0,3840,3840,3855,3855,3840
DATA 3840,3855,3855,3855,0,3855,3855,3855,15,15,3855,3855,15,15,0,3855,15,0,0,15
DATA 15,15,0,15,3840,0,15,80,9,0,3840,0,15,0,15,0,3855,0,3840,3840
DATA 3840,3855,15,15,0,3855,3855,3855,0,3855,3855,3855,3855,3855,0,3855,3855,3855,0,3840
DATA 3840,3855,15,15,15,0,3855,0,3840,0,3840,0,15,0

OptionData: 'OPTION.PUT image data.
DATA 608
DATA 160,15,0,6144,6168,6168,6168,6168,0,0,0,0,0,3864,3855,3855,3855,7951,6168,0
DATA 0,0,0,3864,6168,6168,6168,6168,7967,24,0,0,6144,6159,0,0,0,0,6168,6175
DATA 0,0,6144,6159,0,0,0,0,0,7960,6168,0,3864,2584,10,8192,8219,0,2570,6144
DATA 7967,24,3864,10535,10025,6944,6943,10016,10537,39,6168,31,9252,2852,2852,6944,6943,9248,2852,9252
DATA 9252,9252,3864,10535,10025,8224,8219,10016,10537,39,6168,31,3864,2584,10,8192,8224,0,2570,6144
DATA 7967,24,6144,6159,0,0,0,0,0,7960,6168,0,6144,6159,0,0,0,0,6168,6175
DATA 0,0,0,3864,6168,6168,6168,6168,7960,24,0,0,0,3864,3855,3855,3855,3855,6175,0
DATA 0,0,0,6144,6168,6168,6168,6168,24,0,0,0,160,15,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,6144,6168,6168,6168,6168,24
DATA 0,0,0,0,5888,7967,7967,7967,7967,6175,6168,0,0,0,6144,7967,0,0,0,7936
DATA 7967,6168,0,0,5911,2584,10,8192,8219,0,2570,7967,24,0,6167,10535,10025,6944,6943,10016
DATA 10537,7975,6168,24,9252,2852,2852,6944,6943,9248,2852,9252,9252,9252,7936,10535,10025,8224,8219,10016
DATA 10537,7975,7967,31,0,2591,10,8192,8224,6168,2570,7967,0,0,0,7936,6168,6168,7960,7967
DATA 7967,0,0,0,0,0,7967,7967,31,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,160,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2560,10,8192
DATA 8219,0,2570,0,0,0,0,10535,10025,6944,6943,10016,10537,39,0,0,5911,5911,5911,5911
DATA 5911,5911,5911,5911,5911,9239,0,10535,10025,8224,8219,10016,10537,39,0,0,0,2560,10,8192
DATA 8224,0,2570,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,160,15,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,7967,7967,31,0,0,0,0,0,0,7936
DATA 6168,6168,7960,7967,7967,0,0,0,0,2591,10,8192,8219,6168,2570,7967,0,0,7936,10535
DATA 10025,6944,6943,10016,10537,7975,7967,31,9252,2852,2852,6944,6943,9248,2852,9252,9252,9252,6167,10535
DATA 10025,8224,8219,10016,10537,7975,6168,24,5911,2584,10,8192,8224,0,2570,7967,24,0,6144,7967
DATA 0,0,0,7936,7967,6168,0,0,5888,7967,7967,7967,7967,6175,6168,0,0,0,6144,6168
DATA 6168,6168,6168,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0

GradiusData: 'VICVIPER.PUT image data.
DATA 704
DATA 280,20,0,7936,7967,7967,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 7936,7967,7967,7967,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16159,7999
DATA 0,7936,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16159,7999,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,7936,16191,7999,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,16159,16191,7999,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,16159,7967,7967,7967,31,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,2335,2313,2313,2313,7967,3840,3855,15,0,0,0,0,0
DATA 0,0,0,9252,2335,2313,2313,2313,2313,2569,2570,2570,3855,3855,0,0,0,0,0,0
DATA 9252,9252,2313,2313,2313,2313,2313,2569,2570,2570,2570,3850,3855,0,0,0,0,9252,9252,9252
DATA 7967,7967,7967,7967,2335,2569,2570,2570,2570,1034,3844,15,0,0,0,9252,9252,16191,16191,16191
DATA 16191,2335,2313,2569,2570,2570,1034,1028,1028,3855,0,0,0,9252,7936,16191,16191,16191,7967,7967
DATA 7967,1028,1028,1028,1028,1028,1028,3844,0,0,0,0,7967,16191,16191,7999,7936,16191,7967,3855
DATA 3855,3855,1028,1028,1028,3844,0,0,0,0,16159,16191,16191,31,16159,16191,31,0,0,3840
DATA 3855,3855,7951,3871,0,0,0,0,16159,16191,7999,0,16159,16191,31,0,0,0,0,0
DATA 0,0,0,0,0,0,16159,16191,7999,0,10023,10023,39,0,0,0,0,0,0,0
DATA 0,0,0,0,16159,16191,7999,0,10023,10023,39,0,0,0,0,0,0,0,0,0
DATA 0,0,10023,10023,10023,39,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 10023,10023,10023,10023,0,0,0,0,0,0,0,0,280,20,0,7936,7967,7967,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,7936,7967,7967,7967,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,16159,7999,0,7936,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,16159,7999,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,7936,16191,7999,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,16159,16191,7999,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DATA 0,16159,7967,7967,7967,31,0,0,0,0,0,0,0,0,0,0,0,0,0,2335
DATA 2313,2313,2313,7967,3840,3855,15,0,0,0,0,0,0,0,0,9252,2335,2313,2313,2313
DATA 2313,2569,2570,2570,3855,3855,0,0,0,0,0,0,9252,9252,2313,2313,2313,2313,2313,2569
DATA 2570,2570,2570,3850,3855,0,0,0,0,9252,9252,9252,7967,7967,7967,7967,2335,2569,2570,2570
DATA 2570,1034,3844,15,0,0,0,9252,9252,16191,16191,16191,16191,2335,2313,2569,2570,2570,1034,1028
DATA 1028,3855,0,0,0,9252,7936,16191,16191,16191,7967,7967,7967,1028,1028,1028,1028,1028,1028,3844
DATA 0,0,0,0,7967,16191,16191,7999,7936,16191,7967,3855,3855,3855,1028,1028,1028,3844,0,0
DATA 0,0,16159,16191,16191,31,16159,16191,31,0,0,3840,3855,3855,7951,3871,0,0,0,0
DATA 16159,16191,7999,0,16159,16191,31,0,0,0,0,0,0,0,0,0,0,0,16159,16191
DATA 7999,0,10023,10023,39,0,0,0,0,0,0,0,0,0,0,0,16159,16191,7999,0
DATA 10023,10023,39,0,0,0,0,0,0,0,0,0,0,0,10023,10023,10023,39,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0,0,10023,10023,10023,10023,0,0,0,0
DATA 0,0,0,0

ERRHAND:

CLS
SCREEN 0
PRINT ERR
END

REM $STATIC
SUB CreateOptionTable STATIC
FOR A = 0 TO 360
                SX = (Cosine(A) / 1024) * 60
                SY = (Sine(A) / 1024) * 35
                SX2 = (-Cosine(A) / 1024) * 60
                SY2 = (-Sine(A) / 1024) * 35
                OptionTable(0, A) = SX
                OptionTable(1, A) = SY
                OptionTable(2, A) = SX2
                OptionTable(3, A) = SY2
NEXT A

END SUB

SUB CreateStars STATIC
        FOR I = 0 TO maxstars
                Stars(I).X = INT(RND * 320)
                Stars(I).Y = INT(RND * 200)
                Stars(I).Speed = 1 + INT(RND * 5)
                IF Stars(I).Speed < 4 THEN
                        Stars(I).Clr = 7
                ELSE
                        Stars(I).Clr = 15
                END IF
        NEXT I
END SUB

SUB CreateTable STATIC
Pi! = 3.141593
FOR I = 0 TO 640                                'create sine and cosine
   Sine(I) = SIN(I * (Pi! / 180)) * 1024                'look up tables to speed up
   Cosine(I) = COS(I * (Pi! / 180)) * 1024                'the math
NEXT


END SUB

SUB DrawDyna (X, Y, I) STATIC
        RelSprite VARSEG(Vpage(0)), X + 20, Y - 7, VARSEG(Dyna(1)), VARPTR(Dyna(DynaIndex(I)))
END SUB

SUB DrawExp (X, Y) STATIC
I = (I MOD 2) + 1
        RelSprite VARSEG(Vpage(0)), X + 15, Y - 3, VARSEG(LasHit(1)), VARPTR(LasHit(LasHitIndex(I)))
END SUB

SUB DrawOptLaser (X, Y) STATIC
        RelSprite VARSEG(Vpage(0)), X, Y - 2, VARSEG(Laser(1)), VARPTR(Laser(LaserIndex(1)))
END SUB

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
        FOR N = 1 TO IntCount
            READ X
            ImageArray(N) = X
        NEXT N
    END IF



END SUB

FUNCTION Inside (X, Y, X1, Y1, X2, Y2) STATIC
Inside = FALSE


IF X >= X1 AND X <= X2 THEN
        IF Y >= Y1 AND Y <= Y2 THEN
                Inside = TRUE
        END IF
END IF

IF Y >= Y1 AND Y < Y2 THEN
        IF X >= X1 AND X <= X2 THEN
                Inside = TRUE
        END IF
END IF


END FUNCTION

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
        X& = (ImageArray(Ptr&) \ 8) * (ImageArray(Ptr& + 1)) + 4
        IF X& MOD 2 THEN X& = X& + 1
        Ptr& = Ptr& + (X& \ 2)
    LOOP WHILE Ptr& < LastInt

    LastImage = IndexNo - 1

    'Copy the image index values into the actual index array.
    REDIM IndexArray(1 TO LastImage)
    FOR N = 1 TO LastImage
        IndexArray(N) = Temp(N)
    NEXT N


END SUB

SUB MoveStars STATIC
        FOR I = 0 TO maxstars
                Stars(I).X = Stars(I).X - Stars(I).Speed
                IF Stars(I).X < 0 THEN Stars(I).X = 320
                RelPset VARSEG(Vpage(0)), Stars(I).X, Stars(I).Y, Stars(I).Clr
        NEXT I
END SUB

SUB PutDrone (X, Y) STATIC
Flags = (Flags MOD 18) + 1
IF Flags = 1 THEN I = (I MOD UBOUND(DroneIndex)) + 1
       RelSprite VARSEG(Vpage(0)), X, Y - 7, VARSEG(Drone(1)), VARPTR(Drone(DroneIndex(I)))
END SUB

SUB PutGradius (X, Y) STATIC
        RelSprite VARSEG(Vpage(0)), X - 5, Y - 10, VARSEG(Gradius(1)), VARPTR(Gradius(GradiusIndex(1)))
END SUB

