(DEFUN C:GPBB ()
;SET LAYER
(COMMAND "SETVAR" "CMDECHO" 0)
(SETQ NY (GETVAR "CLAYER"))
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(setq GPSET (findfile "c:/acad/ACAD/SUPPORT/GP.SET"))
(IF (= GPSET NIL)
    (PROGN
       (PROMPT "\nPLEASE SETTING LAYER GIUDE PIN :" )
       (SETQ FC (OPEN "c:/acad/ACAD/SUPPORT/GP.SET" "w"))
       (setq GPCNT (GETSTRING T"\nSETTING GUIDE PIN  LAYER OF CONTNIUE LINE ? <0>:"))
       (IF (= GPCNT "")
              (WRITE-LINE "0" FC)
              (WRITE-LINE GPCNT FC)
       )
       (setq GPCEN (GETSTRING T"\nSETTING GUIDE PIN LAYER OF CENTER LINE ? <CEN>:"))
       (IF (= GPCEN "")
              (WRITE-LINE "CEN" FC)
              (WRITE-LINE GPCEN FC)
       )
       (setq GPHID (GETSTRING T"\nSETTING GUIDE PIN LAYER OF HIDDEN LINE ? <HID>:"))
       (IF (= GPHID "")
              (WRITE-LINE "HID" FC)
              (WRITE-LINE GPHID FC)
       )
       (setq GPDIM (GETSTRING T"\nSETTING GUIDE PIN WORD IS LP OR GP ? <GP>:"))
       (IF (= GPDIM "")
              (WRITE-LINE "GP" FC)
              (WRITE-LINE GPDIM FC)
       )
       (setq GPTXT (GETSTRING T"\nSETTING GUIDE PIN LAYER OF TEXT ? <TEXT>:"))
       (IF (= GPTXT "")
              (WRITE-LINE "TEXT" FC)
              (WRITE-LINE GPTXT FC)
       )
       (CLOSE FC)
    )
)

(IF (/= GPSET NIL)
    (PROGN
       (SETQ FC (OPEN "c:/acad/ACAD/SUPPORT/GP.SET" "r"))
       (SETQ GPCNT (READ-LINE FC))
       (SETQ GPCEN (READ-LINE FC))
       (SETQ GPHID (READ-LINE FC))
       (SETQ GPDIM (READ-LINE FC))
       (SETQ GPTXT (READ-LINE FC))
       (IF (OR (= GPCNT "") (= GPCEN "") (= GPHID "") (= GPDIM "") (= GPTXT "")
               (= GPCNT NIL) (= GPCEN NIL) (= GPHID NIL) (= GPDIM NIL) (= GPTXT NIL))
           (CLOSE FC)
       )
       (IF (OR (= GPCNT "") (= GPCEN "") (= GPHID "") (= GPDIM "") (= GPTXT "")
               (= GPCNT NIL) (= GPCEN NIL) (= GPHID NIL) (= GPDIM NIL) (= GPTXT NIL))
           (PROGN
              (PROMPT "\nPLEASE SETTING LAYER GIUDE PIN :" )
              (SETQ FC (OPEN "c:/acad/ACAD/SUPPORT/GP.SET" "w"))
              (setq GPCNT (GETSTRING T"\nSETTING GUIDE PIN  LAYER OF CONTNIUE LINE ? <0>:"))
              (IF (= GPCNT "")
                  (WRITE-LINE "0" FC)
                  (WRITE-LINE GPCNT FC)
              )
              (setq GPCEN (GETSTRING T"\nSETTING GUIDE PIN LAYER OF CENTER LINE ? <CEN>:"))
              (IF (= GPCEN "")
                  (WRITE-LINE "CEN" FC)
                  (WRITE-LINE GPCEN FC)
              )
              (setq GPHID (GETSTRING T"\nSETTING GUIDE PIN LAYER OF HIDDEN LINE ? <HID>:"))
              (IF (= GPHID "")
                  (WRITE-LINE "HID" FC)
                  (WRITE-LINE GPHID FC)
              )
              (setq GPDIM (GETSTRING T"\nSETTING GUIDE PIN WORD IS LP OR GP ? <GP>:"))
              (IF (= GPDIM "")
                  (WRITE-LINE "GP" FC)
                  (WRITE-LINE GPDIM FC)
              )
              (setq GPTXT (GETSTRING T"\nSETTING GUIDE PIN LAYER OF TEXT ? <TEXT>:"))
              (IF (= GPTXT "")
                  (WRITE-LINE "TEXT" FC)
                  (WRITE-LINE GPTXT FC)
              )
           (CLOSE FC)
           )
       )
       (SETQ FC (OPEN "c:/acad/ACAD/SUPPORT/GP.SET" "r"))
       (SETQ GPCNT (READ-LINE FC))
       (SETQ GPCEN (READ-LINE FC))
       (SETQ GPHID (READ-LINE FC))
       (SETQ GPDIM (READ-LINE FC))
       (SETQ GPTXT (READ-LINE FC))
       (CLOSE FC)
       (PROMPT "\nG.P CONTINUE OF LAYER IS:" )(PROMPT GPCNT)(TERPRI)
       (PROMPT "\nG.P CENTER OF LAYER IS:" ) (PROMPT GPCEN)(TERPRI)
       (PROMPT "\nG.P HIDDEN OF LAYER IS:" ) (PROMPT GPHID)(TERPRI)
       (PROMPT "\nG.P DIMENSION OF LAYER IS:" ) (PROMPT GPDIM)(TERPRI)
       (PROMPT "\nG.P TEXT   OF LAYER IS:" ) (PROMPT GPTXT)(TERPRI)
    )
)

(SETQ ANS (strcase (GETSTRING "\nDO YOU WANT TO CHANGE LAST SETTING <Y/N> N:")))
(IF (= ANS "Y")
    (PROGN
       (PROMPT "\nPLEASE SETTING LAYER:" )
       (SETQ FC (OPEN "c:/acad/ACAD/SUPPORT/GP.SET" "w"))
       (PROMPT "\nG.P CONTINUE OF LAYER " )(PROMPT "<")(PROMPT GPCNT) (PROMPT ">:")
       (setq GPCNT (GETSTRING T))
       (IF (= GPCNT "")
              (WRITE-LINE "0" FC)
              (WRITE-LINE GPCNT FC)
       )
       (PROMPT "\nG.P CENTER OF LAYER " )(PROMPT "<")(PROMPT GPCEN) (PROMPT ">:")
       (setq GPCEN (GETSTRING T))
       (IF (= GPCEN "")
              (WRITE-LINE "CEN" FC)
              (WRITE-LINE GPCEN FC)
       )
       (PROMPT "\nG.P HIDDEN OF LAYER " )(PROMPT "<")(PROMPT GPHID) (PROMPT ">:")
       (setq GPHID (GETSTRING T))
       (IF (= GPHID "")
              (WRITE-LINE "HID" FC)
              (WRITE-LINE GPHID FC)
       )
       (PROMPT "\nG.P THE WORDS " )(PROMPT "<")(PROMPT GPDIM) (PROMPT ">:")
       (setq GPDIM (GETSTRING T))
       (IF (= GPDIM "")
              (WRITE-LINE "GP" FC)
              (WRITE-LINE GPDIM FC)
       )
       (PROMPT "\nG.P TEXT OF LAYER " )(PROMPT "<")(PROMPT GPTXT)(PROMPT ">:")
       (setq GPTXT (GETSTRING T))
       (IF (= GPTXT "")
              (WRITE-LINE "TEXT" FC)
              (WRITE-LINE GPTXT FC)
       )
       (CLOSE FC)
       (SETQ FC (OPEN "c:/acad/ACAD/SUPPORT/GP.SET" "r"))
       (SETQ GPCNT (READ-LINE FC))
       (SETQ GPCEN (READ-LINE FC))
       (SETQ GPHID (READ-LINE FC))
       (SETQ GPDIM (READ-LINE FC))
       (SETQ GPTXT (READ-LINE FC))
       (CLOSE FC)
       (PROMPT "\nG.P CONTINUE OF LAYER NOW IS:" )(PROMPT GPCNT)(TERPRI)
       (PROMPT "\nG.P CENTER   OF LAYER NOW IS:" ) (PROMPT GPCEN)(TERPRI)
       (PROMPT "\nG.P HIDDEN   OF LAYER NOW IS:" ) (PROMPT GPHID)(TERPRI)
       (PROMPT "\nG.P DIMENSION OF LAYER IS:" ) (PROMPT GPDIM)(TERPRI)
       (PROMPT "\nG.P TEXT   OF WORD IS:" ) (PROMPT GPTXT)(TERPRI)
  )
)

(MENUCMD "S=GP")
(SETQ D 30)
(SETQ D (GETREAL"\nSelect dim:"))
(IF  (= (SETQ ANS1 (GETSTRING "\nDOU YOU WANT TO CUT PART LINE (P2):<Y>")) "")
     (SETQ ANS1 "Y"))
(SETQ ANS1 (STRCASE ANS1))
(IF (AND (>= D 16) (< D 20))
    (PROGN
       (SETQ BD1 (+ D 9))
       (SETQ BD (+ D 14))
       (SETQ H  6)
       (SETQ M  8)
       (SETQ R  2.5)
       (SETQ FR  1.83)
       (SETQ BUD (+ D 14))
       (SETQ BUD1 (+ D 9))
       (SETQ BUH  8)
       (SETQ BUR  3)
       (SETQ W 3  )
       (SETQ P 16)
     )
)
(IF (AND (>= D 20) (< D 25))
    (PROGN
       (SETQ BD1 (+ D 10))
       (SETQ BD (+ D 15))
       (SETQ H  8)
       (SETQ M  10)
       (SETQ R  2.5)
       (SETQ FR  2.75)
       (SETQ BUD (+ 15))
       (SETQ BUD1 (+ D 10))
       (SETQ BUH  8)
       (SETQ BUR  3)
       (SETQ W 3  )
       (SETQ P 20)
     )
)
(IF (AND (>= D 25) (< D 30))
    (PROGN
       (SETQ BD1 (+ D 10))
       (SETQ BD (+ 15))
       (SETQ H  8)
       (SETQ M  12)
       (SETQ R  2.5)
       (SETQ FR  2.75)
       (SETQ BUD (+ 15))
       (SETQ BUD1 (+ D 10))
       (SETQ BUH  8)
       (SETQ BUR  3)
       (SETQ W 3  )
       (SETQ P 25)
     )
)
(IF (AND (>= D 30) (< D 35))
    (PROGN
       (SETQ BD1 (+ D 12))
       (SETQ BD (+ D 17))
       (SETQ H  10)
       (SETQ M  15)
       (SETQ R  3)
       (SETQ FR  2.75)
       (SETQ BUD (+ D 17))
       (SETQ BUD1 (+ D 12))
       (SETQ BUH 10)
       (SETQ BUR  3)
       (SETQ W 3  )
       (SETQ P 30)
     )
)
(IF (AND (>= D 35) (< D 40))
    (PROGN
       (SETQ BD1 (+ D 13))
       (SETQ BD (+ D 19))
       (SETQ H  10)
       (SETQ M  15)
       (SETQ R  3)
       (SETQ FR  2.75)
       (SETQ BUD (+ D 19))
       (SETQ BUD1 (+ D 13))
       (SETQ BUH 10)
       (SETQ BUR  4)
       (SETQ W 4  )
       (SETQ P 30)
     )
)
(IF (AND (>= D 40) (< D 50))
    (PROGN
       (SETQ BD1 (+ D 15))
       (SETQ BD (+ D 21))
       (SETQ H  10)
       (SETQ M  20)
       (SETQ R  4)
       (SETQ FR  3.67)
       (SETQ BUD (+ D 21))
       (SETQ BUD1 (+ D 15))
       (SETQ BUH 10)
       (SETQ BUR  4)
       (SETQ W 4  )
       (SETQ P 40)
     )
)
(IF (AND (>= D 50) (< D 60))
    (PROGN
       (SETQ BD1 (+ D 20))
       (SETQ BD (+ D 26))
       (SETQ H  12)
       (SETQ M  25)
       (SETQ R  5)
       (SETQ FR  4.58)
       (SETQ BUD (+ D 26))
       (SETQ BUD1 (+ D 20))
       (SETQ BUH 12)
       (SETQ BUR  4)
       (SETQ W 4  )
       (SETQ P 50)
     )
)
(IF (AND (>= D 60) (< D 70))
    (PROGN
       (SETQ BD1 (+ D 20))
       (SETQ BD (+D 26))
       (SETQ H  15)
       (SETQ M  25)
       (SETQ R  5)
       (SETQ FR  4.58)
       (SETQ BUD (+ D 26))
       (SETQ BUD1 (+ D 20))
       (SETQ BUH 12)
       (SETQ BUR  4)
       (SETQ W 4  )
       (SETQ P 60)
     )
)
(IF (AND (>= D 70) (< D 80))
    (PROGN
       (SETQ BD1 (+ D 20))
       (SETQ BD (+ D 26))
       (SETQ H  15)
       (SETQ M  25)
       (SETQ R  5)
       (SETQ FR  4.58)
       (SETQ BUD (+ D 26))
       (SETQ BUD1 (+ D 20))
       (SETQ BUH 12)
       (SETQ BUR  4)
       (SETQ W 4  )
       (SETQ P 70)
     )
)
(IF (= D 80)
    (PROGN
       (SETQ BD1 100)
       (SETQ BD 106)
       (SETQ H  15)
       (SETQ M  25)
       (SETQ R  5)
       (SETQ FR  4.58)
       (SETQ BUD 86)
       (SETQ BUD1 80)
       (SETQ BUH 12)
       (SETQ BUR  4)
       (SETQ W 4  )
       (SETQ P 80)
     )
)
;(SETQ P1 (LIST 305.68 38.95))
;(SETQ P2 (LIST 305.68 108.95))
;(SETQ P3 (LIST 305.68 248.95))
(SETQ P1 (GETPOINT "\nP1:"))
(SETQ P2 (GETPOINT P1 "\nP2:"))
(SETQ ag1 (ANGLE P1 P2))
(SETQ AG2 (* PI 0.5))
(SETQ P3 (GETPOINT P2 "\nP3:"))
(SETQ DR1 (POLAR (POLAR P1 AG1 H) (+ AG1 AG2) (+ (/ BD 2.0) 1.5)))
(SETQ DR2 (POLAR (POLAR P1 AG1 H) (- AG1 AG2) (+ (/ BD 2.0) 1.5)))
(SETQ DR3 (POLAR P1 (+ AG1 AG2) (+ (/ BD 2.0) 1.5)))
(SETQ DR4 (POLAR P1 (- AG1 AG2) (+ (/ BD 2.0) 1.5)))
(SETQ DR5 (POLAR (POLAR P1 AG1 H) (+ AG1 AG2) (/ BD 2.0)))
(SETQ DR6 (POLAR (POLAR P1 AG1 H) (- AG1 AG2) (/ BD 2.0)))
(SETQ DR7 (POLAR P1 (+ AG1 AG2) (/ BD 2.0)))
(SETQ DR8 (POLAR P1 (- AG1 AG2) (/ BD 2.0)))
;ABOVE FIRST BOX
(SETQ LSE (DISTANCE P1 P3)) ;DIST FOR P1 P3
(SETQ LST (DISTANCE P1 P2)) ;DIST FOR P1 P2
(SETQ LS2 (DISTANCE P2 P3)) ;DIST FOR P2 P3

(SETQ DR9 (POLAR (POLAR P1 AG1 (+ H 3))  (+ AG1 AG2) (/ BD1 2.0)))
(SETQ DR10 (POLAR (POLAR P1 AG1 (+ H 3)) (- AG1 AG2) (/ BD1 2.0)))
(SETQ DR11 (POLAR (POLAR P1 AG1 (+ H 3)) (+ AG1 AG2) (- (/ BD1 2.0) 0.5)))
(SETQ DR12 (POLAR (POLAR P1 AG1 (+ H 3)) (- AG1 AG2) (- (/ BD1 2.0) 0.5)))
(SETQ DR13 (POLAR (POLAR P1 AG1 H) (+ AG1 AG2) (- (/ BD1 2.0) 0.5)))
(SETQ DR14 (POLAR (POLAR P1 AG1 H) (- AG1 AG2) (- (/ BD1 2.0) 0.5)))
(SETQ DR15 (POLAR (POLAR P1 AG1 H ) (+ AG1 AG2) (/ BD1 2.0)))
(SETQ DR16 (POLAR (POLAR P1 AG1 H ) (- AG1 AG2) (/ BD1 2.0)))
(SETQ DR17 (POLAR (POLAR P1 AG1 (+ (* 2 D ) LST)) (+ AG1 AG2) (/ BD1 2.0)))
(SETQ DR18 (POLAR (POLAR P1 AG1 (+ (* 2 D ) LST)) (- AG1 AG2) (/ BD1 2.0)))
(SETQ DR19 (POLAR (POLAR P1 AG1 (- LST 1)) (+ AG1 AG2) (/ D 2.0)))
(SETQ DR20 (POLAR (POLAR P1 AG1 (- LST 1)) (- AG1 AG2) (/ D 2.0)))
(SETQ DR21 (POLAR (POLAR P1 AG1 (- LSE M 5)) (+ AG1 AG2) (/ D 2.0)))
(SETQ DR22 (POLAR (POLAR P1 AG1 (- LSE M 5)) (- AG1 AG2) (/ D 2.0)))
(SETQ DR23 (POLAR (POLAR P1 AG1 (- LSE 5)) (+ AG1 AG2) (/ D 2.0)))
(SETQ DR24 (POLAR (POLAR P1 AG1 (- LSE 5)) (- AG1 AG2) (/ D 2.0)))
(SETQ DRINT1 (POLAR DR21 (- AG1 0.0872665) 3))
(SETQ DRINT2 (POLAR DR22 (+ AG1 0.0872665) 3))
(SETQ INT1 (INTERS DRINT1 DR21 DR23 DR24 NIL))
(SETQ INT2 (INTERS DRINT2 DR22 DR23 DR24 NIL))
(SETQ DR25 (POLAR (POLAR P1 AG1 LSE ) (+ AG1 AG2) (+ (/ D 2.0) 1.5)))
(SETQ DR26 (POLAR (POLAR P1 AG1 LSE ) (- AG1 AG2) (+ (/ D 2.0) 1.5)))
(SETQ DR27 (POLAR (POLAR P1 AG1 (+ LST (* 2 D))) (+ AG1 AG2) (+ (/ D 2.0) 1.5)))
(SETQ DR28 (POLAR (POLAR P1 AG1 (+ LST (* 2 D))) (- AG1 AG2) (+ (/ D 2.0) 1.5)))
(SETQ DR29 (POLAR (POLAR P1 AG1 (+ LST (* 2 D))) (+ AG1 AG2) (/ D 2.0)))
(SETQ DR30 (POLAR (POLAR P1 AG1 (+ LST (* 2 D))) (- AG1 AG2) (/ D 2.0)))
(SETQ DR31 (POLAR (POLAR P1 AG1 (- (+ LST (* 2 D)) BUR)) (+ AG1 AG2) (/ D 2.0)))
(SETQ DR32 (POLAR (POLAR P1 AG1 (- (+ LST (* 2 D)) BUR)) (- AG1 AG2) (/ D 2.0)))
(SETQ DR33 (POLAR (POLAR P1 AG1 (+ LST (* 2 D))) (+ AG1 AG2) (+ (/ D 2.0) BUR)))
(SETQ DR34 (POLAR (POLAR P1 AG1 (+ LST (* 2 D))) (- AG1 AG2) (+ (/ D 2.0) BUR)))
(SETQ DR35 (POLAR (POLAR P1 AG1 (+ LST (* 2 D))) (+ AG1 AG2) (- (/ BD1 2.0) 1)))
(SETQ DR36 (POLAR (POLAR P1 AG1 (+ LST (* 2 D))) (- AG1 AG2) (- (/ BD1 2.0) 1)))
(SETQ DR37 (POLAR (POLAR P1 AG1 (- (+ LST (* 2 D)) 1)) (+ AG1 AG2) (/ BD1 2.0)))
(SETQ DR38 (POLAR (POLAR P1 AG1 (- (+ LST (* 2 D)) 1)) (- AG1 AG2) (/ BD1 2.0)))
(SETQ DR39 (POLAR (POLAR P1 AG1 (+ LST  2 )) (+ AG1 AG2) (/ BD1 2.0)))
(SETQ DR40 (POLAR (POLAR P1 AG1 (+ LST  2 )) (- AG1 AG2) (/ BD1 2.0)))
(SETQ DR41 (POLAR (POLAR P1 AG1 (+ LST  1 )) (+ AG1 AG2) (- (/ BD1 2.0) 1)))
(SETQ DR42 (POLAR (POLAR P1 AG1 (+ LST  1 )) (- AG1 AG2) (- (/ BD1 2.0) 1)))
(SETQ DR43 (POLAR (POLAR P1 AG1 (+ LST  1 )) (+ AG1 AG2) (/ D 2.0)))
(SETQ DR44 (POLAR (POLAR P1 AG1 (+ LST  1 )) (- AG1 AG2) (/ D 2.0)))
(SETQ DR45 (POLAR (POLAR P1 AG1 (+ LST  1 )) (+ AG1 AG2) (+ (/ D 2.0) BUR)))
(SETQ DR46 (POLAR (POLAR P1 AG1 (+ LST  1 )) (- AG1 AG2) (+ (/ D 2.0) BUR)))
(SETQ DR47 (POLAR (POLAR P1 AG1 (+ LST  1  BUR)) (+ AG1 AG2) (/ D 2.0)))
(SETQ DR48 (POLAR (POLAR P1 AG1 (+ LST  1  BUR)) (- AG1 AG2) (/ D 2.0)))


(SETQ DR49 (POLAR (POLAR P1 AG1 (- LST  1 )) (+ AG1 AG2) (/ BD1 2.0)))
(SETQ DR50 (POLAR (POLAR P1 AG1 (- LST  1 )) (- AG1 AG2) (/ BD1 2.0)))
;

(SETQ DR51 (POLAR INT1 (- AG1 AG2) FR))
(SETQ DR52 (POLAR INT2 (+ AG1 AG2) FR))
(SETQ DR53 (POLAR INT1 (- AG1 (DTR 185)) 1.83))
(SETQ DR54 (POLAR INT2 (+ AG1 (DTR 185)) 1.83))
(IF  (= ANS1 "N")
     (COMMAND "LAYER" "SET" GPHID "")
     (COMMAND "LAYER" "SET" GPCNT "")
)
(COMMAND "LINE" DR1 DR2 "")
(COMMAND "LINE" DR1 DR3 "")
(COMMAND "LINE" DR2 DR4 "")
(COMMAND "LINE" DR5 DR7 "")
(COMMAND "LINE" DR6 DR8 "")

(COMMAND "LINE" DR9 DR10 "")
(COMMAND "LINE" DR11 DR13 "")
(COMMAND "LINE" DR12 DR14 "")
(COMMAND "LINE" DR15 DR17 "")
(COMMAND "LINE" DR16 DR18 "")
(COMMAND "LINE" DR19 DR21 "")
(COMMAND "LINE" DR17 DR29 "")
(COMMAND "LINE" DR18 DR30 "")
(COMMAND "LINE" DR20 DR22 "")
(COMMAND "LINE" DR21 DR22 "")
(COMMAND "LINE" DR21 DR53 "")
(COMMAND "LINE" DR22 DR54 "")
;(COMMAND "LINE" DR23 DR24 "")

(COMMAND "ARC" DR51 "E" DR53 "R" R)
(COMMAND "ARC" DR54 "E" DR52 "R" R)

(COMMAND "ARC" DR31 "E" DR33 "R" BUR)
(COMMAND "ARC" DR34 "E" DR32 "R" BUR)
(COMMAND "LINE" DR35 DR37 "")
(COMMAND "LINE" DR36 DR38 "")
(COMMAND "LINE" DR39 DR41 DR43 "")
(COMMAND "LINE" DR40 DR42 DR44 "")
(COMMAND "ARC" DR45 "E" DR47 "R" BUR)
(COMMAND "ARC" DR48 "E" DR46 "R" BUR)
(IF (= ANS1 "Y")
    (COMMAND "TRIM" DR19 DR20 "" (POLAR P2 (+ AG1 AG2) 4) "")
)
(COMMAND "LINE" DR49 DR50 "")
(COMMAND "LINE" DR51 DR52 "")

(SETQ NU 1)
(IF (> LS2 P)
    (PROGN
       (SETQ N (FIX (/ LS2 P)))
       (SETQ GP P)
       (REPEAT (- N 3)
          (SETQ BR1 (POLAR (POLAR P1 AG1 (- LSE P W 5)) (+ AG1 AG2) (/ D 2.0)))
          (SETQ BR2 (POLAR (POLAR P1 AG1 (- LSE P W 5)) (- AG1 AG2) (/ D 2.0)))
          (SETQ BR3 (POLAR (POLAR P1 AG1 (- LSE P 5)) (+ AG1 AG2) (/ D 2.0)))
          (SETQ BR4 (POLAR (POLAR P1 AG1 (- LSE P 5)) (- AG1 AG2) (/ D 2.0)))
;         (COMMAND "BREAK" BR1 "F" BR1 BR3)
;         (COMMAND "BREAK" BR2 "F" BR2 BR4)
          (COMMAND "ARC" BR1 "E" BR3 "R" 3)
          (COMMAND "ARC" BR4 "E" BR2 "R" 3)
          (COMMAND "LINE" BR1 BR2 "")
          (COMMAND "LINE" BR3 BR4 "")
          (SETQ NU (+ NU 1))
          (SETQ P (+ GP P))
          (IF (< (- LSE P) (+ LST 8))
              (SETQ N 1)
          )
       )
    )
)

(COMMAND "LINE" DR25 DR27 "")
(COMMAND "LINE" DR26 DR28 "")
(COMMAND "LAYER" "SET" GPCEN "")
(COMMAND "LINE" (POLAR P1 AG1 -1) (POLAR P1 AG1 (+ 1 LSE)) "")
;HERE IS TEXT
(COMMAND "LAYER" "SET" GPTXT "")
(SETQ NUM (GETSTRING T "\nHOW MANY GUPIDE PIN ?"))
(IF (OR (= NUM "") (= NUM "1"))
   (SETQ GPDIM (STRCAT GPDIM NUM ))
   (SETQ GPDIM (STRCAT GPDIM "(" NUM "X" ")"))
)
(IF (< AG1 PI)
    (PROGN
       (SETQ TT1 (POLAR (POLAR P1 AG1 (+ H 5))  (+ AG1 AG2) 2))
       (SETQ TT2 (POLAR (POLAR P1 AG1 (+ H 5)) (- AG1 AG2) 5))
       (SETQ AG1T AG1)
    )
)
(IF (>= AG1 PI)
    (PROGN
       (SETQ TT2 (POLAR (POLAR P1 AG1 (+ H 25))  (+ AG1 AG2) 5))
       (SETQ TT1 (POLAR (POLAR P1 AG1 (+ H 25)) (- AG1 AG2) 2))
       (SETQ AG1T (+ AG1 PI))
    )
)
(SETQ LONG1 (- (DISTANCE P1 P3) 5))
(SETQ LONG1 (FIX LONG1))
(SETQ LONG1 (RTOS LONG1 2 0))
(SETQ LP (GETVAR "LUPREC"))   ;LP DIGITAL
(SETQ D1 (RTOS D 2 LP))
(SETQ D11 (FIX (ATOF D1)))
(SETQ RET (- D D11))
(IF (OR (= RET 0) (= RET 0.0) (= RET 0.00))
    (PROGN
       (SETQ SR (- (STRLEN D1) LP 1))
       (SETQ D1 (SUBSTR D1 1 SR))
    )
)
(SETQ DIST1 (STRCAT "%%C" D1 "X" LONG1 "L"))
(COMMAND "TEXT" TT1 3.0 (RTD AG1T) GPDIM)
(COMMAND "TEXT" TT2 3.0 (RTD AG1T) DIST1)
)
