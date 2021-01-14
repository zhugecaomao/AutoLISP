;;此为我的lisp总汇
;本段程序可将选中的圆一次性裁剪掉圆中（经过圆心的）的线段。
(Defun c:tc (/ ucsfl fil len n m e ed pt0 pt pbx) 
 (command "redraw")
 (command "undo" "begin")
 (setq pbx (getvar "pickbox"))
 (setvar "pickbox" 3)
 (setq ucsfl (getvar "ucsfollow"))
 (setvar "ucsfollow" 0)
 (command "ucs" "world")			;转到世界坐标系
 (setq fil (ssget))			；选择圆
 (setq len (sslength fil))		；确定选中圆的个数
 (setq n 0)
 (while (<= n (- len 1))
   (setq e (ssname fil n))
   (setq ed (entget e))
   (if (/= "CIRCLE" (cdr (assoc 0 ed)))
    (setq n (+ 1 n))
    (progn 
     (setq pt0 (cdr (assoc 10 ed)))	;old circle's center
(command "zoom" "c" pt0 "80")		;可调整该数字以适应不同半径的圆
      (setq pt (osnap pt0 "nea"))
       (setq m 1)
      (while (and (/= nil pt) (< m 10)) ;在一个圆内裁剪不超过10次，以防止死循环
          (command "trim" e "" pt "")
          (setq pt (osnap pt0 "nea"))
          (setq m (+ 1 m))
      )
      (setq n (+ 1 n))
(command "zoom" "p")	
    )
   )
  )
 (command "ucs" "p")			;返回用户坐标系
 (setvar "ucsfollow" ucsfl)
 (setvar "pickbox" pbx)
 (command "undo" "end")
(princ)      
)
(princ "\n\n\t\ttcpiao\t\t\t裁剪圆内通过圆心的直线\t\t  tc")
;*********************************************************************************
;本段程序可将选中的圆一次性转为你所需要的半径。
(Defun c:cr (/ ucsfl R fil len n e ed b c R0 pt0 ang pt1 pt2 ln lnn i j jt qt k L pt ) 
 (command "redraw")
 (command "undo" "begin")
 (setq pbx (getvar "pickbox"))
 (setvar "pickbox" 3)
 (setq ucsfl (getvar "ucsfollow"))
 (setvar "ucsfollow" 0)
 (command "ucs" "world")			;转到世界坐标系
 ( setq R (getreal "\ninput R "))	；输入圆半径
 (setq fil (ssget))			；选择圆
 (setq len (sslength fil))		；确定选中圆的个数
 (setq n 0)
 (while (<= n (- len 1))
  (progn 
   (setq e (ssname fil n))
   (setq ed (entget e))
   (setq b nil) (setq c nil)
   (if (/= "CIRCLE" (cdr (assoc 0 ed)))
    (setq n (+ 1 n))
    (progn 
     (setq R0 (cdr (assoc 40 ed)))	;old circle's radius
     (setq pt0 (cdr (assoc 10 ed)))	;old circle's center
     (setq ed (subst (cons 40 R) (assoc 40 ed) ed))
     (setq n (+ 1 n))
     (entmod ed)
(command "zoom" "c" pt0 "15")		;可调整该数字以适应不同半径的圆
     (setq ang 0)
     (while (< ang (* 2 pi))
      (setq pt1 (polar pt0 ang R0))
      (setq ang (+ ang (/ pi 30)))
      (setq pt2 (osnap pt1 "endp"))
      (setq b (cons pt2 b))
     )
(setq ln (length b))
(setq lnn (- ln 1))
(setq i 0)
(setq pt (nth i b))
(while (<= i lnn)
  (setq pt (nth i b))
  (setq j (+ i 1))
  (setq jt (nth j b))
  (while (and (not (equal pt jt)) (< j lnn))
    (setq qt (nth j b))
    (setq j (+ 1 j))
    (setq jt (nth j b))
  )
  (if (not (equal pt jt)) (setq c (cons pt c)))
  (setq i (+ 1 i))
)
  (setq k 0)
  (setq L (length c))
;*************************************
  (while (<= k (- L 1))
    (setq pt (nth k c))
       (if (> R0 R)
          (command "extend" e "" pt "")
          (command "trim" e "" pt "")
       )
    (setq k (+ 1 k))
   )；while结束
;*************************************
(command "zoom" "p")
  )
 )
    )
   )
 (command "ucs" "p")			;返回用户坐标系
 (setvar "ucsfollow" ucsfl)
 (setvar "pickbox" pbx)
 (command "undo" "end")
(princ)      
)
(princ "\n\n\t\t crpiao\t\t改变检查井半径的程序\t\t\t cr")
;*********************************************************************************
;;;本文件与bgao.lsp相比，可在用户坐标系下标示选取点的绝对坐标。
;技巧：（按一下F8键试试，你可能会有一点惊喜哟） 
;如果有什么BUG，请联系我：piaoyj@szmedi.com.cn
;启动命令为zb
(defun c:zb( / ucsfl os p0 pxx pyy px py pp ppp paa pbb entl a b le sc len alph alf alfa p1 p2 p3 p11 p22 p21 t1 t2)
 (command "undo" "begin")
 (setq CHO (getvar "CMDECHO"))		;CMDECHO系统变量为1时，当使用command命令时反馈提示和输入，如为0则不反馈
 (setvar "CMDECHO" 0)
 ;(command "style" "standard" "txt,hztxt" "" "" "" "" "" "")
(setq ucsfl (getvar "ucsfollow"))
(setvar "ucsfollow" 0)
(command "ucs" "world")			;转到世界坐标系
(setq os (getvar "osmode"))

(while (equal h nil)
  (setq h (getreal "\n 请输入字体高度:"))
;(command "LAYER" "Make" "gaobz" "")
 )   
(setvar "osmode" 37)			;1端点，4圆心，32交点，可组合。
(initget 1 "h")
(setq p0 (getpoint "\n H/<选择插入点:>"))
(while (eq p0 "h") 
  (setq hh (getreal "\n 请输入字体高度:"))
   (if (/= nil hh) (setq h hh))
(setq p0 (getpoint "\n 请选择插入点:"))
)
(setq pxx (car p0))
(setq pyy (nth 1 p0))
(setq px (rtos pxx 2 3))
(setq py (rtos pyy 2 3))
(setvar "osmode" 0)
(setq pp (getpoint "\n 请选择引出点:"))	;引出点pp
(command "line" p0 pp nill)
(command "ucs" "p")			;返回用户坐标系
(command "line" "" pause "")


(setq entl (entget (entlast)))
(setq a (assoc 10 entl))
(setq b (assoc 11 entl))
(setq pa (cdr a))		;引出点pa
(setq ppp (cdr b))		;引出点pb
(setq paa (trans pa 0 1))
(setq pbb (trans ppp 0 1))		;引出点的用户坐标
(setq le (distance paa pbb))		;两点间距离	
(setq len (* 9.5 h))
(setq sc (/ len le))
(if (< le len)
  (progn 
   (command "scale" (entlast) "" paa sc "")
   )
)
(setq alph (angle paa pbb))		;引出两点的弧度alph 
(setq alf (* 180.0 (/ alph pi)))	;求出角度值alf
(setq p1 (polar paa alph h))		
(setq p2 (polar p1 alph (* 7 h)))	;p2决定线长
(setq p3 (polar p2 alph 1000))
(setq ent (entlast))
(command "break" ent p2 p3)		;将多余的线剪掉
(if (>= alf 105) 
(if (>= alf 255)
 (progn
  (setq pd p1)
  (setq alfa alf)
  (setq p11 (polar pd (+ 1.5708 alph) (* 0.4 h)))
  (setq p12 (polar pd (+ 4.7124 alph) (* 1.4 h)));定出文本起点
  )
 (progn
  (setq p21 (polar p2 (+ pi alph) h))	;
  (setq p11 (polar p21 (- alph 1.5708) (* 0.4 h)))
  (setq p12 (polar p21 (+ alph 1.5708) (* 1.4 h)));定出文本起点
  (setq alfa (+ alf 180))
  )
  )
				;当alf大于105时
 (progn
  (setq pd p1)
  (setq alfa alf)
  (setq p11 (polar pd (+ 1.5708 alph) (* 0.4 h)))
  (setq p12 (polar pd (+ 4.7124 alph) (* 1.4 h)));定出文本起点
  )
)
(setq t1 (strcat "X-" py))
(setq t2 (strcat "Y-" px))
(command "text" p11 h alfa t1)
(command "text" p12 h alfa t2)
(setvar "osmode" os)			;返回原捕捉模式
(setvar "ucsfollow" ucsfl)
 (command "undo" "end")
 (setvar "CMDECHO" CHO)
 (princ)
)
(princ "\n\n\t\t zbpyj\t\t\t标注坐标的程序\t\t\tzb")
;*********************************************************************************
(defun c:pg()
(command "purge" "a" "" "n")
(command "purge" "a" "" "n")
(command "purge" "a" "" "n")
(command "purge" "a" "" "n")
)
(princ "\n\n\t\t auto-purge\t\tpurge的批处理命令\t\t\tpg")
;*********************************************************************************
(Defun c:et ( / newtx v1 v2 nme oldtx v3 )
(setvar "cmdecho" 0)
       (prompt "\npick text to be changed:")
       (setq v1 (ssget))
       (setq newtx (getstring T "\nENTER NEW STRING: " ))
       (setq newtx (cons 1 newtx))
       (setq v2 0)
          (if (/= v1 nil)
              (while (< v2 (sslength v1))
                     (setq nme (ssname v1 v2 ))
                     (setq oldtx (assoc 1 (entget nme)))
                     (setq v3 (entget nme))
                     (entmod (subst newtx oldtx v3))
                     (entupd nme)
                     (setq v2 (+ v2 1 ))
               )
         )
 )
