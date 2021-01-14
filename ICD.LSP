
;       Interactive Colour Designer

;       Designed and implemented by Kelvin R. Throop in June of 1987

;       This code allows the user to interactively select a colour from
;       the colour gamut of an AutoCAD 256 colour device by manipulating
;       sliders which control hue, brightness, and saturation.  Another
;       slider allows selection from the six special grey scale colours.

;       The capability is provided in both functional and a command
;       forms.  To set the current entity drawing colour, you may
;       simply use the command:

;       icolour
;   or  icolor

;       If you want a colour number to use in another context (such as to
;       reply to a LAYER COLOUR prompt, or for the CHANGE command, or for
;       use in your own Lisp code) you may use:

;       (icolour)
;   or  (icolor)

;       which return the selected colour number in the range from 10
;       to 255.

;       ICOLOUR  --  Obtain colour number interactively and return index.

(defun icolour ( / vctr smin smax pixy)

;       Obtain world to screen scale factors and build our local
;       coordinate system in which the screen runs from (0 0) to (1 1).

        (setq vctr (getvar "viewctr")
              yspan (getvar "viewsize")
              smin (getvar "vsmin")
              smax (getvar "vsmax")
              ymin (- (cadr vctr) (/ yspan 2.0))
              xspan (* yspan (/ (- (car smax) (car smin))
                                (- (cadr smax) (cadr smin))))
              xmin (- (car vctr) (/ xspan 2.0))
        )

;       Make sure we're on the graphics screen and clear it

        (graphscr)
        (grclear)
        (setq scoords (getvar "coords"))
        (setvar "coords" 0)        ; Coordinate line?  Just say no.

        (setq pixy (/ 1.0 (cadr (getvar "screensize"))))

;       Precompute lines and bounding region for hue

        (setq huelf (plcs (list 0.1 0.85)))
        (setq huelt (plcs (list 0.9 0.85)))
        (setq huehf (plcs (list 0.1 (+ 0.85 pixy))))
        (setq hueht (plcs (list 0.9 (+ 0.85 pixy))))

        (setq huexl (+ xmin (* 0.1 xspan)))
        (setq huexh (+ xmin (* 0.9 xspan)))
        (setq hueyl (+ ymin (* 0.8 yspan)))
        (setq hueyh (+ ymin (* 0.9 yspan)))

;       Precompute lines and bounding region for brightness

        (setq brtlf (plcs (list 0.3 0.65)))
        (setq brtlt (plcs (list 0.7 0.65)))
        (setq brthf (plcs (list 0.3 (+ 0.65 pixy))))
        (setq brtht (plcs (list 0.7 (+ 0.65 pixy))))

        (setq brtxl (+ xmin (* 0.3 xspan)))
        (setq brtxh (+ xmin (* 0.7 xspan)))
        (setq brtyl (+ ymin (* 0.6 yspan)))
        (setq brtyh (+ ymin (* 0.7 yspan)))

;       Precompute lines and bounding region for saturation

        (setq satlf (plcs (list 0.4 0.45)))
        (setq satlt (plcs (list 0.6 0.45)))
        (setq sathf (plcs (list 0.4 (+ 0.45 pixy))))
        (setq satht (plcs (list 0.6 (+ 0.45 pixy))))

        (setq satxl (+ xmin (* 0.4 xspan)))
        (setq satxh (+ xmin (* 0.6 xspan)))
        (setq satyl (+ ymin (* 0.4 yspan)))
        (setq satyh (+ ymin (* 0.5 yspan)))

;       Precompute lines and bounding region for grey values

        (setq grylf (plcs (list 0.2 0.25)))
        (setq grylt (plcs (list 0.8 0.25)))
        (setq gryhf (plcs (list 0.2 (+ 0.25 pixy))))
        (setq gryht (plcs (list 0.8 (+ 0.25 pixy))))

        (setq gryxl (+ xmin (* 0.2 xspan)))
        (setq gryxh (+ xmin (* 0.8 xspan)))
        (setq gryyl (+ ymin (* 0.2 yspan)))
        (setq gryyh (+ ymin (* 0.3 yspan)))

;       Draw the hue control slider

        (grdraw (list huexl hueyl) (list huexl hueyh) 10)
        (grdraw (list huexh hueyl) (list huexh hueyh) 210)
        (grdraw huelf huelt 90)

;       Draw the lightness control slider

        (grdraw (list brtxl brtyl) (list brtxl brtyh) 94)
        (grdraw (list brtxh brtyl) (list brtxh brtyh) 90)
        (grdraw brtlf brtlt 94)

;       Draw the saturation control slider

        (grdraw (list satxl satyl) (list satxl satyh) 10)
        (grdraw (list satxh satyl) (list satxh satyh) 11)
        (grdraw satlf satlt 10)

;       Draw the grey scale slider

        (grdraw (list gryxl gryyl) (list gryxl gryyh) 251)
        (grdraw (list gryxh gryyl) (list gryxh gryyh) 255)
        (grdraw grylf grylt 253)

;       Set defaults.  We start with a middle of the road green.  You
;       want to change this to default to the last colour, but rember
;       that if the pointer happens to be inside one the sliders, it
;       will be immediately changed.

        (setq hue 90
              brite 0
              sat 0
        )
        (ucol)

;       Loop examining pointer coordinates.  If the user enters an
;       active slider area, dispatch to the handler for that slider.

        (setq ocont T)
        (setq lp nil)
        (while ocont
           (setq p (grread T))
           (if (not (equal lp p))
              (progn
                 (setq lp p)
                 (if (= (car p) 5)
                    (progn
                       (setq px (caadr p))
                       (setq py (cadadr p))
                       (if (and (>= py hueyl) (<= py hueyh)
                                (>= px huexl) (<= px huexh))
                          (sethue)
                          (if (and (>= py brtyl) (<= py brtyh)
                                   (>= px brtxl) (<= px brtxh))
                             (setbrt)
                             (if (and (>= py satyl) (<= py satyh)
                                      (>= px satxl) (<= px satxh))
                                (setsat)
                                (if (and (>= py gryyl) (<= py gryyh)
                                         (>= px gryxl) (<= px gryxh))
                                   (setgry)
                                )
                             )
                          )
                       )
                    )
                    (if (= (car p) 3)
                       (setq ocont nil)
                    )
                 )
              )
           )
        )

;       Put back the original screen and return the selected colour

        (setvar "coords" scoords)
        (grtext)
        (redraw)
        col
)

