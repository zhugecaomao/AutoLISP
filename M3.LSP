(defun C:zp(/ rat di)
(setq rat(getreal"\nWhat is ratio of current view distance?"))
(setq vpt(list(getvar "vpointx")(getvar "vpointy")
	(getvar "vpointz")))
(setq targ(getvar "TARGET"))
(setq DIS(* RAT(distance TARG VPT)))
	(command "dview" "" "D" DIS "")
)
