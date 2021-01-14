;*************************************************************************

;                              TUBE.LSP

;      By Simon Jones    Autodesk Ltd, London     March 1987

;   This macro will draw an open tube in any orientation, made up
; of 3DFACES.

;*************************************************************************

(vmon)
(prompt "\nLoading. Please wait...")
(terpri)

(defun MODES (a)
   (setq MLST '())
   (repeat (length a)
      (setq MLST (append MLST (list (list (car a) (getvar (car a))))))
      (setq a (cdr a)))
)

(defun MODER ()
   (repeat (length MLST)
      (setvar (caar MLST) (cadar MLST))
      (setq MLST (cdr MLST))
   )
)

(defun *ERROR* (st)
  (moder)
  (terpri)
  (princ "\nError: ")
  (princ st)
  (princ)
)


; Convert degrees to radians
(defun DTR (a)
  (* pi (/ a 180.0))
)

; Convert radians to degrees
(defun RTD (a)
  (/ (* a 180.0) pi)
)

; List of X an Y co-ordinates of point
(defun XY (pt)
  (list (car pt) (cadr pt))
)

; List of X and Z co-ordinates of point
(defun XZ (pt)
  (list (car pt) (caddr pt))
)

;*********** ROTATE POINTS ABOUT Y-AXIS ******************

(defun ABT-Y (pt a / p)
   (setq p (polar (xz cen)
                     (+ (angle (xz cen) (xz pt)) a)
                     (distance (xz cen) (xz pt))
              )
   )
   (list (car p) (cadr pt) (cadr p))
)

;*********** ROTATE POINTS ABOUT Z-AXIS ******************

(defun ABT-Z (pt a)
   (append
         (polar cen
               (+ (angle cen pt) a)
               (distance cen pt)
         )
         (list (caddr pt))
   )
)

;******************** MAIN PROGRAM ************************

(defun C:TUBE ( / p1 p2 ay az c ang len dzz dxy
                  ang1 n r cen2 vc vb cen l)

   (modes '("blipmode" "cmdecho"))
   (setvar "CMDECHO" 0)
   (command "UNDO" "MARK")

   (initget (+ 1 8 16))
   (setq cen (getpoint "\nFrom point: "))

   (initget (+ 1 8 16))
   (setq cen2 (getpoint cen "\nTo point: "))

   (initget (+ 1 2 4) "Diameter")
   (setq r (getdist cen "\nDiameter/<Radius>: "))
   (if (= r "Diameter")
       (progn
         (initget (+ 1 2 4))
         (setq r (/ (getdist cen "\nDiameter: ") 2.0))
       )
   )

   (initget (+ 2 4))
   (setq n (getint "\nNumber of faces <10>: "))
   (if (null n) (setq n 10))

   (setq ang1 (/ (* 2 pi) n)) ;Angle per segment
   (setq dxy (distance cen cen2))
   (setq dzz (- (caddr cen2) (caddr cen)))
   (setq len (sqrt (+ (* dzz dzz) (* dxy dxy))))

   (setq ang 0 c 0 l nil)
   (setq az (angle (xy cen) (xy cen2)))
   (setq ay (atan dzz dxy))

   (terpri)
   (while (< c (1+ n))

        ; Calculate pair of points for horizontal tube
        (setq p1 (list
                     (car cen)
                     (+ (* r (cos ang)) (cadr cen))
                     (+ (* r (sin ang)) (caddr cen))
                  )
        )
        (setq p2 (list
                     (+ len (car cen))
                     (+ (* r (cos ang)) (cadr cen))
                     (+ (* r (sin ang)) (caddr cen))
                  )
        )

        ; Rotate points perpendicular to Y-axis
        (setq p1 (abt-y p1 ay))
        (setq p2 (abt-y p2 ay))

        ; Rotate points perpendicular to Z-axis
        (setq p1 (abt-z p1 az))
        (setq p2 (abt-z p2 az))

        ; Construct a list containing all the points of the
        ; tube in the correct order for the "3DFACE" command
        (if (= (rem (+ c 1) 2) 1)
            (progn
              (setq l (append l (list p1)))
              (setq l (append l (list p2)))
            )
            (progn
              (setq l (append l (list p2)))
              (setq l (append l (list p1)))
            )
        )

        ; Increment angle
        (setq ang (+ ang ang1))

        (princ "\rGenerating faces - ") (princ c)
        (setq c (1+ c))
   )

   ; Draw "tube"
   (setvar "BLIPMODE" 0)
   (command "3DFACE")         ; Enter 3DFACE command and
   (foreach n l (command n))  ; Pass over each 3d point
   (command "")

   (moder)
   (princ)
)
