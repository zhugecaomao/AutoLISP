
(defun c:TName (/ tf e p thisdrawing mtext lea)
  (setq tf t)
  (while tf
    (if
      (and (setq e (entsel "\nÑ¡ÔñÊ÷Ä¾: "))
	   (or (= (cdr (assoc 0 (setq el (entget (car e))))) "INSERT")
	       (= (cdr (assoc 0 el)) "HATCH")
	   )
	   (setq p (getpoint (last e) "\n±ê×¢µã: "))
      )
       (progn
	 (if (not thisdrawing)
	   (setq thisdrawing
		  (vlax-get-property
		    (vlax-get-property
		      (vlax-get-acad-object)
		      'activedocument
		    )
		    'modelspace
		  )

	   )
	 )
	 (setq mtext (vla-addmtext
		       thisdrawing
		       (vlax-3d-point (trans p 1 0))
		       0.
		       (cdr (assoc 2 el))
		     )
	 )
	 (setq lea (vla-addleader
		     thisdrawing
		     (vlax-make-variant
		       (vlax-safearray-fill
			 (vlax-make-safearray vlax-vbdouble '(0 . 5))
			 (append (trans (last e) 1 0) (trans p 1 0))
		       )
		     )
		     mtext
		     aclinewitharrow
		   )
	 )
	 (vla-put-arrowheadblock lea "_DOT")
       )				;end progn
       (setq tf nil)
    )					;end if
  )					;end while
  (princ)
)