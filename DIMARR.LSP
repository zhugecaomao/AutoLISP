DEFUN C:DIMARR
;(SETQ LY (GETSTRING"\nWHICH LAYER ?:"))
(COMMAND "OSNAP" "NEAR")
(SETQ DP (GETPOINT"\nDIMESION FROM:"))
(COMMAND "OSNAP" "NONE")
(SETQ DP1 (GETPOINT DP "\nDIMESION TO:"))
(SETQ DPT (GETPOINT DP "\nDIMESION DIRECT:"))
(SETQ AG1 (ANGLE DP DPT))
(SETQ DOP (GETPOINT"\nORGIN POINT:"))
;(COMMAND "LAYER" "SET" LY "")
(COMMAND "SETVAR" "HIGHLIGHT" "1")
(COMMAND "SELECT" "AU" "\\")
(SETQ SA (SSGET "P" ))                ;select entity
(SETQ N (SSLENGTH SA))                      ;LIST HOW MANY SELECT
(SETQ I 0)                                 ;FIRST ENTITY
(COMMAND "LINE" DP DP1 "")
;========== IF AG1 90 OR 270 DO =====================
(IF (OR (= (RTD AG1) 90) (= (RTD AG1) 90.0) (= (RTD AG1) 270) (= (RTD AG1) 270.0))
  (PROGN
    (REPEAT N
      (SETQ NA (ENTGET (SSNAME SA I)))
      (SETQ I (+ 1 I))
      (SETQ NB (ASSOC 0 NA))
      (IF (= "LINE" (CDR NB))
          (PROGN
              (SETQ NP1 (ASSOC 11 NA))  ;right
              (SETQ NP1 (CDR NP1))      ;right
              (SETQ NP2 (ASSOC 10 NA))  ;left
              (SETQ NP2 (CDR NP2))      ;left
              (SETQ DIMP (LIST (CAR DP) (CADR NP1)))
              (IF (> (CADR NP1) (CADR DOP))
                 (PROGN
                   (SETQ DP1 (POLAR DIMP (DTR 260) 3.03))
                   (SETQ DP2 (POLAR DIMP (DTR 280) 3.03))
                   (SETQ LP (POLAR DIMP (DTR 270) 5.0))
                 )
              )
              (IF (< (CADR NP1) (CADR DOP))
                 (PROGN
                   (SETQ DP1 (POLAR DIMP (DTR 260) -3.03))
                   (SETQ DP2 (POLAR DIMP (DTR 280) -3.03))
                   (SETQ LP (POLAR DIMP (DTR 270) -5.0))
                 )
              )
              (IF (/= (CADR DOP) (CADR DIMP))
                 (PROGN
                    (COMMAND "SOLID" DIMP DP1 DP2 "" "")
;                   (COMMAND "LINE" DP DP1 "")
                 )
              )
          );PROGN
      )
    )
  )
)

;========== IF AG1 0 OR 180 DO =====================
(IF (OR (= (RTD AG1) 0) (= (RTD AG1) 0.0) (= (RTD AG1) 180) (= (RTD AG1) 180.0))
  (PROGN
    (REPEAT N
      (SETQ NA (ENTGET (SSNAME SA I)))
      (SETQ I (+ 1 I))
      (SETQ NB (ASSOC 0 NA))
      (IF (= "LINE" (CDR NB))
          (PROGN
              (SETQ NP1 (ASSOC 11 NA))  ;right
              (SETQ NP1 (CDR NP1))      ;right
              (SETQ NP2 (ASSOC 10 NA))  ;left
              (SETQ NP2 (CDR NP2))      ;left
              (SETQ DIMP (LIST (CAR NP1) (CADR DP)))
              (IF (> (CAR NP1) (CAR DOP))
                 (PROGN
                   (SETQ DP1 (POLAR DIMP (DTR 190) 3.03))
                   (SETQ DP2 (POLAR DIMP (DTR 170) 3.03))
                   (SETQ LP (POLAR DIMP (DTR 180) 5.0))
                 )
              )
              (IF (< (CAR NP1) (CAR DOP))
                 (PROGN
                   (SETQ DP1 (POLAR DIMP (DTR 190) -3.03))
                   (SETQ DP2 (POLAR DIMP (DTR 170) -3.03))
                   (SETQ LP (POLAR DIMP (DTR 180) -5.0))
                 )
              )
              (IF (/= (CAR DOP) (CAR DIMP))
                 (PROGN
                    (COMMAND "SOLID" DIMP DP1 DP2 "" "")
;                   (COMMAND "LINE" DIMP LP "")
                 )
              )
  ;         (COMMAND "POINT" DIMP)
          );PROGN
      )
    )
  )
)

