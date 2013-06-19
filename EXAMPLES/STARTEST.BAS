DECLARE SUB Load.Pal ()
' Real-Time Star Routines, by Adigun Azikwie Polack
' 24 June 2002 (UPDATED!!!)

DEFINT A-Z

'---------------------------------------------------------------------------
'Here are my Star Routines!!!  ;D

DECLARE SUB STARinit (Strmul%)
DECLARE SUB STARMotion (Lay%, Strmul%, Col%, Trans%)
DECLARE SUB STARmove (Strmul%, Dir%, Spd%)
'---------------------------------------------------------------------------


'$DYNAMIC
'$INCLUDE: 'rellib.bi'
CLEAR

DIM SHARED Layer%
REDIM SHARED Vpage(31999) AS INTEGER
DIM SHARED Pal AS STRING * 768

'---------------------------------------------------------------------------
'These commands are REQUIRED in order for these Star Routines to work
'                                                               properly!!!

REDIM SHARED S1!(30), S2!(30), S3!(30), S4!(30)
REDIM SHARED S5!(30), S6!(30), S7!(30), S8!(30)
REDIM SHARED SE1!(30), SE2!(30), SE3!(30), SE4!(30)
REDIM SHARED SE5!(30), SE6!(30), SE7!(30), SE8!(30)
'---------------------------------------------------------------------------

Layer% = VARSEG(Vpage(0))
RelKeyBoardON

RelInitVGA13
RelFfix

RelReadPal Pal
Load.Pal

RelDelay 60

'---------------------------------------------- About the "STARinit" command:

STARinit 29
'         
'         ÀÄÄÄÄÄÄÄÄÄThis is the number of star groups that you want to use.
'                   (one star group alone represents a group of 8 stars!)
'
' ****ALWAYS**** use this command FIRST before you even use the "STARmotion"
' and "STARmove" commands!!!  ;)
'----------------------------------------------------------------------------



DO

'-------------------------------------------- About the "STARmotion" command:

STARMotion Layer%, 29, 1, 0
'                      
'            ³      ³  ³  ÀÄÄÄThis is the transparent/opaque switch.
'            ³      ³  ³      (0 = Opaque; 1 = Transparent)
'            ³      ³  ³
'            ³      ³  ÀÄÄÄÄÄÄThis is the number that represents a color of
'            ³      ³         the stars within any 16-color spread of a
'            ³      ³         256-color palette (beyond the first 15 colors,
'            ³      ³         usually!)!
'            ³      ³
'            ³      ÀÄÄÄÄÄÄÄÄÄThis is the number of star groups that you want
'            ³                to use.
'            ³                (one star group alone represents a group of 8
'            ³                 stars!)
'            ³
'            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄThis is the layer position that you want to
'                             paste your stars in.
'
' T I P S : ----------------------------------------------------
'
' * It is recommended that you use this command before you use
'   the "STARmove" command.
'
' * While using this command, if you set the color number to -1,
'   then the stars will animate in random colors!
' --------------------------------------------------------------
'
'----------------------------------------------------------------------------



'---------------------------------------------- About the "STARmove" command:

STARmove 29, 2, 7
'             
'         ³  ³  ÀÄÄÄThis is the speed setting for the stars (0 to 300 only).
'         ³  ³      (Lower numbers = Lower Speeds;
'         ³  ³       higher numbers = Higher Speeds; 300 = MAXIMUM SPEED;
'         ³  ³       and 0 = NO speed)
'         ³  ³
'         ³  ÀÄÄÄÄÄÄThis is the direction switch for the stars.
'         ³         (1 = up, 2 = down, 3 = left, 4 = right)
'         ³
'         ÀÄÄÄÄÄÄÄÄÄThis is the number of star groups that you want to use.
'                   (one star group alone represents a group of 8 stars!)
'
' T I P S : ----------------------------------------------------
'
' * It is best to use the "STARmove" command AFTER you use the
'   "STARMotion" command, particularly when drawing your layers
'   and then putting your layers to the VIDEO buffer!
'
' * If you use this command to move in a horizontal direction
'   and IMMEDIATELY use that same command to move in a vertical
'   direction, then you have successfully have the potential of
'   moving the stars diagonally in a wild way!!!
'
' --------------------------------------------------------------
'
'----------------------------------------------------------------------------


