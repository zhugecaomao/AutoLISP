(defun C:bush-b()
(setq p (getpoint "\nPlease insert the point:"))
(setq D (getreal "\nPlease select the diameter size '16' '20' '25' '30' '35' '40' '50' '60':"))
(setq L (getreal "\nPlease enter the bush 'B' length:"))
(setq A (getreal "\nPLease enter the bush 'B' angle:"))
(setq B (* pi (/ a 180)))
(cond
    ((= d 16)(setq d1 25))
    ((= d 20)(setq d1 30))
    ((= d 25)(setq d1 35))
    ((= d 30)(setq d1 42))
    ((= d 35)(setq d1 48))
    ((= d 40)(setq d1 55))
    ((= d 50)(setq d1 70))
)
(setq p1 (polar p B L))
(setq p2 (polar p (- B (/ pi 2))(+ (/ D 2) 1)))
(setq p6 (polar p (- B (/ pi 2))(- (/ D1 2) 1)))
(setq p4 (polar p1 (- B (/ pi 2))(+ (/ D 2) 1)))
(setq p8 (polar p1 (- B (/ pi 2))(- (/ D1 2) 1)))
(setq p3 (polar p2 (+ B (/ pi 4)) (sqrt 2)))
(setq p7 (polar p6 (- B (/ pi 4)) (sqrt 2)))
(setq p5 (polar p4 (+ B (* pi 0.75)) (sqrt 2)))
(setq p9 (polar p8 (- B (* pi 0.75)) (sqrt 2)))
(command "line" p2 p3 p5 p4 "")
(command "line" p8 p9 p7 p6 "")
(setq p10 (polar p (+ B (/ pi 2))(+ (/ D 2) 1)))
(setq p14 (polar p (+ B (/ pi 2))(- (/ D1 2) 1)))
(setq p13 (polar p1 (+ B (/ pi 2))(+ (/ D 2) 1)))
(setq p17 (polar p1 (+ B (/ pi 2))(- (/ D1 2) 1)))
(setq p11 (polar p10 (- B (/ pi 4))(sqrt 2)))
(setq p15 (polar p14 (+ B (/ pi 4))(sqrt 2)))
(setq p16 (polar p17 (+ B (* pi 0.75))(sqrt 2)))
(setq p12 (polar p13 (- B (* pi 0.75))(sqrt 2)))
(command "line" p10 p11 p12 p13 "")
(command "line" p17 p16 p15 p14 "")
(command "line" p12 p5 "")
)








