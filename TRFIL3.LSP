(VMON)
;-----------------
;CHAMFER THREE LINES
(DEFUN C:TRFIL3 (/ TC1)
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(IF (= (setq D (getreal "\nPlease Input Value Of Edge/<2>:")) NIL)
    (setq D 2))
  (SETQ TC1 (ENTSEL "\nSelect edge line:"))
  (SETVAR "FILLETRAD" D)
  (SETVAR "FILLETRAD" D)
  (COMMAND "BREAK" TC1 "F" (CADR TC1) "@"
           "FILLET" PAUSE PAUSE
           "FILLET" PAUSE PAUSE
  )
  (PRINC)
)
