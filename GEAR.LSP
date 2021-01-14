(defun grinf ()
  (setq cp (getpoint "\nCENTER OF GEAR:"))
  (setq cc (getpoint cp "\nPITCH CIRCLE:"))
  (setq teeth (getint "\nNUMBER OF TEETH: "))
   (while (< teeth 14)
    (setq teeth (getint "\nMUST BE AT LEAST 14 TEETH: "))
   )
)

(defun dtr (a)
  (* pi (/ a 180.0))
)
(defun grcalc ()
   (setq pc (polar cp 0 (distance cp cc)))
   (setq dptch
        (/ teeth (* 2.0 (distance cp pc))))
   (setq htooth
        (/ 0.32 dptch))
   (setq xtooth
        (/ 1.0 dptch))
   (setq side
        (* (/ 2.257 dptch) 1.0642))
)
(defun grdrw ()
   (command "PLINE"
     (polar pc 0 xtooth) "a" "ce" cp "l" htooth "l"
    (polar (getvar "lastpoint")
           (dtr 160)
           side)
    "A"
    "CE"
   cp
   "L"
   htooth
   ""
 )
 (command "MIRROR" "l" "" pc cp "n")
 (command "ARRAY"
    "c"
    (polar pc (dtr 135) side)
    (polar pc (dtr 315) side)
    ""
    "p"
    cp
    teeth
    ""
    "")
  ) ; End of GRDRW function
(defun c:gear ()
   (grinf)
   (setq oldblp (getvar "blipmode"))
   (setq oldech (getvar "cmdecho"))
   (setvar "blipmode" 0)
   (setvar "cmdecho" 0)
    (grcalc)
    (grdrw)
    (setvar "blipmode" oldblp)
    (SEtvar "cmdecho" oldech)
)
