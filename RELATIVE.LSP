; ************************************************************************
;                           RELATIVE.LSP

; By Simon Jones  Autodesk Ltd, London     23 July 1986

; This macro provides a point that is relative by a
; given angle and distance to a known point such as
; the "End pt" of a line or "Centre of" a circle.

; When AutoCAD requires a point for a command
; respond with:
;         (relative)   (from keyboard)

; Or alternatively enter the following line as a menu
; command in the "**OSNAPB 3" sub-menu in the screen menu
; with the remaining object snap commands:

;         [RELATIVE](relative) $s=

;         then:
;            1) Enter or select a point.
;                 (using object snap if required)
;            2) Enter or show a distance relative to
;                 the selected point.
;            3) Enter or show an angle relative to
;                 the selected point

; Added error checking and an error function - April 1988.
; ************************************************************************


(defun myerror (s)                    ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
   (if (/= s "Function cancelled")
      (princ (strcat "\nError: " s))
   )                                  ; print error message and exit cleanly
   (setq *error* olderr)              ; Restore old *error* handler
   (princ)
)

(defun RELATIVE (/ olderr pts dist ang pt)
   (setq olderr  *error*
         *error* myerror)
   (initget 17)                       ; pts must be a 3d non null point
   (setq pts (getpoint "\nRelative to: "))
   (initget 7)                        ; dist must not be zero, neg or null
   (setq dist (getdist pts "\nRelative distance: "))
   (initget 1)                        ; ang must not be null
   (setq ang (getangle pts "\nRelative angle: "))
   (setq *error* olderr)              ; restore old *error* handler
   (setq pt (polar pts ang dist))
)
