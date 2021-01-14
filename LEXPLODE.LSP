;-----------------------------------------------------------------------------+
;                               LEXPLODE.LSP                                  |
;                                                                             |
;    Larry Knott                Version 1.0                  5/25/88          |
;                                                                             |
;    Explode a BLOCK, POLYLINE, or DIMENSION and copy the entities            |
;    that replace it to the layer that the original entity was on.            |
;                                                                             |
;-----------------------------------------------------------------------------+

;-------------------------- INTERNAL ERROR HANDLER ---------------------------|

(defun lexerr (s)                     ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
  (if (/= s "Function cancelled")
    (princ (strcat "\nError: " s))
  )
  (setvar "highlight" ohl)            ; restore old highlight value
  (setvar "cmdecho" oce)              ; restore old cmdecho value
  (setq *error* olderr)               ; restore old *error* handler
  (princ)
)
;------------------------------ COMMON FUNCTION ------------------------------|

(defun getval (n e) (cdr (assoc n e)))

;--------------------------- GET ENTITY TO EXPLODE ---------------------------|

(defun getent (t1 / no_ent e0)
(setq no_ent T)
(while no_ent
  (if (setq e0 (entsel "\nSelect block reference, polyline, dimension, or mesh: "))
    (if (member (getval 0 (setq e1 (entget (car e0)))) t1)
      (if (equal (getval 0 e1) "INSERT")
        (if (and (equal (getval 41 e1) (getval 42 e1))
                 (equal (getval 42 e1) (getval 43 e1)))
          (setq no_ent nil)
          (princ "\nX, Y, and Z scale factors must be equal."))
        (setq no_ent nil))
      (princ "\nNot a block reference, polyline, or dimension."))
    (princ " No object found."))
))

;-------------------------------- MAIN PROGRAM -------------------------------|

(defun c:lexplode (/ oce ohl e0 en e1 s0)
(setq olderr *error*
      *error* lexerr)
(setq oce (getvar "cmdecho"))         ; save value of cmdecho
(setq ohl (getvar "highlight"))       ; save value of highlight
(setvar "cmdecho" 0)                  ; turn cmdecho off
(setvar "highlight" 0)                ; turn highlight off
(setq e0 (entlast))
(setq en (entnext e0))
(while (not (null en))                ; find the last entity              
  (setq e0 en)
  (setq en (entnext e0))
)
(getent '("INSERT" "DIMENSION" "POLYLINE"))
(command "explode" (getval -1 e1))    ; explode the entity
(setq s0 (ssadd))
(while (entnext e0) (ssadd (setq e0 (entnext e0)) s0))
(command "chprop" s0 ""               ; change entities to the proper layer
         "c"   "bylayer"              ; regardless of their extrusion direction
         "lt"  "bylayer"
         "la"  (getval 8 e1) "")
(princ (strcat "\nEntities exploded onto layer " (getval 8 e1) "."))
(setvar "highlight" ohl)              ; restore old highlight value
(setvar "cmdecho" oce)                ; restore old cmdecho value
(setq *error* olderr)                 ; restore old *error* handler
(prin1))

;------------------------------------ END ------------------------------------|
