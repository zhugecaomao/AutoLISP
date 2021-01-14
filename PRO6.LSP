;#********************** changel ****************************************

(defun c:cl ()                               ;Change Layer
;
;Change entitis'layer to a layer of an entity
;
    (setvar "cmdecho" 0)
    (prompt "\nSelect object to be changed\n")
 ;  (command "select" pause)
    (setq a (ssget))
    (prompt "\nPick an object on the desired layer...")
    (setq temp (car (entsel)))
    (if temp
        (progn
            (setq temp (entget temp))
            (setq temp (cdr (assoc 8 temp)))
            (command "change" a "" "p" "la" temp "")
        )
    )
)
