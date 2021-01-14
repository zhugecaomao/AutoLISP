DEFUN C:QCHNG ()
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(COMMAND "SETVAR" "HIGHLIGHT" "1")
(setq po (entget (car (entsel"\nSelect Point:"))))
(setq CIR (entget (car (entsel"\nSelect CIRCLE:"))))
(SETQ po1 (CDR (ASSOC 10 po)))  ;center of circle
(SETQ CIRP (CDR (ASSOC 10 CIR)))  ;center of circle
(SETQ R (CDR (ASSOC 40 CIR))) ;radio of circle
(setq r2 (distance po1 cirp))
(setq r0 (- r2 r))
(command "circle" po1  r0 )
(COMMAND "SETVAR" "HIGHLIGHT" "1")
