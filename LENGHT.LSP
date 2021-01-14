;*****************************************************
;********** THIS IS BELT LIGET MECHINE LAW ***********
;**********  PROGRAM DESIGN HUANG YU CHIA  ***********
;**********      DESIGN DATA 89-03-13      ***********
;*****************************************************
(defun c:lig (/ e d c l x y z)
(setq  G1 (getstring "Enter Answer Belt Lenght Or Center Distance (L,C)"))
(IF (or (= G1 "L")(= G1 "l"))
(PROGN
(setq  T1 (getstring "Enter Output Units mm or in (M,I)"))
(IF (or (= T1 "M")(= T1 "m"))
(PROGN
(setq  Y1 (getstring "Enter is Open or Int (O,I) "))
(setq e (getreal "\nEnter Big Cir =  "))          ;BIG CIR DIAMETER
(setq d (getreal "\nEnter Small Cir =  "))        ;SMALL CIR DIAMETER
(setq c (getreal "\nEnter Center-Ceneter =  "))   ;CENTER-CENTER
(IF (or (= Y1 "O")(= Y1 "o"))
(PROGN
(setq x (* (/ pi 2)(+ e d)))
(setq y (* 2 c))
(setq z (/(*(- e d) (- e d)) (* 4 c)))
(setq l2 (+ x y z ))                               ;BELT LIGHT
(prompt " Belt Lenght= ")
(prin1 l2)(prompt " mm ")
))
(IF (or (= Y1 "I")(= Y1 "i"))
(PROGN
(setq x (*(/ pi 2)(+ e d)))
(setq y (* 2 c))
(setq z1 (/(*(+ e d) (+ e d)) (* 4 c)))
(setq li (+ x y z1 ))
(prompt " Belt Lenght= ")
(prin1 li)(prompt " mm ")
))
))
(IF (or (= T1 "I")(= T1 "i"))
(progn
(setq  Y1 (getstring "Enter is Open or Int (O,I) "))
(setq e (getreal "\nEnter Big Cir =  "))
(setq d (getreal "\nEnter Small Cir =  "))
(setq c (getreal "\nEnter Center-Ceneter =  "))
(IF (or (= Y1 "O")(= Y1 "o"))
(PROGN
(setq x (*(/ pi 2)(+ e d)))
(setq y (* 2 c))
(setq z (/(*(- e d) (- e d)) (* 4 c)))
(setq l2 (/(+ x y z ) 25.4))
(prompt " Belt Lenght= ")
(prin1 l2 )(prompt " inch ")
))
(IF (or (= Y1 "I")(= Y1 "i"))
(PROGN
(setq x (*(/ pi 2)(+ e d)))
(setq y (* 2 c))
(setq z1 (/(*(+ e d) (+ e d)) (* 4 c)))
(setq li (/(+ x y z1 ) 25.4))
(prompt " Belt Lenght= ")
(prin1 li)(prompt " inch ")
))
))
))
(IF (or (= G1 "C")(= G1 "c"))
(PROGN
(setq  T1 (getstring "Enter Output Units mm or in (M,I)"))
(IF (or (= T1 "M")(= T1 "m"))
(PROGN
(setq  Y1 (getstring "Enter is Open or Int (O,I) "))
(setq e (getreal "\nEnter Big Cir =  "))          ;BIG CIR DIAMETER
(setq d (getreal "\nEnter Small Cir =  "))        ;SMALL CIR DIAMETER
(setq l (getreal "\nEnter Belt Lenght =  "))   ;BELT LIGHT
(IF (or (= Y1 "O")(= Y1 "o"))
(PROGN
(setq x (-(* 2 l) (*(+ e d) pi)))
(setq y (sqrt (-(* x x)(* 8 (*(- e d)(- e d))))))
(setq l2 (/(+ x y ) 8 ))                               ;BELT LIGHT
(prompt " Center Distance = ")
(prin1 l2)(prompt " mm ")
))
(IF (or (= Y1 "I")(= Y1 "i"))
(PROGN
(setq x (-(* 2 l) (*(+ e d) pi)))
(setq y (sqrt (-(* x x)(* 8 (*(+ e d)(+ e d))))))
(setq li (/(+ x y ) 8 ))
(prompt " Center Distance = ")
(prin1 li)(prompt " mm ")
))
))
(IF (or (= T1 "I")(= T1 "i"))
(progn
(setq  Y1 (getstring "Enter is Open or Int (O,I) "))
(setq e (getreal "\nEnter Big Cir =  "))
(setq d (getreal "\nEnter Small Cir =  "))
(setq l (getreal "\nEnter Belt Lenght =  "))   ;BELT LIGHT
(IF (or (= Y1 "O")(= Y1 "o"))
(PROGN
(setq x (-(* 2 l) (*(+ e d) pi)))
(setq y (sqrt (-(* x x)(* 8 (*(- e d)(- e d))))))
(setq li (/(+ x y ) 8 25.4 ))
(prompt " Center Distance = ")
(prin1 li )(prompt " inch ")
))
(IF (or (= Y1 "I")(= Y1 "i"))
(PROGN
(setq x (-(* 2 l) (*(+ e d) pi)))
(setq y (sqrt (-(* x x)(* 8 (*(+ e d)(+ e d))))))
(setq li (/(+ x y ) 8 25.4 ))
(prompt " Center Distance = ")
(prin1 li)(prompt " inch ")
))
)))
))
