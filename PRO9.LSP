(DEFUN C:cp-2 ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "cp-2")
     (std-1)
     (SETQ XR5 (/ XR 5))
     (SETQ YR12 (/ XR5 4.5))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR5)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR12)) 1))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "c34" "c47" "d10" "" "exit"))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "c33" "c46" "d09" "d22" "exit"))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "c32" "c45" "d08" "d21" "exit"))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "c31" "c44" "d07" "d20" "last"))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "c30" "c43" "d06" "d19" "last"))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "c29" "c42" "d05" "d18" "last"))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "c28" "c41" "d04" "d17" ""))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "c27" "c40" "d03" "d16" ""))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "c26" "c39" "d02" "d15" ""))))
          (IF (= JA 10) (SETQ DS (NTH IA
              (LIST "c25" "c38" "d01" "d14" ""))))
          (IF (= JA 11) (SETQ DS (NTH IA
              (LIST "c24" "c37" "c50" "d13" ""))))
          (IF (= JA 12) (SETQ DS (NTH IA
              (LIST "c23" "c36" "c49" "d12" ""))))
          (IF (= JA 13) (SETQ DS (NTH IA
              (LIST "c22" "c35" "d48" "d11" ""))))
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