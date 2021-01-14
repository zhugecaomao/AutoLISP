(defun c:cool()
   (setq s (getstring "\n Enter diameter [6] [8] [10]:"))
   (setq s1 (getreal "\n Enter rotation angle:"))
   (setq p (getpoint "\n Select insert point: "))
   (setq s2 (strcat "/acad-r10/basdwg/" "pt" s))
   (command "insert" s2 p "" "" s1)
)
