;-------------------------------START:
(defun c:NC ()
   (GRAPHSCR) (SETVAR "CMDECHO" 0)
   (COMMAND "LAYER" "S" "DIM" "")
  (if (= jona 1) (progn
   (initget (+ 1 2 4))
   (if (= sn nil)
    (setq sn (getreal "\nSTART NUMBER: ")))
   (if (= en nil)
    (setq en (getreal "\nEND NUMBER: ")))
		  )
  )
   (while (<= sn en)
	 (setq op (getpoint "\nPOINT TO OBJECT: "))
	 (setq cp (getpoint "\nEND POINT: "))
	   (setq ang (angle cp op))
	      (setq np (polar cp ang 6))
		(setq txt (RTOS sn 2 0)) (setq sn (+ sn 1))
	(command "donut" "0" "1" op "" "line" op np ""
		 "insert" "nc" cp 1 1 0 txt)
   )
)   ;  write by Jonathan,Chang	 9/03/90 in METAL office.
