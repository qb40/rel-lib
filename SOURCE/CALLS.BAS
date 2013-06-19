DEFINT A-Z
DECLARE SUB RelXMSPut (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL SprSeg%, BYVAL SprOff%, BYVAL Flipmode%, BYVAL DummySeg%, BYVAL xmsHandle%)
DECLARE SUB RelXMSFromBase (BYVAL BaseSeg%, BYVAL BaseOFF&, BYVAL xmsHandle%, BYVAL XMSOffset&, BYVAL Length&)
DECLARE SUB RelAddHI (BYVAL SEGINTVAL%, BYVAL OFFINTVAL%, BYVAL BYTEVAL%)
DECLARE SUB RelAddLOW (BYVAL SEGINTVAL%, BYVAL OFFINTVAL%, BYVAL BYTEVAL%)
DECLARE FUNCTION xRelLoadBMP% (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL FileSeg%, BYVAL FileOff%, BYVAL PalSeg%, BYVAL PalOff%, BYVAL SwitchPal%)
DECLARE FUNCTION RelLoadBMP% (Layer%, x%, y%, File$, Pal$, SwitchPal%)
DECLARE FUNCTION xRelLoadPCX% (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL FileSeg%, BYVAL FileOff%, BYVAL PalSeg%, BYVAL PalOff%, BYVAL SwitchPal%)
DECLARE FUNCTION RelLoadPCX% (Layer%, x%, y%, File$, Pal$, SwitchPal%)
DECLARE SUB xRelFindFile (BYVAL MaskSeg%, BYVAL MaskOff%, BYVAL FileSeg%, BYVAL FileOff%, BYVAL Attribute%)
DECLARE FUNCTION RelFindFile$ (Mask$, Attribute%)
DECLARE SUB xRelMode7Map (BYVAL Layer%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL sx%, BYVAL sy%, BYVAL sz%, BYVAL Hz%, BYVAL c%, BYVAL sa%, BYVAL cx&, BYVAL cy&, BYVAL TSeg%, BYVAL TOff%, BYVAL Mseg%, BYVAL MOff%, BYVAL xM%, BYVAL yM%)
DECLARE SUB RelMode7Map (Layer%, x1%, y1%, x2%, y2%, Angle%, scalex%, scaley%, scalez%, Horz%, camx!, camy!, Texture%(), TextureOffset%, Map%())
DECLARE SUB xRelMode7 (BYVAL Layer%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL scalex%, BYVAL scaley%, BYVAL scalez%, BYVAL Horz%, BYVAL cosa%, BYVAL sina%, BYVAL camx&, BYVAL camy&, BYVAL TextSeg%, BYVAL Textoff%)
DECLARE SUB RelMode7 (Layer%, x1%, y1%, x2%, y2%, Angle%, scalex%, scaley%, scalez%, Horz%, camx!, camy!, Texture%(), TextureOffset%)
DECLARE SUB xRelPsetWu (BYVAL Layer%, BYVAL x&, BYVAL y&, BYVAL clr%)
DECLARE SUB RelPsetWu (Layer%, x!, y!, clr%)
DECLARE SUB xRelPsetWu16 (BYVAL Layer%, BYVAL x&, BYVAL y&, BYVAL clr%)
DECLARE SUB RelPsetWu16 (Layer%, x!, y!, clr%)
DECLARE SUB RelLensMap (Dest%, Src%, x%, y%, Radius%, sheight%, Mode%)
DECLARE SUB RelSphereMap (Layer%, x%, y%, xoff%, yoff%, Radius%, sheight%, Image%(), ImageOffs%, Mode%)
DECLARE SUB xRelSphereMap (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL xoff%, BYVAL yoff%, BYVAL Radius%, BYVAL sheight%, BYVAL TextSeg%, BYVAL Textoff%, BYVAL SqrSeg%, BYVAL SqrOff%)
DECLARE SUB xRelSphereMapSolid (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL xoff%, BYVAL yoff%, BYVAL Radius%, BYVAL sheight%, BYVAL TextSeg%, BYVAL Textoff%, BYVAL SqrSeg%, BYVAL SqrOff%)
DECLARE SUB xRelSphereMapTrans (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL xoff%, BYVAL yoff%, BYVAL Radius%, BYVAL sheight%, BYVAL TextSeg%, BYVAL Textoff%, BYVAL SqrSeg%, BYVAL SqrOff%)
DECLARE SUB xRelLens (BYVAL Dest%, BYVAL Src%, BYVAL x%, BYVAL y%, BYVAL Radius%, BYVAL sheight%, BYVAL SqrSeg%, BYVAL SqrOff%)
DECLARE SUB xRelLensSolid (BYVAL Dest%, BYVAL Src%, BYVAL x%, BYVAL y%, BYVAL Radius%, BYVAL sheight%, BYVAL SqrSeg%, BYVAL SqrOff%)
DECLARE SUB xRelLensTrans (BYVAL Dest%, BYVAL Src%, BYVAL x%, BYVAL y%, BYVAL Radius%, BYVAL sheight%, BYVAL SqrSeg%, BYVAL SqrOff%)

