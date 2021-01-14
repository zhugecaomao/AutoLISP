;*************	Alex Chiang    88' 12,19
(defun c:dl (/ l s)
     (setvar "cmdecho" 0)
     (setq l (strcase (getstring "\nInput the layer to delete :")))
     (while (not (= (strlen l) 0))
	 (setq s (ssget "x" (list (cons 8 l))))
	 (command "erase" s "")
	 (setq l (strcase (getstring "\nInput the layer to delete :")))
     )
     (setvar "cmdecho" 1)
)

