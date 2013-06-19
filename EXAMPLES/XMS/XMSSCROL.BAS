'An example of an XMS only scroller made with Rellib!!!!

DECLARE SUB Engine.MovePlayer (Player AS ANY)
DECLARE SUB Engine.DrawStatBar ()
DECLARE SUB Engine.DrawMap ()
DECLARE SUB Engine.DrawPlayer (Player AS ANY)
DECLARE SUB Engine.DoControls (Finval%)
DECLARE SUB Engine.DrawScreen ()
DECLARE SUB Engine.UpdateCamera (Level AS ANY, Player AS ANY)
DECLARE SUB Engine.Main ()
DECLARE SUB Engine.InitHero (NewObject AS ANY)
DECLARE SUB Engine.LoadMap ()
DECLARE SUB Engine.InitVars ()
DECLARE SUB Engine.InitLevel ()
DECLARE FUNCTION Engine.TileCollide% (Player AS ANY)
DECLARE SUB Engine.LoadDATA ()
DEFINT A-Z

'========Declare types here
TYPE SpriteType
         id             AS INTEGER              'id[unused]
         x              AS INTEGER              'World X pos
         y              AS INTEGER
         oldX           AS INTEGER              'Snapback values
         oldY           AS INTEGER
         Xv             AS INTEGER              'X Speed
         Yv             AS INTEGER              'Y speed
         Active         AS INTEGER
         Frame          AS INTEGER              'Frame in tile where to draw
         MinFrame       AS INTEGER              '[unused]
         NumFrame       AS INTEGER              '[unused]
         Move           AS INTEGER              'if the sprite is moving?
         Counter        AS INTEGER              'misc counter
         Direction      AS INTEGER              'we will use this :)
         DirChanged     AS INTEGER              'if it changed direction
         oldDir         AS INTEGER              '
         TileX          AS INTEGER              'Tile where the Player is on
         TileY          AS INTEGER
         Collide        AS INTEGER              '[unused]
         Speed          AS INTEGER              'player stride speed
END TYPE


TYPE LevelType
        Xmax    AS INTEGER          'Maximum Number of Tiles a Map has
        Ymax    AS INTEGER
        CamX    AS INTEGER          'Pixel*Pixel Camera Position
        CamY    AS INTEGER
        TileX   AS INTEGER          'Tile postion of Camera
        TileY   AS INTEGER          'Calculated by CAMX\TileSize(16*16)
        Xpos    AS INTEGER          'Pixel position Inside the Tile
        Ypos    AS INTEGER          '0 to 15 (used for Scrolling)
END TYPE


TYPE MapLayerType
       BaseL     AS INTEGER         'Farthest layer
       FringeL   AS INTEGER         '[unused]
       TiltL  AS INTEGER            '[unused]
END TYPE

'Screen constants(Full Screen 320*200)
CONST ScrnXmax = 320, ScrnYmax = 200
CONST ScrnXmid = 160 - 8, ScrnYmid = 100 - 8
CONST ScrnXmin = 0, ScrnYmin = 0

'Tile dimensions 16*16
CONST TileW = 16
CONST TileH = 16

'Number of Tiles per screen 320\16=20,200\16=12
'Used to calculate the DrawMap sub
CONST ScrnTileXmax = ScrnXmax \ TileW
CONST ScrnTileYmax = ScrnYmax \ TileH

'Map Dimensions change this to suit your needs
'Base this on the MAPDATA dimensions
CONST MapXmax = 35, MapYmax = 26

'Directional constants for easy sprite handling
'DN=Neutral(not Moving), DR=Right...........
CONST DN = 0, DU = 1, DR = 2, DD = 3, DL = 4

REM $INCLUDE: 'RelLib.BI'
REM $DYNAMIC


CLS
SCREEN 0

DIM SHARED VPage(31999) AS INTEGER
DIM SHARED LAYER AS INTEGER
DIM SHARED xmsHandle%
DIM SHARED XmsEndOFF&

