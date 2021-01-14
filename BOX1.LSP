DEFUN C:BOX1
(SETQ P (GETPOINT "\nInsert point:"))
(SETQ L (GETDIST P "\nLength:"))
(SETQ W (GETDIST P "\nWidth:"))
(SETQ DR1 (LIST (- (CAR P) (/ L 2)) (- (CADR P)(/ W 2))))
(SETQ DR2 (LIST (+ (CAR P) (/ L 2)) (- (CADR P)(/ W 2))))
(SETQ DR3 (LIST (- (CAR P) (/ L 2)) (+ (CADR P)(/ W 2))))
(SETQ DR4 (LIST (+ (CAR P) (/ L 2)) (+ (CADR P)(/ W 2))))
(COMMAND "LINE" DR1 DR3 DR4 DR2 "C" )
