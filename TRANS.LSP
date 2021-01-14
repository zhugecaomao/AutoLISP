; This program provides 2-dimesional and 3-dimensional coordinate translation
; rotation. Useful for rotating 3DFACE and 3DLINE entities.

; NOTE !! All points must be 3d points of the form of (x y z).

(defun rotate (axis ang base p / pt xy)
   (setq pt (mapcar '- p base))
   (cond ((or (not ang) (not pt)) nil)
         ((= "X" axis) 
            (setq xy (calang (nth 1 pt) (nth 2 pt) ang))
            (mapcar '+ (list (float (nth 0 pt)) (car xy) (cadr xy)) base)
         )
         ((= "Y" axis) 
            (setq xy (calang (nth 2 pt) (nth 0 pt) ang))
            (mapcar '+ (list (cadr xy) (float (nth 1 pt)) (car xy)) base)
         )
         ((= "Z" axis)
            (setq xy (calang (nth 0 pt) (nth 1 pt) ang))
            (mapcar '+ (list (car xy) (cadr xy) (float (nth 2 p))) base))
   )
)

(defun calang (x y ra / hyp vin)
   (setq ra (* (/ ra 180.0) pi))
   (setq hyp (sqrt (+ (* x x) (* y y))))
   (setq vin (+ (atan y x) ra))
   (setq x (* (cos vin) hyp))
   (setq y (* (sin vin) hyp))
   (list (if (< (abs x) 1e-12) 0.0 x)
         (if (< (abs y) 1e-12) 0.0 y))
)

(defun C:TRANS (/ ax bp el n sl ss v)
   (setq n 0 sl 0)               ; initialize counter & entity count
   (setq ss nil)                 ; set the selection-set to nil
   (if (setq ss (ssget))         ; get some entities
      (progn
         (setq sl (sslength ss)) ; get the number of entities in ss
         (initget 1 "X Y Z")
         (setq ax (getkword "\nAxis (X, Y, or Z): "))
         (initget 1)
         (setq v  (getreal  "\nRotation angle: "))
         (initget (+ 1 16))
         (setq bp (getpoint "\nBase point: "))
      )
   )
   (while (< n sl)
      (setq el (entget (ssname ss n)))
      (cond ((= (cdr (assoc 0 el)) "3DLINE")
             (setq el (subst (cons 10 (rotate ax v bp (cdr (assoc 10 el))))
                             (assoc 10 el) 
                             el
                      )
             )
             (setq el (subst (cons 11 (rotate ax v bp (cdr (assoc 11 el))))
                             (assoc 11 el)
                             el
                      )
             )
             (entmod el)
            )
            ((= (cdr (assoc 0 el)) "3DFACE")
             (setq el (subst (cons 10 (rotate ax v bp (cdr (assoc 10 el)))) 
                             (assoc 10 el) 
                             el
                      )
             )
             (setq el (subst (cons 11 (rotate ax v bp (cdr (assoc 11 el)))) 
                             (assoc 11 el) 
                             el
                      )
             )
             (setq el (subst (cons 12 (rotate ax v bp (cdr (assoc 12 el)))) 
                             (assoc 12 el) 
                             el
                      )
             )
             (if (assoc 13 el)
                (setq el (subst (cons 13 (rotate ax v bp (cdr (assoc 13 el)))) 
                                (assoc 13 el) 
                                el
                         )
                )
             )
             (entmod el)
            )
            (T nil)
      )
      (setq n (1+ n))
   )
   (princ)                       ; exit quietly
)
