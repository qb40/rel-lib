DECLARE SUB UpdateLevelCamera (Level AS ANY, Direction%)
DECLARE SUB UpdatePlayer (Player AS ANY, Direction%)
DECLARE FUNCTION ValidDirection% (PlayerX%, PlayerY%, Direction%)
DECLARE SUB DrawScreen ()
DECLARE SUB DrawAnya (PlayerX%, PlayerY%, Direction%)
DECLARE SUB LoadNpc ()
DECLARE SUB LoadTiles ()
DECLARE SUB MakeImageIndex (ImageArray%(), IndexArray%())
DECLARE SUB InitImageData (FileName$, ImageArray%())
REM $INCLUDE: 'RelLib.BI'

'/==========================================================================
'PIXEL BY PIXEL SCROLLING USING TILES
'FOR RPGS AND SHOOTERS ALIKE
'Using CamX and CamY
'LIB is RelLib
'/==========================================================================
DEFINT A-Z

TYPE PlayerType
        X         AS INTEGER       'Global Pixel*Pixel Position
        Y         AS INTEGER       'of Player
        Speed     AS INTEGER       'Duh?!
        Direction AS INTEGER       'Where player faces
        MoveFlag  AS INTEGER       'If the player has moved
        AnimFrame AS INTEGER       'Offset of PutArray to display
        TileX  AS INTEGER          'Global TILE(not Pixel position
        TileY  AS INTEGER          'of Player for Colission Detection
END TYPE

TYPE LevelType
        Xmax    AS INTEGER          'Maximum Number of Tiles a Map has
        Ymax    AS INTEGER
        TileX   AS INTEGER          'Tile postion of Camera
        TileY   AS INTEGER
        CamX    AS INTEGER          'Pixel*Pixel Camera Position
        CamY    AS INTEGER
        Xpos    AS INTEGER          'Pixel position Inside the Tile
        Ypos    AS INTEGER          '0 to TileH/W
END TYPE



CONST ScrnXmax = 320, ScrnYmax = 200
CONST ScrnXmid = 160, ScrnYmid = 100
CONST ScrnXmin = 0, ScrnYmin = 0

CONST TileW = 20, TileH = 20  'Dimensions of OurTile
CONST ScrnTileXmax = ScrnXmax \ TileW
CONST ScrnTileYmax = ScrnYmax \ TileH

CONST MapXmax = 69, MapYmax = 29

CONST DN = 0, DR = 1, DU = 2, DL = 3, DD = 4

CONST CatFrame1 = 77, CatFrame2 = 76

'Dynamic array for Tiles 20*20
REDIM SHARED Tile(1 TO 1)
REDIM SHARED TileIndex(1 TO 1)
REDIM SHARED Anya(1 TO 1)
REDIM SHARED AnyaIndex(1 TO 1)
REDIM SHARED Font(1 TO 1)
REDIM SHARED FontIndex(1 TO 1)

REDIM SHARED Vpage(31999) AS INTEGER

DIM SHARED Map(69, 29)



DIM SHARED Lilytte AS PlayerType
DIM SHARED Level AS LevelType
DIM SHARED VsyncON
DIM SHARED RGBpal AS STRING * 768    'our 768 pal string

DIM SHARED Path$
Path$ = ""
Path$ = "C:\qbasic\RelLib\Examples\RPG\"


'Initialize

'==Lilytte
Lilytte.X = 20
Lilytte.Y = 20
Lilytte.Speed = 1
Lilytte.Direction = DR
Lilytte.MoveFlag = FALSE
Lilytte.AnimFrame = 13
Lilytte.TileX = Lilytte.X \ TileW
Lilytte.TileY = Lilytte.Y \ TileH

'===Level
Level.Xmax = 69
Level.Ymax = 29
Level.TileX = 0
Level.TileY = 0
Level.CamX = 0
Level.CamY = 0
Level.Xpos = 0
Level.Ypos = 0


'Load tiles into put image array


CLS
RelInitVga13
LoadTiles
LoadNpc

RESTORE Mapdata
FOR Y = 0 TO 29
        READ A$
        FOR X = 0 TO 69
                M = ASC(MID$(A$, X + 1, 1))
                Map(X, Y) = M - 48
        NEXT X
NEXT Y