DIM SHARED Path$
DIM RGBpal AS STRING * 768

Size = RelSize(0, 0, 100, 100)
DIM SHARED Tdum(Size)  AS INTEGER
REDIM SHARED XmsSprIndex(1) AS XmsTileIndexType
REDIM SHARED XmsTileIndex(1) AS XmsTileIndexType
REDIM SHARED XmsFontIndex(1) AS XmsTileIndexType
REDIM SHARED XmsTempIndex(1) AS XmsTileIndexType
REDIM SHARED XmsTemp2Index(1) AS XmsTileIndexType


DIM SHARED Map(MapXmax, MapYmax) AS MapLayerType    'Our map

DIM SHARED Level AS LevelType                       'Global level varialble
DIM SHARED Hero AS SpriteType                       'our hero

DIM SHARED VsyncOn              'if we wait for vertical refresh
DIM SHARED StatBarON            'if we want to see the statbar

LAYER = VARSEG(VPage(0))        'get the SEGMENT of our buffer



IF RelXmsInit THEN
        PRINT "Xms Allocated"
        PRINT RelXmsGetFree
        PRINT RelXmsGetTotal
END IF

CLS
SCREEN 13



xmsHandle% = RelXmsAllocate(1024)

Path$ = "C:\Qbasic\Rellib\Examples\Xms\"
Path$ = ""

Engine.LoadDATA                 'Load tiles and palette
Engine.LoadMap                  'Load map
Engine.InitVars                 'Init some global vars
Engine.InitLevel                'Load level
Engine.InitHero Hero            'Load hero
Engine.Main                     'do the scrolling


Ender:
RelXmsDeallocate xmsHandle%
CLS
SCREEN 0
WIDTH 80
END



'Map Data
'I put this in a data statement since its easier to understand that way
' :)  you could put this in a file if you want
'Dimensions : 36*27
'Note: Col(X) #36 and Row(Y) #27 is not used by the Map. They are there for
'Padding purposes and to prevent errors.
BASEMAPDATA:
DATA 06,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,06
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,02,02,02,02,02,02,02,02,02,02,02,02,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,02,01,01,01,01,01,01,01,01,01,02,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,02,02,02,02,02,02,02,02,02,02,02,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,06,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,06,06,06,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,06,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,04,04,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,04,04,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,02,01,01,01,01,01,01,01,01,01,01,01,04,04,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,02,01,01,01,01,01,01,01,01,01,01,01,04,04,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,02,02,02,02,02,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,02,02,02,02,02,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,02,01,01,01,01,01,03,03,03,03,01,01,01,01,01,01,03,03,03,03,03,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,02,01,01,01,01,01,01,03,03,03,01,01,01,01,01,01,03,01,01,01,03,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,03,01,01,01,01,01,01,03,01,01,01,03,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,03,03,03,01,01,01,01,01,01,01,01,01,01,03,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,03,01,01,01,01,03,01,03,03,03,03,03,01,01,01,01,01,01,01
DATA 01,05,01,01,01,01,01,01,01,01,01,01,01,01,01,03,03,03,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,05,05,05,05,01,01,01,01,01,01,01,01,01,03,03,03,03,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,05,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01
DATA 05,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,05

REM $STATIC
SUB Engine.DoControls (Finval) STATIC

'Get the contols using RelKey
'Finval is the value to set if we wanted to go out of the loop

IF RelKey(KEYESC) THEN                'Quit
    Finval = TRUE
END IF
IF RelKey(KEYSPACE) THEN              'Toggle WAIT
    VsyncOn = NOT VsyncOn
    WHILE RelKey(KEYSPACE): WEND
END IF
IF RelKey(KEYENTER) THEN              'Toggle StatBar
    StatBarON = NOT StatBarON
    WHILE RelKey(KEYENTER): WEND
