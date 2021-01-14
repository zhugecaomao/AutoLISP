;|
功    能：循环拾取点后，绘制封闭曲线、标注分段线长、各点坐标、积
适用范围：规划

注    意：字体高度(textsize)、绘图单位(m & mm)请自行设定
|;
(if (not $xdtb_globle_scale)
  (setq $xdtb_globle_scale 1.0)
)
($xdrx_load "xdlsp.lsp")
(load "hzbbz.fas")
(defun c:XDTB_DRedLn (/ area e e1 len pcen pt pts ss box xmid ymid)
  (xdrx_begin)
  (xdrx_sysvar_push "osmode")
  (xdrx_ucson)
  (while (setq pt (getpoint "\n边界点: "))
    ($xdlsp_grdraw pt)
    (setq pts (cons pt pts))
    (if	(> (length pts) 1)
      (grdraw (car pts) (cadr pts) 1 1)
    )
  )
  (redraw)
  (setq	e1 (entlast)
	ss (ssadd)
  )
  (if (>= (length pts) 2)
    (progn
      (setq len	(length pts)
	    pts	($XDLSP_Points_Close pts)
      )
      ($XDLSP_Draw_Pline pts t)
      (setq e  (entlast)
	    ss (ssadd e ss)
      )
      (mapcar '(lambda (x y)
		 (vl-cmdf ".text"
			  (list	(/ (+ (car x) (car y)) 2)
				(/ (+ (cadr x) (cadr y)) 2)
				'0.
			  )
			  ""
			  ($xdlsp_rtd ($xdlsp_angle_format (angle x y)))
			  (rtos (distance x y) 2 3)
		 )
		 (ssadd (entlast) ss)
	       )
	      (reverse (cdr (reverse pts)))
	      (cdr pts)
      )
      (if (not (equal e e1))
	(progn
	  (setq area (apply 'xdrx_parea pts))
	  (if (not (zerop area))
	    (progn (vl-cmdf ".text"
			    "j"
			    "mc"
			    (list (/ (apply '+ (mapcar 'car pts)) len)
				  (/ (apply '+ (mapcar 'cadr pts)) len)
				  '0.
			    )
			    ""
			    0.
			    (strcat "总面积: " (rtos area 2 3))
		   )
		   (ssadd (entlast) ss)
	    )
	  )
	)
      )
      (setq box	 (apply 'xdrx_pointsbox pts)
	    xmid (/ (+ (caar box) (caadr box)) 2)
	    ymid (/ (+ (cadar box) (cadr (last box))) 2)
      )
      (mapcar
	'(lambda (p)
	   (cond
	     ((and (< (car p) xmid)
		   (< (cadr p) ymid)
	      )
	      (ea:hzbbz	p
			(polar p (* -0.75 pi) (* 10. $xdtb_globle_scale))
			0.
			t
			"X"
			t
	      )
	     )
	     ((and (<= (car p) xmid)
		   (>= (cadr p) ymid)
	      )
	      (ea:hzbbz	p
			(polar p (* 0.75 pi) (* 10. $xdtb_globle_scale))
			0.
			t
			"X"
			t
	      )
	     )
	     ((and (>= (car p) xmid)
		   (< (cadr p) ymid)
	      )
	      (ea:hzbbz	p
			(polar p (* -0.25 pi) (* 10. $xdtb_globle_scale))
			0.
			nil
			"X"
			t
	      )
	     )
	     ((and (>= (car p) xmid)
		   (>= (cadr p) ymid)
	      )
	      (ea:hzbbz	p
			(polar p _pi4 (* 10. $xdtb_globle_scale))
			0.
			nil
			"X"
			t
	      )
	     )
	     (t)
	   )
	   (ssadd (entlast) ss)
	 )
	(cdr pts)
      )
      (if ss
	(xdrx_group_make "*" ss)
      )
    )
  )
  (xdrx_ucsoff)
  (xdrx_sysvar_pop)
  (xdrx_end)
  (princ)
)