(defun c:gc (/ olderr obl ocm s tp tm)
  (setq olderr *error* *error* ai_abort
	ocm (getvar "cmdecho")   obl (getvar "blipmode"))
  (setvar "cmdecho" 0) 		(command "_.UNDO" "_GROUP")  (setvar "blipmode" 0)
	(setq	s (ssget)
		tp (getreal "\n上公差: ")
		tm (getreal "\n下公差: "))
	(command "dim" "dimtol" "1" "dimtp" tp "dimtm" tm "up" s "" 
		"dimtol" "0" "e")
  (setq *error* olderr)
  (setvar "cmdecho" ocm) (setvar "blipmode" obl) (command "_.UNDO" "_E")
	(princ)
)