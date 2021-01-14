;;去除表中指定索引处的表项
(defun cutnum_lst (oldlst num / k templst)
  (setq	k 0
	templst	'()
  )
  (foreach n oldlst
    (if	(/= k num)
      (setq templst (cons n templst)
	    k	    (1+ k)
      )
    )
    (setq k (1+ k))
  )
  (setq newlst (reverse templst))
)
;;去除表中指定项
(defun drop (lst item)
  (append (reverse (cdr (member item (reverse lst))))
	  (cdr (member item lst))
  )
)
;;将点表中在方框内的点组成新表
(defun pt_inm (oldlst PT1 PT2 PT3 PT4 /	oldlist	n pt1 pt2 pt3 pt4
	       templst newlst)
  (setq templst '())
  (foreach n oldlst
    (if	(/= (point_inm n pt1 pt2 pt3 pt4) nil)
      (setq templst (cons n templst))
    )
  )
  (setq newlst (reverse templst))
)
;;将点表中在多边形内的点组成新表
(defun pt_inmx (oldlst pm)
  (setq templst '())
  (foreach n oldlst
    (if	(ea:point_inm n pm)
      (setq templst (cons n templst))
    )
  )
  (setq newlst (reverse templst))
)
;;判断两点是否等
(defun eq_point	(pt1 pt2)
  (if (and (equal (car pt1) (car pt2) 1e-5)
	   (equal (cadr pt1) (cadr pt2) 1e-5)
      )
    t
    nil
  )
)
;;判断两直线是否相交
(defun line_int	(se1 se2)
  (if (/= (inters (cdr (assoc 10 (entget se1)))
		  (cdr (assoc 11 (entget se1)))
		  (cdr (assoc 10 (entget se2)))
		  (cdr (assoc 11 (entget se2)))
		  t
	  )
	  nil
      )
    t
    nil
  )
)
;;点到直线的垂直距离
(defun point_line (pt pt1 pt2 / ptangle ptn pt pt1 pt2 dist jptx)
  (setq	ptangle	(angle pt1 pt2)
	ptn	(polar pt (+ (* 0.5 pi) ptangle) 0.01)
	jptx	(inters pt ptn pt1 pt2 nil)
	dist	(distance pt jptx)
  )
  dist
)
;;判断点是否在方框内
(defun point_inm (pt pt1 pt2 pt3 pt4 / dist1 dist2 dist3 dist4 pt pt1
		  pt2 pr3 pt4)
  (setq	dist1 (point_line pt pt1 pt2)
	dist2 (point_line pt pt2 pt3)
	dist3 (point_line pt pt1 pt4)
	dist4 (point_line pt pt3 pt4)
  )
  (if (equal (+ dist1 dist2 dist3 dist4)
	     (+ (distance pt1 pt2) (distance pt2 pt3))
	     1e-10
      )
    t
    nil
  )
)
;;测试点是否在多边形内.
(defun ea:point_inm
       (p pm / point_x mx px1 pm edge_int_num pt_online_num)
  (setq	point_x	(mapcar '(lambda (x) (car x)) pm)
	mx	(abs (- (apply 'max point_x) (car p)))
	px1	(polar p 0 (* mx 2))
  )
  (setq	pm	      (append pm (list (nth 0 pm)))
	edge_int_num  0
	pt_online_num 0
  )
  (while (> (length pm) 1)
    (setq pc (nth 0 pm)
	  pn (nth 1 pm)
    )
    (if	(inters p px1 pc pn)
      (setq edge_int_num (+ 1 edge_int_num))
    )
    (if	(equal (angle p pc) 0 1e-5)
      (setq pt_online_num (+ 1 pt_online_num))
    )
    (if	(and (equal (angle p pc) 0 1e-5)
	     (equal (angle p pn) 0 1e-5)
	)
      (setq pt_online_num (- pt_online_num 1))
    )
    (setq pm (cdr pm))
    (if	(= (rem (+ pt_online_num edge_int_num) 2) 1)
      t
      nil
    )
  )
)
;;清理表中的重复项
(defun purge_lst (lst / n m lst1 tmplist)
  (setq	tmplist	'()
	tmplist	(cons (car lst) tmplist)
	lsttmp	(cutnum_lst lst 0)
  )
  (setq	n (length lsttmp)
	m 0
  )
  (while (/= m n)
    (setq id   '()
	  lst1 (nth m lsttmp)
    )
    (foreach na	tmplist
      (if (= (eq_point na lst1) nil)
	(setq id (cons 0 id))
	(setq id (cons 1 id))
      )
    )
    (if	(= (member '1 id) nil)
      (setq tmplist (cons lst1 tmplist))
    )
    (setq m (1+ m))
  )
  (setq tmplist (reverse tmplist))
)
;;计算两点的中点
(defun mpt (mpt1 mpt2)
  (polar mpt1 (angle mpt1 mpt2) (/ (distance mpt1 mpt2) 2))
)

(defun se_426 (pt)
  (setq	sex1	   (ssname (ssget "c" pt pt) 0)
	sex1ent	   (entget sex1)
	sex1name   (cdr (assoc -1 sex1ent))
	sex1pt1	   (cdr (assoc 10 sex1ent))
	sex1pt2	   (cdr (assoc 11 sex1ent))
	newse	   (drop selist sex1name)
	newsen	   (length newse)
	newsem	   0
	newjptlist '()
  )
  (while (/= newsem newsen)
    (setq newse1   (nth newsem newse)
	  newsept1 (cdr (assoc 10 (entget newse1)))
	  newsept2 (cdr (assoc 11 (entget newse1)))
    )
    (if
      (setq newjpt1 (inters sex1pt1 sex1pt2 newsept1 newsept2))
       (setq newjptlist (cons newjpt1 newjptlist))
    )
    (setq newsem (1+ newsem))
  )
  (setq	newjptx	(car newjptlist)
	newjpty	(cadr newjptlist)
  )
  (if (> (distance newjptx pt) (distance newjpty pt))
    (setq newjpt newjptx)
    (setq newjpt newjpty)
  )
  (command "break" sex1 newjpt pt)
)
(defun se_123 (lst)
  (setq se1 lst)
  (setq	dptx (cdr (assoc 10 (entget se1)))
	dpty (cdr (assoc 11 (entget se1)))
  )
  (if (or (equal dptlist (list dptx dpty))
	  (equal dptlist (list dpty dptx))
      )
    (command "erase" se1 "")
  )
)
;;;
;;; 主程序
;;;
(defun c:ttr (/	      pta     ptb     ptax    ptay    ptbx    ptby
	      ptaxby  ptbxay  ptbox   se      n	      m	      nn
	      mm      nnn     mmm     ptlist  ptl     lse     sename
	      pt1     pt2     pt3     pt4     ptlist1 n1      m1
	      ptl     tmplist templist	      na      nb      nab
	      ptl3    ptl4    jpt1    jpt2    jpt3    jpt4    se1
	      jptx    jpty    dptx    dpty    sex1    sex1net sex1name
	      sex1pt1 sex1pt2 newse   newsen  newsem  newjptlist
	      newsept1	      newsept2	      newjpt1 newjpt2 newjptx
	      newjpty dpt1    dpt2    dpt3    dpt4    se2     se3
	     )
  (setq cadver (substr (getvar "acadver") 1 2))
  (setq oldos (getvar "osmode"))
  (if (< oldos 16384)
    (setvar "osmode" (+ oldos 16384))
  )
  (setq oldcmd (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (prompt "\n请选择修剪区域,直接选取(左键)为窗选,右键为栅选<任意键结束>:")
  ;(if (= cadver "14")
    ;(setq pta (grread (grread)))
  (setq pta (grread))
   ; )
  (while (/= (car pta) 2)
    (if	(and (/= (car pta) 12)(listp (cadr pta)))
      (progn
	(setq pta (cadr pta))
	(setq ptb (getcorner pta "\n修剪区域对角:"))
	(if (/= ptb nil)
	  (progn
	    (setq ptax (car pta)
		  ptay (cadr pta)
		  ptbx (car ptb)
		  ptby (cadr ptb)
	    )
	    (setq ptaxby (list ptax ptby)
		  ptbxay (list ptbx ptay)
	    )
	    (setq sebox (list pta ptaxby ptb ptbxay))
	    (setq se (ssget "c" pta ptb '((0 . "LINE"))))
	  )
	  (setq se nil)
	)
      )
    )
    (if	(or (= (car pta) 12)(= (car pta) 25))      
      (progn
	(SETQ PTA (CAR PTA))
	(setq sebox '())
	(setq aa (getpoint "\n选取多边形区域的一个顶点"))
	(if (/= aa nil)
	  (progn
	    (setq sebox (cons aa sebox))
	    (setq dd aa)
	    (while
	      (setq cc (getpoint aa "\n选取多边形区域的下一顶点"))
	       (grdraw aa cc 7 1)
	       (setq aa cc)
	       (setq sebox (cons aa sebox))
	    )
	    (grdraw aa dd 7 1)
	    (setq se (ssget "cp" sebox '((0 . "LINE"))))
	    (redraw)
	  )
	  (setq se nil)
	)
      )
    )
    (IF	(/= SE NIL)
      (PROGN
	(SETQ n	     (sslength se)
	      selist '()
	      ptl    '()
	      ptlist '()
	      m	     0
	)
	(while (/= m n)
	  (setq	lse    (entget (ssname se m))
		sename (cdr (assoc -1 lse))
		selist (cons sename selist)
		pt1    (cdr (assoc 10 lse))
		pt2    (cdr (assoc 11 lse))
		ptl    (cons pt2 ptl)
		ptl    (cons pt1 ptl)
		ptlist (cons ptl ptlist)
		ptl    '()
		m      (1+ m)
	  )
	)
	(setq n	      (length ptlist)
	      m	      0
	      jptlist '()
	)
	(while (/= m n)
	  (setq	ptl1	(car (nth m ptlist))
		ptl2	(cadr (nth m ptlist))
		ptlist1	(cutnum_lst ptlist m)
		m	(1+ m)
		n1	(length ptlist1)
		m1	0
	  )
	  (while (/= m1 n1)
	    (setq ptl3 (car (nth m1 ptlist1))
		  ptl4 (cadr (nth m1 ptlist1))
	    )
	    (if	(setq jpt (inters ptl1 ptl2 ptl3 ptl4 t))
	      (setq jptlist (cons jpt jptlist))
	    )
	    (setq m1 (1+ m1))
	  )
	)
	(setq jptlist (purge_lst jptlist))
	(setq tmptlist '()
	      n	       (length ptlist)
	      m	       0
	)
	(while (/= m n)
	  (setq	dpt1	 (car (nth m ptlist))
		tmptlist (cons dpt1 tmptlist)
		dpt2	 (cadr (nth m ptlist))
		tmptlist (cons dpt2 tmptlist)
		m	 (1+ m)
	  )
	)
	(setq dptlist (reverse tmptlist))
	(if (listp pta)
	  (progn
	    (if	(= (equal jptlist '(nil)) nil)
	      (setq jptlist (pt_inm jptlist pta ptbxay ptb ptaxby)
	      )
	    )
	    (setq dptlist (pt_inm dptlist pta ptbxay ptb ptaxby)
	    )
	  )
	  (progn
	    (if	(= (equal jptlist '(nil)) nil)
	      (setq jptlist (pt_inmx jptlist sebox))
	    )
	    (setq dptlist (pt_inmx dptlist sebox)
	    )
	  )
	)
	(if (/= dptlist nil)
	  (setq dptlist (purge_lst dptlist))
	)
	(if (equal jptlist '(nil))
	  (setq na 0)
	  (setq na (length jptlist))
	)
	(setq nb    (length dptlist)
	      nab   (+ na nb)
	      nlist (list na nb nab)
	)
;;;
;;;执行操作
;;;
	(if (equal nlist '(2 0 2))
	  (command "trim"
		   se
		   ""
		   (mpt (car jptlist) (cadr jptlist))
		   ""
	  )
	)
	(if (and (= (* 2 (length selist)) nb) (= na 0))
	  (command "ERASE" se "")
	)
	(if
	  (and (= na 0) (= (- (length selist) (length dptlist)) 1))
	   (progn
	     (setq n (length dptlist)
		   m 0
	     )
	     (while (/= m n)
	       (setq dpt (nth m dptlist))
	       (setq m (1+ m))
	       (command "EXTEND" se "" dpt "")
	     )
	     (setq yorn (getstring "\n需要修剪吗？Y or N <Y>"))
	     (if (or (= yorn "y") (= yorn "") (= yorn nil))
	       (progn
		 (setq jptxlist '())
		 (setq n (length selist)
		       m 0
		 )
		 (while	(/= m n)
		   (setq sexx (nth m selist))
		   (setq sexlist (cutnum_lst selist m))
		   (setq nn (length sexlist)
			 mm 0
		   )
		   (while (/= mm nn)
		     (setq sexy (nth mm sexlist))
		     (if (setq
			   jptx
			    (inters (cdr (assoc 10 (entget sexx)))
				    (cdr (assoc 11 (entget sexx)))
				    (cdr (assoc 10 (entget sexy)))
				    (cdr (assoc 11 (entget sexy)))
			    )
			 )
		       (setq jptxlist (cons jptx jptxlist))
		     )
		     (setq mm (1+ mm))
		   )
		   (setq m (1+ m))
		 )
		 (setq jptxlist (purge_lst jptxlist))
		 (while	(>= (length jptxlist) 2)
		   (setq jptx1 (nth 0 jptxlist)
			 jptx2 (nth 1 jptxlist)
		   )
		   (command "trim"
			    se
			    ""
			    (mpt jptx1 jptx2)
			    ""
		   )
		   (setq jptxlist (cdr jptxlist))
		 )
	       )
	     )
	   )
	)
	(if (equal nlist '(4 0 4))
	  (progn
	    (setq jpt1 (car jptlist)
		  jpt2 (cadr jptlist)
		  jpt3 (caddr jptlist)
		  jpt4 (cadddr jptlist)
	    )
	    (command "trim"
		     se
		     ""
		     (mpt jpt1 jpt2)
		     (mpt jpt1 jpt3)
		     (mpt jpt1 jpt4)
		     (mpt jpt2 jpt3)
		     (mpt jpt2 jpt4)
		     (mpt jpt3 jpt4)
		     ""
	    )
	  )
	)
	(if (equal nlist '(1 2 3))
	  (progn
	    (se_123 (car selist))
	    (se_123 (cadr selist))
	    (command "trim" se "" (car dptlist) (cadr dptlist) "")
	  )
	)
	(if (equal nlist '(2 2 4))
	  (progn
	    (se_123 (car selist))
	    (se_123 (cadr selist))
	    (se_123 (caddr selist))
	    (command "trim"
		     se
		     ""
		     (car dptlist)
		     (cadr dptlist)
		     (mpt (car jptlist) (cadr jptlist))
		     ""
	    )
	  )
	)
	(if (equal nlist '(4 2 6))
	  (progn
	    (setq dpt1 (car dptlist)
		  dpt2 (cadr dptlist)
	    )
	    (se_426 dpt1)
	    (setq newjptn newjpt)
	    (se_426 dpt2)
	    (command "trim" se "" (mpt newjptn newjpt) "")
	  )
	)
	(if (and (= (length selist) 2) (equal nlist '(0 2 2)))
	  (command "FILLET" (car dptlist) (cadr dptlist))
	)
	(if (equal nlist '(1 1 2))
	  (command "trim" se "" (car dptlist) "")
	)
	(if (and (= (length selist) 2) (equal nlist '(1 3 4)))
	  (command "ERASE" se "")
	)
	(if (and (= (length selist) 4)
		 (or (equal nlist '(1 3 4)) (equal nlist '(1 4 5)))
	    )
	  (progn
	    (setq sen (length selist)
		  sem 0
	    )
	    (while (/= sem sen)
	      (setq sex1 (nth sem selist))
	      (setq newselist (drop selist sex1))
	      (foreach n newselist
		(if (line_int sex1 n)
		  (setq	sexa sex1
			sexb n
		  )
		)
	      )
	      (setq sem (1+ sem))
	    )
	    (setq newselist (drop selist sexa)
		  newselist (drop newselist sexb)
	    )
	    (if	(listp pta)
	      (progn
		(if
		  (= (point_inm
		       (setq
			 fpt1
			  (cdr (assoc 10 (entget (car newselist)))
			  )
		       )
		       pta
		       ptbxay
		       ptb
		       ptaxby
		     )
		     nil
		  )
		   (setq
		     fpt1 (cdr (assoc 11 (entget (car newselist))))
		   )
		)
		(if
		  (= (point_inm
		       (setq fpt2
			      (cdr (assoc 10 (entget (cadr newselist))))
		       )
		       pta
		       ptbxay
		       ptb
		       ptaxby
		     )
		     nil
		  )
		   (setq fpt2
			  (cdr (assoc 11 (entget (cadr newselist))))
		   )
		)
	      )
	      (progn
		(if
		  (= (ea:point_inm
		       (setq
			 fpt1
			  (cdr (assoc 10 (entget (car newselist)))
			  )
		       )
		       sebox
		     )
		     nil
		  )
		   (setq
		     fpt1 (cdr (assoc 11 (entget (car newselist))))
		   )
		)
		(if (= (ea:point_inm
			 (setq
			   fpt2
			    (cdr (assoc 10 (entget (cadr newselist))))
			 )
			 sebox
		       )
		       nil
		    )
		  (setq	fpt2
			 (cdr (assoc 11 (entget (cadr newselist))))
		  )
		)
	      )
	    )
	    (setq oldfillet (getvar "filletrad"))
	    (setvar "filletrad" 0.0)
	    (command "FILLET" fpt1 fpt2)
	    (setvar "filletrad" oldfillet)
	    (setq dptlist1 (drop dptlist fpt1)
		  dptlist1 (drop dptlist1 fpt2)
	    )
	    (command "trim" se "" (car dptlist1) (cadr dptlist1) "")
	  )
	)
	(princ nlist)
      )
    )
    (prompt "\n请选择修剪区域,直接选取为窗选,右键为栅选<任意键结束>:")
    (setq pta (grread))    
  )
  (setvar "osmode" oldos)
    (setvar "cmdecho" oldcmd)
)
(PRINC
  "\n自动修剪程序已经加载成功,用“TTR”命令运行。 BY ZHYNT。HTTP://WWW.XDCAD.NET"
)
(PRINC)

