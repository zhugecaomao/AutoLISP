; Converts 2Dlines to 3Dlines with Z coord. set to current elevation
; Ian Kitching June 8, 1987

(DEFUN DRAW ()
(setq a (cdr (assoc 10 get)))
(setq b (cdr (assoc 11 get)))
(setq a (append a ele))
(setq b (append b ele))
(COMMAND "3DLINE" A B)
(COMMAND "")
)
(defun C:CONVERT ()
(setvar "cmdecho" 0)
(prompt "\nCopies line entities from one layer to 3Dlines on another")
        (setq l (strcase (getstring "\nEnter layer name: ")))
        (setq new (strcase (getstring "\nEnter new layer name: ")))
        (setq ele (getvar "elevation")) (setq ele (list ele))
        (command "layer" "m" new)
        (command "")
(setq e (entnext))
        (while e
           (setq get (entget e))
           (if (= l (cdr (assoc 8 get))) (progn
             (setq line (cdr (assoc 0 get)))
           (if (equal line "LINE") (DRAW))
           )
           )
(setq e (entnext e))
        )
(setvar "cmdecho" 1)
)

