Hi,

RelLib is a Screen 13 game development lib for QB45(should also work
with QB71 and VB dos). Pls. Read RelLib.DOC for more details.
Use IE to View Rellib.HTM
Use Edit to View Relib.TXT



Eric 

PS.  The source for this LIB is open and you can use/abuse at your 
own risk. Don't forget to check out the example files.

/=======================================================
July. 16, 2004 (Version 5.0) 

Added:
1. RelTriF
2. RelTriG
3. RelPsetWu16
4. RelInsideT
5. RelTriT
6. RelTile2Xms
7. RelAddXmsTileIndex
8. RelXmsPut
9. RelXmsPutT
10. RelXmsPutC
11. RelXmsPutG
12. RelXmsPutS
/=======================================================
Sept. 16, 2003 (Version 4.2) beta.
****Sorry didn't finish writing the docs yet.
1. Added RelSphereMap
2. Added RelLens
3. Some example Files
4. GamaLineH
5. 3 docs. Wordpad version, HTML ver, and Edit Ver. ;*)



/=======================================================
Sept. 1 2003 (Version 4.1) beta.
1. Added Mode 7
2. Mode & map
3. RelPsetWU
4. RelSmooth

/=======================================================
July 9, 2003 (Version 4) beta.

1. 3 types of Docs. HTML, Wordpad, and pure text.
2. Added RelFindFiles

More Changes...June 30, 2003

1. Scrapped RelSpriteFlipV, RelspriteFlipH,
	RelSpriteFlipVH. to
	RELSPRITEFLIP which is all but you need to do 
	all the above routines.
2. RelSpriteFlipGAMMA
3. RelSpriteFlipTrans
4. Changed RelloadBMP to a Function
5. Added RelLoadPCX(also a Function)
	*error codes are in "RelLib.Doc"
6. Optimized some stuff.

	
Changes May 11, 2003 Ahh.. first update!!!
Happy Mom's day!!!!

1. Bugfix for RelGet.
2. Added:
	A) RelSpriteFlipH
	B) RelSpriteFlipV
	C) RelSpriteFlipVH	
	D) RelWrapX
	E) RelWrapY
	F) RelWater
	G) RelRefrac
	H) RelShadowPut
	I) RelHilitePut
3. Made RelBoxF and RelBoxTransF support true clipping
	and they are faster than ever!!!

/======================================================	
Changes November 6, 2002
Optimized RelLoadBMP by 1000% ;*)
Changed the calling convention to....
DECLARE SUB RelLoadBMP (DESTSEG%, File$, SwitchPal%)
sorry....

/======================================================	
Update!!!!!
June 25,2002
added RelFfix

/======================================================	
August ??, 2002
Xms Routines

September 22,2002
Added RelAngle


/=======================================================
Update!!!!
Ver 2.0(Joakim's version)

1. RelSpriteOnSprite
	*transparent PUT routine but uses the normal QB GET/PUT array
	as a destination so you can use your normal get/put array as 
	a double buffer. This is also autoclipped and as fast as 
	RelSprite. See example file(SpriteON.Bas)
2. RelSpriteOnSpriteS
	*Same as RelSpriteOnSprite but puts the sprite Solidly.
	Almost as fast as RelSpriteSolid
3. RelCollideSpr
	*An extremely fast PIXEL-Perfect collision detection.  I can't
	Notice an FPS decrease on my RPG engine when I used this 
	Instead of RelCollideSprB on a 486.  Pls. See Collide.EXE/BAS
	on the Examples folder.
4. RelPsetOnSprite
	*Psets a pixel on a QB get/put array
5. RelPsetOnSpriteT
	*Psets a pixel on a QB get/put array, Translucently.
6. RelPointOnSprite
	*Returns the color of the pixel on the get/put array.

/======================================================================
VER 1.1

What's New since the last update at QB45.com

1. Diagonal Line Routine(Normal and Translucent)
2. Sprite Rotations(Normal and Translucent)
3. RelInside, RelInsideC which are used for range checking in RPGs
4. Byte size variable emulators along with an example(Bytesamp.bas)
	RelAddHi
	RelAddLow
	RelGetHi
	RelGetLow
5. RelMouseReset
More or less 10 procedures. ;*)





