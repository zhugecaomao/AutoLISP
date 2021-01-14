(defun c:cham()
 (setvar "cmdecho" 0)
  (setq d1 (getvar "chamfera"))
             (menucmd "s=fil")
  (prompt "\nFirst Chamfers distance <") (prompt (rtos d1 2 2)) (prompt ">: ")
(if (= (setq d (getreal)) nil) (setq d d1))
  (setq d2 (getvar "chamferb"))
  (prompt "\nSecond  Chamfers distance <") (prompt (rtos d2 2 2)) (prompt ">: ")
(if (= (setq d3 (getreal)) nil) (setq d3 d2))

    (setq a 2)
  (while (/= a 1)
    (setq p1 (entsel "\nSelect 1st line: "))

    (if (/= p1 nil) (progn
     (setq p1p (entget (car p1)))
     (setq se1 (osnap (cadr p1) "near"))
     (setq p1s (cdr (assoc 10 p1p)))
     (setq p1e (cdr (assoc 11 p1p)))

    (setq p2 (entsel "\nSelect 2nd line: "))
     (setq p2p (entget (car p2)))
     (setq se2 (osnap (cadr p2) "near"))
     (setq p2s (cdr (assoc 10 p2p)))
     (setq p2e (cdr (assoc 11 p2p)))

    (setq inp (inters p1s p1e p2s p2e nil))
  (setq ang1 (angle inp se1))
  (setq ang2 (angle inp se2))


  (command "chamfer" "d" d d3 "chamfer" se1 se2)
  (save_layer)   (set_layer dim)
     (command "line" inp  (polar inp ang1 (- d 0.8)) "")
     (command "line" inp  (polar inp ang2 (- d3 0.8)) "")
    (set_layer la)
                     )
                (setq a 1)
     );end if
    )
   (menucmd "s= ")
)
