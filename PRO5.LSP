; MODES
; System variable save
(defun modes (a)
   (setq MLST nil)
   (repeat (length a)
      (setq MLST (append MLST (list (list (car a) (getvar (car a))))))
      (setq a (cdr a)) ) )
;--------------------------------------
; System variable restore
(defun moder ()
   (repeat (length MLST)
      (setvar (caar MLST) (cadar MLST))
      (setq MLST (cdr MLST)) ) )
;--------------------------------------
; Delta x y
(defun dxy (p dx dy)
  (list
     (+ dx (car p))
     (+ dy (cadr p)) ) )
;--------------------------------------
; Item from association list
(defun item (n alist)
  (cdr (assoc n alist) ) )
;--------------------------------------
; Midpoint between two points
(defun midpoint (p1 p2)
  (mapcar
      '(lambda (x1 x2)
	       (* 0.5 (+ x1 x2)))
       p1 p2) )
;--------------------------------------
; TRIM entities on points outside boundary
(defun trim (ename p)
   (setq fuzz 1E-6)
   (if (not
	  (and
	     (<= (- x0 fuzz) (car p)  (+ x2 fuzz))
	     (<= (- y0 fuzz) (cadr p) (+ y2 fuzz))))
       (progn
	 (command (list ename p))
	 T) ) )
;--------------------------------------
; TRIM ARC IFF quadrant point is on arc
(defun trimarc (ename cen rad sa ea quad)
   (if (or
	  (<= sa quad ea)
	  (<= sa (+ quad d360) ea) )
	(trim ename (polar cen quad rad)) ) )
;--------------------------------------
; Crossing Selection
(defun sscross (p0 p2 / ss1 ss2)
      (setq
	 ss1 (ssget "c" p0 p2)
	 ss2 (ssget "w" p0 p2) )
      (if (/= (sslength ss1) (sslength ss2))
	 (progn
	     (command "select" ss1 "r" ss2 "")
	  (setq
	       ss1 nil
	       ss2 nil )
	      (ssget "p") ) ) )
