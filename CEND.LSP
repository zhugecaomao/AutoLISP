(VMON)
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
;-----------------
;CIRCLE PLUS LINE
(DEFUN C:CEND (/ EE1 EE3 EE4 EE5)
 (MENUCMD "S=X")
 (SETQ EE1 (GETPOINT "\nCenter point:"))
 (IF EE1
  (PROGN
   (IF (= EE2 NIL) (SETQ EE2 0.00) (SETQ EE5 EE2))
   (PROMPT "Diameter:<") (PRINC (RTOS EE2)) (PROMPT ">")
   (SETQ EE2 (GETREAL))
   (IF (= EE2 NIL)
       (PROGN
        (SETQ EE2 EE5)
        (CEND1)
       )
       (CEND1)
   )
  )
 ) (PRINC)
)
(DEFUN CEND1 ()
       (SETQ EE3 (/ EE2 2))
       (SETVAR "CMDECHO" 0)
       (COMMAND "CIRCLE" EE1 "D" EE2)
       (SETQ EE4 (GETVAR "CLAYER"))
       (COMMAND "LAYER" "S" "CENTER" ""
                "LINE" (LIST (- (CAR EE1) EE3 2) (CADR EE1))
                       (LIST (+ (CAR EE1) EE3 2) (CADR EE1)) ""
                "LINE" (LIST (CAR EE1) (- (CADR EE1) EE3 2))
                       (LIST (CAR EE1) (+ (CADR EE1) EE3 2)) ""
                "LAYER" "S" EE4 "")
       (SETVAR "CMDECHO" 1)
)
