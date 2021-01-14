(DEFUN C:UP ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "UP")
     (std-1)
     (SETQ XR3 (/ XR 3))
     (SETQ YR7 (/ XR3 4.5))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR3)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR7)) 1))
	  (IF (= JA 1) (SETQ DS (NTH IA
	      (LIST "" "" ""))))
	  (IF (= JA 2) (SETQ DS (NTH IA
	      (LIST "" "" ""))))
	  (IF (= JA 3) (SETQ DS (NTH IA
	      (LIST "UP12C" "UP12B" "UP12A"))))
	  (IF (= JA 4) (SETQ DS (NTH IA
	      (LIST "UP10C" "UP10B" "UP10A"))))
	  (IF (= JA 5) (SETQ DS (NTH IA
	      (LIST "UP08C" "UP08B" "UP08A"))))
	  (IF (= JA 6) (SETQ DS (NTH IA
	      (LIST "UP06C" "UP06B" "UP06A"))))
	  (IF (= JA 7) (SETQ DS (NTH IA
	      (LIST "UP05C" "UP05B" "UP05A"))))
    (REDRAW)))
	 (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "UP")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Base Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)



