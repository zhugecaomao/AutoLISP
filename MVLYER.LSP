;-------
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
;Move the entities having the same layer of selected entity
(DEFUN C:MVLYER()
  (MENUCMD "S=X")
  (PROMPT "Select layer to be moveing")
  (SETQ D1 (CDR (ASSOC 8 (ENTGET (CAR (ENTSEL))))))
  (SETQ D2 (SSGET "X" (LIST (CONS 8 D1))))
  (PROMPT"\n") (PROMPT D1)(PROMPT"\nWill be moving")
  (COMMAND "SELECT" "AU" "\\")
  (SETQ D3 (GETPOINT "\nBase point"))
  (SETQ D4 (GETPOINT D3 "\nTo point:"))
  (SETQ SA (SSGET "P" ))                ;select entity
  (SETQ N (SSLENGTH SA))                ;LIST HOW MANY SELECT
  (SETQ I 0)                                 ;FIRST ENTITY
  (REPEAT N
    (SETQ NA (ENTGET (SSNAME SA I)))      ;GET ENTITY NAME
    (SETQ I (+ 1 I))
    (SETQ NB (ASSOC 8 NA))
    (SETQ NC (CDR (CAR NA)))
    (IF (= D1 (CDR NB))
        (PROGN
          (SETVAR "CMDECHO" 0)
          (COMMAND "MOVE" NC "" D3 D4)
          )
    )
  )
)