END IF
IF RelKey(KEYTAB) THEN                'if Pressed Speed is increased
    Hero.Speed = 2
ELSE
    Hero.Speed = 1
END IF


IF RelKey(KEYUP) THEN   'Pressed UP
        Hero.Direction = DU             'Direction=Up
        Hero.Yv = -Hero.Speed           'Add -Yv to go up
        Hero.Xv = 0                     'Vertical direction so 0
        Engine.MovePlayer Hero          'Update Player position
END IF
IF RelKey(KEYRIGHT) THEN
        Hero.Direction = DR             'Direction=DOWN
        Hero.Xv = Hero.Speed            'Add +XV to go right
        Hero.Yv = 0                     'Horizontal so 0
        Engine.MovePlayer Hero          'Update Player position
END IF

IF RelKey(KEYDOWN) THEN
        Hero.Direction = DD             'Ditto
        Hero.Yv = Hero.Speed
        Hero.Xv = 0
        Engine.MovePlayer Hero
END IF
IF RelKey(KEYLEFT) THEN
        Hero.Direction = DL             'Ditto
        Hero.Xv = -Hero.Speed
        Hero.Yv = 0
        Engine.MovePlayer Hero
END IF

END SUB

SUB Engine.DrawMap STATIC

'Notes:
'1.Mod our Cam with 16 to get correct offset inside the tile
'2.Uses the constants TileH,TileW,ScrnTileXmax,ScrnTileYmax
'3.Constants are declared at the module level
'4.BaseL should be drawn with RelSpriteSolid since its faster(4 pixels drawn at a time)
'5.LAYER is the segment we are drawing to prevent flicker.

'==========BaseLayer====================
'Formula for X.(the loop below)
'(X*TileW)=Video Screen Coord(0 to 320 Step 16)
'(X*TileW)-Level.Xpos=TileOffset that we have to show from 0 to 16-Xpos
'Assuming Level.Xpos=4
'So if X*TileW=0 then (X*TileW)-Level.Xpos=-4
'We start Drawing from -4 to -4+16
'ie,-4 to 12 then the next tile is 13 to 13+16
'Hope you understand

'Draw our Screen(No need to clear our Page)
'Baselayer
FOR y = 0 TO ScrnTileYmax + 1     '14 tiles add 1 to prevent bad looking bottom
FOR x = 0 TO ScrnTileXmax         '21 tiles since we count 0
        Tx = x + Level.TileX
        Ty = y + Level.TileY
        IF Tx > MapXmax THEN Tx = MapXmax       'Limit if over the dimensions
        IF Ty > MapYmax THEN Ty = MapYmax       'of the map
        Tile = Map(Tx, Ty).BaseL                'Get Tilenumber
        IF Tile > 0 THEN                        'of there is a tile draw it.
                ScreenX = (x * TileW) - Level.Xpos      'Calc where to put a
                ScreenY = (y * TileH) - Level.Ypos      'particular tile
                RelXMSPutS LAYER, ScreenX, ScreenY, VARSEG(XmsTileIndex(1)), VARPTR(XmsTileIndex(Tile)), VARSEG(Tdum(0)), xmsHandle%
        END IF
NEXT x
NEXT y

END SUB

SUB Engine.DrawPlayer (Player AS SpriteType) STATIC

'Notes:
'1. Uses the Directional Constants defined at module level(DN,DR...)

'This Stops the Player from Swaying his arms very fast
'DirChanged=Is just a flag to prevent Electric legs effect and to see if
'Player changed direction

IF Player.Direction <> Player.oldDir THEN      'if Player changes direction
        Player.DirChanged = 1                  'Flag it to change BaseFrame
ELSE
        'Delays frame rotation for sprite(Electric legs :))
        Player.DirChanged = (Player.DirChanged AND 7) + 1       'Try to REM this :)
END IF

