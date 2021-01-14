(defun c:scr()
   (setq s(getstring "\n Enter screw size: "))
   (setq a(getreal "\n Enter insert angle: "))
   (setq p(getpoint "\n Select insert point: "))
   (command "insert" /acad-r10/basdwg/s p "" "" a)
)
