
;                          TABLES.LSP

;  Exerciser for (TBLNEXT) and (TBLSEARCH) functions.

;  The functions (LAYERS), (LTYPES), (VIEWS), (STYLES), (BLOCKS)
;  (UCS), and (VPORT) can be called independently.  Each lists the 
;  entries in the associated symbol table, optionally in alphabetical 
;  order.  The TABLES command ((C:TABLES) funciton) calls each of them 
;  in turn.

;  For the layer, linetype, and text style tables, an asterisk in column
;  one marks the current setting.  If the current linetype is "BYLAYER",
;  the linetype corresponding to the current layer will be marked with
;  an "L" in column one.

;  by Duff Kurland - Autodesk, Inc.
;  October 12, 1986

;  Added (UCS) and (VPORT) - May 1988 

;  (LAYERS) - Dump the layer table

(defun layers ( / c d f ln lt ly n x)
   (tblset "layer")
   (write-line "  Layer       Status  Color  Linetype    Description")
   (terpri)
   (setq cl (getvar "clayer"))          ; get current layer
   (setq n  0)
   (setq x  (next T))                   ; get first layer
   (while x
      (setq n  (1+ n)
            ly (fld  2 x)               ; layer name
            ln (fld  6 x)               ; linetype name
            c  (fld 62 x)               ; color number
            f  (logand (fld 70 x) 1)    ; "frozen" flag
            lt (tblsearch "ltype" ln)   ; linetype table entry
            d  (fld  3 lt)              ; linetype prose description
      )
      (write-line
         (strcat
            (if (= ly cl) "* " "  ")    ; flag current layer
            (strfill ly 12)             ; edit layer name
            (strfill
               (cond ((= f 1) "Frozen") ; edit status
                     ((< c 0) "Off")
                     (T       "On")
               ) 8
            )
            (strfill (itoa (abs c)) 7)  ; edit color number
            (strfill ln 12)             ; edit linetype name
            (substr d 1 30)             ; edit linetype description
         )
      )
      (setq x (next nil))               ; get next layer entry
   )
   (princ (if (= n 0) "  -None-\n\n" "\n"))
   nil
)


;  (LTYPES) - Dump the linetype table

(defun ltypes ( / a cl d f lt n s x)
   (tblset "ltype")
   (write-line "  Linetype    Align  Segs  Description")
   (terpri)
   (setq cl (getvar "celtype"))         ; get current linetype
   (setq f  "* ")                       ; set default "current" flag

   ;  If current linetype is "BYLAYER", look up the linetype
   ;  associated with the current layer, and change the
   ;  "current" flag from "* " to "L ".

   (setq cl
      (cond ((= cl "BYBLOCK") "")
            ((= cl "BYLAYER") (setq f "L ")
                              (fld 6 (tblsearch "layer" (getvar "clayer"))))
            (T cl)
      )
   )
   (setq n 0)
   (setq x (next T))                    ; first linetype
   (while x
      (setq n  (1+ n)
            lt (fld  2 x)               ; linetype name
            d  (fld  3 x)               ; linetype prose description
            a  (fld 72 x)               ; alignment code
            s  (fld 73 x)               ; number of dash length items
      )
      (write-line
         (strcat
            (if (= lt cl) f "  ")       ; flag current entity linetype
            (strfill lt 12)             ; edit layer name
            (strfill (chr a) 7)         ; alignment code
            (strfill (itoa s) 6)        ; number of dash length items
            (substr d 1 30)             ; linetype description
         )
      )
      (if (> s 0) (progn

         ;  Edit dash length items

         (setq x (member (assoc 49 x) x)) ; get list of dash items
         (while x
            (setq s (cdar x))           ; get dash length
            (write-line
               (strcat
                  (strfill " " 27)
                  (cond ((= s 0) "Dot")
                        ((> s 0) (strcat "Pen down " (rtos s 2 4)))
                        (T       (strcat "Pen up   " (rtos (abs s) 2 4)))
                  )
               )
            )
            (setq x (cdr x))            ; get next dash item
         )
      ))
      (setq x (next nil))               ; get next linetype entry
   )
   (princ (if (= n 0) "  -None-\n\n" "\n"))
   nil
)


