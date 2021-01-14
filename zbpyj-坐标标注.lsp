;;;本文件与bgao.lsp相比，可在用户坐标系下标示选取点的绝对坐标。
;技巧：（按一下F8键试试，你可能会有一点惊喜哟） 
;如果有什么BUG，请联系我：piaoyj@szmedi.com.cn
;启动命令为zb
(defun c:zb( / p0 pxx pyy px py pp ppp paa pbb alph alf alfa p1 p2 p3 p11 p22 p21)
(command"style" "" "" 0 "" "" "" "" "")
(setq ucsfl (getvar "ucsfollow"))
(setvar "ucsfollow" 0)
(command "ucs" "world")			;转到世界坐标系
(setq os (getvar "osmode"))

(while (equal h nil)
  (setq h (getreal "\n 请输入字体高度:"))
;(command "LAYER" "Make" "gaobz" "")
 )   

   
(setvar "osmode" 37)
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
(setq p2 (polar p1 alph (* 8.5 h)))
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




)