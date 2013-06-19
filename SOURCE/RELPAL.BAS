DECLARE SUB RelReadRGB (ColorVal%, R%, G%, B%)
DECLARE SUB RelWriteRGB (ColorNum%, R%, G%, B%)
DECLARE SUB RelReadPal (PalString$)
DEFINT A-Z

SUB RelFade (R, G, B, Counts) STATIC
'This sub fades the current palette to the specified RGB color
'counts is a nifty idea that lets you specify how many iterations
'to fade b4 it ends, cool huh?


TempPal$ = SPACE$(768)
RelReadPal TempPal$
REDIM TempPalArray(2, 255) AS SINGLE
REDIM FadePal(2, 255) AS SINGLE
DIM PalDiff AS SINGLE

ColorVal = 0
 
FOR I% = 1 TO 768 STEP 3
    TempPalArray(0, ColorVal) = ASC(MID$(TempPal$, I%, 1))
    TempPalArray(1, ColorVal) = ASC(MID$(TempPal$, I% + 1, 1))
    TempPalArray(2, ColorVal) = ASC(MID$(TempPal$, I% + 2, 1))
    ColorVal = ColorVal + 1
NEXT I%

IF Counts < 1 THEN Counts = 1
'Morphing algorithm used  yay!!!!
FOR I = 0 TO 255
        PalDiff = R - TempPalArray(0, I)
        FadePal(0, I) = PalDiff / Counts

        PalDiff = G - TempPalArray(1, I)
        FadePal(1, I) = PalDiff / Counts

        PalDiff = B - TempPalArray(2, I)
        FadePal(2, I) = PalDiff / Counts
NEXT I

FOR I = 1 TO Counts
        FOR J = 0 TO 255
                TempPalArray(0, J) = TempPalArray(0, J) + FadePal(0, J)
                TempPalArray(1, J) = TempPalArray(1, J) + FadePal(1, J)
                TempPalArray(2, J) = TempPalArray(2, J) + FadePal(2, J)
        NEXT J

        WAIT &H3DA, 8, 8
        WAIT &H3DA, 8

        OUT &H3C8, 0
        FOR J = 0 TO 255
                OUT &H3C9, TempPalArray(0, J)
                OUT &H3C9, TempPalArray(1, J)
                OUT &H3C9, TempPalArray(2, J)
        NEXT J

NEXT I

ERASE TempPalArray
ERASE FadePal


END SUB

SUB RelFadeStep (StartCol, EndCol, R%, G%, B%) STATIC
'This sub fades the current palette to the specified RGB color
'in steps, so if you want to fade fully call this sub 64 times
'from StartColor to Endcolor ie, selective fade

IF StartCol > EndCol THEN SWAP StartCol, EndCol

I = I + 1

IF I > 63 THEN
        I = 0
        EXIT SUB
END IF

FOR J = StartCol TO EndCol


        RelReadRGB J, RD, GN, BLL

        IF R% > RD THEN
                RD = RD + 1
        ELSEIF R% < RD THEN
                RD = RD - 1
        ELSE
                'Do nothing
        END IF

        IF G% > GN THEN
                GN = GN + 1
        ELSEIF G% < GN THEN
                GN = GN - 1
        ELSE
                'Do nothing
        END IF

        IF B% > BLL THEN
                BLL = BLL + 1
        ELSEIF B% < BLL THEN
                BLL = BLL - 1
        ELSE
                'Do nothing
        END IF

        RelWriteRGB J, RD, GN, BLL

NEXT J

END SUB

SUB RelFadeToPal (PalString$, Counts) STATIC
'This sub fades the current palette to the specified palette comtained
'in the 768 byte palstring$
'counts is a nifty idea that lets you specify how many iterations
'to fade b4 it ends, cool huh?

