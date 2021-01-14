;成批文字减前后缀程序
(DEFUN C:ch4 ()
 (setq qh (getint "\n1--减前缀,2--减后缀,<1>"))
 (if (= qh nil)(setq qh 1))
 (princ "\nselect object:")
 (setq s (ssget))
 (princ "一个汉字占两个字节，汉字按照两个字数计算")
 (setq nnn (getint "\n输入要减的字数<1>:"))
 (if (= nnn nil)(setq nnn 1))
 (setq n (sslength s))
 (setq k 0 )
 (while (< k n) 
      (setq name (ssname s k))
      (setq a (entget name))
      (setq t1 (assoc '0 a))
      (setq t1 (cdr t1))
      (if (= t1 "TEXT") (PROGN
        (setq h (assoc '1 a))
	(setq hh (cdr h))
        (setq len0 (strlen hh) len1 (- len0 nnn))
        (if (= qh 1)(setq  str1 (substr hh (+ 1 nnn) len1)))
	(if (/= qh 1)(setq str1 (substr hh 1 len1)))
	(setq h1 (cons 1 str1))
        ;(if (= str "") (setq h1 h))
        (setq a (subst h1 h a))
        (entmod a)
        ))
      (setq k (+ k 1))
 )
)



 