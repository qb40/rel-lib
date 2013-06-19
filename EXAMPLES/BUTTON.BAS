DECLARE SUB CheckForClick ()
DECLARE SUB DrawButtons ()
DECLARE SUB InitButtons ()
DECLARE SUB LoadPal ()
DECLARE SUB InitImageData (FileName$, ImageArray%())
DECLARE SUB MakeImageIndex (ImageArray%(), IndexArray%())
DEFINT A-Z

REM $INCLUDE: 'RelLib.BI'

TYPE PalType
        R AS INTEGER
        G AS INTEGER
        B AS INTEGER
END TYPE

TYPE ButtonType
        X       AS INTEGER
        Y       AS INTEGER
        W       AS INTEGER
        H       AS INTEGER
END TYPE

REDIM SHARED Vpage(31999) AS INTEGER

REDIM SHARED Font(1 TO 1) AS INTEGER
REDIM SHARED FontIndex(1 TO 1) AS INTEGER

REDIM SHARED Relpal(255) AS PalType

REDIM SHARED Button(4) AS ButtonType
DIM SHARED RGBpal AS STRING * 768
DIM SHARED Path$

InitButtons

RANDOMIZE TIMER
CLS
RelInitVGA13
RelCls VARSEG(Vpage(0)), 0

Path$ = ""
Path$ = "C:\Qbasic\RelLib\Examples\"
RelLoadPal Path$ + "RelPal.Pal", RGBpal, TRUE

File$ = Path$ + "SIfntDG.Put"
InitImageData File$, Font()
MakeImageIndex Font(), FontIndex()


RelFont256 VARSEG(Vpage(0)), 10, 50, "Press A Key:", TRUE, Font(), FontIndex()

RelFontTrans256 VARSEG(Vpage(0)), 10, 70, "Fonts by Adigun Polack", TRUE, Font(), FontIndex()

IF RelMouseDetect THEN
        RelFont256 VARSEG(Vpage(0)), 10, 150, "Mouse Detected", TRUE, Font(), FontIndex()
ELSE
        RelFont256 VARSEG(Vpage(0)), 10, 150, "No Mouse Detected", TRUE, Font(), FontIndex()
END IF
RelPcopy VIDEO, VARSEG(Vpage(0))
RelMouseShow
C$ = INPUT$(1)
RelCls VARSEG(Vpage(0)), 0
RelCls VIDEO, 0

DrawButtons

RelMouseShow

CheckForClick

RelInitText
END

SUB CheckForClick STATIC

RelFont256 VIDEO, 10, 150, "Press Right Mouse Button to EXIT", TRUE, Font(), FontIndex()

DO
        IF RelMouseClick = 1 THEN
                FOR I = 0 TO 4
                        IF RelMouseInside(Button(I).X, Button(I).Y, Button(I).X + Button(I).W, Button(I).Y + Button(I).H) THEN
                                RelBoxF VARSEG(Vpage(0)), 10, 180, 319, 199, 0
                                RelFont256 VARSEG(Vpage(0)), 10, 180, "Clicked Button:" + STR$(I), TRUE, Font(), FontIndex()
                                RelCopyBlock VIDEO, VARSEG(Vpage(0)), 10, 180, 319, 199
                        END IF
                NEXT I
        END IF

LOOP UNTIL RelMouseClick = 2



END SUB

SUB DrawButtons STATIC
FOR I = 0 TO 4
        RelBoxF VARSEG(Vpage(0)), Button(I).X, Button(I).Y, Button(I).X + Button(I).W, Button(I).Y + Button(I).H, 25 + I
NEXT I
RelPcopy VIDEO, VARSEG(Vpage(0))
END SUB

SUB InitButtons STATIC
TileH = 20
TileW = 40

Button(0).X = 0
Button(0).Y = 0
Button(0).W = TileW
Button(0).H = TileH

Button(1).X = 120
Button(1).Y = 0
Button(1).W = TileW
Button(1).H = TileH

Button(2).X = 250
Button(2).Y = 0
Button(2).W = TileW
Button(2).H = TileH

Button(3).X = 0
Button(3).Y = 100
Button(3).W = TileW
Button(3).H = TileH

Button(4).X = 250
Button(4).Y = 100
Button(4).W = TileW
Button(4).H = TileH





END SUB

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

