(DEFUN C:RECIR ()
(SETQ P0 (GETPOINT "Select Circle Center Point "))
(repeat 5
(command "circle" p0 pause )
)(princ))
