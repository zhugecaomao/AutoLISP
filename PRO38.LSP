(DEFUN C:PL ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "PL")
     (std-1)
     (SETQ XR6 (/ XR 6))
     (SETQ YR9 (/ XR6 3))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR6)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1))
	  (IF (= JA 1) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "" ""))))
	  (IF (= JA 2) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "" ""))))
	  (IF (= JA 3) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "" ""))))
	  (IF (= JA 4) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "" ""))))
	  (IF (= JA 5) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "" ""))))
	  (IF (= JA 6) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "" ""))))
	  (IF (= JA 7) (SETQ DS (NTH IA
	      (LIST "" "" "" "PL20C" "PL20B" "PL20A"))))
	  (IF (= JA 8) (SETQ DS (NTH IA
	      (LIST "" "" "" "PL16C" "PL16B" "PL16A"))))
	  (IF (= JA 9) (SETQ DS (NTH IA
	      (LIST "" "" "" "PL13C" "PL13B" "PL13A"))))
	    (REDRAW)))
	  (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "PL")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Parting Locks Base Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)
