(defun c:semb (/ dis dus dbs ds dw ofd ofl ocm oco obl olderr pl pw pul pur pdl pdr rxds ryds rt 
		rul rur rbl rbr rtd spd sp)
  (setq ;olderr *error* 
        ;*error* ai_abort 
	   ocm (getvar "cmdecho") 
	   obl (getvar "blipmode")
	oco (getvar "cecolor"))
  (setvar "cmdecho" 0)  (command "_.UNDO" "_GROUP")  (setvar "blipmode" 0) 
  (initget 1)
  (setq	pl (* (find "A001" 1) 0.5)
	pw (* (find "A001" 2) 0.5)
	ds (getvar "dimscale")
	sp (getint "\n请输入---钉、司规格: ")
	spd (getreal "\n         介子直径: ")
	ofd (getreal "\n         偏孔距离: ")
	dis (cond ((= sp 16) 18)
		((= sp 20) 23)
		((= sp 25) 28)
		((= sp 30) 35)
		((= sp 35) 38)
		((= sp 40) 40)
		((= sp 45) 43)
		((= sp 50) 48 50))
	pul (list (* (- pl dis) -1) (- pw dis))
	pur (list (- pl dis) (- pw dis))
	pdl (list (car pul) (* (cadr pul) -1))
	pdr (list (car pur) (cadr pdl)))
  (if (/= ofd 0)
    (progn
	(initget 1 "Left Right Both")
	(setq ofl (getkword "\nLeft/Right/Both: "))
	(if (or (= ofl "Left") (= ofl "Both"))
		(setq pul (list (+ (car pul) ofd) (cadr pul))))	
	(if (or (= ofl "Right") (= ofl "Both"))
		(setq pur (list (- (car pur) ofd) (cadr pur))))
  ) )
  (command "cecolor" "4" "circle" pul "d" sp "circle" pur "d" sp 
			 "circle" pdl "d" sp "circle" pdr "d" sp
	   "cecolor" "6" "circle" pul "d" spd "circle" pur "d" spd
			 "circle" pdl "d" spd "circle" pdr "d" spd)
  (setq	dw (getreal "\n		凳仔宽度: ")
	rt (getint "\n         回针规格: ")
	rtd (getreal "\n	 介子直径: ")
	dr1 (list pl (- pw dw))
	dl1 (list (* pl -1) (cadr dr1))
	rxds (cond ((= rt 10) 18)
		((= rt 12) 24)
		((= rt 16) 29)
		((= rt 20) 28)
		((= rt 25) 36)
		((= rt 30) 36 36))
	ryds (+ (cond ((= rt 10) 15)
		((= rt 12) 20)
		((= rt 16) 19)
		((= rt 20) 23)
		((= rt 25) 25)
		((= rt 30) 32 32)) (+ dw 2))
	rul (list (* (- pl rxds) -1) (- pw ryds))
	rur (list (- pl rxds) (cadr rul))
	rbl (list (car rul) (* (cadr rul) -1))
	rbr (list (car rur) (* (cadr rur) -1)))
  (command "cecolor" "2" "celtype" "hidden"
	"line" dr1 dl1 "")
  (setq dus (entlast))
  (command "line" (polar dr1 4.7123889 2) (polar dl1 4.7123889 2) "")
  (setq dbs (entlast))
  (command "mirror" dus dbs "" '(0 0) '(1 0) ""
	"cecolor" "4" "celtype" "CONTINUOUS"
	"circle" rul "d" rt "circle" rur "d" rt 
	"circle" rbl "d" rt "circle" rbr "d" rt
	"cecolor" "6"
	"circle" rul "d" rtd "circle" rur "d" rtd
	"circle" rbl "d" rtd "circle" rbr "d" rtd
	"cecolor" "2"
	"dim" "ordinate" pul (polar pul 1.5707963 (+ dis (* ds 0.4))) ""
		"ordinate" pul (polar pul 3.1415926 (+ dis (* ds 0.4))) ""
		"ordinate" pur (polar pur 1.5707963 (+ dis (* ds 0.4))) ""
		"ordinate" pdl (polar pdl 3.1415926 (+ dis (* ds 0.4))) ""
		"ordinate" pdl (polar pdl 4.7123889 (+ dis (* ds 0.4))) ""
		"ordinate" pdr (polar pdr 4.7123889 (+ dis (* ds 0.4))) ""
		"ordinate" rbl (polar rbl 4.7123889 (+ ryds (* ds 0.4))) ""
		"ordinate" rbr (polar rbr 4.7123889 (+ ryds (* ds 0.4))) ""
		"ordinate" rbl (polar rbl 3.1415926 (+ rxds (* ds 0.4))) ""
		"ordinate" rul (polar rul 3.1415926 (+ rxds (* ds 0.4))) ""
		);"ordinate" (list (* pl -1) (- pw )
  (setvar "cmdecho" ocm) (setvar "blipmode" obl) (setvar "cecolor" oco)
  (setq *error* olderr)  (command "_.UNDO" "_E")
  (princ)
)
