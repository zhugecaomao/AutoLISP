(defun c:xy(/ htext)
   (setq htext (getvar "textsize"))
   (setq h (* 0.8 htext))
   (command "osnap" "inter,end")
   (setq p0 (getpoint "\pick the base point"))
   (command "osnap"  "none")
   (setq p1 (getpoint "\pick the dim line"))
   (setq p2 (getpoint "\pick the dim line"))
               (setq p0x (car p0))     (setq sx (rtos p0x 2 3))   (setq sx (strcat "y" sx))
               (setq p0y (cadr p0))    (setq sy (rtos p0y 2 3))   (setq sy (strcat "x" sy))
               (setq p1x (car p1))
               (setq p1y (cadr p1))
               (setq p2x (car p2))   
               (setq p2y (cadr p2))   
          (if (< p1x p2x)  (progn      
                                 (setq p2x (+ p1x (* 10 h)))
                                 (setq p2y p1y)
                                 (setq t1x (+ p1x h)) 
                                 (setq t1y (+ p1y (/ h 2)))
                                 (setq t2x (+ p1x h))
                                 (setq t2y (- p1y (* h 1.5)))
                            )
                            (progn
                                  (setq p2x (- p1x (* 10 h)))
                                  (setq p2y p1y)
                                  (setq t1x (+ p2x h))
                                  (setq t1y (+ p2y (/ h 2)))
                                  (setq t2x (+ p2x h))
                                  (setq t2y (- p2y (* h 1.5)))
                             )
                  )
   (command "pline" p0 p1 (list p2x p2y) "")       
   
   (command "text" (list t1x t1y)  0 sy)
   (command "text" (list t2x t2y)  0 sx)

   )



;mypoly工具于2001年9月12日完成

(defun c:mypoly(/ pp e)
       (print "土地使用公建，线宽w=2.5,偏移ww=3.0,地块线宽1.6")
       (print "用地布局公建，线宽w=1.6,偏移ww=2.5,地块线宽0.8")
       (print "用地布局居住，线宽w=2.5,偏移ww=3.0,地块线宽0.8")
       (print "   ")
       (if (= w nil)   (setq w (getreal "输入线宽度w=")) )
       (if (= ww nil)  (setq ww  (getreal "输入偏移宽度ww") ))
       (setq pp (getpoint "确定地块点"))
       (command "bpoly" pp "")
       (setq e (ssget "l"))
       (command "offset" ww e pp "")
       (command "erase" e "")
       (setq e (ssget "l"))
       (command "pedit" e "w" w "")
     
)


;mydzkk工具于2001年9月13日完成
(defun c:mydzkk(/ w pp e p1 p2 p3 p4 ww s1 s2)
       (setq s1 (getint "输入距离A:(100)"))
       (setq s2 (getint "输入距离B:(40)"))
       (if (= s1 nil)   (setq s1 100))
       (if (= s2 nil)   (setq s2 40) )
        (setq p1 (getpoint "first point"))
        (setq p2 (getpoint "second point"))
        (setq p3 (getpoint "third point"))
        (setq p4 (getpoint "fouth point"))      

       (setq p1 (polar p2 (angle p2 p1) s1))      
       (setq p4 (polar p3 (angle p3 p4) s2))
        
       (setq w 2.2)  (setq ww 3) (setq pp (getpoint "点取偏移点"))  
       (command "pline" p1 "w" w w p2 p3 p4 "")

       (setq e (ssget "l"))
       (command "offset" ww e pp "")
       (command "erase" e "")

)



(defun c:lo( )
       (setq p (ssget))
       (command "pedit" p "c" "")

)