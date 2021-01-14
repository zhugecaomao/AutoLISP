(vmon)

;======= BASE CONFIGURATION =======
        (setq dpi (/ pi 4)
              hpi (/ pi 2)
              spi (* pi 1.5)
        )
;======= SAMEP MAIN ROUTINE =======
;ARE TWO POINT AT SAME POSITION?
;1990/03/14 BY FUH-SHARE

(defun samep (p1 p2 / x1 y1 x2 y2)
   (setq x1 (rtos (car p1))
         y1 (rtos (cadr p1))
         x2 (rtos (car p2))
         y2 (rtos (cadr p2))
   )
   (if (and (= x1 x2) (= y1 y2))
       T
       nil
   )
)
;--- END OF SAMEP ---

;======= DTR MAIN ROUTINE =======
;TRANSFER DEGREE TO RADIANS
;1990/03/15 BY FUH-SHARE

(defun dtr (d)
   (* pi (/ d 180.))
)
;--- END OF DTR ---

;======= RTD MAIN ROUTINE =======
;TRANSFER RADIANS TO DEGREE
;1990/03/15 BY FUH-SHARE

(defun rtd (r)
   (* r (/ 180 pi))
)
;--- END OF RTD ---

;======= ZEROA MAIN ROUTINE =======
;IS THE ANGLE EQUAL ZERO?
;1990/03/15 BY FUH-SHARE

;(defun zeroa (a / zr a zz)
;   (setq zr (rtos 0)
;         a (rtos a)
;         zz (rtos (* 2 pi))
;   )
;   (if (or (= a zr) (= a zz))
;       T
;       nil
;   )
;)
;---END OF ZEROA ---
;INSTEAD BY EQUALA

;======= REVERSEA MAIN ROUTINE =======
;ROTATE ANY AHGLE FROM THE PARAMETER OF ANGLE
;1990/03/15

(defun reversea (a ra)
   (rem (+ a ra) (* pi 2))
)
;--- END OF REVERSEA ---

;======= EQUALA MAIN ROUTINE =======
;ARE TWO ANGLE OF PARAMETER EQUAL?
;1990/03/16 BY FUH-SHARE
;1990/05/22 update v1.1

(defun equala (a b / zr zz)
   (setq a (rtos a)
         b (rtos b)
        zr (rtos 0)
        zz (rtos (* 2 pi))
   )
   (cond ((= b zr)
          (if (or (= a zr) (= a zz))
              T
              nil
          )
         )
      ; (if (= a b)
      ;     T   2
      ;     nil
      ; )
         ((= a zr)
          (if (or (= b zr) (= b zz))
              T
              nil
          )
         )
         (T (if (= a b)
                T
                nil
            )
         )
   )
)
;--- END OF FILE ---

;======= FTF MAIN ROUTINE =======
;DETERMINE THE DECIMAL VALUE
;IF THE VALUE BELOW FIVE CANCEL THE VALUE
;IF THE VALUE ABOVE OR EQUAL FIVE CARRY THE VALUE
;1990/03/16 BY FUH-SHARE

(defun ftf (f / fi fd)
   (setq fi (fix f)
         fd (- f fi)
   )
   (if (>= fd 0.5)
       (1+ fi)
       fi
   )
)
;--- END OF FTF ---

;======= CHEN-ERR MAIN ROUTINE =======
;1990/03/21 BY FUH-SHARE

(defun chen-err (s)
   (if (= s "null function")
       (princ (strcat "\nError: " ss))
   )
   (setvar "cmdecho" 1)
   (setvar "highlight" 1)
   (setvar "osmode" 0)
   (setq *error* olderr)
)
;--- END OF CHEN-ERR ---

;======= GETPAD MAIN ROUTINE =======
;1990/03/23 BY FUH-SHARE

(defun getpad (p1 s)
   (setq p2 (getpoint p1 s)
         a  (angle p1 p2)
         d  (distance p1 p2)
   )
)
;--- END OF GETPAD ---
;;(defun ortho ()
;;   (setvar "orthomode" (boole 6 (getvar "orthomode") 1))
;;)
;;(defun snap ()
;;   (setvar "snapmode" (boole 6 (getvar "snapmode") 1))
;;)
;;(defun s::startup ()
;;   (command "undefine" "end"
;;    command "undefine" "quit"
;;    command "dec"
;;    command "sk" "from chen>null"
;;    command "dec"
;;   )
;;)
;;(defun c:end (/ yn)
;;   (setq yn (strcase (getstring "\nAre your sure? ")))
;;   (if (= yn "Y")
;;       (command "sk" "off>null"
;;        command ".end"
;;       )
;;   )
;;)
;;(defun c:quit ()
;;   (command "sk" "off>null"
;;    command ".quit"
;;   )
;;)

;======= OFFSET MAIN ROUTINE =======
;MAKE AN OFFSET LINE
;1990-05-22 BY FUH-SHARE

(defun offset (pt1 pt2 dis / ang p)
   (setq ang (REVERSEA (angle pt1 pt2) hpi)
         pt  (polar pt2 ang dis)
         p   (polar pt1 ang dis)
   )
)
;--- END OF FILE ---

;======= +/- MAIN ROUTINE =======
;REVERSE PLUS AND MINUS
;1990-05-22 BY FUH-SHARE

(defun +/- (r)
   (if (minusp r)
       (abs r)
       (- r (* 2 r))
   )
)
;--- END OF FILE ---

;======= START MAIN ROUTINE =======
;START PROGRAM
;1990-15-24 BY FUH-SHARE

(defun start ()
   (setvar "cmdecho" 0)
   (setvar "blipmode" 0)
)
;--- END OF FILE ---
