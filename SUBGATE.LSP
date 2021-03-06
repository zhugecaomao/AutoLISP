(defun c:subgate()
(setq F (getvar "blipmode")) (setvar "blipmode" 0)
(setq p (getpoint "\n Insert point:"))
(setq L (getreal "\n Enter distance from ptline to gate center:"))
(setq U (/ pi 180))
(setq X (getreal "\n Enter draft angle:"))
(setq Ad (* X U))
(setq Y (getreal "\n Enter cone angle:"))
(setq Ac (* Y U))
(setq Z (getreal "\n Enter angle of gate center (makes w/vert):"))
(setq A (* Z U))
(setq d (getreal "\n Enter dia. of initial drill hole:"))
(setq dm (/ d (sin (- A Ad))))
(setq p1 (polar p (- (/ pi -2) Ad) (/ L (cos Ad))))
(setq p2 (polar p1 (- (/ pi 2) Ad) (/ (* 0.5 dm) (cos Ad))))
(setq p3 (polar p1 (- (/ pi 2) Ad) (/ (* -0.5 dm) (cos Ad))))
(setq p4 (polar p1 (- (/ pi 2) A) (/ L (cos A))))
(setq p5 (polar p2 (+ (- (/ pi 2) A) (/ Ac 2.0)) (/ (- L (/ dm 2.0)) (cos (- A (/ Ac 2.0))))))
(setq p6 (polar p3 (- (- (/ pi 2) A) (/ Ac 2.0)) (/ (+ L (/ dm 2.0)) (cos (+ A (/ Ac 2.0))))))
(if (>= (car p5) (+ (car p) 1.2))
 (progn
  (setq Mx (* 2 (- (car p4) (+ (car p) 1.2))))
  (setq Mn (* 2 (- (car p4) (car p5))))
  (textscr)
  (prompt "\n Max dia of runner:") (princ Mx)
  (prompt "\n Min dia of runner:") (princ Mn)
  (setq D (getreal "\n Enter runner diameter:"))
  (setq Dp (getreal "\n Enter runner deepth [0] [1/2 runner dia]:"))
  (graphscr)
  (setq p7 (polar p4 pi Dp))
  (setq p8 (polar p4 (/ pi -2) Dp))
  (command "line" p2 p5 "")
  (command "line" p3 p6 "")
  (command "line" p1 p4 "")
  (if (/= Dp 0)
   (progn
    (command "arc" p7 "C" p4 p8)
    (command "line" "" 20 "")
  ))
(setq p9 (getpoint "\n Enter insert point on plan view:"))
(setq p10 (polar p9 0 (distance p p4)))
(setq p11 (polar p10 (/ pi 2) (* D 0.5)))
(setq p12 (polar p10 (/ pi -2) (* D 0.5)))
(setq p13 (polar p11 0 20))
(if (= Dp 0))
(command "line" p13 p11 "")
(command "arc" "" p12)
(command "line" "" 20 "")
))
(setvar "blipmode" F))
