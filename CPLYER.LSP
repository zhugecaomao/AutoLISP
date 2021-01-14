;-------
;Move the entities having the same layer of selected entity
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(DEFUN C:CPLYER()
  (MENUCMD "S=X")
  (PROMPT"\nSelect layer to be copyed:")
  (SETQ D5 (ENTSEL))
  (SETQ D1 (CDR (ASSOC 8 (ENTGET (CAR D5)))))
  (SETQ D2 (SSGET "X" (LIST (CONS 8 D1))))
  (PROMPT"\n")(PROMPT D1)(PROMPT" Will be copyed")
  (SETQ CHLY (GETSTRING"\nCopy to which layer?:"))
  (COMMAND "SELECT" "AU" "\\")
  (SETQ ANS (GETSTRING T "\n(1)STILL HERE(2)ANOTHER PLACE?: "))
  (SETQ ANS (STRCASE ANS))
  (IF (= ANS "2")
      (PROGN
        (SETQ D3 (GETPOINT "\nBase point:"))
        (SETQ D4 (GETPOINT D3 "\nTo point:"))
      )
  )
  (IF (= ANS "1")
      (PROGN
        (SETQ D3 (CAR (CDR D5)))
        (SETQ D4 (CAR (CDR D5)))
      )
  )
  (SETQ SA (SSGET "P" ))                ;select entity
  (SETQ N (SSLENGTH SA))                ;LIST HOW MANY SELECT
  (SETQ I 0)                                 ;FIRST ENTITY
  (REPEAT N
    (SETQ NA (ENTGET (SSNAME SA I)))      ;GET ENTITY NAME
    (SETQ I (+ 1 I))
    (SETQ NB (ASSOC 8 NA))
    (IF (= D1 (CDR NB))
        (PROGN
          (SETQ NC (CDR (CAR NA)))
          (SETVAR "CMDECHO" 0)
          (COMMAND "COPY" NC "" D3 D4)
          (SETQ S1 NC)
          (SETVAR "CMDECHO" 0)
;         (IF S1 (COMMAND "CHANGE" "L"  "" "P" "COLOR" "BYLAYER" "LT" "BYLAYER" "LA" CHLY ""))
          (IF S1 (COMMAND "CHANGE" S1  "" "P" "COLOR" "BYLAYER" "LT" "BYLAYER" "LA" CHLY ""))
          (SETVAR "CMDECHO" 1)
          (PRINC)
       )
    )
  )
)
