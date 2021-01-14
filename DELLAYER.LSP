; ********************************************************************
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
;                           DELLAYER.LSP

;  This program deletes all entities on a specified layer.

; ********************************************************************

(defun dellerr (s)                    ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
   (if (/= s "Function cancelled")
       (princ (strcat "\nError: " s))
   )
   (setq S nil)                       ; Free selection-set if any
   (setvar "CMDECHO" ocmd)            ; Restore saved mode
   (setq *error* olderr)              ; Restore old *error* handler
   (princ)
)

(defun C:DELLAYER (/ olderr ocmd L S)

   (setq olderr  *error*
         *error* dellerr)
   (setq ocmd (getvar "CMDECHO"))
   (setvar "CMDECHO" 0)
   (setq L (strcase (getstring "\nLayer to delete: ")))
   (setq S (ssget "X" (list (cons 8 L))))  ; Get all entities on layer
   (if S
      (command "ERASE" S "")          ; Delete 'em!
      (princ "Layer empty or not a valid layer name.")
   )
   (setq S nil)                       ; Free selection-set
   (setvar "CMDECHO" ocmd)            ; Restore saved mode
   (setq *error* olderr)              ; Restore old *error* handler
   (princ)
)

