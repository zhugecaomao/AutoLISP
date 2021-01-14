(defun c:sCR (/ siz kw len lis i4 set1 cl ltype d str hd en i2 i3 dp ang2
		po1 po2 po3 po4 po5 po6 po11 po12 ln)
   (start)
   (if (null moi) (setq moi "10"))
   (setq siz (getstring (strcat "\nENTER SIZE <" moi ">: ")))
   (if (/= siz "") (setq moi siz))
   (setq kw (strcase (substr moi 1 1)))
   (if (= kw "W")
       (INCH)
       (MM)
   )
   (TREE4)
   (setq len (getdist i3 "\nENTER LENGTH: ")
	 ln  (+ (distance i2 i3) len)
	 ln  (1+ (fix ln))
	 lis (list 4 5 6 7 8 9 10 11 12 14 16 18 20 22 25 28 30 32 35 38 40
		   45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125
		   130 140 150 160 180 190 200 220 240 260 280 300)
   )
   (if (< ln 300)
       (while (not (member ln lis)) (setq ln (1+ ln)))
   )
   (setq i4   (polar i3 ang2 len)
	 set1 (ssget "c" po11 po6)
	 set1 (ssdel en set1)
   )
   (tree7)
   (setq cl (getvar "clayer")
	 ltype (cdr (assoc 6 (tblsearch "layer" cl)))
   )
   (if (= ltype "CONTINUOUS")
       (progn
      ; (command "undo" "g")
       (TREE5)
       )
   )
)

;=== MM ===
(defun MM (/ fm rd)
   (setq fm (open "mm.dat" "r"))
   (setq d (atof moi))
   (setq str (strcat "M" moi))
   (while (null hd)
	  (setq rd (read-line fm))
	  (if (= rd (strcat moi "M"))
	      (setq hd (atof (read-line fm)))
	  )
	  (if (= rd nil)
	      (progn
		 (*ERROR* "\nERROR : SIZE NOT FOUND!")
	      )
	  )
   )
   (close fm)
)

;=== INCH ===
(defun INCH (/ fn dln dec rd)
   (setq fn (open "inch.dat" "r"))
   (setq d (substr moi 2))
   (if (= 0 (- (atof d) (fix (atof d))))
       (setq str (strcat "W" d "/8"))
       (setq str (strcat "W" (rtos (* 2 (atof d)) 2 0) "/16"))
   )
   (setq d (rtos (* (atof d) (/ 25.4 8)) 2 3))
   (setq dln (strlen d))
   (setq d (atof (substr d 1 (- dln 1))))
   (setq dec (atof (substr (rtos d) dln 1)))
   (if (>= dec 5)
       (setq d (+ d 0.01))
   )
   (while (null hd)
	  (setq rd (read-line fn))
	  (if (= rd moi)
	      (setq hd (atof (read-line fn)))
	  )
	  (if (= rd nil)
	      (progn
		 (*ERROR* "\nERROR : SIZE NOT FOUND!")
	      )
	  )
   )
   (close fn)
)

;=== TREE3 ===
(defun tree3 (s / sel ent pt eget ena)
   (while (not (setq sel (entsel s)))
	  (prompt "\nNo entity select!\007")
   )
   (setq ent (car sel)
	 pt  (cadr sel)
	 eget (entget ent)
	 ena  (cdr (assoc 0 eget))
   )
   (cond ((= ena "LINE") (setq eget eget))
	 ((= ena "POLYLINE")
	  (command "explode" sel)
	  (setq eget (entget (ssname (ssget pt) 0)))
	 )
	 (T (tree3 "\nSelect not a LINE  or POLYLINE...\007\r\nSelect again: "))
   )
)

;=== TREE4 ===
(defun tree4 (/ eg1 eg2 eg3 p1 p2 p3 p4 p5 p6 an1 an3 i1 hh hdd dd ang1)
   (setq eg1 (tree3 "\nFirst line: ")
	 p1  (cdr (assoc 10 eg1))
	 p2  (cdr (assoc 11 eg1))
	 an1 (angle p1 p2)
	 eg2 (tree3 "\nSecond line: ")
	 p3  (cdr (assoc 10 eg2))
	 p4  (cdr (assoc 11 eg2))
	 eg3 (tree3 "\nCentral line: ")
	 en  (cdr (assoc -1 eg3))
	 p5  (cdr (assoc 10 eg3))
	 p6  (cdr (assoc 11 eg3))
	 an3 (angle p5 p6)
	 i1  (inters p1 p2 p5 p6)
	 i3  (inters p3 p4 p5 p6)
	 hh  (* 1.067 d)
	 hdd (* 1.079 hd)
	 dd  (* 1.095 d)
	 dp  (* 0.85 d)
	 ang1 (- an1 an3)
	 ang2 (angle i1 i3)
   )
   (if (not (or (EQUALA (abs ang1) hpi) (EQUALA (abs ang1) spi)))
       (setq hh (+ hh (tree6)))
   )
   (setq i2   (polar i1 ang2 hh)
	 po3  (OFFSET i1 i2 (/ hdd 2))
	 po4  pt
	 po3  (inters p1 p2 po3 po4 nil)
	 po1  (OFFSET i1 i2 (+/- (/ hdd 2)))
	 po2  pt
	 po1  (inters p1 p2 po1 po2 nil)
	 po11 (OFFSET i2 i3 (/ dd 2))
	 po12 pt
	 po5  (OFFSET i2 i3 (+/- (/ dd 2)))
	 po6  pt
   )
)

;=== TREE5 ===
(defun tree5 (/ n sna)
   (setq n 0)
   (command "undo" "g")
   (while (setq sna (ssname set1 n))
	  (command "trim" "w" po5 po6 "w" po11 po12 "" (list sna i3) "")
	  (setq n (1+ n))
   )
   (command "erase" "p" "")
   (command "undo" "e")
)

;=== TREE6 ===
(defun tree6 ()
   (abs (/ hdd (* 2 (/ (sin ang1) (cos ang1)))))
)

;=== TREE7 ===
(defun tree7 (/ txt exo ptx)
   (command ;"line" po1 po2 ""
	    ;"line" po3 po4 ""
	     "line" po5 po6 ""
	     "line" po11 po12 ""
	    "insert" "scr-h" i2 hd d (- (rtd (REVERSEA ang2 pi)) 90)
	    "insert" "scr-b" i3 d (abs (distance i2 i3)) (- (rtd (REVERSEA ang2 pi)) 90)
	    "insert" "scr-s" i3 d len (+ (rtd ang2) 90)
	    "insert" "scr-e" i4 (/ dp 2) (* dp 0.497776) (+ (rtd ang2) 90)
   )
   (setq str (strcat str "X" (rtos ln 2 0))
	 txt (* (getvar "dimtxt") 1.2)
	 exo (* (getvar "dimexo") 2)
	 ptx (polar i2 ang2 exo)
   )
   (if (or (<= ang2 hpi) (> ang2 spi))
       (command "text" ptx txt (rtd ang2) str)
       (command "text" "r" ptx txt (rtd (REVERSEA ang2 pi)) str)
   )
)

;=== *ERROR* ===
(defun *ERROR* (msg)
   (princ "ERROR: ") (princ msg)
   (terpri)
   (setq test nil)
   (())
)
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
;	  a (rtos a)
;	  zz (rtos (* 2 pi))
;   )
;   (if (or (= a zr) (= a zz))
;	T
;	nil
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
      ;     T	2
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
;;	 (command "sk" "off>null"
;;	  command ".end"
;;	 )
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