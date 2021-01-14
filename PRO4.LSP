(defun c:cblock ()
  (setq cont "T")
  (while (= cont "T")
    (setq newblock (getstring "\nEnter name of new block: "))
    (setq slength (strlen newblock))
    (if (= slength 0)
      (princ "\nNull input invalid...")
      (setq cont nil)
    ) ;endif
  ) ;endwhile
  (setq endtest 32)
  (while (= endtest 32)
    (setq ename nil)
    (while (not ename)
      (setq ename (entsel))
      (if (not ename)
        (princ "\nNull input invalid...")
      ) ;endif
    ) ;endwhile
    (setq edata (entget (car ename)))
    (setq edata (subst (cons 2 newblock) (assoc 2 edata) edata))
    (entmod edata)
    (prompt "\nHit the <SPACE> bar to continue... or any other key to stop.")
    (setq endtest (cadr (grread)))   ;if  endtest=32
  ) ;endwhile
  (princ)
) ;endcblock
