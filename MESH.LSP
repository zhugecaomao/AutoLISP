; **********************************************************************
;                               MESH.LSP
;
; This routine constructs a planar mesh from 4 corner points and a
; mesh M and N size.  If the corner points are entered clockwise or
; counterclockwise, the mesh will not intersect itself.
;
; Written by Karry Layden - April 1988
; **********************************************************************

; Given a starting and an ending point, this function finds the next
; set of points in the N direction.

;(IF (= (TYPE F1) 'FILE ) "YES"  (COMMAND "QUIT" "Y" ))
;(IF (= (TYPE F2) 'FILE ) "YES" (COMMAND "QUIT" "Y" ))
(defun next-n (pt1 pt2 / xinc yinc zinc loop pt)
   (setq xinc (/ (- (car pt2) (car pt1)) (1- n)))
   (setq yinc (/ (- (cadr pt2) (cadr pt1)) (1- n)))
   (setq zinc (/ (- (caddr pt2) (caddr pt1)) (1- n)))
   (setq loop (1- n))
   (setq pt pt1)
   (while (> loop 0)
      (setq pt (list (+ (car pt) xinc) (+ (cadr pt) yinc) (+ (caddr pt) zinc)))
      (setq l (cons pt l))
      (setq loop (1- loop))
   )
)

; This function finds the next point in the M direction.

(defun next-m (pt1 pt2 loop / xinc yinc zinc)
   (if (/= m loop)
      (progn
         (setq xinc (/ (- (car pt2) (car pt1)) (- m loop)))
         (setq yinc (/ (- (cadr pt2) (cadr pt1)) (- m loop)))
         (setq zinc (/ (- (caddr pt2) (caddr pt1)) (- m loop)))
      )
      (progn
         (setq xinc 0)
         (setq yinc 0)
         (setq zinc 0)
      )
   )
   (setq pt1 (list (+ (car pt1) xinc) (+ (cadr pt1) yinc) (+ (caddr pt1) zinc)))
)

;Internal error handler

(defun myerror (s)                    ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
   (if (/= s "Function cancelled")
       (princ (strcat "\nError: " s))
   )
   (setvar "blipmode" obm)            ; Restore old BLIPMODE value
   (setvar "cmdecho" ocmd)            ; Restore old CMDECHO value
   (setq *error* olderr)              ; Restore old *error* handler
   (princ)
)

; Main program

(defun C:MESH (/ olderr ocmd obm c1 c2 c3 c4 m n l loop i)
   (setq olderr  *error*              ; Initialize variables
         *error* myerror
         m 0
         n 0)
   (setq ocmd (getvar "cmdecho"))     ; Save old CMDECHO value
   (setq obm (getvar "blipmode"))     ; Save old BLIPMODE value
   (setvar "cmdecho" 0)               ; Set CMDECHO off

   (initget 17)
   (setq c1 (getpoint "\nFirst corner: "))
   (initget 17)
   (setq c2 (getpoint "\nSecond corner: "))
   (initget 17)
   (setq c3 (getpoint "\nThird corner: "))
   (initget 17)
   (setq c4 (getpoint "\nForth corner: "))
   (while (or (< m 2) (> m 256))
      (initget 7)
      (setq m (getint "\nMesh M size: "))
      (if (or (< m 2) (> m 256))
         (princ "\nValue must be between 2 and 256.")
      )
   )
   (while (or (< n 2) (> n 256))
      (initget 7)
      (setq n (getint "\nMesh N size: "))
      (if (or (< n 2) (> n 256))
         (princ "\nValue must be between 2 and 256.")
      )
   )

   (setq l (list c1))
   (setq loop 1)
   (next-n c1 c2)
   (while (< loop m)
      (setq c1 (next-m c1 c4 loop))
      (setq c2 (next-m c2 c3 loop))
      (setq l (cons c1 l))
      (next-n c1 c2)
      (setq loop (1+ loop))
   )
   (setvar "blipmode" 0)              ; Set BLIPMODE off
   (setq i 0)
   (command "3dmesh" m n)
   (while (<= i (* m n)) (command (nth i l)) (setq i (1+ i)))

   (setvar "blipmode" obm)            ; Restore old BLIPMODE value
   (setvar "cmdecho" ocmd)            ; Restore old CMDECHO value
   (setq *error* olderr)              ; Restore old *error* handler
   (princ)
)
