(Defun C:Runner()
(Setvar "Cmdecho" 0)
(Setq P1 (Getpoint "\nIsertion point of runner: "))
(Setq A (Getdist P1 "\nRadius: "))
(Setq B (Getdist P1 "\nLength: "))
(Setq C (Getangle P1 "\nAngle: "))
(Command "Arc" "C" P1
(Polar P1 (+ (/ Pi 2)  C) A) "A" "180")
(Command "Line" ""
(Polar (Getvar "Lastpoint") A B) "")
(Command "Arc" ""
(Polar (Getvar "Lastpoint") (+ (/ Pi 2) C)
(* 2 A)))
(Command "Line" "" (Polar (Getvar "Lastpoint")
(+ Pi C) B) ""))
