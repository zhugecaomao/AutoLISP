DEFUN C:CHGRAD
(COMMAND "SETVAR" "HIGHLIGHT" "1")
(COMMAND "SELECT" "AU" "\\")
(SETQ SA (SSGET "P" ))
(SETQ N (SSLENGTH SA))
(SETQ I 0)
(REPEAT N
  (SETQ NA (ENTGET (SSNAME SA I)))
  (SETQ I (+ 1 I))
  (SETQ NB (ASSOC 0 NA))
  (IF (OR (= "CIRCLE" (CDR NB)) (= "ARC" (CDR NB)))
      (PROGN
          (SETQ NP1 (ASSOC 40 NA))
          (SETQ OLDR (CDR NP1))
         ;(PROMPT PROMPT"\nCIRCLE OF
          (SETQ NEWR NIL)
          (SETQ NEWR (GETREAL (STRCAT "\nNEW RAD<" (rtos OLDR 2 4) "> :")))
          (IF (NULL NEWR)
              (SETQ NEWR NIL)
          )
         (IF (/= NEWR NIL)
             (ENTMOD (SUBST (CONS 40 NEWR)  NP1  NA))
         )
      )
  )
)
