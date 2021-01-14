;*************************************************************************
;                             3DARRAY.LSP

;       By Simon Jones   Autodesk Ltd,London   March 1987

;  Functions included:
;       1) Rectangular ARRAYS (rows, columns & levels)
;       2) Circular ARRAYS around any axis

;  All are loaded by: (load "3darray")

;  And run by:
;       Command: 3darray
;                Select objects:
;                Rectangular or Polar array (R/P): (select type of array)

;  Expanded the circular arrays to revolve around any user
;  specified axis - June 1988
;***********************************************************************

;******************************** MODES ********************************

; System variable save

(defun MODES (a)
   (setq MLST '())
   (repeat (length a)
      (setq MLST (append MLST (list (list (car a) (getvar (car a))))))
      (setq a (cdr a)))
)

;******************************** MODER ********************************

; System variable restore

(defun MODER ()
   (repeat (length MLST)
      (setvar (caar MLST) (cadar MLST))
      (setq MLST (cdr MLST))
   )
)

;******************************** 3DAERR *******************************

; Standard error function

(defun 3DAERR (st)                    ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
  (if (/= st "Function cancelled")
      (princ (strcat "\nError: " s))
  )
  (command "UNDO" "E")
  (moder)                             ; Restore system variables
  (setq *error* olderr)               ; Restore old *error* handler
  (princ)
)

;******************************* P-ARRAY *******************************

; Perform polar (circular) array around any axis

(defun P-ARRAY (/ n af yn cen c ra)

   ; Define number of items in array
   (setq n 0)
   (while (<= n 1)
          (initget (+ 1 2 4))
          (setq n (getint "\nNumber of items: "))
          (if (= n 1)
              (prompt "\nNumber of items must be greater than 1")
          )
   )

   ; Define angle to fill
   (initget 2)
   (setq af (getreal "\nAngle to fill <360>: "))
   (if (= af nil) (setq af 360))

   ; Are objects to be rotated?
   (initget "Yes No")
   (setq yn (getkword "\nRotate objects as they are copied? <Y>: "))
   (if (null yn)
      (setq yn "Y")
   )

   ; Define center point of array
   (initget 17)
   (setq cen (getpoint "\nCenter point of array: "))
   (setq c (trans cen 1 0))

   ; Define rotational axis
   (initget 17)
   (setq ra (getpoint cen "\nSecond point on axis of rotation: "))
   (while (equal ra cen)
      (princ "\nInvalid point. Second point cannot equal center point.")
      (initget 17)
      (setq ra (getpoint cen "\nPlease try again: "))
   )
   (setvar "UCSFOLLOW" 0)
   (setvar "GRIDMODE" 0)
   (command "UCS" "ZAXIS" cen ra)
   (setq cen (trans c 0 1))

   ; Draw polar array
   (command "ARRAY" ss "" "P" cen n af yn)
   (command "UCS" "p")
)

;******************************* R-ARRAY *******************************

; Perform rectangular array

(defun R-ARRAY (/ nr nc nl flag x y z c el en ss2 e)

   ; Set array parameters
   (while (or (= nr nc nl nil) (= nr nc nl 1))
      (setq nr 1)
      (initget (+ 2 4))
      (setq nr (getint "\nNumber of rows (---) <1>: "))
      (if (null nr) (setq nr 1))
      (initget (+ 2 4))
      (setq nc (getint "\nNumber of columns (|||) <1>: "))
      (if (null nc) (setq nc 1))
      (initget (+ 2 4))
      (setq nl (getint "\nNumber of levels (...) <1>: "))
      (if (null nl) (setq nl 1))
      (if (= nr nc nl 1)
         (princ "\nOne-element array, nothing to do.\nPlease try again")
      )
   )
   (setvar "ORTHOMODE" 1)
   (setvar "HIGHLIGHT" 0)
   (setq flag 0)                      ; Command style flag
   (cond ((/= nr 1)
          (initget (+ 1 2))
          (setq y (getdist "\nDistance between rows (---): "))
          (setq flag 1)
         )
   )
   (cond ((/= nc 1)
          (initget (+ 1 2))
          (setq x (getdist "\nDistance between columns (|||): "))
          (setq flag (+ flag 2))
         )
   )
   (cond  ((/= nl 1)
           (initget (+ 1 2))
           (setq z (getdist "\nDistance between levels (...): "))
          )
   )
   (setvar "BLIPMODE" 0)

   (setq c 1)
   (setq el (entlast))                ; Reference entity
   (setq en (entnext el))
   (while (not (null en))
       (setq el en)
       (setq en (entnext el))
   )

   ; Copy the selected entities one level at a time
   (while (< c nl)
          (command "COPY" ss ""
                          "0,0,0"
                          (append (list 0 0) (list (* c z)))
          )
          (setq c (1+ c))
   )

   (setq ss2 (ssadd))                 ; create a new selection set
   (setq e (entnext el))              ; of all the new entities since
   (while e                           ; the reference entity.
       (ssadd e ss2)
       (setq e (entnext e))
   )

   ; Array original selection set and copied entities
   (cond
     ((= flag 1) (command "ARRAY" ss ss2 "" "R" nr "1" y))
     ((= flag 2) (command "ARRAY" ss ss2 "" "R" "1" nc x))
     ((= flag 3) (command "ARRAY" ss ss2 "" "R" nr nc y x))
   )
)

;***************************** MAIN PROGRAM ****************************

(defun C:3DARRAY (/ olderr ss xx)

   (setq olderr *error*
         *error* 3daerr)
   (modes '("cmdecho" "blipmode" "highlight" "orthomode" 
            "ucsfollow" "gridmode"))
   (setvar "CMDECHO" 0)
   (command "UNDO" "GROUP")
   (graphscr)

   (setq ss nil)
   (while  (null ss)                  ; Ensure selection of entities
           (setq ss (ssget))
   )

   (initget 1 "Rectangular Polar Circular")
   (setq xx (getkword "\nRectangular or Polar array (R/P): "))
   (cond ((eq xx "Rectangular") (r-array))
         (T (p-array))
   )
   (command "UNDO" "E")
   (moder)                            ; Restore system variables
   (setq *error* olderr)              ; Restore old *error* handler
   (princ)
)