IF Player.DirChanged = 1 THEN
    IF Player.Move THEN
        Player.Frame = (Player.Frame MOD Player.NumFrame) + 1       'Frame=Current frame(1 to 3) the
                                        'Player sprite is
                                        'Frame is Added to baseFrame to locate
                                        'the True Sprite Offset
                                        'See PP256

        SELECT CASE Player.Direction
                CASE DR
                        'Calculate the Frame of the sprite to draw
                        Player.Frame = Player.Frame + 8        'Base Frame=8
                CASE DU
                        Player.Frame = Player.Frame + 12        'Base Frame=12
                CASE DL
                        Player.Frame = Player.Frame + 4        'Base Frame=4
                CASE DD
                        Player.Frame = Player.Frame            'Base Frame=1
                CASE ELSE
        END SELECT

        Player.Move = FALSE             'Stops the Player from Swaying
                                        'his arms while not moving
    ELSE                                'if the hero ain't movin'

        SELECT CASE Player.Direction
                CASE DR
                        'Calculate the Frame of the sprite to draw
                        Player.Frame = 8 + 4
                CASE DU
                        Player.Frame = 12 + 4
                CASE DL
                        Player.Frame = 4 + 4
                CASE DD
                        Player.Frame = 4
                CASE ELSE
        END SELECT

    END IF

END IF

'Formula: X(same goes for Y)
'Player.X-Level.CamX
'just puts the player at the Center of screen
'So if Player.X=500 then CamX=Player.X-ScrnYmid(ScrnYmid=Middle of 320=160)
'CamX:500-160=340
'Player.X=500
'Xcenter:500-340=160(ScrnXmid)
'Same goes for Y
'See Engine.UpdateCamera for more Details :)
'Sprite(SpriteIndex(Sprite.Frame) is the current frame of the Sprite(calculated above)
'Notes:
'1.Sprite(SpriteIndex(Sprite.Frame))=Real offset of the frame(NO ERRORS)
'2.SpriteIndex(Sprite.Frame)=Index of the real offset of the frame(ERRORS)

IF Player.Frame <> 0 THEN               'Just to be sure to prevent errors since PP256 starts at 1
        RelXMSPut LAYER, (Player.x - Level.CamX), (Player.y - Level.CamY), VARSEG(XmsSprIndex(1)), VARPTR(XmsSprIndex(Player.Frame)), 0, VARSEG(Tdum(0)), xmsHandle%
END IF

Player.oldDir = Player.Direction      'Save our Direction for checking above
                                      'OldDir is saved since we have declared
                                      'this SUB  as STATIC

END SUB

SUB Engine.DrawScreen STATIC
'Draw our map and player to screen

Engine.DrawMap          'Draw our map to Vpage()
Engine.DrawPlayer Hero  'Draw our Player to Vpage()

IF StatBarON THEN           'Draw Statusbar of on
    Engine.DrawStatBar
END IF

IF VsyncOn THEN             'doh?!
    WAIT &H3DA, 8  'Wait for retrace. REM this for Lightning Speed ;)
END IF

RelPcopy VIDEO, LAYER        'Display it to screen(VIDEO)


END SUB

SUB Engine.DrawStatBar
STATIC FPS, FPS2, StartTime&

'Calc FPS
FPS = FPS + 1
IF StartTime& + 1 < TIMER THEN
 FPS2 = FPS
 FPS = 0
 StartTime& = TIMER
END IF


'Top Statbar
'Draw some TranslucentBoxes
RelBoxTransF LAYER, 0, 0, 319, 50, 38
RelBox LAYER, 0, 0, 319, 50, 27
RelBox LAYER, 1, 1, 319 - 1, 50 - 1, 31
RelBox LAYER, 2, 2, 319 - 2, 50 - 2, 27

