(DEFUN C:SE ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "SE")
     (std-1)
     (SETQ XR3 (/ XR 3))
     (SETQ YR10 (/ XR3 5))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR3)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR10)) 1))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "SE10" "" ""))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "SE9" "" ""))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "SE8" "" ""))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "SE7" "SE17" ""))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "SE6" "SE16" ""))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "SE5" "SE15" ""))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "SE4" "SE14" ""))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "SE3" "SE13" ""))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "SE2" "SE12" ""))))
          (IF (= JA 10) (SETQ DS (NTH IA
              (LIST "SE1" "SE11" ""))))
            (REDRAW)))
          (setq ds1 (substr ds 1 2))
         (IF (= ds1 "SE")(PROGN
           (SETQ PO (GETPOINT "\nInsert Section Note Base Point :"))
           (if (= ds "SE9") (progn
                            (setq sl (getint "\nInput scale"))
                            )
                            (setq sl 1)
           )
           (COMMAND "INSERT" DS PO sl "" )))
)



