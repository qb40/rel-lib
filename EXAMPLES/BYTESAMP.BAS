DEFINT A-Z

'Cheesy Example of Rellib's Byte emulation
'Note that A is defined as an integer

'Subs Used:
'1. RelAddHi     =Adds a high byte value to an integer value
'2. RelAddLow    =Adds a Low byte value to an integer value

'Functions used:
'1. RelGetHi    =Gets the High byte value of an integer
'2. RelGetLow   =Gets the Low byte value of an integer

'Notes:
'you could also use this pure QB code to Retrieve the Bytes
'of an integer which was modified by either RelAddHi of RelAddLow
'BUT limits you to values 0 to 127 so beware!!!!!!
'Whereas if you use RelAddHi/RelGetHi or RelAddLow/RelGetLow combination,
'you can represent values from 0 to 255 ;-)
'Speed difference is negligible anyways...... about 2x as fast/slow.

'CODE: Toshi Horie taught this to me ;*)
'PRINT IntVal AND 255                 'Qb equivalent of Low Byte
'PRINT IntVal \ 256                   'Qb equivalent of High Byte
'END CODE

'$INCLUDE: 'RelLib.Bi'

DIM SHARED IntVal AS INTEGER            'Our Integer value to be played with


CLS
SCREEN 0

IntVal = 0              'Init to zero

PRINT IntVal, "Initial value"

RelAddLow VARSEG(IntVal), VARPTR(IntVal), 127            'add Low Byte

PRINT IntVal                                            'Print New value

RelAddHI VARSEG(IntVal), VARPTR(IntVal), 247             'add High Byte

PRINT IntVal                                            'Print New Value


'Demonstrates splitting Integers to bytes
'useful for Tilesets in games to save half of the memory for maps

PRINT RelGetLow(IntVal), "Low Byte"             'Print Low Byte
PRINT RelGetHI(IntVal), "High Byte"             'Print High Byte


'Alternative way to use the above functions:
'1.
REM LowByte= RelGetLow(Intval)
REM Print LowByte, "Low Byte"                        'Print Low Byte
'2.
REM HighByte= RelGetHigh(Intval)
REM Print HighByte, "High Byte"                      'Print High Byte


PRINT
PRINT

'Demonstrate the Flexibility of the Byte Emulators
'since it could also be used in Arrays and Even Types!!!!!!
TYPE NpcType
        id      AS INTEGER
        X       AS INTEGER
        Y       AS INTEGER
        Scr     AS STRING * 20
        XV      AS SINGLE
        YV      AS SINGLE
        Hp      AS DOUBLE
END TYPE

DIM Npc(100) AS NpcType         'Dimension our Typed Array


'Initialize the values of our first element
'we will use subscript zero
Npc(0).id = 100
Npc(0).X = 100
Npc(0).Y = 100
Npc(0).XV = 200
Npc(0).YV = 200
Npc(0).Scr = "Anya Therese B. Lope"
Npc(0).Hp = 1000


'We will play with Npc(0).Id in this case

PRINT Npc(0).id                 'print Initial value of id

RelAddLow VARSEG(Npc(0).id), VARPTR(Npc(0).id), 20      'Add low byte

PRINT Npc(0).id, "Low Add"

RelAddHI VARSEG(Npc(0).id), VARPTR(Npc(0).id), 45       'Add high Byte

PRINT Npc(0).id, "High Add"

PRINT

PRINT RelGetLow(Npc(0).id), "Low Byte"                  'Print Low Byte Value
PRINT RelGetHI(Npc(0).id), "High Byte"                  'Print High Byte Value

PRINT Npc(0).id AND 255                 'Qb equivalent
PRINT Npc(0).id \ 256                   'Qb equivalent

PRINT
PRINT "Npc Data"

'Print our NPC data to ensure that the other
'elements in the types are not changed

PRINT Npc(0).id
PRINT Npc(0).X
PRINT Npc(0).Y
PRINT Npc(0).XV
PRINT Npc(0).YV
PRINT Npc(0).Scr
PRINT Npc(0).Hp

END













