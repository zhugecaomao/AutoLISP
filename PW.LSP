;;;Zpm-pw.lsp

;;;本程序用于修改line,pline,arc,circle线的宽度
;;;-------------------------------------------------------------------
;;;===================================================================
;;;改pline线的宽度
(defun pl_e (pline width)
  (command "pedit" pline "w" width "")
)
;;;===================================================================
;;;改line,arc线宽度                   
(defun l_e (line width)
  (command "pedit" line "" "w" width "")
)
;;;===================================================================
;;;改circle宽度
(defun pc_w (circle width / ed la cen rad d1 d2)
  (setq ed (entget circle))		;取得实体参数集
  (setq la (cdr (assoc 8 ed)))		;获得圆的当前层
  (setq cen (cdr (assoc 10 ed)))	;获得圆的圆心
  (setq cen (trans cen circle 1))	;将圆心坐标CEN由目标坐系
					;转到当前用户坐标系
  (setq rad (cdr (assoc 40 ed)))	;获得圆的半径
  (setq d1 (- (+ rad rad) width))	;内径
  (setq d2 (+ (+ rad rad) width))	;外径
  (command "layer" "s" la "")
  (entdel circle)
  (command "donut" d1 d2 cen "")
)
;;;===================================================================
(defun c:pw (/ osm width ss number i ename etype)
  (setvar "cmdecho" 0)
  (setq osm (getvar "osmode"))
  (setvar "osmode" 0)

  (if (null default-w)
    (setq default-w "0.00000000")
  )
  (setq width (getreal (strcat "请输入线宽<" default-w ">:")))
  (if (null width)
    (setq width (distof default-w))
    (setq default-w (rtos width 2 8))
  )
  (print)
  (prompt "请选择对象：")
  (setq ss (ssget))
  (if (null ss)
    (princ)
    (progn
      (setq number (sslength ss))
      (setq i 0)
      (repeat number
	(progn
	  (setq ename (ssname ss i))
	  (setq etype (cdr (assoc 0 (entget ename))))
	  (if
	    (= etype "CIRCLE")
	     (pc_w ename width)
	     (if
	       (or (= etype "LWPOLYLINE") (= etype "POLYLINE"))
		(pl_e ename width)
		(if
		  (or (= etype "LINE") (= etype "ARC"))
		   (l_e ename width)
		);END IF
	     );END IF
	  );END IF
	  (setq i (1+ i))
	);END PROGN
      );END REPEAT
    );END PROGN
  );END IF

  (setvar "cmdecho" 1)
  (setvar "osmode" osm)
  (princ)
)
;;;------------------------------------=------------------------------
;;;===================================================================
;;;***** END *****;;;
