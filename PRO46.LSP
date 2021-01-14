(DEFUN C:SP ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "SP")
     (std-1)
     (SETQ XR6 (/ XR 6))
     (SETQ YR9 (/ XR6 3))
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR6)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1));))
	  (IF (= JA 1) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "" "" "" ))))
	  (IF (= JA 2) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "SP80C" "SP80B" "SP80A"))))
	  (IF (= JA 3) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "SP70C" "SP70B" "SP70A"))))
	  (IF (= JA 4) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "SP60C" "SP60B" "SP60A"))))
	  (IF (= JA 5) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "SP50C" "SP50B" "SP50A"))))
	  (IF (= JA 6) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "SP40C" "SP40B" "SP40A"))))
	  (IF (= JA 7) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "SP35C" "SP35B" "SP35A"))))
	  (IF (= JA 8) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "SP30C" "SP30B" "SP30A"))))
	  (IF (= JA 9) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "SP25C" "SP25B" "SP25A"))))
	    (REDRAW)))
	 (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "SP")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Support Pillar Base Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)
