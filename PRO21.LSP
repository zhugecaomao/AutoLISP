;執行此程式後,選擇螢幕上的物體,即可把該物體所屬的層次冷凍。
;但是不能冷凍目前螢幕所在的層次

(defun c:frlay (/ freeze lnames ss ent lname)
    (setq freeze "" lnames '())
    (princ "\nPick entities on layers to be
    froren...\n")
    (setq ss (ssget))
    (while  (and ss (setq ent (ssname ss 0)))
      (cond
        ((member (setq lname (cdr (assoc 8 (entget ent))))
	  lnames))
        (t (setq freeze (strcat freeze lname ",")
                 lnames (cons lname lnames)
	   )
	)
      )
      (setq ss (ssdel ent ss))
    )
    (setq freeze (if (> (strlen freeze) 1)
                   (substr freeze 1 (1- (strlen freeze)))
                   freeze
		 )
    )
    (if (/= freeze "") (command ".layer" "f" freeze ""))
    (princ)
  )
