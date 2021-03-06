(defun c:land(/ pp n s n ss x)
         (setq pp (ssget))
         (setq n (sslength pp))
         (setq s 0 x 0)
         (setq ss (ssadd))
         (repeat n
                 (setq name (ssname pp x))
                 (setq ss (ssadd name ss))
                 (command "area" "e" ss)
                 (setq s (+ s (getvar "area")))
                 (setq ss (ssdel name ss))
                 (setq x (1+ x))
          )
         (prompt "the area = ")
         (/ s 10000)
 
 )
(defun c:road()
         (setq pp (ssget))
         (setq n (sslength pp))
         (setq s 0 x 0 length 0)
         (setq ss (ssadd))
         (repeat n
                 (setq name (ssname pp x))
                 (setq ss (ssadd name ss))
                 (command "area" "e" ss)
                 (setq l (getvar "perimeter"))
                 (setq w (cdr (assoc 40 (entget name))) )
                 (setq ss (ssdel name ss))
                 (setq x (1+ x))
                 (setq s (+ s (* l w)))
                 (setq length (+ length l))
                )
         (prompt "the area = ")
         (setq s (/ s 1))
         (prin1 s)
         (prompt "the total length =")
         (/ length 1000)

 )
