;執行此程式後,選擇物體剪斷的邊緣,再用Window選擇被剪斷的物體,則連續的
;剪斷

(defun c:mtrim (/ ce ss ls no pnt1 pnt2)
  (setvar "cmdecho" 0)
  (prompt "select cutting edge") (terpri)
  (setq ce (ssget )) (terpri)
  (prompt "select objects to trim: ")
  (terpri)
  (setq pnt1 (getpoint "first point"))
  (terpri)
  (setq pnt2 (getcorner pnt1 "2nd pnt"))
  (terpri)
  (setq ss (ssget "c" pnt1 pnt2)
        ls (sslength ss)
        no -1
  )
  (command "trim" ce "")
  (repeat ls
    (setq no (1+ no))
    (command (list (ssname ss no) pnt2))
  )
  (command "")
  (setvar "cmdecho" 1)
  (prin1)
)
