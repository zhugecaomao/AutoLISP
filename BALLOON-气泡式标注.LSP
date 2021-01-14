;balloon.lsp
;本程序创建旁注线并将文字封在一个“气泡”里。
;如果字符少于3个，气泡是一个圆环，如果多于或等于3个字符，气泡是一个椭园。
;文本和气泡以同样角度延伸于旁注线，“气泡”放置到指定的层。

(defun C:BALLOON
  (/ tmp ts th nh ip sp ali le errexit bx acadver
     LBLOCK BLAYER TEXTGAP CHARWIDTH BWIDTH)
    (setq LBLOCK T)        ;“气泡”创建为块，除非这里LBLOCK设为nil
    (setq BLAYER "sdim")   ;放置“气泡”的图层："XXXX"=放置在层XXXX，nil=使用当前层
    (setq TEXTGAP 0.8)     ;希望的文本和“气泡”的间距（1单位=尺寸文本高）
    (setq CHARWIDTH 1.0)   ;1个单位高字符的平均宽度（仅用于R11）
    (setq BWIDTH 0.04)     ;“气泡”线宽：nil=无宽度（1单位=尺寸文本高，如果气泡是椭圆，无效，且在R13中PELLIPSE=0）
  (setq acadver (read (substr (getvar "ACADVER") 1 2)))
  (if (/= (type acadver) 'INT) (setq acadver 0))

  (defun errexit (s)
    (princ "\n错误：  ")
    (princ s)
    (restore)
  )

  (defun bx ()
    (if le (entdel le))
    (setvar "CMDECHO" (car oldvar))
    (setvar "BLIPMODE" (cadr oldvar))
    (setvar "OSMODE" (nth 2 oldvar))
    (setvar "CLAYER" (nth 3 oldvar))
    (setvar "DONUTID" (nth 4 oldvar))
    (setvar "DONUTOD" (nth 5 oldvar))
    (setq *error* olderr)
    (princ)
  )
  ;Main Program
  (setq T (not nil))
  (setq olderr  *error*
        restore bx
        *error* errexit
  )
  (setq oldvar 
    (list 
      (getvar "CMDECHO") 
      (getvar "BLIPMODE") 
      (getvar "OSMODE")
      (getvar "CLAYER")
      (getvar "DONUTID")
      (getvar "DONUTOD")
    )
  )
  (setvar "CMDECHO" 0)
  (setvar "BLIPMODE" 0)
  (setvar "OSMODE" 0)
  (terpri)
  (if (= acadver 11)            ;是R11吗？

    (defun textbox (elist)      ;如果是，定义一个定制的文本框函数
      (list
        '(0 0 0)
        (list
          (* (strlen (cdr (assoc 1 elist))) (cdr (assoc 40 elist)) CHARWIDTH)
          (cdr (assoc 40 elist))
          0
        )
      )
    )
  )
  (if 
    (= 0 
      (setq th 
        (cdr (assoc '40 (tblsearch "style" (getvar "textstyle"))))
      )
    ) 
    (setq nh (setq th (* (getvar "DIMTXT") (getvar "DIMSCALE"))))
    (setq nh nil)
  )
  (if BLAYER  
    (command "._LAYER"
      (if (tblsearch "LAYER" BLAYER) "_S" "_M")
      BLAYER
      ""
    )
  )
  (if (setq ip (setq sp (getpoint "拾取旁注线起点： ")))
    (progn
      (entmake (list '(0 . "POINT") (cons 10 (trans sp 1 0))))
      (setq le (entlast))
      (command "._DIM1" "_LEADER")
      (setvar "CMDECHO" 1)
      (command sp)
      (while
        (progn 
          (initget 128)
          (setq sp (getpoint sp))
        )
        (command sp)
      )
      (setvar "CMDECHO" 0)
      (command)
      (setq sp (trans (cdr (assoc '11 (entget (entlast)))) 0 1))
      (setq ali (angle (trans (cdr (assoc '10 (entget (entlast)))) 0 1) sp))  
      (setq tmp (getstring T "键入文本：  "))
      (setq ts (textbox (list (cons '1 tmp) (cons '40 th))))
      (setq ts 
        (list 
          (+ (- (car (cadr ts)) (car (car ts))) (* 2 TEXTGAP th))
          (* 3 TEXTGAP th)
        )
      )
      (command "._TEXT"
               "_M"
               (polar 
                 sp 
                 ali 
                 (* 0.5 (if (<= (strlen tmp) 2) (cadr ts) (car ts))) 
               )
      )
      (if nh (command th))
      (command 
        (if (<= (strlen tmp) 2)
          '0
          (rtd
            (if 
              (and (< ali (* 3 (/ pi 2))) (> ali (/ pi 2))) 
              (+ ali pi) 
              ali
            )
          )
        )
        tmp
      )
      (if (<= (strlen tmp) 2)
        (command "._DONUT" 
                 (cadr ts) 
                 (cadr ts) 
                 (polar 
                   sp 
                   ali 
                   (* 0.5 (if (<= (strlen tmp) 2) (cadr ts) (car ts))) 
                 )
                 ""
        )
        (command "._ELLIPSE" 
                 sp 
                 (polar sp ali (if (<= (strlen tmp) 2) (cadr ts) (car ts)))
                 (/ (cadr ts) 2)
        )
      )
      (if 
        (and BWIDTH
             (> BWIDTH 0)
             (not (and (= acadver 13) (zerop (getvar "PELLIPSE")) (> (strlen tmp) 2)))
        ) 
        (command "._PEDIT" (entlast) "W" (* th BWIDTH) "X")
      )
      (if LBLOCK
        (progn
          (entmake (list 
            (cons '0 "BLOCK") 
            (cons '2 "*U") 
            (cons '70 1) 
            (cons '10 ip)
          ))
          (setq th (setq tmp le))
          (while (setq tmp (entnext tmp))
            (entmake (entget tmp))
          ) 
          (setq tmp (entmake (list (cons '0 "ENDBLK"))))
          (while (setq th (entnext th))
            (entdel th)
          ) 
          (entdel le)
          (setq le nil)
          (entmake (list 
            (cons '0 "INSERT") 
            (cons '2 tmp) 
            (cons '10 ip)
          ))
        )
      )   
    )  
  )  
  (restore)
)