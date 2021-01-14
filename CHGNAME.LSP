(defun chgname ()
  (setq inlist filelist)
  (while inlist
    (setq looklist (car inlist))
    (setq inlist (cdr inlist))
    (setq PT (car looklist))
    (setq description (car (cdr looklist)))
    (setq NO (car (cdr (cdr looklist))))
    (setq STOCK (car (cdr (reverse looklist))))
    (setq MATL (car (reverse looklist)))
    (cond
      ((assoc PT proplist)
       (setq chgattlist (assoc PT proplist))
