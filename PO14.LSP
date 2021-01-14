(defun po( / pl en pts ver mark i mk pln pln1 key epln opt1  ptl
             d1 d2 p1 p2 lastp ud ppts pent z)
  (setvar "cmdecho" 0)
  (setvar "blipmode" 0)
  (command "undo" "c" "all")
  (while (null pl)
    (setq pl (entsel "\nSelect A Polyline: "))
    (if (null pl) (progn (princ "  Nothing Selected.") (exit)))
  )
  (setq en (cdr (assoc 0 (entget (car pl)))))

   (if (or (= "POLYLINE" en) (= "LWPOLYLINE" en) (= "LINE" en) )
      (progn
       (setq pl (car pl) ple (entget pl))
       (setq ocl (cdr (assoc 8 ple)))
       (setq lw (cdr (assoc 40 ple)))
       (if (= lw nil) (setq lw 0))
       (cond ((= "LINE" en)
             (setq z (last (cdr (assoc 10 ple))))
       ))
       (cond ((= "POLYLINE" en)
             (setq ptss (getpl pl))
             (setq z (last (nth 0 ptss)))
       ))
       (cond ((= "LWPOLYLINE" en)
             (setq z (cdr (assoc 38 ple)))
 ;           (command "pedit" pl "f" "x")
       ))

       (princ "Z=")(princ z)(princ " m")
      )

      (progn
        (alert "\n       Entity Select\n\nIsn't \003LINE\003 or \003POLYLINE\003\n " )
        (exit)
      )
   )

   (if (= "LINE" en)(progn
      (command "_.pedit" pl "Y" "x")
      (setq pl (entlast))
   ))

   (setq pts (getpl pl) )
   (if (cdr (assoc 62 (entget pl)))
      (setvar "cecolor" (rtos (cdr (assoc 62 (entget pl))) 2 0))
      (setvar "cecolor" "bylayer")
   )

   (setq ipt (car (getfp pts)) mark (cadr (getfp pts)))
   (dp ipt 11)

  (setq opt T ud 0 )
  (while opt
   (initget "Insert Add Move Next Exit Undo")
   (setq opt (getkword "\nInsert/Add/Next/Move/Undo/Exit/<Exit>:  "))
   (cond
     ( (or (= nil opt)(= opt "Exit"))
        (setq opt nil) (princ)
     )
     ( (= opt "Undo")
      (if (> ud 1)
        (progn
         (command "_.UNDO" "_END")
         (command "_.UNDO" "1")
         (setq ud (- ud 2))
         (dp ipt 0)
         (setq ipt lastp pts ppts pl pent)
         (redraw pl 3)
         (dp ipt 11)
        )
        (progn
         (princ "\tNothing to undo!")
         (setq ud (- ud 1))
        )
      );if
     )

     ( (= opt "Move")
       (setq ud 2 pent pl ppts pts lastp ipt)
       (dp ipt 0)
       (setq ptl (getpl pl) i (1- (length ptl)))
       (dp (nth (1- (length ptl)) ptl) 14)

       (redraw (entlast) 3)
             (princ "\nNext/Skip 10 points/Back 10 points/Previous/pickpoint with mouse/<EXit>")
             (setq mk nil opt1 nil)
             (while (null mk)
               (setq key (grread) )
               (cond
                 ( (or (and (= (car key) 2)(= (cadr key) 110))
                       (and (= (car key) 2)(= (cadr key) 78))
                   )   ; N
                   (dp (nth i ptl) 0)
                   (setq i (1+ i))
                   (if (> i (1- (length ptl))) (setq i (1- (length ptl))))
                   (dp (nth i ptl) 14)
                 )
                 ( (or (and (= (car key) 2)(= (cadr key) 115))
                       (and (= (car key) 2)(= (cadr key) 83))
                   )   ; S
                   (dp (nth i ptl) 0)
                   (setq i (+ i 10))
                   (if (> i (1- (length ptl))) (setq i (1- (length ptl))))
                   (dp (nth i ptl) 14)
                 )
                 ( (or (and (= (car key) 2)(= (cadr key) 112))
                       (and (= (car key) 2)(= (cadr key) 80))
                   )   ; P
                   (dp (nth i ptl) 0)
                   (setq i (1- i))
                   (if (< i 0) (setq i 0))
                   (dp (nth i ptl) 14)
                 )
                 ( (or (and (= (car key) 2)(= (cadr key) 98))
                       (and (= (car key) 2)(= (cadr key) 66))
                   )   ; P
                   (dp (nth i ptl) 0)
                   (setq i (- i 10))
                   (if (< i 0) (setq i 0))
                   (dp (nth i ptl) 14)
                 )
                 ( (or (and (= (car key) 2)(= (cadr key) 101))  ;e
                       (and (= (car key) 2)(= (cadr key) 69))   ;E
                       (and (= (car key) 2)(= (cadr key) 120))  ;x
                       (and (= (car key) 2)(= (cadr key) 88))   ;X
                       (and (= (car key) 2)(= (cadr key) 32)) ;spacebar
                       (and (= (car key) 2)(= (cadr key) 13)) ;return key
                       (= 6 (car key))          ; Exit
                   )   ; E
                      (dp (nth i ptl) 0)
                      (setq pl (entlast))
                      (setq pts (getpl pl))
                      (setq ipt (car (getfp pts)) mark (cadr (getfp pts)))
                      (setq mk T)
                 )
                  (     (= (car key) 3)
                   (dp (nth i ptl) 0)
                   (setq ptl (subst (cadr key) (nth i ptl) ptl))
                   (command "_.erase" (entlast) "")
                   (command "_.pline")(foreach pt ptl (command pt))(command)
                   (redraw (entlast) 3)
                   (dp (nth i ptl) 14)
                 )
               ) ; condition
             );while
       (dp ipt 11)
     )
     ( (= "Add" opt)
      (setq ss T ud 0)
      (while ss
       (setq ss (car (entsel "\nPloyline or Line To Add/Exit/<Exit>:")))
       (if ss
       (progn
       (command "_.change" ss "" "p" "e" z "")
       (setq sse (entget ss) )
       (setq sse (subst (cons 8 ocl) (assoc 8 sse) sse)) (entmod sse)
       (setq lastp ipt ud (+ ud 2) pent pl ppts pts)
       (cond
        ( (= "LINE" (cdr (assoc 0 (entget ss))))
          (setq p1 (cdr (assoc 10 (entget ss)))
                p2 (cdr (assoc 11 (entget ss)))
                d1 (distance p1 ipt)
                d2 (distance p2 ipt)
          ) ;setq
          (cond
             ( (or (= d1 0) (= d2 0)) (command "pedit" pl "j" ss "" "x"))
             ( (> d1 d2)
               (command "line" ipt p2 "")
               (command "pedit" pl "j" ss (entlast) "" "w" lw "x")
             )
             ( (< d1 d2)
               (command "line" ipt p1 "")
               (command "pedit" pl "j" ss (entlast) "" "w" lw "x")
             )
          );cond
          (dp ipt 0)
          (setq pl (entlast))(setq pts (getpl pl))
          (setq ipt (car (getfp pts)) mark (cadr (getfp pts)))
          (dp ipt 11)
        )
        ( (= "POLYLINE" (cdr (assoc 0 (entget ss))))
          (setq ptss (getpl ss) p1 (nth 0 ptss)
                  p2 (nth (1- (length ptss)) ptss)
                  d1 (distance p1 ipt)
                  d2 (distance p2 ipt)
          );setq
          (cond
             ( (or (= d1 0) (= d2 0)) (command "pedit" pl "j" ss "" "x"))
             ( (> d1 d2)
               (command "line" ipt p2 "")
               (command "pedit" pl "j" ss (entlast) "" "w" lw "x")
             )
             ( (< d1 d2)
               (command "line" ipt p1 "")
               (command "pedit" pl "j" ss (entlast) "" "w" lw "x")
             )
          );cond
          (dp ipt 0)
          (setq pl (entlast))(setq pts (getpl pl))
          (setq ipt (car (getfp pts)) mark (cadr (getfp pts)))
          (dp ipt 11)
        )

        ( (= "LWPOLYLINE" (cdr (assoc 0 (entget ss))))
          (setq ptss (getpl ss) p1 (nth 0 ptss)
                  p2 (nth (1- (length ptss)) ptss)
                  d1 (distance p1 ipt)
                  d2 (distance p2 ipt)

          );setq
          (cond
             ( (or (= d1 0) (= d2 0)) (command "pedit" pl "j" ss "" "x"))
             ( (> d1 d2)
               (command "line" ipt p2 "")
               (command "pedit" pl "j" ss (entlast) "" "w" lw "x")
             )
             ( (< d1 d2)
               (command "line" ipt p1 "")
               (command "pedit" pl "j" ss (entlast) "" "w" lw "x")
             )
          );cond
          (dp ipt 0)
          (setq pl (entlast))(setq pts (getpl pl))
          (setq ipt (car (getfp pts)) mark (cadr (getfp pts)))
          (dp ipt 11)
        )

        (T (princ "\tERROR! Not a Ployline or Line."))
        );progn
       );condition
      );if
     );while
     (command)
     )

     ( (= "Insert" opt)
       (setq pt T i 0 ud 2)
       (command "Pline" ipt)
       (while pt
         (if (= i 0)
           (setq pt (getpoint ipt "\nNext Point/Exit/<Exit>:"))
           (setq pt (getpoint pt  "\nNext Point/Exit/<Exit>:"))
         )
         (command pt)
         (setq i (1+ i) )
       );while
       (command)
          (dp ipt 0)
          (if (>= i 1)
            (progn
              (setq lastp ipt ppts pts pent pl)
              (command "pedit" pl "j" (entlast) "" "X")
              (setq pl (entlast))
            )
          );if
          (setq pts (getpl pl))
          (setq ipt (car (getfp pts)) mark (cadr (getfp pts)))
          (dp ipt 11)
     )

     ( (= "Next" opt)
       (dp ipt 0)
       (if (= 0 mark) (setq mark (1- (length pts))) (setq mark 0))
       (setq ipt (nth mark pts))
       (dp ipt 11)
     )
   );condition
  );while
  (REDRAW PL 4)(DP IPT 0)
  (princ)
)
(defun dp(pt kk / vs)
  (setq vs (* 0.035 (getvar "viewsize")))
  (grdraw (polar pt (* pi 0.25) vs) (polar pt (* pi -0.75) vs) kk)
  (grdraw (polar pt (* pi 0.75) vs) (polar pt (* pi -0.25) vs) kk)
)