;       SETHUE  --  Set hue.  This is invoked when the user enters the hue
;                   control slider and returns when he leaves it or clicks.

(defun sethue ( / cont lp p px py pcol)
        (setq cont T)
        (setq lp nil)
        (while cont
           (setq p (grread T))
           (if (not (equal lp p))
              (progn
                 (setq lp p)
                 (if (= (car p) 5)
                    (progn
                       (setq px (caadr p))
                       (setq py (cadadr p))
                       (if (and (>= py hueyl) (<= py hueyh)
                                (>= px huexl) (<= px huexh))
                          (progn
                             (setq pcol (fix (* 24 (/ (- 
                                (/ (- px xmin) xspan) 0.1) 0.8))))
                             (setq hue (+ (* 10 pcol) 10))
                             (ucol)
                             (grdraw huelf huelt col)
                             (grdraw huehf hueht col)
                             (grtext -1 (strcat "Hue: " (itoa hue)))
                          )
                          (setq cont nil)
                       )
                    )
                    (if (= (car p) 3)
                       (setq cont nil ocont nil)
                    )
                 )
              )
           )
        )
        (grdraw huehf hueht 0)
        (grtext -1 "")
)

;       SETBRT  --  Set brightness.  This is activated when the user enters
;                   the brightness control slider and returns when
;                   he leaves it or clicks.

