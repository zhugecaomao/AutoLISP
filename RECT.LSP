;         ----------- rect.lsp ----------
; this lisp is let user easy to draw a rectangle by dinamic
; fuction.
;
;---start:
;
  (defun rect ()
    (graphscr)
     (setq oo (getpoint "\nPICK UP FIRST CORNER POINT:"))
     (setq rr (getcorner "\nPICK UP ANOTHER CORNER POINT:" oo))
      (setq oo1 (list (car oo) (cadr rr)))
      (setq rr1 (list (car rr) (cadr oo)))
    (command "line" oo rr1 rr oo1 "c")
  )
