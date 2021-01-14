
; ************************************************************************
;                              RPOLY.LSP
;
;       Written by Kelvin R. Throop in October 1985
;
;       Based on the technique described in Philip J. Davis,
;       "Circulant Matrices", Wiley 1979.
;
;       Refinement of a random polygon by iterative replacement of
;       its vertices by the midpoints of its edges.  This miraculously
;       transforms most random polygons into an ellipse-shaped convex
;       polygon.
;
;       Added error checking and an error function - April 1988
;
; ************************************************************************
                                                                           
(defun drawpoly (p / dp dl)
        (setq dp p)
        (setq dl (length p))
        (command "pline")
        (repeat dl
           (command (car dp))
           (setq dp (cdr dp))
        )
        (command "c")
)

(defun myerror (s)                    ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
        (if (/= s "Function cancelled")
           (princ (strcat "\nError: " s))
        )
        (setvar "cmdecho" ocmd)       ; Restore saved modes
        (setvar "blipmode" oblp)
        (setq *error* olderr)         ; Restore old *error* handler
        (princ)
)

(defun C:RPOLY (/ olderr ocmd oblp cycno pl p pvert cyc plast pn pe pc)
        (setq olderr  *error*
              *error* myerror)
        (setq ocmd (getvar "cmdecho"))
        (setq oblp (getvar "blipmode"))
        (setvar "cmdecho" 0)
        (setq cycno 0)
        (setq pl nil)
        (while (setq p (getpoint "Next point: "))
           (setq pl (cons p pl))
        )
        (setvar "blipmode" 0)
        (setq pvert (length pl))

        (if pl 
           (progn
              (drawpoly pl)
              (initget 6)
              (while (setq cyc (getint "\nCycle count: "))
                 (repeat cyc
                    (setq plast (nth (1- pvert) pl))
                    (setq pn nil)
                    (setq pe pl)
                    (repeat pvert
                       (setq pc (car pe))
                       (setq pe (cdr pe))
                       (setq pn (cons (list (/ (+ (car pc) (car plast)) 2)
                                            (/ (+ (cadr pc) (cadr plast)) 2))
                                      pn)
                       )
                       (setq plast pc)
                    )
                    (setq pl pn)
                    (setq cycno (1+ cycno))
                    (princ "Cycle ")
                    (princ cycno)
                    (terpri)
                 )
                 (command "erase" "l" "")
                 (drawpoly pn)
                 (command "zoom" "e")
                 (initget 6)
              )
           )
        )
        (setvar "cmdecho" ocmd)
        (setvar "blipmode" oblp)
        (setq *error* olderr)         ; Restore old *error* handler
        (princ)
)
