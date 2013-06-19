DECLARE SUB LoadPal ()
DECLARE SUB InitImageData (FileName$, ImageArray%())
DECLARE SUB MakeImageIndex (ImageArray%(), IndexArray%())
DEFINT A-Z

REM $INCLUDE: 'RelLib.BI'

REDIM SHARED Vpage(31999) AS INTEGER

REDIM SHARED Font(1 TO 1) AS INTEGER
REDIM SHARED FontIndex(1 TO 1) AS INTEGER
REDIM SHARED FontPP(1 TO 1) AS INTEGER
REDIM SHARED FontPPIndex(1 TO 1) AS INTEGER
DIM SHARED RGBpal AS STRING * 768
DIM SHARED Path$


CLS
RelInitVGA13
RelCLS VARSEG(Vpage(0)), 0

Path$ = "C:\Qbasic\RelLib\Examples\"
'Path$ = ""

RelLoadPal Path$ + "RelPal.Pal", RGBpal, TRUE

File$ = Path$ + "SIfntDG.Put"
InitImageData File$, Font()
MakeImageIndex Font(), FontIndex()

File$ = Path$ + "EX-Fnt01.Put"
InitImageData File$, FontPP()
MakeImageIndex FontPP(), FontPPIndex()

RelFont256 VARSEG(Vpage(0)), 10, 50, "Press A Key:", TRUE, Font(), FontIndex()

RelFontTrans256 VARSEG(Vpage(0)), 10, 70, "Fonts by Adigun Polack", TRUE, Font(), FontIndex()
RelFontGamma256 VARSEG(Vpage(0)), 10, 80, "Fonts by Adigun Polack", TRUE, 6, Font(), FontIndex()
RelFontGamma256 VARSEG(Vpage(0)), 10, 90, "Fonts by Adigun Polack", TRUE, -6, Font(), FontIndex()

IF RelMouseDetect THEN
        RelFont256 VARSEG(Vpage(0)), 10, 150, "Mouse Detected", TRUE, Font(), FontIndex()
ELSE
        RelFont256 VARSEG(Vpage(0)), 10, 150, "No Mouse Detected", TRUE, Font(), FontIndex()
END IF
RelPCopy VIDEO, VARSEG(Vpage(0))
RelMouseShow
C$ = INPUT$(1)

FOR X = 0 TO 319
        C = C MOD 255 + 1
FOR Y = 0 TO 199
        RelPset VARSEG(Vpage(0)), X, Y, C
NEXT Y
NEXT X



RelFont256 VARSEG(Vpage(0)), 20, 50, "Fonts by Adigun Polack", FALSE, Font(), FontIndex()
RelFont256 VARSEG(Vpage(0)), 20, 60, "Greets to EEBRO and BETA_SS", FALSE, FontPP(), FontPPIndex()
RelFontFixedT256 VARSEG(Vpage(0)), 10, 190, "Anya Therese B. Lope", TRUE, Font(), FontIndex()


Score& = 1999999999
RelScore256 VARSEG(Vpage(0)), 10, 100, Score&, TRUE, Font(), FontIndex()
RelScoreTrans256 VARSEG(Vpage(0)), 0, 110, Score&, TRUE, Font(), FontIndex()
RelScoreGamma256 VARSEG(Vpage(0)), 0, 110, Score&, TRUE, 6, Font(), FontIndex()
RelScoreGamma256 VARSEG(Vpage(0)), 0, 120, Score&, TRUE, -6, Font(), FontIndex()
RelMouseLimitXY 100, 90, 250, 150
RelBox VARSEG(Vpage(0)), 100, 90, 250, 150, 15
RelMouseHide
RelPCopy VIDEO, VARSEG(Vpage(0))
RelMouseShow
DO
        XX = RelMouseX
        YY = RelMouseY
        RelBoxF VARSEG(Vpage(0)), 0, 0, 150, 30, 0
        RelFont256 VARSEG(Vpage(0)), 0, 0, "MouseX=" + STR$(XX), FALSE, Font(), FontIndex()
        RelFont256 VARSEG(Vpage(0)), 0, 10, "MouseY=" + STR$(YY), FALSE, Font(), FontIndex()
        RelFont256 VARSEG(Vpage(0)), 0, 20, "MouseB=" + STR$(RelMouseClick), FALSE, Font(), FontIndex()
        RelCopyBlock VIDEO, VARSEG(Vpage(0)), 0, 0, 150, 30
LOOP UNTIL INKEY$ <> ""

RelMouseHide


RelInitText
END

'* InitImageData() subroutine:
'* Initializes an integer array with image data - this must be done before
'* displaying an image using the PUT(graphics) statement. The calling value
'* of FileName$ dictates whether the data should be read directly from an
'* image file or from DATA statements (see below).
'*
'* Parameters:
'*    FileName$ - The name of the image file to load. This must include the
'*                path to the file if it does not reside in the current
'*                directory. If FileName$ is an empty string (""), image
'*                data is read from DATA statements.
'* ImageArray() - Dynamic, integer array to hold the image data.
'*
'* Note: Before calling InitImageData() to initialize images from DATA
'*       statements, use an appropriate RESTORE statement to ensure the
'*       correct DATA statements are read.
'*
SUB InitImageData (FileName$, ImageArray())

    IF FileName$ <> "" THEN
        '***** Read image data from file *****

        'Establish size of integer array required.
        FileNo = FREEFILE
        OPEN FileName$ FOR BINARY AS #FileNo
        Ints = (LOF(FileNo) - 7) \ 2
        CLOSE #FileNo
        REDIM ImageArray(1 TO Ints)

        'Load image data directly into array memory.
        DEF SEG = VARSEG(ImageArray(1))
        BLOAD FileName$, 0
        DEF SEG
    ELSE
        '***** Read image data from DATA statements *****

        'Establish size of integer array required.
        READ IntCount
        REDIM ImageArray(1 TO IntCount)

        'READ image DATA into array.
        FOR N = 1 TO IntCount
            READ X
            ImageArray(N) = X
        NEXT N
    END IF


END SUB

'* MakeImageIndex() subroutine:
'* Constructs an image position index for the images held in an image array.
'*
'* Parameters:
'* ImageArray() - Dynamic, integer array holding images to be indexed.
'* IndexArray() - Dynamic, integer array to hold the index for images in
'*                ImageArray().
'*
SUB MakeImageIndex (ImageArray(), IndexArray())

    'The index will initially be built in a temporary array, allowing
    'for the maximum 1000 images per file.
    DIM Temp(1 TO 1000)
    Ptr& = 1: IndexNo = 1: LastInt = UBOUND(ImageArray)
    DO
        Temp(IndexNo) = Ptr&
        IndexNo = IndexNo + 1

        'Evaluate descriptor of currently referenced image to
        'calculate the beginning of the next image.
        X& = (ImageArray(Ptr&) \ 8) * (ImageArray(Ptr& + 1)) + 4
        IF X& MOD 2 THEN X& = X& + 1
        Ptr& = Ptr& + (X& \ 2)
    LOOP WHILE Ptr& < LastInt

    LastImage = IndexNo - 1

    'Copy the image index values into the actual index array.
    REDIM IndexArray(1 TO LastImage)
    FOR N = 1 TO LastImage
        IndexArray(N) = Temp(N)
    NEXT N

END SUB

