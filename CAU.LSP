(vmon)
(defun C:bush-a ()
   (if bush-a (c:bush-a)(progn (load "pro2")(c:bush-a))))
(defun C:bush-b ()
   (if bush-b (c:bush-b)(progn (load "pro3")(c:bush-b))))
(defun C:cblock ()
   (if cblock (c:cblock)(progn (load "pro4")(c:cblock))))
(defun C:clip ()
   (if clip (c:clip)(progn (load "pro5")(c:clip))))
(defun C:cl ()
   (if cl (c:cl)(progn (load "pro6")(c:cl))))
(defun C:cp ()
   (if cp (c:cp)(progn (load "pro8")(c:cp))))
(defun C:cp-2 ()
   (if cp-2 (c:cp-2)(progn (load "pro9")(c:cp-2))))
(defun C:diminch ()
   (if diminch (c:diminch)(progn (load "pro11")(c:diminch))))
(defun C:dimmm ()
   (if dimmm (c:dimmm)(progn (load "pro12")(c:dimmm))))
(defun C:dimscl ()
   (if dimscl (c:dimscl)(progn (load "pro13")(c:dimscl))))
(defun C:dl ()
   (if dl (c:dl)(progn (load "pro14")(c:dl))))
(defun C:ej ()
   (if ej (c:ej)(progn (load "pro15")(c:ej))))
(defun C:ep-1 ()
   (if ep-1 (c:ep-1)(progn (load "pro16")(c:ep-1))))
(defun C:ep-2 ()
   (if ep-2 (c:ep-2)(progn (load "pro17")(c:ep-2))))
(defun C:ext ()
   (if ext (c:ext)(progn (load "pro18")(c:ext))))
(defun C:gp ()
   (if gp (c:gp)(progn (load "pro22")(c:gp))))
(defun C:int ()
   (if int (c:int)(progn (load "pro23")(c:int))))
(defun C:k1 ()
   (if k1 (c:k1)(progn (load "pro24")(c:k1))))
(defun C:ko ()
   (if ko (c:ko)(progn (load "pro25")(c:ko))))
(defun C:lp ()
   (if lp (c:lp)(progn (load "pro26")(c:lp))))
(defun C:lpa ()
   (if lpa (c:lpa)(progn (load "pro27")(c:lpa))))
(defun C:lpb ()
   (if lpb (c:lpb)(progn (load "pro28")(c:lpb))))
(defun c:lsp ()
   (if lsp (c:lsp)(progn (load "pro29")(c:lsp))))
(defun C:mak ()
   (if mak (c:mak)(progn (load "pro30")(c:mak))))
(defun C:mtrim ()
   (if mtrim (c:mtrim)(progn (load "pro33")(c:mtrim))))
(defun C:no () (if no (c:no)(progn (load "pro34")(c:no))))
(defun C:of2 ()
   (if of2 (c:of2)(progn (load "pro35")(c:of2))))
(defun C:op ()
   (if op (c:op)(progn (load "pro37")(c:op))))
(defun C:pl ()
   (if pl (c:pl)(progn (load "pro38")(c:pl))))
(defun C:rl ()
   (if rl (c:rl)(progn (load "pro39")(c:rl))))
(defun C:rp ()
   (if rp (c:rp)(progn (load "pro40")(c:rp))))
(defun C:retp ()
   (if retp (c:retp)(progn (load "pro41")(c:retp))))
(defun C:se ()
   (if se (c:se)(progn (load "pro45")(c:se))))
(defun C:sp ()
   (if sp (c:sp)(progn (load "pro46")(c:sp))))
(defun C:spp ()
   (if spp (c:spp)(progn (load "pro47")(c:spp))))
(defun C:std ()
   (if std (c:std)(progn (load "pro49")(c:std))))
(defun C:up ()
   (if up (c:up)(progn (load "pro52")(c:up))))
(defun C:vhdim ()
   (if vhdim (c:vhdim)(progn (load "pro53")(c:vhdim))))
(defun C:vhdime ()
   (if vhdime (c:vhdime)(progn (load "pro54")(c:vhdime))))
(defun C:sldim ()
   (if sldim (c:sldim)(progn (load "pro55")(c:sldim))))
(defun C:we ()
   (if we (c:we)(progn (load "pro56")(c:we))))
(defun C:wl ()
   (if wl (c:wl)(progn (load "pro57")(c:wl))))

(DEFUN PIN (/ P1 P2 P3 P4 TEMP L1 L2)
(SETQ L1 (CAR (ENTSEL "\nFIRST LINE : ")))
(IF (/= L1 nil)
    (PROGN
	(REDRAW L1 3)
	(SETQ TEMP (ENTGET L1))
	(SETQ P1 (CDR (ASSOC 10 TEMP)))
	(SETQ P2 (CDR (ASSOC 11 TEMP)))
	(SETQ L2 (CAR (ENTSEL "\nSECOND LINE : ")))
	(IF (/= L2 nil)
	    (PROGN
		(REDRAW L2 3)
		(SETQ TEMP (ENTGET L2))
		(SETQ P3 (CDR (ASSOC 10 TEMP)))
		(SETQ P4 (CDR (ASSOC 11 TEMP)))
		(REDRAW L2 1)
	    )
	)
	(REDRAW L1 1)
    )
)
(IF (AND (/= L1 nil) (/= L2 nil))
(INTERS P1 P2 P3 P4 nil)
)
)
(DEFUN STD-1 ()
   (SETVAR "CMDECHO" 0)
   (SETQ VC (GETVAR "VIEWCTR"))
   (SETQ YR (GETVAR "VIEWSIZE"))
   (SETQ VX (GETVAR "VSMAX"))
   (SETQ VI (GETVAR "VSMIN"))
   (setq nx (/ (- (NTH 0 vx) (NTH 0 vi)) (- (NTH 1 vx) (NTH 1 vi)) ))
   (SETQ XI (- (NTH 0 VC) (/ (* YR nx) 2)))	     ;left dwon x
   (SETQ YI (- (NTH 1 VC) (/ YR 2)))		     ;left dwon y
   (SETQ nx1 (rtos nx 2 1))
   (if (= "1.6" nx1) (setq xr (* yr nx 0.85839))(setq xr (* yr 1.408)))
)
(defun rtd(r) (* r (/ 180 pi)))

;(defun c:0()
;	 (command "layer" "s" "0" ""))
;(defun c:11()
;	 (command "layer" "s" "11" ""))
;(defun c:12()
;	 (command "layer" "s" "12" ""))
;(defun c:13()
;	 (command "layer" "s" "13" ""))
;(defun c:14()
;	 (command "layer" "s" "14" ""))
;(defun c:15()
;	 (command "layer" "s" "15" ""))
;(defun c:16()
;	 (command "layer" "s" "16" ""))
;(defun c:17()
;	 (command "layer" "s" "17" ""))
;(defun c:wl3()
;	 (command "layer" "s" "wl3" ""))
;(defun c:wl4()
;	 (command "layer" "s" "wl4" ""))
;(defun c:wl5()
;	 (command "layer" "s" "wl5" ""))
;(defun c:sc3()
;	 (command "layer" "s" "sc3" ""))
;(defun c:sc4()
;	 (command "layer" "s" "sc4" ""))
;(defun c:sc5()
;	 (command "layer" "s" "sc5" ""))
