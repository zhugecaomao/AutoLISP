(VMON)
(DEFUN C:CHBT ()
  (SETVAR "CMDECHO" 0)
  (SETQ QJ (GETVAR "VIEWCTR"))                                  ;CETER OF PICTURE
  (SETQ QM (/ (GETVAR "VIEWSIZE") 2))                           ;HALF HIGH OF PICTURE
  (SETQ QQ (- (CADR (GETVAR "VSMAX")) (CADR (GETVAR "VSMIN")))) ;HIGH
  (SETQ QN (- (CAR (GETVAR "VSMAX")) (CAR (GETVAR "VSMIN"))))   ;WIDTH
  (SETQ QK (/ QQ QN))                                           ;SACLE H/W
  (SETQ Q1 (/ QM QK))                                           ;SCALE OF AREA
  (SETQ QG (LIST (- (CAR QJ) Q1) (- (CADR QJ) QM)))             ;LEFT RIGHT
  (SETQ Q0 (/ (GETVAR "VIEWSIZE") 6) )                          ; 1/6 OF PICTURE
  (SETQ QL (/ Q0 0.68 QK))                                         ;LENGTH OF WIDTH
  (SETQ QO (GETPOINT "\nSelect one:"))                          ;SELECT POINT
  (SETQ QH (- (CADR QO) (CADR QG)))
  (SETQ QC (- (CAR QO) (CAR QG)))
  (SETQ QEJ (FIX (/ QC QL)))
  (SETQ QJJ (FIX (/ QH Q0)))
  (SETQ QJJ (FIX (/ QH Q0)))
  (MENUCMD "S=X")
  (MENUCMD "S=CHBT")
  (REDRAW)
)
;-------------------------------------------------------------
(DEFUN C:PAGE1 ()
  (SETVAR "CMDECHO" 0)
  (COMMAND "VSLIDE" "CHB")
  (C:CHBT)
  (COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "CHB1")(LOAD "c:/acad/LSP/CHB1") (C:CHB1))
     ((AND(= QEJ 0)(= QJJ 4))(SETQ PP "CHB1")(LOAD "c:/acad/LSP/CHB1") (C:CHB1))
     ((AND(= QEJ 0)(= QJJ 3))(SETQ PP "CHB2")(LOAD "c:/acad/LSP/CHB2") (C:CHB2))
     ((AND(= QEJ 0)(= QJJ 2))(SETQ PP "CHB2")(LOAD "c:/acad/LSP/CHB2") (C:CHB2))
     ((AND(= QEJ 0)(= QJJ 1))(SETQ PP "CHB3")(LOAD "c:/acad/LSP/CHB3") (C:CHB3))
     ((AND(= QEJ 0)(= QJJ 0))(SETQ PP "CHB3")(LOAD "c:/acad/LSP/CHB3") (C:CHB3))

     ((AND(= QEJ 1)(= QJJ 5))(SETQ PP "CHB4")(LOAD "c:/acad/LSP/CHB4") (C:CHB4))
     ((AND(= QEJ 1)(= QJJ 4))(SETQ PP "CHB4")(LOAD "c:/acad/LSP/CHB4") (C:CHB4))
     ((AND(= QEJ 1)(= QJJ 3))(SETQ PP "CHB5")(LOAD "c:/acad/LSP/CHB5") (C:CHB5))
     ((AND(= QEJ 1)(= QJJ 2))(SETQ PP "CHB5")(LOAD "c:/acad/LSP/CHB5") (C:CHB5))
     ((AND(= QEJ 1)(= QJJ 1))(SETQ PP "CHB6")(LOAD "c:/acad/LSP/CHB6") (C:CHB6))
     ((AND(= QEJ 1)(= QJJ 0))(SETQ PP "CHB6")(LOAD "c:/acad/LSP/CHB6") (C:CHB6))

     ((AND(= QEJ 2)(= QJJ 5))(SETQ PP "CHB7")(LOAD "c:/acad/LSP/CHB7") (C:CHB7))
     ((AND(= QEJ 2)(= QJJ 4))(SETQ PP "CHB7")(LOAD "c:/acad/LSP/CHB7") (C:CHB7))
     ((AND(= QEJ 2)(= QJJ 3))(SETQ PP "CHB8")(LOAD "c:/acad/LSP/CHB8") (C:CHB8))
     ((AND(= QEJ 2)(= QJJ 2))(SETQ PP "CHB8")(LOAD "c:/acad/LSP/CHB8") (C:CHB8))
     ((AND(= QEJ 2)(= QJJ 1))(SETQ PP "CHB9")(LOAD "c:/acad/LSP/CHB9") (C:CHB9))
     ((AND(= QEJ 2)(= QJJ 0))(SETQ PP "CHB9")(LOAD "c:/acad/LSP/CHB9") (C:CHB9))

     ((AND(= QEJ 3)(= QJJ 5))(SETQ PP "CHB10")(LOAD "c:/acad/LSP/CHB10") (C:CHB10))
     ((AND(= QEJ 3)(= QJJ 4))(SETQ PP "CHB10")(LOAD "c:/acad/LSP/CHB10") (C:CHB10))
     ((AND(= QEJ 3)(= QJJ 3)))
     ((AND(= QEJ 3)(= QJJ 2)))
     ((AND(= QEJ 3)(= QJJ 1)))
     ((AND(= QEJ 3)(= QJJ 0)))
   )
(SETVAR "CMDECHO" 1)
)
