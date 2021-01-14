(defun c:CHPL ()
   (setq a (ssget "x" '((0 . "POLYLINE"))))
   (setq n (sslength a))
  (setq num 0)
(repeat n
; (setq b1 (entget (ssname a num)))
  (setq b1 (ssname a num))
  (setq num (1+ num))
  (command "explode" b1)
)
)
