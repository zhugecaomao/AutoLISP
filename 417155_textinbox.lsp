;;;文字定点在直线方格内,by 841594
;;;v1.0 - 2005.9.12

(defun c:textinbox (/ en ptm)

;;;从一个点求到某个方向最近直线的距离
  (defun snearlin (pt ang / scsz ss n en pt1 pt2 ptj lst)
    (setq scsz (* (getvar "viewsize"))
	  ss   (ssget "f" (list pt (polar pt ang scsz)) '((0 . "LINE")))
    )
    (if	ss
      (progn
	(setq n 0)
	(while (setq en (ssname ss n))
	  (setq	ent (entget en)
		pt1 (trans (cdr (assoc 10 ent)) 0 1)
		pt2 (trans (cdr (assoc 11 ent)) 0 1)
		ptj (inters pt (polar pt ang 1.0) pt1 pt2 nil)
		lst (cons (list (distance pt ptj) en) lst)
		n   (1+ n)
	  )
	)				; while
	(apply 'min (mapcar 'car lst))
      )
    )
  )

;;;   求文字的中心点
  (defun txtmpt	(en / ent box ls pt ang)
    (setq ent (entget en)
	  box (textbox ent)
	  ang (cdr (assoc 50 ent))
	  ls  (mapcar '(lambda (a b) (* 0.5 (+ a b)))
		      (car box)
		      (cadr box)
	      )
	  pt  (cdr (assoc 10 ent))
    )
    (polar pt (+ ang (angle '(0 0) ls)) (distance '(0 0) ls))
  )					; defun

;;; main
  (command "undo" "begin")
  (setq	ss (ssget '((0 . "TEXT")))
	n  0
  )
  (while (setq en (ssname ss n))
    (setq ptm  (trans (txtmpt en) 0 1)
	  disn (snearlin ptm (* 0.5 pi))
	  diss (snearlin ptm (* 1.5 pi))
	  dise (snearlin ptm 0.0)
	  disw (snearlin ptm pi)
    )
    (if	(and disn diss)
      (setq yy (* 0.5 (- disn diss)))
      (setq yy 0)
    )
    (if	(and dise disw)
      (setq xx (* 0.5 (- dise disw)))
      (setq xx 0)
    )
    (or	(= 0 xx yy)
	(command "move" en "" "non" (list xx yy) "")
    )
    (setq n (1+ n))
  )
  (command "undo" "end")
  (princ)
)

