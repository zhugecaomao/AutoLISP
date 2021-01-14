;************************ PYRAMID.LSP **********************************

;     By Simon Jones     Autodesk Ltd, London       March 1987

; This macro constructs various tetrahedrons and pyramids with a flat base
; on the X-Y plane with either 3 or 4 corners using "3DFACES". A null
; response to the fourth base point will result in the construction of
; a three-point base.

; Enter points in the same manner as "3DFACES".

; The "TOP" option will construct pyramids with flat tops. This face may
; be closed or left open.

; The "RIDGE" option will draw solids in the form of pitched roofs. To
; prevent the "bowtie" effect, enter the ridge points parallel to the side
; defined by the first and second base points. This option is only valid
; for four point base constructions.

;**************************************************************************

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

;**************** CONSTRUCT 3D POINT **********************

 ; Construct point with elevation as Z coordinate

(defun CONPT (p prmpt el)
  (initget 1)
  (if p
      (append (getpoint (xy p) prmpt) (list el))
      (append (getpoint prmpt) (list el))
  )
)

(defun XY (pt)
  (list (car pt) (cadr pt))
)

;*********************** MAIN PROGRAM *********************

(defun C:PYRAMID (/ prmpt b-el t-el bp1 bp2 bp3 bp4
                    tp1 tp2 tp3 tp4 x col)

  ; Store system variable values
  (modes '("elevation" "thickness" "cmdecho" "blipmode" "highlight"))
  (setvar "cmdecho" 0)
  (command "UNDO" "MARK")

  ; Constuction lines will only be drawn in "PLAN" view.
  (if (and
         (= (getvar "VPOINTX") 0.0)
         (= (getvar "VPOINTY") 0.0)
         (= (getvar "VPOINTZ") 1.0)
      )
      (setq col 2) ; Colour variable for construction lines
      (setq col 0) ; 2=Yellow & 0=Blank
  )

  ; Set base elevation
  (setq prmpt (strcat "\nBase elevation <"
                      (rtos (getvar "ELEVATION"))   ; Default "ELEVATION"
                      ">: "                         ; variable
              )
  )
  (setq b-el (getreal prmpt))
  (if (null b-el) (setq b-el (getvar "ELEVATION")))


  (if (equal (getvar "THICKNESS") 0.0)  ;Only prompt a default height
      (progn                            ;if "THICKNESS" variable is non-zero
        (initget (+ 1 2))
        (setq t-el (getreal "\Height: "))
      )
      (progn
       (setq prmpt (strcat "\nHeight <"
                           (rtos (getvar "THICKNESS"))
                           ">: "
                   )
       )
       (initget 2)
       (setq t-el (getreal prmpt))
       (if (null t-el) (setq t-el (getvar "THICKNESS")))
      )
  )
  (setq t-el (+ b-el t-el))

  (graphscr)
  (setq bp1 (conpt nil "\nFirst base point: " b-el))
  (setq bp2 (conpt bp1  "\nSecond base point: " b-el))
  (grdraw (xy bp1) (xy bp2) col)
  (setq bp3 (conpt bp2 "\nThird base point: " b-el))
  (grdraw (xy bp2) (xy bp3) col)
  (setq bp4 (getpoint (list (car bp3) (cadr bp3)) "\nFourth base point: "))

  (cond (bp4
         (setq bp4 (append bp4 (list b-el)))
         (grdraw (xy bp3) (xy bp4) col)
         (grdraw (xy bp4) (xy bp1) col)
         (initget 1 "Top Ridge")
         (setq tp1 (getpoint "\nRidge/Top/<Apex point>: "))
        )
        (T
         (grdraw (xy bp3) (xy bp1) col)
         (initget 1 "Top")
         (setq tp1 (getpoint "\nTop/<Apex point>: "))
        )
  )

  (cond
        ((= tp1 "Top")   ; Truncated pyramid option.
         (setq tp1 (conpt nil " \nFirst top point: " t-el))
         (setq tp2 (conpt tp1 "\nSecond top point: " t-el))
         (grdraw (xy tp1) (xy tp2) col)
         (setq tp3 (conpt tp2 "\nThird top point: " t-el))
         (grdraw (xy tp2) (xy tp3) col)
         (if bp4
                (progn
                 (setq tp4 (conpt tp3 "\nFourth top point: " t-el))
                 (grdraw (xy tp3) (xy tp4) col)
                 (grdraw (xy tp4) (xy tp1) col)
                )
                (grdraw (xy tp3) (xy tp1) col)
         )
         (setvar "BLIPMODE" 0)
         (initget "Yes No")
         (setq x (getkword "\nClose top face (Yes or No) <Y>: "))
         (if (null x) (setq x "Yes"))
         (if bp4
               (progn
                (if (equal x "Yes")
                    (command "3DFACE" tp1 tp2 tp3 tp4 "")
                )
                (command "3DFACE" bp1 tp1 tp2 bp2 bp3
                                  tp3 tp4 bp4 bp1 tp1 ""
                )
               )
               (progn
                (if (equal x "Yes")
                    (command "3DFACE" tp1 tp2 tp3 "" "")
                )
                (command "3DFACE" bp1 tp1 tp2 bp2 bp3 tp3 tp1 bp1 "")
               )
         )
        )
        ((= tp1 "Ridge")   ; Ridged "roof" option
         (setq tp1 (conpt nil "\nFirst ridge point: " t-el))
         (setq tp2 (conpt tp1 "\nSecond ridge point: " t-el))
         (grdraw (xy tp1) (xy tp2) col)
         (setq xx "Yes")
         (setvar "BLIPMODE" 0)
         (if (/= (angle bp1 bp2) (angle tp1 tp2))
             (progn
               (initget "Yes No")
               (prompt "\nRidge is not parallel to first edge. ")
               (prompt "\nProceed (Yes or No) <N>: ")
               (setq xx (getkword))
              )
         )
         (cond ((= xx "Yes")
                (command "3DFACE" bp1 tp1 tp2 bp2 ""
                         "3DFACE" bp2 bp3 tp2 "" ""
                         "3DFACE" bp3 tp2 tp1 bp4 ""
                         "3DFACE" bp4 tp1 bp1 "" ""
                )
               )
               (T
                (grdraw (xy bp1) (xy bp2) 0)
                (grdraw (xy bp2) (xy bp3) 0)
                (grdraw (xy bp3) (xy bp4) 0)
                (grdraw (xy bp4) (xy bp1) 0)
                (grdraw (xy tp1) (xy tp2) 0)
               )
         )
        )
        (T     ; Default option "Apex point"
         (setq tp1 (append tp1 (list t-el)))
         (if bp4
             (command "3DFACE" bp1 bp2 tp1 "" ""
                      "3DFACE" bp2 bp3 tp1 "" ""
                      "3DFACE" bp3 bp4 tp1 "" ""
                      "3DFACE" bp4 bp1 tp1 "" ""

             )
             (command "3DFACE" bp1 bp2 tp1 "" ""
                      "3DFACE" bp2 bp3 tp1 "" ""
                      "3DFACE" bp3 bp1 tp1 "" ""
             )
         )
        )
  )
  (moder) ; Reset system variables
  (princ)
)