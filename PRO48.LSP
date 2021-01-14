(DEFUN C:ST ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "ST")
     (std-1)
     (SETQ XR6 (/ XR 6))
     (SETQ YRA (* XR6 4))
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR6)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YRA)) 1))
	  (IF (= JA 1) (SETQ DS (NTH IA
	      (LIST "" "" "" "ST16C" "ST16B" "ST16A"))))
	    (REDRAW)))
	 (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "ST")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Stop Pin Base Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)



