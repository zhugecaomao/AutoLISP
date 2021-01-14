(defun c:an( / h p0 p1 p2 p3 p4 pt1 pt2 )
   (setq h (getvar "textsize"))
   (command "osnap" "inter,end")
   (setq p0 (getpoint "\pick the base point"))
   (setq p1 (getpoint "\pick the second point"))
   (command "osnap" "none")
   (setq p2 (getpoint "\pick the dim point"))

   (setvar "aunits" 3)
   (setvar "angbase" (/ pi 2))
   (setvar "auprec" 4)
   (setvar "angdir" 1)
   (setq ang (angle p0 p1))
   (setq an (angtos ang  1 4))
   (setq di (rtos (distance p0 p1) 2 3))

   (setq p3 (polar p2 ang (* 9 h) ) )           
   (setq p4 (polar p3  (+ ang 3) (* 2 h) ))
               
   (setq pt1 (polar p2  (+ ang 0.7) h))
   (setq pt2 (polar p2  (- ang 0.9) (* 2 h)))

   (setvar "angdir" 0)   (setvar "angbase" 0)

   (if (= "d" (substr an 3 1))   (setq an (strcat (substr an 1 2) "%%d" (substr an 4) )   ))
   (if (= "d" (substr an 4 1))   (setq an (strcat (substr an 1 3) "%%d" (substr an 5) )   ))
   (if (= "d" (substr an 2 1))   (setq an (strcat (substr an 1 1) "%%d" (substr an 3) )   ))
   (command "pline" p2 p3 p4 "")       
   (command "text" pt1  ang an "")
   (command "text" pt2  ang di "")
     

   )

