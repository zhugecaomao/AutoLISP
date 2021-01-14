;********以下是子程序部分********
;型号字母改大写*****
(defun atoA (/)
  (setq type_b (strcase type_b))
  (set_tile "type_p" type_b)
)
;屏蔽I/O选项*********
(defun mode (/ type type_num)
  (setq type_num (strlen type_b))
  (if (= type_num 2)
    (mode_tile "o_i" 1)
    (progn 
      (setq type (substr type_b 1 2))
      (if (or (= type "FA") (= type "GA") (= type "FC") (= type "GC") )
          (mode_tile "o_i" 1)
          (mode_tile "o_i" 0) )
   )  )
)
;********改变线型********
(defun cen () (command "linetype" "s" "center" "" "color" 3))
(defun hid () (command "linetype" "s" "hidden" "" "color" 6))
(defun con () (command "linetype" "s" "continuous" "" "color" 4))
;********加中心线********
(defun CEN_L ()
   (setq CN_L (entget (entlast)))
   (cen)(command "line" (polar (cdr (assoc 10 CN_L)) (/ pi 2) 
			(+ (cdr (assoc 40 CN_L)) (/ (cdr (assoc 40 CN_L)) 8)))
			(polar (cdr (assoc 10 CN_L)) (/ pi -2) 
			(+ (cdr (assoc 40 CN_L)) (/ (cdr (assoc 40 CN_L)) 8))) ""
		 "line" (polar (cdr (assoc 10 CN_L)) 0
		        (+ (cdr (assoc 40 CN_L)) (/ (cdr (assoc 40 CN_L)) 8))) 
		        (polar (cdr (assoc 10 CN_L)) (* pi -1) 
			(+ (cdr (assoc 40 CN_L)) (/ (cdr (assoc 40 CN_L)) 8))) ""))
;********标注X轴的尺寸********
(defun ORD_X (pw pl IH_T I_D CN_L / L_ORD)
   (setq X_X (nth 1 (assoc 10 CN_L))
         Y_Y (nth 2 (assoc 10 CN_L)))
 (if (< Y_Y 0)
   (setq X_X_Y -1)
   (setq X_X_Y 1))
   (if (= IH_T "I")
   (setq L_ORD (+ (/ pw (* 2 X_X_Y)) (* I_D X_X_Y)))
   (setq L_ORD (/ pw (* 2 X_X_Y))))
   (con)(command "dim" "ordinate" (list X_X (+ Y_Y (* (cdr (assoc 40 CN_L)) X_X_Y)))
                                  (list X_X (+ L_ORD (* pl 0.02 X_X_Y))) "" "e"))
;********标注Y轴的尺寸********
(defun ORD_y (CN_L pl / W_ORD)
   (setq X_X_X (nth 1 (assoc 10 CN_L))
         Y_Y_Y (nth 2 (assoc 10 CN_L)))
(if (< X_X_X 0)
   (setq Y_Y_X -1)
   (setq Y_Y_X 1))
   (setq W_ORD (/ pl (* 2 Y_Y_X)))   
   (con)(command "dim" "ordinate" (list (+ X_X_X (* (cdr (assoc 40 CN_L)) Y_Y_X)) Y_Y_Y)
                                  (list	(+ W_ORD (* pl 0.02 Y_Y_X)) Y_Y_Y) "" "e"))
;*****设置模胚类型******
(defun set_type (/ )
  (if (or (= type_b "AI") (= type_b "AH") (= type_b "AT")
          (= type_b "BI") (= type_b "BH") (= type_b "BT")
          (= type_b "CI") (= type_b "CH") (= type_b "CT")
          (= type_b "DI") (= type_b "DH") (= type_b "DT") ) 
      (setq type_p "S") )
  (if (or (= type_b "DAI") (= type_b "DAH") (= type_b "EAI") (= type_b "EAH")
          (= type_b "DBI") (= type_b "DBH") (= type_b "EBI") (= type_b "EBH")
          (= type_b "DCI") (= type_b "DCH") (= type_b "ECI") (= type_b "ECH")
          (= type_b "DDI") (= type_b "DDH") (= type_b "EDI") (= type_b "EDH"))
      (setq type_p "P") )
  (if (or (= type_b "FAI") (= type_b "FAH") (= type_b "GAI") (= type_b "GAH")
          (= type_b "FCI") (= type_b "FCH") (= type_b "GCI") (= type_b "GCH"))
      (setq type_p "R") )
  )
;*********设置工字模or直身模*****
  (defun set_i_h (/ type_num )
    (setq type_num (strlen type_b))
    (if (= type_num 2) (setq IH_T (substr type_b 2)))
    (if (= IH_T "T") (setq IH_T "H"))
    (if (= type_num 3) (setq IH_T (substr type_b 3)))
  )