RelKeyBoardON
VsyncON = FALSE
VsyncON = TRUE
RelFade 0, 0, 0, 0
DrawScreen
DrawAnya Lilytte.X - Level.CamX, Lilytte.Y - Level.CamY, Lilytte.Direction
RelPcopy VIDEO, VARSEG(Vpage(0))
RelLoadPal Path$ + "RelPal.Pal", RGBpal, FALSE
RelFadeToPal RGBpal, 63

Finished = FALSE
StartFade = FALSE

DO



        DrawScreen
        DrawAnya Lilytte.X - Level.CamX, Lilytte.Y - Level.CamY, Lilytte.Direction
        IF VsyncON THEN RelWait
        RelPcopy VIDEO, VARSEG(Vpage(0))

        IF RelKey(KEYENTER) THEN
                VsyncON = NOT VsyncON
        END IF

        IF RelKey(KEYUP) THEN
                Direction = DU
                UpdatePlayer Lilytte, Direction
                UpdateLevelCamera Level, Direction
        END IF
        IF RelKey(KEYDOWN) THEN
                Direction = DD
                UpdatePlayer Lilytte, Direction
                UpdateLevelCamera Level, Direction

        END IF
        IF RelKey(KEYRIGHT) THEN
                Direction = DR
                UpdatePlayer Lilytte, Direction
                UpdateLevelCamera Level, Direction

        END IF
        IF RelKey(KEYLEFT) THEN
                Direction = DL
                UpdatePlayer Lilytte, Direction
                UpdateLevelCamera Level, Direction

        END IF

        IF RelKey(KEYESC) THEN
                StartFade = TRUE
        END IF
       
        IF StartFade THEN
                Counter = Counter MOD 6 + 1
                IF Counter = 5 THEN
                        RelFadeStep 0, 255, 0, 0, 0
                        FadeCounter = FadeCounter + 1
                        IF FadeCounter > 63 THEN Finished = TRUE
                END IF
        END IF


        

LOOP UNTIL Finished

RelKeyBoardOFF

RelInitText
CLS

END

Mapdata:   '70 by 30
REM           1         2         3         4         5         6         7
REM  1234567890123456789012345678901234567890123456789012345678901234567890

DATA }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
DATA }111111111111111111111111111111111111111111111111111111111111YTRREWA}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }111111111111111111111111a111a11111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }111111a1111111111111111111111111111111111111h1111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111n11111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111n1111o111111111111111}}
DATA }1111111111111111111111111111111111111111111111111i11111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }111111111111111111111111111111111111111111111111111o111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111g11111111111111111111}}
DATA }1111111111111111111111111111111111111111111111111111111111111111111}}
DATA }1111111111111111111111111111111111111111111111d11111111111111111111}}
DATA }111111111111111111111111111111111111111w111111111111111111111111111}}
DATA }11111111111111111111111111111111111111111111111f1111111111111111111}}
DATA }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
DATA }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

SUB DrawAnya (PlayerX, PlayerY, Direction) STATIC

Counter = Counter MOD 30 + 1
IF Counter = 1 THEN
        FrameFlag = NOT FrameFlag
        Gamma = Gamma + 1
        IF Gamma > 16 THEN Gamma = -16
END IF


IF Direction <> OldDir THEN II = 1 ELSE II = (II MOD 5) + 1

IF II = 1 THEN
IF Lilytte.MoveFlag THEN
        I = (I MOD 3) + 1
        SELECT CASE Direction
                CASE DR
                        Lilytte.AnimFrame = I + 12
                CASE DU
                        Lilytte.AnimFrame = I + 4
                CASE DL
                        Lilytte.AnimFrame = I + 8
                CASE DD
                        Lilytte.AnimFrame = I
                CASE ELSE
        END SELECT

        Lilytte.MoveFlag = FALSE

END IF
END IF

