(DEFUN C:EJ ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "EJ")
     (std-1)
     (SETQ XR18 (/ XR 18))
     (SETQ YR9 XR18)
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR18)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1));))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "" "" "EJ2-6" "" "" "EJ1-6" ""
                    "" "" "" "" "" "" ""
                    "EJ05B" "" "" "EJ06A" ))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "" "EJ2-20" "EJ2-5" "" "EJ1-20" "EJ1-5" ""
                    "" "" "" "" "" "" ""
                    "EJ45B" "" "EJ20A" "EJ05A" ))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "" "EJ2-18" "EJ2-4.5" "" "EJ1-18" "EJ1-4.5" ""
                    "" "" "" "" "" "" ""
                    "EJ04B" "" "EJ18A" "EJ45A" ))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "" "EJ2-16" "EJ2-4" "" "EJ1-16" "EJ1-4" ""
                    "" "" "" "" "" "" ""
                    "EJ35B" "" "EJ16A" "EJ04A" ))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "" "EJ2-14" "EJ2-3.5" "" "EJ1-14" "EJ1-3.5" ""
                    "" "" "" "" "" "" ""
                    "EJ03B" "" "EJ14A" "EJ35A" ))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "" "EJ2-12" "EJ2-3" "" "EJ1-12" "EJ1-3" "EJ08D"
                    "EJ08D" "EJ08D" "" "" "" "" ""
                    "EJ25B" "" "EJ12A" "EJ03A" ))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "" "EJ2-10" "EJ2-2.5" "" "EJ1-10" "EJ1-2.5" "EJ07D"
                    "EJ07D" "EJ07D" "EJ10C" "EJ10C" "EJ10C" "" ""
                    "EJ02B" "" "EJ10A" "EJ25A" ))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "" "EJ2-8" "EJ2-2" "" "EJ1-8" "EJ1-2" "EJ06D"
                    "EJ06D" "EJ06D" "EJ08C" "EJ08C" "EJ08C" "" ""
                    "EJ15B" "" "EJ08A" "EJ02A" ))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "" "EJ2-7" "EJ2-1.5" "" "EJ1-7" "EJ1-1.5" "EJ05D"
                    "EJ05D" "EJ05D" "EJ06C" "EJ06C" "EJ06C" "" "EJ06B"
                    "EJ01B" "" "EJ07A" "EJ15A" ))))
            (REDRAW)))
             (SETQ DS1 (substr ds 1 4))
             (setq ds2 (substr ds 1 2))
         (if (= ds1 "EJ1-") (progn
                       (SETQ PO (GETPOINT "\nINSERT POINT :"))
                       (setq sd (substr ds 5 3))
                         (atof sd)
                         (command "insert" "ej1" po sd "" "")))
         (if (= ds1 "EJ2-") (progn
                       (SETQ PO (GETPOINT "\nINSERT POINT :"))
                       (setq sd (substr ds 5 3))
                         (atof sd)
                         (command "insert" "ej2" po sd "" "")))
        (if (and (= ds2 "EJ") (/= ds1 "EJ1-") (/= ds1 "EJ2-"))
                 (progn
                 (SETQ PO (GETPOINT "\nINSERT POINT :"))
                 (COMMAND "INSERT" DS PO "" "" )))
)
