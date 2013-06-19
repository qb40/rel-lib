DEFINT A-Z


DECLARE SUB RelTriF (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL x3%, BYVAL y3%, BYVAL C%)
DECLARE SUB RelTriFTrans (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL x3%, BYVAL y3%, BYVAL C%)
DECLARE SUB RelTriG (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL c1%, BYVAL x2%, BYVAL y2%, BYVAL c2%, BYVAL x3%, BYVAL y3%, BYVAL c3%)
DECLARE SUB RelTriT (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL u1%, BYVAL v1%, BYVAL x2%, BYVAL y2%, BYVAL u2%, BYVAL v2%, BYVAL x3%, BYVAL y3%, BYVAL u3%, BYVAL v3%, BYVAL Tseg%, BYVAL Toff%)
'/======================SCREEN SWITCHING===================================
DECLARE SUB RelInitText ()
DECLARE SUB RelInitVGA13 ()
'/======================SCREEN BUFFER======================================
DECLARE SUB RelPCopy (BYVAL DestSeg%, BYVAL SrcSeg%)
DECLARE SUB RelPcopyTrans (BYVAL DestSeg%, BYVAL SrcSeg%)
DECLARE SUB RelPcopyTransB (BYVAL DestSeg%, BYVAL SrcSeg%)
DECLARE SUB RelPcopyBlended (BYVAL DestSeg%, BYVAL SrcSeg%)
DECLARE SUB RelPCopySF (BYVAL DestSeg%, BYVAL SrcSeg%)
DECLARE SUB RelPCopyGamma (BYVAL DestSeg%, BYVAL SrcSeg%, BYVAL GammaVal%)
DECLARE SUB RelCompress (BYVAL DestSeg%, BYVAL DestOff%, BYVAL SrcSeg%)
DECLARE SUB RelCLS (BYVAL DestSeg%, BYVAL C%)
DECLARE SUB RelPageSwap (BYVAL DestSeg%, BYVAL SrcSeg%)
DECLARE SUB RelCopyLineH (BYVAL DestSeg%, BYVAL SrcSeg%, BYVAL Ypos%)
DECLARE SUB RelCopyLineV (BYVAL DestSeg%, BYVAL SrcSeg%, BYVAL Xpos%)
DECLARE SUB RelCopyBlock (BYVAL DestSeg%, BYVAL SrcSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%)
DECLARE SUB RelGammaBlock (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL GammaVal%)
DECLARE SUB RelWrapX (BYVAL DestSeg%, BYVAL SrcSeg%, BYVAL x%)
'/======================DRAWING PRIMITIVES=================================
DECLARE SUB RelPset (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL C%)
DECLARE SUB RelPsetF (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL C%)
DECLARE SUB RelPsetTrans (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL C%)
DECLARE SUB RelBoxF (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL C%)
DECLARE SUB RelBoxTransF (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL C%)
DECLARE SUB RelBox (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL C%)
DECLARE SUB RelBoxTrans (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL C%)
DECLARE SUB RelLine (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL C%)
DECLARE SUB RelLineTrans (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL C%)
DECLARE SUB RelLineH (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL C%)
DECLARE SUB RelLineV (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL y2%, BYVAL C%)
DECLARE SUB RelLineTransV (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL y2%, BYVAL C%)
DECLARE SUB RelLineTransH (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL C%)
'/======================SPRITE=============================================
DECLARE SUB RelSprite (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%)
DECLARE SUB RelSpriteSolid (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%)
DECLARE SUB RelSpriteFast (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%)
DECLARE SUB RelSpriteTrans (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%)
DECLARE SUB RelSpriteSF (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%)
DECLARE SUB RelSpriteColor (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%, BYVAL C%)
DECLARE SUB RelSpriteColorX (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%, BYVAL C%, BYVAL STARTC%)
DECLARE SUB RelSpriteSolidX (BYVAL DestSeg%, BYVAL SrcSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL NewX%, BYVAL NewY%)
DECLARE SUB RelSpriteGamma (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%, BYVAL GammaVal%)
DECLARE SUB RelSpriteRotate (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL Angle%, BYVAL SprSeg%, BYVAL SprOff%)
DECLARE SUB RelSpriteRotateTrans (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL Angle%, BYVAL SprSeg%, BYVAL SprOff%)
DECLARE SUB RelSpriteFlip (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%, BYVAL Flipmode%)
DECLARE SUB RelSpriteFlipT (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%, BYVAL Flipmode%)
DECLARE SUB RelSpriteFlipG (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%, BYVAL Flipmode%, BYVAL GammaVal%)
DECLARE SUB RelSpriteFlipC (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%, BYVAL Flipmode%, BYVAL Clr%)
DECLARE SUB RelGet (BYVAL DestSeg%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL SprSeg%, BYVAL SprOff%)
'/======================COLLISION DETECTION=================================
DECLARE FUNCTION RelCollide% (BYVAL DestSeg%, BYVAL x%, BYVAL y%, BYVAL SPRITESEGMENT%, BYVAL SPRITEOFFSET%)
DECLARE FUNCTION RelCollideSpr% (BYVAL SPR1X%, BYVAL SPR1Y%, BYVAL SPR1SEGMENT%, BYVAL SPR1OFFSET%, BYVAL SPR2X%, BYVAL SPR2Y%, BYVAL SPR2SEGMENT%, BYVAL SPR2OFFSET%)
DECLARE FUNCTION RelCollideSprB% (BYVAL SPR1X%, BYVAL SPR1Y%, BYVAL SPR1SEGMENT%, BYVAL SPR1OFFSET%, BYVAL SPR2X%, BYVAL SPR2Y%, BYVAL SPR2SEGMENT%, BYVAL SPR2OFFSET%)
'/======================KEYBOARD============================================
DECLARE SUB RelKeyBoardON ()
DECLARE SUB RelKeyBoardOFF ()
DECLARE FUNCTION RelKey% (BYVAL Scancode%)
'/======================FONT================================================
DECLARE SUB RelPrint (DestSeg%, x%, y%, Font$, Mincolor%, Italic%)
DECLARE SUB RelPrintS (DestSeg%, x%, y%, Font$, Mincolor%, Xscale%, Yscale%, Italic%)
DECLARE SUB RelPrintTransS (DestSeg%, x%, y%, Font$, Mincolor%, Xscale%, Yscale%, Italic%)
DECLARE SUB RelScoreTrans256 (DestSeg%, x%, y%, Score&, Centered%, FontArray%(), FontArrayIndex%())
DECLARE SUB RelScore256 (DestSeg%, x%, y%, Score&, Centered%, FontArray%(), FontArrayIndex%())
DECLARE SUB RelFontFixedT256 (DestSeg%, x%, y%, Text$, Centered%, FontArray%(), FontArrayIndex%())
DECLARE SUB RelFontFixed256 (DestSeg%, x%, y%, Text$, Centered%, FontArray%(), FontArrayIndex%())
DECLARE SUB RelFontTrans256 (DestSeg%, x%, y%, Text$, Centered%, FontArray%(), FontArrayIndex%())
DECLARE SUB RelFont256 (DestSeg%, x%, y%, Text$, Centered%, FontArray%(), FontArrayIndex%())
DECLARE SUB RelScoreGamma256 (DestSeg%, x%, y%, Score&, Centered%, GammaVal%, FontArray%(), FontArrayIndex%())
DECLARE SUB RelFontGamma256 (DestSeg%, x%, y%, Text$, Centered%, GammaVal%, FontArray%(), FontArrayIndex%())
'/======================MEMORY==============================================
DECLARE SUB RelMemCopy (BYVAL DestSeg%, BYVAL DestOff%, BYVAL SrcSeg%, BYVAL SrcOff%, BYVAL NumBytes%)
DECLARE SUB RelAddHI (BYVAL SEGINTVAL%, BYVAL OFFINTVAL%, BYVAL BYTEVAL%)
DECLARE SUB RelAddLOW (BYVAL SEGINTVAL%, BYVAL OFFINTVAL%, BYVAL BYTEVAL%)
DECLARE FUNCTION RelGetHI (BYVAL Intval%)
DECLARE FUNCTION RelGetLow (BYVAL Intval%)
'/======================MOUSE===============================================
DECLARE SUB RelMouseShow ()
DECLARE SUB RelMouseHide ()
DECLARE SUB RelMouseReset ()
DECLARE SUB RelMouseLimitXY (BYVAL MinX%, BYVAL MinY%, BYVAL MaxX%, BYVAL MaxY%)
DECLARE SUB RelMouseSetXY (BYVAL x%, BYVAL y%)
DECLARE FUNCTION RelMouseX% ()
DECLARE FUNCTION RelMouseY% ()
DECLARE FUNCTION RelMouseClick% ()
DECLARE FUNCTION RelMouseDetect% ()
DECLARE FUNCTION RelMouseInside (BYVAL MinX%, BYVAL MinY%, BYVAL MaxX%, BYVAL MaxY%)
'/======================IMAGES==============================================
DECLARE FUNCTION RelLoadBMP% (Layer%, x%, y%, File$, Pal$, SwitchPal%)
DECLARE FUNCTION RelLoadPCX% (Layer%, x%, y%, File$, Pal$, SwitchPal%)
'/======================PALETTES============================================
DECLARE SUB RelReadRGB (ColorVal%, R%, G%, B%)
DECLARE SUB RelWriteRGB (ColorNum%, R%, G%, B%)
DECLARE SUB RelReadPal (PalString$)
DECLARE SUB RelFade (R%, G%, B%, Counts%)
DECLARE SUB RelFadeStep (StartCol%, EndCol%, R%, G%, B%)
DECLARE SUB RelFadeToPal (PalString$, Counts%)
DECLARE SUB RelFadeToPalStep (StartCol%, EndCol%, PalString$)
DECLARE SUB RelFadeToPalX (StartCol%, EndCol%, PalString$, Counts%)
DECLARE SUB RelFadeX (StartCol%, EndCol%, R%, G%, B%, Counts%)
DECLARE SUB RelLoadPal (File$, PalString$, Switch%)
DECLARE SUB RelLoadPalPP256 (File$)
DECLARE SUB RelNegativePal ()
DECLARE SUB RelRotatePalB (StartCol%, EndCol%)
DECLARE SUB RelRotatePalF (StartCol%, EndCol%)
DECLARE SUB RelSavePal (File$)
DECLARE SUB RelSwitchToPal (PalString$)

