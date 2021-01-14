(defun c:wl()
    (COMMAND "VSLIDE" "WL")
    (SETVAR "CMDECHO" 0)
     (std-1)
     (SETQ XR9 (/ XR 9))
     (SETQ YR9 (/ XR9 2))
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
	  (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR9)))
	  (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1));))
	  (IF (= JA 1) (SETQ DS (NTH IA
	      (LIST "" "" "" "" ""
		    "" "" "" "" ))))
	  (IF (= JA 2) (SETQ DS (NTH IA
	      (LIST "" "" "" "" ""
		    "" "" "" "" ))))
	  (IF (= JA 3) (SETQ DS (NTH IA
	      (LIST "" "" "" "" ""
		    "" "" "" "" ))))
	  (IF (= JA 4) (SETQ DS (NTH IA
	      (LIST "" "" "WL16G" "WL16F" "WL16E"
		    "WL16D" "WL16C" "WL16B" "WL16A" ))))
	  (IF (= JA 5) (SETQ DS (NTH IA
	      (LIST "" "" "WL14G" "WL14F" "WL14E"
		    "WL14D" "WL14C" "WL14B" "WL14A" ))))
	  (IF (= JA 6) (SETQ DS (NTH IA
	      (LIST "" "" "WL12G" "WL12F" "WL12E"
		    "WL12D" "WL12C" "WL12B" "WL12A" ))))
	  (IF (= JA 7) (SETQ DS (NTH IA
	      (LIST "" "" "WL10G" "WL10F" "WL10E"
		    "WL10D" "WL10C" "WL10B" "WL10A" ))))
	  (IF (= JA 8) (SETQ DS (NTH IA
	      (LIST "" "" "WL08G" "WL08F" "WL08E"
		    "WL08D" "WL08C" "WL08B" "WL08A" ))))
	  (IF (= JA 9) (SETQ DS (NTH IA
	      (LIST "" "" "WL06G" "WL06F" "WL06E"
		    "WL06D" "WL06C" "WL06B" "WL06A" ))))
	    (REDRAW)))
	 (IF (/= DS "")(PROGN
	   (SETQ PO (GETPOINT "\nINSERT POINT :"))
	   (COMMAND "INSERT" DS PO "" "" )))
)



