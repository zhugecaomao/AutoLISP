; *******************************************************************
;                            ASCTEXT.LSP

;       By Simon Jones  Autodesk Ltd, London  4 July 1986

;   Use ASCTEXT.LSP to insert ASCII text files into AutoCAD drawings.
;   The blocks of text can be either Left, Center, Middle or Right
;   Justified.

;   The file name must include an extension and may include a
;   directory prefix, as in /acad/sample.txt or \\acad\\sample.txt.

;   Apart from height (unless fixed) & rotational angle,
;   "Text options" include:
;       Define distance between lines.
;       Define opening line for reading.
;       Define number of lines to read.
;       Global under/overscoring of lines.
;       Global upper/lower case change.
;    &  Column definitions.

;   Modified for use with AutoCAD 2.6     23 April 1987
; *******************************************************************

;--------:GLOBAL variables

; a$$    :Last angle (for default value)
; f$$    :Last file  (for default value)
; rtfile :Read File
; ang    :Rotation angle
; c      :Total line count
; cd     :Column distance
; d      :Distance between lines
; eof    :End of file flag
; l1     :First line to read
; h      :Text height
; j      :Text justification
; lc     :Column line count
; n      :Number of lines to read
; nl     :Number of lines per column
; opt    :Options list
; pt     :Text insertion point
; pt1    :First text insertion point
; rf     :File to read
; s      :Text string
; ts     :Text style list
; ul     :Upper/lower case flag