;  (VIEWS) - Dump the named view table

(defun views ( / c d h n v w x z)
   (tblset "view")
   (write-line "  View        Height x Width    Center            Direction")
   (terpri)
   (setq n 0)
   (setq x (next T))                    ; get first view
   (while x
      (setq n  (1+ n)
            v  (fld  2 x)               ; view name
            c  (fld 10 x)               ; center point
            d  (fld 11 x)               ; X,Y of direction
            z  (fld 31 x)               ; Z of direction
            h  (fld 40 x)               ; height
            w  (fld 41 x)               ; width (valid only for windows)
      )
      (write-line
         (strcat
            "  "
            (strfill v 12)              ; edit view name
            (strfill (strcat (rtos h 2 4)   ; edit height x width
                             "x"
                             (rtos w 2 4)) 18
            )
            (strfill (strcat (rtos (car c) 2 4)  ; edit center point
                             ","
                             (rtos (cadr c) 2 4)) 18
            )
            (rtos (car d) 2 4)          ; edit X portion of direction
            ","
            (rtos (cadr d) 2 4)         ; edit Y portion of direction
            ","
            (rtos z 2 4)                ; edit Z portion of direction
         )
      )
      (setq x (next nil))               ; get next view entry
   )
   (princ (if (= n 0) "  -None-\n\n" "\n"))
   nil
)


;  (STYLES) - Dump the text style table

(defun styles ( / cs fb ff g h n o s w x)
   (tblset "style")
   (write-line "  Text style  Height  Width   Slant  Flags  Font      Bigfont")
   (terpri)
   (setq cs (getvar "textstyle"))       ; get current style
   (setq n  0)
   (setq x  (next T))                   ; get first style
   (while x
      (setq n  (1+ n)
            s  (fld  2 x)               ; style name
            ff (fld  3 x)               ; primary font file
            fb (fld  4 x)               ; big font file
            h  (fld 40 x)               ; height
            w  (fld 41 x)               ; width factor
            o  (fld 50 x)               ; obliquing angle
            g  (fld 71 x)               ; generation flags
      )
      (write-line
         (strcat
            (if (= s cs) "* " "  ")     ; flag current style
            (strfill s 12)              ; edit style name
            (strfill (rtos h 2 4) 8)    ; height
            (strfill (rtos w 2 4) 8)    ; width factor
            (strfill (angtos o 0 2) 7)  ; obliquing angle
            (strfill (itoa g) 7)        ; generation flags
            (strfill ff 10)             ; primary font file
            fb                          ; big font file
         )
      )
      (setq x (next nil))               ; get next style entry
   )
   (princ (if (= n 0) "  -None-\n\n" "\n"))
   nil
)


;  (BLOCKS) - Dump the block definition table

(defun blocks ( / b e ec ed et f n o x)
   (tblset "block")
   (write-line "  Block       Flags  Origin")
   (terpri)
   (setq n 0)
   (setq x (next T))                    ; get first block definition
   (while x
      (setq n  (1+ n)
            b  (fld  2 x)               ; block name
            o  (fld 10 x)               ; origin X,Y,Z
            f  (fld 70 x)               ; flags
      )
      (write-line
           (strcat
                "  "
                (strfill b 12)          ; edit block name
                (strfill (itoa f) 7)    ; flags
                (rtos (car o) 2 4)      ; origin X
                ","
                (rtos (cadr o) 2 4)     ; origin Y
                ","
                (rtos (caddr o) 2 4)    ; origin Z
           )
      )

      ;  Display interesting facts about the entities comprising
      ;  this block definition.

      (setq e (fld -2 x))               ; point to first entity
      (while e
           (setq ed (entget e))         ; get the entity data
           (setq et (fld  0 ed))        ; entity type
           (setq ec (fld 62 ed))        ; entity color
           (write-line
               (strcat
                   (strfill " " 14)
                   (strfill et 9)       ; edit entity type
                   " on layer "
                   (fld 8 ed)           ; edit layer name
                   " with color "
                   (cond ((= ec 0)  "BYBLOCK")  ; edit color number
                         ((null ec) "BYLAYER")
                         (T         (itoa ec))
                   )
               )
           )
           (if (setq e (entnext e))     ; if there's another entity,
               (setq ed (entget e))     ;   read its data
           )
      )
      (terpri)
      (setq x (next nil))               ; get next block entry
   )
   (princ (if (= n 0) "  -None-\n\n" "\n"))
   nil
)

