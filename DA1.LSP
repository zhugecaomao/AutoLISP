;*******TRY DRAW A LINE BY A POINT ON  LINE*****
(DEFUN C:DA1 ()
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
      (GRAPHSCR)
      (INITGET  1 )
  (SETQ A (getpoint "\nSelect a point of line:"))
      (INITGET  1 )
  (SETQ ANG (GETANGLE "\nInput ortho line ANG:"))
      (INITGET ( + 1 2 4 ))
  (SETQ D (GETREAL "\nInput ortho line long:"))
  (SETQ D2 (* (/ D 2) -1))
  (SETQ S (POLAR A ANG (/ D 2)))
  (SETQ D1 (POLAR A ANG D2))
  (COMMAND "LINE" S  D1 "")
)


