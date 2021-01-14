(defun c:pm1(); / i j k secpl pt1 pt2 pt3 pt4 pts points ipt ipts iptn lines slines
;                z mark pj stp edp pt leth pta zz)

(command)

  (defun *error* (s)                   ; If an error (such as CTRL-C) occurs
   (if (/= s "Function cancelled")
    (if (= s "quit / exit abort")
     (princ)
    (princ (strcat "\nError: " s))
    )
   )
  (princ)
  );defun error
(setq os (getvar "osmode"))(setvar "osmode" 0)
(Setvar "cmdecho" 1)(setvar "blipmode" 0)(setvar "regenmode" 1)
(prompt "\n点选剖面中心线(中心线必须是多义线):")
  (setq secpl (car (entsel)))

  (if (or (= "POLYLINE" (cdr (assoc 0 (entget secpl))))
          (= "LWPOLYLINE" (cdr (assoc 0 (entget secpl))))
       )   
      ()
      (progn (print "中心线不是多义线，程序退出。")(exit))
  )
  (command "_.change" secpl "" "P" "e" 0 "")
  (setq pts (getpl secpl))

;  (print pts)(grread)
  (if (< (cadr (car pts)) (cadr (last pts)))
      (setq pts (reverse pts))
  )
;  (print pts)

  (setq lines (ssget "F" pts))
  (if (ssmemb secpl lines) (setq lines (ssdel secpl lines)))

  (setq slines (ssadd) i 0 mark T k 0)
  (while (< i (sslength lines))
    (if (= "LINE" (cdr (assoc 0 (entget (ssname lines i)))))(progn
        (if (= 0 (caddr (cdr (assoc 10 (entget (ssname lines i))))))
          (progn
             (princ "\n有 0 高程线，这些线被改为 0 层和 200 号颜色。程序停止执行。")
             (command "change" (ssname lines i) "" "p" "layer" 0 "color" 200 "")
             (setq mark nil k (1+ k))
          )
        )
        (setq slines (ssadd (ssname lines i) slines))
    ))
    (setq i (1+ i))
  );end while
  (if (not mark) (exit))

  (setq i 0 j 0 ipts '() )
  (while (< i (sslength slines))
     (setq pt1 (cdr (assoc 10 (entget (ssname slines i))))
           pt2 (cdr (assoc 11 (entget (ssname slines i))))
             z (caddr pt1)
           pt1 (list (car pt1) (cadr pt1))
           pt2 (list (car pt2) (cadr pt2))
     )
     (setq mark T j 0)
     (while (and (< j (- (length pts) 1)) mark)
           (setq pt3 (nth j pts) pt4 (nth (1+ j) pts))
           pt3 (list (car pt3) (cadr pt3))
           pt4 (list (car pt4) (cadr pt4)) 
           (setq ipt (inters pt1 pt2 pt3 pt4 T))
;           (princ pt1)(princ pt2)(princ pt3)(princ pt4)(princ z)
;           (grdraw pt1 pt2 4)(grdraw pt3 pt4 5)
           (if ipt (progn
               (setq mark nil)
;               (command "point" ipt)
               (setq ipts (append ipts (list (append ipt (list z j)))))
           ))
;           (grdraw pt1 pt2 7)(grdraw pt3 pt4 7)
           (setq j (1+ j))
     );while
     (setq i (1+ i))
  );end while

;(print (length ipts))(print ipts)
;(print (length pts)) (print pts)

  (setq i 0 j 0 points '())
  (while (< i (length pts))
       (setq j 0 iptn '())
       (while (< j (length ipts))
           (setq pj (nth j ipts))
           (if (= i (nth 3 pj))
              (setq iptn (append iptn (list (list (car pj)(cadr pj)(caddr pj)))))
           )
           (setq j (1+ j))
       );while
;       (terpri)(princ "Number of points=")(princ (length iptn))
;       (terpri)(princ "Before Sorted:")(princ iptn)(princ (nth i pts))
       (setq iptn (sortlength iptn (nth i pts))
           points (append points (list (nth i pts)) iptn)
       )
;       (terpri)(princ "After Sorted:")(princ iptn)
       (setq i (1+ i))
  );while
  (setq points (append points (list (nth (1- (length pts)) pts))))
;  (print (length points))

  (setq i 0 mark T)
  (while (and mark (< i (length points)))     ;search for elevation of points 1
         (if (/= 0.0 (caddr (nth i points)))
             (setq z (caddr (nth i points)) mark nil)
         )
         (setq i (1+ i))
  )

;(princ points)
  (terpri)(princ "Plotting the Section PolyLine...")
  (setq i 1 leth 0 pta (list (list 0 z)))
  (while (< i (length points))
     (setq leth (+ leth (distance (3to2 (nth i points)) (3to2 (nth (1- i) points))))
             pt (nth i points)
     )
     (if (= 0.0 (caddr pt))
      (progn
         (setq pta (append pta (list (list leth (cadr (last pta))))))
         (command "_.line" (polar (last pta) (/ pi 2) 100.0) (polar (last pta) (/ pi -2) 100.0) "")
      )
      (setq pta (append pta (list (list leth (caddr pt)))))
     );if
     (setq i (1+ i))
  );while

  (setq stp (car pta) edp (last pta) zz '())
  (command "_.zoom" "c" (list (/ (+ (car stp)(car edp)) 2)(/ (+ (cadr stp)(cadr edp)) 2))
                        (/ (distance stp edp) 1.5))

; (print pta)(grread)
  (SETQ PTT PTA)
  (command "_.pline")
  (foreach pt pta
     (command pt)
     (setq zz (append zz (list (cadr pt))))
  )
  (command)
  (setq zmax (apply 'max zz) zmin (apply 'min zz) i zmin)
  (command "line" (list -20 zmin) (list -20 zmax) "")
  (repeat (fix (+ (/ (- zmax zmin) 50) 1))
      (command "line" (list -30 i) (list -20 i) "")
      (command "text" "j" "mr" (list -20 i) 10 0 (rtos i 2 0))
      (setq i (+ 50 i))
  );repeat
  (setvar "osmode" os)
)

(defun 3to2 (pts / p)
     (setq p (list (car pts) (cadr pts)))
)
 
(defun getpl (pl / mark pts ver i pt vern)
;   (redraw pl 3)
   (terpri)(princ "读取多义线顶点...")
   (setq vern (read (substr (getvar "ACADVER") 1 2)))
   (if (<= vern 13)(progn
      (setq mark "VERTEX" i 0 ver (entnext pl) )
      (while (= "VERTEX" mark)
         (setq pts (append pts (list (cdr (assoc 10 (entget ver))))))
         (setq ver (entnext ver) i (1+ i))
         (setq mark (cdr (assoc 0 (entget ver))))
      ))
      (progn
         (setq ver (entget pl))
         (foreach pt ver
             (if (= 10 (car pt))
                 (setq pts (append pts (list (append (cdr pt) (list 0.0)))))
             )
         )
         (print pts)(grread)
      );progn
   );if
   (princ "读点完成.")(terpri)
   (setq pts pts)
)

(defun sortlength(pots stp / i j p1 p2 x1 x2 temp)
    (terpri)(princ "正在根据长度排序...")
    (setq i 0)
    (while (<= i (1- (length pots)))
       (setq j (1+ i))
       (while (<= j (1- (length pots)))
          (setq x2 (distance stp (list (car (nth i pots)) (cadr (nth i pots)))))
          (setq x1 (distance stp (list (car (nth j pots)) (cadr (nth j pots)))))
;          (grread)(princ "Di=")(princ x2)(princ "Dj=")(princ x1)

          (if (> x2 x1)(progn
;          (princ "SWAP")
              (setq p1 (nth i pots)
                    p2 (nth j pots)
                    pots (subst "SWAP1" p1 pots)
                    pots (subst "SWAP2" p2 pots)
                    pots (subst p1 "SWAP2"  pots)
                    pots (subst p2 "SWAP1"  pots)
                      x2 (car (nth j pots))
                      x1 (car (nth i pots))
              );setq
          ));if
          (setq j (1+ j))
       );while
       (setq i (1+ i))
    );while
    (princ "排序完成.")
    (setq pots pots)
)

