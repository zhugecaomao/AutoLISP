
;      ZOOM to the extents of the virtual screen

(defun C:ZE ()
   (command "ZOOM" "W" (getvar "VSMIN") (getvar "VSMAX"))
)

;      ZOOM Window like ZOOM Dynamic except done on current display
;      doesn't handle keyboard except space, return and arrow keys

(defun drawbox ()			 ; draw the box
   (grdraw ll ul -1)  (grdraw ul ur -1)
   (grdraw ur lr -1)  (grdraw lr ll -1)
   (if (= mode 0) (cenx) (arrow))
)
(defun cenx ()				 ; draw center X
   (grdraw x1 x2 -1)  (grdraw x3 x4 -1)
)
(defun arrow () 			 ; draw sizing arrow
   (grdraw a1 a4 -1)  (grdraw a2 a4 -1)  (grdraw a3 a4 -1)
)
(defun defbox ()			 ; redefine box parameters & draw
   (setq deltay (* deltax aspect))	 ; assume deltax & center were
   (setq xcen (car center) ycen (cadr center))	; reset in higher level
   (setq lx (- xcen deltax) ux (+ xcen deltax)) ; lower/upper X/Y for box
   (setq ly (- ycen deltay) uy (+ ycen deltay))
   (setq ll (list lx ly) ul (list lx uy))  ; corners of box
   (setq ur (list ux uy) lr (list ux ly))
   (setq yp (+ ycen arm) ym (- ycen arm))  ; upper/lower Y for cross and arrow
   (setq a1 (list (- ux arm) yp) a2 (list (- ux arm) ym)) ; left arrow tips
   (setq a3 (list (- ux arm arm) ycen))  ; arrow tail
   (setq a4 (list ux ycen))		 ; right end of all three
   (setq x1 (list (- xcen arm) ym) x2 (list (+ xcen arm) yp))  ; ends of X
   (setq x3 (list (- xcen arm) yp) x4 (list (+ xcen arm) ym))
   (drawbox)
)
(defun C:ZW (/ arm aspect center deltax inp loop mode prev pt source)
   (setq center (getvar "VIEWCTR"))      ; start at screen center
   (setvar "LASTPOINT" (setq prev center)) ; try to re-center cursor
   (setq aspect (/ (cadr (setq aspect (getvar "SCREENSIZE"))) (car aspect)))
   (setq deltax (* 0.25 (getvar "VIEWSIZE")))  ; use 1/4 screen box
   (setq arm (* 0.1 deltax) mode 0 loop T) ; initially in box move mode
   (defbox)
   (while loop
      (setq inp (grread T))		 ; get input, tracking
      (setq source (car inp) pt (cadr inp))  ; isolate source and # or point
      (cond ((= source 3)		 ; "pick" button?
	       (cenx) (arrow)		 ; erase old & draw new or vice versa
	       (setq mode (- 1 mode))	 ; toggle box mode
	       (setvar "LASTPOINT" center)) ; try to re-center cursor
	    ((= source 5)		 ; tracking point?
	       (if (or (/= (car  prev) (car  pt)) ; if it moved
		       (/= (cadr prev) (cadr pt)))
	       (progn			 ; change or move box
		  (if (= mode 0)
		     (setq center pt)
		     (setq deltax (+ deltax (- (car pt) (car prev)))))
		  (setq prev pt)
		  (drawbox)		 ; erase old box
		  (defbox)		 ; set new center/size and draw
	       )))
	    ((or (and (= source 6) (= pt 0))	 ; button 1, or
		 (and (= source 2)		 ; keyboard and
		      (or (= pt 13) (= pt 32)))) ; CR or blank?
	       (drawbox)		 ; erase old box
	       (command "ZOOM" "W" ll ur)
	       (setq loop nil)) 	 ; exit
	    (T				 ; any other grread value
	       (drawbox)		 ; erase old box
	       (setq loop nil A "EXIT")) ; exit
      )
   )
)
