(DEFUN C:GETENY()
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(GRAPHSCR) (TERPRI)                   ;GRAPHICS MODE
(COMMAND "SELECT" "\\")
(SETQ SA (SSGET "P" ))                ;select entity
(SETQ N (SSLENGTH SA))                ;LIST HOW MANY SELECT
(SETQ NA (ENTGET (SSNAME SA 0)))      ;GET ENTITY NAME
)
