(DEFUN C:CHGSTY ()
(COMMAND "SETVAR" "HIGHLIGHT" "1")
(COMMAND "SETVAR" "CMDECHO" "1")
(MENUCMD "S=X")
(MENUCMD "S=CHGSTY")
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(COMMAND "SELECT" "AU" "\\")
(SETQ FNT (GETSTRING"\nPease input Style:"))
(SETQ SA (SSGET "P" ))                ;select entity
(SETQ N (SSLENGTH SA))                ;LIST HOW MANY SELECT
(SETQ I 0)                            ;FIRST ENTITY
(REPEAT N
   (SETQ NA (ENTGET (SSNAME SA I)))                    ;GET ENTITY NAME
   (SETQ I (+ 1 I))
   (SETQ NB (ASSOC 0 NA))
   (IF (= "TEXT" (CDR NB))
       (PROGN
          (SETQ TH (ASSOC 40 NA))
          (SETQ TH (CDR TH1))
          (SETQ NA (SUBST (CONS 7 FNT) (ASSOC 7 NA) NA))
          (ENTMOD NA)
       )
   )
)
(COMMAND "SETVAR" "HIGHLIGHT" "1")
)
