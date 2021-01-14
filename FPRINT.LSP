;  This is a programming example.
;  This function prints (lists) an ASCII text file on the screen.
;  Usage:   (fprint "filename.ext")
         
(defun fprint (s / c i)
   (setq i (open s "r"))               ; open the file for reading
   (if i
      (progn
         (while (setq c (read-line i)) ; read one line of text from the file
            (princ c)                  ; and print it on the screen
            (princ "\n")
         )
         (close i)                     ; close the file
      )
      (princ (strcat "Cannot open file " s))
   )
   (princ)
)
