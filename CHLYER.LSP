(DEFUN C:CHLYER()
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(GRAPHSCR) (TERPRI)                   ;GRAPHICS MODE
(PROMPT"\nSelect layer to be changed:")
(SETQ V1 (CDR (ASSOC 8 (ENTGET (CAR (ENTSEL)))))) ;LAYER
(SETQ V2 (SSGET "X" (LIST (CONS 8 V1))));CADR
(PROMPT"\n") (PROMPT V1) (PROMPT" Will be changed")
(SETQ CHLY (GETSTRING"\nChange to which layer?:"))
(PROMPT"\nSelect entity to change:")
(COMMAND "SELECT" "AU" "\\")
(SETQ SA (SSGET "P" ))                ;select entity
(SETQ N (SSLENGTH SA))                ;LIST HOW MANY SELECT
(SETQ I 0)                                 ;FIRST ENTITY
(REPEAT N
  (SETQ NA (ENTGET (SSNAME SA I)))      ;GET ENTITY NAME
  (SETQ I (+ 1 I))
  (SETQ NB (ASSOC 8 NA))
  (IF (= V1 (CDR NB))
      (PROGN
         (SETQ TH (ASSOC 8 NA))
         (SETQ NA (SUBST (CONS 8 CHLY) (ASSOC 8 NA) NA))
         (ENTMOD NA)
      )
  )
)
)
