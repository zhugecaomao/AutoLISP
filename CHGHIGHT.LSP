(defun c:chghight ()
(menucmd "s=sel")
(setq l (getdist "Input change after text hight = "))
(setq a (ssget))
(setq b (sslength a))
(setq d 0)
(repeat b
(setq c (ssname a d))
(setq q (entget c))
(setq e (assoc 40 (entget c)))
(setq k (cdr (assoc 0 (entget c))))
(if (= k "TEXT")
(PROGN
(setq f (subst (cons 40 l) e q))
(entmod f))
)
(setq d (+ d 1))
)(princ))
