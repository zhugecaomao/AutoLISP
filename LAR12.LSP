;-----------------------------------------------------------------------
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
  (DEFUN LRDIM ()
        (SETQ SC (GETVAR "DIMLFAC"))
        (SETQ CA (GETVAR "LUPREC"))
        (SETVAR "ORTHOMODE" 0)
        (SETQ G1 (ENTSEL "\nSelect arc or circle:"))
        (SETVAR "OSMODE" 0)
        (MENUCMD "S=NUMBER")
        (SETQ G2 (GETSTRING "\nSelect number or RETURN for none:"))
        (SETQ G3 (CDR (ASSOC 40 (ENTGET (CAR G1)))))
;       (IF (= (- (FIX G3) G3) 0.0)
;           (PROGN
;             (SETQ G3 (FIX G3))
;             (SETQ CA 0)
;           )
;       )
        (SETQ G3 (RTOS (* G3 SC) 2 CA))
        (SETQ G3 (STRCAT "R" G3))
        (SETVAR "CMDECHO" 1)
  )
;--------------------------------------------------------------------------
  (DEFUN CS1A ()
    (COMMAND "DIM" "LEADER" "NEAR" (CADR G1) PAUSE "" (STRCAT G2 "-" G3) EXIT)
  )
;
  (DEFUN CS1B ()
    (COMMAND "DIM" "LEADER" "NEAR" (CADR G1) PAUSE "" G3 EXIT)
  )
;
  (DEFUN CS2A ()
    (COMMAND "DIM" "LEADER" "NEAR" (CADR G1) PAUSE PAUSE PAUSE "" (STRCAT G2 "-" G3) EXIT)
  )
;
  (DEFUN CS2B ()
    (COMMAND "DIM" "LEADER" "NEAR" (CADR G1) PAUSE PAUSE PAUSE "" G3 EXIT)
  )
;-------------------------------------------------------------------------
    ;DIMENSION SMALL & INTERMEDIATE RADIUS
(DEFUN C:LAR1 ()
     (LRDIM)
     (IF (/= G2 "") (CS1A) (CS1B))
)
;-----------------------------------------------------------------------
    ;DIMENSION LARGE RADIUS
(DEFUN C:LAR2   ()
    (LRDIM)
     (IF (/= G2 "") (CS2A) (CS2B))
)
