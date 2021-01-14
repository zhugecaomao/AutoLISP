; ******************************************************************
;                          CL.LSP

;    By MING TSAIR-LEE

;  This macro constructs a pair of center lines through the
;  center of a circle. The lines are put on a layer "CENTER".

; ******************************************************************
(defun C:CENL (/ clay e cen rad d ts xx)
   (COMMAND "OSNAP" "NONE")
   (setq clay  (getvar "CLAYER"))
  (setq e nil xx "Yes")
  (setq ts (tblsearch "LAYER" "CENter"))
   (if (= xx "Yes")
      (progn
       (while (null e)
          (setq e (entsel "\nSelect arc or circle: "))
          (if e
              (progn
               (setq e (car e))
               (if (and
                     (/= (cdr (assoc 0 (entget e))) "ARC")
                    (/= (cdr (assoc 0 (entget e))) "CIRCLE")
                   )
                   (progn (prompt "\nEntity is a ")
                          (princ (cdr (assoc 0 (entget e))))
                          (setq e nil)
                   )
               )
             )
          )
       )
      (setq cen (trans (cdr (assoc 10 (entget e))) e 1))
      (setq rad (cdr (assoc 40 (entget e))))
      (prompt "\nRadius is ")
      (princ (rtos rad))
      (initget 7 "Length")
      (setq d (getdist "\nLength/<Extension>: "))
       (if (= d "Length")
        (progn
         (initget 7)
         (setq d (getdist cen "\nLength: "))
        )
        (setq d (+ rad d))
       )
       (command "LAYER" "S" "CENter" "")
       (command "LINE" (list (car cen) (- (cadr cen) d) (caddr cen))
                       (list (car cen) (+ (cadr cen) d) (caddr cen))
                       ""
       )
       (command "LINE" (list (- (car cen) d) (cadr cen) (caddr cen))
                       (list (+ (car cen) d) (cadr cen) (caddr cen))
                       ""
       )
       (command "LAYER" "S" clay "")
      )
   )
   (princ)
)
