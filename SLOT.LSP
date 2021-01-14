(defun C:slot()
   (setq P1 (getpoint "\nCorner 1:"))
   (setq P2 (getcorner P1 "\nCorner 2:"))
   (setq Pl (car P1)
         Pd (cadr P1)
   )
   (if (> Pl (car P2)) (setq Pl (car P2) Pr (car P1)) (setq Pr (car P2)))
   (if (> Pd (cadr P2)) (setq Pd (cadr P2) Pu (cadr P1)) (setq Pu (cadr P2)))
   (setq R (* 0.5 (- Pu Pd))
         Pc (list (* 0.5 (+ Pl Pr)) (* 0.5 (+ Pu Pd)))
   )
   (command "Pline" (list (+ Pl R) Pd) (list (- Pr R) Pd)
            "a" (list (- Pr R) Pu)
            "l" (list (+ Pl R) Pu)
            "a" "cl"
   )
   (setq S1 (ssget "l"))
   (command "rotate" s1 "" Pc pause
            "move" s1 "" Pc pause
            "explode" (cdr (assoc 10 (entget (entnext (entlast)))))
   )
)