IF RelKey%(KEYESC) THEN EXIT DO
IF RelKey%(KEYLEFT) THEN STARmove 29, 3, 25
IF RelKey%(KEYRIGHT) THEN STARmove 29, 4, 25


RelPrint Layer%, 1, 1, "---- Real-Time Star Routines ----", 16, 0
RelPrint Layer%, 0, 0, "---- Real-Time Star Routines ----", 24, 0
RelPrint Layer%, 41, 9, "by Adigun Azikwie POLACK", 16, 1
RelPrint Layer%, 40, 8, "by Adigun Azikwie POLACK", 24, 1

RelPrint Layer%, 1, 169, "Press LEFT and RIGHT keys to move those", 96, 0
RelPrint Layer%, 1, 177, "stars horizontally!", 96, 0
RelPrint Layer%, 0, 168, "Press LEFT and RIGHT keys to move those", 104, 0
RelPrint Layer%, 0, 176, "stars horizontally!", 104, 0

RelPrint Layer%, 1, 193, "Press [ESC] to exit this test.", 96, 0
RelPrint Layer%, 0, 192, "Press [ESC] to exit this test.", 104, 0

RelPCopy VIDEO, Layer%
RelCLS Layer%, 0
RelWait
LOOP

RelFade 0, 0, 0, 80
RelKeyBoardOFF

ENDPROGRAM:
RelInitText
COLOR 7: END



PaletteData: ' palette data. FJ pal this is.... :*)
DATA 0,2752512,10752,2763264,42,2752554,5418,2763306
DATA 1381653,4134165,1392405,4144917,1381695,4134207,1392447,4144959
DATA 0,328965,526344,723723,921102,1118481,1315860,1579032
DATA 1842204,2105376,2368548,2631720,2960685,3289650,3684408,4144959
DATA 0,4,8,12,16,21,25,29
DATA 33,37,42,46,50,54,58,63
DATA 0,262144,524288,786432,1048576,1376256,1638400,1900544
DATA 2162688,2424832,2752512,3014656,3276800,3538944,3801088,4128768
DATA 0,1024,2048,3072,4096,5376,6400,7424
DATA 8448,9472,10752,11776,12800,13824,14848,16128
DATA 0,262148,524296,786444,1048592,1376277,1638425,1900573
DATA 2162721,2424869,2752554,3014702,3276850,3538998,3801146,4128831
DATA 0,263168,526336,789504,1052672,1381632,1644800,1907968
DATA 2171136,2434304,2763264,3026432,3289600,3552768,3815936,4144896
DATA 0,1028,2056,3084,4112,5397,6425,7453
DATA 8481,9509,10794,11822,12850,13878,14906,16191
DATA 0,516,1032,1548,2064,2581,3097,3613
DATA 4385,4901,5418,5934,6450,6966,7482,8255
DATA 0,131076,262152,393228,524304,655381,786457,917533
DATA 1114145,1245221,1376298,1507374,1638450,1769526,1900602,2097215
DATA 0,262656,525312,787968,1050624,1378816,1641472,1904128
DATA 2167040,2429696,2757888,3020544,3283200,3545856,3808512,4136960
DATA 0,131844,263688,395532,527376,659477,791321,923165
DATA 1120545,1252389,1384490,1516334,1648178,1780022,1911866,2109503
DATA 0,131588,263176,394764,526352,657941,789529,921117
DATA 1118497,1250085,1381674,1513262,1644850,1776438,1908026,2105407
DATA 0,515,1030,1545,2060,2575,3090,3605
DATA 4376,4891,5406,5921,6436,6951,7466,8238
DATA 63,2103,4143,6183,8223,10008,12048,14088
DATA 16128,13833,11538,9243,6948,4653,2358,63
DATA 32,1058,2084,3110,4136,5418,6444,7470
DATA 8496,9522,10804,11830,12856,13882,14908,16191

