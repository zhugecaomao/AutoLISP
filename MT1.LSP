(defun c:mt1 (/ ts a)
   (setq ts (getstring "\nENTER NEW COLOR:"))
   (setq a (ssget "x" '((0 . "text"))))
   (COMMAND "CHANGE" "P" A "" "P" "C" ts "")
)
