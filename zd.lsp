;;****************展点  主程序******************
(defun c:zd( / luj oldosmode mjrow)
;;(if (null cal)(arxload"geomcal"))
;;(princ "\n 打开数据文件.....")
  (setvar "cmdecho" 0)
  (setvar "DIMZIN" 1)
  (setq oldosmode (getvar "osmode"))
  (setvar "osmode" 0)
  (if lu_jing T (setq lu_jing "e:/"))

  (setq luj (getfiled "打开文件..." lu_jing "txt" 2))
  (if luj   (progn 
               (setq mjrow(Wfchli luj) lu_jing luj)
               (Fcld mjrow))
   (princ "\n 文件打开取消，程序退出。"))
   (setvar "osmode" oldosmode)
   (princ)
)


(defun Fcld( cctv / qss)
(while (progn
      (initget "P C ")
      (setq qss(getpoint "\n 平面图展开(P) / 侧断面展开(C) /<退出>：")) 
      
      (if (= qss "P") (progn
                        ;;  展开数据平面图
                        (command "pline")
                        (mapcar 'command (Coorde cctv))
                        (command "")
                        (command "undo" "be")
                        (Xtext cctv)
                        (command "undo" "e")
                        (command "zoom" "e")) 
                       )
      (if (= qss "C") (progn 
                        ;;  按比例展开数据剖面图
                        (if (findfile "dmtk.dwg")
                        (command "insert" "dmtk.dwg" "0,0" "" "" "")
                        (princ "\n 未找到标尺及图框块文件"))
                        (command "pline")
                        (mapcar 'command (Hlist cctv))
                        (command "") 
                        (command "undo" "be")
                        (Hline cctv) ;;标注距离及高程
                        (command "undo" "e")
                        (command "zoom" "e"))
                )
                qss
  ))
)


;;******************标注高程*********************
(defun Xtext(mja / n h zaa xya)
(setq n 0 h "10" ;;文字高度
      zaa (Coordz mja)
      xya (Coorde mja))
(repeat (length zaa)
   (command "text" (nth n xya) h "0" (rtos (nth n zaa) 2 2))
   (setq n (1+ n)))
)


;;*************求两点间距离及高程****************
(defun Hlist(mjh / n h zaa xya)
(setq xx 1 yy 1) ;;比例尺
(setq n 0 HL 0 hct '()
      zaa (Coordz mjh)
      xya (Coorde mjh))
(repeat (- (length zaa) 1)
   (if (/= (nth n zaa) 0)
   (setq hct (cons (list (* HL xx) (* (nth n zaa) yy)) hct))) 
   
   (setq HL  (+ hl (distance (nth n xya) (nth (+ n 1) xya)))
          n (1+ n)))
   (reverse hct)
)


;;***********在横线上标出距离及高程**************
(defun Hline(mjn / n h yl yml xl xml) ;;
(setq xx 1 yy 1) ;;比例尺
(setq csa 30  ;;两条横线间的距离
      csd 5  ;;标注短线的长度
      csh "5" ;;标注字高
  )
 (setq n 0 xp (Hlist mjrow)
       h (length xp)
       xl (car (nth 0 xp))
       xml (car (nth (- h 1) xp))
       yl (- (cadr (nth 0 xp)) 114)
       yml (- yl csa)
)
       
 (command "line" (list xl yl) (list xml yl) "")
 (command "line" (list xl yml) (list xml yml) "")
 (repeat h 
  (setq xc (car (nth n xp)))
  (command "line" (list xc yml)(list xc (+ yml csd)) "")
  (command "text" "j" "ml" (list xc (+ yml (* 1.2 csd)))
    csh "90" (rtos (/ xc xx) 2 1))
  (setq hc (cadr (nth n xp)))
  (command "line" (list xc yl)(list xc (+ yl csd)) "")
  (command "text" "j" "ml" (list xc (+ yl (* 1.2 csd)))
   csh "90" (rtos (/ hc yy) 2 1))
  (setq n (1+ n))
)


)

;;******************提取高程*********************
(defun Coordz(mj / n aa ccx) 
  (setq n 0 aa '())
   (repeat (length mj)
   (setq ccx (nth n mj) n (1+ n)
         aa (cons (nth 3 ccx) aa)
   )) (reverse aa)
)



;;******************提取坐标*********************
;;传入多维表 (序号 x坐标 y坐标 高程)
;;返回每个元素的三维坐标
(defun Coorde(mj / n aa ccx) 
  (setq n 0 aa '())
   (repeat (length mj)
   (setq ccx (nth n mj) n (1+ n)
         aa (cons (list (nth 1 ccx)(nth 2 ccx)(nth 3 ccx)) aa)
   )) (reverse aa)
)

;;***********把多行字符文件转换为表**************
;;需要tt_fk子程序的支持
;;传入文件的全名包括路径的字符串
;;返回值为多维表
(defun Wfchli(lcc / f_dat txt_row ccdate) 
 (setq ccdate '() f_dat (open lcc "r"))
    (while (setq txt_row (read-line f_dat))
    (if (> (strlen txt_row) 1)
    (setq ccdate (cons (Tt_fk txt_row) ccdate)))
) (reverse ccdate)
)



;;***********把一行字符串转换为表****************
;;传入字符串参数： "1,453.34,452.63,53.3"
;;返回值为一个表： (1 453.34 452.63 53.3)
(defun Tt_fk(tt / k tr_k nn)  
 (setq nn (strlen tt) k 0 tr_k "")
 (while (<= k nn)
        (setq tr_kn (substr tt (setq k (+ k 1)) 1))
        (if (or (= tr_kn ",")(= tr_kn ";"))
        (setq tr_k (strcat tr_k " "))
        (setq tr_k (strcat tr_k tr_kn)))
 )(read (strcat "(" tr_k ")"))
)



;;应廖工的要求编写本程序
;;杨晓鹏  2005.11.3
