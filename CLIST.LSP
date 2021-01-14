(defun c:clist (/ cen cn dia fnp lpt lp1 m n obl ocm oco oln olderr ozi p1 p2 rpt rp1 s
		 sn ss t1 t2 t3 tex th )
  (setq oln (getvar "clayer")
	oco (getvar "cecolor")
	obl (getvar "blipmode")
	ocm (getvar "cmdecho")
	ozi (getvar "dimzin")
	olderr *error* 
       *ERROR* AI_ABORT)
   (setvar "cmdecho" 0)
   (command "_.UNDO" "_GROUP")
   (setvar "blipmode" 0) (setvar "dimzin" 0)
  (setvar "textstyle" "standard")
 
  (setq ss 	(ssget)
	cn	(getstring "\n 输入代码,可任意输（必须先关闭捕捉点及Caps lock键!）: ")
	lp1	(getpoint "\n列表框的第一行位置,任意点一处 ")
	th	(* (getvar "dimscale") 0.18)
	rp1	(polar lp1 0 (* 12 th))
	fnp	(list (+ (car lp1) (* th 0.2)) (+ (cadr lp1) (* th 0.2))))
;	fil	(open (strcat "c:/" fn ".txt") "w"))
;  (princ "%\n" fil)
  (command "color" 130 "line" lp1 rp1 "")
  (setq tex "")
  (while (/= tex "e")
     (setq tex (getstring "\n输入对象特征<以E结束列表>: "))
     (if (/= tex "e")
	
(progn
     		(command "cecolor" 130
			 "line" lp1 (polar lp1 4.7123889 th) "" 
			 "line" rp1 (polar rp1 4.7123889 th) ""
			 "cecolor" 2
			 "text" (polar fnp 4.7123889 th) (* 0.6 th) 0 tex)
     		(setq 	lp1 	(polar lp1 4.7123889 th)
	   		rp1 	(polar rp1 4.7123889 th)
	   		fnp 	(polar fnp 4.7123889 th))
  )  )  )
	
  (setq p1 (polar lp1 0 (* 3 th))
	p2 (polar p1 0 (* 4.5 th))
	t1 (list (+ (car lp1) (* 1.5 th)) (- (cadr lp1) (* 0.8 th)))
	t2 (polar t1 0 (* 3.75 th))
	t3 (polar t1 0 (* 8.25 th)))
  (command	"cecolor" 130
		"line" lp1 rp1 (polar rp1 4.7123889 th) (polar lp1 4.7123889 th) lp1 ""
	   	"line" p1 (polar p1 4.7123889 th) ""
		"line" p2 (polar p2 4.7123889 th) ""
		"cecolor" 3
		"text" "j" "bc" t1 (* 0.6 th) 0 "code"
		"text" "j" "bc" t2 "" "" "X"
		"text" "j" "bc" t3 "" "" "Y")
  (setq lp1 (polar lp1 4.7123889 th)
	rp1 (polar rp1 4.7123889 th)
	p1 (polar p1 4.7123889 th)
	p2 (polar p2 4.7123889 th))

  (setq slen 	(sslength ss)
	n 0
	m 0)
  (while (/= n slen)
     (setq s 	(entget (ssname ss n))
	   sn	(cdr (assoc 0 s)))
     (if (= sn "CIRCLE")
        (progn
	  (setq t1 	(polar t1 4.7123889 th)
		dia	(* (cdr (assoc 40 s)) 2)
		cen	(cdr (assoc 10 s)))
	  (command "cecolor" 140
		"text" (polar cen 0.78 (* dia 0.5)) "" "" (strcat cn (rtos (1+ m) 2 0))
		"cecolor" 130
		"line" lp1 (polar lp1 4.7123889 th) (polar rp1 4.7123889 th) rp1 ""
		"line" p1 (polar p1 4.7123889 th) ""
		"line" p2 (polar p2 4.7123889 th) ""
		"cecolor" 21
		"text" "j" "bc" t1 "" "" (strcat cn (rtos (1+ m) 2 0))
		"cecolor" 2
		"text" "j" "br" (polar t1 0 (* 5.8 th)) "" "" (rtos (car cen) 2 2)
		"text" "j" "br" (polar t1 0 (* 10.3 th)) "" "" (rtos (cadr cen) 2 2))
	  (setq lp1 (polar lp1 4.7123889 th)
		rp1 (polar rp1 4.7123889 th)
		p1  (polar p1 4.7123889 th)
		p2  (polar p2 4.7123889 th)
		m   (1+ m))
;	  (princ (strcat "X" (rtos (car cen) 2 3) "Y" (rtos (cadr cen) 2 3) "\n") fil)
     )  )
     (setq n (1+ n))
  )
 
;  (princ "M99\n" fil)
;  (princ "%" fil)
;  (close fil)
	
  (setvar "cecolor" oco)      
  (setvar "clayer" oln)  
  (setvar "blipmode" obl)
  (setvar "cmdecho" ocm)
  (setvar "dimzin" ozi)
  (setq *error* olderr) (command "_.UNDO" "_E")
  (princ)
)

	
