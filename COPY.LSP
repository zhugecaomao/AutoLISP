;  This is a programming example.

;  This program takes two ASCII files as arguments, and copies the first
;  file into the second.  If the first file does not exist, an error message
;  is displayed; however, if the second file does not exist, it is created.
;  Note that if the second file exists, its data will be overwritten.
;  Usage: (copy "infile.ext" "outfile.ext")

(defun copy (in out / ifp ofp l)
   (cond ((null (setq ifp (open in "r")))       ; try to open in for reading
                (princ "Can't open ")           ; if nil print error message
                (princ in)
                (princ " for reading."))
        (if ifp (progn
                (setq ofp (open out "w"))       ; else open out for writing
                (while (setq l (read-line ifp)) ; read each line from in
                   (write-line l ofp)           ; and write it to out
                )
                (close ofp)                     ; close both files
                (close ifp))
        )
   )
   (princ)
)
