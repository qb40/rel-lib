'Spheremaping Example
' ;*)

REM $DYNAMIC
REM $INCLUDE: 'RelLib.BI'

DEFINT A-Z



DIM Vpage%(31999)
DIM Vpage2%(31999)
Size% = RelSize(0, 0, 127, 127)
DIM Texture%(Size%)

DIM Layer%, Layer2%
DIM PAL AS STRING * 768
Layer% = VARSEG(Vpage%(0))
Layer2% = VARSEG(Vpage2%(0))

'''''SET THIS TO THE FOLDER YOU UNZIPPED THE ARCHIVE

Path$ = "C:\Temp\Rellib\Examples\"
File$ = "Anya128C.Bmp"

CLS
SCREEN 13


c = RelLoadBMP(VIDEO, 0, 0, Path$ + File$, PAL, TRUE)
GET (0, 0)-(127, 127), Texture%

PUT (0, 0), Texture%, PSET

x% = 10
xv% = 1
yv% = 1
y% = 10
Radius% = 64
sheight% = 30

T# = TIMER
DO
    F& = (F& + 1) AND &H7FFFFFFF
    xx% = SIN(F& / 80) * 160 + (160 - Radius%)
    yy% = COS(F& / 90) * 100 + (100 - Radius%)
    RelCls Layer%, 0
    RelSprite Layer%, 128, 0, VARSEG(Texture%(0)), VARPTR(Texture%(0))
    RelSphereMap Layer%, xx%, yy%, xx%, yy%, Radius%, sheight%, Texture%(), 0, 1
    RelSphereMap Layer%, 160 - xx%, 100 - yy%, 0, 0, Radius%, sheight%, Texture%(), 0, 1
    RelSphereMap Layer%, 160 - Radius, 100 - Radius, xx%, 0, Radius%, sheight%, Texture%(), 0, 2
    'WAIT &H3DA, 8
    RelPcopy VIDEO, Layer%

LOOP UNTIL INKEY$ <> ""


RelSprite Layer2%, 0, 0, VARSEG(Texture%(0)), VARPTR(Texture%(0))
RelSprite Layer2%, 128, 0, VARSEG(Texture%(0)), VARPTR(Texture%(0))
RelSprite Layer2%, 128, 128, VARSEG(Texture%(0)), VARPTR(Texture%(0))
RelSprite Layer2%, 0, 128, VARSEG(Texture%(0)), VARPTR(Texture%(0))
RelSprite Layer2%, 256, 0, VARSEG(Texture%(0)), VARPTR(Texture%(0))
RelSprite Layer2%, 256, 128, VARSEG(Texture%(0)), VARPTR(Texture%(0))
Radius% = 40
sheight% = 20
Radius2% = 30
sheight2% = 20
Radius3% = 30
sheight3% = 20


F& = 0
T# = TIMER
DO
    F& = (F& + 1) AND &H7FFFFFFF
    xx% = SIN(F& / 80) * 160 + (160 - Radius%)
    yy% = COS(F& / 90) * 100 + (100 - Radius%)
    RelCls Layer%, 0
    RelPcopy Layer%, Layer2%
    RelLensMap Layer%, Layer2%, xx%, yy%, Radius%, sheight%, 0
    RelLensMap Layer%, Layer2%, 160 - xx%, 100 - yy%, Radius2%, sheight2%, 1
    RelLensMap Layer%, Layer2%, xx%, 100 - yy%, Radius3%, sheight3%, 2
    RelPcopy VIDEO, Layer%
LOOP UNTIL INKEY$ <> ""

Fps% = F& / (TIMER - T#)

CLS
SCREEN 0
WIDTH 80

PRINT Fps%
c$ = INPUT$(1)
END

