; **********************************************************************   
;                            CHFACE.LSP
;
; By Jan S. Yoder                                 April 22, 1988
;
; A routine to change the end point locations of 3dfaces by pointing.
;
; Undo backs up one face at a time, regardless of the number processed.
;
; Version 0.3
;
; **********************************************************************   

; Internal error handler

(defun myerr (s)                     ; If an error (such as CTRL-C) occurs
                                     ; while this command is active...
   (if (/= s "Function cancelled")
       (princ (strcat "\nError: " s))
   )
   (redraw ent 1)
   (command "undo" "e")
   (setvar "osmode" osm)             ; restore old OSNAP value
   (setvar "blipmode" obm)           ; restore old BLIPMODE value
   (setvar "cmdecho" ocmd)           ; restore old CMDECHO value
   (setq *error* olderr)             ; restore old *error* handler
   (princ)
)

; Move the vertex

(defun mvvtx (v opt)
  (initget 16)
  (setq npt (getpoint opt "\nNew location: ") )
  (if (= (type npt) 'LIST) 
   (progn
    (setq entl (subst (cons v (trans npt 1 0)) (assoc v entl) entl) ) 
    (entmod entl) ) ) 
)

; Allow selection of 3dfaces to redraw while editing

(defun disply (/ ss n1 t1)
  (cond (ss (princ "\nRedrawing entities...")
            (repeat (sslength ss)
              (ssadd (setq t1 (ssname ss (setq n1 (1+ n1)))) faclst)
            )
            (princ "done.")
        T)                           ; return T
  )
)

; Find the vertex by pointing

(defun findpt ()
  (foreach n '(10 11 12 13)
    (if (equal ans (cdr(assoc n entl)))
      (setq savn n)
    )
  )
  savn
)

; Main program

(defun C:CHFACE (/ splfo osm rg ent oflags entvtx1 entvtx2
                   entvtx3 entvtx4 ans flags tst test)

 (setq olderr   *error*
         *error*  myerr)
 (setq ocmd (getvar "cmdecho"))      ; save old CMDECHO value
 (setvar "cmdecho" 0)                ; set CMDECHO off
 (setq osm (getvar "osmode"))        ; save old OSNAP value
 (setq obm (getvar "blipmode"))      ; save old BLIPMODE value
 (setvar "blipmode" 0)               ; set BLIPMODE to off

 (setq cont "Yes")

; Get all the faces in the database
  
 (setq fcs (ssget "x" '((0 . "3DFACE"))))

  (setq test T ent nil xit T)
  (while test
   (setq ent (car(entsel "\nSelect the entity to change: ")))
   (if (equal ent nil)
     (princ "\nNo entity selected.  Please try again. ")
     (progn
      (setq savent ent
            entl (entget ent))
      (if (equal (cdr(assoc 0 entl)) "3DFACE")
       (setq test nil)
       (princ "\nEntity selected is not a 3Dface. ")
      )
     )
   )
  )

  (setvar "osmode" 1)                ; set osmode to endpoint
  (while xit
    (command "undo" "group")
    (disply)
    (redraw ent 3)
    (initget "1 2 3 4 Undo Display")
    (setq ans (getpoint "\n1/2/3/4/Undo/Display/<Select vertex>: "))
    (cond
      ((= ans "1")
        (setq entvtx (trans (cdr(assoc 10 entl)) 0 1))
        (mvvtx 10 entvtx)
      )
      ((= ans "2")
        (setq entvtx (trans (cdr(assoc 11 entl)) 0 1))
        (mvvtx 11 entvtx)
      )
      ((= ans "3")
        (setq entvtx (trans (cdr(assoc 12 entl)) 0 1))
        (mvvtx 12 entvtx)
      )
      ((= ans "4")
        (setq entvtx (trans (cdr(assoc 13 entl)) 0 1))
        (mvvtx 13 entvtx)
      )
      ((= ans "Undo")
        (command "undo" "e")
        (command "undo" "3")
        (setq ent savent
              entl (entget ent))     ; restore saved entity
      )
      ((= ans "Display")
        (initget "All Select")
        (setq ss (if (eq (setq ans (getkword "\nSelect/<All>: ")) "Select")
                     (ssget)
                 )
              n1 -1
        )
        (if (= ans "Select") (disply) (redraw))
      )
      ((= (type ans) 'LIST)
        (setq n (findpt)
              entvtx (trans (cdr(assoc n entl)) 0 1))
        (mvvtx n entvtx)
      )
      ((or (= ans "") (= ans nil))
        (setq xit nil)
        (redraw ent 1)
        (command "undo" "e")
        (setvar "osmode" osm)        ; restore old OSNAP value
        (setvar "blipmode" obm)      ; restore old BLIPMODE value
        (setvar "cmdecho" ocmd)      ; restore old CMDECHO value
        (setq *error* olderr)        ; restore old *error* handler
        (princ)                       
      )
    )
  )
)