TempPal$ = SPACE$(768)
RelReadPal TempPal$
REDIM TempPalArray(2, 255) AS SINGLE      'Current pal
REDIM TempPalArray2(2, 255) AS SINGLE     'PalString$ pal
REDIM FadePal(2, 255) AS SINGLE
DIM PalDiff AS SINGLE


ColorVal = 0
FOR I% = 1 TO 768 STEP 3
    TempPalArray(0, ColorVal) = ASC(MID$(TempPal$, I%, 1))
    TempPalArray(1, ColorVal) = ASC(MID$(TempPal$, I% + 1, 1))
    TempPalArray(2, ColorVal) = ASC(MID$(TempPal$, I% + 2, 1))
    ColorVal = ColorVal + 1
NEXT I%

ColorVal = 0
FOR I% = 1 TO 768 STEP 3
    TempPalArray2(0, ColorVal) = ASC(MID$(PalString$, I%, 1))
    TempPalArray2(1, ColorVal) = ASC(MID$(PalString$, I% + 1, 1))
    TempPalArray2(2, ColorVal) = ASC(MID$(PalString$, I% + 2, 1))
    ColorVal = ColorVal + 1
NEXT I%


IF Counts < 1 THEN Counts = 1

'Morphing algorithm used  yay!!!!
FOR I = 0 TO 255
        PalDiff = TempPalArray2(0, I) - TempPalArray(0, I)
        FadePal(0, I) = PalDiff / Counts

        PalDiff = TempPalArray2(1, I) - TempPalArray(1, I)
        FadePal(1, I) = PalDiff / Counts

        PalDiff = TempPalArray2(2, I) - TempPalArray(2, I)
        FadePal(2, I) = PalDiff / Counts
NEXT I

FOR I = 1 TO Counts
        FOR J = 0 TO 255
                TempPalArray(0, J) = TempPalArray(0, J) + FadePal(0, J)
                TempPalArray(1, J) = TempPalArray(1, J) + FadePal(1, J)
                TempPalArray(2, J) = TempPalArray(2, J) + FadePal(2, J)
        NEXT J

        WAIT &H3DA, 8, 8
        WAIT &H3DA, 8

        OUT &H3C8, 0
        FOR J = 0 TO 255
                OUT &H3C9, TempPalArray(0, J)
                OUT &H3C9, TempPalArray(1, J)
                OUT &H3C9, TempPalArray(2, J)
        NEXT J

NEXT I

ERASE TempPalArray
ERASE TempPalArray2
ERASE FadePal


END SUB

SUB RelFadeToPalStep (StartCol, EndCol, PalString$) STATIC

'This sub fades the current palette to the palette in the
'768 byte Palstring$
'in steps, so if you want to fade fully call this sub 64 times
'from StartColor to Endcolor ie, selective fade

PalI = PalI + 1

IF PalI > 63 THEN
        PalI = 0
        EXIT SUB
END IF


REDIM TempPalArray(2, 255) AS INTEGER      'Current pal

ColorVal = 0
FOR I% = 1 TO 768 STEP 3
    TempPalArray(0, ColorVal) = ASC(MID$(PalString$, I%, 1))
    TempPalArray(1, ColorVal) = ASC(MID$(PalString$, I% + 1, 1))
    TempPalArray(2, ColorVal) = ASC(MID$(PalString$, I% + 2, 1))
    ColorVal = ColorVal + 1
NEXT I%


IF StartCol > EndCol THEN SWAP StartCol, EndCol


FOR J = StartCol TO EndCol


        RelReadRGB J, RD, GN, BLL
        R% = TempPalArray(0, J)
        IF R% > RD THEN
                RD = RD + 1
        ELSEIF R% < RD THEN
                RD = RD - 1
        ELSE
                'Do nothing
        END IF

        G% = TempPalArray(1, J)
        IF G% > GN THEN
                GN = GN + 1
        ELSEIF G% < GN THEN
                GN = GN - 1
        ELSE
                'Do nothing
        END IF

        B% = TempPalArray(2, J)
        IF B% > BLL THEN
                BLL = BLL + 1
        ELSEIF B% < BLL THEN
                BLL = BLL - 1
        ELSE
                'Do nothing
        END IF

        RelWriteRGB J, RD, GN, BLL

