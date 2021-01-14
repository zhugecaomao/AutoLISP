; **********************************************************************
;                             CHGTEXT.LSP

;  This program will replace every occurrence of an "old string" with a     
;  "new string".  You will be prompted to select the text you wish
;  to change.  Then you will be asked to enter the "old string" and 
;  the "new string".  After the text has been changed, the total number 
;  of changed lines is displayed.
; **********************************************************************

(defun chgterr (s)
   (if (/= s "Function cancelled")   ; If an error (such as CTRL-C) occurs
      (princ (strcat "\nError: " s)) ; while this command is active...
   )
   (setq p nil)                      ; Free selection set
   (setq *error* olderr)             ; Restore old *error* handler
   (princ)
)

(defun C:CHGTEXT (/ p l n e os as ns st s nsl osl sl si chf chm olderr)
   (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)
   (setq p (ssget))                  ; Select objects
   (if p (progn                      ; If any objects selected
      (while (= 0 (setq osl (strlen (setq os (getstring t "\nOld string: ")))))
            (princ "Null input invalid")
      )
      (setq nsl (strlen (setq ns (getstring t "\nNew string: "))))
      (setq l 0 n (sslength p))
      (while (< l n)                 ; For each selected object...
         (if (= "TEXT"               ; Look for TEXT entity type (group 0)
                (cdr (assoc 0 (setq e (entget (ssname p l))))))
            (progn
               (setq chf nil si 1)
               (setq s (cdr (setq as (assoc 1 e))))
               (while (= osl (setq sl (strlen
                             (setq st (substr s si osl)))))
                  (if (= st os)
                      (progn
                        (setq s (strcat (substr s 1 (1- si)) ns
                                        (substr s (+ si osl))))
                        (setq chf t) ; Found old string
                        (setq si (+ si nsl))
                      )
                      (setq si (1+ si))
                  )
               )
               (if chf (progn        ; Substitute new string for old
                  (setq e (subst (cons 1 s) as e))
                  (entmod e)         ; Modify the TEXT entity
                  (setq chm (1+ chm))
               ))
            )
         )
         (setq l (1+ l))
      )
   ))
   (princ "Changed ")                ; Print total lines changed
   (princ chm)
   (princ " text lines.")
   (terpri)
   (setq *error* olderr)             ; Restore old *error* handler
   (princ)
)
