(VMON)
(setq jona 1 LEO 0 METAL 6461
      chris 1
)
;
(setvar "CMDECHO" 0)
(defun dtr (a)
    (* pi (/ a 180.0))
)
;
(defun rel (p x y)
         (setq pp (list (+ (car p) x) (+ (cadr p) y)))
)
;
(defun RELATIVE ()
             (setq p (getpoint "\nRelative PT: "))
             (setq X (getREAL "\nRelative X-distance: "))
             (setq Y (getREAL "\nRelative Y-distance: "))
             (setq p (LIST (+ (CAR P) X) (+ (CADR P) Y)))
)
;
(TERPRI)
(princ "\n..... METAL TECH CO;LTD  TEL:(02)781-3670,740-3809 ....")
(PRINC)
