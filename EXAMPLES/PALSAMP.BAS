DEFINT A-Z

'$INCLUDE: 'RelLib.Bi'

'Palette Samples

DIM SHARED RGBpal AS STRING * 768
DIM SHARED Path$

Path$ = "C:\Qbasic\RelLib\Examples\"
'Path$ = ""

RANDOMIZE TIMER
CLS
RelInitVGA13

RelFade 0, 0, 0, 0                 'Hide build of GFX

RelLoadPal Path$ + "RelPal.Pal", RGBpal, FALSE

FOR I = 0 TO 98
        RelBox VIDEO, I, I, 319 - I, 199 - I, 32 + I
NEXT I

RelPrint VIDEO, 0, 0, "Fade/FadeToPal/RotatePalF|B/NegativePal", 24, TRUE

IF RelMouseDetect THEN RelMouseShow


RelFadeToPal RGBpal, 80


RelFade INT(RND * 64), INT(RND * 64), INT(RND * 64), 80

RelFadeToPal RGBpal, 80

C$ = INPUT$(1)
RelNegativePal
C$ = INPUT$(1)
RelSwitchToPal RGBpal

DO
        RelRotatePalF 32, 255
        RelWait
LOOP UNTIL INKEY$ <> ""

DO
        RelRotatePalB 32, 255
        RelWait
LOOP UNTIL INKEY$ <> ""



RelInitText

END






