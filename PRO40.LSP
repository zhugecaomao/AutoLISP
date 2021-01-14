(DEFUN C:RP ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "RP")
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
		    "" "" "" ))))
	  (IF (= JA 3) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "" "" "" ))))
	  (IF (= JA 4) (SETQ DS (NTH IA
	      (LIST "" "" ""
		    "" "" "" ))))
	  (IF (= JA 5) (SETQ DS (NTH IA
	      (LIST "" "" "RP30D"
		    "RP30C" "RP30B" "RP30A" ))))
	  (IF (= JA 6) (SETQ DS (NTH IA
	      (LIST "" "" "RP25D"
		    "RP25C" "RP25B" "RP25A" ))))
	  (IF (= JA 7) (SETQ DS (NTH IA
	      (LIST "" "" "RP20D"
		    "RP20C" "RP20B" "RP20A" ))))
	  (IF (= JA 8) (SETQ DS (NTH IA
	      (LIST "" "" "RP15D"
		    "RP15C" "RP15B" "RP15A" ))))
	  (IF (= JA 9) (SETQ DS (NTH IA
	      (LIST "" "" "RP12D"
		    "RP12C" "RP12B" "RP12A" ))))
	    (REDRAW)))
	 (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "RP")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Return Pin Base Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)
