(defun c:bakhid ()
(setvar "osmode" 32)
(setq b (getpoint "break point :"))
(setvar "osmode" 0)
(prompt "select object: ")
(command "break" pause "f" b b)
(prompt "wich one change : ")
(command "select" pause)
(command "change" "p" "" "la" "3")
(princ)
)
