;-----------------------------------------------------------------------------+
;                                                                             |
;                                  SSX.LSP                                    |
;                                                                             |
;           Larry Knott          Version 2.0             7/18/88              |
;                                                                             |
;    "(SSX)" -  Easy SSGET filter routine.                                    |
;                                                                             |
;    Creates a selection set.  Either type "(SSX)" at the "Command:" prompt   |
;    to create a "previous" selection set or type "(SSX)" in response to any  |
;    "Select objects:" prompt.  You may use the functions "(A)" to add        |
;    entities and "(R)" to remove entities from a selection set during object |
;    selection.  More than one filter criteria can be used at a time.         |
;                                                                             |
;-----------------------------------------------------------------------------|

;--------------------------- INTERNAL ERROR HANDLER --------------------------|

(defun ssx-err (s)                    ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
(if (/= s "Function cancelled")
    (princ (strcat "\nError: " s))
)
(setq *error* olderr)                 ; Restore old *error* handler
(princ)
)

;-------------------------- ADD AND REMOVE FUNCTIONS -------------------------|

(defun r() (command "r") (ssx))
(defun a() (command "a") (ssx))

;-------------------------------- MAIN PROGRAM -------------------------------|

(defun ssx (/ olderr t1 t2 t3 f1 f2)
(setq olderr *error* *error* ssx-err t1 T f2 'f1)
(while t1
  (initget "Block Color Entity LAyer LType Style Thickness")
  (setq t1 (getkword
     "\n>>Block name/Color/Entity/LAyer/LType/Style/Thickness: "))
  (setq t2
     (cond
        ((eq t1 "Block")      2)   ((eq t1 "Color")     62)
        ((eq t1 "Entity")     0)   ((eq t1 "LAyer")      8)
        ((eq t1 "LType")      6)   ((eq t1 "Style")      7)
        ((eq t1 "Thickness") 39)))
  (initget 1)
  (setq t3
     (cond
        ((= t2  2)  (getstring "\n>>Block name: "))
        ((= t2 62)  (initget " ? ")
                    (while
                       (or (eq (setq t3 (getint "\n>>Color number/<?>: ")) "?")
                           (null t3)
                           (> t3 256)
                           (< t3 0))
                           (textscr)
          (princ "\n                                                     ")
          (princ "\n                 Color number   |   Standard meaning ")
          (princ "\n                ________________|____________________")
          (princ "\n                                |                    ")
          (princ "\n                       0        |      <BYBLOCK>     ")
          (princ "\n                       1        |      Red           ")
          (princ "\n                       2        |      Yellow        ")
          (princ "\n                       3        |      Green         ")
          (princ "\n                       4        |      Cyan          ")
          (princ "\n                       5        |      Blue          ")
          (princ "\n                       6        |      Magenta       ")
          (princ "\n                       7        |      White         ")
          (princ "\n                    8...255     |      -Varies-      ")
          (princ "\n                      256       |      <BYLAYER>     ")
          (princ "\n                                               \n\n\n")
                          (initget "?")) t3)
        ((= t2  0)  (getstring "\n>>Entity type: "))
        ((= t2  8)  (getstring "\n>>Layer name: "))
        ((= t2  6)  (getstring "\n>>Linetype name: "))
        ((= t2  7)  (getstring "\n>>Text style name: "))
        ((= t2 39)  (getreal   "\n>>Thickness: "))
        (T          nil)))
  (if t3 (setq f1 (cons (cons t2 t3) f1)))
)
(setq f2 (ssget "x" (eval f2)))
(setq *error* olderr)
(if (and f1 f2) f2 (progn (princ "\n0 found.") (prin1)))
)
