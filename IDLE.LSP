
;       The IDLE command

(defun *ERROR* (s)
        (redraw)
        (grtext)
)

(defun c:idle ()
        (expand 100)
        (setq vc (getvar "viewctr"))
        (setq cx (car vc))
        (setq cy (cadr vc))
        (setq vs (/ (getvar "viewsize") 2))
        (setq xmin (- cx vs))
        (setq xmax (+ cx vs))
        (setq ymin (- cy vs))
        (setq ymax (+ cy vs))
        (setq xdir (/ vs 10) ydir xdir)
        (setq cx (+ cx (* xdir 7)))
        (setq cy (- cy (* ydir 3)))
        (grclear)
        (grtext -1 "          That's entertainment!")
        (grtext -2 "Press CANCEL to stop.")
        (setq lp (list cx cy))

        (while t
           (setq nx (+ cx xdir))
           (if (or (> nx xmax) (< nx xmin))
              (progn
                 (setq xdir (- xdir))
                 (setq nx cx)
              )
           )
           (setq ny (+ cy ydir))
           (if (or (> ny ymax) (< ny ymin))
              (progn
                 (setq ydir (- ydir))
                 (setq ny cy)
              )
           )
           (setq cx nx cy ny)
           (grdraw lp (setq lp (list nx ny)) -1)
        )
)
