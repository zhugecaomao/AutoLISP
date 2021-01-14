(defun C:divl()
   (if (not (null P11))
      (progn
         (setq A1 (- (angle P11 P4) (angle P11 P3)))
         (if (> 0 A1) (setq A1 (+ A1 (* 2 pi))))
         (setq A0 (+ (* 0.5 A1) (angle P11 P3))
               Len (distance P11 P3)
         )
      )
   )
   (command "line" P11 (polar P11 A0 Len) "")
)
