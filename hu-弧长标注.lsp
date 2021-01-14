;==============================
;          »¡³¤±ê×¢
;==============================
(defun C:hu (/ obj sel el e r ang angs ange larc pnt multi)
  (setvar "CMDECHO" 0)
  (setq multi (getvar 'dimlfac));;;add 2002.5.15 can remove
  (setq obj (entsel "\nSelect ARC:<Exit> "))
  (setq sel (car obj))
  
  (setq pnt (getpoint "point"))
   
  (terpri)
  (if (/= sel nil)
    (progn
      (setq el (entget sel))
       
      (setq e (assoc 0 el))
      (if (= "ARC" (cdr e))
	(progn
	  (setq r (assoc 40 el))
	  (setq r (cdr r))
	  (setq angs (assoc 50 el))
	  (setq angs (cdr angs))
	  (setq ange (assoc 51 el))
	  (setq ange (cdr ange))
	  (setq ang (- ange angs))
	  (if (< ang 0)
	    (setq ang (- (* 2 pi) (abs ang)))
	  )
	  (setq larc (* r ang))
	  (setq larc (* larc multi));;;add 2002.2.20 can remove
                                   ;;;add muti as multiple
	  ;;;(princ "Angle = ")
	  ;;;(prin1 (* (/ ang pi) 180))
	  ;;;(princ " , Radius = ")
	  ;;;(prin1 r)
	  ;;;(princ "\nLength of ARC is : ")
	  ;;;(prin1 larc)

	  
	)
	(princ "Object is not a ARC !")
      )
    )
  )
  (setq larc  (rtos larc 2 1) )
(command "dimangular"  obj  "t" larc pnt )
  (princ)
)

