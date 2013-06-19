REM $INCLUDE: 'RelLib.BI'

DEFINT A-Z
SUB RelFont256 (DestSeg%, X%, Y%, Text$, Centered%, FontArray(), FontArrayIndex()) STATIC
FontSeg% = VARSEG(FontArray(1))
IF NOT Centered% THEN

        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSprite DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + (FontArray(FontArrayIndex(FontChar%)) \ 8)
        NEXT I%

ELSE            'Centered

        StrLen% = 0
        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                StrLen% = StrLen% + (FontArray(FontArrayIndex(FontChar%)))
        NEXT I%
        StrLen% = StrLen% \ 8  'Calculate length
        X% = (320 - StrLen%) \ 2
        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSprite DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + (FontArray(FontArrayIndex(FontChar%)) \ 8)
        NEXT I%

END IF

END SUB

SUB RelFontFixed256 (DestSeg%, X%, Y%, Text$, Centered%, FontArray(), FontArrayIndex()) STATIC
FontSeg% = VARSEG(FontArray(1))
Spacing% = 0   'Calculate fixed spacing
Spacing% = FontArray(FontArrayIndex(1)) \ 8
IF NOT Centered% THEN

        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSprite DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + Spacing%
        NEXT I%

ELSE            'Centered
        StrLen% = 0
        StrLen% = Spacing% * LEN(Text$)
        X% = (320 - StrLen%) \ 2
        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSprite DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + Spacing%
        NEXT I%

END IF

END SUB

SUB RelFontFixedT256 (DestSeg%, X%, Y%, Text$, Centered%, FontArray(), FontArrayIndex()) STATIC

FontSeg% = VARSEG(FontArray(1))
Spacing% = 0   'Calculate fixed spacing
Spacing% = FontArray(FontArrayIndex(1)) \ 8
IF NOT Centered% THEN

        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSpriteTrans DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + Spacing%
        NEXT I%

ELSE            'Centered
        StrLen% = 0
        StrLen% = Spacing% * LEN(Text$)
        X% = (320 - StrLen%) \ 2
        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSpriteTrans DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + Spacing%
        NEXT I%

END IF


END SUB

SUB RelFontTrans256 (DestSeg%, X%, Y%, Text$, Centered%, FontArray(), FontArrayIndex()) STATIC
FontSeg% = VARSEG(FontArray(1))
IF NOT Centered% THEN

        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSpriteTrans DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + (FontArray(FontArrayIndex(FontChar%)) \ 8)
        NEXT I%

ELSE            'Centered

        StrLen% = 0
        FOR I% = 1 TO LEN(Text$)   'get font length
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                StrLen% = StrLen% + (FontArray(FontArrayIndex(FontChar%)))
        NEXT I%
        StrLen% = StrLen% \ 8  'Calculate length
        X% = (320 - StrLen%) \ 2
        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSpriteTrans DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + (FontArray(FontArrayIndex(FontChar%)) \ 8)
        NEXT I%

END IF

END SUB

SUB RelScore256 (DestSeg%, X%, Y%, Score&, Centered%, FontArray%(), FontArrayIndex%()) STATIC
FontSeg% = VARSEG(FontArray(1))
Spacing% = 0   'Calculate fixed spacing
Spacing% = FontArray(FontArrayIndex(1)) \ 8

'===Add Commas
Text$ = RTRIM$(LTRIM$(STR$(Score&)))

L = LEN(Text$)
Temp$ = ""
II = 0

FOR I = L TO 1 STEP -1
        I$ = MID$(Text$, I, 1)

        IF II = 3 THEN
                Temp$ = Temp$ + "," + I$
        ELSE
                Temp$ = Temp$ + I$
        END IF
        II = (II MOD 3) + 1

NEXT I

'Reverse it

L = LEN(Temp$)
Temp2$ = ""

FOR I = L TO 1 STEP -1
        I$ = MID$(Temp$, I, 1)
        Temp2$ = Temp2$ + I$
NEXT I

Text$ = LTRIM$(RTRIM$(Temp2$))

'Print it
IF NOT Centered% THEN

        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSprite DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + Spacing%
        NEXT I%

ELSE            'Centered
        StrLen% = 0
        StrLen% = Spacing% * LEN(Text$)
        X% = (320 - StrLen%) \ 2
        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSprite DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + Spacing%
        NEXT I%

END IF

END SUB

SUB RelScoreTrans256 (DestSeg%, X%, Y%, Score&, Centered%, FontArray%(), FontArrayIndex%()) STATIC
FontSeg% = VARSEG(FontArray(1))
Spacing% = 0   'Calculate fixed spacing
Spacing% = FontArray(FontArrayIndex(1)) \ 8

'===Add Commas
Text$ = RTRIM$(LTRIM$(STR$(Score&)))

L = LEN(Text$)
Temp$ = ""
II = 0

FOR I = L TO 1 STEP -1
        I$ = MID$(Text$, I, 1)

        IF II = 3 THEN
                Temp$ = Temp$ + "," + I$
        ELSE
                Temp$ = Temp$ + I$
        END IF
        II = (II MOD 3) + 1

NEXT I

'Reverse it

L = LEN(Temp$)
Temp2$ = ""

FOR I = L TO 1 STEP -1
        I$ = MID$(Temp$, I, 1)
        Temp2$ = Temp2$ + I$
NEXT I

Text$ = LTRIM$(RTRIM$(Temp2$))

'Print it
IF NOT Centered% THEN

        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSpriteTrans DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + Spacing%
        NEXT I%

ELSE            'Centered
        StrLen% = 0
        StrLen% = Spacing% * LEN(Text$)
        X% = (320 - StrLen%) \ 2
        FOR I% = 1 TO LEN(Text$)
                FontChar% = ASC(MID$(Text$, I%, 1)) - 31
                RelSpriteTrans DestSeg%, X%, Y%, FontSeg%, VARPTR(FontArray(FontArrayIndex(FontChar)))
                X% = X% + Spacing%
        NEXT I%

END IF


END SUB

