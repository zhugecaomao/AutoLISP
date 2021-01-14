(DEFUN C:ep-1 ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "ep-1")
     (std-1)
     (SETQ XR5 (/ XR 5))
     (SETQ YR12 (/ XR5 4.5))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR5)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR12)) 1))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "a13e" "b12e" "c08e" "c21e" "EXIT"))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "a12e" "b11e" "c07e" "c20e" "EXIT"))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "a11e" "b10e" "c06e" "c19e" "EXIT"))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "a10e" "b09e" "c05e" "c18e" "NEXT"))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "a09e" "b08e" "c04e" "c17e" "NEXT"))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "a08e" "b07e" "c03e" "c16e" "NEXT"))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "a07e" "b06e" "c02e" "c15e" "LAST"))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "a06e" "b05e" "c01e" "c14e" "LAST"))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "a05e" "b04e" "b17e" "c13e" "LAST"))))
          (IF (= JA 10) (SETQ DS (NTH IA
              (LIST "a04e" "b03e" "b16e" "c12e" ""))))
          (IF (= JA 11) (SETQ DS (NTH IA
              (LIST "a03e" "b02e" "b15e" "c11e" ""))))
          (IF (= JA 12) (SETQ DS (NTH IA
              (LIST "a02e" "b01e" "b14e" "c10e" ""))))
          (IF (= JA 13) (SETQ DS (NTH IA
              (LIST "a01e" "a14e" "b13e" "c09e" ""))))
                ))
         (setq ds1 (substr ds 1 1))
         (IF (or (= ds1 "a") (= ds1 "b") (= ds1 "c"))(PROGN
           (redraw)
           (SETQ PO (GETPOINT "\nInsert Base Point :"))
           (COMMAND "INSERT" DS PO "" "" "")))
         (IF (= DS "NEXT")(if (null c:ep-2) (progn (load "ep-2") (c:ep-2)) (c:ep-2)))
         (IF (= DS "LAST")(C:STD))
         (if (= DS "EXIT")(redraw))
)



