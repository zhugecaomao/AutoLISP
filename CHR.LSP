(defun c:CHR (/ n obl ocm olderr s ss r cpt)
  (setq olderr *error* *error* ai_abort  
        ocm (getvar "cmdecho")   obl (getvar "blipmode")
        oco (getvar "cecolor"))
  (setvar "cmdecho" 0)        (command "_.UNDO" "_GROUP")    (setvar "blipmode" 0) 
  (setq r (getreal "\n«Î ‰»Î÷ÿª≠‘≤µƒ∞Îæ∂:"))
  (princ "\n«Î—°‘Ò‘≤:")
  (setq n 0 ss (ssget))
  (repeat (sslength ss)
    (setq s (entget (ssname ss n)))     
    (setq cpt (cdr (assoc 10 s)))
    (command "circle" cpt r)
    (setq n (1+ n))
  )
  (setq *error* olderr)
  (setvar "cmdecho" ocm) (setvar "blipmode" obl) (setvar "cecolor" oco)
  (setq *error* olderr) (command "_.UNDO" "_E")
  (princ)
)

;*** ∫Û– ***
(princ "\n  Type-------------< CHR >   to run this program.") 
(princ)


