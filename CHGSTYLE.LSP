(defun c:chgstyle ()
(menucmd "s=sel")
(setq l (getstring "Input change after text style = "))
(setq a (ssget))
(setq b (sslength a))
(setq d 0)
(repeat b
(setq c (ssname a d))
(setq q (entget c))
(setq e (assoc 7 (entget c)))
(setq k (cdr (assoc 0 (entget c))))
(if (= k "TEXT")
(PROGN
(setq f (subst (cons 7 l) e q))
(entmod f))
)
(setq d (+ d 1))
)(princ))
