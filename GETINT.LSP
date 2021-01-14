DEFUN C:getp
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(COMMAND "SETVAR" "HIGHLIGHT" "1")
(setq a1 (entget (car (entsel"\nSelect line1:"))))
(setq a2 (entget (car (entsel"\nSelect line2:"))))
(SETQ ET1 (CDR (ASSOC 11 A1)))  ;right
(SETQ ET2 (CDR (ASSOC 10 A1)))  ;right
(SETQ ET3 (CDR (ASSOC 11 A2)))  ;right
(SETQ ET4 (CDR (ASSOC 10 A2)))  ;right
(SETQ INT1 (INTERS ET1 ET2 ET3 ET4 NIL))
(setq ang1 (angle ET1 ET2))
(setq ang2 (angle ET3 ET4))
(SETQ D1 (DISTANCE INT1 ET1))
(SETQ D2 (DISTANCE INT1 ET2))
(SETQ D3 (DISTANCE INT1 ET3))
(SETQ D4 (DISTANCE INT1 ET4))
(IF (> D1 D2)
    (PROGN
      (SETQ DT1 D2)
      (SETQ ANG3 (ANGLE INT1 ET2))
    )
    (PROGN
      (SETQ DT1 D1)
      (SETQ ANG3 (ANGLE INT1 ET1))
    )
)
(IF (> D3 D4)
    (PROGN
      (SETQ DT2 D4)
      (SETQ ANG4 (ANGLE INT1 ET4))
    )
    (PROGN
      (SETQ DT2 D3)
      (SETQ ANG4 (ANGLE INT1 ET3))
    )
)
(setq DT1 (* dT1 0.6))
(setq DT2 (* dT2 0.6))

(setq p2 (polar INT1 ANG3 DT1))
(setq p4 (polar INT1 ANG4 DT2))
(COMMAND "LAYER" "SET" "PHA" "")
(COMMAND "LINE" INT1 P2 "")
(COMMAND "LINE" INT1 P4 "")
(COMMAND "SETVAR" "HIGHLIGHT" "1")
