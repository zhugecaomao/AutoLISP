(defun LL (A1 B1 C1 A2 B2 C2)
   (setq d (- (* 1.0 a1 b2) (* 1.0 a2 b1)))
   (list (/ (- (* b1 c2) (* b2 c1)) d)
         (/ (- (* a2 c1) (* a1 c2)) d))
)
(defun TL (P1 P2)
   (setq a (- (cadr pp1) (cadr p1)))
   (setq b (- (car p1) (car pp1)))
   (setq c (- (* (cadr p1) (- (car pp1) (car p1))) (* (car p1) (- (cadr pp1) (cadr p1)))))
   (setq pa (+ (* (car p2) (- (car p1) (car pp1))) (* (cadr p2) (- (cadr p1) (cadr pp1)))))
   (setq r (ll a b c (- b) a pa))
   (setq ap (getvar "orthomode"))
   (setvar "orthomode" 0)
   (command "change" p1)
   (command "" r)
   (setvar "orthomode" ap)
)
(defun TA (P1 GP2)
   (setq p2 (osnap p1 "end"))
   (setq gp1 (polar c1 (- (* 2 (angle c1 pp1)) (angle c1 p2)) (distance c1 p1)))
   (setq ad (- (angle c1 pp1) (angle c1 p2)))
   (setq p2 (list (+ (car c1) (* (- (car gp2) (car c1))
                                 (/ (distance c1 p1) (distance gp2 c1))))
                  (+ (cadr c1) (* (- (cadr gp2) (cadr c1))
                                 (/ (distance c1 p1) (distance gp2 c1))))))
   (command "erase" p1)
   (command "")
   (if (or (and (> ad 0) (< ad pi)) (< ad (- pi)))
       (command "arc" p2 "c" c1 gp1)
       (command "arc" gp1 "c" c1 p2))
)
(defun C:TRIM1 ()
   (setvar "osmode" 512)
   (setq p1 (getpoint "\nSelect Object:"))
   (setvar "osmode" 0)
   (setq gp2 (getpoint "\nDigit Trim Point:"))
   (setq c1 (osnap p1 "cen"))
   (setq pp1 (osnap p1 "mid"))
   (if pp1 (if c1 (ta p1 gp2)
                  (tl p1 gp2)))
)
(defun C:POINTER ()
(command "setvar" "cmdecho" 0)
   (setq r1 (getreal "\nRadius <0.3>:"))
   (setq p2 (getpoint  "\nFrom:"))
   (command "layer" "s" 0)
   (command "")
   (if r1 (command "circle" p2 r1)
          (command "circle" p2 0.3))
   (command "layer" "s" "dim")
   (command "")
   (setq pp1 p2)
   (setq p1 p2)
   (command "line" p1)
   (setq p2 (getpoint p1 "\nTo:"))
   (while p2 (command p2)
             (setq pp1 p1)
             (setq p1 p2)
             (setq p2 (getpoint p2)))
   (command "")
   (setq r1 (getreal "\nRadius <6.0>:"))
   (if (not r1) (setq r1 6.0))
   (setq p2 (list (+ (car pp1) (* (- (car p1) (car pp1))
                                 (/ (+ r1 (distance pp1 p1)) (distance pp1 p1))))
                  (+ (cadr pp1) (* (- (cadr p1) (cadr pp1))
                                 (/ (+ r1 (distance pp1 p1)) (distance pp1 p1))))))
   (command "circle" p2 r1)
)
(defun C:DLINE ()
   (setq pi2 (/ pi 2.0))
   (setvar "osmode" 512)
   (setq p1 (getpoint "\nLINE:"))
   (setq p2 (getpoint "\nDIRECTION:"))
   (setvar "osmode" 0)
   (setq l1 (getreal "\nDISTANCE FROM END: "))
   (setq l2 (getreal "\nLENGTH: "))
   (setvar "aperture" 1)
   (setq p3 (osnap p1 "end"))
   (setq t1 (angle p3 p1))
   (setq p1 (polar p3 t1 l1))
   (if (> t1 0.0) (setq t1 (- t1 pi)))
   (setq t2 (angle p3 p2))
   (if (and (> t2 t1) (< t2 (+ t1 pi))) (setq t3 (+ t1 pi2))
                                        (setq t3 (- t1 pi2)))
   (setq p2 (polar p1 t3 l2))
   (command "line" p1 p2)
   (command "")
   (setvar "aperture" 5)
)
(DEFUN *ERROR*(ST1)
   (PRINC "ERROR : ") (PRINC ST1) (TERPRI)
)
(DEFUN TT1 (/ P2 H1)
   (SETQ TL (STRLEN TX))
   (SETQ P2 P1)
   (WHILE (> TL 0)
      (IF (> (ASCII TX) 127)
          (PROGN (SETQ H1 (SUBSTR TX 1 2))
                 (SETQ TX (SUBSTR TX 3))
                 (SETQ TL VC))
          (PROGN (SETQ H1 (SUBSTR TX 1 1))
                 (SETQ TX (SUBSTR TX 2))
                 (SETQ TL (/ VC 2)))
      )
   (IF (/= (ASCII H1) 32) (COMMAND "TEXT" P2 HI RT H1))
   (SETQ P2 (LIST (+ (CAR P2) TL) (CADR P2)))
   (SETQ TL (STRLEN TX))
   )
)
(DEFUN TT2 ()
   (COMMAND "TEXT" P1 HI RT TX)
   (SETQ TX "")
)
(DEFUN DINP (/ H1)
   (SETQ H1 (GETVAR "TEXTSIZE"))
   (SETQ HI (GETREAL (STRCAT "\nTEXT HEIGHT <" (RTOS H1) "> : ")))
   (SETQ RT (GETREAL "\nRotation angle <0> : "))
   (IF (NULL HI) (SETQ HI H1))
   (IF (NULL RT) (SETQ RT 0))
   (SETQ NX (GETSTRING "DO YOU WANT EXPLODED CHARACTER (Y/N) <Y> : "))
   (IF (EQ NX "y") (SETQ NX "Y"))
   (IF (OR (EQ NX "") (EQ NX "Y")) (PROGN (SETQ NX "Y")
       (SETQ H1 (* 1.125 HI))
       (SETQ VC (GETREAL (STRCAT "\nCHARACTER SPACING <" (RTOS H1) "> : ")))
       (IF (NULL VC) (SETQ VC H1))
   ))
   (SETQ H1 (* 1.375 HI))
   (SETQ VI (GETREAL (STRCAT "\nLINE SPACING <" (RTOS H1) "> : ")))
   (IF (NULL VI) (SETQ VI H1))
   (SETQ P1 (GETPOINT "\nStart point : "))
)
(DEFUN C:CFILE ()
   (SETVAR "CMDECHO" 0)
   (SETQ AA (GETSTRING "\nPlease input the file name : "))
   (SETQ F (OPEN AA "r"))
   (IF F (PROGN (PROMPT "\nFILE OPENED")
         (COMMAND "STYLE" "CHINA" "" "" "" "" "" "")
         (SETQ TX (READ-LINE F))
         (DINP)
         (WHILE (/= TX NIL)
            (IF (EQ NX "Y") (TT1) (TT2))
            (SETQ P1 (LIST (CAR P1) (- (CADR P1) VI)))
            (SETQ TX (READ-LINE F))
         )
         (CLOSE F)
         (COMMAND "STYLE" "STANDARD" "" "" "" "" "" ""))
         (*ERROR* (STRCAT " File ---  " AA "  not found.  "))
   )
)
(DEFUN C:CTEXT ()
   (SETVAR "CMDECHO" 0)
   (SETQ VC (GETVAR "VIEWCTR"))
   (SETQ YR (GETVAR "VIEWSIZE"))
   (SETQ VX (GETVAR "VSMAX"))
   (SETQ VI (GETVAR "VSMIN"))
   (SETQ NX (/ (- (NTH 0 VX) (NTH 0 VI))
               (- (NTH 1 VX) (NTH 1 VI)) 1.6494468))
   (SETQ XI (- (NTH 0 VC) (* 0.8247234 NX YR)))
   (SETQ YI (- (NTH 1 VC) (* 0.5 YR)))
   (IF (< NX 1.0) (SETQ YR (* YR NX)))
   (SETQ DX (/ YR 17.111111111))
   (SETQ DY (/ YR 14.0))
   (COMMAND "STYLE" "CHINA" "" "" "" "" "" "")
   (SETQ YR "D:/CTEXT/")
   (DINP)
   (SETQ JA 5)
   (SETQ CT 1) (SETQ TX "")
   (WHILE (OR (< JA 1) (> JA 4))
      (COMMAND "VSLIDE" (STRCAT YR "SEL"))
      (SETQ PT (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
      (IF (NULL PT) (SETQ JA 4) (PROGN
          (SETQ IA (- (FIX (/ (- (NTH 0 PT) XI DX) (* 2.0 DX))) 1))
          (SETQ JA (/ (- 11 (FIX (/ (- (NTH 1 PT) YI) DY))) 2))))
      (IF (AND (>= IA 0) (< IA 11)) (PROGN
          (IF (= JA 1) (SETQ VS (NTH IA
              (LIST "A" "E" " " " " "Q" " " " " "3" "3" "3" "3"))))
          (IF (= JA 2) (SETQ VS (NTH IA
              (LIST "B" "F" "J" "M" "S" "V" "Y" "3" "3" "3" "4"))))
          (IF (= JA 3) (SETQ VS (NTH IA
              (LIST "C" "G" "K" "O" "T" "W" "1" "3" "3" "3" "4"))))
          (IF (= JA 4) (SETQ VS (NTH IA
              (LIST "D" "H" "L" "P" "U" "X" "2" "3" "3" "3" "4"))))
          (IF (EQ VS " ") (SETQ JA 5)
                  (PROGN (SETQ VS (STRCAT YR VS))
                         (COMMAND "VSLIDE" VS)))
      ))
   )
   (SETQ VX (STRCAT YR "4"))
   (WHILE (OR (/= JA 13) (> IA 8))
       (SETQ PT (GETPOINT "\nPLEASE DIGIT THE CHARACTER : "))
       (IF (= PT NIL) (PROGN (SETQ I 12) (SETQ J 13)) (PROGN
           (SETQ I (+ (* (FIX (/ (- (NTH 0 PT) XI) DX)) 2) 1))
           (SETQ J (- 13 (FIX (/ (- (NTH 1 PT) YI) DY))))
       ))
       (SETQ IA I) (SETQ JA J)
       (IF (AND (= J 13) (AND (> I 8) (< I 16))) (PROGN
           (IF (EQ  NX "Y") (TT1) (TT2))
           (SETQ P1 (LIST (CAR P1) (- (CADR P1) VI)))
       ))
       (IF (AND (= J 13) (AND (> I 16) (< I 28))) (PROGN
           (SETQ TL (STRLEN TX))
           (IF (/= VS VX) (SETQ TX (SUBSTR TX 1 (- TL 2)))
                          (SETQ TX (SUBSTR TX 1 (- TL 1)))
           )
       ))
       (IF (< J 12) (PROGN
           (SETQ F (OPEN VS "r"))
           (WHILE (> J 0)
               (SETQ J1 (READ-LINE F))
               (SETQ J (- J 1))
           )
           (WHILE (> I 0)
               (SETQ I1 (READ-CHAR F))
               (SETQ I (- I 1))
           )
           (SETQ TX (STRCAT TX (CHR I1)))
           (IF (/= VS VX) (PROGN
               (SETQ I1 (READ-CHAR F))
               (SETQ TX (STRCAT TX (CHR I1)))
           ))
           (CLOSE F)
       ))
       (IF (= J 12) (PROGN
           (SETQ VS (STRCAT YR (CHR (+ 65 (/ I 2)))))
           (IF (= I 53) (SETQ VS (STRCAT YR "1")))
           (IF (= I 55) (SETQ VS (STRCAT YR "2")))
           (COMMAND "VSLIDE" VS)
       ))
       (IF (AND (= J 13) (> I 48)) (PROGN
           (IF (> I 52) (SETQ VS (STRCAT YR "3"))
                        (SETQ VS VX))
           (COMMAND "VSLIDE" VS)
       ))
   )
   (IF (EQ NX "Y") (TT1) (TT2))
   (COMMAND "STYLE" "STANDARD" "" "" "" "" "" "")
   (REDRAW)
)
