DEFUN C:CLOSELY
(COMMAND "SETVAR" "HIGHLIGHT" "1")
(PROMPT"\nSelect layer to freeze:")
(COMMAND "SELECT" "AU" "\\")
(SETQ SA (SSGET "P" ))
(SETQ N (SSLENGTH SA))
(SETQ I 0)
(REPEAT N
  (SETQ NA (ENTGET (SSNAME SA I)))
  (SETQ I (+ 1 I))
  (SETQ LY (ASSOC 8 NA))
  (SETQ LY1 (CDR LY))
  (COMMAND "LAYER" "FREEZE" LY1 "")
)