Flipmode% = 0
'Temp status check(Draw our Status for debugging purposes) ;)
RelFontXMS LAYER, 5, 5, "Hero TileX=" + LTRIM$(STR$(Hero.TileX)), 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 5, 15, "Hero TileY=" + LTRIM$(STR$(Hero.TileY)), 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 5, 25, "Tile Under=" + LTRIM$(STR$(Map(Hero.TileX, Hero.TileY).BaseL)), 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 5, 35, "Frame=" + LTRIM$(STR$(Hero.Frame)), 0, XmsFontIndex(), Flipmode%, xmsHandle%

RelFontXMS LAYER, 110, 5, "Level TileX=" + LTRIM$(STR$(Hero.TileX)), 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 110, 15, "Level TileY=" + LTRIM$(STR$(Level.TileY)), 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 110, 25, "FPS=" + LTRIM$(STR$(FPS2)), 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 110, 35, "VsyncON=" + LTRIM$(STR$(VsyncOn)), 0, XmsFontIndex(), Flipmode%, xmsHandle%

RelFontXMS LAYER, 220, 5, "<Esc>: Exit", 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 220, 15, "<Spc>: Vsync", 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 220, 25, "<Ent>: Stats", 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 220, 35, "<Tab>: Run", 0, XmsFontIndex(), Flipmode%, xmsHandle%

'Bottom Statbar
'Draw some TranslucentBoxes
RelBoxTransF LAYER, 0, 160, 319, 199, 138
RelBox LAYER, 0, 160, 319, 199, 154
RelBox LAYER, 1, 161, 319 - 1, 199 - 1, 159
RelBox LAYER, 2, 162, 319 - 2, 199 - 2, 154

RelFontXMS LAYER, 5, 171, "Relsoft's XMS only scroller!", 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 5, 179, "graphics: L_o_j and AAP", 0, XmsFontIndex(), Flipmode%, xmsHandle%
'RelFontXMS LAYER, 5, 163, "FREE MEM: " + LTRIM$(STR$(FRE(-1))), 0, XmsFontIndex(), Flipmode%, xmsHandle%
RelFontXMS LAYER, 5, 187, "Tiles on XMS:(At least)" + LTRIM$(STR$(XmsEndOFF&)), 0, XmsFontIndex(), Flipmode%, xmsHandle%


END SUB

SUB Engine.InitHero (NewObject AS SpriteType)

'Initializes the hero's attributes(characteristics)

NewObject.id = 1
NewObject.x = 18 * TileW                'Start from 18 tiles right
NewObject.y = 15 * TileH                '15 tiles down
NewObject.oldX = 18 * TileW
NewObject.oldY = 15 * TileH
NewObject.Xv = 0
NewObject.Yv = 0
NewObject.Active = TRUE
NewObject.Frame = 1
NewObject.MinFrame = 1                  'Looking down
NewObject.NumFrame = 4                  'number of frames per face
NewObject.Move = TRUE
NewObject.Counter = 0
NewObject.Direction = DD
NewObject.TileX = NewObject.x \ TileW       'Calculate TileX
NewObject.TileY = NewObject.y \ TileH
NewObject.Collide = FALSE
NewObject.Speed = 1                     'Set speed to 1

END SUB

SUB Engine.InitLevel

Level.Xmax = MapXmax            'Load max values
Level.Ymax = MapYmax
Level.CamX = 0
Level.CamY = 0
Level.TileX = 0
Level.TileY = 0
Level.Xpos = 0
Level.Ypos = 0

END SUB

SUB Engine.InitVars
VsyncOn = FALSE         'WAIT off
StatBarON = TRUE        'Status bar ON

END SUB

SUB Engine.LoadDATA

RelLoadPalPP256 Path$ + "XmsPal.Pal"

File$ = "XmsHero.Put"
RelTile2Xms Path$ + File$, XmsSprIndex(), xmsHandle%, 0, XmsEndOFF&
File$ = "xmsTiles.Put"
RelTile2Xms Path$ + File$, XmsTileIndex(), xmsHandle%, XmsEndOFF&, XmsEndOFF&
File$ = "XmsFont.Put"
RelTile2Xms Path$ + File$, XmsFontIndex(), xmsHandle%, XmsEndOFF&, XmsEndOFF&

