;--------------------------------------------------------------------
(defun tht()
   (princ "\nDimtxt <") (princ (getvar "dimtxt")) (princ ">: ")
   (setq th (getreal)) (IF (= TH NIL) (SETQ TH (GETVAR "dimtxt")))
)
;--------------------------------------------------------------------
;--------------------------------------------------------------------
(defun postion()
   (princ "\nText Postion  [1] UP [2] CENTER <2>:")
   (setq POS (getreal)) (IF (= POS NIL) (SETQ POS 2))
)
;--------------------------------------------------------------------
;--------------------------------------------------------------------
(defun dimscale()
   (princ "\nDimscale <1>: ")
   (setq dscale (getreal)) (IF (= dscale NIL) (SETQ dscale 1))
)
;--------------------------------------------------------------------
(defun or()
    (setq op (getpoint "\nOrigin Pt: "))
)
;--------------------------------------------------------------------
(defun dig()
   (princ "\nDigital <2> :")
   (setq di (getint)) (if (= di nil) (setq di 2))
)
;--------------------------------------------------------------------
(defun dimex()
   (setq exo (getreal "\nDimEXO <1>:"))
   (IF (= exo nil) (setq exo 1))
)
;--------------------------------------------------------------------
(defun disth(op p)
   (rtos (abs (/ (- (cadr p) (cadr op)) dscale)) 2 di)
)
;--------------------------------------------------------------------
(defun distv(op p)
   (rtos (abs (/ (- (car p) (car op)) dscale)) 2 di)
)
;--------------------------------------------------------------------
(defun ext()
   (setq c1 (getpoint "\nCorner #1 point: "))
   (setq c2 (getcorner c1 "\nCorner #2 point: "))
   (setq c1x (car c1) c2x (car c2) c1y (cadr c1) c2y (cadr c2))
   (if (> c1x c2x) (setq cc c1x c1x c2x c2x cc))
   (if (< c1y c2y) (setq cc c1y c1y c2y c2y cc))
   (setq c1 (list c1x c1y) c2 (list c2x c2y))
   (grdraw c1 (list (car c2) (cadr c1)) 1 1)
   (grdraw (list (car c2) (cadr c1)) c2 1 1)
   (grdraw c2 (list (car c1) (cadr c2)) 1 1)
   (grdraw (list (car c1) (cadr c2)) c1 1 1)
)
;--------------------------------------------------------------------
(defun turnh()
   (COMMAND "OSNAP" OKEY)
    (save_layer) (set_layer dim)
(WHILE T
  (setq p (getpoint "\nPoint To Dim: "))
   (COMMAND "OSNAP" "NONE")
  (setq pP (getpoint "\nNext 1 PT: " p))
  (setq pP1 (getpoint "\nNext 2 PT: " pP))
    (setq Pp (list (car PP) (cadr P)))
   (IF (= (ANGLE P PP) 0) (PROGN
       (COMMAND "LINE" (polar p (dtr 0) exo) PP
		PP1 (setq ep (list (car c2) (cadr Pp1)))
       "")
;RIGHT
(if (= pos 2) (progn
	 (setq textp (rel ep (/ th 2.0) (- 0 (/ th 2.0))))
	 (command "text" textp th "0" (disth op p))
		 )(progn
	 (setq textp (polar ep (dtr 90) 0.6))
	 (command "text" "r" textp th "0" (disth op p))
		  )
   )
			 )(PROGN
       (COMMAND "LINE" (polar p (dtr 180) exo) PP
		     PP1 (setq ep (list (car c1) (cadr Pp1)))
       "")
;LEFT

   (if (= pos 2) (progn
	 (setq textp (rel ep (- 0 (/ th 2.0)) (- 0 (/ th 2.0))))
	 (command "text" "r" textp th "0" (disth op p))
		 )(progn
	 (setq textp (polar ep (dtr 90) 0.6))
	 (command "text" textp th "0" (disth op p))
		  )
   )
			 )
))
)
;--------------------------------------------------------------------
(defun turnV()
   (COMMAND "OSNAP" OKEY)
    (save_layer) (set_layer dim)
(WHILE T
  (setq p (getpoint "\nPoint To Dim: "))
   (COMMAND "OSNAP" OKEY)
  (setq pP (getpoint "\nNext 1 PT: " p))
  (setq pP1 (getpoint "\nNext 2 PT: " pP))
    (setq Pp (list (car P) (cadr PP)))
   (IF (= (ANGLE P PP) (DTR 90)) (PROGN
       (COMMAND "LINE" (polar p (dtr 90) exo) PP
		PP1 (setq ep (list (car PP1) (cadr C1)))
       "")
;UP
   (if (= pos 2) (progn
	 (setq textp (rel ep (/ th 2.0) (/ th 2.0)))
	 (command "text"  textp th "90" (distv op p))
		 )(progn
	 (setq textp (polar ep (dtr 180) 0.6))
	 (command "text" "r" textp th "90" (distv op p))
		  )
   )
			 )(PROGN
       (COMMAND "LINE" (polar p (dtr 270) exo) PP
		     PP1 (setq ep (list (car PP1) (cadr C2)))
       "")
;DOWN
   (if (= pos 2) (progn
	 (setq textp (rel ep (+ 0 (/ th 2.0)) (- 0 (/ th 2.0))))
	 (command "text" "r" textp th "90" (distv op p))
		 )(progn
	 (setq textp (polar ep (dtr 180) 0.6))
	 (command "text" textp th "90" (distv op p))
		  )
   )
			 )
))
)
;--------------------------------------------------------------------
(defun c:right()
   (COMMAND "OSNAP" OKEY)
    (save_layer) (set_layer dim)
  (setq p (getpoint "\nPoint To Dim: "))
  (command "line" (polar p (dtr 0) exo) (setq ep (list (car c2) (cadr p))) "")
   (COMMAND "OSNAP" "NONE")
(if (= pos 2) (progn
	 (setq textp (rel ep (/ th 2.0) (- 0 (/ th 2.0))))
	 (command "text" textp th "0" (disth op p))
		 )(progn
	 (setq textp (polar ep (dtr 90) 0.6))
	 (command "text" "r" textp th "0" (disth op p))
		  )
   )
       (setq p1 ep) (setq exb 8) (setq test 1)
    (while (/= test nil)
   (COMMAND "OSNAP" OKEY)
  (if (/= (setq p (getpoint "\nPoint To Dim: ")) nil) (progn
    (if (> (setq exe (abs (- (cadr p) (cadr p1)))) th) (progn
   (COMMAND "OSNAP" "NONE")
  (command "line" (polar p (dtr 0) exo) (setq ep (list (car c2) (cadr p))) "")
   (if (= pos 2) (progn
	 (setq textp (rel ep (/ th 2.0) (- 0 (/ th 2.0))))
	 (command "text" textp th "0" (disth op p))
		 )(progn
	 (setq textp (polar ep (dtr 90) 0.6))
	 (command "text" "r" textp th "0" (disth op p))
		  )
   )
	(setq p1 ep EXB 8));end progn
 (progn
     (setq EP (POLAR EP (DTR 270) (+ TH 1)))
   (COMMAND "OSNAP" "NONE")
  (command "line" (setq p2 (polar p (dtr 0) exo))
   (setq p2 (list (- (car c2) exb) (cadr p2))) (setq p2 (LIST (+ (CAR P2) 4) (CADR EP)))
		 (setq ep (list (car c2) (cadr p2))) "")
	 (setq textp (rel ep (/ th 2.0) (- 0 (/ th 2.0))))
	 (command "text" textp th "0" (disth op p))
 (SETQ exb (+ exb 1.5))
  (setq p1 ep));END PROGN
 );end if
   (COMMAND "OSNAP" "NONE")
);end progn
	  (progn (setq exb 8 test nil))
);end if
);end while
   (COMMAND "OSNAP" "NONE")(set_layer la)
);end defun
;--------------------------------------------------------------------
(defun c:left()
   (COMMAND "OSNAP" OKEY)
    (save_layer) (set_layer dim)
  (setq p (getpoint "\nPoint To Dim: "))
  (command "line" (polar p (dtr 180) exo) (setq ep (list (car c1) (cadr p))) "")
   (COMMAND "OSNAP" "NONE")
   (if (= pos 2) (progn
	 (setq textp (rel ep (- 0 (/ th 2.0)) (- 0 (/ th 2.0))))
	 (command "text" "r" textp th "0" (disth op p))
		 )(progn
	 (setq textp (polar ep (dtr 90) 0.6))
	 (command "text" textp th "0" (disth op p))
		  )
   )
       (setq p1 ep) (setq exb 8) (setq test 1)
    (while (/= test nil)
   (COMMAND "OSNAP" OKEY)
  (if (/= (setq p (getpoint "\nPoint To Dim: ")) nil) (progn
    (if (> (setq exe (abs (- (cadr p) (cadr p1)))) th) (progn
   (COMMAND "OSNAP" "NONE")
  (command "line" (polar p (dtr 180) exo) (setq ep (list (car c1) (cadr p))) "")
   (if (= pos 2) (progn
	 (setq textp (rel ep (- 0 (/ th 2.0)) (- 0 (/ th 2.0))))
	 (command "text" "r" textp th "0" (disth op p))
		 )(progn
	 (setq textp (polar ep (dtr 90) 0.6))
	 (command "text" textp th "0" (disth op p))
		  )
   )
	(setq p1 ep EXB 8));end progn
 (progn
     (setq EP (POLAR EP (DTR 270) (+ TH 1)))
   (COMMAND "OSNAP" "NONE")
  (command "line" (setq p2 (polar p (dtr 180) exo))
   (setq p2 (list (+ (car c1) exb) (cadr p2))) (setq p2 (LIST (- (CAR P2) 5) (CADR EP)))
		 (setq ep (list (car c1) (cadr p2))) "")
	 (setq textp (rel ep (- 0 (/ th 2.0)) (- 0 (/ th 2.0))))
	 (command "text" "r" textp th "0" (disth op p))
 (SETQ exb (+ exb 1.5))
  (setq p1 ep));END PROGN
 );end if
   (COMMAND "OSNAP" "NONE")
);end progn
	  (progn (setq exb 8 test nil))
);end if
);end while
   (COMMAND "OSNAP" "NONE")
);end defun

