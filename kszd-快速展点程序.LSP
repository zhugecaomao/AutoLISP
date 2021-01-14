;LISP快速展点程序
;LISP展点程序，主要地形测量中展绘碎部点等。
;展1000点：在HP(AMD Athlon64 3000+ 256MB)电胶上仅耗时0.142秒；
; 在金利(Geleron(R) CPU 2.40GHz 256MB)电胶上耗时0.882秒
;数据文件格式为：每一点的数据（点号、X、Y、H）为一行，用逗号或空格作为分隔符，即
;点号1 X1 Y1 H1 或者 点号1, X1, Y1, H1
;点号2 X2 Y2 H2 或者 点号2, X2, Y2, H2
;点号3 X3 Y3 H3 或者 点号3, X3, Y3, H3
;......
;点号n Xn Yn Hn 或者 点号n, Xn, Yn, Hn1
(defun c:kszd()
(setq ff (open (getfiled "请选择要展点的数据文件" "" "txt" 2) "r")
fhb nil t0 (getvar "cdate")
cm (getvar "cmdecho") os (getvar "osmode")
tcm1 "高程注记" tcm2 "点记"
)
(setvar "cmdecho" 0)(setvar "osmode" 0)
(if (= (tblsearch "layer" tcm1) nil) (command "layer" "n" tcm1 ""))
(if (= (tblsearch "layer" tcm2) nil) (command "layer" "n" tcm2 ""))
(while (setq zb (read-line ff))
;(setq zb (vl-string-translate " " "," zb))
(setq zb (vl-string-translate "," " " zb))
(setq zb (read (strcat "(" zb ")"))
zb (list (list (nth 2 zb) (nth 1 zb)) (vl-princ-to-string (last zb)));注记高程
;zb (list (list (nth 2 zb) (nth 1 zb)) (vl-princ-to-string (car zb)));提示：注记点号请用该行
fhb (append fhb (list zb))
)
)
(setq t1 (getvar "cdate"))
(close ff)
(setq zb (vl-sort fhb '(lambda (e1 e2) (< (car (car e1)) (car (car e2)))))
x0 (car (car (car zb))) x1 (car (car (last zb)))
zb (vl-sort fhb '(lambda (e1 e2) (< (cadr (car e1)) (cadr (car e2)))))
y0 (cadr (car (car zb))) y1 (cadr (car (last zb)))
)
(command "zoom" "w" (list x0 y0) (list x1 y1))
(setq t2 (getvar "cdate"))
(foreach zb fhb
(setq zfc (last zb)
;pt (mapcar '+ (car zb) '(1.5 -1.25))
pt (car zb) 
)

(entmake (list '(0 . "TEXT") '(100 . "AcDbEntity") '(100 . "AcDbText") 
'(62 . 1) '(40 . 2.5) '(50 . 0.0) 
;(cons 8 tcm1) (cons 1 zfc) (cons 10 pt)
(cons 8 tcm1) (cons 1 zfc) (cons 10 (mapcar '+ pt (1.5 -1.25)))
)
(entmake (list '(0 . "POINT") '(100 . "AcDbEntity") '(100 . "AcDbPoint")
'(62 . 2)
(cons 8 tcm2) (cons 10 pt)
)
)
)
(setq t3 (getvar "cdate")
dt1 (* 1000000 (- t1 t0))
dt2 (* 1000000 (- t3 t2))
)
(princ (strcat "
读入数据共耗时：" (rtos dt1 2 3) "秒 展点共耗时" (rtos dt2 2 3) "秒"
"
展点数：" (itoa (length fhb)) "个 每展一点耗时：" (rtos (/ dt2 (length fhb)) 2 10) "秒"
)
)
(setvar "cmdecho" cm)(setvar "osmode" os)(princ)
)  
