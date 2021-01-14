(DEFUN C:WE ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "WE")
     (std-1)
     (SETQ XR6 (/ XR 6))
     (SETQ YR9 (/ XR6 3))
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR6)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1));))
	  (IF (= JA 1) (SETQ DS (NTH IA
	      (LIST "" "" "" ""
		    "" "" ))))
	  (IF (= JA 2) (SETQ DS (NTH IA
	      (LIST "" "" "" ""
		    "" "" ))))
	  (IF (= JA 3) (SETQ DS (NTH IA
	      (LIST "" "" "" ""
		    "" "" ))))
	  (IF (= JA 4) (SETQ DS (NTH IA
	      (LIST "" "" "" ""
		    "" "" ))))
	  (IF (= JA 5) (SETQ DS (NTH IA
	      (LIST "" "" "" ""
		    "" "" ))))
	  (IF (= JA 6) (SETQ DS (NTH IA
	      (LIST "WE200F" "WE200E" "WE200D" "WE200C"
		    "WE200B" "WE200A" ))))
	  (IF (= JA 7) (SETQ DS (NTH IA
	      (LIST "WE150F" "WE150E" "WE150D" "WE150C"
		    "WE150B" "WE150A" ))))
	  (IF (= JA 8) (SETQ DS (NTH IA
	      (LIST "WE100F" "WE100E" "WE100D" "WE100C"
		    "WE100B" "WE100A" ))))
	  (IF (= JA 9) (SETQ DS (NTH IA
	      (LIST "WE50F" "WE50E" "WE50D" "WE50C"
		    "WE50B" "WE50A" ))))
	    (REDRAW)))
	 (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "WE")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Wedge Base Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)



