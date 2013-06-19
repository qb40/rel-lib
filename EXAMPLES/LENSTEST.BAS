REM $DYNAMIC
REM $INCLUDE: 'RelLib.BI'

DEFINT A-Z



DIM Vpage%(31999)
DIM Vpage2%(31999)

DIM Sqrt%(0 TO (128 * 128) \ 2)

DIM Layer%
DIM Layer2%
DIM PAL AS STRING * 768
Layer% = VARSEG(Vpage%(0))
Layer2% = VARSEG(Vpage2%(0))

CLS
SCREEN 13
RelFFix
j% = 0
FOR i% = 0 TO UBOUND(Sqrt%)
    a% = SQR(j%)
    j% = j% + 1
    b% = SQR(j%)
    C% = 0
    RelAddLow VARSEG(C%), VARPTR(C%), a%
    RelAddHi VARSEG(C%), VARPTR(C%), b%
    Sqrt%(i%) = C%
    j% = j% + 1
NEXT i%



FOR y = 0 TO 199
FOR x = 0 TO 319
    RelPset Layer2%, x, y, x OR y
NEXT x
NEXT y

'RelPcopy VIDEO, Layer2%
'C$ = INPUT$(1)
'END

x% = 10
xv% = 1
yv% = 1
y% = 10
Radius% = 64
sheight% = 30
Radius2% = 40
sheight2% = 20
Radius3% = 32
sheight3% = 20


GOSUB CalcNewGrad

T# = TIMER
DO
    F& = (F& + 1) AND &H7FFFFFFF
    xx% = SIN(F& / 80) * 160 + (160 - Radius%)
    yy% = COS(F& / 90) * 100 + (100 - Radius%)
    RelCls Layer%, 0
    RelPcopy Layer%, Layer2%
    RelLensMap Layer%, Layer2%, xx%, yy%, Radius%, sheight%, 1
    RelLensMap Layer%, Layer2%, 160 - xx%, 100 - yy%, Radius2%, sheight2%, 1
    RelLensMap Layer%, Layer2%, xx%, 100 - yy%, Radius3%, sheight3%, 1
    RelLensMap Layer%, Layer2%, 160 - xx%, yy%, Radius%, sheight3%, 1
    'WAIT &H3DA, 8
    GOSUB CalcNewGrad
    RelPcopy VIDEO, Layer%
LOOP UNTIL INKEY$ <> ""


Fps% = F& / (TIMER - T#)

CLS
SCREEN 0
WIDTH 80

PRINT Fps%
C$ = INPUT$(1)
END


CalcNewGrad:
    CurrentTime& = TIMER * 64
    r% = INT(32 + 31 * COS(F& * PI / 256 + CurrentTime& / 74))
    g% = INT(32 + 31 * COS(F& * PI / 256 + CurrentTime& / 63))
    b% = INT(32 + 31 * COS(F& * PI / 256 + CurrentTime& / 81))
    FOR i% = 0 TO 127
        RelWriteRGB i%, r% * i% / 128, g% * i% / 128, b% * i% / 128
        RelWriteRGB 128 + i%, r% + (63 - r%) * i% / 128, g% + (63 - g%) * i% / 128, b% + (63 - b%) * i% / 128
    NEXT i%
RETURN

