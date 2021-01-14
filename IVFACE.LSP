
; ************************************************************************
;                             IVFACE.LSP
;
; By Jan S. Yoder                                   21 Avril 88
;
; A routine to change the invisibility flags of 3dfaces by pointing.
;
; Revised 22 Avril 88
;
; Undo backs up one face at a time, regardless of the number processed.
;
; Version 0.3
;
; ************************************************************************

; Internal error handler

(defun myerr (s)                     ; If an error (such as CTRL-C) occurs
                                     ; while this command is active...
   (if (/= s "Function cancelled")
       (princ (strcat "\nError: " s))
   )
   (setvar "splframe" splfo)
   (command "color" "bylayer")
   (if (= rg "Yes") (command "regen")) ; regen if resetting splframe to off
   (entdel (cdr(assoc -1 ent)))
   (entdel (cdr(assoc -1 ent)))
   (setq *error* olderr)             ; Restore old *error* handler
   (setvar "cmdecho" ocmd)
   (princ)
)

; Main program

(defun C:IVFACE (/ olderr ocmd rg splfo tst cont text ent osm entvtx1 entvtx2 entvtx3 entvtx4 ans flags)

 (setq olderr   *error*
         *error*  myerr)
 (setq ocmd (getvar "cmdecho"))
 (setvar "cmdecho" 0)

 (initget "Yes No")
 (setq rg (getkword "\nWould you like to regenerate the drawing to view invisible edges?  Yes/<No> ") )
 (if (= rg "Yes")
  (progn
   (setq splfo (getvar "splframe"))
   (setvar "splframe" 1)
   (command "regen")
  )
 )

 (setq tst T cont "Yes")
 (while tst
  (setq test T ent nil)
  (command "undo" "group")
  (setq osm (getvar "osmode"))       ; save old OSNAP value
  (setvar "osmode" 0)                ; set OSNAP to off
  (while test
   (setq ent (entsel "\nSelect the entity to change: "))
   (if (equal ent nil)
     (princ "\nNo entity selected -- please try again. ")
     (progn
      (setq ent (entget(car ent)))
      (if (equal (cdr(assoc 0 ent)) "3DFACE")
       (setq test nil)
       (princ "\nEntity selected is not