;--------------------------------------
; Identify entities
(defun id (ent / ename etype)
   (setq
      ename (item -1 ent)
      etype (item 0 ent)
   )
   (if (= etype "ARC")
      (list ename etype (item 50 ent) (item 51 ent)) ; sa & ea
      (list ename etype)
   )
)
;--------------------------------------
; CLIP
(defun c:clip ( / myerror ss1 ss2 trimmed)
;
; ---------- Internal error handler
      (defun myerror (s)
	 (if (/= S "Function cancelled")
	    (princ (strcat "\nError: " s)) )
	 (command)
	 (command)
	 (command "undo" "end" "undo" "back")
	 (moder)
	 (setq *error* olderr)
	 (princ) )
; ---------- Initialize
   (setq
      olderr   *error*
      *error*  myerror
      d0   0.0
      d90  (* 0.5 pi)
      d180 pi
      d270 (* 1.5 pi)
      d360 (* 2.0 pi) )
   (modes '("CMDECHO" "HIGHLIGHT" "BLIPMODE" "OSMODE"))
   (setvar "cmdecho" 0)
   (setvar "blipmode" 0)
   (setvar "osmode" 0)
   (setq hm (getvar "highlight"))
   (command "undo" "mark")
   (command "layer" "set" "0" "on" "0" "")
   ;
   ; ---------- get clip box
   (setq
      p0  (getpoint "\nFirst corner: ")
      ok  p0 )
   (if ok
     (progn
       (initget (+ 1 32)) ; disallow nulls, draw crossing box
       (setq
	  p2  (getcorner p0 "Other corner: ")
	  p1  (list (car p2) (cadr p0))
	  p3  (list (car p0) (cadr p2)) )
       (if (setq ss1 (ssget "c" p0 p2))
	  (setq ok T)
	  (progn
	     (setq ok nil)
	     (princ "\nNothing selected!") ) ) ) )
   (if ok
     (progn
       ; ---------- draw clip box
       (setq midp (midpoint p0 p2))
       (command "pline" p0 "w" 0 0 p1 p2 p3 "c")
       (setq polyent (entlast))
       ;
       ; ---------- mark the last entity in the drawing
       (command "point" "0,0")
       (setq lastent (entlast))
       (entdel lastent)
       ;
       ; ----------- move the clip to one side
       (princ "\nLocation of clip: ")
       (command "move" polyent "" midp pause)
       (setq newpnt (getvar "lastpoint"))
       (while (equal newpnt midp)
	 (command "undo" "1")
	 (princ "\nLocation of clip: ")
	 (command "move" polyent "" midp pause)
	 (setq newpnt (getvar "lastpoint"))
       )
       (command "pline" p0 "w" 0 0 p1 p2 p3 "c")
       (setvar "highlight" 0)
       (command "copy" ss1 "" midp newpnt)
       (setvar "highlight" hm)
       ;
       ; ----------- get the new clip boundaries
       (setq
	  ename (entnext polyent)
	  p0	(item 10 (entget ename))
	  ename (entnext (entnext ename))
	  p2	(item 10 (entget ename))
	  x0	(car p0)
	  x2	(car p2)
	  y0	(cadr p0)
	  y2	(cadr p2) )
       (if (< x2 x0)
	 (setq
	    x0	(car p2)
	    x2	(car p0) ) )
       (if (< y2 y0)
	 (setq
	   y0 (cadr p2)
	   y2 (cadr p0) ) )
       ; ---------- explode everything we can, gather what we can't
       (setq
	  ename lastent
	  ss2	(ssadd) )
       (princ "\nGathering data... Please wait...")
       (while (setq ename (entnext ename))
	  (setq
	     ent (entget ename)
	     etype (item 0 ent) )
	  (if (= hm 1) (redraw ename 3)) ; highlight entity
	  (cond
	     ((= etype "INSERT")
	      (if (and (equal (item 41 ent) (item 42 ent))
		       (equal (item 41 ent) (item 43 ent)))
		 (command "explode" ename)
		 (ssadd ename ss2) ) )
	     ((member etype '("POLYLINE" "DIMENSION" "INSERT"))
	      (command "explode" ename) )
	     ((ssadd ename ss2) ) ) )
       ; ---------- remove everything outside the clip box
       (setq
	 ss1 (ssget "c" p0 p2) )
       (command "erase" ss2 "r" ss1 "")) )
   ; ---------- do the trimming
   (setq trimmed nil) ; list of trimmed circles, arcs
   (while ok
      ; ---------- form a selection set of objects
      ; 	   crossing the border
      (setq
	 ok  nil
	 i   0
	 ss1 (sscross p0 p2)
	 l   (if ss1
		(sslength ss1)
		0 ) )
      ; ---------- trim each entity crossing the border
      (if (> l 0)
	 (command "trim" polyent "")  )
      (while (< i l)
	 (setq
	    ename (ssname ss1 i)
	    ent   (entget ename)
	    etype (item 0 ent) )
	 (if (not (member (id ent) trimmed)) ; if we trimmed this exact entity
	     (progn			     ;	don't trim it again
		(setq trimmed (cons (id ent) trimmed))
		(cond
		   ((= etype "LINE") ; trim endpoints
		    (trim ename (item 10 ent))
		    (trim ename (item 11 ent)) )
		   ((= etype "CIRCLE")
		    (setq
		       cen (item 10 ent)
		       rad (item 40 ent)
		       ok  T )
		    (cond ; trim first quadrant outside border
		     ( (trim ename (dxy cen rad     0.0   ))   )
		     ( (trim ename (dxy cen 0.0     rad   ))   )
		     ( (trim ename (dxy cen (- rad) 0.0   ))   )
		     ( (trim ename (dxy cen 0.0     (- rad)))  )  ) )
		   ((= etype "ARC")
		    (setq
		       cen (item 10 ent)
		       rad (item 40 ent)
		       sa  (item 50 ent)
		       ea  (item 51 ent)
		       ok  T )
		    (if (> sa ea)
		       (setq ea (+ ea d360)) )
		    (cond ; trim first endpoint or quadrant outside border
		      ((trim ename (polar cen sa rad))	     )
		      ((trim ename (polar cen ea rad))	     )
		      ((trimarc ename cen rad sa ea d0)      )
		      ((trimarc ename cen rad sa ea d90)     )
		      ((trimarc ename cen rad sa ea d180)    )
		      ((trimarc ename cen rad sa ea d270)    ) ) ) ) ) )
	 (setq i (1+ i)) )
      (if (> l 0) (command "")) )

   ;--------- Drawing border on old position

   (setq p6 (list (car p3) (cadr p1))
	 p7 (list (car p1) (cadr p3)))
   (command "pline" p1 "w" 0 0 p6 p3 p7 "c")
   ; ---------- erase any lines, circles, or arcs we left behind
   (setq
      i   0
      ss1 (sscross p0 p2)
      l   (if ss1
	     (sslength ss1)
	     0 ) )
   (while (< i l)
      (setq
	 ename (ssname ss1 i)
	 ent   (entget ename)
	 etype (item 0 ent) )
      (if (member etype '("LINE" "CIRCLE" "ARC"))
	 (entdel ename) )
      (setq i (1+ i)) )
   ;
   ; scale the clip
   (setvar "highlight" 0)
   (initget (+ 2 4)) ; disallow negative and zero inputs
   (if (setq sf (getreal "\nScale factor <1.0000>: "))
     (command "scale" "c" p0 p2 "" newpnt sf) )
   (moder)			      ; Restore saved modes
   (setq *error* olderr)	      ; Restore old *error* handler
   (princ)
;
)
