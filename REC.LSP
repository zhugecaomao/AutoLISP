(defun c:rec ()
   (setq clay  (getvar "CLAYER"))
   (setq a (ssget))
   (setq ddx (getreal "\nEXTENSION DIST: "))
   (setq n (sslength a))
  (setq num 0)
  (SETQ TEST 1)
(repeat n
  (setq b1 (entget (ssname a num)))
  (setq num (1+ num))
  (setq c1 (assoc 10 b1))
  (setq c2 (assoc 11 b1))
  (setq x1 (cadr c1))
  (setq x2 (cadr c2))
  (setq dx (abs (- x1 x2)))
  (if (/= dx 0) (setq d1 dx))
  (setq y1 (caddr c1))
  (setq y2 (caddr c2))
  (setq dy (abs (- y1 y2)))
  (if (/= dy 0) (setq d2 dy))
 (while (= test 1)
  (if (> x1 x2) (setq minx x2) (setq minx x1))
  (if (> y1 y2) (setq miny y2) (setq miny y1))
        (setq test 2)
 )
 (if (> minx x1) (setq minx x1))
 (if (> minx x2) (setq minx x2))
 (if (> miny y1) (setq miny x1))
 (if (> miny y2) (setq miny x2))
)
  (setq minp (list minx miny))
  (setq cp (polar (polar minp 0 (/ d1 2.0)) (/ pi 2.0) (/ d2 2.0)))
  (command "layer" "s" "center" "")
  (command "line" (polar cp 0 (+ (/ d1 2.0) ddx))
                  (polar cp pi (+ (/ d1 2.0) ddx))
                  ""
                  "LINE"
                  (polar cp (/ pi 2.0) (+ (/ d2 2.0) ddx))
                  (polar cp (/ (* pi 3.0) 2.0) (+ (/ d2 2.0) ddx))
                  ""
  )
       (command "LAYER" "S" clay "")
)