REM $STATIC
SUB Load.Pal

RESTORE PaletteData
    FOR N = 0 TO 255
        READ C&
        B = C& \ 65536: C& = C& - B * 65536
        G = C& \ 256: C& = C& - G * 256
        R = C&
        OUT &H3C8, N
        OUT &H3C9, R
        OUT &H3C9, G
        OUT &H3C9, B
     NEXT N
END SUB

SUB STARinit (Strmul%)

FOR str% = 0 TO Strmul%
  S1!(str%) = INT(RND(1) * 200) + 1: SE1!(str%) = INT(RND(1) * 340) + 10
  S2!(str%) = INT(RND(1) * 200) + 1: SE2!(str%) = INT(RND(1) * 340) + 10
  S3!(str%) = INT(RND(1) * 200) + 1: SE3!(str%) = INT(RND(1) * 340) + 10
  S4!(str%) = INT(RND(1) * 200) + 1: SE4!(str%) = INT(RND(1) * 340) + 10
  S5!(str%) = INT(RND(1) * 200) + 1: SE5!(str%) = INT(RND(1) * 340) + 10
  S6!(str%) = INT(RND(1) * 200) + 1: SE6!(str%) = INT(RND(1) * 340) + 10
  S7!(str%) = INT(RND(1) * 200) + 1: SE7!(str%) = INT(RND(1) * 340) + 10
  S8!(str%) = INT(RND(1) * 200) + 1: SE8!(str%) = INT(RND(1) * 340) + 10
NEXT

END SUB

SUB STARMotion (Lay%, Strmul%, Col%, Trans%)
IF Col% > 0 THEN
  StrCOL1 = 6 + (16 * Col%)
  StrCOL2 = 7 + (16 * Col%)
  StrCOL3 = 8 + (16 * Col%)
  StrCOL4 = 9 + (16 * Col%)
  StrCOL5 = 10 + (16 * Col%)
  StrCOL6 = 11 + (16 * Col%)
  StrCOL7 = 13 + (16 * Col%)
  StrCOL8 = 15 + (16 * Col%)
  ELSEIF Col% = -1 THEN
  StrCOL1 = INT(RND(1) * 239) + 16
  StrCOL2 = INT(RND(1) * 239) + 16
  StrCOL3 = INT(RND(1) * 239) + 16
  StrCOL4 = INT(RND(1) * 239) + 16
  StrCOL5 = INT(RND(1) * 239) + 16
  StrCOL6 = INT(RND(1) * 239) + 16
  StrCOL7 = INT(RND(1) * 239) + 16
  StrCOL8 = INT(RND(1) * 239) + 16
END IF

FOR str% = 0 TO Strmul%
  IF Trans% = 0 THEN
    RelPset Lay%, SE1!(str%), S1!(str%), StrCOL1: RelPset Lay%, SE2!(str%), S2!(str%), StrCOL5
    RelPset Lay%, SE3!(str%), S3!(str%), StrCOL2: RelPset Lay%, SE4!(str%), S4!(str%), StrCOL6
    RelPset Lay%, SE5!(str%), S5!(str%), StrCOL3: RelPset Lay%, SE6!(str%), S6!(str%), StrCOL7
    RelPset Lay%, SE7!(str%), S7!(str%), StrCOL4: RelPset Lay%, SE8!(str%), S8!(str%), StrCOL8
  END IF
  IF Trans% >= 1 THEN
    RelPsetTrans Lay%, SE1!(str%), S1!(str%), StrCOL1: RelPsetTrans Lay%, SE2!(str%), S2!(str%), StrCOL5
    RelPsetTrans Lay%, SE3!(str%), S3!(str%), StrCOL2: RelPsetTrans Lay%, SE4!(str%), S4!(str%), StrCOL6
    RelPsetTrans Lay%, SE5!(str%), S5!(str%), StrCOL3: RelPsetTrans Lay%, SE6!(str%), S6!(str%), StrCOL7
    RelPsetTrans Lay%, SE7!(str%), S7!(str%), StrCOL4: RelPsetTrans Lay%, SE8!(str%), S8!(str%), StrCOL8
  END IF