'/======================OnSprite SUBS/FUNCTION==============================
'Special procedures Allegro Style!!! Joakim's subs :*)
DECLARE SUB RelPsetOnSprite (BYVAL DESTSprSEG%, BYVAL DESTSprOFF%, BYVAL x%, BYVAL y%, BYVAL C%)
DECLARE SUB RelPsetOnSpriteT (BYVAL DESTSprSEG%, BYVAL DESTSprOFF%, BYVAL x%, BYVAL y%, BYVAL C%)
DECLARE SUB RelSpriteOnSprite (BYVAL DESTSprSEG%, BYVAL DESTSprOFF%, BYVAL x%, BYVAL y%, BYVAL SprSeg%, BYVAL SprOff%)
DECLARE SUB RelSpriteOnSpriteS (BYVAL DESTSprSEG%, BYVAL DESTSprOFF%, BYVAL x%, BYVAL y%, BYVAL SprSeg%, BYVAL SprOff%)
DECLARE FUNCTION RelPointOnSprite% (BYVAL DESTSprSEG%, BYVAL DESTSprOFF%, BYVAL x%, BYVAL y%)

'/======================XMS SUBS/FUNCTION===================================
DECLARE FUNCTION RelXmsInit% ()
DECLARE FUNCTION RelXmsGetFree& ()
DECLARE FUNCTION RelXmsGetTotal& ()
DECLARE FUNCTION RelXmsAllocate% (BYVAL AmountKbs&)
DECLARE SUB RelXmsDeallocate (BYVAL xmsHandle%)
DECLARE SUB RelXMSFromBase (BYVAL BaseSeg%, BYVAL BaseOFF&, BYVAL xmsHandle%, BYVAL XMSOffset&, BYVAL Length&)
DECLARE SUB RelXMStoBase (BYVAL BaseSeg%, BYVAL BaseOFF&, BYVAL xmsHandle%, BYVAL XMSOffset&, BYVAL Length&)
DECLARE SUB RelXMSPut (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL SprSeg%, BYVAL SprOff%, BYVAL Flipmode%, BYVAL DummySeg%, BYVAL xmsHandle%)
DECLARE SUB RelXMSPutT (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL SprSeg%, BYVAL SprOff%, BYVAL Flipmode%, BYVAL DummySeg%, BYVAL xmsHandle%)
DECLARE SUB RelXMSPutC (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL SprSeg%, BYVAL SprOff%, BYVAL Flipmode%, BYVAL Clr%, BYVAL DummySeg%, BYVAL xmsHandle%)
DECLARE SUB RelXMSPutG (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL SprSeg%, BYVAL SprOff%, BYVAL Flipmode%, BYVAL Gamma%, BYVAL DummySeg%, BYVAL xmsHandle%)
DECLARE SUB RelXMSPutS (BYVAL Layer%, BYVAL x%, BYVAL y%, BYVAL SprSeg%, BYVAL SprOff%, BYVAL DummySeg%, BYVAL xmsHandle%)
DECLARE SUB RelAddXMSTileIndex (DestTile() AS ANY, SourceTile() AS ANY)
DECLARE SUB RelTile2Xms (Filename$, Tile() AS ANY, xmsHandle%, XmsStartOFF&, XmsEndOFF&)
DECLARE SUB RelFontXms (DestSeg%, x%, y%, Text$, Centered%, XmsFont() AS ANY, Flipmode%, xmsHandle%)
'/======================Misc GFX============================================
DECLARE SUB RelWater (BYVAL DestSeg%, BYVAL SourceSeg%)
DECLARE SUB RelSmooth (BYVAL Layer%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%)
DECLARE SUB RelPsetWu (Layer%, x!, y!, Clr%)
DECLARE SUB RelPsetWu16 (Layer%, x!, y!, Clr%)
DECLARE SUB RelLensMap (Dest%, Src%, x%, y%, Radius%, sheight%, Mode%)
DECLARE SUB RelSphereMap (Layer%, x%, y%, xoff%, yoff%, Radius%, sheight%, Image%(), ImageOffs%, Mode%)
'/======================Mode 7================================================
DECLARE SUB RelMode7Map (Layer%, x1%, y1%, x2%, y2%, Angle%, scalex%, scaley%, scalez%, Horz%, camx!, camy!, Texture%(), TextureOffset%, Map%())
DECLARE SUB RelMode7 (Layer%, x1%, y1%, x2%, y2%, Angle%, scalex%, scaley%, scalez%, Horz%, camx!, camy!, Texture%(), TextureOffset%)
'/======================FUNCTIONS===========================================
DECLARE FUNCTION RelSize% (BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%)
DECLARE FUNCTION RelPoint% (BYVAL DestSeg%, BYVAL x%, BYVAL y%)
DECLARE FUNCTION RelInside% (BYVAL x%, BYVAL y%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%)
DECLARE FUNCTION RelInsideC% (BYVAL x%, BYVAL y%, BYVAL XC%, BYVAL YC%, BYVAL Radius%)
DECLARE FUNCTION RelAngle% (BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%)
DECLARE FUNCTION RelInsideT% (BYVAL x%, BYVAL y%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL x3%, BYVAL y3%)
'/======================File================================================
DECLARE FUNCTION RelFindFile$ (Mask$, Attribute%)
'/======================MISC================================================
DECLARE SUB RelWait ()
DECLARE SUB RelDelay (BYVAL Msec%)
DECLARE SUB RelFfix ()

'/======================CONSTANTS===========================================
'KEY CONSTANTS
CONST KEYESC = 1, KEYENTER = 28, KEYSPACE = 57, KEYTAB = &HF
CONST KEYUP = 72, KEYDOWN = 80, KEYLEFT = 75, KEYRIGHT = 77

'Of course!!!!! :)
CONST FALSE = 0, TRUE = NOT FALSE
CONST VIDEO = &HA000

'FlipMode(for use with RelSpriteFlip)
CONST FLIPNONE = 0, FLIPH = 1, FLIPV = 2, FLIPVH = 3

'File Find
CONST VOLUMELABEL = &H8, DIRECTORY = &H10, ARCHIVE = &H20
CONST READONLY = &H1, HIDDEN = &H2, SYSTEMFILE = &H4
                                             
'misc...

'Type for xms base sprite routines.
'8 bytes per sprite no matter how big it is.

TYPE XmsTileIndexType
    Bytes   AS LONG
    offs    AS LONG
END TYPE


