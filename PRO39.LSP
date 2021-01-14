(DEFUN C:RL ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "RL")
     (std-1)
     (SETQ XR6 (/ XR 6))
     (SETQ YR7 (/ XR6 2.25))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR6)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR7)) 1))
	  (IF (= JA 1) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "RL12A1" "RL12A"))))
	  (IF (= JA 2) (SETQ DS (NTH IA
	      (LIST "RL10E" "RL10D" "RL10C" "RL10B" "RL10A1" "RL10A"))))
	  (IF (= JA 3) (SETQ DS (NTH IA
	      (LIST "RL08E" "RL08D" "RL08C" "RL08B" "RL08A1" "RL08A"))))
	  (IF (= JA 4) (SETQ DS (NTH IA
	      (LIST "RL06E" "RL06D" "RL06C" "RL06B" "RL06A1" "RL06A"))))
	  (IF (= JA 5) (SETQ DS (NTH IA
	      (LIST "RL05E" "RL05D" "RL05C" "RL05B" "RL05A1" "RL05A"))))
	  (IF (= JA 6) (SETQ DS (NTH IA
	      (LIST "RL04E" "RL04D" "RL04C" "RL04B" "" ""))))
	  (IF (= JA 7) (SETQ DS (NTH IA
	      (LIST "" "RL03D" "" "RL03B" "" ""))))
    (REDRAW)))
	 (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "RL")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Lock Pin Base Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)