;  (UCS) - Dump the UCS table

(defun ucs ( / n x na o oz xd xz yd yz)
   (tblset "ucs")
   (write-line "  UCS         Origin            X axis direction    Y axis direction")
   (terpri)
   (setq n  0)
   (setq x  (next T))                   ; get first ucs
   (while x
      (setq n  (1+ n)
            na (fld  2 x)               ; UCS name
            o  (fld 10 x)               ; origin
            oz (fld 30 x)               ; origin z 
            xd (fld 11 x)               ; X axis direction
            xz (fld 31 x)               ; X axis z 
            yd (fld 12 x)               ; Y axis direction
            yz (fld 32 x)               ; Y axis z 
      )
      (write-line
         (strcat
            (if (= na cucs) "* " "  ")  ; flag current UCS
            (strfill na 12)             ; edit UCS name
            (strfill (strcat "("
               (rtos (car o) 2 2)       ; edit UCS origin
               ","
               (rtos (cadr o) 2 2)
               ","
               (rtos oz 2 2)
               ")") 18)
            (strfill (strcat "("
               (rtos (car xd) 2 2)      ; edit X axis direction
               ","
               (rtos (cadr xd) 2 2)
               ","
               (rtos xz 2 2)
               ")") 20)
               "("
               (rtos (car yd) 2 2)      ; edit Y axis direction
               ","
               (rtos (cadr yd) 2 2)        
               ","
               (rtos yz 2 2)
               ")"
         )
      )
      (setq x (next nil))               ; get next UCS entry
   )
   (princ (if (= n 0) "  -None-\n\n" "\n"))
   nil
)

;  (VPORT) - Dump the viewport table

(defun vport ( / n x na ll ur v)
   (setq prev nil)
   (tblset "vport")
   (write-line "  Viewport    Lower left     Upper Right     View Mode")
   (terpri)
   (setq n  0)
   (setq x  (nextvp T prev))            ; get first viewport
   (while x
      (setq n  (1+ n)
            na (fld  2 x)               ; viewport name
            ll (fld 10 x)               ; lower left corner
            ur (fld 11 x)               ; upper right corner
            v  (fld 71 x)               ; view mode
      )
      (write-line
         (strcat
            "  "
            (strfill na 10)             ; edit viewport name
            "  "
            (strfill (strcat "("        ; edit lower left corner
               (rtos (car ll) 2 2)
               ","
               (rtos (cadr ll) 2 2)
               ")") 15)   
            (strfill (strcat "("        ; edit upper right corner
               (rtos (car ur) 2 2)
               ","
               (rtos (cadr ur) 2 2)
               ")") 15)
            " "
            (rtos v 2 2)                ; edit view mode
         )
     )
      (setq x (nextvp nil prev))        ; get next viewport entry
   )
   (princ (if (= n 0) "  -None-\n\n" "\n"))
   nil
)

;  Blank-fill the given string to a specified number of characters

(defun strfill (s len)
   (substr (strcat s "                              ") 1 len)
)

;  Return the value associated with a particular entity field

(defun fld (num lst)
   (cdr (assoc num lst))
)

;  Set up to process specified symbol table.  If TBLSORT is not yet
;  defined, ask user whether the entries should be sorted.  If sorting
;  is enabled, obtain all entries and sort them forming TBLENTS list.

