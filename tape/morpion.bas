1 REM ZX Morpion by Vincent Audergon
2 REM This software is open source. You can redistribute it and / or modify it
10 BORDER 7 : PAPER 7 : INK 0 : CLS

21 PRINT AT 5,2; "ZX Morpion par Gwyrin" 
22 PRINT AT 12,3; PAPER 7; INK 0; "W, A, S, D - Move the cursor"
23 PRINT AT 13,3; PAPER 7; INK 0; "J - Confirm choice"
24 PRINT AT 14,3; PAPER 7; INK 0; "R - Reset the game"
25 PRINT AT 15,3; PAPER 7; INK 0; "Press any key to start"

30 LET WSCREEN = 256
31 LET HSCREEN = 192
32 LET WIDTH = 85
33 LET HEIGHT = 64
34 LET CROSSSIZE = 30
35 LET CIRCLESIZE = 20
36 LET DEFAULTCOLOR = 0
37 LET COLCURSOR = 0 : LET LINCURSOR = 0
38 LET PLAYER = 2 : REM 1 => Joueur 1 de jouer, 2 => jouer 2 de jouer
39 DIM CELLS(2, 2) AS UByte : REM Représente les cellules du jeu
40 LET j$ = INKEY$
41 IF j$ = "" THEN GOTO 40: END IF

REM FONCTIONS

FUNCTION reset()
    CELLS(0,0) = 0
    CELLS(1,0) = 0
    CELLS(2,0) = 0
    CELLS(0,1) = 0
    CELLS(1,1) = 0
    CELLS(2,1) = 0
    CELLS(0,2) = 0
    CELLS(1,2) = 0
    CELLS(2,2) = 0
    PLAYER = 2
END FUNCTION

REM Dessine une cercle une une croix dans une des cellules
REM col 0 => 2
REM lin 0 => 2
REM cercle => 1 = joueur 1 (croix), 2 = joueur 2 (cercle)
FUNCTION tour(col AS UByte, lin AS UByte, cercle AS UByte)
    LET XCOORD = WIDTH * col + WIDTH/2
    LET YCOORD = HEIGHT * lin + HEIGHT/2
    IF cercle = 1 THEN
        REM Ceci est un cercle
        CIRCLE XCOORD, YCOORD, CIRCLESIZE
    ELSE IF cercle = 2 THEN
        cross(XCOORD, YCOORD)
    END IF
END FUNCTION

REM Dessine une croix aux coordonnées x,y (origine de la croix au centre)
FUNCTION cross(x AS UByte, y AS UByte)
    PLOT x-CROSSSIZE/2, y-CROSSSIZE/2 : DRAW CROSSSIZE, CROSSSIZE
    PLOT x+CROSSSIZE/2, y-CROSSSIZE/2 : DRAW -CROSSSIZE, CROSSSIZE
END FUNCTION

REM Dessine le curseur sur une des cellules
REM col 0 => 2
REM lin 0 => 2
FUNCTION cursor(col AS UBYTE, lin AS UBYTE)
    LET XCOORD = WIDTH*col
    LET YCOORD = HEIGHT*lin
    PLOT XCOORD, YCOORD
    INK 4
    DRAW WIDTH-1, 0: DRAW 0, HEIGHT-1: DRAW -WIDTH+1, 0: DRAW 0, -HEIGHT+1
END FUNCTION

FUNCTION play()
    IF PLAYER = 1 AND CELLS(COLCURSOR, LINCURSOR) = 0 THEN
        REM J1
        CELLS(COLCURSOR, LINCURSOR) = PLAYER
        PLAYER = 2
        BEEP 0.1,3
    ELSE IF CELLS(COLCURSOR, LINCURSOR) = 0
        REM J2
        CELLS(COLCURSOR, LINCURSOR) = PLAYER
        PLAYER = 1
        BEEP 0.1,5
    END IF
END FUNCTION

FUNCTION waitForRelease()
    300 LET l$ = INKEY$
    IF l$ = "" THEN GOTO 300 : END IF
END FUNCTION

FUNCTION drawG()
    CLS
    INK 0
    REM On dessine les lignes
    FOR i = 1 TO 2
        PLOT 0,HEIGHT*i : DRAW WSCREEN-1,0
    NEXT
    FOR i = 1 TO 2
        PLOT WIDTH*i,0 : DRAW 0,HSCREEN-1
    NEXT
    REM On dessine les croix et les cercles
    tour(0,0, CELLS(0,0))
    tour(1,0, CELLS(1,0))
    tour(2,0, CELLS(2,0))
    tour(0,1, CELLS(0,1))
    tour(1,1, CELLS(1,1))
    tour(2,1, CELLS(2,1))
    tour(0,2, CELLS(0,2))
    tour(1,2, CELLS(1,2))
    tour(2,2, CELLS(2,2))
    cursor(COLCURSOR,LINCURSOR)
END FUNCTION



REM On définit la couleur du cadre en noir
REM CLS => On vide l'écran des anciens assets graphiques
50 BORDER 0 : CLS : INK DEFAULTCOLOR
51 reset()
52 drawG()

REM Lecture des touches du clavier
53 LET k$ = INKEY$

REM On traîte des entrées clavier
54 IF k$ = "" THEN
55    GOTO 53
56 ELSE
REM Une touche du clavier est appuyée
57    IF k$ = "r"
        REM RESET
58        GOTO 10
    ELSE IF k$ = "w"
        REM CURSEUR VERS LE HAUT
59        waitForRelease()
60        LET NEWLIN = LINCURSOR + 1
61        IF NEWLIN < 3 AND NEWLIN > -1 THEN
62            LINCURSOR = NEWLIN
63        END IF
64        drawG()
65    ELSE IF k$ = "a"
        REM CURSEUR VERS LA GAUCHE
66        waitForRelease()
67        LET NEWCOL = COLCURSOR - 1
68        IF NEWCOL < 3 AND NEWCOL > -1 THEN
69            COLCURSOR = NEWCOL
        END IF
70        drawG()
71    ELSE IF k$ = "s"
        REM CURSEUR VERS LE BAS
72        waitForRelease()
73        LET NEWLIN = LINCURSOR -1
74        IF NEWLIN < 3 AND NEWLIN > -1 THEN
75            LINCURSOR = NEWLIN
76        END IF
77        drawG()
78    ELSE IF k$ = "d"
        REM CURSEUR VERS LE DROITE
79        waitForRelease()
80        LET NEWCOL = COLCURSOR + 1
89        IF NEWCOL < 3 AND NEWCOL > -1 THEN
90            COLCURSOR = NEWCOL
91        END IF
92        drawG()
93    ELSE IF k$ = "j"
94        waitForRelease()
95        play()
96        drawG()
97    END IF
98    GOTO 53
99 END IF