NEXT

END SUB

SUB STARmove (Strmul%, Dir%, Spd%)

IF Spd% <= 0 THEN Spd% = 0
IF Spd% >= 300 THEN Spd% = 300

FOR str% = 0 TO Strmul%
  IF Dir% = 1 THEN
    S1!(str%) = S1!(str%) - (.01 * (Spd%)): IF S1!(str%) <= 0 THEN S1!(str%) = 220: SE1!(str%) = INT(RND(1) * 320) + 1
    S2!(str%) = S2!(str%) - (.02 * (Spd%)): IF S2!(str%) <= 0 THEN S2!(str%) = 220: SE2!(str%) = INT(RND(1) * 320) + 1
    S3!(str%) = S3!(str%) - (.03 * (Spd%)): IF S3!(str%) <= 0 THEN S3!(str%) = 220: SE3!(str%) = INT(RND(1) * 320) + 1
    S4!(str%) = S4!(str%) - (.04 * (Spd%)): IF S4!(str%) <= 0 THEN S4!(str%) = 220: SE4!(str%) = INT(RND(1) * 320) + 1
    S5!(str%) = S5!(str%) - (.05 * (Spd%)): IF S5!(str%) <= 0 THEN S5!(str%) = 220: SE5!(str%) = INT(RND(1) * 320) + 1
    S6!(str%) = S6!(str%) - (.06 * (Spd%)): IF S6!(str%) <= 0 THEN S6!(str%) = 220: SE6!(str%) = INT(RND(1) * 320) + 1
    S7!(str%) = S7!(str%) - (.07 * (Spd%)): IF S7!(str%) <= 0 THEN S7!(str%) = 220: SE7!(str%) = INT(RND(1) * 320) + 1
    S8!(str%) = S8!(str%) - (.08 * (Spd%)): IF S8!(str%) <= 0 THEN S8!(str%) = 220: SE8!(str%) = INT(RND(1) * 320) + 1
  END IF

  IF Dir% = 2 THEN
    S1!(str%) = S1!(str%) + (.01 * (Spd%)): IF S1!(str%) >= 210 THEN S1!(str%) = -0: SE1!(str%) = INT(RND(1) * 320) + 1
    S2!(str%) = S2!(str%) + (.02 * (Spd%)): IF S2!(str%) >= 210 THEN S2!(str%) = -0: SE2!(str%) = INT(RND(1) * 320) + 1
    S3!(str%) = S3!(str%) + (.03 * (Spd%)): IF S3!(str%) >= 210 THEN S3!(str%) = -0: SE3!(str%) = INT(RND(1) * 320) + 1
    S4!(str%) = S4!(str%) + (.04 * (Spd%)): IF S4!(str%) >= 210 THEN S4!(str%) = -0: SE4!(str%) = INT(RND(1) * 320) + 1
    S5!(str%) = S5!(str%) + (.05 * (Spd%)): IF S5!(str%) >= 210 THEN S5!(str%) = -0: SE5!(str%) = INT(RND(1) * 320) + 1
    S6!(str%) = S6!(str%) + (.06 * (Spd%)): IF S6!(str%) >= 210 THEN S6!(str%) = -0: SE6!(str%) = INT(RND(1) * 320) + 1
    S7!(str%) = S7!(str%) + (.07 * (Spd%)): IF S7!(str%) >= 210 THEN S7!(str%) = -0: SE7!(str%) = INT(RND(1) * 320) + 1
    S8!(str%) = S8!(str%) + (.08 * (Spd%)): IF S8!(str%) >= 210 THEN S8!(str%) = -0: SE8!(str%) = INT(RND(1) * 320) + 1
  END IF

  IF Dir% = 3 THEN
    SE1!(str%) = SE1!(str%) - (.01 * (Spd%)): IF SE1!(str%) <= -10 THEN SE1!(str%) = 340: S1!(str%) = INT(RND(1) * 200) + 1
    SE2!(str%) = SE2!(str%) - (.02 * (Spd%)): IF SE2!(str%) <= -10 THEN SE2!(str%) = 340: S2!(str%) = INT(RND(1) * 200) + 1
    SE3!(str%) = SE3!(str%) - (.03 * (Spd%)): IF SE3!(str%) <= -10 THEN SE3!(str%) = 340: S3!(str%) = INT(RND(1) * 200) + 1
    SE4!(str%) = SE4!(str%) - (.04 * (Spd%)): IF SE4!(str%) <= -10 THEN SE4!(str%) = 340: S4!(str%) = INT(RND(1) * 200) + 1
    SE5!(str%) = SE5!(str%) - (.05 * (Spd%)): IF SE5!(str%) <= -10 THEN SE5!(str%) = 340: S5!(str%) = INT(RND(1) * 200) + 1
    SE6!(str%) = SE6!(str%) - (.06 * (Spd%)): IF SE6!(str%) <= -10 THEN SE6!(str%) = 340: S6!(str%) = INT(RND(1) * 200) + 1
    SE7!(str%) = SE7!(str%) - (.07 * (Spd%)): IF SE7!(str%) <= -10 THEN SE7!(str%) = 340: S7!(str%) = INT(RND(1) * 200) + 1
    SE8!(str%) = SE8!(str%) - (.08 * (Spd%)): IF SE8!(str%) <= -10 THEN SE8!(str%) = 340: S8!(str%) = INT(RND(1) * 200) + 1
  END IF

  IF Dir% = 4 THEN
    SE1!(str%) = SE1!(str%) + (.01 * (Spd%)): IF SE1!(str%) >= 330 THEN SE1!(str%) = -20: S1!(str%) = INT(RND(1) * 200) + 1
    SE2!(str%) = SE2!(str%) + (.02 * (Spd%)): IF SE2!(str%) >= 330 THEN SE2!(str%) = -20: S2!(str%) = INT(RND(1) * 200) + 1
    SE3!(str%) = SE3!(str%) + (.03 * (Spd%)): IF SE3!(str%) >= 330 THEN SE3!(str%) = -20: S3!(str%) = INT(RND(1) * 200) + 1
    SE4!(str%) = SE4!(str%) + (.04 * (Spd%)): IF SE4!(str%) >= 330 THEN SE4!(str%) = -20: S4!(str%) = INT(RND(1) * 200) + 1
    SE5!(str%) = SE5!(str%) + (.04 * (Spd%)): IF SE5!(str%) >= 330 THEN SE5!(str%) = -20: S4!(str%) = INT(RND(1) * 200) + 1
    SE6!(str%) = SE6!(str%) + (.06 * (Spd%)): IF SE6!(str%) >= 330 THEN SE6!(str%) = -20: S6!(str%) = INT(RND(1) * 200) + 1
    SE7!(str%) = SE7!(str%) + (.07 * (Spd%)): IF SE7!(str%) >= 330 THEN SE7!(str%) = -20: S7!(str%) = INT(RND(1) * 200) + 1
    SE8!(str%) = SE8!(str%) + (.08 * (Spd%)): IF SE8!(str%) >= 330 THEN SE8!(str%) = -20: S8!(str%) = INT(RND(1) * 200) + 1
  END IF
NEXT

END SUB

