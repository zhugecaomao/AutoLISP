(defun c:sohole()
(setq F (getvar "blipmode")) (setvar "blipmode" 0)
(setq p (getpoint "Insert point:"))
(setq D (getint "\n Enter screw size [4] [6] [8] [10] [12] [16]:"))
(if (= D 4)
 (progn
 (setq D1 4.4)
 (setq D2 8.0)))
(if (= D 6)
 (progn
 (setq D1 6.5)
 (setq D2 11.0)))
(if (= D 8)
 (progn
 (setq D1 8.8)
 (setq D2 14.0)))
(if (= D 10)
 (progn
 (setq D1 11.0)
 (setq D2 17.5)))
(if (= D 12)
 (progn
 (setq D1 13.0)
 (setq D2 20.0)))
(if (= D 16)
 (progn
 (setq D1 18.0)
 (setq D2 26.0)))
(command "circle" p "D" D1)
(command "circle" p "D" D2)
(setvar "blipmode" F))
