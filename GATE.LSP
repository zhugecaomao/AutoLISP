(defun c:gate ()
       (command "vslide" "gate")
       (setq d (getreal "\nEnter d Size:"))
          (setq l (getreal "\nEnter Length:"))
       (command "redraw")
          (setq op (getpoint "\nINSERTION POINT?"))
        (command "osnap" "none" )
        (setq a (getangle op "\nANGLE= "))
        (setq a (+ a (/ pi 2.0)))
                (setq p1 (polar op a (/ d 2.0)))
                (setq p2 (polar p1 (- a (dtr 90)) (- l d)))
        (command "layer" "set" "draw" "")
        (command "line" p1 p2 ""
        "arc" "" (setq p3 (polar p2 (- a (dtr 180)) d)) ""
        "line" "" (setq p4 (polar p3 (- a (dtr 270)) (- l d))) ""
        "arc" "" p1 "")
)
