(DEFUN C:K1 ()
     (SETVAR "CMDECHO" 0)
     (COMMAND  "VSLIDE" "KO")
     (std-1)
     (SETQ XR9 (/ XR 9))
     (SETQ YR2 (* XR9 3))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR9)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR2)) 1));))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" "" ""
                    "KO35B" "KO21A" ))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "KO17A" "KO13A" "KO09A" "KO07A" "KO05A"
                    "KO04A" "KO03A" "KO02A" "KO01A" ))))
            (REDRAW)))
         (setq ds1 (substr ds 1 2))
         (IF (= ds1 "KO")(PROGN
           (SETQ PO (GETPOINT "\nInsert K.O Base Point :"))
           (COMMAND "INSERT" DS PO "" "" )))
)
