(defun c:picklay ()
(prompt "Pick an entity :")
(setq sl (entget (car (entsel))))
(setq la (cdr (assoc 8 sl)))
(setq sl (ssget "x" (list (cons 8 la))))
)
