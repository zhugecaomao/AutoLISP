;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                CV(COPYM) 超级多重复制   CCLISP程序                ;;
;;;                By    二００五年九月                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:cv ( / ss p1 cmd snaptp ucshold )
 (acet-error-init 
   (list (list  "cmdecho" 0 
               "snaptype" 0
               "snapmode" nil
               "gridmode" nil
               "snapunit" nil
               "gridunit" nil
         );list
         0
         '(progn
            (acet-sysvar-set (list "cmdecho" 0))
            (if ss 
                (acet-ss-redraw ss 4)
            )
            (if ucshold
                (acet-ucs-set ucshold)
            )
            (acet-sysvar-restore)
            (princ)
          );progn
   );list
 );acet-error-init
 (setq ucshold (acet-ucs-get nil))
 (if (setq ss (ssget)) 
     (progn
      (acet-ss-redraw ss 3)
      (setq p1 (getpoint "\基点: "))
      (acet-ss-redraw ss 4)
      (if p1
          (acet-copym ss p1)
      );if
     );progn then
 );if
 (acet-error-restore)
);defun c:copym
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun acet-copym ( ss p1 / na p2 n d lst j p3 )
 (setq p2 T)
 (setq n 0)
 (while p2
  (setq na (entlast))
  (if (not lst)
      (setq lst (list (list ss p1)))
  );if
  (setvar "lastpoint" p1)
  (acet-ss-redraw ss 3)
  (initget 128 "Repeat Divide Measure Array Undo eXit")
  (setq p2 (acet-ss-drag-move 
            ss
            p1 
            "\n第二点或 \n[重复(R)/定数分开(D)/定距等分(M)/阵列(A)/撤消(U)] <退出>: "
            nil
           );acet-ss-drag-move 
  );setq
  (acet-ss-redraw ss 4)
  (if (= p2 "eXit")
      (setq p2 nil)
  );if
  (cond
   ((= p2 "Undo")
    (if (= n 0)
        (princ "\n没有撤消。")
        (progn
         (command "_.undo" "1")
         (setq   n (- n 1)
               lst (cdr lst)
                ss (car lst)
                p1 (cadr ss)
                ss (car ss)
         );setq
        );progn else
    );if
   );cond #1
   ((= p2 "Repeat")
    (if (= n 0)
        (princ "\n没有重复。")
        (progn
         (setq p2 (cadr (car lst))
               p1 (cadr (cadr lst))
                d (list (- (car p2) (car p1))
                        (- (cadr p2) (cadr p1))
                        (- (caddr p2) (caddr p1))
                  );list
         );setq
         (command "_.copy" ss "" d "")
         (setq   n (+ n 1)
                ss (acet-ss-new na)
                p1 (list (+ (car p2) (car d))
                         (+ (cadr p2) (cadr d))
                         (+ (caddr p2) (caddr d))
                   );list
               lst (cons (list ss p1) lst)
         );setq
        );progn else
    );if
   );cond #2
   ((equal 'LIST (type p2))
    (command "_.copy" ss "" p1 p2)
    (setq   n (+ n 1)
           ss (acet-ss-new na)
           p1 p2
          lst (cons (list ss p1) lst)
    );setq
   );cond #3
   ((and (= "Divide" p2)
         (setq p3 (getpoint p1 "\n选择定数分开的端点: "))
         (progn
          (initget 6)
          (setq j (getint "\n复制数: "))
         );progn
    );and
    (setq  ss (acet-copym-divide ss p1 p3 j)
           p1 p3
          lst (cons (list ss p1) lst)
            n (+ n 1)
    );setq
   );cond #4
   ((and (= "Measure" p2)
         (setq p3 (getpoint p1 "\n选择定距等分的端点: "))
         (progn
          (initget 6)
          (setq d (getdist "\n复制之间的距离: "))
         );progn
    );and
    (setq  ss (acet-copym-measure ss p1 p3 d) ;returns selset and base point
           p1 (cadr ss)
           ss (car ss)
          lst (cons (list ss p1) lst)
            n (+ n 1)
    );setq
   );cond #5
   ((= "Array" p2)
    (setq  ss (acet-copym-array ss p1)
           p1 (cadr ss)
           ss (car ss)
          lst (cons (list ss p1) lst)
            n (+ n 1)
    );setq
   );cond #6
   (p2
    (princ "\n无效的输入。")
   );cond #7
  );cond close
 );while
 
);defun acet-copym
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun acet-copym-array ( ss p1 / a )
 (initget "Pick Measure Divide")
 (setq a (getkword "\n选取-动态(P)/定距等分(M)/定数等分(D) <选取>: "))
 (cond
  ((or (not a)
       (= a "Pick")
   );or
   (setq a (acet-copym-array-dynamic ss p1))
  );cond #1
  ((= a "Measure")
   (setq a (acet-copym-array-measure ss p1))
  );cond #2
  ((= a "Divide")
   (setq a (acet-copym-array-divide ss p1))
  );cond #3
 );cond close
 a
);defun acet-copym-array
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun acet-copym-array-dynamic ( ss p1 / snap grid snapu gridu p2 p3 p4 dx dy lst ss2 na a )
 
 (acet-undo-begin)
 (setq p2 (getangle p1 "\n指定角度 <0>: "))
 (if p2
     (setq p2 (polar p1 p2 1.0)) ;convert angle to a point
     (setq p2 (polar p1 0.0 1.0));use default of 0 and convert to point
 );if
 (setq p3 (polar p1 (+ (angle p1 p2) (/ pi 2.0)) 1.0)
       p1 (trans p1 1 0)
       p2 (trans p2 1 0)
       p3 (trans p3 1 0)
 );setq
 (acet-ucs-cmd (list "_3p" (trans p1 0 1) (trans p2 0 1) (trans p3 0 1)))
 (setq p1 (trans p1 0 1)
       p2 (trans p2 0 1)  
       p3 (trans p3 0 1)  
 );setq
 
 (setq  p2 (acet-copym-getcorner p1 "\n选取角点以得到列和行距离: " T)
        dx (- (car p2) (car p1))
        dy (- (cadr p2) (cadr p1))
       lst (list p1)
        p4 T
 );setq 
 (acet-sysvar-set
  (list
    "snapunit" (list (abs dx) (abs dy))
    "gridunit" (list (abs dx) (abs dy))
    "snapmode" 1
    "gridmode" 1
  )
 );acet-sysvar-set
 
 (while p4
  (setvar "snapmode" 1)
  (setvar "gridmode" 1)
  ;(setq p4 (getpoint p1 "\n选取阵列的元素位置或按<回车>键完成: "))
  (setq p4 (acet-ss-drag-move 
             ss
             p1
             "\n选取阵列的元素位置或按<回车>键完成: "
             nil
            );acet-ss-drag-move 
  );setq
  (cond
   ((not p4) T);cond #1
   ((member p4 lst)
    (princ "\n*invalid* 您已经选取了此点!")
   );cond #2
   (T
    (setq  na (entlast)
          lst (cons p4 lst)
    );setq
    (command "_.copy" ss "" p1 p4)
   );cond #3
  );cond close
 );while
 (if na 
     (setq  p1 (trans (getvar "lastpoint") 1 0)
           ss2 (acet-ss-new na)
     );setq
     (setq ss2 ss);setq else
 );if
 (acet-ucs-cmd (list"_prev"))
 (setq p1 (trans p1 0 1))
 
 (acet-sysvar-restore)
 (acet-undo-end)
 
 (list ss2 p1)
);defun acet-copym-array-dynamic
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun acet-copym-getcorner ( p1 msg nozero / flag p2 na )
 (while (not flag)
  (setq na (entlast))
  (command "_.rectang" p1)
  (while (wcmatch (getvar "cmdnames") "*RECTANG*") 
   (princ msg)
   (command pause)
  );while
  (setq p2 (getvar "lastpoint"));setq
  (if (not (equal na (entlast)))
      (entdel (entlast))
  );if
  (cond
   ((not nozero)
    (setq flag T)
   );cond #1
   ((and (equal (car p1) (car p2) 0.00000001)
         (equal (cadr p1) (cadr p2) 0.00000001)
    );and
    (princ "\n*Points cannot be equal*")
   );cond #2
   ((= (car p1) (car p2))
    (princ "\n*X 座标不能相等*")
   );cond #3
   ((= (cadr p1) (cadr p2))
    (princ "\n*Y 座标不能相等*")
   );cond #4
   (T
    (setq flag T)
   );cond #5
  );cond close
 );while
 p2
);defun acet-copym-getcorner
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun acet-copym-array-measure ( ss p1 / snap grid snapu gridu p2 p3 p4 dx dy 
                                     ss2 na a n j k m x y
                           )
 (acet-undo-begin)
 
 (setq p2 (getangle p1 "\n指定角度 <0>: "))
 (if p2
     (setq p2 (polar p1 p2 1.0)) ;convert angle to a point
     (setq p2 (polar p1 0.0 1.0));use default of 0 and convert to point
 );if
 (setq p3 (polar p1 (+ (angle p1 p2) (/ pi 2.0)) 1.0)
       p1 (trans p1 1 0)
       p2 (trans p2 1 0)
       p3 (trans p3 1 0)
 );setq
 (acet-ucs-cmd (list "_3p" (trans p1 0 1) (trans p2 0 1) (trans p3 0 1)))
 
 (setq  p1 (trans p1 0 1)
        p2 (acet-copym-getcorner p1 "\n选取角点以得到行和列距离: " T)
        dx (- (car p2) (car p1))
        dy (- (cadr p2) (cadr p1))
        p4 T
 );setq 
 (acet-sysvar-set
  (list
    "snapunit" (list (abs dx) (abs dy))
    "gridunit" (list (abs dx) (abs dy))
    "snapmode" 1
    "gridmode" 1
  )
 );acet-sysvar-set
 
 (setq p2 (acet-copym-getcorner p1 "\n阵列填充另一角: " T))
 (if (> (car p2) (car p1))
     (setq dx (abs dx))
     (setq dx (* -1.0 (abs dx)))
 );if
 (if (> (cadr p2) (cadr p1))
     (setq dy (abs dy))
     (setq dy (* -1.0 (abs dy)))
 );if
 (setq k (/ (abs (- (car p2) (car p1)))
            (abs dx)
         )
       m (/ (abs (- (cadr p2) (cadr p1)))
            (abs dy)
         )
       k (+ 1 (atoi (rtos k 2 0)))
       m (+ 1 (atoi (rtos m 2 0)))
 );setq
 
 (setq n 0)
 (repeat m	;; rows
  (setq y (+ (cadr p1) (* dy n)))
 
  (setq j 0)
  (repeat k	;; columns
   (setq x (+ (car p1) (* dx j)))
   (setq na (entlast))
   (if (not (and (= n 0)
                 (= j 0)
            );and
       );not
       (command "_.copy" ss "" p1 (list x y (caddr p1)))
   );if
   (setq j (+ j 1));setq
  );repeat
 
 (setq n (+ n 1))
 );repeat
 (if na
     (setq  p1 (trans (getvar "lastpoint") 1 0)
           ss2 (acet-ss-new na)
     );setq
     (setq ss2 ss);setq else
 );if
 (acet-ucs-cmd (list "_prev"))
 (setq p1 (trans p1 0 1))
 
 (acet-sysvar-restore)
 (acet-undo-end)
 
 (list ss2 p1)
);defun acet-copym-array-measure
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun acet-copym-array-divide ( ss p1 / p2 dx dy ss2 na a n j k m x y p3 )
 (acet-undo-begin)
 
 (setq p2 (getangle p1 "\n指定角度 <0>: "))
 (if p2
     (setq p2 (polar p1 p2 1.0)) ;convert angle to a point
     (setq p2 (polar p1 0.0 1.0));use default of 0 and convert to point
 );if
 (setq p3 (polar p1 (+ (angle p1 p2) (/ pi 2.0)) 1.0)
       p1 (trans p1 1 0)
       p2 (trans p2 1 0)
       p3 (trans p3 1 0)
 );setq
 (acet-ucs-cmd (list "_3p" (trans p1 0 1) (trans p2 0 1) (trans p3 0 1)))
 
 (setq p1 (trans p1 0 1)
       p2 (acet-copym-getcorner p1 "\n阵列填充另一角: " nil)
 );setq
 
 (initget 6)
 (setq k (getint "\n输入列数: "))
 (initget 6)
 (setq m (getint "\n输入行数: "))
 (setq dx (/ (- (car p2) (car p1)) k)
       dy (/ (- (cadr p2) (cadr p1)) m)
 );setq
 
 (setq n 0)
 (repeat m	;; rows
  (setq y (+ (cadr p1) (* dy n)))
 
  (setq j 0)
  (repeat k	;; columns
   (setq x (+ (car p1) (* dx j)))
   (setq na (entlast))
   (if (not (and (= n 0)
                 (= j 0)
            );and
       );not
       (command "_.copy" ss "" p1 (list x y (caddr p1)))
   );if
   (setq j (+ j 1));setq
  );repeat
 
 (setq n (+ n 1))
 );repeat
 (if na
     (setq  p1 (trans (getvar "lastpoint") 1 0)
           ss2 (acet-ss-new na)
     );setq
     (setq ss2 ss);setq else
 );if
 (acet-ucs-cmd (list "_prev"))
 (setq p1 (trans p1 0 1))
 
 (acet-undo-end)
 
 (list ss2 p1)
);defun acet-copym-array-divide
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Takes a selection set, two points and the distance between 
;consecutive copies.
;Returns a list containing a selection set the most 
;recent copy and a base point.
;
(defun acet-copym-measure ( ss p1 p3 d / j n na p2 )
 
 (acet-undo-begin)
 (setq j (fix (/ (distance p1 p3) d))
       n 1
 );setq
 (repeat j
 (setq p2 (polar p1 (angle p1 p3) (* d n))
       na (entlast)
 );setq
 (command "_.copy" ss "" p1 p2)
 (if (= n j)
     (setq ss (acet-ss-new na))
 );if
 (setq n (+ n 1))
 );repeat 
 (acet-undo-end)
 (list ss p2)
);defun acet-copym-measure
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;takes a selection set, two points and the number of copies to 
;make of the selection between the two points.
;returns a selection set the most recent copy
;
(defun acet-copym-divide ( ss p1 p3 j / d n na p2 )
 
 (acet-undo-begin)
 (setq d (/ (distance p1 p3) j)
       n 1
 );setq
 (repeat j
 (setq p2 (polar p1 (angle p1 p3) (* d n))
       na (entlast)
 );setq
 (command "_.copy" ss "" p1 p2)
 (if (= n j)
     (setq ss (acet-ss-new na))
 );if
 (setq n (+ n 1))
 );repeat 
 (acet-undo-end)
 ss
);defun acet-copym-divide


(princ)