(princ "\n\n\t\t et\t\t\t以指定内容替代所选的文本\t\t  et")
;*********************************************************************************
;技巧：（按一下F8键试试，你可能会有一点惊喜哟） 
;如果有什么BUG，请联系我：piaoyj@szmedi.com.cn
;启动命令为bz
(defun c:bz(/ CHO os p0 pxx pyy px py pp entl a b pa ppp paa pbb le len sc alph alf p1 p2 p3 ent pd p11 p12 p21)
 (command "undo" "begin")
 (setq CHO (getvar "CMDECHO"))
 (setvar "CMDECHO" 0)
 ;(command "style" "txtp" "txt,hztxt" "" "" "" "" "" "")
(while (equal h1 nil)
  (setq h1 (getreal "\n 请输入字体高度:"))
;(command "LAYER" "Make" "gaobz" "")
 )   
(setq os (getvar "osmode"))
   
(setvar "osmode" 4)				;捕捉方式原37
(setq p0 (getpoint "\n 请选择插入点:"))
(setq pxx (car p0))
(setq pyy (nth 1 p0))
(setq px (rtos pxx 2 3))
(setq py (rtos pyy 2 3))
(setvar "osmode" 0)
(setq pp (getpoint "\n 请选择引出点:"))	;引出点pp
(command "line" p0 pp nill)
(command "line" "" pause "")
(setq entl (entget (entlast)))
(setq a (assoc 10 entl))
(setq b (assoc 11 entl))
(setq pa (cdr a))		;引出点pa
(setq ppp (cdr b))		;引出点pb
(setq paa (trans pa 0 1))
(setq pbb (trans ppp 0 1))		;引出点的用户坐标
(setq le (distance paa pbb))		;两点间距离	
(setq len (* 4.3 h1))
(setq sc (/ len le))
(if (< le len)
  (progn 
   (command "scale" (entlast) "" paa sc "")
   )
)
(setq alph (angle paa pbb))		;引出两点的弧度alph 
(setq alf (* 180.0 (/ alph pi)))	;求出角度值alf
(setq p1 (polar paa alph (* 0.4 h1)))		
(setq p2 (polar p1 alph (* 3.5 h1)))
(setq p3 (polar p2 alph 1000))
(setq ent (entlast))
(command "break" ent p2 p3)		;将多余的线剪掉
(if (>= alf 105) 
(if (>= alf 255)
 (progn
  (setq pd p1)
  (setq alfa alf)
  (setq p11 (polar pd (+ 1.5708 alph) (* 0.3 h1)))
  (setq p12 (polar pd (+ 4.7124 alph) (* 1.3 h1)));定出文本起点
  )
 (progn
  (setq p21 (polar p2 (+ pi alph) (* 0.5 h1)))	  ;(* 0.5 h1)调节向左标注时的文本起点
  (setq p11 (polar p21 (- alph 1.5708) (* 0.3 h1)))
  (setq p12 (polar p21 (+ alph 1.5708) (* 1.3 h1)));定出文本起点
  (setq alfa (+ alf 180))
  )
  )
				;当alf大于105时
 (progn
  (setq pd p1)
  (setq alfa alf)
  (setq p11 (polar pd (+ 1.5708 alph) (* 0.3 h1)))
  (setq p12 (polar pd (+ 4.7124 alph) (* 1.3 h1)));定出文本起点
  )
)
(command "text" p11 h1 alfa "DADA")
(command "text" p12 h1 alfa "ADAD")
(setvar "osmode" os)			;返回原捕捉模式
 (command "undo" "end")
 (setvar "CMDECHO" CHO)
 (princ)
)
(princ "\n\n\t\tbzpyj\t\t\t帮助标注检查井标高的工具\t\t  bz")
;*********************************************************************************
;author piao yingjun    piaoyj@szmedi.com.cn
(Defun c:cb ( / fil sc scl len n e ed h) 
 (command "redraw")
(setq fil (ssget))
( setq sc (getreal "\n请输入宽度比例："))
( setq scl sc)
(setq len (sslength fil))
(setq n 0)
 (while (<= n (- len 1))
  (progn
   (setq e (ssname fil n))
   (if (= "TEXT" (cdr (assoc 0 (setq ed (entget e)))))   
     (progn
       (setq h  scl)
          (setq ed (subst (cons 41 h) (assoc 41 ed) ed)) 
          (setq n (+ 1 n))
          (entmod ed)
     )
    (setq n (+ 1 n))
    )
   )
  )
(princ)
)
(princ)
(princ "\n\n\t\t改字体宽度比例cb\t  改变所选文本的宽度比例\t\t   cb")
;*********************************************************************************
;;;  peditn.lsp
;;;  (C)  给排水组 
;;;  by zhuxiaofeng
;;;  1995,10,20 (1版)
;;;  1997,5,15  (2版)
;;;  2001,8,15  (3版) by piaoyingjun
;;;  该程序可修改线,弧,圆、椭圆及多义线的宽度
(defun C:pn (/ p l n e q w a m layer0 color0 linetype0 layer1 color1 linetype1 rad-out rad-in)
 (command "undo" "begin")
  (setq oldblp (getvar "blipmode")
        oldech (getvar "cmdecho")
        olderr *error*
        linetype1 (getvar "celtype")
        layer1 (getvar "clayer")
        color1 (getvar "cecolor")
  )
  (setvar "blipmode" 0) 
  (setvar "cmdecho" 0)
  (defun *error* (msg)
    (princ "\n") 
    (princ msg)
    (setvar "blipmode" oldblp)
    (setvar "cmdecho" oldech)
    (setq *error* olderr)
    (princ)
  )  
  (prompt "\n请选择要改变宽度的线,弧,圆及多义线.")
  (setq p (ssget))
  (setq w (getreal "\n请输入宽度<1>:"))
  (if (not w) (setq w 1))
  (setq l 0 m 0 n (sslength p))
  (while (< l n)
    (setq q (ssname p l))
    (setq ent (entget q))
    (setq b (cdr (assoc 0 ent)))
    (if (member b '("LINE" "ARC"))
      (progn 
        (command "PEDIT" q "y" "w" w "x") 
        (setq m (+ 1 m))
      ) 
    )
    (if (= "LWPOLYLINE" b)
      (progn 
        (command "PEDIT" q "w" w "x") 
        (setq m (+ 1 m))
      ) 
    )
    (if (= "CIRCLE" b)
      (progn 
        (if (assoc 6 ent) (setq linetype0 (cdr (assoc 6 ent))) (setq linetype0 "bylayer"))
        (setq layer0 (cdr (assoc 8 ent)))
        (if (assoc 62 ent) (setq color0 (cdr (assoc 62 ent))) (setq color0 "bylayer"))
        (setq center0 (cdr (assoc 10 ent)))
        (setq radius0 (cdr (assoc 40 ent)))
        (setq diameter0 (* 2 radius0))
        (entdel q)
        (command "color" color0)
        (command "layer" "s" layer0 "")
        (command "linetype" "s" linetype0 "")
        (if (> w diameter0)
          (progn 
            (princ "\n\t 因线宽大于圆的直径，故将该圆填充")
            (princ)
            (setq rad-out (* 2 radius0)
                  rad-in 0
            )
          )
        )
        (if (<= w diameter0)
          (progn 
            (setq rad-out (+ (* 2 radius0) w) 
                  rad-in (- (* 2 radius0) w)
            )
          )
        )
        (command "donut" rad-in rad-out center0 "")
        (setq m (+ 1 m))
      )
    ) 
    (setq l (+ 1 l))
  )
  (if (= "ELLIPSE" b)
   (progn
    (setq center0 (cdr (assoc 10 ent)))
    (command "offset" w q center0 "")
    (command "offset" w q (list 0 0 0) "")
    (entdel q)
    (command "hatch" "s" "f" center0 (list 0 0 0) "" "")
  ))
  (if (= 0 m)
    (progn 
     (princ "\n\t  没有任何线,弧,圆，椭圆，及多义线被选中")
      (princ)
    )
  )
  (setvar "blipmode" oldblp)
  (setvar "cmdecho" oldech)
  (setq *error* olderr)
  (command "color" color1)
  (command "layer" "s" layer1 "")
  (command "linetype" "s" linetype1 "")
 (command "undo" "end")
  (princ)

(princ "\n\t  线宽编辑程序,  (c) 1997 ")
(princ "\n\t  c:Peditn 已加载; 以Pn启动命令.\n")
(princ)
)
(princ "\n\n\t\t线宽编辑程序\t\t  可改变线、圆、椭圆、弧及多义线的宽度\t    pn")
;*********************************************************************************
;author piao yingjun    piaoyj@szmedi.com.cn
(Defun c:cz ( / fil len n e ed b new1 c new2 ) 
 (command "redraw")
(setq fil (ssget))
(setq len (sslength fil))
(setq n 0)
 (while (<= n (- len 1))
  (progn
   (setq e (ssname fil n))
   (setq ed (entget e))
   (if (/= nil)   
     (progn
          (setq b (assoc 10 ed))
         (setq new1 (list 10 (car (cdr b)) (car (cdr (cdr b))) 0))
          (setq ed (subst new1 b ed)) 

          (setq c (assoc 11 ed))
         (setq new2 (list 11 (car (cdr c)) (car (cdr (cdr c))) 0))
          (setq ed (subst new2 c ed)) 
          (setq n (+ 1 n))
          (entmod ed)
     )
    (setq n (+ 1 n))
    )
   )
  )
(princ)
)
;(princ "\n\t  改变纵坐标,  (piaoyj@szmedi.com.cn) 2001 ")
;(princ "\n\t  程序 已加载; 以cz启动命令.\n")
(princ)

(princ "\n\n\t\t改直线纵坐标cz\t  改变简单实体（非多义线）的纵坐标为0   cz")
;*********************************************************************************
(defun c:xs(/ e ed )
(setq e (car (entsel)))
(textscr)
(setq ed (entget e))
)
;(princ "\n\t 显示所选实体的信息")
;(princ "\n\t 程序已加载，以xs启动命令。\n")
(princ)
(princ "\n\n\t\t显示实体信息xs\t  显示所选的实体的信息\t\t   xs")
;*********************************************************************************
;author piao yingjun    piaoyj@szmedi.com.cn
(Defun c:cdx ( / case) 
 (command "redraw")

(setq fil (ssget))
(setq case (getint "\n 改成(1)小写 / <直接回车为大写>："))	

(setq len (sslength fil))
(setq n 0)

 (while (<= n (- len 1))
  (progn
   (setq e (ssname fil n))
   (cond 
        ((= "TEXT" (cdr (assoc 0 (setq ed (entget e)))))
          (progn
  
           (setq ostr (cdr (assoc 1 ed)))
           (setq nstr (strcase ostr case))
           (setq ed (subst (cons 1 nstr) (assoc 1 ed) ed)) 
           (setq n (+ 1 n))
           (entmod ed)
          ))
        ((= "MTEXT" (cdr (assoc 0 (setq ed (entget e)))))
          (progn
  
           (setq ostr (cdr (assoc 1 ed)))
           (setq nstr (strcase ostr case))
             (setq lenstr (strlen nstr))
              (setq m 1)
              (while (< m lenstr)
                (if (= "\\p" (substr nstr m 2))
                   
                     (setq nstr (strcat (substr nstr 1 m) "\P" (substr nstr (+ 2 m))))
                 ;(setq m (+ 1 m))   
                )
                 (setq m (+ 1 m))
              )

           (setq ed (subst (cons 1 nstr) (assoc 1 ed) ed)) 
           (setq n (+ 1 n))
           (entmod ed)
          ))
       (T (setq n (+ 1 n)))
    )
   )
  )
(princ)
)
(princ "\n\t  改变所选文本的大小写 以cdx启动命令 2002 \n")
;*********************************************************************************