;*******
  (defun mod_s_y (/ ) (set_tile "s_y" s_y))
  (defun mod_o_i (/ ) (set_tile "o_i" P_O_I)) 
  (defun set_cb_ta (/) 
     (if (or (= type_b "AI") (= type_b "AT") (= type_b "BI") (= type_b "BT")
             (= type_b "CI") (= type_b "CT") (= type_b "DI") (= type_b "DT") ) 
         (setq CB_TA "Y")
         (setq CB_TA "N") )
  )
  (defun set_scrw (/)
   ;*********B板杯头
    (if (and (>= msize 1515) (<= msize 1830)) (setq screwb_num 4))
    (if (= msize 1835) (setq screwb_num 6))
    (if (and (>= msize 2020) (<= msize 2025)) (setq screwb_num 4))
    (if (and (>= msize 2030) (<= msize 2045)) (setq screwb_num 6))
    (if (and (>= msize 2325) (<= msize 2340)) (setq screwb_num 4))
    (if (= msize 2335) (setq screwb_num 6))
    (if (and (>= msize 2525) (<= msize 2530)) (setq screwb_num 4))
    (if (and (>= msize 2535) (<= msize 2550)) (setq screwb_num 6))
    (if (= msize 2730) (setq screwb_num 4))
    (if (and (>= msize 2735) (<= msize 2940)) (setq screwb_num 6))
    (if (= msize 3030) (setq screwb_num 4))
    (if (and (>= msize 3035) (<= msize 3350)) (setq screwb_num 6))
    (if (and (= msize 3535) (= type_p "S")) (setq screwb_num 4)) 
    (if (and (= msize 3535) (/= type_p "S")) (setq screwb_num 6))
    (if (and (>= msize 3540) (<= msize 5570)) (setq screwb_num 6))
    (if (and (>= msize 5575) (<= msize 5580)) (setq screwb_num 8))
    (if (and (>= msize 6060) (<= msize 6070)) (setq screwb_num 6))
    (if (and (>= msize 6075) (<= msize 6080)) (setq screwb_num 8))
   ;******针板杯头
    (if (<= msize 5070) (setq screwe_num 4) (setq screwe_num 6))
  )
     
