
; (C) Copyright 1988 by Autodesk, Inc.
;----------------------------------------------------------------------------;
; FUNCTION NAME :  ATTFIX
;                                              
;----------------------------------------------------------------------------;
; REVISION HISTORY
; 
; Ver. 1.0    06/01/88  AXT           
;----------------------------------------------------------------------------;
; FUNCTION ARGUMENTS 
;
;    None.
;----------------------------------------------------------------------------;
; FUNCTION RETURNS
;
;    None.
;----------------------------------------------------------------------------;
; GLOBAL VARIABLES
;
;    None.
;----------------------------------------------------------------------------;
; CALLED FROM
;
;  AutoCAD command line.
;----------------------------------------------------------------------------;
; CALLS
; name      : function
;
; f:ratt()              : read attribute values from a block
;----------------------------------------------------------------------------;
; OPERATION
;
;
; This routine is written to fix the attribute block conversion bug
;  when updating from AEC Arch 1.5/2.5 to 2.0/9.0
;
;------------------------------ END OF HEADER -------------------------------;
;
;------------------------------ MAIN FUNCTION -------------------------------;

(defun c:attfix ( / v:1 v:2 v:3 v:4 v:5 v:6 v:7 v:8 v:9 v:10 v:11 v:12
                 v:13 v:14 v:15 v:16 v:17 v:18 v:19 rspnse selset ed bname
                 ent nent temp count ipt xscal yscal i blay loop prmpt tatt
                 once dxa dya dxr dyr)
(gc)
(setvar "cmdecho" 0)
(command "undo" "end")
(command "undo" "mark")
(f:mods '("osmode" "expert" "attdia"))
(f:slay "0")
(setvar "osmode" 0)
(setvar "expert" 3)
(setvar "attdia" 0)
(setq uscal (getvar "userr3"))
(setq dxa (* 0.01669046 (getvar "userr3"))  ; x offset distance for appliance att blocks insert
      dya (* 0.01329462 (getvar "userr3"))  ; y offset distance for appliance att blocks insert
      dxr (* 0.12897321 (getvar "userr3"))  ; x offset distance for finish att blocks insert
      dyr (* 0.48367811 (getvar "userr3"))  ; y offset distance for finish att blocks insert
      dxw (* 0.05215464 (getvar "userr3"))  ; x offset distance for window attribute
      dyw (* -0.07989646 (getvar "userr3")) ; y offset distance for window attribute
      loop T 
      once T 
)

(textscr)
(prompt "\n ATTFIX version 1.0   6/01/88")
(prompt "\n (C) Copyright 1988 by Autodesk, Inc.")
(prompt "\n \n \n \nAutoCAD AEC Architectural 2.0/9.0 includes an UPDATE routine for")
(prompt "\nupdating older AEC Architectural drawings.  This routine damages attribute")
(prompt "\ntags used with doors, windows, appliances, cabinet finish and room finish.")
(prompt "\nAll copies of AEC Architectural shipped after May 16, 1988 include a")
(prompt "\ncorrected UPDATE routine.  These copies are designated as version 2.01/9.0.")
(prompt "\n \nIf you have used the UPDATE routine provided with AEC Architectural 2.0/9.0")
(prompt "\nyou can use this ATTFIX routine to correct the affected attributes in each")
(prompt "\ndrawing in which they occur.  If you have not yet used this UPDATE routine,")
(prompt "\nyou have no need for ATTFIX.")
(prompt "\n \n \nBe sure to have a backup of this drawing before continuing with ATTFIX.")
(prompt "\n \n \nPress Control C to return to your drawing now if you do not")
(prompt "\nneed to use ATTFIX.")
(prompt "\n \nPress any key to proceed with this routine.")
(terpri)
(grread)
(graphscr)

(while loop
 (menucmd "S=aj01ab")                            ;Object sel menu
 (prompt "\n \nSelect the attribute tags that you want to review. ")
 (setq selset (ssget))
 (if selset
   (progn
   ;-- highligh selection set
     (setq count 0)
     (while (setq ent (ssname selset count))
       (setq ed (entget ent)
             bname (cdr (assoc 2 ed))
             count (1+ count)
       )
       (if (or (eq bname "AU016T1") (eq bname "AU019T1")
               (eq bname "AUD1DAS") (eq bname "AUW1DAS")
               (eq bname "AU018T1")
           )
            (redraw ent 3)
       )
     )
     (menucmd "S=AU009S1")            ;Y(es) N(o) menu
     (prompt "\n \nYou may review each of these tags individually,")
     (prompt "\nor have them fixed automatically.")
     (setq prmpt (getstring "\nDo you want to review each tag individually?  <Yes>: "))
     (if (or (= (strcase (substr prmpt 1 1)) "Y") (= prmpt ""))
        (setq prmpt T)
        (setq prmpt nil)
     )

     (if prmpt
       (progn
          ;-- dehighlight selection set
          (setq count 0)
          (while (setq ent (ssname selset count))
            (setq ed (entget ent)
                  bname (cdr (assoc 2 ed))
                  count (1+ count)
            )
            (if (or (eq bname "AU016T1") (eq bname "AU019T1")
                    (eq bname "AUD1DAS") (eq bname "AUW1DAS")
                    (eq bname "AU018T1")
                )
                 (redraw ent 4)
            )
          )
     ;-- start going through the selection set.
          (setq count 0)
          (while (setq ent (ssname selset count))
            (setq ed    (entget ent)
                  bname  (cdr (assoc 2 ed))
                  ipt (cdr (assoc 10 ed))
                  xscal (cdr (assoc 41 ed))
                  yscal (cdr (assoc 42 ed))
                  blay (cdr (assoc 8 ed))
                  count (1+ count)
            )
            (cond
              ((eq bname "AU016T1")
                (command "layer" "s" blay "")
                (f:ratt)
                (redraw ent 3)
                (prompt "\nDepth: ")
                (princ v:7)
                (prompt "\nHeight: ")
                (princ v:8)
                (menucmd "S=AU009S1")            ;Y(es) N(o) menu
                (setq rspnse (getstring "\nDo you want these APPLIANCE attribute values fixed?  <Yes>: "))
                (if (or (= (strcase (substr rspnse 1 1)) "Y") (= rspnse ""))
                  (progn                              
                     (entdel ent)
                     (setq temp v:8
                           v:8 v:7
                           v:7 temp
                     )
                     (setq ipt (list (+ (car ipt) dxa) (+ (cadr ipt) dya)))
                     (command "insert" "AU016T1" ipt xscal yscal 0)
                     (setq i 1)
                     (repeat 11
                       (command (eval (read (strcat "v:" (itoa i)))))
                       (setq i (1+ i))
                     )
                  )
                  (redraw ent 4)
                )
              )
              ((eq bname "AU018T1")
                (redraw ent 3)
                (menucmd "S=AU009S1")            ;Y(es) N(o) menu
                (setq rspnse (getstring "\n \n \nDo you want this ROOM FINISH tag returned to its original size?  <Yes>: "))
                (if (or (= (strcase (substr rspnse 1 1)) "Y") (= rspnse ""))
                     (command "scale" ent "" ipt "1.66667"     
                              "move" ent "" ipt
                              (list (+ (car ipt) dxr) (+ (cadr ipt) dyr))
                     )
                )
                (redraw ent 4)
              )
              ((eq bname "AU019T1")
                (command "layer" "s" blay "")
                (f:ratt)
                (redraw ent 3)
                (prompt "\nSymbol:  ")
                (setq tatt v:1)
                (while (< (strlen tatt) 20)
                  (setq tatt (strcat tatt " "))
                )
                (princ (substr tatt 1 20))
                (prompt "  Mounting:  ")
                (setq tatt v:2)
                (while (< (strlen tatt) 20)
                  (setq tatt (strcat tatt " "))
                )
                (princ (substr tatt 1 20))
                (prompt "\nQuality:  ")
                (setq tatt v:4)
                (while (< (strlen tatt) 20)
                  (setq tatt (strcat tatt " "))
                )
                (princ (substr tatt 1 20))
                (prompt " Elevation:  ")
                (setq tatt v:5)
                (while (< (strlen tatt) 20)
                  (setq tatt (strcat tatt " "))
                )
                (princ (substr tatt 1 20))
                (menucmd "S=AU009S1")            ;Y(es) N(o) menu
                (setq rspnse (getstring "\nDo you want these CABINET FINISH attribute values fixed?  <Yes>: "))
                (if (or (= (strcase (substr rspnse 1 1)) "Y") (= rspnse ""))
                  (progn                              
                     (entdel ent)
                     (setq temp v:5 
                           v:5 v:1
                           v:1 temp
                           temp v:4
                           v:4 v:2
                           v:2 temp
                     )
                     (command "insert" "AU019T1" ipt (* 1.95 xscal) (* 1.95 yscal) 0)
                     (setq i 1)
                     (repeat 6
                       (command (eval (read (strcat "v:" (itoa i)))))
                       (setq i (1+ i))
                     )
                  )
                  (redraw ent 4)
                )
              )
              ((eq bname "AUD1DAS")
                (command "layer" "s" blay "")
                (f:ratt)
                (redraw ent 3)
                (prompt "\nNumber:  ")
                (setq tatt v:1)
                (while (< (strlen tatt) 20)
                  (setq tatt (strcat tatt " "))
                )
                (princ (substr tatt 1 20))
                (prompt "  Width:  ")
                (setq tatt v:2)
                (while (< (strlen tatt) 20)
                  (setq tatt (strcat tatt " "))
                )
                (princ (substr tatt 1 20))
                (prompt "\nHeight:  ")
                (princ v:3)
                (menucmd "S=AU009S1")            ;Y(es) N(o) menu
                (setq rspnse (getstring "\nDo you want these DOOR attribute values fixed?  <Yes>: "))
                (if (or (= (strcase (substr rspnse 1 1)) "Y") (= rspnse ""))
                  (progn                              
                     (entdel ent)
                     (setq temp v:3
                           v:3 v:2
                           v:2 v:1
                           v:1 temp
                     )
                     (command "insert" "AUD1DAS" ipt xscal yscal 0)
                     (setq i 1)
                     (repeat 18
                       (command (eval (read (strcat "v:" (itoa i)))))
                       (setq i (1+ i))
                     )
                  )
                  (redraw ent 4)
                )
              )
              ((eq bname "AUW1DAS")
                (command "layer" "s" blay "")
                (f:ratt)
                (redraw ent 3)
                (prompt "\nNumber:  ")
                (setq tatt v:1)
                (while (< (strlen tatt) 20)
                  (setq tatt (strcat tatt " "))
                )
                (princ (substr tatt 1 20))
                (prompt "  Width:  ")
                (setq tatt v:2)
                (while (< (strlen tatt) 20)
                  (setq tatt (strcat tatt " "))
                )
                (princ (substr tatt 1 20))
                (prompt "\nHeight:  ")
                (setq tatt v:3)
                (while (< (strlen tatt) 20)
                  (setq tatt (strcat tatt " "))
                )
                (princ (substr tatt 1 20))
                (prompt "  Sill Height:  ")
                (setq tatt v:4)
                (while (< (strlen tatt) 20)
                  (setq tatt (strcat tatt " "))
                )
                (princ (substr tatt 1 20))
                (menucmd "S=AU009S1")            ;Y(es) N(o) menu
                (setq rspnse (getstring "\nDo you want these WINDOW attribute values fixed?  <Yes>: "))
                (if (or (= (strcase (substr rspnse 1 1)) "Y") (= rspnse ""))
                  (progn                              
                     (entdel ent)
                     (setq v:15 v:14 
                           v:14 v:13
                           v:13 v:12
                           v:12 v:11
                           v:11 v:10
                           v:10 v:9
                           v:9  v:8
                           v:8  v:7
                           v:7  v:6
                           v:6  v:5
                           v:5  v:4
                           v:4  0
                           temp v:3
                           v:3  v:2
                           v:2  v:1
                           v:1  temp
                     )
                     (setq ipt (list (+ (car ipt) dxw) (+ (cadr ipt) dyw)))
                     (command "insert" "AUW1DAS" ipt xscal yscal 0)
                     (setq i 1)
                     (repeat 15
                       (command (eval (read (strcat "v:" (itoa i)))))
                       (setq i (1+ i))
                     )
                  )
                  (redraw ent 4)
                )
              )
              (T
              )
            )
          )
       )
; else do automatically
       (progn
          (if once
            (progn
              (textscr)
(prompt "\n \n \n \n \n \n \n                            WARNING")
(prompt "\n \n \nAs explained in the documentation that accompanies this routine,")
(prompt "\nthe routine automatically reorders all attribute tags for")
(prompt "\ndoors, windows, appliances, and room finish that you have")
(prompt "\nselected.  If you select undamaged tags, they may be damaged.")
(prompt "\n \nIf you're not certain that all of these tags need fixing,")
(prompt "\nyou should review them individually before fixing them.")
(prompt "\n \n \n \n \nPress any key to redisplay your drawing.")
(terpri)
(terpri)
(terpri)
(terpri)
(terpri)
(terpri)
                  (setq once nil)
                  (grread)
                  (graphscr)
               )
            )
            (setq rspnse (getstring "\n \n \nAre you sure that you want these tags updated automatically? <Yes>: "))
            (if (or (= (strcase (substr rspnse 1 1)) "Y") (= rspnse ""))
              (progn
                 ;-- dehighlight selection set
                 (setq count 0)
                 (while (setq ent (ssname selset count))
                   (setq ed (entget ent)
                         bname (cdr (assoc 2 ed))
                         count (1+ count)
                   )
                   (if (or (eq bname "AU016T1") (eq bname "AU019T1")
                           (eq bname "AUD1DAS") (eq bname "AUW1DAS")
                           (eq bname "AU018T1")
                       )
                        (redraw ent 4)
                   )
                 )
     ;-- start going through the selection set.
                (setq count 0)
                (while (setq ent (ssname selset count))
                   (setq ed    (entget ent)
                         bname  (cdr (assoc 2 ed))
                         ipt (cdr (assoc 10 ed))
                         xscal (cdr (assoc 41 ed))
                         yscal (cdr (assoc 42 ed))
                         blay (cdr (assoc 8 ed))
                         count (1+ count)
                   )
                 (cond
                   ((eq bname "AU016T1")
                     (command "layer" "s" blay "")
                     (f:ratt)
                     (entdel ent)
                     (setq temp v:8
                           v:8 v:7
                           v:7 temp
                     )
                     (setq ipt (list (+ (car ipt) dxa) (+ (cadr ipt) dya)))
                     (command "insert" "AU016T1" ipt xscal yscal 0)
                     (setq i 1)
                     (repeat 11
                       (command (eval (read (strcat "v:" (itoa i)))))
                       (setq i (1+ i))
                     )
                   ) 
                   ((eq bname "AU018T1")
                     (command "scale" ent "" ipt "1.66667"
                              "move" ent "" ipt
                              (list (+ (car ipt) dxr) (+ (cadr ipt) dyr))
                     )
                   )
                   ((eq bname "AU019T1")
                     (command "layer" "s" blay "")
                     (f:ratt)
                     (entdel ent)
                     (setq temp v:5 
                           v:5 v:1
                           v:1 temp
                           temp v:4
                           v:4 v:2
                           v:2 temp
                     )
                     (command "insert" "AU019T1" ipt (* 1.95 xscal) (* 1.95 yscal) 0)
                     (setq i 1)
                     (repeat 6
                       (command (eval (read (strcat "v:" (itoa i)))))
                       (setq i (1+ i))
                     )
                   )
                   ((eq bname "AUD1DAS")
                     (command "layer" "s" blay "")
                     (f:ratt)
                     (entdel ent)
                     (setq temp v:3
                           v:3 v:2
                           v:2 v:1
                           v:1 temp
                     )
                     (command "insert" "AUD1DAS" ipt xscal yscal 0)
                     (setq i 1)
                     (repeat 18
                       (command (eval (read (strcat "v:" (itoa i)))))
                       (setq i (1+ i))
                     )
                   )
                   ((eq bname "AUW1DAS")
                     (command "layer" "s" blay "")
                     (f:ratt)
                     (entdel ent)
                     (setq v:15 v:14 
                           v:14 v:13
                           v:13 v:12
                           v:12 v:11
                           v:11 v:10
                           v:10 v:9
                           v:9  v:8
                           v:8  v:7
                           v:7  v:6
                           v:6  v:5
                           v:5  v:4
                           v:4  0
                           temp v:3
                           v:3  v:2
                           v:2  v:1
                           v:1  temp
                     )
                     (command "insert" "AUW1DAS" ipt xscal yscal 0)
                     (setq i 1)
                     (repeat 15
                       (command (eval (read (strcat "v:" (itoa i)))))
                       (setq i (1+ i))
                     )
                   )
                   (T
                   )
                 )
              )
            )  
            (progn
                 ;-- dehighlight selection set
                 (setq count 0)
                 (while (setq ent (ssname selset count))
                   (setq ed (entget ent)
                         bname (cdr (assoc 2 ed))
                         count (1+ count)
                   )
                   (if (or (eq bname "AU016T1") (eq bname "AU019T1")
                           (eq bname "AUD1DAS") (eq bname "AUW1DAS")
                           (eq bname "AU018T1")
                       )
                        (redraw ent 4)
                   )
                 )
            )
         )
       )
     )
   )
 )

 (menucmd "S=AU009S1")            ;Y(es) N(o) menu
 (setq rspnse (getstring "\n \n \nDo you want to review other attribute tags in this drawing?  <Yes>: "))
 (if (or (= (strcase (substr rspnse 1 1)) "Y") (= rspnse ""))
   (progn
      (setq loop T)
      (command "undo" "end")
      (command "undo" "mark")
   )
   (setq loop nil)
 )
)

(gc)
(menucmd "S=S")
(f:rlay)
(f:modr)
(prompt "\n \n \nATTFIX completed.")
(princ)

)    ; end of routine

;----------------------------------------------------------------------------;
; FUNCTION NAME :  F:RATT
;                                              
;----------------------------------------------------------------------------;
; REVISION HISTORY
; 
; Ver. 1.0    05/25/88  AXT           
;----------------------------------------------------------------------------;
; FUNCTION ARGUMENTS 
;
;    None.
;----------------------------------------------------------------------------;
; FUNCTION RETURNS
;
;    None.
;----------------------------------------------------------------------------;
; GLOBAL VARIABLES
;
;    None.
;----------------------------------------------------------------------------;
; CALLED FROM
;
;  ATTFIX
;----------------------------------------------------------------------------;
; CALLS
; name      : function
;
;  None
;----------------------------------------------------------------------------;
; OPERATION
;
;  Function to read in attribute values into vi variables
;
;------------------------------ END OF HEADER -------------------------------;

(defun f:ratt ( / )
   (setq i 1
    nent ent
   )
   (while (/= (cdr (assoc 0 (setq ed (entget
              (setq nent (entnext nent)))))) "SEQEND")
      (set (read (strcat "v:" (itoa i))) (cdr (assoc 1 ed)))
      (setq i (1+ i))
   )

)





