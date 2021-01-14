;               Line - Angle LISP
;               -----------------
;  WRITE BY CHANG,YU CHANG      METAL TECH CO; LTD 1989-04-25
;
;
;
;--START
(defun la (/ lp ll lan)
   (setq lp (getpoint "\nSTART POINT: "))
    (setq ll (getreal "\nLENGTH: "))
     (setq lan (getangle lp "\nANGLE: "))
   (command "line" lp (polar lp lan ll) "")
)