NEXT J

ERASE TempPalArray


END SUB

SUB RelFadeToPalX (StartCol, EndCol, PalString$, Counts) STATIC

'This sub fades the current palette to the specified palette comtained
'in the 768 byte palstring$ form Start col to endcol
'ie selective fade
'counts is a nifty idea that lets you specify how many iterations
'to fade b4 it ends, cool huh?

TempPal$ = SPACE$(768)
RelReadPal TempPal$
REDIM TempPalArray(2, 255) AS SINGLE      'Current pal
REDIM TempPalArray2(2, 255) AS SINGLE     'PalString$ pal
REDIM FadePal(2, 255) AS SINGLE
DIM PalDiff AS SINGLE


ColorVal = 0
FOR I% = 1 TO 768 STEP 3
    TempPalArray(0, ColorVal) = ASC(MID$(TempPal$, I%, 1))
    TempPalArray(1, ColorVal) = ASC(MID$(TempPal$, I% + 1, 1))
    TempPalArray(2, ColorVal) = ASC(MID$(TempPal$, I% + 2, 1))
    ColorVal = ColorVal + 1
NEXT I%

ColorVal = 0
FOR I% = 1 TO 768 STEP 3
    TempPalArray2(0, ColorVal) = ASC(MID$(PalString$, I%, 1))
    TempPalArray2(1, ColorVal) = ASC(MID$(PalString$, I% + 1, 1))
    TempPalArray2(2, ColorVal) = ASC(MID$(PalString$, I% + 2, 1))
    ColorVal = ColorVal + 1
NEXT I%


IF Counts < 1 THEN Counts = 1

'Morphing algorithm used  yay!!!!
IF StartCol > EndCol THEN SWAP StartCol, EndCol
FOR I = StartCol TO EndCol
        PalDiff = TempPalArray2(0, I) - TempPalArray(0, I)
        FadePal(0, I) = PalDiff / Counts

        PalDiff = TempPalArray2(1, I) - TempPalArray(1, I)
        FadePal(1, I) = PalDiff / Counts

        PalDiff = TempPalArray2(2, I) - TempPalArray(2, I)
        FadePal(2, I) = PalDiff / Counts
NEXT I

FOR I = 1 TO Counts
        FOR J = StartCol TO EndCol
                TempPalArray(0, J) = TempPalArray(0, J) + FadePal(0, J)
                TempPalArray(1, J) = TempPalArray(1, J) + FadePal(1, J)
                TempPalArray(2, J) = TempPalArray(2, J) + FadePal(2, J)
        NEXT J

        WAIT &H3DA, 8, 8
        WAIT &H3DA, 8

        FOR J = StartCol TO EndCol
                OUT &H3C8, J
                OUT &H3C9, TempPalArray(0, J)
                OUT &H3C9, TempPalArray(1, J)
                OUT &H3C9, TempPalArray(2, J)
        NEXT J

NEXT I

ERASE TempPalArray
ERASE TempPalArray2
ERASE FadePal

END SUB

SUB RelFadeX (StartCol, EndCol, R, G, B, Counts) STATIC
'This sub fades the current palette to the specified RGB color
'from StartColor to Endcolor ie, selective fade
'counts is a nifty idea that lets you specify how many iterations
'to fade b4 it ends, cool huh?


TempPal$ = SPACE$(768)
RelReadPal TempPal$
REDIM TempPalArray(2, 255) AS SINGLE
REDIM FadePal(2, 255) AS SINGLE
DIM PalDiff AS SINGLE

ColorVal = 0