TYPE XmsTileIndexType
    Bytes   AS LONG
    offs    AS LONG
END TYPE

SUB RelAddXMSTileIndex (DestTile() AS XmsTileIndexType, SourceTile() AS XmsTileIndexType)

MinDest = LBOUND(DestTile)
MinSource = LBOUND(SourceTile)
MaxDest = UBOUND(DestTile)
MaxSource = UBOUND(SourceTile)
MaxALL = MaxDest + MaxSource
DIM Temp(MinDest TO MaxALL) AS XmsTileIndexType

FOR i = MinDest TO MaxDest
    Temp(i) = DestTile(i)
NEXT i
'Add
FOR i = MaxDest + 1 TO MaxALL
    Temp(i) = SourceTile(i - MaxDest)
NEXT i

'Copy
REDIM DestTile(MinDest TO MaxALL) AS XmsTileIndexType

FOR i = MinDest TO MaxALL
    DestTile(i) = Temp(i)
NEXT i

ERASE Temp
ERASE SourceTile

END SUB

DEFSNG A-Z
FUNCTION RelFindFile$ (Mask$, Attribute%)
  Fil$ = SPACE$(12)
  Mask$ = Mask$ + CHR$(0)
  xRelFindFile VARSEG(Mask$), SADD(Mask$), VARSEG(Fil$), SADD(Fil$), Attribute%
  Fil$ = LTRIM$(RTRIM$(Fil$))
  IF Fil$ = CHR$(0) THEN Fil$ = ""
  RelFindFile$ = Fil$
END FUNCTION

DEFINT A-Z
SUB RelFontXms (DestSeg%, x%, y%, Text$, Centered%, XmsFont() AS XmsTileIndexType, Flipmode%, xmsHandle%) STATIC
IF InitDone = 0 THEN
    REDIM Dummy%((64 * 64 + 4) \ 2)
    RelXMSPut DestSeg%, xxx%, yyy%, VARSEG(XmsFont(1)), VARPTR(XmsFont(1)), Flipmode%, VARSEG(Dummy(0)), xmsHandle%
    Wid% = Dummy%(1)
    InitDone = -1
END IF
xxx% = x%
yyy% = y%
IF NOT Centered% THEN

        FOR i% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, i%, 1)) - 31
                RelXMSPut DestSeg%, xxx%, yyy%, VARSEG(XmsFont(1)), VARPTR(XmsFont(FontChar)), Flipmode%, VARSEG(Dummy(0)), xmsHandle%
                xxx% = xxx% + Wid%
        NEXT i%

ELSE            'Centered

        StrLen% = 0
        FOR i% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, i%, 1)) - 31
                StrLen% = StrLen% + Wid%
        NEXT i%
        StrLen% = StrLen% \ 8  'Calculate length
        xxx% = (320 - StrLen%) \ 2
        FOR i% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, i%, 1)) - 31
                RelXMSPut DestSeg%, xxx%, yyy%, VARSEG(XmsFont(1)), VARPTR(XmsFont(FontChar)), Flipmode%, VARSEG(Dummy(0)), xmsHandle%
                xxx% = xxx% + Wid%
        NEXT i%

END IF

END SUB

DEFSNG A-Z
SUB RelLensMap (Dest%, Src%, x%, y%, Radius%, sheight%, Mode%) STATIC

IF InitDone% = 0 THEN
    DIM Sqrt%((128 * 128) \ 2)
    j% = 0
    FOR i% = 0 TO UBOUND(Sqrt%)
        a% = SQR(j%)
        j% = j% + 1
        b% = SQR(j%)
        c% = 0
        RelAddLOW VARSEG(c%), VARPTR(c%), a%
        RelAddHI VARSEG(c%), VARPTR(c%), b%
        Sqrt%(i%) = c%
        j% = j% + 1
    NEXT i%
    InitDone% = -1
END IF

