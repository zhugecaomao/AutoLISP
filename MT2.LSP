(defun c:mt2 (/ ts a)
   (setq ts (getstring "\nENTER NEW LAYER:"))
   (setq a (ssget "x" (LIST (cons 8 "0") (cons 0 "text"))))
   (COMMAND "CHANGE" "P" A "" "P" "LAYER" ts "")
   (PRINC "\n") (PRINC)
)