(defun MODES (a)
   (setq MLST '())
   (repeat (length a)
      (setq MLST (append MLST (list (list (car a) (getvar (car a))))))
      (setq a (cdr a)))
)

(defun MODER ()
   (repeat (length MLST)
      (setvar (caar MLST) (cadar MLST))
      (setq MLST (cdr MLST))
   )
)


(defun atxterr (st)                   ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
  (if (/= st "Function cancelled")
      (princ (strcat "\nError: " st))
  )
  (moder)                             ; Restore modified modes
  (if (= (type rtfile) 'FILE) (close rtfile))
  (setq rtfile nil)
  (setq *error* olderr)               ; Restore old *error* handler
  (princ)
)


   ;Function for inserting text a recalculation of insertion
   ;point.

   (defun 1LTXT ()
      (if (member '1 opt) (setq s (strcat "%%u" s "%%u")))
      (if (member '2 opt) (setq s (strcat "%%o" s "%%o")))
      (if (member '4 opt) (setq s (strcase s)))
      (if (member '8 opt) (setq s (strcase s T)))
      (if (and (= lc (1+ nl)) (/= nl 0))
          (progn
           (setq lc 1)
           (setq pt (polar pt1 ang cd))
           (setq pt1 pt)
          )
      )
      (cond ((and (= j "L") h)
             (command "TEXT" pt h (rtd ang) s)
            )
            ((and (/= j "L") h)
             (command "TEXT" j pt h (rtd ang) s)
            )
            ((and (= j "L") (null h))
             (command "TEXT" pt (rtd ang) s)
            )
            ((and (/= j "L") (null h))
             (command "TEXT" j pt (rtd ang) s)
            )
      )
      (if (/= d "Auto")
          (if (= (cdr (assoc 70 ts)) 4)
              (setq pt (polar pt (+ (dtr 90) ang) d))
              (setq pt (polar pt (+ (dtr 270) ang) d))
          )
      )
      (setq c (1+ c))
      (if (= c n)
          (setq eof T)
      )
   )

   ;Degrees to radians conversion
   (defun DTR (y)
    (* pi (/ y 180.0))
   )
   ;Radians to degrees conversion
   (defun RTD (Y)
    (* 180.0 (/ y pi))
   )

;********************** MAIN PROGRAM ***************************


(defun C:ASCTEXT (/ olderr ang c cd d eof rtfile rf h
                    j l1 opt pt pt1 ts n nl lc s ul)

  ; a$$ holds default ANGLE
  ; f$$ holds default fILE

  (setq olderr  *error*
        *error* atxterr)
  (modes '("BLIPMODE" "CMDECHO" "HIGHLIGHT"))

  (while (null rtfile)
         ;Prompt for file to be inserted
         (if (null f$$)
             (progn
              (initget 1)
              (prompt "\nFile to read (including extension): ")
             )
             (progn
              (prompt "\nFile to read (including extension)/<")
              (princ (strcat f$$ ">: "))
             )
         )
         (setq rf (getstring))
         (if (and (= rf "") (/= nil f$$))
             (setq rf f$$)
         )
         (setq rtfile (open rf "r"))
         (if rtfile
             (setq f$$ rf)
             (prompt "\nFile not found. ")
         )
  )

  ;Prompt for start point or justification
  (initget 1  "Center Middle Right")
  (setq pt (getpoint
             "\nStart point or Center/Middle/Right: "
           )
  )
  (if (/= (type pt) 'LIST)
      (setq j (substr pt 1 1))
      (setq j "L")
  )


  ;Prompt for an insertion point
  (if (/= (type pt) 'LIST)
      (progn
       (initget 1)
       (setq pt (getpoint (strcat "\n" pt " point: ")))
      )
  )
  (setq pt1 pt)  ; First insertion point

  ;Prompt for a text height
  (setq ts (tblsearch "STYLE" (getvar "TEXTSTYLE"))
        h nil
  )
  (if (= (cdr (assoc 40 ts)) 0.0)
      (progn
        (initget 6)
        (setq h (getdist pt (strcat "\nHeight <"
                                    (rtos (getvar "TEXTSIZE"))
                                    ">: "
                            )
                )
        )
        (if (null h) (setq h (getvar "TEXTSIZE")))
      )
  )

  ;Prompt for rotation angle of text
  (if (null a$$)
      (progn
       (if (= (cdr (assoc 70 ts)) 4)  ; Vertical style text
           (progn
            (setq a$$ 270)
            (prompt "\nRotation angle <270>: ")
           )
           (progn
            (setq a$$ 0)
            (prompt "\nRotation angle <0>: ")
           )
       )
      )
      (progn
       (prompt "\nRotation angle <")
       (princ (strcat (angtos a$$) ">: "))
      )
  )
  (setq ang (getangle pt))
  (if (null ang) (setq ang a$$))
  (setq a$$ ang)

  (setq d "Auto" l1 1 n "All" opt nil lc 0 nl 0 c 0)

  (initget "Yes No")
  (if (= "Yes"  (getkword "\nChange text options? <N>: "))
     (progn

       ;Prompt for distance between lines.
       (initget "Auto")
       (setq d (getdist pt "\nDistance between lines/<Auto>: "))
       (if (= d nil) (setq d "Auto"))

       ;Prompt for first line to read.
       (initget (+ 2 4))
       (setq l1 (getint "\nFirst line to read/<1>: "))
       (if (null l1) (setq l1 1))

       ;Prompt for number of following lines.
       (initget (+ 2 4) "All")
       (setq n (getint "\nNumber of lines to read/<All>: "))
       (if (= n "All") (setq n nil))

       (initget "Yes No")
       (if (= "Yes" (getkword "\nUnderscore each line? <N>: "))
           (setq opt (append opt '(1)))
       )
       (initget "Yes No")
       (if (= "Yes" (getkword "\nOverscore each line? <N>: "))
           (setq opt (append opt '(2)))
       )

       ; Option for global redefinition of text case.
       (initget "Upper Lower No")
       (prompt "\nChange text case? ")
       (setq ul (getkword "  Upper/Lower/<N>: "))
       (cond ((= ul "Upper") (setq opt (append opt '(4))))
             ((= ul "Lower") (setq opt (append opt '(8))))
       )

       ; Option for setting up columns.
       (initget "Yes No")
       (if (= "Yes" (getkword "\nSet up columns? <N>: "))
           (progn
            (setq opt (append opt '(16)))
            (initget (+ 1 2))
            (setq cd (getdist pt "\nDistance between columns: "))
            (initget (+ 1 2 4))
            (setq nl (getint "\nNumber of lines per column: "))
           )
       )

     )
  )
  (setvar "BLIPMODE" 0)
  (setvar "HIGHLIGHT" 0)
  (setvar "CMDECHO" 0)

  (setq eof nil)
  (setq s (repeat l1 (read-line rtfile)))

  (setq lc (1+ lc))
  (1ltxt)
  (while (null eof)
    (if (= d "Auto")
        (progn
         (setq s (read-line rtfile))
         (setq lc (1+ lc))
         (if s
           (progn
            (if (= lc (1+ nl))
                (1ltxt)
                (progn
                 (if (member '1 opt) (setq s (strcat "%%u" s "%%u")))
                 (if (member '2 opt) (setq s (strcat "%%o" s "%%o")))
                 (if (member '4 opt) (setq s (strcase s)))
                 (if (member '8 opt) (setq s (strcase s T)))
                 (command "TEXT" "" s)
                 (setq c (1+ c))
                 (if (= c n) (setq eof T))
                )
            )
           )
           (setq eof T)
         )
        )
        (progn
         (setq s (read-line rtfile))
         (setq lc (1+ lc))
         (if s (1ltxt) (setq eof T))
        )
    )
  )
  (close rtfile)                    
  (setq rtfile nil)
  (moder)                             ; Restore modified modes
  (setq *error* olderr)               ; Restore old *error* handler
  (princ)
)
