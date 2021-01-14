(defun C:ponv(/ vpt)
(setq vpt(list(getvar "vpointx")(getvar "vpointy")
	(getvar "vpointz")))
	(command "dview" "" "p0" "0,0,0" vpt "d" "" "")
)