(defun setbrt ( / cont lp p px py)
        (setq cont T)
        (setq lp nil)
        (while cont
           (setq p (grread T))
           (if (not (equal lp p))
              (progn
                 (setq lp p)
                 (if (= (car p) 5)
                    (progn
                       (setq px (caadr p))
                       (setq py (cadadr p))
                       (if (and (>= py brtyl) (<= py brtyh)
                                (>= px brtxl) (<= px brtxh))
                          (progn
                             (setq brite (- 8 (* 2 (fix (* 5
                                (/ (- (/ (- px xmin) xspan) 0.3) 0.4))))))
                             (ucol)
                             (grdraw brtlf brtlt col)
                             (grdraw brthf brtht col)
                             (grtext -1 (strcat "Brightness: " (itoa brite)))
                          )
                          (setq cont nil)
                       )
                    )
                    (if (= (car p) 3)
                       (setq cont nil ocont nil)
                    )
                 )
              )
           )
        )
        (grdraw brthf brtht 0)
        (grtext -1 "")
)

;       SETSAT  --  Set saturation.  This is activated when the user enters
;                   the saturation control slider and returns when
;                   he leaves it or clicks.

(defun setsat ( / cont lp p px py)
        (setq cont T)
        (setq lp nil)
        (while cont
           (setq p (grread T))
           (if (not (equal lp p))
              (progn
                 (setq lp p)
                 (if (= (car p) 5)
                    (progn
                       (setq px (caadr p))
                       (setq py (cadadr p))
                       (if (and (>= py satyl) (<= py satyh)
                                (>= px satxl) (<= px satxh))
                          (progn
                             (setq sat (if (> px (+ xmin (/ xspan 2))) 1 0))
                             (ucol)
                             (grdraw satlf satlt col)
                             (grdraw sathf satht col)
                             (grtext -1 (strcat "Saturation: " (itoa sat)))
                          )
                          (setq cont nil)
                       )
                    )
                    (if (= (car p) 3)
                       (setq cont nil ocont nil)
                    )
                 )
              )
           )
        )
        (grdraw sathf satht 0)
        (grtext -1 "")
)

;       SETGRY  --  Set grey scale.  This is activated when the user enters
;                   the grey scale control slider and returns when
;                   he leaves it or clicks.

(defun setgry ( / cont lp p px py)
        (setq cont T)
        (setq lp nil)
        (while cont
           (setq p (grread T))
           (if (not (equal lp p))
              (progn
                 (setq lp p)
                 (if (= (car p) 5)
                    (progn
                       (setq px (caadr p))
                       (setq py (cadadr p))
                       (if (and (>= py gryyl) (<= py gryyh)
                                (>= px gryxl) (<= px gryxh))
                          (progn
                             (setq col (+ 250 (fix (* 6
                                (/ (- (/ (- px xmin) xspan) 0.2) 0.6)))))
                             (grdraw grylf grylt col)
                             (grdraw gryhf gryht col)
                             (grtext -1 (strcat "Grey scale: "
                                (itoa (- col 250))))
                              (grtext -2 (strcat "Colour: " (itoa col)))
                          )
                          (setq cont nil)
                       )
                    )
                    (if (= (car p) 3)
                       (setq cont nil ocont nil)
                    )
                 )
              )
           )
        )
        (grdraw gryhf gryht 0)
        (grtext -1 "")
)

;       PLCS  --  Tranform point from local coordinate system to world
;                 coordinates.

(defun plcs (p)
           (list (+ xmin (* (car p) xspan))
                 (+ ymin (* (cadr p) yspan)))
)

;       UCOL  --  Update colour from hue, lightness, and saturation

(defun ucol ()
        (setq col (+ hue brite sat))
        (grtext -2 (strcat "Colour: " (itoa col)))
)

;       C:ICOLOUR --  Command to set current colour
;       C:ICOLOR  --  Synonym
;       ICOLOR    --  Synonym of functional form

(defun C:ICOLOUR ()
        (command "colour" (icolour))
)
(defun C:ICOLOR ()
        (command "colour" (icolour))
)
(defun icolor ()
        (icolour)
)
