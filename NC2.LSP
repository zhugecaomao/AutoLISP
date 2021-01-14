;-------------------------------START:
(defun c:NC ()
   (GRAPHSCR)
  (if (= jona 1) (progn
   (initget (+ 1 2 4))
   (if (= sn nil)
    (setq sn (getreal "\nSTART NUMBER: ")))
   (if (= en nil)
    (setq en (getreal "\nEND NUMBER: ")))
   (if (= bom nil) (progn
    (setq bom (getstring "\nOUTPUT MATERIAL TABLE FILE: "))
    (setq bom (open bom "a"))))
                  )
  )
   (while (<= sn en)
         (setq op (getpoint "\nPOINT TO OBJECT: "))
         (setq cp (getpoint "\nEND POINT: "))
           (setq ang (angle cp op))
              (setq np (polar cp ang 6))
                (setq txt (RTOS sn 2 0)) (setq sn (+ sn 1))
        (command "donut" "0" "2.5" op "" "line" op np ""
                 "insert" "nc" cp 1 1 0 txt)
        (write-line TXT bom)
        (write-line (getstring t "\nDESCRIPTION: ") bom)
        (write-line (getstring t "\nSIZE: ") bom)
        (write-line (getstring t "\nMAT'L: ") bom)
        (write-line (getstring t "\nH/T: ") bom)
        (write-line (getstring "\nQT'Y: ") bom)
   )
     (close bom)
)   ;  write by Jonathan,Chang   9/03/90 in METAL office.
