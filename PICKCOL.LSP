(defun c:pickcol ()
(prompt "Pick an entity :")
(setq sl (entget (car (entsel))))
(setq co (cdr (assoc 62 sl)))
(setq sl (ssget "x" (list (cons 62 co))))
)
