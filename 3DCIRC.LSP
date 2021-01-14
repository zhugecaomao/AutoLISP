;**************************** 3DCIRC.LSP *********************************

;     By Simon Jones    Autodesk Ltd, London     February 1987

;    This macro will draw a "circle" in any orientation, with
;  3DLINES. The "circle" is effectively, a multi-sided polygon
;  with a minimum of three sides.
;*************************************************************************

;----------- GLOBAL variables

; ainc : Angle of inclination
; arot : Angle of rotation
; aseg : Angle per segment
; cen  : Centre point
; c    : Counter
; dx   : Delta X
; dy   : Delta Y
; dz   : Delta Z
; l    : List of 3D points
; n    : Number of lines
; rad  : Radius
; vb   : Blipmode variable
; vc   : Cmdecho variable

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

;******************** MAIN PROGRAM ************************

(defun C:3DCIRC (/ cen rad n aseg ainc arot
                   ang c l dx dy dz x y z pt)

   (modes '("cmdecho" "blipmode" "elevation"))
   (setvar "CMDECHO" 0)

   ; Set centre point
   (initget (+ 1 16))
   (setq cen (getpoint "\nCentre point: "))
   (setvar "elevation" (caddr cen))

   ; Set radius
   (initget (+ 1 2 4) "Diameter")
   (setq rad (getdist cen "\nDiameter/<Radius>: "))
   (if (= rad "Diameter")
       (progn
        (initget (+ 1 2))
        (setq rad (/ (getdist cen "\nDiameter: ") 2))
       )
   )

   ; Set angle of inclination (default is vertical)
   (setq ainc (getangle cen "\nInclined angle <90>: "))
   (if (null ainc) (setq ainc (/ pi 2)))

   ; Set rotational angle
   (setq arot (getangle cen "\nRotational angle <0>: "))
   (if (null arot) (setq arot 0))

   ; Circle resolution
   (while (< n 3)
          (initget (+ 2 4))
          (setq n (getint "\nNumber of lines <16>: "))
          (cond ((null n) (setq n 16))
                ((< n 3) (prompt "\nMust be greater than 2 lines. "))
          )
   )

   (setq aseg (/ (* 2 pi) n)) ;Angle per segment
   (setq ang 0 c 0 l nil)

   ; Calculate points around "circle"
   (while (< c (1+ n))

          ; Calculate points for vertical circle
          (setq dx (* rad (cos ang)))
          (setq dz (* rad (sin ang)))
          (setq dy 0)

          ; Rotate points through incline angle
          ;if not vertical
          (if (/= (fix (abs (sin ainc))) 1)
              (progn
               (setq dy (* dz (cos ainc)))
               (setq dz (* dz (sin ainc)))
              )
          )

          (setq x (+ (car cen) dx))
          (setq y (+ (cadr cen) dy))
          (setq z (+ (caddr cen) dz))

          ; Rotate points around vertical axis
          (setq pt (polar cen
                          (+ (angle cen (list x y)) arot)
                          (distance cen (list x y))
                   )
          )
          (setq pt (append pt (list z)))
          (setq l (append l (list pt))) ;Add next point to list
          (setq ang (+ ang aseg))
          (prompt "\rGenerating lines - ") (princ c)
          (setq c (1+ c))
   )

   ; Draw "circle"
   (setvar "BLIPMODE" 0)
   (command "3DLINE")         ; Enter 3DLINE command
   (foreach n l (command n))  ; Pass over each 3d point
   (command "")               ; End command

   (moder)
   (princ)
)
