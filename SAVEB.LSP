defun c:saveb
(setq a1 (getvar "dwgname"))
(setq name (strcat "b:/" a1))
(command "save" name)