;--------------------------------------------------------------------
(defun c:2ph()
   (COMMAND "OSNAP" "NONE") (SETQ P 0 TEST 1)
    (save_layer) (set_layer dim)
(WHILE (/= TEST NIL)
  (setq p (getpoint "\nPoint To Dim: "))
   (IF (/= P NIL) (PROGN
  (setq ep (getpoint "\nEnd Point: "))
  (IF (> (CAR P) (CAR EP)) (PROGN
  (command "line" (polar p (dtr 180) exo) (setq ep (list (car EP) (cadr p))) "")
  (command "text" "r" (rel ep (- 0 (/ th 2.0)) (- 0 (/ th 2.0))) th "0" (disth op p))
			   )(PROGN
  (command "line" (polar p (dtr 0) exo) (setq ep (list (car EP) (cadr p))) "")
  (command "text" (rel ep (/ th 2.0) (- 0 (/ th 2.0))) th "0" (disth op p))
			   )
  );END IF
		  ) (SETQ TEST NIL)
  );END IF
);END WHILE
    (set_layer la)
)
;--------------------------------------------------------------------
(defun c:up()
   (COMMAND "OSNAP" OKEY)
    (save_layer) (set_layer dim)
  (setq p (getpoint "\nPoint To Dim: "))
  (command "line" (polar p (dtr 90) exo) (setq ep (list (car p) (cadr c1))) "")
   (COMMAND "OSNAP" "NONE")
   (if (= pos 2) (progn
	 (setq textp (rel ep (/ th 2.0) (/ th 2.0)))
	 (command "text"  textp th "90" (distv op p))
		 )(progn
	 (setq textp (polar ep (dtr 180) 0.6))
	 (command "text" "r" textp th "90" (distv op p))
		  )
   )
       (setq p1 ep) (setq exb 8) (setq test 1)
    (while (/= test nil)
   (COMMAND "OSNAP" OKEY)
  (if (/= (setq p (getpoint "\nPoint To Dim: ")) nil) (progn
    (if (> (setq exe (abs (- (car p) (car p1)))) th) (progn
   (COMMAND "OSNAP" "NONE")
  (command "line" (polar p (dtr 90) exo) (setq ep (list (car p) (cadr c1))) "")
   (if (= pos 2) (progn
	 (setq textp (rel ep (/ th 2.0) (/ th 2.0)))
	 (command "text"  textp th "90" (distv op p))
		 )(progn
	 (setq textp (polar ep (dtr 180) 0.6))
	 (command "text" "r" textp th "90" (distv op p))
		  )
   )
	(setq p1 ep EXB 8));end progn
 (progn
     (setq EP (POLAR EP (DTR 0) (+ TH 1)))
   (COMMAND "OSNAP" "NONE")
  (command "line" (setq p2 (polar p (dtr 90) exo))
   (setq p2 (list (car p2) (- (cadr c1) exb))) (setq p2 (LIST (CAR ep) (+ 4 (CADR P2))))
	    (setq ep (list (car p2) (cadr c1))) "")
	 (setq textp (rel ep (/ th 2.0) (/ th 2.0)))
	 (command "text"  textp th "90" (distv op p))
 (SETQ exb (+ exb 1.5))
  (setq p1 ep));END PROGN
 );end if
   (COMMAND "OSNAP" "NONE")
);end progn
	  (progn (setq exb 8 test nil))
);end if
);end while
   (COMMAND "OSNAP" "NONE") (set_layer la)
);end defun
;--------------------------------------------------------------------
(defun c:down()
   (COMMAND "OSNAP" OKEY)
    (save_layer) (set_layer dim)
  (setq p (getpoint "\nPoint To Dim: "))
  (command "line" (polar p (dtr 270) exo) (setq ep (list (car p) (cadr c2))) "")
   (COMMAND "OSNAP" "NONE")
   (if (= pos 2) (progn
	 (setq textp (rel ep (+ 0 (/ th 2.0)) (- 0 (/ th 2.0))))
	 (command "text" "r" textp th "90" (distv op p))
		 )(progn
	 (setq textp (polar ep (dtr 180) 0.6))
	 (command "text" textp th "90" (distv op p))
		  )
   )
       (setq p1 ep) (setq exb 8) (setq test 1)
    (while (/= test nil)
   (COMMAND "OSNAP" OKEY)
  (if (/= (setq p (getpoint "\nPoint To Dim: ")) nil) (progn
    (if (> (setq exe (abs (- (car p) (car p1)))) th) (progn
   (COMMAND "OSNAP" "NONE")
  (command "line" (polar p (dtr 270) exo) (setq ep (list (car p) (cadr c2))) "")
   (if (= pos 2) (progn
	 (setq textp (rel ep (+ 0 (/ th 2.0)) (- 0 (/ th 2.0))))
	 (command "text" "r" textp th "90" (distv op p))
		 )(progn
	 (setq textp (polar ep (dtr 180) 0.6))
	 (command "text" textp th "90" (distv op p))
		  )
   )
	(setq p1 ep EXB 8));end progn
 (progn
     (setq EP (POLAR EP (DTR 0) (+ TH 1)))
   (COMMAND "OSNAP" "NONE")
  (command "line" (setq p2 (polar p (dtr 270) exo))
   (setq p2 (list (car p2) (+ (cadr c2) exb))) (setq p2 (LIST (CAR ep) (- (CADR P2) 4)))
	    (setq ep (list (car p2) (cadr c2))) "")
;  (if (= pos 2) (progn
	 (setq textp (rel ep (+ 0 (/ th 2.0)) (- 0 (/ th 2.0))))
	 (command "text" "r" textp th "90" (distv op p))
;		 )(progn
;	 (setq textp (polar ep (dtr 180) 0.6))
;	 (command "text" textp th "90" (distv op p))
;		  )
;  )
 (SETQ exb (+ exb 1.5))
  (setq p1 ep));END PROGN
 );end if
   (COMMAND "OSNAP" "NONE")
);end progn
	  (progn (setq exb 5 test nil))
);end if
);end while
   (COMMAND "OSNAP" "NONE") (set_layer la)
);end defun
;--------------------------------------------------------------------
(defun c:2pv()
   (COMMAND "OSNAP" "NONE") (SETQ P 0 TEST 1)
    (save_layer) (set_layer dim)
(WHILE (/= TEST NIL)
  (setq p (getpoint "\nPoint To Dim: "))
   (IF (/= P NIL) (PROGN
  (setq ep (getpoint "\nEnd Point: "))
  (IF (< (CAdR P) (CAdR EP)) (PROGN
  (command "line" (polar p (dtr 90) exo) (setq ep (list (car P) (cadr ep))) "")
  (command "text" (rel ep (/ th 2.0) (/ th 2.0)) th "90" (distv op p))
			   )(PROGN
  (command "line" (polar p (dtr 270) exo) (setq ep (list (car P) (cadr ep))) "")
  (command "text" "r" (rel ep (/ th 2.0) (- 0 (/ th 2.0))) th "90" (disth op p))
			   )
  );END IF
		  ) (SETQ TEST NIL)
  );END IF  (set_layer la)
);END WHILE
)
;--------------------------------------------------------------------
(defun Cirdim ()
	  (setq e (car (entsel "\nSelct arc or circle: ")))
    (save_layer) (set_layer dim)
  (setq p (cdr (assoc 10 (entget e))))
  (setq rad (cdr (assoc 40 (entget e))))
	 (setq DIS (DISTANCE p(getpoint p "\nEXT PT: ")))
	 (setq textp (rel (POLAR p (DTR 0) DIS) (/ th 2.0) (- 0 (/ th 2.0))))
	 (command "text" textp th "0" (disth op p))
	 (setq textp (rel (POLAR p(DTR 90) DIS) (/ th 2.0) (/ th 2.0)))
	 (command "text" textp th "90" (distv op p))
    (set_layer la)
)
;--------------------------------------------------------------------
(defun Cird ()
	  (setq e (car (entsel "\nSelct arc or circle: ")))
    (save_layer) (set_layer dim)
  (setq p (cdr (assoc 10 (entget e))))
  (setq rad (cdr (assoc 40 (entget e))))
	 (setq DIS (DISTANCE p(getpoint p "\nEXT PT: ")))
	 (setq textp (rel (POLAR p (DTR 180) DIS) (- 0 (/ th 2.0)) (- 0 (/ th 2.0))))
	 (command "text" "R" textp th "0" (disth op p))
	 (setq textp (rel (POLAR p (DTR 270) DIS) (- 0 (/ th 2.0)) (/ th 2.0)))
	 (command "text" "R" textp th "90" (distv op p))
     (set_layer la)
)
;--------------------------------------------------------------------
(defun c:start()
      (tht)
      (dig)
      (or)
      (EXT)
      (dimex)
     (princ "\nOsnap mode = endpoint") (princ)
)
;--------------------------------------------------------------------------------------------
(SETQ POS 2)
(SETQ dscale 1)
(setq okey "endpoint")
