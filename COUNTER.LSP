;COUNTER.LSP
; This lisp routine is accessed by a menu selection from
; the Counter.mnu on the sample drawing disk.  It inserts
; a block called "res" pausing for an insertion point and
; rotation angle.  If the block is inserted on a line or
; polyline it will break that entity.

; The routine sets OSNAP to "endpoint" so an error function
; has been defined to reset OSNAP to "none" if the user 
; cancels the routine with a ^C.

(defun my-error (st)
  (setvar "osmode" 0)
  (princ st) (terpri)
  (setq *error* orig-err)
  (princ)
)
(defun C:res (/ attdia? blk-ang lblock orig-err)
  (setq orig-err *error* *error* my-error)
  (setq attdia? (getvar "attdia"))
  (setvar "osmode" 512) (setvar "attdia" 1)
  (command "insert" "res" pause "1" "1" pause)
  (setq blk-ang (cdr (assoc 50 (entget (entlast)))))
  (entdel (setq lblock (entlast)))
  (setq lp (getvar "lastpoint"))
  (if (ssget lp)
   (progn
    (setq etype (cdr (assoc 0 (entget (ssname (ssget lp) 0)))))
    (if (or (equal etype "LINE") (equal etype "POLYLINE"))
        (command "break" lp (polar lp blk-ang 2))
    )
   )
  )
  (entdel lblock)
  (setvar "osmode" 0) (setvar "attdia" attdia?)
  (setq *error* orig-err) (princ)
)