(defun getpl (pl / mark pts ver i ee)
 (redraw pl 3)
 (if (= "POLYLINE" (cdr(assoc 0 (entget pl))))
  (progn ;read points of ployline
   (setq mark "VERTEX" i 0 ver (entnext pl) )
   (while (= "VERTEX" mark)
      (setq pts (append pts (list (cdr (assoc 10 (entget ver))))))
      (setq ver (entnext ver) i (1+ i))
      (setq mark (cdr (assoc 0 (entget ver))))
   )
  )
      (progn ;read points of lwployline
         (setq ee (entget pl))
         (foreach pt ee
             (if (= 10 (car pt))
                 (setq pts (append pts (list
                           (append (cdr pt) (list (cdr (assoc 38 ee)))))))
             )
         )
      );progn
 );if
         (setq pts pts)
)

(defun getfp(pts / fp mk vc vh p p1 p2)
   (setq vc (getvar "viewctr")
         vh (/ (getvar "viewsize") 2.0)
         p1 (nth 0 pts)
         p2 (nth (1- (length pts)) pts)
   )
   (if (> (distance p1 vc) (distance p2 vc))
       (setq fp p2 mk (nth (1- (length pts)) pts))
       (setq fp p1 mk 0)
   )
   (setq p (list fp mk))
)

(defun c:qe()
  (defun *ERROR* (s)
     (terpri)(princ "Error = ")(princ s)
     (princ)
  )
  (po)
)

(princ "\n\tQEdit a tour line Loaded.")
(princ "\n\tStart With command QE")
(princ)
