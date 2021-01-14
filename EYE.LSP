(defun c:eye(/ obl ocm olderr olt oco dia pt lst n dia_ dia1 )
  (setq obl (getvar "blipmode")  oco (getvar "cecolor")
	ocm (getvar "cmdecho")  olt (getvar "celtype")
	olderr *error* 
       *ERROR* AI_ABORT)
  (setvar "cmdecho" 0)
  (command "_.UNDO" "_GROUP")
  (setvar "blipmode" 0)
  (initget 1)
  (setq dia (getreal "\n请输入杯头螺丝大小: "))
  (setq lst (list 0.25 5.1 0.312 6.5 0.375 7.9 0.5 10.5 0.625 13.5 0.75 16.5 0.875 19.25
                  1.0 22 1.25 27.75 1.5 33.5 1.75 39 2.0 44.5 2.25 50 2.5 56.5
                  3 2.5 4 3.3 5 4.2 6 5.0 8 6.8 10 8.5 12 10.2 14 12 16 14 18 15.5 20 17.5
                  22 19.5 24 21 27 24 30 26.5 36 32 42 37.5 48 43 56 50.5 64 58.0001))
  (setq n 0   dia_ 0)
  (while (and (/= dia_ dia) (< dia_ 64))
    (setq n (+ n 2))
    (setq dia_ (nth n lst))
  )
  (setq dia1 (nth (+ n 1) lst))
  (if (< dia 2.5) (setq dia (* dia 25.4)))
  (if (> dia1 dia)
    (prompt "\n没有这种规格的螺丝，请确实.")
    (progn
      (setq pt (getpoint "\n杯头螺丝中心位置: "))
      (while (/= pt nil)
        (command "color" oco "celtype" olt
                 "circle" pt "d" dia1
                 "arc" "c" pt (polar pt 0 (/ dia 2)) (polar pt (/ pi -2) (/ dia 2))
                 "color" 1  "celtype" "center"
                 "line" (polar pt pi (* dia 0.65)) (polar pt 0 (* dia 0.65)) ""
                 "line" (polar pt (/ pi 2) (* dia 0.65)) (polar pt (/ pi -2) (* dia 0.65)) ""
		 "color" oco "celtype" olt)
        (setq pt (getpoint "\n下一个杯头螺丝中心位置: "))
      )
    )
  )
  (command "_.UNDO" "_E")
  (setvar "blipmode" obl) (setvar "cecolor" oco) (setvar "celtype" olt)
  (setvar "cmdecho" ocm)
  (setq *error* olderr) 
  (princ)
 )