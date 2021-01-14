;**********  Alex  Chiang   88' 12,18
;       FREEZED SINGE LAYER
(defun c:fl (/ l)
     (setvar "cmdecho" 0)
     (setq l (getstring "\nInput the layer desired to be freezed :"))
     (while (not (= (strlen l) 0))
	 (command "layer" "f" l "")
	 (setq l (getstring "\nInput the layer desired to be freezed :"))
     )
     (setvar "cmdecho" 1)
)
