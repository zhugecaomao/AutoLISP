(DEFUN C:ep-2 ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "ep-2")
     (std-1)
     (SETQ XR5 (/ XR 5))
     (SETQ YR12 (/ XR5 4.5))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR5)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR12)) 1))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "c34e" "c47e" "d10e" "" "exit"))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "c33e" "c46e" "d09e" "d22e" "exit"))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "c32e" "c45e" "d08e" "d21e" "exit"))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "c31e" "c44e" "d07e" "d20e" "last"))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "c30e" "c43e" "d06e" "d19e" "last"))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "c29e" "c42e" "d05e" "d18e" "last"))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "c28e" "c41e" "d04e" "d17e" ""))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "c27e" "c40e" "d03e" "d16e" ""))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "c26e" "c39e" "d02e" "d15e" ""))))
          (IF (= JA 10) (SETQ DS (NTH IA
              (LIST "c25e" "c38e" "d01e" "d14e" ""))))
          (IF (= JA 11) (SETQ DS (NTH IA
              (LIST "c24e" "c37e" "c50e" "d13e" ""))))
          (IF (= JA 12) (SETQ DS (NTH IA
              (LIST "c23e" "c36e" "c49e" "d12e" ""))))
          (IF (= JA 13) (SETQ DS (NTH IA
              (LIST "c22e" "c35e" "d48e" "d11e" ""))))
                      ))
         (setq ds1 (substr ds 1 1))
         (IF (OR (= ds1 "c") (= ds1 "d"))(PROGN
            (redraw)
           (SETQ PO (GETPOINT "\nInsert Base Point :"))
           (COMMAND "INSERT" DS PO "" "" "")))
         (IF (= ds "last")(c:cp))
         (if (= ds "exit")(redraw))
)
