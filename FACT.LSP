;  This is a programming example of a recursive function
;  which calculates the factorial of an integer.

(defun factor (y)
   (cond ((= 0 y) 1)
         (t  (* y (factor (1- y))))
   )
)

(defun C:FACT (/ x)
   (initget 7)     ;x must not be null, negative or zero
   (setq x (getint "Enter an integer: "))
   (factor (float x))
)
