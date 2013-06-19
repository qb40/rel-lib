DEFINT A-Z
REM $INCLUDE: 'RelLib.BI'

SUB RelPrint (DestSeg, X, Y, Font$, Mincolor, Italic) STATIC

'=======Prints system fonts on screen  specified by X,Y
'=======Uses 8 colors from mincolor to Mincolor+8
'=======Font$ is the string, italic? Duh!!!!!
'=====Sample Code
        'Note Kgen....Min are constants
        'X = 261
        'Y = 183
        'Font$ = "RelSoft"
        'Italic = True
        'KgenFont X - 1, Y - 1, Font$, KgenGreenMin, Italic
        'KgenFont X, Y, Font$, KgenBlueMin, Italic
'End Sample
'======================================================

DIM E(7): E(0) = 1: FOR F = 1 TO 7: E(F) = E(F - 1) + E(F - 1): NEXT F

XXX = X%
YYY = Y%

IF X% = 320 THEN X% = 160 - (4 * LEN(Font$))




DEF SEG = &HFFA6
FOR A = 1 TO LEN(Font$)
KC = 0
IF Italic THEN
        Ita = 8
ELSE
        Ita = 0
END IF

 X = X + 8
 D = ASC(MID$(Font$, A, 1)) * 8 + 14
 FOR B = 0 TO 7
  FOR C = 0 TO 7
   IF PEEK(B + D) AND E(C) THEN RelPset DestSeg, ((X - C) + Ita), Y + B, Mincolor + KC
  NEXT C
        KC = KC MOD 8 + 1
           IF Italic THEN
                Ita = Ita - 1
           END IF
 NEXT B
NEXT A

DEF SEG

X = XXX
Y = YYY


END SUB

SUB RelPrintS (DestSeg, X, Y, Font$, Mincolor, Xscale, Yscale, Italic) STATIC

'=======Prints scalable system fonts on screen  specified by X,Y
'=======Uses 8 colors from mincolor to Mincolor+8
'=======Font$ is the string, italic? Duh!!!!!
'=======Xscale/Yscale are scale to enlarge the font
'=====Sample Code
        'Note Kgen....Min are constants
        'X = 261
        'Y = 183
        'Xscale=3
        'Yscale=2
        'Font$ = "RelSoft"
        'Italic = True
        'KgenTTFont X - 1, Y - 1, Font$, KgenGreenMin,Xscale,Yscale Italic
        'KgenTTFont X, Y, Font$, KgenBlueMin,,Xscale,Yscale Italic
'End Sample
'======================================================

DIM E(7): E(0) = 1: FOR F = 1 TO 7: E(F) = E(F - 1) + E(F - 1): NEXT F

XXX = X
YYY = Y
XSS = Xscale
YSS = Yscale

IF X = 320 THEN X = 160 - ((4 * Xscale * LEN(Font$)))



IF Italic THEN
        Ita = 8
ELSE
        Ita = 0
END IF


DEF SEG = &HFFA6
FOR A = 1 TO LEN(Font$)

KC = 0
YY = 0
XX = 0

 X = X + (8 * Xscale)
 D = ASC(MID$(Font$, A, 1)) * 8 + 14
 FOR B = 0 TO 7
        YY = YY + Yscale
        XX = 0
  FOR C = 0 TO 7
        IF PEEK(B + D) AND E(C) THEN RelBoxF DestSeg, (X - (C * Xscale)) + Ita, Y + YY, (X - (C * Xscale)) + Ita - (Xscale - 1), Y + YY + Yscale - 1, Mincolor + KC
        XX = XX + Xscale
  NEXT C
        KC = KC MOD 8 + 1

           IF Italic THEN
                Ita = Ita - 1
                IF Ita < 1 THEN Ita = 8
           END IF

 NEXT B

NEXT A

DEF SEG

X = XXX
Y = YYY
Xscale = XSS
Yscale = YSS

END SUB

SUB RelPrintTransS (DestSeg, X, Y, Font$, Mincolor, Xscale, Yscale, Italic) STATIC

'=======Prints scalable system fonts on screen  specified by X,Y
'translucently
'=======Uses 8 colors from mincolor to Mincolor+8
'=======Font$ is the string, italic? Duh!!!!!
'=======Xscale/Yscale are scale to enlarge the font
'=====Sample Code
        'Note Kgen....Min are constants
        'X = 261
        'Y = 183
        'Xscale=3
        'Yscale=2
        'Font$ = "RelSoft"
        'Italic = True
        'KgenTTFont X - 1, Y - 1, Font$, KgenGreenMin,Xscale,Yscale Italic
        'KgenTTFont X, Y, Font$, KgenBlueMin,,Xscale,Yscale Italic
'End Sample
'======================================================

DIM E(7): E(0) = 1: FOR F = 1 TO 7: E(F) = E(F - 1) + E(F - 1): NEXT F

XXX = X
YYY = Y
XSS = Xscale
YSS = Yscale

IF X = 320 THEN X = 160 - ((4 * Xscale * LEN(Font$)))



IF Italic THEN
        Ita = 8
ELSE
        Ita = 0
END IF


DEF SEG = &HFFA6
FOR A = 1 TO LEN(Font$)

KC = 0
YY = 0
XX = 0

 X = X + (8 * Xscale)
 D = ASC(MID$(Font$, A, 1)) * 8 + 14
 FOR B = 0 TO 7
        YY = YY + Yscale
        XX = 0
  FOR C = 0 TO 7
        IF PEEK(B + D) AND E(C) THEN RelBoxTransF DestSeg, (X - (C * Xscale)) + Ita, Y + YY, (X - (C * Xscale)) + Ita - (Xscale - 1), Y + YY + Yscale - 1, Mincolor + KC
        XX = XX + Xscale
  NEXT C
        KC = KC MOD 8 + 1

           IF Italic THEN
                Ita = Ita - 1
                IF Ita < 1 THEN Ita = 8
           END IF

 NEXT B

NEXT A

DEF SEG

X = XXX
Y = YYY
Xscale = XSS
Yscale = YSS

END SUB