File$ = "xmsTiles.Put"
RelTile2Xms Path$ + File$, XmsTempIndex(), xmsHandle%, XmsEndOFF&, XmsEndOFF&

'Put a LOT of tiles to XMS for bragging rights...
FOR i = 0 TO 400
File$ = "xmsTiles.Put"
RelTile2Xms Path$ + File$, XmsTemp2Index(), xmsHandle%, XmsEndOFF&, XmsEndOFF&
RelAddXMSTileIndex XmsTempIndex(), XmsTemp2Index()
NEXT i


END SUB

SUB Engine.LoadMap STATIC

RESTORE BASEMAPDATA         'Read from Data label BASEmapDATA

FOR y = 0 TO MapYmax
FOR x = 0 TO MapXmax
        READ Tile
        Map(x, y).BaseL = Tile      'If you don't understand this.....
NEXT x
NEXT y

END SUB

SUB Engine.Main STATIC

Finished = FALSE        'For our loop
RelKeyBoardON

DO
    Engine.UpdateCamera Level, Hero 'Update camera position
    Engine.DrawScreen               'Draw Our  Screen to page and
                                    'Copy it to VIDEO
    Engine.DoControls Finished      'Control the player via RelKey

LOOP UNTIL Finished

RelKeyBoardOFF



END SUB

SUB Engine.MovePlayer (Player AS SpriteType) STATIC

'Updates the players position according to its direction
'ZELDA style Pixel*Pixel free movement
'Sample Code:
'CODE: Player.X = Player.X + Player.XV
        'Add Xspeed to Player X position
        '(-)=LEFT, (+)=Right
        'Same for Y
'CODE: IF Player.X > (Level.Xmax * TileW)  THEN Player.X = (Level.Xmax * TileW)
        'Checks if player is outside of World map boudaries
        '(Level.Xmax * TileW) - TileW=(36*16)-16

'Save old player values as this is used for "Snapping" back to
'its original position if we collided with a tile.

Player.oldX = Player.x
Player.oldY = Player.y


'***Move the player Horizontaly
'***and limit the position if its out of bounds
Player.x = Player.x + Player.Xv
IF Player.x < ScrnXmin THEN Player.x = ScrnXmin
IF Player.x > (Level.Xmax * TileW) THEN Player.x = (Level.Xmax * TileW)

'***Move the player vertically
'***and limit the position if its out of bounds
Player.y = Player.y + Player.Yv
IF Player.y < ScrnYmin THEN Player.y = ScrnYmin
IF Player.y > (Level.Ymax * TileH) THEN Player.y = (Level.Ymax * TileH)

'Update the player moveFlag to animate the player(REM this for no Animation)
Player.Move = TRUE

'Return Player last pos if collided with collidable tiles
IF Engine.TileCollide(Player) THEN
        Player.x = Player.oldX
        Player.y = Player.oldY
END IF

'Calculate what Tile the player is
'Add 8 to X and Y to get center of Player since size is 16*16
Player.TileX = (Player.x + 8) \ TileW    'Center of Sprite
Player.TileY = (Player.y + 8) \ TileH

END SUB

FUNCTION Engine.TileCollide (Player AS SpriteType) STATIC
'Crappy tile*tile collision detection ;)
'Returns TRUE if collision is detected, FALSE if not
'I didn't include a Pixel*pixel colision detection so as not to be confusing
'RelLib has a Pixel*pixel collision detection so don't worry ;)

'Init the function to be FALSE(no collision)
Engine.TileCollide = FALSE


'4 checks are done to be sure ;)
'Up-Left corner of hero
x = Player.x + 10        'Add 1 for 15*15 Box Collision
y = Player.y + 8
GOSUB CheckForTile      'check for the tile

