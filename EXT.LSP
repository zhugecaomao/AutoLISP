defun c:ext
(Setq P1 (Osnap (Getpoint "Touch line") "NEAR"))
(Setq P5 (Osnap P1 "endp"))
(Setq A (Angle P1 P5))
(Setq P3 (Getdist P1 "Enter extension distance:"))
(Setq P4 (Polar P5 A P3))
(COMMAND "Change" P1 "" P4 )