SELECT CASE Mode%
CASE 0       'TransParent
    xRelLens Dest%, Src%, x%, y%, Radius%, sheight%, VARSEG(Sqrt%(0)), VARPTR(Sqrt%(0))
CASE 1       'Solid
    xRelLensSolid Dest%, Src%, x%, y%, Radius%, sheight%, VARSEG(Sqrt%(0)), VARPTR(Sqrt%(0))
CASE 2       'TransLucent
    xRelLensTrans Dest%, Src%, x%, y%, Radius%, sheight%, VARSEG(Sqrt%(0)), VARPTR(Sqrt%(0))
CASE ELSE    'TransParent
    xRelLens Dest%, Src%, x%, y%, Radius%, sheight%, VARSEG(Sqrt%(0)), VARPTR(Sqrt%(0))
END SELECT

END SUB

DEFINT A-Z
FUNCTION RelLoadBMP% (Layer%, x%, y%, File$, Pal$, SwitchPal%)
   File$ = File$ + CHR$(0)
   RelLoadBMP% = xRelLoadBMP%(Layer%, x%, y%, VARSEG(File$), SADD(File$), VARSEG(Pal$), SADD(Pal$), BYVAL SwitchPal%)
END FUNCTION

FUNCTION RelLoadPCX% (Layer%, x%, y%, File$, Pal$, SwitchPal%)
   File$ = File$ + CHR$(0)
   RelLoadPCX% = xRelLoadPCX%(Layer%, x%, y%, VARSEG(File$), SADD(File$), VARSEG(Pal$), SADD(Pal$), BYVAL SwitchPal%)
END FUNCTION

DEFSNG A-Z
SUB RelMode7 (Layer%, x1%, y1%, x2%, y2%, Angle%, scalex%, scaley%, scalez%, Horz%, camx!, camy!, Texture%(), TextureOffset%)

'xRelMode7   Proc  Uses es di ds si,\
'            Layer:word,scalex:word, scaley:word, scalez:word, horz:word,\
'            cosa: word, sina: word, camx: word, camy: word, TextSeg: word, TextOff: word
a! = (Angle% * 3.141593) / 180
cosa% = COS(a!) * 256
sina% = SIN(a!) * 256
camx& = camx! * 65536
camy& = camy! * 65536
IF Horz% < 1 THEN Horz% = 1

xRelMode7 Layer%, x1%, y1%, x2%, y2%, scalex%, scaley%, scalez%, Horz%, cosa%, sina%, camx&, camy&, VARSEG(Texture%(TextureOffset%)), VARPTR(Texture%(TextureOffset%))

END SUB

SUB RelMode7Map (Layer%, x1%, y1%, x2%, y2%, Angle%, scalex%, scaley%, scalez%, Horz%, camx!, camy!, Texture%(), TextureOffset%, Map%())
'xRelMode7map   Proc  Uses es di ds si,\
'                Layer:word, x1:word, y1:word, x2:word, y2:word, scalex:word, scaley:word, scalez:word, horz:word,\
'                cosa: word, sina: word, camx: Dword, camy: Dword, TextSeg: word, TextOff: word, Mapseg:Word, MapOff: word, xMapsize:word,yMapsize: word

a! = (Angle% * 3.141593) / 180
cosa% = COS(a!) * 256
sina% = SIN(a!) * 256
camx& = camx! * 65536
camy& = camy! * 65536
Mx% = UBOUND(Map%, 1) + 1
My% = UBOUND(Map%, 2) + 1

IF Horz% < 1 THEN Horz% = 1
xRelMode7Map Layer%, x1%, y1%, x2%, y2%, scalex%, scaley%, scalez%, Horz%, cosa%, sina%, camx&, camy&, VARSEG(Texture%(TextureOffset%)), VARPTR(Texture%(TextureOffset%)), VARSEG(Map%(0, 0)), VARPTR(Map%(0, 0)), Mx%, My%

END SUB

SUB RelPsetWu (Layer%, x!, y!, clr%)
x& = x! * 256
y& = y! * 256
xRelPsetWu Layer%, x&, y&, clr%
END SUB

SUB RelPsetWu16 (Layer%, x!, y!, clr%)
x& = x! * 256
y& = y! * 256
xRelPsetWu16 Layer%, x&, y&, clr%
END SUB

SUB RelSphereMap (Layer%, x%, y%, xoff%, yoff%, Radius%, sheight%, Image%(), ImageOffs%, Mode%) STATIC

