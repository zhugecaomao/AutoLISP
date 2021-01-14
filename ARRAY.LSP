(defun C:ARRY(/ ss aw cp r1 c2 an)
    (setq ss (ssget))
    (initget (+ 1 2 4) "Rectangular Fill Circle Polar")
    (setq aw (getkword "\nRectangular/Fill/Circle/Polar array (R/F/C/P): "))
    (cond ((= aw "Polar")
	   (setq cp (getpoint "\nCenter point of array: ")
		 r1 (getint "\nNumber of items: ")
		 an (getreal "\nAngle to fill (+=ccw, -=cw) <360>: ")
		 ry (getstring "\nRotate objects as they are copied? <Y> "))
	   (if (null an) (setq an 360))
	   (if (or (/= ry "N") (/= ry "n"))(setq ry "Y"))
	   (command "ARRAY" ss "" "P" cp r1 an ry)
	  );end polar
	  ((= aw "Circle")
	   (setq cp (getpoint "\nCenter point of array: ")
		 an (getreal "\nAngle between items (+=ccw, -=cw): "))
	   (if (or (= an 360) (= an 0))
	       (prompt "\nValue must be nonzero.")
	       (progn
		  (setq r1 (getint "\nNumber of items or -(degrees to fill): "))
		  (setq ry (getstring "Rotate objects as they are copied? <N> "))
		  (if (or (/= ry "N") (/= ry "n"))(setq ry "Y"))
		  (command "ARRAY" ss "" "C" cp an r1 ry)
	       )
	   );end if
	  );end center
	  ((or (= aw "Rectangular") (= aw "Fill"))
	   (setq r1 (getint "\nNumber of rows (---) <1>: "))
	   (if (null r1) (setq r1 1))
	   (setq c2 (getint "\nNumber of columns (|||) <1>: "))
	   (if (null c2) (setq c2 1))
	   (if (and (= r1 1) (= c2 1))
	       (prompt "\nOne-element array, nothing to do. ")
	       (progn
		 (if (= aw "Rectangular")
		     (cond ((and (/= r1 1) (= c2 1))
			    (setq dr (getdist "\nDistance between rows: "))
			   )
			   ((and (= r1 1) (/= c2 1))
			    (setq dr (getdist "\nDistance between columns: "))
			   )
			  (T (setq dr (getdist "\nDistance between rows: "))
			     (setq dc (getdist "\nDistance between columns: "))
			  )
		     );end cond
		     (progn
		      (cond ((and (/= r1 1) (= c2 1))
			    (setq dr (getdist "\nDistance of row: "))
			    )
			    ((and (= r1 1) (/= c2 1))
			     (setq dr (getdist "\nDistance of column: "))
			    )
			    (T (setq dr (getdist "\nDistance of row: "))
			       (setq dc (getdist "\nDistance of column: "))
			    )
		      );end cond
		      (setq dr (/ dr r1))
		      (if (/= dc null) (setq dc (/ dc c2)))
		     );end progn
		 );end if
		 (setq an (getangle "\nRotation angle <0>:"))
		   (if (null an) (setq an 0))
	       );end of progn
	   );end if
	   (setq sn (getvar "SNAPANG"))
	   (setvar "SNAPANG" an)
	   (if (or (= r1 1) (= c2 1))
	       (COMMAND "ARRAY" ss "" "R" r1 c2 dr)
	       (command "ARRAY" ss "" "R" r1 c2 dr dc)
	   )
	   (setvar "SNAPANG" sn)
	  );end r & f
    );end cond
    (princ)
)
