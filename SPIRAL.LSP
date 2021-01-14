;       This is a programming example.
;
;       Designed and implemented by Kelvin R. Throop in January 1985
;
;       This program constructs a spiral. It can be loaded and called 
;       by typing either "spiral" or the following:
;       (cspiral <# rotations> <base point> <growth per rotation>
;                <points per circle>).
;

(defun cspiral (ntimes bpoint cfac lppass / ang dist tp ainc dinc circle bs cs)
        (setq cs (getvar "cmdecho"))    ; save old cmdecho and blipmode
        (setq bs (getvar "blipmode"))
        (setvar "blipmode" 0)           ; turn blipmode off
        (setvar "cmdecho" 0)            ; turn cmdecho off
        (setq circle (* 3.141596235 2))
        (setq ainc (/ circle lppass))
        (setq dinc (/ cfac lppass))
        (setq ang 0.0)
        (setq dist 0.0)
        (command "pline" bpoint)        ; start spiral from base point and...
        (repeat ntimes
           (repeat lppass
              (setq tp (polar bpoint (setq ang (+ ang ainc))
                          (setq dist (+ dist dinc))))
              (command tp)              ; continue to the next point...
           )
        )
        (command)                       ; until done.
        (setvar "blipmode" bs)          ; restore saved blipmode
        (setvar "cmdecho" cs)           ; restore saved cmdecho
        nil
)
;
;       Interactive spiral generation
;
(defun C:SPIRAL ( / nt bp cf lp)
        (initget 1)                     ; bp must not be null
        (setq bp (getpoint "\nCenter point: "))
        (initget 7)                     ; nt must not be zero, neg, or null
        (setq nt (getint "\nNumber of rotations: "))
        (initget 3)                     ; cf must not be zero, or null
        (setq cf (getdist "\nGrowth per rotation: "))
        (initget 6)                     ; lp must not be zero or neg
        (setq lp (getint "\nPoints per rotation <30>: "))
        (cond ((null lp) (setq lp 30)))
        (cspiral nt bp cf lp)
)
