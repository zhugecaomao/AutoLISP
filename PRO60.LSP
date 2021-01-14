(DEFUN C:LO ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "LO")
     (std-1)
     (SETQ XR3 (/ XR 3))
     (SETQ YR9 (/ XR3 6))
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR3)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1));))
	  (IF (= JA 1) (SETQ DS (NTH IA
	      (LIST "" "" ""))))
	  (IF (= JA 2) (SETQ DS (NTH IA
	      (LIST "" "" ""))))
	  (IF (= JA 3) (SETQ DS (NTH IA
	      (LIST "" "" ""))))
	  (IF (= JA 4) (SETQ DS (NTH IA
	      (LIST "" "" ""))))
	  (IF (= JA 5) (SETQ DS (NTH IA
	      (LIST "" "" ""))))
	  (IF (= JA 6) (SETQ DS (NTH IA
	      (LIST "" "" "LO200"))))
	  (IF (= JA 7) (SETQ DS (NTH IA
	      (LIST "" "" "LO175"))))
	  (IF (= JA 8) (SETQ DS (NTH IA
	      (LIST "" "" "LO150"))))
	  (IF (= JA 9) (SETQ DS (NTH IA
	      (LIST "" "" "LO100"))))
	    (REDRAW)))
	  (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "LO")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Locating Ring Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)