FOR I% = 1 TO 768 STEP 3
    TempPalArray(0, ColorVal) = ASC(MID$(TempPal$, I%, 1))
    TempPalArray(1, ColorVal) = ASC(MID$(TempPal$, I% + 1, 1))
    TempPalArray(2, ColorVal) = ASC(MID$(TempPal$, I% + 2, 1))
    ColorVal = ColorVal + 1
NEXT I%

IF Counts < 1 THEN Counts = 1
'Morphing algorithm used  yay!!!!
IF StartCol > EndCol THEN SWAP StartCol, EndCol

FOR I = StartCol TO EndCol
        PalDiff = R - TempPalArray(0, I)
        FadePal(0, I) = PalDiff / Counts

        PalDiff = G - TempPalArray(1, I)
        FadePal(1, I) = PalDiff / Counts

        PalDiff = B - TempPalArray(2, I)
        FadePal(2, I) = PalDiff / Counts
NEXT I

FOR I = 1 TO Counts
        FOR J = StartCol TO EndCol
                TempPalArray(0, J) = TempPalArray(0, J) + FadePal(0, J)
                TempPalArray(1, J) = TempPalArray(1, J) + FadePal(1, J)
                TempPalArray(2, J) = TempPalArray(2, J) + FadePal(2, J)
        NEXT J

        WAIT &H3DA, 8, 8
        WAIT &H3DA, 8

        FOR J = StartCol TO EndCol
                OUT &H3C8, J
                OUT &H3C9, TempPalArray(0, J)
                OUT &H3C9, TempPalArray(1, J)
                OUT &H3C9, TempPalArray(2, J)
        NEXT J

NEXT I

ERASE TempPalArray
ERASE FadePal

END SUB

SUB RelLoadPal (File$, PalString$, Switch) STATIC
'Loads a 768 pal to PalString$
'File$=File to load
'PalString$=768 byte pal
'Switch=Flag to switch the current pal to palstring$
'any non-zero for switch will change the current pal

 IF INSTR(File$, ".") = 0 THEN File$ = File$ + ".RGB"

    TempPal$ = SPACE$(768)

    FileNum% = FREEFILE
    OPEN File$ FOR BINARY AS #FileNum%
        GET #FileNum%, , TempPal$
    CLOSE #FileNum%

    IF LEN(TempPal$) <> 768 THEN EXIT SUB



IF Switch THEN

    OUT &H3C8, 0
    FOR I% = 1 TO 768 STEP 3
        OUT &H3C9, ASC(MID$(TempPal$, I%, 1))
        OUT &H3C9, ASC(MID$(TempPal$, I% + 1, 1))
        OUT &H3C9, ASC(MID$(TempPal$, I% + 2, 1))
    NEXT I%

END IF

PalString$ = TempPal$

END SUB

SUB RelLoadPalPP256 (File$) STATIC
'Loads and Switches the pal to PP256's pal
'Special thanks goes to Kackurot for this one. LOL

IF File$ = "" THEN
    FOR N = 0 TO 255
        READ C&
        B = C& \ 65536: C& = C& - B * 65536
        G = C& \ 256: C& = C& - G * 256
        R = C&
        OUT &H3C8, N
        OUT &H3C9, R
        OUT &H3C9, G
        OUT &H3C9, B
     NEXT

ELSE
IF INSTR(File$, ".") = 0 THEN File$ = LEFT$(File$, 8) + ".Pal"
OPEN File$ FOR BINARY AS #1
    FOR N = 0 TO 255
        GET #1, , C&
        B = C& \ 65536: C& = C& - B * 65536
        G = C& \ 256: C& = C& - G * 256
        R = C&
        OUT &H3C8, N
        OUT &H3C9, R
        OUT &H3C9, G
        OUT &H3C9, B
     NEXT
CLOSE
END IF

END SUB

SUB RelNegativePal STATIC

FOR I% = 0 TO 255

 RelReadRGB I%, R%, G%, B%
 RelWriteRGB I%, 63 - R%, 63 - G%, 63 - B%

NEXT I%

