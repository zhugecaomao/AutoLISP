;**********    Alex  Chiang  88' 12,18
(defun c:tl (/ l)
     (setvar "cmdecho" 0)
     (setq l (getstring "\nInput the layer desired to be thawed :"))
     (while (not (= (strlen l) 0))
	 (command "layer" "t" l "")
	 (setq l (getstring "\nInput the layer desired to be thawed :"))
     )
     (setvar "cmdecho" 1)
)
]