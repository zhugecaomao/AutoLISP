(DEFUN C:bo ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "bo-1")
     (std-1)
     (SETQ XR6 (/ XR 6.0))
     (SETQ YR18 (/ XR6 4.5))
     (SETQ DS "")
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR6)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR18)) 1))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "" "" "" "REV2E" "PL-BOM-H" ""))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "" "" "" "REV2C" "PL-BOM-E" ""))))
          (IF (= JA 10) (SETQ DS (NTH IA
              (LIST "" "" "" "REV1E" "PL-BOM-C" ""))))
          (IF (= JA 11) (SETQ DS (NTH IA
              (LIST "" "" "" "REV1C" "BOME" ""))))
          (IF (= JA 12) (SETQ DS (NTH IA
              (LIST "" "" "" "A3" "BOMC" ""))))
          (IF (= JA 13) (SETQ DS (NTH IA
              (LIST "" "" "" "A2" "BOM" ""))))
          (IF (= JA 14) (SETQ DS (NTH IA
              (LIST "" "" "" "A1" "MARKE" ""))))
          (IF (= JA 15) (SETQ DS (NTH IA
              (LIST "" "" "" "A0" "MARKC" ""))))
          (IF (= JA 16) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""))))
          (IF (= JA 17) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""))))
          (IF (= JA 18) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""))))
    (REDRAW)))
           (SETQ WS (SUBSTR DS 1 2))
         (IF (AND (/= DS "") (/= WS "12"))(PROGN
           (SETQ PO (GETPOINT "\nInsert Base Point :"))
           (COMMAND "INSERT" DS PO "" "" "")))
        (IF (AND (/= DS "")(= WS "12"))(PROGN
                                       (SETQ NAM (SUBSTR DS 3 2))
                              (SETQ PO (GETPOINT "\nInsert Base Point :"))
                              (COMMAND "INSERT" NAM PO "" "" "")
    (IF (OR (= NAM "WT") (= NAM "DN") (= NAM "MT") (= NAM "TD"))
        (PROGN
        (SETQ IFA 0)
 (SETQ IFA (GETSTRING "\nInsert Draw bord : A0 & A1 & A2 & A3 & A4 & NO(N) .:"))
         (if (AND (OR (/= IFA "N")(/= IFA "n")) (= (SUBSTR IFA 1 1) "A"))
              (PROGN
                     (SETQ ANS (STRCAT NAM IFA))
                     (COMMAND "INSERT" ANS PO "" "" "")
             ))
    (SETQ IFB (GETSTRING "\nInsert Bom : Yes(Y) & No(N) .:"))
         (if (AND (OR (/= IFB "N")(/= IFB "n")) (OR (= IFB "Y") (= IFB "y")))
               (PROGN
                     (SETQ ANS1 (STRCAT NAM "BOM"))
                     (COMMAND "INSERT" ANS1 PO "" "" "")
                     ))
                      )
               )
           )
        )
)