END SUB

SUB RelReadPal (PalString$) STATIC

TempPal$ = SPACE$(768)

OUT &H3C7, 0
FOR I% = 0 TO 255
  MID$(TempPal$, (I% * 3) + 1, 1) = CHR$(INP(&H3C9))
  MID$(TempPal$, (I% * 3) + 2, 1) = CHR$(INP(&H3C9))
  MID$(TempPal$, (I% * 3) + 3, 1) = CHR$(INP(&H3C9))
NEXT I%

PalString$ = TempPal$

END SUB

SUB RelReadRGB (ColorVal, R, G, B) STATIC
        OUT &H3C7, ColorVal
        R = INP(&H3C9)
        G = INP(&H3C9)
        B = INP(&H3C9)
END SUB

SUB RelRotatePalB (StartCol, EndCol) STATIC

IF StartCol > EndCol THEN SWAP StartCol, EndCol

REDIM TempPal(2, StartCol TO EndCol) AS INTEGER

FOR I = StartCol TO EndCol
        RelReadRGB I, TempPal(0, I), TempPal(1, I), TempPal(2, I)
NEXT I
FOR I = StartCol TO EndCol - 1
        SWAP TempPal(0, I), TempPal(0, I + 1)
        SWAP TempPal(1, I), TempPal(1, I + 1)
        SWAP TempPal(2, I), TempPal(2, I + 1)
NEXT I

FOR I = StartCol TO EndCol
        RelWriteRGB I, TempPal(0, I), TempPal(1, I), TempPal(2, I)
NEXT I
ERASE TempPal

END SUB

SUB RelRotatePalF (StartCol, EndCol) STATIC

IF StartCol > EndCol THEN SWAP StartCol, EndCol

REDIM TempPal(2, StartCol TO EndCol) AS INTEGER

FOR I = StartCol TO EndCol
        RelReadRGB I, TempPal(0, I), TempPal(1, I), TempPal(2, I)
NEXT I
FOR I = EndCol TO StartCol + 1 STEP -1
        SWAP TempPal(0, I), TempPal(0, I - 1)
        SWAP TempPal(1, I), TempPal(1, I - 1)
        SWAP TempPal(2, I), TempPal(2, I - 1)
NEXT I

FOR I = StartCol TO EndCol
        RelWriteRGB I, TempPal(0, I), TempPal(1, I), TempPal(2, I)
NEXT I

ERASE TempPal

END SUB

SUB RelSavePal (File$) STATIC

IF INSTR(File$, ".") = 0 THEN File$ = LEFT$(File$, 8) + ".Pal"

TempPal$ = SPACE$(768)

OUT &H3C7, 0
FOR I% = 0 TO 255
  MID$(TempPal$, (I% * 3) + 1, 1) = CHR$(INP(&H3C9))
  MID$(TempPal$, (I% * 3) + 2, 1) = CHR$(INP(&H3C9))
  MID$(TempPal$, (I% * 3) + 3, 1) = CHR$(INP(&H3C9))
NEXT I%

FileNum% = FREEFILE
OPEN File$ FOR BINARY AS #FileNum%
PUT #FileNum%, , TempPal$
CLOSE #FileNum%

END SUB

SUB RelSwitchToPal (PalString$) STATIC
TempPal$ = SPACE$(768)
TempPal$ = PalString$
    OUT &H3C8, 0
    FOR I% = 1 TO 768 STEP 3
        OUT &H3C9, ASC(MID$(TempPal$, I%, 1))
        OUT &H3C9, ASC(MID$(TempPal$, I% + 1, 1))
        OUT &H3C9, ASC(MID$(TempPal$, I% + 2, 1))
    NEXT I%

END SUB

SUB RelWriteRGB (ColorNum, R, G, B) STATIC
        OUT &H3C8, ColorNum
        OUT &H3C9, R
        OUT &H3C9, G
        OUT &H3C9, B
END SUB

