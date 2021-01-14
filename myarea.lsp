;;From 韩光聪 四川 . 成都
(defun c:myarea()
   (setvar "osmode" 0)
   (setq pt (getpoint "\\n选取点："))
   (while pt 
       (setvar "cecolor" "1")
       (command "bpoly" pt "")
       (setq en (entlast))
       (if (/= en nil)
          (progn
             (command "area" "o" en)
             (setq aa (getvar "area"))
             (redraw en 3)
             (alert (strcat "面积:" (rtos aa 2))) 
          );end progn
       );end if
       (entdel en)
       (setvar "cecolor" "bylayer")
       (setq pt (getpoint "\\n选取点:"))
    );end while
    (prin1)
);end fun

