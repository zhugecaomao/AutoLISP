DEFUN C:ALINE
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(COMMAND "SETVAR" "HIGHLIGHT" "1")
(setq a1 (entget (car (entsel"\nSelect line 1:"))))
(setq a2 (entget (car (entsel"\nSelect line 2:"))))
(SETQ ANGP (GETANGLE "\nTYPING A ANGLE:"))
(SETQ DISP (GETREAL "\nTYPING DISTANCE:"))
(SETQ ET1 (CDR (ASSOC 11 A1)))  ;right
(SETQ ET2 (CDR (ASSOC 10 A1)))  ;right
(SETQ ET3 (CDR (ASSOC 11 A2)))  ;right
(SETQ ET4 (CDR (ASSOC 10 A2)))  ;right
(SETQ INT (INTERS ET1 ET2 ET3 ET4 NIL))
(SETQ P2 (POLAR INT ANGP DISP))
(COMMAND "LINE" INT P2 "")
(COMMAND "SETVAR" "HIGHLIGHT" "1")
