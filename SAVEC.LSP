defun c:savec
(setq a1 (getvar "dwgname"))
(SETQ A2 (GETVAR "DWGPREFIX"))
(setq name (strcat A2 a1))
(command "save" name "Y")
