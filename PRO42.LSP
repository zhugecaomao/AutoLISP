(DEFUN C:SC ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "SC")
     (std-1)
     (SETQ XR18 (/ XR 18))
     (SETQ YR9 XR18)
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR18)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1));))
	  (IF (= JA 1) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "" "" ""
		    "" "" "SC16E" "" "SC16D" "" "SC16C"
		    "" "SC16B" "" "SC16A" ))))
	  (IF (= JA 2) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "" "" ""
		    "" "" "SC14E" "" "SC14D" "" "SC14C"
		    "" "SC14B" "" "SC14A" ))))
	  (IF (= JA 3) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "" "" "SC48F"
		    "SC48F" "" "SC12E" "" "SC12D" "" "SC12C"
		    "" "SC12B" "" "SC12A" ))))
	  (IF (= JA 4) (SETQ DS (NTH IA
	      (LIST "" "" "" "" "SC20G" "SC20G" "SC36F"
		    "SC36F" "" "SC10E" "" "SC10D" "" "SC10C"
		    "" "SC10B" "" "SC10A" ))))
	  (IF (= JA 5) (SETQ DS (NTH IA
	      (LIST "SC08I" "SC08I" "SC08H" "SC08H" "SC16G" "SC16G" "SC30F"
		    "SC30F" "" "SC08E" "" "SC08D" "" "SC08C"
		    "" "SC08B" "" "SC08A" ))))
	  (IF (= JA 6) (SETQ DS (NTH IA
	      (LIST "SC06I" "SC06I" "SC06H" "SC06H" "SC12G" "SC12G" "SC24F"
		    "SC24F" "" "SC06E" "SC24D" "SC06D" "SC24C" "SC06C"
		    "SC24B" "SC06B" "" "SC06A" ))))
	  (IF (= JA 7) (SETQ DS (NTH IA
	      (LIST "SC05I" "SC05I" "SC05H" "SC05H" "SC10G" "SC10G" "SC20F"
		    "SC20F" "" "SC05E" "SC22D" "SC05D" "" "SC05C"
		    "SC22B" "SC05B" "" "SC05A" ))))
	  (IF (= JA 8) (SETQ DS (NTH IA
	      (LIST "SC04I" "SC04I" "SC04H" "SC04H" "SC08G" "SC08G" "SC16F"
		    "SC16F" "SC20E" "SC04E" "SC20D" "SC04D" "SC20C" "SC04C"
		    "SC20B" "SC04B" "SC20A" "SC04A" ))))
	  (IF (= JA 9) (SETQ DS (NTH IA
	      (LIST "SC03I" "SC03I" "SC03H" "SC03H" "SC06G" "SC06G" "SC12F"
		    "SC12F" "SC18E" "SC03E" "SC18D" "SC03D" "SC18C" "SC03C"
		    "SC18B" "SC03B" "SC18A" "SC03A" ))))
	    (REDRAW)))
	 (setq ds1 (substr ds 1 2))
	 (IF (= ds1 "SC")(PROGN
	   (SETQ PO (GETPOINT "\nInsert Screws Base Point :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)
