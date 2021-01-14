
;************* BILL TABLE *************
;THIS PROGRAM IS FOR CALL SCREEN MENU TO SELECT STRING

(DEFUN C:DA6 ()
 (SETQ PP1 NIL PX NIL PY NIL MPX NIL MPY NIL NR 0 D 0 TY T REWW T NUMA NIL)
 (SETQ BETA NIL DELTA NIL ALFA T)
 (SETQ DN (GETVAR "DWGNAME"))
 (SETQ FP (STRCAT  DN ".P"))
 (SETQ FPS (STRCAT DN ".PS"))
 (SETQ PP1 (FINDFILE FP ))
 (SETQ PP2 (FINDFILE FPS ))
                         (GRAPHSCR)
  (PROMPT "\nInput the number:")
              (INITGET 1 "1 2 3")
  (SETQ BETA  (GETKWORD "\n <1>Only Ball <2>Only Bill <3>Ball & Bill:"))
;
  (IF (= BETA "1" )  (SETQ DELTA 2)  )
  (IF (OR (= BETA "2" ) (= BETA "3"))  (MAIN)  )
;
 (IF (OR (= BETA "1") (= BETA "3")) (PROGN
                  (INITGET (+ 1 2 4))
  (SETQ A (GETREAL "\n Ball text height: "))
 ))
;
              (INITGET 1 "Yes No")
  (SETQ CW (STRCASE (GETSTRING 1 "\n Continuous number  <Y/N>?")))
;
 (IF (= CW "Y")  (PROGN
                    (INITGET (+ 1 2 4))
  (IF (= BETA "1") (SETQ D (- (GETINT  "\n Start number of ball: ") 1)))
                    (INITGET (+ 1 2 4))
  (IF (= BETA "2") (SETQ D (- (GETINT  "\n Start number of row: ") 1)))
                    (INITGET (+ 1 2 4))
  (IF (= BETA "3") (SETQ D (- (GETINT  "\n Start number of row & bill:") 1)))
 ))
;--------------------------------------
 (SETQ LOOP1 T )
 (WHILE LOOP1
  (SETQ PP1 NIL PP2 NIL)
  (IF (= CW "Y")  (SETQ D (+ D 1)) )
  (IF (/= CW "Y") (PROGN
   (SETQ D NIL)
      (INITGET (+ 2 4))
   (SETQ D (GETINT  "\n Input  number: "))
   (IF (OR (= D NIL) (= D "")) (SETQ LOOP1 NIL ) )
  ))

  (IF (AND (OR (= BETA "1") (= BETA "3")) (/= LOOP1 NIL)) (PROGN
   (SETQ PP1 (GETPOINT "\n LOCATE POINT TIP: "))
   (IF (AND (/= PP1 NIL) (/= PP1 "") )
    (SETQ PP2 (GETPOINT "\n LOCATE BALLOON CENTER: "))
   )
   (IF (OR (= PP1 NIL) (= PP1 "") (= PP2 NIL) (= PP2 ""))
    (SETQ LOOP1 NIL)
   )

   (IF (/= LOOP1 NIL) (PROGN
    (SETQ ITM (ITOA D))
    (SETQ WE (STRLEN ITM))
    (IF (>  D 99) (SETQ C1 (* A 1.2)) )
    (IF (<= D 99) (SETQ C1 (* A 1.3)) )
    (COMMAND "DONUT" 0 (* A 0.167 ) PP1 "")
    (COMMAND "LINE" PP1
             (POLAR PP1 (ANGLE PP1 PP2) (- (DISTANCE PP1 PP2) C1)) "")
    (COMMAND "CIRCLE" PP2  C1 )
    (COMMAND "TEXT" "M"  PP2 A "0"  ITM )
   ))
  ))
 ;
  (IF (AND (= DELTA 1) (/= DELTA 2) (/= LOOP1 NIL)) (PROGN
   (SETQ PT ( LIST (CAR P) (+ (CADR P) (* HI D)) ))
   (SETQ AA   (CADR PT)  )
   (SETQ BB   (CADR MP)  )
   (SETQ A1 (FIX (/ (- AA BB) HI) ))

   (IF (>= A1 0) (PROGN
    (SETQ NR (+ A1 1))
    (SETQ WW (/ (- (CADR MP) (CADR P)) HI ))
    (SETQ PS MP )
    (TABLE)
    (TEXTPUT)
    (WRITE)
   ))

   (IF (< A1 0) (PROGN
    (TEXTPUT)
    (WRITE)
   ))
  ))

 );ENDREPEAT LOOP1

);ENDDEFUN
;----------------------------------------------------------------
;----------------------------------------------------------------
(DEFUN  MAIN ()
  (IF (AND (/= PP1 NIL) (/= PP2 NIL)) (PROGN
                (OUT)
      (IF (= ALFA NIL) (SETQ PP1 NIL PP2 NIL))
  ))
  (IF (AND (/= PP1 NIL) (/= PP2 NIL) (/= ALFA NIL) )  (PROGN
                    (INITGET  1 "Yes No")
   (SETQ ALF (STRCASE (GETSTRING "\n Cancel old table<Y/N>?")))
   (IF (= ALF "Y") (PROGN
    (IF (AND (/= P NIL) (/= MP NIL))
     (COMMAND "ERASE" "W" P  (LIST (+ (CAR MP) TL) (CADR MP ) ) ""  )
    )
    (IF (AND (/= P NIL) (= MP NIL))
     (COMMAND "ERASE" "W" P (GETCORNER P "\n The upright corner:") "")
    )
    (SETQ PP1 NIL PP2 NIL)
   ))
  ));ENDIF PP1/=NIL & PP2/=NIL

  (IF (OR (= PP1 NIL) (= PP2 NIL) ) (progn
   (SETQ FFP (OPEN FP "w"))
   (CLOSE FFP)
   (SETQ FFPS (OPEN FPS "w"))
   (CLOSE FFPS)
    (IN)
    (OUT)
    (SETQ DELTA 0  NR 1  PS P  PT P)
    (TABLE)
    (TEXTPUT)
    (HEAD)
  ))
     (SETQ DELTA 1)
);ENDDEFUN
;----------------------------------------------------------------
(DEFUN IN  ()
    (SETQ ALFA T)
    (COMMAND "SETVAR" "ORTHOMODE" "1")
    (SETQ FFP (OPEN  FP "a"))
             (INITGET 1 "2 3 4 5 6 7 8 9 10 11 12 13")
    (SETQ NUM (GETINT "\n Number of rows<2-13>"))
    (SETQ NM (ITOA NUM))
    (WRITE-LINE NM FFP)
             (INITGET (+ 1 2 4))
    (SETQ TI (RTOS (GETREAL "\n Bill text height : ") 2 ))
    (WRITE-LINE TI FFP)
             (INITGET (+ 1 2 4))
    (SETQ HI (RTOS (GETREAL "\n Row height : ") 2 ))
    (WRITE-LINE HI FFP)

             (INITGET (+ 1 2 4))
    (SETQ P (getpoint "\n Start point of table")  )
    (SETQ PX (RTOS (CAR  P ) 2))
    (SETQ PY (RTOS (CADR P ) 2))
    (WRITE-LINE PX FFP)
    (WRITE-LINE PY FFP)

    (SETQ MP P)
    (SETQ PRE P)
    (SETQ OP 1)
    (REPEAT NUM
      (SETQ OPP (ITOA OP))
      (TERPRI)
      (PROMPT (STRCAT  "Long of the" OPP ":"))
             (INITGET (+ 1 2 4))
      (SETQ PL (GETDIST PRE ) )
      (SETQ LL (RTOS PL 2 ))
      (WRITE-LINE  LL FFP)
      (SETQ PRE  (LIST (+ (CAR PRE) PL) (CADR P) ))
      (SETQ OP (+ OP 1))
    )

    (MENUCMD "S=DABILL")
    (SETQ OP 1)
    (PROMPT "\n")
    (REPEAT  NUM
      (SETQ OPP (ITOA OP))
      (PROMPT (STRCAT  "String of the" OPP ":"))
      (SETQ ST (GETSTRING 1 ))
      (WRITE-LINE  ST FFP)
      (SETQ OP (+ OP 1))
    )
    (CLOSE FFP)

    (MENUCMD "S=SCREEN")
    (SETQ FFPS (OPEN FPS "w"))
    (WRITE-LINE  PX FFPS)
    (WRITE-LINE  PY FFPS)
    (CLOSE FFPS)
);ENDDEFUN
;----------------------------------------------------------
(DEFUN OUT  ()
  (SETQ L1  0  L2 0 L3 0 L4 0 L5 0 L6 0 L7 0 L8 0 L9 0 L10 0 )
  (SETQ L11 0 L12 0 L13 0 ALFA T)
  (SETQ FFP  (OPEN FP  "r"))

  (SETQ NUM (READ-LINE FFP ))
  (IF (OR (= NUM NIL) (= NUM ""))
   (SETQ ALFA NIL)
   (SETQ NUM (ATOI NUM))
  )

  (IF (/= ALFA NIL) (PROGN
   (SETQ TI (READ-LINE FFP ))
   (IF (OR (= TI NIL) (= TI ""))
    (SETQ ALFA NIL)
    (SETQ TI (ATOF TI))
   )
  ))

  (IF (/= ALFA NIL) (PROGN
   (SETQ HI (READ-LINE FFP ))
   (IF (OR (= HI NIL) (= HI ""))
    (SETQ ALFA NIL)
    (SETQ HI (ATOF HI))
   )
  ))

  (IF (/= ALFA NIL) (PROGN
   (SETQ PX (READ-LINE FFP ))
   (IF (OR (= PX NIL) (= PX ""))
    (SETQ ALFA NIL PX NIL)
    (SETQ PX (ATOF PX))
   )
  ))

  (IF (/= ALFA NIL) (PROGN
   (SETQ PY (READ-LINE FFP ))
   (IF (OR (= PY NIL) (= PY ""))
    (SETQ ALFA NIL PY NIL)
    (SETQ PY (ATOF PY))
   )
  ))

  (IF (/= ALFA NIL) (PROGN
   (IF (AND (/= PX NIL) (/= PY NIL))
    (SETQ P (LIST PX PY ))
   )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 1)) (PROGN
   (SETQ L1 (READ-LINE FFP ))
   (IF (= L1 NIL) (SETQ ALFA NIL) (SETQ L1 (ATOF L1)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 2)) (PROGN
   (SETQ L2 (READ-LINE FFP ))
   (IF (= L2 NIL) (SETQ ALFA NIL) (SETQ L2 (ATOF L2)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 3)) (PROGN
   (SETQ L3 (READ-LINE FFP ))
   (IF (= L3 NIL) (SETQ ALFA NIL) (SETQ L3 (ATOF L3)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 4)) (PROGN
   (SETQ L4 (READ-LINE FFP ))
   (IF (= L4 NIL) (SETQ ALFA NIL) (SETQ L4 (ATOF L4)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 5)) (PROGN
   (SETQ L5 (READ-LINE FFP ))
   (IF (= L5 NIL) (SETQ ALFA NIL) (SETQ L5 (ATOF L5)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 6)) (PROGN
   (SETQ L6 (READ-LINE FFP ))
   (IF (= L6 NIL) (SETQ ALFA NIL) (SETQ L6 (ATOF L6)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 7)) (PROGN
   (SETQ L7 (READ-LINE FFP ))
   (IF (= L7 NIL) (SETQ ALFA NIL) (SETQ L7 (ATOF L7)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 8)) (PROGN
   (SETQ L8 (READ-LINE FFP ))
   (IF (= L8 NIL) (SETQ ALFA NIL) (SETQ L8 (ATOF L8)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 9)) (PROGN
   (SETQ L9 (READ-LINE FFP ))
   (IF (= L9 NIL) (SETQ ALFA NIL) (SETQ L9 (ATOF L9)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 10)) (PROGN
   (SETQ L10 (READ-LINE FFP ))
   (IF (= L10 NIL) (SETQ ALFA NIL) (SETQ L10 (ATOF L10)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 11)) (PROGN
   (SETQ L11 (READ-LINE FFP ))
   (IF (= L11 NIL) (SETQ ALFA NIL) (SETQ L11 (ATOF L11)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 12)) (PROGN
   (SETQ L12 (READ-LINE FFP ))
   (IF (= L12 NIL) (SETQ ALFA NIL) (SETQ L12 (ATOF L12)) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 13)) (PROGN
   (SETQ L13 (READ-LINE FFP ))
   (IF (= L13 NIL) (SETQ ALFA NIL) (SETQ L13 (ATOF L13)) )
  ))

  (IF (/= ALFA NIL)
   (SETQ TL (+ L1 L2 L3 L4 L5 L6 L7 L8 L9 L10 L11 L12 L13 ))
  )

  (IF (AND (/= ALFA NIL) (>= NUM 1) ) (PROGN
   (SETQ HST  (READ-LINE FFP ))
   (IF (= HST NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 2) ) (PROGN
   (SETQ ST1 (READ-LINE FFP ))
   (IF (= ST1 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 3) ) (PROGN
   (SETQ ST2 (READ-LINE FFP ))
   (IF (= ST2 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 4) ) (PROGN
   (SETQ ST3 (READ-LINE FFP ))
   (IF (= ST3 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 5) ) (PROGN
   (SETQ ST4 (READ-LINE FFP ))
   (IF (= ST4 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 6) ) (PROGN
   (SETQ ST5 (READ-LINE FFP ))
   (IF (= ST5 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 7) ) (PROGN
   (SETQ ST6 (READ-LINE FFP ))
   (IF (= ST6 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 8) ) (PROGN
   (SETQ ST7 (READ-LINE FFP ))
   (IF (= ST7 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 9) ) (PROGN
   (SETQ ST8 (READ-LINE FFP ))
   (IF (= ST8 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 10) ) (PROGN
   (SETQ ST9 (READ-LINE FFP ))
   (IF (= ST9 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 11) ) (PROGN
   (SETQ ST10 (READ-LINE FFP ))
   (IF (= ST10 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 12) ) (PROGN
   (SETQ ST11 (READ-LINE FFP ))
   (IF (= ST11 NIL) (SETQ ALFA NIL) )
  ))

  (IF (AND (/= ALFA NIL) (>= NUM 13) ) (PROGN
   (SETQ ST12 (READ-LINE FFP ))
   (IF (= ST12 NIL) (SETQ ALFA NIL) )
  ))

  (CLOSE FFP )

  (IF (/= ALFA NIL) (PROGN
   (SETQ FFPS (OPEN FPS  "r"))
   (SETQ MPX1 (READ-LINE FFPS ))
   (SETQ MPY1 (READ-LINE FFPS ))
   (CLOSE FFPS)
   (IF (AND (/= MPX1 NIL) (/= MPY1 NIL))
    (SETQ MP (LIST (ATOF MPX1) (ATOF MPY1) ))
   )
   (IF (OR (= MPX1 NIL) (= MPY1 NIL))
    (SETQ ALFA NIL)
   )
  ))
   (PROMPT "\n OUT OK !!!")
);ENDDEFUN
;---------------------------------------------------------------------
(DEFUN   TABLE  ()
  (REPEAT NR
   (SETQ PE  (LIST (+ (CAR PS ) TL ) (CADR PS ) ))
   (SETQ PTS (LIST (CAR PS )         (+ (CADR PS ) HI) ))
   (SETQ PTE (LIST (+ (CAR PS ) TL ) (+ (CADR PS ) HI) ))
   (SETQ P1  (LIST (+ (CAR PS ) L1 ) (CADR PS ) ))
   (SETQ P11 (LIST (+ (CAR PTS) L1 ) (CADR PTS) ))
   (IF (= DELTA 0) (COMMAND "LINE" PS PE  "") )
   (COMMAND "LINE" PTS PTE "")
   (COMMAND "LINE" PS PTS "")
   (COMMAND "LINE" PE PTE "")
   (COMMAND "LINE" P1 P11 "")

   (IF (>= NUM 3) (PROGN
    (SETQ P2  (LIST (+ (CAR P1) L2  ) (CADR P1 )))
    (SETQ P21 (LIST (+ (CAR P11) L2 ) (CADR P11)))
    (COMMAND "LINE" P2  P21  "")
   ))
   (IF (>= NUM 4) (PROGN
    (SETQ P3  (LIST (+ (CAR P2) L3  ) (CADR P2 )))
    (SETQ P31 (LIST (+ (CAR P21) L3 ) (CADR P21)))
    (COMMAND "LINE" P3  P31  "")
   ))
   (IF (>= NUM 5) (PROGN
    (SETQ P4  (LIST (+ (CAR P3) L4  ) (CADR P3 )))
    (SETQ P41 (LIST (+ (CAR P31) L4 ) (CADR P31)))
    (COMMAND "LINE" P4  P41  "")
   ))
   (IF (>= NUM 6) (PROGN
    (SETQ P5  (LIST (+ (CAR P4) L5  ) (CADR P4 )))
    (SETQ P51 (LIST (+ (CAR P41) L5 ) (CADR P41)))
    (COMMAND "LINE" P5  P51  "")
   ))
   (IF (>= NUM 7) (PROGN
    (SETQ P6  (LIST (+ (CAR P5) L6  ) (CADR P5 )))
    (SETQ P61 (LIST (+ (CAR P51) L6 ) (CADR P51)))
    (COMMAND "LINE" P6  P61  "")
   ))
   (IF (>= NUM 8) (PROGN
    (SETQ P7  (LIST (+ (CAR P6) L7  ) (CADR P6 )))
    (SETQ P71 (LIST (+ (CAR P61) L7 ) (CADR P61)))
    (COMMAND "LINE" P7  P71  "")
   ))
   (IF (>= NUM 9) (PROGN
    (SETQ P8  (LIST (+ (CAR P7) L8  ) (CADR P7 )))
    (SETQ P81 (LIST (+ (CAR P71) L8 ) (CADR P71)))
    (COMMAND "LINE" P8  P81  "")
   ))
   (IF (>= NUM 10) (PROGN
    (SETQ P9  (LIST (+ (CAR P8) L9  ) (CADR P8 )))
    (SETQ P91 (LIST (+ (CAR P81) L9 ) (CADR P81)))
    (COMMAND "LINE" P9  P91  "")
   ))
   (IF (>= NUM 11) (PROGN
    (SETQ P10 (LIST (+ (CAR P9) L10 ) (CADR P9 )))
    (SETQ P101 (LIST (+ (CAR P91) L10) (CADR P91)))
    (COMMAND "LINE" P10 P101 "")
   ))
   (IF (>= NUM 12) (PROGN
    (SETQ P11 (LIST (+ (CAR P10) L11 ) (CADR P10)))
    (SETQ P111 (LIST (+ (CAR P101) L11) (CADR P101)))
    (COMMAND "LINE" P11 P111 "")
   ))
   (IF (>= NUM 13) (PROGN
    (SETQ P12 (LIST (+ (CAR P11) L12 ) (CADR P11)))
    (SETQ P121 (LIST (+ (CAR P111) L12) (CADR P111)))
    (COMMAND "LINE" P12 P121 "")
   ))

   (IF (= DELTA 1) (PROGN
    (SETQ IM (ITOA (FIX WW )))
    (SETQ PIM  (LIST  (+ (CAR PS) (/ L1 2)) (+ (CADR PS ) (/ HI 2))  ))
    (COMMAND "TEXT" "M" PIM TI "0" IM)
    (SETQ WW (+ WW 1))
   ))

   (SETQ MP PTS)
   (SETQ PS PTS)

  );ENDREPEAT NR
      (SETQ FFPS (OPEN FPS "w"))
      (SETQ MPX (RTOS (CAR MP ) 2))
      (SETQ MPY (RTOS (CADR MP ) 2))
      (WRITE-LINE MPX FFPS)
      (WRITE-LINE MPY FFPS)
      (CLOSE FFPS)
);ENDDEFUN
;------------------------------------------------
(DEFUN TEXTPUT ()
   (SETQ PV   (LIST (+ (CAR PT) L1)  (+ (CADR PT) (/ HI 2) )      ))
   (SETQ PUT1 (LIST (+ (CAR PV) (/ L2 2))   (CADR PV)             ))
   (SETQ PUT2 (LIST (+ (CAR PV) L2 (/ L3 2))   (CADR PV)          ))
   (SETQ PUT3 (LIST (+ (CAR PV) L2 L3 (/ L4 2))   (CADR PV)       ))
   (SETQ PUT4 (LIST (+ (CAR PV) L2 L3 L4 (/ L5 2))   (CADR PV)    ))
   (SETQ PUT5 (LIST (+ (CAR PV) L2 L3 L4 L5 (/ L6 2))   (CADR PV) ))
   (SETQ K (+ L2 L3 L4 L5 L6))
   (SETQ PUT6 (LIST (+ (CAR PV) K (/ L7 2))   (CADR PV) ))
   (SETQ K (+ K L7))
   (SETQ PUT7 (LIST (+ (CAR PV) K (/ L8 2))   (CADR PV) ))
   (SETQ K (+ K L8 ))
   (SETQ PUT8 (LIST (+ (CAR PV) K (/ L9 2))   (CADR PV) ))
   (SETQ K (+ K L9))
   (SETQ PUT9 (LIST (+ (CAR PV) K (/ L10 2))   (CADR PV) ))
   (SETQ K (+ K L10))
   (SETQ PUT10 (LIST (+ (CAR PV) K (/ L11 2))   (CADR PV) ))
   (SETQ K (+ K L11))
   (SETQ PUT11 (LIST (+ (CAR PV) K (/ L12 2))   (CADR PV) ))
   (SETQ K (+ K L12))
   (SETQ PUT12 (LIST (+ (CAR PV) K (/ L13 2))   (CADR PV) ))
);ENDDEFUN
;-------------------------------------------------------------------
(DEFUN WRITE ()
 (SETQ WO1 NIL WO2 NIL WO3 NIL WO4 NIL WO5 NIL WO6 NIL WO7 NIL WO8 NIL
       WO9 NIL WO10 NIL WO11 NIL WO12 NIL  )

 (MENUCMD "S=DABLIST")

 (IF (>= NUM 2) (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 1:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST1 ":" ))
  (SETQ WO1 (GETSTRING 1 ))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT1 TI "0" WO1) )
 ))

 (IF (>= NUM 3) (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 2:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST2 ":"))
  (SETQ WO2 (GETSTRING 1 ))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT2 TI "0" WO2) )
 ))

 (IF (>= NUM 4)  (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 3:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST3 ":"))
  (SETQ WO3 (GETSTRING 1 ))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT3 TI "0" WO3) )
 ))

 (IF (>= NUM 5) (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 4:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST4 ":"))
  (SETQ WO4 (GETSTRING 1 ))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT4 TI "0" WO4) )
 ))

 (IF (>= NUM 6) (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 5:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST5 ":"))
  (SETQ WO5 (GETSTRING 1 ))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT5 TI "0" WO5) )
 ))

 (IF (>= NUM 7)  (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 6:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST6 ":"))
  (SETQ WO6 (GETSTRING 1 ))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT6 TI "0" WO6) )
 ))

 (IF (>= NUM 8) (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 7:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST7 ":"))
  (SETQ WO7 (GETSTRING 1 ))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT7 TI "0" WO7) )
 ))

 (IF (>= NUM 9)  (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 8:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST8 ":"))
  (SETQ WO8 (GETSTRING 1))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT8 TI "0" WO8) )
 ))

 (IF (>= NUM 10)  (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 9:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST9 ":"))
  (SETQ WO9 (GETSTRING 1))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT9 TI "0" WO9 ) )
 ))

 (IF (>= NUM 11) (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 11:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST10 ":"))
  (SETQ WO10 (GETSTRING 1))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT10 TI "0" WO10) )
 ))

 (IF (>= NUM 12) (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 12:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST11 ":"))
  (SETQ WO11 (GETSTRING 1 ))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT11 TI "0" WO11) )
 ))

 (IF (>= NUM 13) (PROGN
 ;(PROMPT "\nPLEASE INPUT BILL TABLET FORM 13:\n")
  (PROMPT "\n")
  (PROMPT (STRCAT ST12 ":"))
  (SETQ WO12 (GETSTRING 1 ))
  (IF (AND (/= WO1 NIL) (/= WO1 "") ) (COMMAND "TEXT" "M" PUT12 TI "0" WO12) )
 ))

);ENDDEFUN
;--------------------------------------------------------------------
(DEFUN HEAD ()
  (SETQ PWWW (LIST  (+ (CAR P) (/ L1 2)) (+ (CADR P) (/ HI 2))  ))
                  (COMMAND "TEXT" "M" PWWW  TI  "0" HST )
  (IF (>= NUM 2 ) (COMMAND "TEXT" "M" PUT1  TI  "0" ST1 )  )
  (IF (>= NUM 3 ) (COMMAND "TEXT" "M" PUT2  TI  "0" ST2 )  )
  (IF (>= NUM 4 ) (COMMAND "TEXT" "M" PUT3  TI  "0" ST3 )  )
  (IF (>= NUM 5 ) (COMMAND "TEXT" "M" PUT4  TI  "0" ST4 )  )
  (IF (>= NUM 6 ) (COMMAND "TEXT" "M" PUT5  TI  "0" ST5 )  )
  (IF (>= NUM 7 ) (COMMAND "TEXT" "M" PUT6  TI  "0" ST6 )  )
  (IF (>= NUM 8 ) (COMMAND "TEXT" "M" PUT7  TI  "0" ST7 )  )
  (IF (>= NUM 9 ) (COMMAND "TEXT" "M" PUT8  TI  "0" ST8 )  )
  (IF (>= NUM 10) (COMMAND "TEXT" "M" PUT9  TI  "0" ST9 )  )
  (IF (>= NUM 11) (COMMAND "TEXT" "M" PUT10 TI  "0" ST10)  )
  (IF (>= NUM 12) (COMMAND "TEXT" "M" PUT11 TI  "0" ST11)  )
  (IF (>= NUM 13) (COMMAND "TEXT" "M" PUT12 TI  "0" ST12)  )
          (SETQ DELTA 1)
);ENDDEFUN