(defun tblset (tbl / olderr new s)
  (setq olderr *error*
         *error* myerror)
  (textscr)
  (setq tblname tbl)                    ; set table name
  (if (null tblsort) (progn             ; sorting not yet determined
     (initget 1 "Yes No")               ; Establish keywords, no null
     (setq s (getkword "\nSort the entries (Y/N) ? "))
     (setq tblsort (if (= s "Yes") 1 0))
  ))
  (if (= tblsort 1) (progn              ; if sorting is enabled
     (setq tblents nil)                 ; start with null list
     (setq new (cdr (assoc 2 (tblnext tbl T))))   ; get first entry name
     (while new
        (setq tblents (cons new tblents))         ; add to list
        (setq new (cdr (assoc 2 (tblnext tbl))))  ; get next entry name
     )
     (setq tblents (str-sort tblents))            ; sort the name list
  ))
  (setq *error* olderr)                 ; restore old *error* handler
  (princ)
)

;  Obtain next (or first) entry from table, or from sorted entry list.

(defun next (first / temp)
   (if (= tblsort 1) (progn             ; if sorting enabled
      (setq temp (car tblents))         ; get next name from list
      (if temp (progn                   ; if not end of list...
         (setq tblents (cdr tblents))   ; chop from list
         (tblsearch tblname temp)       ; get table entry for this name
      ))
    )
    (tblnext tblname first)             ; else get next (or first) table entry
   )
)

;  Obtain next (or first) vports entry from table, or from sorted entry list.

(defun nextvp (first prev / temp)
   (if (= tblsort 1) (progn             ; if sorting enabled
      (if first
         (setq temp (car tblents))      ; get first name from list
         (progn
            (setq prev (car tblents))   ; store previous name
            (setq temp (cadr tblents))  ; get next name from list
         )
      )
      (if temp (progn
         (if (null first)
            (setq tblents (cdr tblents)); chop from list
         )
         (if (= prev temp) (progn
            (setq prev temp)
            (tblnext tblname first)     ; get next table entry
            )(progn
            (setq prev temp)
            (tblsearch tblname temp T)  ; get table entry for this name
         ))
      ))
      )
      (tblnext tblname first)           ; else get next (or first) table entry
   )
)

;  Sort a list of strings.

(defun str-sort (x)
  (cond ((null (cdr x)) x)
        (T (str-merge (str-sort (first-half x))
                      (str-sort (last-half x))))))

(defun str-merge (a b)
  (cond ((null a) b)
        ((null b) a)
        ((< (strcmp (car a) (car b)) 0)
           (cons (car a) (str-merge (cdr a) b)))
        (t (cons (car b) (str-merge a (cdr b))))))

(defun first-half (l)
  (head l (1- (length l))))

(defun head (l n)
  (cond ((minusp n) nil)
        (t (cons (car l) (head (cdr l) (- n 2))))))

(defun last-half (l)
  (tail l (1- (length l))))

(defun tail (l n)
  (cond ((minusp n) l)
        (t (tail (cdr l) (- n 2)))))

;  Compare two strings.  Return 0 if they are equal, -1 if the
;  first string is less than the second in ASCII collating sequence,
;  and 1 if the second string is less than the first.

(defun strcmp (a b)
  (cond ((= a b) 0)
        (T (cond ((< (ascii a) (ascii b)) -1)
                 ((> (ascii a) (ascii b))  1)
                 (t (strcmp (substr a 2) (substr b 2)))))))

; Internal error handler

(defun myerror (s)                      ; If an error (such as CTRL-C) occurs
                                        ; while this command is active...
   (if (/= s "Function cancelled")
      (princ (strcat "\nError: " s))
   )
   (setq *error* olderr)                ; restore old *error* handler
   (princ)
)

;  Dump all the symbol tables

(defun C:TABLES ()
   (setq tblsort nil)                   ; Force "Sort Y/N" query
   (layers)
   (ltypes)
   (views)
   (styles)
   (blocks)
   (ucs)
   (vport)
)
