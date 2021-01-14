(defun C:DIMINCH (/)
   (setq os1 25.4)
   (setq ns1 1)
   (setq coum (/ ns1 os1))
   (setq aly "DIM")
   (setq dtxt1 T)
   (setvar "cmdecho" 0)
   (while (/= dtxt1 nil)
        (setq dtxt1 (entget (car (entsel "Select a text of dimension:"))))
        (print)
        (prompt "   ***Select a line to stop this program***")
        (print)
        (setq testt (cdr(assoc 0 dtxt1)))
            (if (/= testt "TEXT")
                (progn
                     (prompt "   ****See you next time !")
                     (setq dtxt1 nil)
                     (print)
                );progn end
                (progn
                    (setq dtxt2 (rtos(atof(cdr(assoc 1 dtxt1))) 2 8))
                    (setq dtxt8 (cdr(assoc 1 dtxt1)))
                    (setq dtxt3 (cdr(assoc 10 dtxt1)))
                    (setq dtxt4 (cdr(assoc 50 dtxt1)))
                    (setq dtxt7 (cdr(assoc 11 dtxt1)))
                    (setq dtxt5 (cdr(assoc -1 dtxt1)))
                    (entdel dtxt5)
                    (setq jod (cdr(assoc 72 dtxt1)))
                    (setq a (atof dtxt2))
                    (setq dtxt6 (* a coum))
                    (setq b (rtos dtxt6 2 3))
                    (setq c (strcat "[" b))
                    (setq d (strcat c "]"))
                    (setq e (strcat dtxt8 d))
                    (setq ang (* dtxt4 (/ 180 pi)))
                        (cond
                             (
                                (= jod 0)
                                (command "text" dtxt3 "" ang e)
                                (command "change" "last" "" "la" aly)
                             )
                             (
                                (= jod 0)
                                (command "text" dtxt3 "" ang e)
                                (command "change" "last" "" "la" aly)
                             )
                             (
                                (= jod 2)
                                (command "text" "r" dtxt7 "" ang e)
                                (command "change" "last" "" "la" aly)
                             )
                             (
                                (= jod 2)
                                (command "text" "r" dtxt7 "" ang e)
                                (command "change" "last" "" "la" aly)
                             )
                         );end cond
                );progn end
            );if end
   )
       (setvar "cmdecho" 1)
)
