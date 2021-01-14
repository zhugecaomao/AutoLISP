(DEFUN C:NO ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "NO")
     (std-1)
     (SETQ XR6 (/ XR 6))
     (SETQ YR16 (/ XR6 4))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR6)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR16)) 1))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "016" "032" "" "" "" ""))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "015" "031" "" "" "079" ""))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "014" "030" "" "062" "078" ""))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "013" "029" "" "061" "077" ""))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "012" "028" "" "060" "" ""))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "011" "027" "" "059" "" ""))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "010" "026" "" "058" "" ""))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "009" "025" "041" "057" "" ""))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "008" "024" "040" "056" "" ""))))
          (IF (= JA 10) (SETQ DS (NTH IA
              (LIST "007" "023" "039" "055" "" ""))))
          (IF (= JA 11) (SETQ DS (NTH IA
              (LIST "006" "022" "038" "054" "" ""))))
          (IF (= JA 12) (SETQ DS (NTH IA
              (LIST "005" "021" "037" "053" "" ""))))
          (IF (= JA 13) (SETQ DS (NTH IA
              (LIST "004" "020" "036" "052" "" ""))))
          (IF (= JA 14) (SETQ DS (NTH IA
              (LIST "003" "019" "035" "051" "" ""))))
          (IF (= JA 15) (SETQ DS (NTH IA
              (LIST "002" "018" "034" "050" "" ""))))
          (IF (= JA 16) (SETQ DS (NTH IA
              (LIST "001" "017" "033" "" "" ""))))
            (REDRAW)))
         (setq ds1 (substr ds 1 1))
         (IF (= ds1 "0")(PROGN
           (SETQ PO (GETPOINT "\nInsert Draft Note Base Point :"))
           (COMMAND "INSERT" DS PO "" "" )))
)



