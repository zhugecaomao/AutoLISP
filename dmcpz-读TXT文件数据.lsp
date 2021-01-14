;;数据如下
;;============================================================================
;;1.图号：J50H033484
;;2.密级：
;;3.比例尺分母：5000
;;4.西南图廓角点X坐标： 4394532.3
;;5.西南图廓角点Y坐标： 486592.5
;;6.西北图廓角点X坐标： 439445.4
;;7.西北图廓角点Y坐标： 4865841.2
;;9.东北图廓角点Y坐标： 489377.3
;;10.东南图廓角点X坐标： 4342528.1
;;11.东南图廓角点Y坐标： 483274.0
;;12.DOM裁切范围西南角点X坐标：4354895
;;13.DOM裁切范围西南角点Y坐标：483427
;;14.DOM裁切范围西北角点X坐标：4367895
;;15.DOM裁切范围西北角点Y坐标：486542
;;16.DOM裁切范围东北角点X坐标：4378478
;;17.DOM裁切范围东北角点Y坐标：498542
;;18.DOM裁切范围东南角点X坐标：4348478
;;19.DOM裁切范围东南角点Y坐标：480627
;;20.作业员：
;;21.检查员：
;;22.单幅数据量：79MB
;;============================================================================
;读txt文件并分离出坐标来lisp程序.还不完善还是先发一个也许能帮初学者一个忙.->
;这是一个有关DMC配准前读txt中(见附件)的特定字符串后坐标的小程序,例子中我只提取西南和东北角点;的X,Y坐标.我是集合了几个人的思路来写的.还不完善,但对于像我这样的初学者来说可能会帮上一点忙;儿.所以就先发上来一个.希望多提宝贵意见.
;================================================================
(defun c:DMCpz ( / txt fi start li str_tfh str_blc
  str_WSx str_WSy str_ENx str_ENy WS_x WS_y EN_x EN_y
        )
  
   (setq path_txt (getfiled "Select .txt file" "" "txt" 2))
   (setq fi (open path_txt "r"))
  
   (setq ;str_tfh ""
 str_WSx ""
 str_WSy ""
 str_ENx ""
 str_ENy ""
 ;str_blc "1:5000"
 )
  
  (setq start T)
  
  (while (and start (setq li (read-line fi)))
    (cond
      ((wcmatch li "*图号*") (setq str_tfh li))
      ((wcmatch li "*DOM裁切范围西南角点X坐标*") (setq str_WSx li))
      ((wcmatch li "*DOM裁切范围西南角点Y坐标*") (setq str_WSy li))
      ((wcmatch li "*DOM裁切范围东北角点X坐标*") (setq str_ENx li))
      ((wcmatch li "*DOM裁切范围东北角点Y坐标*") (setq str_ENy li)(setq start nil))
      (t nil)
    )
  )
    (setq WS_x
      (atof (substr str_WSx (+ 1 (strlen "：") (vl-string-search "：" str_WSx))) 
             ))
    (setq WS_y
      (atof (substr str_WSy (+ 1 (strlen "：") (vl-string-search "：" str_WSy))) 
             ))
    (setq EN_x
      (atof (substr str_ENx (+ 1 (strlen "：") (vl-string-search "：" str_ENx))) 
             ))
    (setq EN_y
      (atof (substr str_ENy (+ 1 (strlen "：") (vl-string-search "：" str_ENy))) 
             ))
   
     (command ".line" (list WS_x WS_y) (list EN_x EN_y) "")
       
    (close fi)
  (princ)
)