IF Lilytte.AnimFrame <> 0 THEN
        RelSprite VARSEG(Vpage(0)), PlayerX, PlayerY, VARSEG(Anya(1)), VARPTR(Anya(AnyaIndex(Lilytte.AnimFrame)))
        YY = PlayerY
        XX = PlayerX
        RelFont256 VARSEG(Vpage(0)), XX - 7, YY - 10, "normal", FALSE, Font(), FontIndex()

        RelSpriteTrans VARSEG(Vpage(0)), PlayerX - 40, PlayerY, VARSEG(Anya(1)), VARPTR(Anya(AnyaIndex(Lilytte.AnimFrame)))

        YY = PlayerY
        XX = PlayerX - 40
        RelFont256 VARSEG(Vpage(0)), XX - 7, YY - 10, "trans", FALSE, Font(), FontIndex()

        RelSpriteGamma VARSEG(Vpage(0)), PlayerX, PlayerY + 35, VARSEG(Anya(1)), VARPTR(Anya(AnyaIndex(Lilytte.AnimFrame))), -6
        YY = PlayerY + 35
        XX = PlayerX
        RelFont256 VARSEG(Vpage(0)), XX - 12, YY - 10, "gamma(-6)", FALSE, Font(), FontIndex()

        RelSpriteGamma VARSEG(Vpage(0)), PlayerX, PlayerY - 35, VARSEG(Anya(1)), VARPTR(Anya(AnyaIndex(Lilytte.AnimFrame))), 6
        YY = PlayerY - 35
        XX = PlayerX
        RelFont256 VARSEG(Vpage(0)), XX - 12, YY - 10, "gamma(+6)", FALSE, Font(), FontIndex()

        RelSpriteColor VARSEG(Vpage(0)), PlayerX + 40, PlayerY, VARSEG(Anya(1)), VARPTR(Anya(AnyaIndex(Lilytte.AnimFrame))), 47
        YY = PlayerY
        XX = PlayerX + 40
        RelFont256 VARSEG(Vpage(0)), XX - 4, YY - 10, "color", FALSE, Font(), FontIndex()
ELSE
END IF
OldDir = Direction

'Draw Trans Box
RelBoxTransF VARSEG(Vpage(0)), 140, 0, 319, 60, 35
FOR BI = 0 TO 5
        RelBoxTrans VARSEG(Vpage(0)), 140 + BI, BI, 320 - BI, 60 - BI, 63 - BI
NEXT BI

'Do some greets
RelFont256 VARSEG(Vpage(0)), 151, 10, "Fonts by Adigun Polack", FALSE, Font(), FontIndex()
RelFont256 VARSEG(Vpage(0)), 151, 20, "Tiles by DarkDread", FALSE, Font(), FontIndex()
RelFont256 VARSEG(Vpage(0)), 151, 30, "Greets to Eero Pitkanen", FALSE, Font(), FontIndex()
RelFont256 VARSEG(Vpage(0)), 151, 40, "CGI Joe & Bobby Leigh", FALSE, Font(), FontIndex()
RelFontTrans256 VARSEG(Vpage(0)), 0, 0, "RelLib Beta Ver xxx", FALSE, Font(), FontIndex()
RelFont256 VARSEG(Vpage(0)), 0, 155, "<ESC> to quit. || <ENTER> to toggle Vsynch!", TRUE, Font(), FontIndex()
RelFontTrans256 VARSEG(Vpage(0)), 0, 0, "RelLib Beta Ver xxx", FALSE, Font(), FontIndex()
RelFontTrans256 VARSEG(Vpage(0)), 0, 10, "RelSoft", FALSE, Font(), FontIndex()
IF VsyncON THEN
RelFont256 VARSEG(Vpage(0)), 20, 20, "Vsync=ON", FALSE, Font(), FontIndex()
ELSE
RelFont256 VARSEG(Vpage(0)), 20, 20, "Vsync=OFF", FALSE, Font(), FontIndex()
END IF
RelPrintTransS VARSEG(Vpage(0)), 45, 165, "Anya Tech 2002", 24, 2, 4, TRUE

END SUB

SUB DrawScreen STATIC
Counter = Counter MOD 30 + 1
IF Counter = 1 THEN
        FrameFlag = NOT FrameFlag
        Gamma = Gamma + 1
        IF Gamma > 6 THEN Gamma = -6
END IF

Level.TileX = INT(Level.CamX / TileW)
Level.TileY = INT(Level.CamY / TileH)
        Level.Xpos = Level.CamX MOD TileW
        Level.Ypos = Level.CamY MOD TileH


