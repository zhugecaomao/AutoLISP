(DEFUN C:GP ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "GP")
     (std-1)
     (SETQ XR6 (/ XR 6))
     (SETQ YR9 (/ XR6 3))
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR6)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1));))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "" "" "" ""
                    "" ""  ))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "" "" "" ""
                    "" ""))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "" "" "" ""
                    "" "" ))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "" "" "" "" ""
                    "" "" ))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "" "" "" ""
                    "" "" ))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "GP30F" "GP30E" "GP30D"
                    "GP30C" "GP30B" "GP30A"  ))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "GP25F" "GP25E" "GP25D"
                    "GP25C" "GP25B" "GP25A"  ))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "GP20F" "GP20E" "GP20D"
                    "GP20C" "GP20B" "GP20A"  ))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "GP16F" "GP16E" "GP16D"
                    "GP16C" "GP16B" "GP16A"  ))))
            (REDRAW)))
         (setq ds1 (substr ds 1 2))
         (IF (= ds1 "GP")(PROGN
           (SETQ PO (GETPOINT "\nInsert Guide Bush Base Point :"))
           (COMMAND "INSERT" DS PO "" "" )))
)
