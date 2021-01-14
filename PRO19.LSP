;#******************* fillet *********************
;
(defun C:F (/ dir temp)
  (setvar "cmdecho" 0)
  (while (and (/= dir "x") (/= dir "X"))
    (setq dir (getstring "\nPline/Rad/eXit/<RETURN to fillet> : "))
    (cond ((or (equal dir "r") (equal dir "R"))
	   (prompt "\nFillet radius<")
	   (prin1 (getvar "filletrad"))
	   (prompt "> : ")
	   (setq temp (getreal))
	   (command "fillet" "r" temp ))
	  ((or (equal dir "P") (equal dir "p"))
	   (setq temp (car (entsel "\nSelect polyline : ")))
	   (command "fillet" "p" temp ))
	  ((= dir "")
	   (fillet))
    )
  )
)


(defun fillet (/ ans ed en n p1 p2 p3 p4 pint temp1 temp2)
  (while (/= (setq temp1 (entsel)) nil)
    (if (or (equal (cdr (assoc 0 (entget (car temp1)))) "LINE")
	    (equal (cdr (assoc 0 (entget (car temp1)))) "ARC")
	    (equal (cdr (assoc 0 (entget (car temp1)))) "CIRCLE"))
	(progn
	(setq en (cons temp1 en))
	(setq ed (cons (entget (car temp1)) ed))
	(redraw (car temp1) 3))
	(prompt "\n\007Illeagle item ! ")
    )
  )
  (setq n (length en))
;
  (while (>= n 2)
    (setq n (1- n))
    (setq temp1 (nth n en))
    (setq n (1- n))
    (setq temp2 (nth n en))
    (if (and
	(equal (cdr (assoc 0 (entget (car temp1)))) "LINE")
	(equal (cdr (assoc 0 (entget (car temp2)))) "LINE"))
	(progn
	(setq p1 (cdr (assoc 10 (entget (car temp1)))))
	(setq p2 (cdr (assoc 11 (entget (car temp1)))))
	(setq p3 (cdr (assoc 10 (entget (car temp2)))))
	(setq p4 (cdr (assoc 11 (entget (car temp2)))))
	(setq pint (inters p1 p2 p3 p4 nil))
	(entmod (endp temp1 pint))
	(entmod (endp temp2 pint))
	)
    )
    (setq temp1 (cadr temp1))
    (setq temp2 (cadr temp2))
    (command "fillet" temp1 temp2)
  )
  ;****** UNTRIM ******
  ;
  (setq ans (getstring "\nTrim ? (N/Y Default) : "))
  (if (or (equal ans "n") (equal ans "N"))
    (progn
      (setq n (length en))
      (while (> n 0)
	(setq n (1- n))
	(entmod (nth n ed))
      )
    )
  )
)



;------------------ endp -----------------------

(defun endp (en pint / ed x x1 x2 x3 y y1 y2 y3)
  (setq x (caadr en))
  (setq y (cadadr en))
  (setq ed (entget (car en)))
  (setq x1 (cadr (assoc 10 ed)))
  (setq y1 (caddr (assoc 10 ed)))
  (setq x2 (cadr (assoc 11 ed)))
  (setq y2 (caddr (assoc 11 ed)))
  (setq x3 (car pint) y3 (cadr pint))
;
;****** different x sign ******
;
  (if (minusp (* (- x1 x3) (- x2 x3)))
    (if (minusp (* (- x x3) (- x2 x3)))
      (subst (cons 11 (list x3 y3))
	     (assoc 11 ed) ed)
      (subst (cons 10 (list x3 y3))
	     (assoc 10 ed) ed)
    )
;
;****** same x sign ******
;

    (if (minusp (* (- y1 y3) (- y2 y3))) ;different y sign
      (if (minusp (* (- y y3) (- y2 y3)))
	(subst (cons 11 (list x3 y3))
	       (assoc 11 ed) ed)
	(subst (cons 10 (list x3 y3))
	       (assoc 10 ed) ed)
      )
      (if (> (distance (list x1 y1) (list x3 y3))
	     (distance (list x2 y2) (list x3 y3)))
	(subst (cons 11 (list x3 y3))
	       (assoc 11 ed) ed)
	(subst (cons 10 (list x3 y3))
	       (assoc 10 ed) ed)
      )
    )
  )
)

