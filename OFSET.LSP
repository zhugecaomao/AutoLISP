;----------------------------------------------------------------------
;OFFSET WITH HALF DISTANCE
(DEFUN C:OFSET (/ SF2 SF3 SF4)
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
 (IF (= SF1 NIL) (SETQ SF1 0.00) (SETQ SF4 SF1))
 (PROMPT "\n<[Offset distance]X2><") (PRINC (RTOS (* 2 SF1))) (PROMPT ">:")
 (SETQ SF5 (GETREAL))
 (IF (/= SF5 NIL) (SETQ SF1 (/ SF5 2)) (SETQ SF1 NIL))
 (IF (= SF1 NIL)
     (PROGN
      (SETQ SF1 SF4)
      (OFSET1)
     )
     (PROGN
      (SETQ SF4 SF1)
      (OFSET1)
     )
 ) (SETQ SF1 SF4) (PRINC)
)
(DEFUN OFSET1 ()
 (WHILE SF1
  (SETQ SF2 (ENTSEL "\nSelect object to offset:"))
  (IF SF2
    (PROGN
     (SETQ SF3 (GETPOINT "\nSide to offset?"))
     (SETVAR "CMDECHO" 0)
     (COMMAND "OFFSET" SF1 SF2 SF3 "")
     (SETVAR "CMDECHO" 1)
    )
    (SETQ SF1 NIL)
  )
 )
)