;********以下是标准模胚的规格的主程序********
(defun c:stc (/ olderr ocm oco obl pl pw  olderr p1 p2 p3 p4 p5 p6 p7 p8 p10 p20 DO_P FO_P p30 p40 p60 p80 msize TYPE_P
		P_O_I IH_T I_D CN_L  GP_D SP_D C_RAD1 S_RAD2 S_RAD1 S_RAD2 R_RAD1 R_RAD2 C1 C2 C3 C4 C10 C20 C30 C40 
		C_POT1 C_POT2 C_POT3 C_POT4 TOP1 TOP2 lp1 lp2 lp3 lp4 lp5 lp6 po1 po2 po3 po4 po5 po6 po7 po8 po9 po10 
		po11 po12 po13 po14 po15 po17 po18 po19 po20 po21 po22 po23 po24 po25 po26 po27 po28 po29 po30 po31 po32
		po33 po34 po35 po36 po37 po38 po39 po40 po41 po42 po43 po44 po45 po46 po47 po48 ang1 ang2 pw1 lp7 lp8 
		lp9 lx1 ly1 L_W th1 th2 ll1 lw1 aa bb po03 po04 p032 po68 po69 po70
		lpo1 lpo2   type_b dcl )
  (setq dcl (load_dialog "c:/Autolisp/sta.dcl"))
  (if (not (new_dialog "sta" dcl)) (exit))
  (set_tile "egy_n" "N")
  (action_tile "order" "(setq ono $value)")
  (action_tile "type_p" "(setq type_b $value) (atoA) (mode)")
  (action_tile "msize" "(setq msize (atoi $value))")
  (action_tile "apd" "(setq apd $value)")
  (action_tile "bpd" "(setq bpd $value)")
  (action_tile "s_y" "(setq s_y (strcase $value)) (mod_s_y)")
  (action_tile "o_i" "(setq P_O_I (strcase $value)) (mod_o_i)")
  (action_tile "egy_n" "(setq egy_n $value)")
  (action_tile "accept" "(done_dialog)")
  (action_tile "cancel" "(exit)")
  (start_dialog)
  (unload_dialog dcl)
  (setq ocm (getvar "cmdecho")
	obl (getvar "blipmode")
	oco (getvar "cecolor")
	olderr *ERROR*
	*error* ai_abort )
  (setvar "cmdecho" 0)   (command "_.UNDO" "_GROUP")  (setvar "blipmode" 0) 
  (set_type)
  (set_i_h)
  (set_cb_ta)

  (if (= egy_n "Y") 
    (progn
      (setq eg_num (getint "\n中托钉.司的数量<4>:"))
      (if (= eg_num nil) (setq eg_num 4))
      (setq eg_dia (getint "\n中托钉.司的大小:"))
  ) )
  (setq pw (* (fix (/ msize 100)) 10)
	pl (* (- msize (* pw 10)) 10))
  (if (or (= msize 6510) (= msize 7010) (= msize 8010))
  (setq pl (* pl 10)))
  (if (>= msize 4545) (setq I_D 50) (setq I_D 25))
  (setq p1 (list (* (/ pl 2) -1) (* (/ pw 2) -1)) p10 (list (* (/ pl 2) -1) (- (* (/ pw 2) -1) I_D))
	p2 (list (car p1) (* -1 (cadr p1)))       p20 (list (car p1) (* -1 (cadr p10)))
	p3 (list (/ pl 2) (/ pw 2))               p30 (list (/ pl 2) (+ (/ pw 2) I_D))  
	p4 (list (car p3) (cadr p1))              p40 (list (car p3) (cadr p10))  
	p5 (list (- (car p1) (/ pl 100)) 0)      
	p6 (list 0 (+ (cadr p2) (/ pl 100)))      p60 (list 0 (+ (cadr p20) (/ pl 100)))
	p7 (list (* -1 (car p5)) 0)            
	p8 (list 0 (* -1 (cadr p6)))              p80 (list 0 (* -1 (cadr p60)))
	pw1 (* (/ 0.5 317) 0.6 pw))
  (setq pll pl)
  (if (= IH_T "I")
      (setq plw (+ pw (* 2 I_D)))
      (setq plw pw))
  (setq oxr (open "c:/Autolisp/data.dat" "w"))
  (princ (strcat "(" (rtos pll) " " (rtos plw) " )\n") oxr)
  (close oxr)

;********以下是上模部分********
  (command "layer" "n" "cavity" "")
  (command "clayer" "cavity")
  (con)
  (if (= IH_T "I") 
      (progn 
	(command "line" p10 p20 p30 p40 "c" "line" p1 p4 "" "line" p2 p3 "")
	(cen)(command "line" p5 p7 "" "line" p60 p80 "")))
  (if (= IH_T "H")      
      (progn
      (command "line" p1 p2 p3 p4 "c")
      (cen)(command "line" p5 p7 "" "line" p6 p8 "")))
  (command  "dimscale" (/ msize 100) "ltscale" (/ msize 150))
  (if (= IH_T "I")
     (progn
     (con)(command "dim"
	  "ordinate" p10 (polar p10 pi (* pl 0.02)) ""
	  "ordinate" p20 (polar p20 (/ pi 2) (* pl 0.02)) ""
	  "ordinate" p30 (polar p30 (/ pi 2) (* pl 0.02)) ""
	  "ordinate" p20 (polar p20 pi (* pl 0.02)) ""
	  "ordinate" p60 (polar p60 (/ pi 2) (* pl 0.02)) "")))
  (if (= IH_T "H")
     (progn
     (con)(command "dim"
	  "ordinate" p2 (polar p2 (/ pi 2) (* pl 0.02)) ""
	  "ordinate" p3 (polar p3 (/ pi 2) (* pl 0.02)) ""
	  "ordinate" p6 (polar p6 (/ pi 2) (* pl 0.02)) "")))
 (command "ordinate" p2 (polar p2 pi (* pl 0.02)) ""
	  "ordinate" p1 (polar p1 pi (* pl 0.02)) ""
	  "ordinate" p5 (polar p5 pi (* pl 0.02)) "" "e")
  
;*******以下是作钉司部分*********
  (load "c:/Autolisp/futaba1.axl") (futaba msize)
  (setq FO_P (open "c:/Autolisp/gpin.dat" "r")
	GATE 0)
  (while (/= SOGP GATE )
	 (setq GATE (atof (read-line FO_P))
	       DO_P (read (read-line FO_P))))
  (close FO_P)
  (setq GP_D (car DO_P) C_RAD1 (cadr DO_P) C_RAD2 (caddr DO_P))
  (setq SP_D (nth 3 DO_P) S_RAD1 (nth 4 DO_P))
  (if (= msize 2325) (setq SP_D (+ 1 SP_D)))
  (if (AND (>= msize 2330)  (<= msize 2335))  (setq SP_D (+ 2 SP_D)))
  (if (AND (>= msize 3045)  (<= msize 3545))  (setq SP_D (+ 2 SP_D)))
  (setq c1 (list (+ (car p1) GP_D) (+ (last p1) GP_D))
       c10 (list (+ (car c1) SP_D) (last c1)) 
	c2 (list (+ (car p2) GP_D 2) (- (last p2) GP_D)) 
       c20 (list (+ (car c2) SP_D) (last c2))
	c3 (list (- (car p3) GP_D) (- (last p3) GP_D))
       c30 (list (- (car c3) SP_D) (last c3))
	c4 (list (- (car p4) GP_D) (+ (last p4) GP_D))
       c40 (list (- (car c4) SP_D) (last c4)))

  (if (= TYPE_P "P")
      (progn
  (if (= P_O_I "O")
  (setq C_POT1 c1 c1 c10 c10 C_POT1
	C_POT2 c2 c2 c20 c20 C_POT2
	C_POT3 c3 c3 c30 c30 C_POT3
	C_POT4 c4 c4 c40 c40 C_POT4))
  (setq cc10 (list (+ (car c10) C_RAD1) (cadr c10))
        cc20 (list (+ (car c20) C_RAD1) (cadr c20))
        cc30 (list (+ (car c30) C_RAD1) (cadr c30))
        cc40 (list (+ (car c40) C_RAD1) (cadr c40)))
  (con)(command "circle" c10 C_RAD1) (CEN_L)
  (con)(command "circle" c20 C_RAD1) (CEN_L)
  (con)(command "circle" c30 C_RAD1) (CEN_L)
  (con)(command "circle" c40 C_RAD1) (CEN_L)
  (con)(command "dim" "leader" (polar c20 (/ pi -3) C_RAD1) 
		  	 (polar c20 (/ pi -3) (+ C_RAD1 (* pl 0.05))) 
			 (polar (polar c20 (/ pi -3) (+ C_RAD1 (* pl 0.05))) 0 (* pl 0.02))
		      "" (strcat "%%c" (itoa SOGP) "娩") "e")
       )
  )
  (hid)(command "circle" c1 (cadr DO_P)) (CEN_L)
  (hid)(command "circle" c2 (cadr DO_P)) (CEN_L)
  (hid)(command "circle" c3 (cadr DO_P)) (CEN_L)
  (hid)(command "circle" c4 (cadr DO_P)) (CEN_L)
  (con)(command "dim" "leader" (polar c2 (/ pi -3) C_RAD1) 
		         (polar c2 (/ pi -3) (+ C_RAD1 (* pl 0.05))) 
			 (polar (polar c2 (/ pi -3) (+ C_RAD1 (* pl 0.05))) 0 (* pl 0.02)) 
			 "" (strcat "%%c" (itoa SOGP)) "e")
  (if (= TYPE_P "R")
      (progn
  (setq PO_INT_R  (polar (polar c2 (/ pi -3) (+ C_RAD1 (* pl 0.05))) 0 (* pl 0.02)))
  (command "text" (list (+ (car PO_INT_R) (* (getvar "dimscale") 0.09)) 
		       (- (cadr PO_INT_R) (* (* (getvar "dimscale") 0.18) 2)))
		   (* (getvar "dimscale") 0.18) "0" (strcat "%%c" (itoa SOGP) "娩"))))
  (command "text" (list (+ (car p2) (/ pw 120)) 
				 (- (cadr p2) (/ pl 120))) (/ msize 685) "270" "DATUM")


;*****以下是加主杯头孔*****
(set_scrw)
(if (= CB_TA "Y")
  (progn
    (setq FO_D (open "c:/Autolisp/gpin.dat" "r")
	GATE 0)
    (while (/= SCRW GATE )
	 (setq GATE (atof (read-line FO_D))
	       SCR_P (read (read-line FO_D))))
    (close FO_D)
    (setq SCR1 (nth 5 SCR_P) SCR2 (nth 8 SCR_P))
    (if (= TYPE_P "S")        
        (setq SCR_C1 scrpc1)
	(setq SCR_C1 pcrpc1)
    )
    (if (and (= TYPE_P "S") (= screwb_num 8))
      (setq SCR_CA scrpc2
	    SCR_NO "(8X)")
      (setq SCR_CA scrpc1
	    SCR_NO "(6X)"))
    (setq SCR_C2 (list (car SCR_C1) (* (cadr SCR_C1) -1))
          SCR_C3 (list (* (car SCR_C1) -1) (* (cadr SCR_C1) -1))
          SCR_C4 (list (* (car SCR_C1) -1) (cadr SCR_C1))
          SCR_C5 (list 0 (cadr SCR_C1))
          SCR_C6 (list 0 (* (cadr SCR_C1) -1))
          SCR_CB (list (car SCR_CA) (* (cadr SCR_CA) -1))
          SCR_CC (list (* (car SCR_CA) -1) (cadr SCR_CA))
          SCR_CD (list (* (car SCR_CA) -1) (* (cadr SCR_CA) -1)))
    (if (and (= TYPE_P "S") (or (= msize 6075) (= msize 6080)))
      (progn
         (hid)(command "circle" SCR_CA SCR2 "circle" SCR_CA SCR1)
         (CEN_L)
         (hid)(command "circle" SCR_CB SCR2 "circle" SCR_CB SCR1)(CEN_L)
         (hid)(command "circle" SCR_CC SCR2 "circle" SCR_CC SCR1)
         (CEN_L)
         (hid)(command "circle" SCR_CD SCR2 "circle" SCR_CD SCR1)(CEN_L)
    )  )
    (if (= screwb_num 6)
      (progn
         (hid)(command "circle" SCR_C5 SCR2 "circle" SCR_C5 SCR1)(CEN_L)
         (hid)(command "circle" SCR_C6 SCR2 "circle" SCR_C6 SCR1)(CEN_L)
      )
    )
    (hid)(command "circle" SCR_C1 SCR2 "circle" SCR_C1 SCR1)
    (CEN_L)
    (hid)(command "circle" SCR_C2 SCR2 "circle" SCR_C2 SCR1)
    (CEN_L)
    (hid)(command "circle" SCR_C3 SCR2 "circle" SCR_C3 SCR1)(CEN_L)
    (hid)(command "circle" SCR_C4 SCR2 "circle" SCR_C4 SCR1)
    (CEN_L)
  )
)


;********以下是作下模部分***********
  (command "layer" "n" "core" 
	   "s" "core" "f" "cavity" "")
  (if (= IH_T "I") 
      (progn 
	(con)(command "line" p10 p20 p30 p40 "c" "line" p1 p4 "" "line" p2 p3 "")
	(cen)(command "line" p5 p7 "" "line" p60 p80 "")))
  (if (= IH_T "H")      
      (progn
      (con)(command "line" p1 p2 p3 p4 "c")
      (cen)(command "line" p5 p7 "" "line" p6 p8 "")))
   (if (= IH_T "I")
     (progn
     (con)(command "dim"
	  "ordinate" p10 (polar p10 pi (* pl 0.02)) ""
	  "ordinate" p20 (polar p20 (/ pi 2) (* pl 0.02)) ""
	  "ordinate" p30 (polar p30 (/ pi 2) (* pl 0.02)) ""
	  "ordinate" p20 (polar p20 pi (* pl 0.02)) ""
	  "ordinate" p60 (polar p60 (/ pi 2) (* pl 0.02)) "")))
 (if (= IH_T "H")
     (progn
(con)(command "dim" "ordinate" p2 (polar p2 (/ pi 2) (* pl 0.02)) ""
		    "ordinate" p3 (polar p3 (/ pi 2) (* pl 0.02)) ""
		    "ordinate" p6 (polar p6 (/ pi 2) (* pl 0.02)) "")))
	   (command "ordinate" p2 (polar p2 pi (* pl 0.02)) ""
		    "ordinate" p1 (polar p1 pi (* pl 0.02)) ""
		    "ordinate" p5 (polar p5 pi (* pl 0.02)) "" "e")
  
;*******以下是下模钉司部分*********
 (setq c1 (list (+ (car p1) GP_D) (+ (last p1) GP_D))
      c10 (list (+ (car c1) SP_D) (last c1))
       c2 (list (+ (car p2) GP_D) (- (last p2) GP_D))
      c20 (list (+ (car c2) SP_D) (last c2)) 
       c3 (list (- (car p3) GP_D 2) (- (last p3) GP_D))
      c30 (list (- (car c3) SP_D) (last c3)) 
       c4 (list (- (car p4) GP_D) (+ (last p4) GP_D))
      c40 (list (- (car c4) SP_D) (last c4)))
  (if (= TYPE_P "P")
      (progn
  (if (= P_O_I "O")
  (setq C_POT1 c1 c1 c10 c10 C_POT1
	C_POT2 c2 c2 c20 c20 C_POT2
	C_POT3 c3 c3 c30 c30 C_POT3
	C_POT4 c4 c4 c40 c40 C_POT4))
  (setq cc10 (list (+ (car c10) S_RAD1) (cadr c10))
        cc20 (list (+ (car c20) S_RAD1) (cadr c20))
        cc30 (list (+ (car c30) S_RAD1) (cadr c30))
        cc40 (list (+ (car c40) S_RAD1) (cadr c40)))
  (con)(command "circle" c10 S_RAD1) (CEN_L)
  (con)(command "circle" c20 S_RAD1) (CEN_L)
  (con)(command "circle" c30 S_RAD1) (CEN_L)
  (con)(command "circle" c40 S_RAD1) (CEN_L)
  (con)(command "pline" cc10 "w" (* pw1 0.95) "" "a" "a" "180" "c" c10 cc10 ""
		"pline" cc20 "w" (* pw1 0.95) "" "a" "a" "180" "c" c20 cc20 ""
		"pline" cc30 "w" (* pw1 0.95) "" "a" "a" "180" "c" c30 cc30 ""
		"pline" cc40 "w" (* pw1 0.95) "" "a" "a" "180" "c" c40 cc40 "")
       (command "dim" "leader" (polar c20 (/ pi -3) S_RAD1) 
		 	 (polar c20 (/ pi -3) (+ S_RAD1 (* pl 0.08))) 
			 (polar (polar c20 (/ pi -3) (+ S_RAD1 (* pl 0.08))) 0 
			 (* pl 0.02)) "" (strcat "%%c" (itoa SOGP) "水口边避空吼") "e")))
 (if (= TYPE_P "R")    (setq C_RAD2 C_RAD1))
 (hid)(command "circle" c1 C_RAD2) (CEN_L)
 (hid)(command "circle" c2 C_RAD2) (CEN_L)
 (hid)(command "circle" c3 C_RAD2) (CEN_L)
 (hid)(command "circle" c4 C_RAD2) (CEN_L)
 (con)(command "dim" "leader" (polar c2 (/ pi -3) C_RAD2) 
			     (polar c2 (/ pi -3) (+ C_RAD2 (* pl 0.08))) 
			     (polar (polar c2 (/ pi -3) (+ C_RAD2 (* pl 0.08))) 0 (* pl 0.02))
			     "" (strcat "%%c" (itoa SOGP)) "e")
    (command "text" (list (- (car p3) (/ pw 35)) (- (cadr p3) (/ pl 120))) (/ msize 685) "270" "DATUM")

;*****以下是下模回针部分*******
(setq FO_D (open "c:/Autolisp/gpin.dat" "r")
	GATE 0)
  (while (/= SANDP GATE )
	 (setq GATE (atof (read-line FO_D))
	       RP_P (read (read-line FO_D))))
(close FO_D)
(setq R_RAD1 (nth 6 RP_P) R_RAD2 (nth 5 RP_P))
(setq rp1 (list (+ (car rpc1) R_RAD2) (cadr rpc1))
      rp2 (list (+ (car rpc2) R_RAD2) (cadr rpc2))
      rp3 (list (+ (car rpc3) R_RAD2) (cadr rpc3))
      rp4 (list (+ (car rpc4) R_RAD2) (cadr rpc4)))
(hid)(command "circle" rpc1 R_RAD1) (CEN_L)
(hid)(command "circle" rpc2 R_RAD1) (CEN_L)
(hid)(command "circle" rpc3 R_RAD1) (CEN_L)
(hid)(command "circle" rpc4 R_RAD1) (CEN_L)
(con)(command "circle" rpc1 R_RAD2
	      "circle" rpc2 ""
	      "circle" rpc3 ""
	      "circle" rpc4 ""
	      "pline" rp1 "w" (* pw1 0.95) "" "a" "a" "180" "c" rpc1 rp1 ""
	      "pline" rp2 "w" (* pw1 0.95) "" "a" "a" "180" "c" rpc2 rp2 ""
	      "pline" rp3 "w" (* pw1 0.95) "" "a" "a" "180" "c" rpc3 rp3 ""
	      "pline" rp4 "w" (* pw1 0.95) "" "a" "a" "180" "c" rpc4 rp4 "")
(con)(command "solid" (polar rpc1 (/ pi 2) R_RAD2) 
		      (polar rpc1 pi R_RAD2) 
		      (polar rpc1 (/ pi -2) R_RAD2) 
		      (polar rpc1 0 R_RAD2) ""
	      "solid" (polar rpc2 (/ pi 2) R_RAD2) 
		      (polar rpc2 pi R_RAD2) 
		      (polar rpc2 (/ pi -2) R_RAD2) 
		      (polar rpc2 0 R_RAD2) ""
	      "solid" (polar rpc3 (/ pi 2) R_RAD2)
		      (polar rpc3 pi R_RAD2) 
		      (polar rpc3 (/ pi -2) R_RAD2) 
		      (polar rpc3 0 R_RAD2) ""
	      "solid" (polar rpc4 (/ pi 2) R_RAD2) 
		      (polar rpc4 pi R_RAD2)
		      (polar rpc4 (/ pi -2) R_RAD2)
		      (polar rpc4 0 R_RAD2) "")
   (command "dim" "leader" (polar rpc2 (/ pi -3) R_RAD1) 
		          (polar rpc2 (/ pi -3) (+ R_RAD1 (* pl 0.05))) 
		          (polar (polar rpc2 (/ pi -3) (+ R_RAD1 (* pl 0.05))) 0 (* pl 0.02))
		       "" (strcat "%%c" (itoa SANDP) "回针") "e")

;以下是中托钉.司部分
(if (= egy_n "Y")
  (progn
  (setq FO_D (open "c:/Autolisp/gpin.dat" "r")
	GATE 0)
  (while (/= eg_dia GATE )
	 (setq GATE (atof (read-line FO_D))
	       eg_p (read (read-line FO_D))))
  (close FO_D)
  (setq eg_rad (cadr eg_p))
  (if (= eg_num 2)
    (setq egc1 (list (car rpc1) 0)
          egc2 (list (car rpc2) 0) ) )
  (if (and (= eg_num 4) (= eg_dia 16)) (setq L 30))
  (if (and (= eg_num 4) (= eg_dia 20)) (setq L 35))
  (if (and (= eg_num 4) (= eg_dia 25)) (setq L 37))
  (if (and (= eg_num 4) (= eg_dia 30)) (setq L 41))
  (if (= eg_num 4)
    (setq egc1 (list (- (car rpc1) L) (cadr rpc1))
          egc2 (list (+ (car rpc2) L) (cadr rpc2))
          egc3 (list (- (car rpc3) L) (cadr rpc3))
          egc4 (list (+ (car rpc4) L) (cadr rpc4)) ) )
  (if (= eg_num 2)
    (progn
      (hid) (command "circle" egc1 eg_rad)(CEN_L)
      (hid) (command "circle" egc2 eg_rad)(CEN_L)
  ) )
  (if (= eg_num 4)
    (progn 
      (hid) (command "circle" egc1 eg_rad)(CEN_L)(ORD_X pw pl IH_T I_D CN_L)
      (hid) (command "circle" egc2 eg_rad)(CEN_L)(ORD_X pw pl IH_T I_D CN_L)
      (hid) (command "circle" egc3 eg_rad)(CEN_L)
      (hid) (command "circle" egc4 eg_rad)(CEN_L)
  ) )
  (command "dim" "leader" (polar egc1 (/ pi -1.5) eg_rad) 
		          (polar egc1 (/ pi -1.5) (+ eg_rad (* pl 0.05))) 
		          (polar (polar egc1 (/ pi -1.5) (+ eg_rad (* pl 0.05))) 0 (* pl 0.02))
		       "" (strcat "%%c" (itoa eg_dia) ) "e")
) )

;******以下是下模针板部分*******
(hid)(command "line" (list (/ pl 2) woep) (list (/ pl -2) woep) "")
(con)(command "dim" "ordinate" (list (/ pl 2) woep) (polar (list (/ pl 2) woep) 0 (* pl 0.015)) "" "e")
(hid)(command "line" (list (/ pl 2) (* woep -1)) (list (/ pl -2) (* woep -1)) "")
(con)(command "dim" "ordinate" (list (/ pl 2) (* woep -1)) (polar (list (/ pl 2) (* woep -1)) 0 (* pl 0.01)) "" "e")
(if (>= msize 5555) 
  (progn
     (hid)(command "line" (list (/ pl 2) (+ woep 5)) (list (/ pl -2) (+ woep 5)) ""
		   "line" (list (/ pl 2) (* (+ woep 5) -1)) (list (/ pl -2) (* (+ woep 5) -1)) "")
     (con)(command "dim" "ordinate" (list (/ pl -2) (* (+ woep 5) -1)) (polar (list (/ pl -2) (* (+ woep 5) -1)) (* pi -1) (* pl 0.02)) ""
		    "ordinate" (list (/ pl -2) (+ woep 5)) (polar (list (/ pl -2) (+ woep 5)) (* pi -1) (* pl 0.02)) "" "e"))
  (progn 
	(hid)(command "line" (list (/ pl 2) (+ woep 2)) (list (/ pl -2) (+ woep 2)) ""
	      "line" (list (/ pl 2) (* (+ woep 2) -1)) (list (/ pl -2) (* (+ woep 2) -1)) "")
	(con)(command "dim" "ordinate" (list (/ pl -2) (* (+ woep 2) -1)) (polar (list (/ pl -2) (* (+ woep 2) -1)) (* pi -1) (* pl 0.02)) ""
		    "ordinate" (list (/ pl -2) (+ woep 2)) (polar (list (/ pl -2) (+ woep 2)) (* pi -1) (* pl 0.02)) "" "e")))

;*****以下为加主杯头孔*****
(setq FO_D (open "c:/Autolisp/gpin.dat" "r")
	GATE 0)
  (while (/= SCRW GATE )
	 (setq GATE (atof (read-line FO_D))
	       SCR_P (read (read-line FO_D))))
(close FO_D)
(setq SCR1 (nth 5 SCR_P) SCR2 (nth 8 SCR_P))
(if (= TYPE_P "S")        
        (setq SCR_C1 scrpc1)
	(setq SCR_C1 pcrpc1)
)
(if (and (= TYPE_P "S") (or (= msize 6075) (= msize 6080)))
    (setq SCR_CA scrpc2
	  SCR_NO "(8X)")
    (setq SCR_CA scrpc1
	  SCR_NO "(6X)"))
(setq SCR_C2 (list (car SCR_C1) (* (cadr SCR_C1) -1))
      SCR_C3 (list (* (car SCR_C1) -1) (* (cadr SCR_C1) -1))
      SCR_C4 (list (* (car SCR_C1) -1) (cadr SCR_C1))
      SCR_C5 (list 0 (cadr SCR_C1))
      SCR_C6 (list 0 (* (cadr SCR_C1) -1))
      SCR_CB (list (car SCR_CA) (* (cadr SCR_CA) -1))
      SCR_CC (list (* (car SCR_CA) -1) (cadr SCR_CA))
      SCR_CD (list (* (car SCR_CA) -1) (* (cadr SCR_CA) -1)))
(if (and (= TYPE_P "S") (or (= msize 6075) (= msize 6080)))
     (progn
      (hid)(command "circle" SCR_CA SCR2 "circle" SCR_CA SCR1)
      (CEN_L)
      (hid)(command "circle" SCR_CB SCR2 "circle" SCR_CB SCR1)(CEN_L)
      (hid)(command "circle" SCR_CC SCR2 "circle" SCR_CC SCR1)
      (CEN_L)
      (hid)(command "circle" SCR_CD SCR2 "circle" SCR_CD SCR1)(CEN_L)
   )  )
   (if (= screwb_num 6) 
     (progn
      (hid)(command "circle" SCR_C5 SCR2 "circle" SCR_C5 SCR1)(CEN_L)
      (hid)(command "circle" SCR_C6 SCR2 "circle" SCR_C6 SCR1)(CEN_L)
   ) ) 
       (hid)(command "circle" SCR_C1 SCR2 "circle" SCR_C1 SCR1)
       (CEN_L)
       (hid)(command "circle" SCR_C2 SCR2 "circle" SCR_C2 SCR1)
       (CEN_L)
       (hid)(command "circle" SCR_C3 SCR2 "circle" SCR_C3 SCR1)(CEN_L)
       (hid)(command "circle" SCR_C4 SCR2 "circle" SCR_C4 SCR1)
       (CEN_L)

;*****以下为加针板杯头*****
(setq FO_D (open "c:/Autolisp/gpin.dat" "r")
      GATE 0)
  (while (/= SCPW GATE )
	 (setq GATE (atof (read-line FO_D))
	       PSCR_P (read (read-line FO_D))))
(close FO_D)
(setq PSCR1 (nth 5 PSCR_P) PSCR2 (nth 8 PSCR_P))
(setq PCR_C1 RPCR1)  
(setq PCR_C2 (list (car PCR_C1) (* (cadr PCR_C1) -1))
      PCR_C3 (list (* (car PCR_C1) -1) (* (cadr PCR_C1) -1))
      PCR_C4 (list (* (car PCR_C1) -1) (cadr PCR_C1))
      PCR_C5 (list (* (car PCR_C1) 0) (* (cadr PCR_C1) -1))
      PCR_C6 (list (* (car PCR_C1) 0) (cadr PCR_C1)))
(if (= screwe_num 6)
  (progn
    (hid)(command "circle" PCR_C5 PSCR2 "circle" PCR_C5 PSCR1) 
	  (CEN_L)
    (hid)(command "circle" PCR_C6 PSCR2 "circle" PCR_C6 PSCR1) 
	  (CEN_L)
  ) )
(hid)(command "circle" PCR_C1 PSCR2 "circle" PCR_C1 PSCR1)
	      (CEN_L)
(hid)(command "circle" PCR_C2 PSCR2 "circle" PCR_C2 PSCR1)
	 (CEN_L)
(hid)(command "circle" PCR_C3 PSCR2 "circle" PCR_C3 PSCR1) 
	  (CEN_L)
(hid)(command "circle" PCR_C4 PSCR2 "circle" PCR_C4 PSCR1)
	  (CEN_L)

;*****以下为加底析与凳仔杯头*****
    (setq FO_D (open "c:/Autolisp/gpin.dat" "r")
	  GATE 0)
    (while (/= SCDW GATE )
	   (setq GATE (atof (read-line FO_D))
		 DSCR_P (read (read-line FO_D))))
    (close FO_D)
    (setq DSCR1 (nth 5 DSCR_P) DSCR2 (nth 8 DSCR_P))
  (if (= TYPE_P "S")
    (setq DCR_C1 (list (car c4) (cadr SCR_C2)))
    (setq DCR_C1 DCR1))
    (setq DCR_C2 (list (car DCR_C1) (* (cadr DCR_C1) -1))
	  DCR_C3 (list (* (car DCR_C1) -1) (* (cadr DCR_C1) -1))
	  DCR_C4 (list (* (car DCR_C1) -1) (cadr DCR_C1)))
  (if (= TYPE_P "S")
    (progn
    (hid)(command "circle" DCR_C1 DSCR2 "circle" DCR_C1 DSCR1)(CEN_L)
    (hid)(command "circle" DCR_C4 DSCR2 "circle" DCR_C4 DSCR1)(CEN_L)
    )
    (progn
    (hid)(command "circle" DCR_C1 DSCR2 "circle" DCR_C1 DSCR1)(CEN_L)
    (hid)(command "circle" DCR_C4 DSCR2 "circle" DCR_C4 DSCR1)(CEN_L)
    )
   )
    (hid)(command "circle" DCR_C2 DSCR2 "circle" DCR_C2 DSCR1)(CEN_L)
    (hid)(command "circle" DCR_C3 DSCR2 "circle" DCR_C3 DSCR1)(CEN_L)    
    (con)

	      
;********以下是加腔部分********
  (initget "Y y N n")
  (setq POCK_T (getkword "\n是否需要加腔?Yes or No?<Y>:"))
  (if (or (= POCK_T nil) (= POCK_T "Y"))
  (progn 
  (setq POCK_L (getreal "\n请输入腔的长度:")
	POCK_W (getreal "\n请输入腔的宽度:")
	POCK_A (getreal "\n请输入A板腔的深度:")
	POCK_B (getreal "\n请输入B板腔的深度:")
	ptp1 (list (* (/ POCK_L 2) -1) (* (/ POCK_W 2) -1))
	ptp2 (list (car ptp1) (* (cadr ptp1) -1))    
	ptp3 (list (/ POCK_L 2) (/ POCK_W 2))               
	ptp4 (list (car ptp3) (cadr ptp1)))        
  (if (= POCK_A nil) (setq POCK_A (atof APD)))
  (if (= POCK_B nil) (setq POCK_B (atof BPD)))
  (if (or (= POCK_A (atof APD)) (= POCK_B (atof BPD))) (setq POCK_H (+ POCK_A POCK_B))
  (setq POCK_H (max POCK_A POCK_B)))
  (if (<= POCK_H 20) (setq FILL_R 8 I_D_R 3.31))
  (if (and (> POCK_H 20) (<= POCK_H 50)) (setq FILL_R 10 I_D_R 4.14))
  (if (and (> POCK_H 50) (<= POCK_H 70)) (setq FILL_R 13 I_D_R 5.38))
  (if (and (> POCK_H 70) (<= POCK_H 120)) (setq FILL_R 16 I_D_R 6.63))
  (if (> POCK_H 120)  (setq FILL_R 21 I_D_R 8.7))
  (con)
  (command "fillet" "r" FILL_R 
	   "pline" ptp1 "w" (* pw1 0.95) "" ptp2 ptp3 ptp4 "c"
	   "fillet" "p" "l")
  (rectang ptp1 ptp3)
  (command "fillet" "p" "l" "explode" "l")
  
 (if (= IH_T "I")
 (command "dim" "ordinate" (list (car ptp2) (- (cadr ptp2) FILL_R))
		       (polar ptp2 (/ pi 2) (+ (- (/ pw 2) (cadr ptp2)) (* pl 0.02) I_D)) ""
		"ordinate" (list (car ptp3) (- (cadr ptp3) FILL_R))
		       (polar ptp3 (/ pi 2) (+ (- (/ pw 2) (cadr ptp3)) (* pl 0.02) I_D)) ""))
(if (= IH_T "H")
  (command "dim" "ordinate" (list (car ptp2) (- (cadr ptp2) FILL_R))
			    (polar ptp2 (/ pi 2) (+ (- (/ pw 2) (cadr ptp2)) (* pl 0.02))) ""
		 "ordinate" (list (car ptp3) (- (cadr ptp3) FILL_R))
			    (polar ptp3 (/ pi 2) (+ (- (/ pw 2) (cadr ptp3)) (* pl 0.02))) ""))
  (command "ordinate" (list (- (car ptp3) FILL_R) (cadr ptp3))
			    (polar ptp3 0 (+ (- (/ pl 2) (car ptp3)) (* pl 0.02))) ""
		 "ordinate" (list (- (car ptp4) FILL_R) (cadr ptp4))
			    (polar ptp4 0 (+ (- (/ pl 2) (car ptp4)) (* pl 0.02))) ""
		   "leader" (polar ptp1 (/ pi 4) I_D_R) 
                             (polar (polar ptp1 (/ pi 4) I_D_R) (/ pi 4) (/ pl 20))
                      (polar (polar (polar ptp1 (/ pi 4) I_D_R) (/ pi 4) (/ pl 20)) 0 (* pl 0.02)) ""
			    (strcat "R" (rtos  FILL_R))  "e")
 (if (= POCK_B (atof BPD))
 (setq text_ "通腔")
 (setq text_ (strcat "-" (rtos POCK_B))))
	 (command "text" (polar ptp2 (/ pi -3) (/ POCK_L 4)) (* (getvar "dimscale") 0.18)
			    "0" text_)
;********上模加腔********
  (command "layer" "t" "cavity" "s" "cavity" "f" "core" "")
  (command "pline" ptp1 "w" (* pw1 0.95) "" ptp2 ptp3 ptp4 "c"
	   "fillet" "p" "l")
  (rectang ptp1 ptp3)
  (command "fillet" "p" "l" "explode" "l")
 (if (= IH_T "I")
 (command "dim" "ordinate" (list (car ptp2) (- (cadr ptp2) FILL_R))
		       (polar ptp2 (/ pi 2) (+ (- (/ pw 2) (cadr ptp2)) (* pl 0.02) I_D)) ""
		"ordinate" (list (car ptp3) (- (cadr ptp3) FILL_R))
		       (polar ptp3 (/ pi 2) (+ (- (/ pw 2) (cadr ptp3)) (* pl 0.02) I_D)) ""))
(if (= IH_T "H")
   (command "dim" "ordinate" (list (car ptp2) (- (cadr ptp2) FILL_R))
			    (polar ptp2 (/ pi 2) (+ (- (/ pw 2) (cadr ptp2)) (* pl 0.02))) ""
		 "ordinate" (list (car ptp3) (- (cadr ptp3) FILL_R))
			    (polar ptp3 (/ pi 2) (+ (- (/ pw 2) (cadr ptp3)) (* pl 0.02))) ""))
  (command "ordinate" (list (- (car ptp3) FILL_R) (cadr ptp3))
			    (polar ptp3 0 (+ (- (/ pl 2) (car ptp3)) (* pl 0.02))) ""
		 "ordinate" (list (- (car ptp4) FILL_R) (cadr ptp4))
			    (polar ptp4 0 (+ (- (/ pl 2) (car ptp4)) (* pl 0.02))) "" 
		   "leader" (polar ptp1 (/ pi 4) I_D_R) 
                             (polar (polar ptp1 (/ pi 4) I_D_R) (/ pi 4) (/ pl 20))
                      (polar (polar (polar ptp1 (/ pi 4) I_D_R) (/ pi 4) (/ pl 20)) 0 (* pl 0.02)) ""
			    (strcat "R" (rtos FILL_R)) "e")
   (if (= POCK_A (atof APD))
   (setq text_ "通腔")
   (setq text_ (strcat "-" (rtos POCK_A))))
	   (command "text" (polar ptp2 (/ pi -3) (/ POCK_L 4)) ""
			    "0" text_)))
  (setvar "cmdecho" ocm) (setvar "blipmode" obl) 
  (setvar "cecolor" oco)  (command "_.UNDO" "_E")
  (setq *error* olderr)
  (princ)
  )
;*** 后叙 ***
(princ "\n  Type-------------< STC >   to run this program.") 
(princ)