'Up-Right corner of hero
x = Player.x + 10
y = Player.y + 8
GOSUB CheckForTile

'Down-Right corner of hero
x = Player.x + 10
y = Player.y + 15
GOSUB CheckForTile

'Down-Left corner of hero
x = Player.x + 5
y = Player.y + 15
GOSUB CheckForTile


EXIT FUNCTION

'Check for collision:(Bounding BoxType)
CheckForTile:
Tx = x \ TileW          'Player.X\TileW=TileX
Ty = y \ TileH          'Player.Y\TileH=TileH

'Check the HI and LOW byte of our fringe layer
'0=No collision,else= collision

IF Map(Tx, Ty).BaseL > 1 THEN
                Engine.TileCollide = TRUE
                EXIT FUNCTION
END IF

RETURN          'Check for next Coord

END FUNCTION

SUB Engine.UpdateCamera (Level AS LevelType, Player AS SpriteType) STATIC

'Updates CAMX,CAMY in relation to Player.X,Player.Y to achieve
'ZELDA style scrolling engine.
'Sample Code:
'CODE: CASE DR
        'Right Direction of movement
'CODE: Level.CamX = Player.X - ScrnXmid
        'Center our player to the screen and Moves the camera to where
        'the player is going
        'ie, Assume: Player.X=1200,ScrnMid=Constant 160(Middle screen)
        'Level.CamX:1200-160=1040
        'to get the TileX:
        'TileX=Level.CamX\TileW=1040\16=65(This will be used with Engine.DrawMap)
'CODE: IF Level.CamX < ScrnXmin THEN Level.CamX = ScrnXmin
        'Check if level.CamX<0, Zero it if its negative to prevent errors
        'ScrnYmin=0(Constant)
'CODE: IF Level.CamX > (Level.Xmax * TileW) - ScrnXmax THEN Level.CamX = (Level.Xmax * TileW) - ScrnXmax
        'Check if Level.CamX > (Level.Xmax * TileW) - ScrnXmax
        '(Level.Xmax * TileW) - ScrnXmax=Maximum number of PIXELS the Map has
        'Level.Xmax=Max num of tile for map(Shared Variable Level.Element)
        'TileW=Width of tile(Constant)
        'ScrnXmax=320(Constant)
        'To calculate: Level.Xmax=MapXmax
        'Formula:(Level.Xmax * TileW) - ScrnXmax
        'Level.Xmax=36
        '(36*16)-320=256
        'Level.CamX=256
        'To calculate TileX:
        'Level.CamX\TileW
        '256\16=16
        'TileX=16(Start Drawing from 16 to 36)
        '16 is the first tile to draw in X
        '36-16=20(See we have to draw 20 tiles horizontally!!!)
        'Same goes for Y
        'See Engine.DrawMap SUB for more details. ;)

'*** Update the camera
Level.CamX = Player.x - ScrnXmid

'***Limit if out of bounds
IF Level.CamX < ScrnXmin THEN Level.CamX = ScrnXmin
IF Level.CamX > ((Level.Xmax + 1) * TileW) - ScrnXmax THEN Level.CamX = ((Level.Xmax + 1) * TileW) - ScrnXmax

Level.CamY = Player.y - ScrnYmid

IF Level.CamY < ScrnYmin THEN Level.CamY = ScrnYmin
IF Level.CamY > ((Level.Ymax + 1) * TileH) - ScrnYmax THEN Level.CamY = ((Level.Ymax + 1) * TileH) - ScrnYmax

'Calculate the first tile to draw
Level.TileX = Level.CamX \ TileW        'First tile to draw
Level.TileY = Level.CamY \ TileH
                            
'Get the offset inside the tile use AND if its a pow of 2 tilesize
Level.Xpos = Level.CamX MOD TileW            'Position in the Tile(0 to 15)
Level.Ypos = Level.CamY MOD TileH            '16*16 tile size(change to fit your needs)



END SUB

