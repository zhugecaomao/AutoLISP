(defun c:zz( / ent p pt el key ed de pt1 pt2)
   (setvar "cmdecho" 0)
   (setq os (getvar "osmode"))
   (setvar "osmode" 512)

   (graphscr)
   (princ "\n点选第一根地形线:")
   (while (null p) (setq p (entsel)))
   (setq pt (car (cdr p)) ent (car p)) 

   (initget 7)
   (setq el (getint "\n本根地形线的高程值: "))
   (initget 7)
   (setq de (getint "\n等高距："))
   (command "_.CHANGE" ent "" "p" "e" el "")

   (dp pt 11)
   (command "line" pt)
   (setq ed de)

   (while pt
      (prompt "\n +升高 / -降低 / =不变 / p视窗平移 / 选择实体: ")
      (setq key (grread))
      (cond
        ( (or (= 6 (car key))                           ;mouse right button
              (and (= 2 (car key)) (= 13 (cadr key)))   ;enter key
              (and (= 2 (car key)) (= 32 (cadr key)))   ;spacebar key
          )
            (command)
            (dp pt 0)
            (setq pt nil)
        ); cond 1
        (  (and (= 2 (car key)) (= 43 (cadr key)))       ; + key
           (setq ed de)
           (princ "\n高程升高")
        ) ; cond 2

        ( (and (= 2 (car key)) (or (= 112 (cadr key))(= 80 (cadr key)))); "P" key
           (setvar "osmode" 0)
           (setq pt1 (getpoint "First point: "))
           (setq pt2 (getpoint pt1 "To point: "))
           (command)
           (command "'pan" pt1 pt2)
           (command "line" pt)
           (setvar "osmode" 512)
        ) ; cond  pan

        (  (or (and (= 2 (car key)) (= 45 (cadr key)))   ; - key
               (and (= 2 (car key)) (= 95 (cadr key))))  ; _ key
           (setq ed (- de))
           (princ "\n高程降低")
        ) ; cond 3

        (  (and (= 2 (car key)) (= 61 (cadr key)))       ; = key
           (setq ed 0)
           (princ "\n高程不变")
        ) ; cond 4

        (  (= 3 (car key))                               ; Pick Entity
           (command)
           (dp pt 0)
           (setq p (nentselp (cadr key)))

           (if p (progn
             (setq ent (car p) pt (cadr key))
             (setq el (+ el ed))
             (princ "El=")(princ el)(terpri)

             (command "_.change" ent "" "p" "e" el "")
             (command "_.text" "J" "MC" pt 1.25 0 (rtos el 2 0))
           ))
           (command "line" pt)
           (dp pt 11)
        ) ; cond 5
        (T (princ "Incorrect key"))
      );condition
   );while
   (setvar "osmode" os)
)
(defun dp(pt kk / vs)
  (setq vs (* 0.035 (getvar "viewsize")))
  (grdraw (polar pt (* pi 0.25) vs) (polar pt (* pi -0.75) vs) kk)
  (grdraw (polar pt (* pi 0.75) vs) (polar pt (* pi -0.25) vs) kk)
)
