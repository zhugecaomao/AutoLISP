(DEFUN C:cp ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "cp")
     (std-1)
     (SETQ XR5 (/ XR 5))
     (SETQ YR12 (/ XR5 4.5))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR5)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR12)) 1))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "a13" "b12" "c08" "c21" "EXIT"))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "a12" "b11" "c07" "c20" "EXIT"))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "a11" "b10" "c06" "c19" "EXIT"))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "a10" "b09" "c05" "c18" "NEXT"))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "a09" "b08" "c04" "c17" "NEXT"))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "a08" "b07" "c03" "c16" "NEXT"))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "a07" "b06" "c02" "c15" "LAST"))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "a06" "b05" "c01" "c14" "LAST"))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "a05" "b04" "b17" "c13" "LAST"))))
          (IF (= JA 10) (SETQ DS (NTH IA
              (LIST "a04" "b03" "b16" "c12" ""))))
          (IF (= JA 11) (SETQ DS (NTH IA
              (LIST "a03" "b02" "b15" "c11" ""))))
          (IF (= JA 12) (SETQ DS (NTH IA
              (LIST "a02" "b01" "b14" "c10" ""))))
          (IF (= JA 13) (SETQ DS (NTH IA
              (LIST "a01" "a14" "b13" "c09" ""))))
            ))
         (setq ds1 (substr ds 1 1))
         (IF (or (= ds1 "a") (= ds1 "b") (= ds1 "c"))(PROGN
           (redraw)
           (SETQ PO (GETPOINT "\nInsert Base Point :"))
           (COMMAND "INSERT" DS PO "" "" "")))
         (IF (= DS "NEXT")(if (null c:cp-2) (progn (load "cp-2") (c:cp-2)) (c:cp-2)))
         (IF (= DS "LAST")(C:STD))
         (if (= DS "EXIT")(redraw))
)
