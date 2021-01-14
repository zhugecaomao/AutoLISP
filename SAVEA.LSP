defun c:savea
(setq a1 (getvar "dwgname"))
(setq name (strcat "a:/" a1))
(command "save" name)
