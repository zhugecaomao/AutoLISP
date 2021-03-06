DEFUN C:GRCOPY4
;SET LAYER
(COMMAND "SETVAR" "CMDECHO" 0)
(SETQ NY (GETVAR "CLAYER"))
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(setq G4SET (findfile "/ACAD/HON/SET/G4.SET"))
(IF (= G4SET NIL)
    (PROGN
       (PROMPT "\nPLEASE SETTING LAYER IN GROUP 4:" )
       (SETQ FC (OPEN "/ACAD/HON/SET/G4.SET" "w"))
       (SETQ G4NUM (GETINT"\nHOW MANY LAYERS DO YOU WANT IN GROUP 4:"))
       (WRITE-LINE (ITOA G4NUM) FC)
       (SETQ ORDER 0)
       (REPEAT G4NUM
          (SETQ ORDER (+ ORDER 1))
          (SETQ ORDER1 (STRCAT (ITOA ORDER) "TH"))
          (PROMPT"\nKEYIN LAYER NAME:<")(PROMPT ORDER1)(PROMPT">")
          (SETQ G4LAY (GETSTRING T))
          (IF (= G4LAY "")
              (WRITE-LINE "" FC)
              (WRITE-LINE G4LAY FC)
          )
       )
       (CLOSE FC)
    )
)

 (IF (/= G4SET NIL)
     (PROGN
        (SETQ FC (OPEN "/ACAD/HON/SET/G4.SET" "r"))
        (SETQ G4NUM (READ-LINE FC))
;       (SETQ G4LAY (READ-LINE FC))
        (IF (OR (= G4NUM "") (= G4NUM NIL))
            (PROGN
               (CLOSE FC)
               (COMMAND G4)
            )
        )
       (IF (OR (= G4NUM NIL) (= G4NUM NIL))
         (PROGN
           (PROMPT "\nPLEASE SETTING LAYER IN GROUP 4:" )
           (SETQ FC (OPEN "/ACAD/HON/SET/G4.SET" "w"))
           (SETQ G4NUM (GETINT"\nHOW MANY LAYERS DO YOU WANT IN GROUP 4:"))
           (WRITE-LINE (ITOA G4NUM) FC)
           (SETQ ORDER 0)
           (REPEAT G4NUM
              (SETQ ORDER (+ ORDER 1))
              (SETQ ORDER1 (STRCAT (ITOA ORDER) "TH"))
              (PROMPT"\nKEYIN LAYER NAME:<")(PROMPT ORDER1)(PROMPT">")
              (SETQ G4LAY (GETSTRING T))
              (IF (= G4LAY "")
                  (WRITE-LINE "" FC)
                  (WRITE-LINE G4LAY FC)
              )
           )
           (CLOSE FC)
         )
       )
        (IF (/= G4NUM NIL)
           (PROGN
              (SETQ FC (OPEN "/ACAD/HON/SET/G4.SET" "r"))
              (SETQ G4NUM (READ-LINE FC))
              (SETQ G4NUM (ATOI G4NUM))
              (SETQ FY1 "")
              (SETQ FY "")
              (SETQ P1 (GETPOINT"\nBASE POINT:"))
              (SETQ P2 (GETPOINT P1"\nTO POINT:"))
              (PROMPT"\nGROUP 4 LAYERS HAVE:")
              (PROMPT "<" )
              (REPEAT G4NUM
                 (SETQ G4LAY (READ-LINE FC))

                 (SETQ MAX (GETVAR "EXTMAX"))
                 (SETQ MIN (GETVAR "EXTMIN"))
                 (COMMAND "SELECT" "CROSSING" MIN MAX "")
                 (SETQ LA G4LAY)
                 (SETQ SA (SSGET "X" (LIST (CONS 8 LA))))
                 (IF (/= SA NIL)
                     (PROGN
                       (COMMAND "COPY" SA "" P1 P2)
                       (SETQ SA NIL)
                     )
                 )

                 (SETQ FY (STRCAT G4LAY "," FY))
                 (SETQ FY1 FY)
                 (PROMPT G4LAY)(PROMPT"  ")
                 (IF (= G4LAY "")
                     (PROGN
                       (COMMAND "G4")
                       (SETQ G4NUM 0)
                     )
                 )
              )
              (PROMPT">")
           (CLOSE FC)
           )
        )
     )
 )