IF InitDone% = 0 THEN
    DIM Sqrt%((128 * 128) \ 2)
    j% = 0
    FOR i% = 0 TO UBOUND(Sqrt%)
        a% = SQR(j%)
        j% = j% + 1
        b% = SQR(j%)
        c% = 0
        RelAddLOW VARSEG(c%), VARPTR(c%), a%
        RelAddHI VARSEG(c%), VARPTR(c%), b%
        Sqrt%(i%) = c%
        j% = j% + 1
    NEXT i%
    InitDone% = -1
END IF

SELECT CASE Mode%
CASE 0       'TransParent
    xRelSphereMap Layer%, x%, y%, xoff%, yoff%, Radius%, sheight%, VARSEG(Image%(0)), VARPTR(Image%(ImageOffs%)), VARSEG(Sqrt%(0)), VARPTR(Sqrt%(0))
CASE 1       'Solid
    xRelSphereMapSolid Layer%, x%, y%, xoff%, yoff%, Radius%, sheight%, VARSEG(Image%(0)), VARPTR(Image%(ImageOffs%)), VARSEG(Sqrt%(0)), VARPTR(Sqrt%(0))
CASE 2       'TransLucent
    xRelSphereMapTrans Layer%, x%, y%, xoff%, yoff%, Radius%, sheight%, VARSEG(Image%(0)), VARPTR(Image%(ImageOffs%)), VARSEG(Sqrt%(0)), VARPTR(Sqrt%(0))
CASE ELSE       'TransParent
    xRelSphereMap Layer%, x%, y%, xoff%, yoff%, Radius%, sheight%, VARSEG(Image%(0)), VARPTR(Image%(ImageOffs%)), VARSEG(Sqrt%(0)), VARPTR(Sqrt%(0))
END SELECT

END SUB

DEFINT A-Z
SUB RelTile2Xms (Filename$, Tile() AS XmsTileIndexType, xmsHandle%, XmsStartOFF&, XmsEndOFF&)
'Converts Tiles to XMS format and Comressing it by 99.99 percent :*)
'Tile() is a DYNAMIC array

REDIM SourceTile(1 TO 1)
'Bload the file
IF Filename$ <> "" THEN
    'Establish size of integer array required.
    f = FREEFILE
    OPEN Filename$ FOR BINARY AS #f
    Ints = (LOF(f) - 7) \ 2
    CLOSE #f
    REDIM SourceTile(1 TO Ints)
    'Load image data directly into array memory.
    DEF SEG = VARSEG(SourceTile(1))
    BLOAD Filename$, 0
    DEF SEG
END IF

'move stuff to xms
RelXMSFromBase VARSEG(SourceTile(1)), VARPTR(SourceTile(1)), xmsHandle%, XmsStartOFF&, (UBOUND(SourceTile) * 2&)
REDIM SourceTileIndex(LBOUND(SourceTile) TO 1000)
''Index it

offs& = 1
Idx = 1
LastInt = UBOUND(SourceTile)
DO
    SourceTileIndex(Idx) = offs&
    Idx = Idx + 1
    Bytes& = (SourceTile(offs&) \ 8) * (SourceTile(offs& + 1)) + 4
    IF (Bytes& AND 1) THEN Bytes& = Bytes& + 1
    offs& = offs& + (Bytes& \ 2)
LOOP WHILE offs& < LastInt

MinElem = LBOUND(SourceTileIndex)
MaxElem = Idx - 1
Offset& = XmsStartOFF&
DIM Temp(MinElem TO MinElem + 1000) AS XmsTileIndexType
Elem = MinElem - 1

DO
        Elem = Elem + 1                         'Incremate Elem
        Wid& = SourceTile(SourceTileIndex(Elem))                     'Calc Width
        hei& = SourceTile(SourceTileIndex(Elem) + 1)            'Calc Height
        w& = Wid& \ 8
        h& = hei&
        ByteLen& = (w&) * (h&) + 4&           'Calc Length in Bytes
        IF (ByteLen& AND 1) THEN ByteLen& = ByteLen& + 1
        Temp(Elem).Bytes = ByteLen&
        Temp(Elem).offs = Offset&             'Put it to TempArray
        'Calc Next offset
        Offset& = Offset& + ByteLen&
LOOP WHILE Elem < MaxElem

REDIM Tile(Elem) AS XmsTileIndexType

FOR i = MinElem TO UBOUND(Tile)
        Tile(i) = Temp(i)
NEXT i


XmsEndOFF& = Offset& + 1
ERASE Temp
ERASE SourceTile
ERASE SourceTileIndex

END SUB

