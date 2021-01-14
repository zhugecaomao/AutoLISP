(defun cscl ( / cl_oe cl_oc en la ss)
  (defun cl_er (s)
    (if (/= s "Function cancelled")
      (if (=s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (eval(read U:E))
    (if cl_oe
      (setq *error* cl_oe)
    )
    (if cl_oc (setvar "cmdecho" cl_oc))
    (princ)
  )
  (if *error*
    (setq cl_oe *error* *error* cl_er)
    (setq *error* cl_er)
  )
  (setq U:G "(command \"undo\" \"group\")"
        U:E "(command \"undo\" \"en\")"
  )
  (setq cl_oc (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (eval(read U:G))
  (princ (strcat "\n            极速改层 V1.0 (c) 1999.1.11 by 陈松 -- 深圳. "))
  (cl_ol)
  (if cl_oe (setq *error* cl_oe))
  (eval(read U:E))
  (if cl_oc (setvar "cmdecho" cl_oc))
  (princ)
)

;;; The cl_ol() definition
;;;
(defun cl_ol()
  (prompt "\n请选择要改变图层属性的物体: ")
  (setq ss(ssget))
  (if ss
    (progn
      (while (null en)
        (setq en (entsel "\n请选择改变后图层所在的物体: "))
      )
      (setq la(cdr (assoc 8 (entget (car en)))))
      (command "_change" ss "" "properties" "layer" la "")
    )
  )
)
;;;
;;; The C: function definition
;;;
(defun c:cl     () (cscl))
(princ "\n\tC:CSCL 已经加载. 键入 CL 执行命令.")
(princ)
