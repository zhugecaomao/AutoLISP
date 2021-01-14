;		      MOLD-DIM PROGRAM
;
;   THIS PROGRAM IS WRITEED BY CHANG,YU CHANG. LICENCE IS BELONG TO
;  METAL TECH CO;LTD, SO, THIS PROGRAM MAY NOT BE ASSIGNED OR TRANSFERRED
;  BY PURCHASER WITHOUT THE PRIOR WRITTEN CONSENT OF METAL TECH.
;
;
;
(prompt "NOW Loading Mold Dim ...")
;  *********************** MOLD-DIM **************************
(prompt "..")
;  TO DEFUN ORIGIN POINT:
( defun ORIGIN ()
	(setq op (getpoint "\nCHOOSE ORIGIN POINT:"))
)
;  -----------------------------------------------------------
(prompt "..")
;  TO DEFUN DIM TEXT HEIGHT:
( defun TEXTH ()
	(setq txt (getreal "\nDIM TEXT HEIGHT:"))
)
;  -----------------------------------------------------------
;  TO CHOOSE NUMBER OF DIGITS
(prompt "..")
( defun DIGIT ()
	(IF (= (setq a (getint "\nNUMBER OF DIGITS/<2>:")) NIL)
	    (setq a 2))
)
;  -----------------------------------------------------------
(prompt "..")
;  TO GET EXTENSION LINE POINT:
( defun EXTLI ()
	(setq ep (getpoint "\nPICK UP EXTENSION LINE:"))
)
;  -----------------------------------------------------------
(prompt "..")
;TO DEFUN TURN FUNCTION
(defun turni()
      (command "osnap" "endpoint")
	(setq p1 (getpoint "\nWHICH POINT TO DIM:"))
	(setq dis (RTOS (abs (- (cadr p1) (cadr op))) 2 A))
      (if (> (car p1) (car op)) (setq sp (list (+ (car p1) 1) (cadr p1)))
	(setq sp (list (- (car p1) 1) (cadr p1))))
	(setq p2 (getpoint "\nCHOOSE A POINT TO TURN : "))
	(setq enp (list (car ep) (cadr p2))) (command "osnap" "non")
	  (command "line" sp p2 enp "")
   (if (> (car ep) (car op)) (setq enp (list (+ (car enp) 2)
     (- (cadr enp) (/ txt 2)))) (setq enp (list (- (car enp) 2) (- (cadr enp)
     (/ txt 2)))))(if (> (car ep) (car op)) (command "text" enp txt "0" dis)
		    (command "text" "r" enp txt "0" dis))
)
;  -----------------------------------------------------------
(prompt "..")
;  TO DRAW HER-DIM AND CONT.
(defun HERI ()
	(command "osnap" "endpoint")
	(setq p1 (getpoint "\nWHICH POINT TO DIM:"))
	(setq dis (RTOS (abs (- (cadr p1) (cadr op))) 2 A))
	(if (> (car p1) (car op)) (setq sp (list (+ (car p1) 1) (cadr p1)))
	     (setq sp (list (- (car p1) 1) (cadr p1))))
	(setq enp (list (car ep) (cadr p1))) (command "osnap" "non")
	(command "line" sp enp "")
(if (> (car ep) (car op)) (setq enp (list (+ (car enp) 2) (- (cadr enp)
 (/ txt 2))))  (setq enp (list (- (car enp) 2) (- (cadr enp)
(/ txt 2)))))	     (if (> (car ep) (car op)) (command "text" enp txt "0" dis)
		  (command "text" "r" enp txt "0" dis))
	(setq qq 1)
	(while (< qq 2) (command "osnap" "endpoint")
	      (setq p1 (getpoint "\nWHICH POINT TO DIM:"))
	      (if (/= p1 nil) (progn
			       (setq dis (RTOS (abs (- (cadr p1) (cadr op))) 2
A))
		    (if (> (car p1) (car op)) (setq sp (list (+ (car p1) 1) (cadr p1)))
			 (setq sp (list (- (car p1) 1) (cadr p1))))
	       (setq enp (list (car ep) (cadr p1))) (command "osnap" "non")
		    (command "line" sp enp "")
      (if (> (car ep) (car op)) (setq enp (list (+ (car enp) 2) (- (cadr enp)
(/ txt 2))))	 (setq enp (list (- (car enp) 2) (- (cadr enp)
 (/ txt 2)))))
		    (if (> (car ep) (car op)) (command "text" enp txt "0" dis)
		   (command "text" "r" enp txt "0" dis))) (setq qq 3))
	  ) (command "osnap" "non")
)
;
; -----------------------------------------------------------------------------
;TO DRAW VERT-TURN DIM
(prompt "..")
(defun turnv ()
    (command "osnap" "endpoint")
      (setq p1 (getpoint "\nWHICH POINT TO DIM:"))
      (setq dis (RTOS (abs (- (car p1) (car op))) 2 A))
    (if (> (cadr p1) (cadr op)) (setq sp (list (car p1) (+ (cadr p1) 1)))
    (setq sp (list (car p1) (- (cadr p1) 1))))
      (setq p2 (getpoint "\nCHOOSE A POINT TO TURN: "))
      (setq enp (list (car p2) (cadr ep))) (command "osnap" "non")
      (command "line" sp p2 enp "")
     (if (> (cadr ep) (cadr op)) (setq enp (list (+ (car enp) (/ txt 2)) (+
(cadr enp) 2)))    (setq enp (list (+ (car enp) (/ txt 2)) (- (cadr enp) 2))))
     (if (> (cadr ep) (cadr op)) (command "text" enp txt "90" dis)
	      (command "text" "r" enp txt "90" dis))
)
;------------------------------------------------------------------------------
(prompt "..")
;  TO DRAW VERI-DIM AND CONT.
(defun VERI ()
	(command "osnap" "endpoint")
	(setq p1 (getpoint "\nWHICH POINT TO DIM:"))
	(setq dis (RTOS (abs (- (car p1) (car op))) 2 A))
	(if (> (cadr p1) (cadr op)) (setq sp (list (car p1) (+ (cadr p1)
1)))		  (setq sp (list (car p1) (- (cadr p1) 1))))
	(setq enp (list (car p1) (cadr ep))) (command "osnap" "non")
	(command "line" sp enp "")
	(if (> (cadr ep) (cadr op)) (setq enp (list (+ (car enp) (/ txt 2)) (+
(cadr enp) 2)))  (setq enp (list (+ (car enp) (/ txt 2)) (- (cadr enp) 2))))
    (if (> (cadr ep) (cadr op)) (command "text" enp txt "90" dis)
			   (command "text" "r" enp txt "90" dis))
	(setq qq 1)
	(while (< qq 2) (command "osnap" "endpoint")
	   (setq p1 (getpoint "\nWHICH POINT TO DIM:"))
	   (if (/= p1 nil) (progn
	  (setq dis (RTOS (abs (- (car p1) (car op))) 2 A))
	  (if (> (cadr p1) (cadr op)) (setq sp (list (car p1) (+ (cadr p1)
1)))		    (setq sp (list (car p1) (- (cadr p1) 1))))
	  (setq enp (list (car p1) (cadr ep))) (command "osnap" "non")
	  (command "line" sp enp "")
	  (if (> (cadr ep) (cadr op)) (setq enp (list (+ (car enp) (/ txt 2))
(+ (cadr enp) 2))) (setq enp (list (+ (car enp) (/ txt 2)) (- (cadr enp) 2))))
	 (if (> (cadr ep) (cadr op)) (command "text" enp txt "90" dis)
		(command "text" "r" enp txt "90" dis))) (setq qq 3))
	  ) (command "osnap" "non")
)
;  ----------------------------------------------------------------------------
(prompt "..")
( DEFUN C:MDIMCONT ()
    (ORIGIN)
    (TEXTH)
    (DIGIT)
    (EXTLI)
) (prompt "loaded") (princ)
