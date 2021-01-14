;面积统计
;计算封闭区域面积的程序，供大家试用，程序完全开放，llisp编写
;要求： 
;1。所绘制的图形必须封闭。
;2。点取封闭区域，区域内最好没有其他实体。
;3。如没有设置比例，程序在开始后会要求用户输入比例，但不能为空。
(DEFUN C:dlmj (   )
(if (= bl nil)(setq bl(getreal "input bl---:")))(setvar "userr1" bl)
(command "-units" "2" "8" "1" "8" "" "")
(setq pt (getpoint "\n点取封闭区域:"))
(setq mmm 0.0)
  (while (/= pt nil)
  (command "layer" "s" "mj" "")
  (command "-boundary" pt "" )
  (setq ent (entlast)) 
  (command "area" "o" ent) 
  (setq j41 (getvar "area"))
  (command "erase" "l" "")
;  (setq j41 (atof j41))
  (setq j41 (* j41 bl) j41 (* j41 bl))
  (setq j41 (/ j41 1000.0) j41 (/ j41 1000.0))
  (setq mmm (+ mmm j41))
  (setq pt (getpoint "\n插入点:"))
  )
(setq nnn (rtos mmm 2 2))
(command "layer" "s" "0" "")
(setq pt (getpoint "\n输出点:"))
(command "text" pt "3" "0" nnn "")
(command "-units" "2" "0" "1" "8" "" "")
)

