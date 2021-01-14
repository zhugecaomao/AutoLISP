;; dq.LSP
;; 版权所有 (C) 2000-2002  明经通道  
;;
;; 明经通道网站  http://www.mjtd.com
;; 作者：郑立楷  mccad@mjtd.com
;;
;;   本软件免费可供进行任何用途需求的拷贝、修改及发行, 但请遵循下述原则:
;;
;;   1)  上列的版权通告必须出现在每一份拷贝里。
;;   2)  相关的说明文档也必须载有版权通告及本项许可通告。
;;
;;   本软件仅提供作为应用上的参考, 而未声明或隐含任何保证; 对于任何特殊
;;   用途之适应性, 以及商业销售所隐含作出的保证, 在此一概予以否认。
;;
;;程序名称：对象水平对齐程序
;;执行命令：dq
;;程序功能：将选定的对象左对齐、右对齐或对中。
;;
;;
(defun c:dq (/ selobjs oldcmdecho)
  (setq oldcmdecho (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (setq selobjs (ssget))
  (if (or (not selobjs) (= (sslength selobjs) 1))
    (princ "\n你必须选定两个或两个以上的对象")
    (process selobjs)
  )
  (setvar "cmdecho" oldcmdecho)
  (princ)
)
(defun process (selobjs	  /	    amode     apnt	apnt_x
		apnt_y	  count	    objname   vlaxobj	MinPoint
		MaxPoint  minext   maxext   ext_l	ext_r
		ext_m	  tpnt
	       )
  (initget "L M R")
  (setq	amode (getkword
		"\n选择对齐方式[左对齐(L)/对中(M)/右对齐(R)]<左对齐>:"
	      )
  )
  (if (not amode)
    (setq amode "L")
  )
  (initget 1)
  (setq apnt (getpoint "\n选择水平对齐方向的对齐点："))
  (setq	apnt_x (car apnt)
	apnt_y (cadr apnt)
  )
  (vl-load-com)
  (setq count 0)
  (repeat (sslength selobjs)
    (setq objname (ssname selobjs count))
    (setq vlaxobj (vlax-ename->vla-object objname))
    (setq MinPoint (vlax-make-variant))
    (setq MaxPoint (vlax-make-variant))
    (vla-GetBoundingBox vlaxobj 'MinPoint 'MaxPoint)
    (setq minext (vlax-safearray->list MinPoint))
    (setq maxext (vlax-safearray->list MaxPoint))
    (setq ext_l (car minext))
    (setq ext_r (car maxext))
    (setq ext_m (+ (/ (abs (- ext_l ext_r)) 2) ext_l))
    (cond
      ((= amode "L")
       (setq tpnt (list ext_l apnt_y))
      )
      ((= amode "M")
       (setq tpnt (list ext_m apnt_y))
      )
      ((= amode "R")
       (setq tpnt (list ext_r apnt_y))
      )
    )
    (if	tpnt
      (command "_move" objname "" "non" tpnt "non" apnt)
    )
    (setq count (1+ count))
  )
)
(princ"\n对象对齐程序已加载，输入dq命令执行。----明经通道http://www.mjtd.com")


