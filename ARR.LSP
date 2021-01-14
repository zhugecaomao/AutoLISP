DEFUN C:ARROWER
(setq n (getstring "\nEnter name: "))
(SETQ AN (STRCAT "C:/acad/HON/N/ARROWER" N))
(COMMAND "INSERT" AN "\\" "\\")
