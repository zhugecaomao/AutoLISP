; ************************************************************************
;                                PREVIEW.LSP

;          Written by Jan S. Yoder         January 26, 1988

;    Camera preview routine for Dview
;    Uses Ashade.lsp and existing camera blocks.

;    The user is requested to choose whether to select camera blocks by 
;    pointing or optionally to type "Name" and be able to select a camera 
;    by its name in the SNAME attribute field. 

;    If this option is chosen and the name is not found using SSGET "X",
;    the available camera names will be printed out and the routine will 
;    end.

;    A default lens length is being set such that the view is just in 
;    front of the camera and therefore does not interfere with the view.

;    Version 1.0a    
; ************************************************************************

;    Camera selection routine for selecting a camera for viewing based
;    on the user defined name.  If name is not found, a list of all 
;    available names is printed as a list of the form (CAM1 CAM2 CAM3... 
;    CAMn).  Could be modified in or added to Ashade.lsp for camera and 
;    light selection.

(defun sget ( sset / sset1 names true n so s1 s2 sname)
    (setq so (strcase sset))
    (setq sname nil n nil true nil sset1 nil s1 nil s2 nil names nil)
    (setq sset1 (ssget "X" '((2 . "CAMERA"))))
    (setq n (- (sslength sset1) 1))
    (while (>= n 0)
      (setq s1(entget(ssname sset1 n)))
      (setq s2(entget(entnext(cdr(assoc -1 s1)))))
      (cond
         ((and (= (cdr(assoc 0 s2)) "ATTRIB")
               (/= (cdr(assoc 0 s2)) "SEQEND")
          )
            (cond
               ((= (cdr(assoc 2 s2)) "SNAME")
                (setq sname (strcase(cdr(assoc 1 s2))))
                  (if (= sname so)
                      (progn 
                        (setq true "T")
                        (setq sset (list 
                              (cdar (entget(ssname sset1 n))) '(0 0 0)))
                        (setq n -1)
                      )
                      (setq names (cons sname names)) 
                  )
               )
            )
            (setq n (1- n))
         ) 
      )
    )
   (if (/= true "T")    
       (if (/= so "?")
         (progn 
           (princ "\nA block by that name was not found. ")
           (princ "\nThe following camera blocks were found:  \n")
           (princ (reverse names))
           (setq sset nil)
         )
         (progn 
           (princ "\nThe following camera blocks were found: \n")
           (princ (reverse names))
           (setq sset nil)
         )
       )
       (setq sset sset)
    )
)

;  This function performs the action of getting to the new camera position.
;  If there is no camera entity, then exit without doing anything.
;  There are three lines commented out, which if turned on will display 
;  the camera and target points, pause for a short while, then continue 
;  on.  These can be deleted or turned on as desired.

(defun act (ent / nxt tar cam T lax lay laz ohl s a dist)
  (if (/= ent nil)
   (progn
    (setq nxt(entget(entnext(cdr(assoc -1 ent)))))
    (while 
       (and (= (cdr(assoc 0 nxt)) "ATTRIB")
            (/= (cdr(assoc 0 nxt)) "SEQEND")
       )
         (cond
            (  (= (cdr(assoc 2 nxt)) "LAX")
              (setq lax (cdr(assoc 1 nxt))))
            (  (= (cdr(assoc 2 nxt)) "LAY")
              (setq lay (cdr(assoc 1 nxt))))
            (  (= (cdr(assoc 2 nxt)) "LAZ")
              (setq laz (cdr(assoc 1 nxt))))
         (T 
           )
         )
      (setq nxt(entget(entnext(cdr(assoc -1 nxt)))))
    )
    (setq tar (list (atof lax) (atof lay) (atof laz)))
    (setq cam (trans (list (cadr(assoc 10 ent)) 
                           (caddr(assoc 10 ent))
                           (cadddr(assoc 10 ent))) 1 0))
    (setq dist (* 0.9 (/ (setq dis (distance cam tar)) 
        (cos (atan (/ (- (caddr cam) (caddr tar)) (distance cam tar)))))))
;   (princ "\nThe target point is : ")(princ tar)
;   (princ "\nThe camera position is : ")(princ cam)
    (repeat 2000 (setq a nil))               ;Dummy pause loop
    (princ "\nSelect the objects that you wish to preview in Dview: ")
    (menucmd "s=dview")
    (setq sset (ssget))
    (setq T nil)
    (setq ohl (getvar "highlight"))
    (command "undo" "m")
    (setvar "highlight" 0)
    (if (null sset)
        (setq s 2) (setq s 1)
    )
    (cond ((= s 1)
          (command "dview" sset "" "po" tar cam "d" dist)
          )
          ((= s 2)
             (command "dview" "" "po" tar cam "d" dist)
          )
    )
    (setvar "highlight" ohl) 
   )
   (princ "\nSorry, no entity selected or found. ") 
  )
)

; Internal error handler

(defun myerr (s)                     ; If an error (such as CTRL-C) occurs
                                     ; while this command is active...
   (if (/= s "Function cancelled")
       (princ (strcat "\nError: " s))
   )
   (setvar "CMDECHO" ocmd)           ; Restore old variable
   (setq *error* olderr)             ; Restore old *error* handler
   (princ)
)
(princ)

; Main function preview

(defun c:preview ( / sset ent olderr ocmd)
 (setq olderr *error*
       *error* myerr)
 (setq ocmd (getvar "CMDECHO"))
 (setvar "CMDECHO" 0)
 (initget "Name Select")
 (setq sset (getkword "\nType 'S' to select a camera or 'N' to select a camera by name <S>: "))
 (if (= sset nil) (setq sset "Select"))
 (if (= sset "Select")
  (progn
   (princ "\nSelect the camera position that you wish to view in Dview: ") 
   (setq sset (entsel))
   (while
     (cond
       ((= sset nil) 
         (princ "\nNo entity selected; please select another camera position: ")
       )
       ((/= (cdr(assoc 2 (setq ent(entget (car sset))))) "CAMERA")
         (progn
           (princ "\nEntity selected is not an AutoShade camera block. ")
           (princ "\nPlease select another camera position: ")
         )
       )
     )                                       
   (setq sset(entsel))
   )                                        
   (act ent)                                
  )                                         
  (progn
   (setq sset (getstring "\nEnter the camera name you wish to preview in Dview; Name/<?>: "))
   (if (= sset "") (setq sset "?"))
   (setq sset(sget sset))
   (if (/= sset nil)
     (progn 
      (setq ent(entget(car sset)))
      (act ent)
     )
   )
  )                                         
 )                                          
(setvar "CMDECHO" ocmd)
(setq *error* olderr)                ; Restore old *error* handler
(princ)
)
;  ************************ End of File **********************************
