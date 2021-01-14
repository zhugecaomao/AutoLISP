(defun c:discir ()
(setq P0 (getpoint "first point:"))
(setq p1 (getpoint "\nend point:"))
(setq l (distance p0 p1))
(setq p2 (getpoint "\ncircle center point:"))
(command "circle" p2 l )
(princ)
)
