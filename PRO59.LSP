(DEFUN C:oc ()
      (SETVAR "CMDECHO" 0)
      (COMMAND "VSLIDE" "oc")
      (std-1)
      (SETQ XR2 (/ XR 2))
      (SETQ YR9 (/ XR2 9))
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
    (IF (NULL PT1) (SETQ JA 14) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR2)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1));))
	  (IF (= JA 1) (SETQ DS (NTH IA
				(LIST "" "" ))))
	  (IF (= JA 2) (SETQ DS (NTH IA
				(LIST "" "" ))))
	  (IF (= JA 3) (SETQ DS (NTH IA
				(LIST "" "" ))))
	  (IF (= JA 4) (SETQ DS (NTH IA
				(LIST "oc100b" "oc100a" ))))
	  (IF (= JA 5) (SETQ DS (NTH IA
				(LIST "oc80b" "oc80a" ))))
	  (IF (= JA 6) (SETQ DS (NTH IA
				(LIST "oc63b" "oc63a" ))))
	  (IF (= JA 7) (SETQ DS (NTH IA
				(LIST "oc50b" "oc50a" ))))
	  (IF (= JA 8) (SETQ DS (NTH IA
				(LIST "oc40b" "oc40a" ))))
	  (IF (= JA 9) (SETQ DS (NTH IA
				(LIST "oc32b" "oc32a" ))))
	    (REDRAW)))
	  (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "oc")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Cylinder Base Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)
