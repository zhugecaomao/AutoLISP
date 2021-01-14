(DEFUN C:SR ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "SR")
     (std-1)
     (SETQ XR2 (/ XR 2))
     (SETQ YR7 (/ XR2 6.75))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR2)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR7)) 1))
	  (IF (= JA 1) (SETQ DS (NTH IA
	      (LIST "" ""))))
	  (IF (= JA 2) (SETQ DS (NTH IA
	      (LIST "" "SR20B"))))
	  (IF (= JA 3) (SETQ DS (NTH IA
	      (LIST "SR50A" "SR16B"))))
	  (IF (= JA 4) (SETQ DS (NTH IA
	      (LIST "SR40A" "SR12B"))))
	  (IF (= JA 5) (SETQ DS (NTH IA
	      (LIST "SR35A" "SR10B"))))
	  (IF (= JA 6) (SETQ DS (NTH IA
	      (LIST "SR30A" "SR08B"))))
	  (IF (= JA 7) (SETQ DS (NTH IA
	      (LIST "SR25A" "SR06B"))))
	    (REDRAW)))
	 (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "SR")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Spring Base Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)