FOR X = 0 TO ScrnTileXmax
FOR Y = 0 TO ScrnTileYmax
        Tile = Map(X + Level.TileX, Y + Level.TileY)
        IF FrameFlag THEN
                IF Tile = CatFrame1 THEN Tile = CatFrame2
        END IF
        RelSpriteSolid VARSEG(Vpage(0)), (X * TileW) - Level.Xpos, (Y * TileH) - Level.Ypos, VARSEG(Tile(1)), VARPTR(Tile(TileIndex(Tile)))
NEXT Y
NEXT X

END SUB

REM $DYNAMIC
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

REM $STATIC
SUB InitPaletteData (FileName$, PaletteArray&())

    'Size array to hold all 256 colours.
    REDIM PaletteArray&(0 TO 255)

    IF FileName$ <> "" THEN
        '*** Read palette data from file ***
        FileNo = FREEFILE
        OPEN FileName$ FOR BINARY AS #FileNo
        FOR N = 0 TO 255
            GET #FileNo, , colour&
            PaletteArray&(N) = colour&
        NEXT N
        CLOSE #FileNo
    ELSE
        '*** Read palette data from DATA statements ***
        FOR N = 0 TO 255
            READ colour&
            PaletteArray&(N) = colour&
        NEXT N
    END IF


END SUB

SUB LoadNpc STATIC

FileName$ = Path$ + "Npc.Put"
InitImageData FileName$, Anya()

MakeImageIndex Anya(), AnyaIndex()

END SUB

SUB LoadTiles STATIC

'Tiles
FileName$ = Path$ + "Town.Put"
InitImageData FileName$, Tile()
MakeImageIndex Tile(), TileIndex()

'Fonts
File$ = "ex-fnt01.Put"
InitImageData File$, Font()
MakeImageIndex Font(), FontIndex()


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

SUB UpdateLevelCamera (Level AS LevelType, Direction) STATIC

SELECT CASE Direction
        CASE DR
                Level.CamX = Lilytte.X - ScrnXmid
                IF Level.CamX < ScrnXmin THEN Level.CamX = ScrnXmin
                IF Level.CamX > (Level.Xmax * TileW) - ScrnXmax THEN Level.CamX = (Level.Xmax * TileW) - ScrnXmax
        CASE DU
                Level.CamY = Lilytte.Y - ScrnYmid
                IF Level.CamY < ScrnYmin THEN Level.CamY = ScrnYmin
                IF Level.CamY > (Level.Ymax * TileH) - ScrnYmax THEN Level.CamY = (Level.Ymax * TileH) - ScrnYmax
        CASE DL
                Level.CamX = Lilytte.X - ScrnXmid
                IF Level.CamX < ScrnXmin THEN Level.CamX = ScrnXmin
                IF Level.CamX > (Level.Xmax * TileW) - ScrnXmax THEN Level.CamX = (Level.Xmax * TileW) - ScrnXmax
        CASE DD
                Level.CamY = Lilytte.Y - ScrnYmid
                IF Level.CamY < ScrnYmin THEN Level.CamY = ScrnYmin
                IF Level.CamY > (Level.Ymax * TileH) - ScrnYmax THEN Level.CamY = (Level.Ymax * TileH) - ScrnYmax
        CASE ELSE
END SELECT

END SUB

SUB UpdatePlayer (Player AS PlayerType, Direction) STATIC


SELECT CASE Direction
        CASE DR
                Player.X = Player.X + Player.Speed
                IF Player.X > (Level.Xmax * TileW) - TileW THEN Player.X = (Level.Xmax * TileW) - TileW
        CASE DU
                Player.Y = Player.Y - Player.Speed
                IF Player.Y < ScrnYmin THEN Player.Y = ScrnYmin
        CASE DL
                Player.X = Player.X - Player.Speed
                IF Player.X < ScrnXmin THEN Player.X = ScrnXmin
        CASE DD
                Player.Y = Player.Y + Player.Speed
                IF Player.Y > (Level.Ymax * TileH) - TileH THEN Player.Y = (Level.Ymax * TileH) - TileH
        CASE ELSE
END SELECT

Player.MoveFlag = TRUE
Player.Direction = Direction

Player.TileX = Player.X \ TileW
Player.TileY = Player.Y \ TileH


END SUB

FUNCTION ValidDirection (PlayerX, PlayerY, Direction) STATIC
ValidDirection = TRUE

SELECT CASE Direction
        CASE DR
                
        CASE DU
        CASE DL
        CASE DD
        CASE ELSE
END SELECT
END FUNCTION

