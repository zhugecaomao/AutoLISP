;                           REF.LSP

; This is a useful routine for obtaining a relative point.
; It can be used whenever an AutoCAD command requests a point.
; Just enter "(ref)" in response to the "...point:" prompt, and
; enter the desired base (reference) point and the relative/polar
; offset from that point. For example:

;    Command: LINE
;    From point: (ref)
;    Reference point: (...pick a point...)
;    Enter relative/polar coordinate (with @): @x,y or @dist<angle
;    To point:

(defun ref ()
   (setvar "LASTPOINT" (getpoint "Reference point: "))
   (getpoint "\nEnter relative/polar coordinates (with @): ") 
)
