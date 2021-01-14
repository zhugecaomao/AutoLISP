(defun c:bar()
(setq A(getstring "\n Enter data's filename:"))
(setq B(open A "r"))
(setq Y(getint "\n How many COLUMN :"))
(setq P(getpoint "\n Enter insert point:"))
(setq C 1)
(repeat Y
(setq D (read-line B))
(command "text" P 3 0 (substr D 1))
(setq P(list (car P) (- (cadr P) 5)))
(terpri)
))
