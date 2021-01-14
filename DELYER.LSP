(DEFUN C:DELYER()
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(GRAPHSCR) (TERPRI)                   ;GRAPHICS MODE
(PROMPT"\nSelect layer to be delete:")
(SETQ V1 (CDR (ASSOC 8 (ENTGET (CAR (ENTSEL)))))) ;LAYER
(SETQ V2 (SSGET "X" (LIST (CONS 8 V1))));CADR
(PROMPT"\n") (PROMPT V1) (PROMPT"\nWill be delete")
(COMMAND "SELECT" "AU" "\\")
(SETQ SA (SSGET "P" ))                ;select entity
(SETQ N (SSLENGTH SA))                ;LIST HOW MANY SELECT
(SETQ I 0)                                 ;FIRST ENTITY
(REPEAT N
  (SETQ NA (ENTGET (SSNAME SA I)))      ;GET ENTITY NAME
  (SETQ I (+ 1 I))
  (SETQ NB (ASSOC 8 NA))
  (SETQ NC (CDR (CAR NA)))
  (IF (= V1 (CDR NB))
      (PROGN
         (ENTDEL NC)
        )
  )
)
)
