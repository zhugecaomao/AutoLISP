;  This is a programming example.
;
;  This is an implementation of a square root function in
;  LISP using the Newton-Raphson method as used in AutoCAD.
;  It is intended as a test of floating point arithmetic in
;  our LISP, as you can check accuracy with the statement:
;     (- (sqr 2) (sqrt 2))
;  which will compare the built-in function with this one.
;
;  John Walker  12/17/84

(defun sqr (x / y c cl)
    (if (or (= 'REAL (type x)) (= 'INT (type x)))
        (progn
            (cond ((minusp x) 'Negative-argument)
                  ((zerop x) 0.0)
                  (t (setq y (/ (+ 0.154116 (* x 1.893872))
                                       (+ 1.0 (* x 1.047988))
                             )
                     )
                     (setq c (/ (- y (/ x y)) 2.0))
                     (setq cl 0.0)
                     (while (not (equal c cl))
                        (setq y (- y c))
                        (setq cl c)
                        (setq c (/ (- y (/ x y)) 2.0))
                     )
                     y
                  )
            )
        )
        (progn
            (princ "Invalid argument.")
            (princ)
        )
    )
)
