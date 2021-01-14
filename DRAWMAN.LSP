;
;       Drawing revision control - A programming example using entity handles.
;
;       This program implements a crude revision control system for drawings;
;       it is supplied purely as an illustration of what can be done using
;       handles and a very small amount of AutoLISP. It does not purport to 
;       be either a full-function drawing manager or the basis for 
;       implementing one.
;
;       The program requires the file REVINFO.DWG which it inserts as a block
;       with invisible attributes when the user logs out. All blocks are
;       inserted on layer $REV and become the reference for RLIST, FINGER, 
;       SELUSER, and SELECO. The revision information can then be referenced
;       when you log back on (i.e. LOGON).
;
;       Written by Kelvin R. Throop in December 1987
;
;
;       LOGON       - Log onto to drawing management system
;
(defun C:LOGON ()
        (if (= (getvar "HANDLES") 0)
           (progn
              (setvar "CMDECHO" 0)
              (command "handles" "on")
              (setvar "CMDECHO" 1)
           )
        )

;       If user already logged on in this system, log him out

        (if usrnam
           (C:logout)
        )

;       Obtain user identity information

        (setq usrnam (getstring T "Please enter your name: "))
        (setq econum (getstring T "Engineering change order number: "))
        (setq coment (getstring T "Comments: "))
        (setq d (getvar "CDATE"))
        (setq d (rtos d 2 0))
        (setq rdate (strcat (substr d 3 2) "/" (substr d 5 2) "/"
           (substr d 7 2)))
        (setq d (entlast))
        (if d
           (setq fhandle (cdr (assoc 5 (entget d))))
           (setq fhandle "0000000000000000")
        )
        (if (< (strlen fhandle) 16)
           (setq fhandle (strcat (substr "0000000000000000"
              1 (- 16 (strlen fhandle))) fhandle))
        )
        (setvar "CMDECHO" 0)
        (command "undefine" "end")
        (setvar "CMDECHO" 1)
        (princ (strcat "Logged on as " usrnam))
        (princ)
)

;       C:LOGOUT    - Add revision block at end of drawing session

(defun C:LOGOUT ()
        (setq d (entlast))
        (if d
           (setq lhandle (cdr (assoc 5 (entget d))))
           (setq lhandle "0000000000000000")
        )
        (if (< (strlen lhandle) 16)
           (setq lhandle (strcat (substr "0000000000000000"
              1 (- 16 (strlen lhandle))) lhandle))
        )
        (setq cl (getvar "CLAYER"))
        (setvar "CMDECHO" 0)
        (command "layer" "make" "$REV" "")
        (command "insert" "revinfo" '(0 0) 1 1 0
           usrnam econum coment rdate fhandle lhandle)
        (command "layer" "set" cl "")
        (setvar "CMDECHO" 1)
        (setq usrnam nil)
        (princ)
)

;       C:END       - Automatically log out user at end of session

(defun C:END ()
        (if usrnam
           (C:logout)
        )
        (command ".end")
)

;       C:RLIST     - List revision information

(defun C:RLIST ()
        (setq s (ssget "X" '((8 . "$REV"))))
        (setq i 0)
        (while (setq e (ssname s i))
           (setq i (1+ i))
           (setq p T)
           (setq lv nil)
           (while p
              (setq e (entnext e))
              (setq ev (entget e))
              (if (= "SEQEND" (cdr (assoc 0 ev)))
                 (setq p nil)
                 (setq lv (append lv (list (cdr (assoc 1 ev)))))
              )
           )
           (princ (strcat "\nECO: " (cadr lv)
              "   Changed by " (car lv) " on " (nth 3 lv)
              ".  Comments: " (caddr lv)))
        )
        (princ)
)

;       C:FINGER    - Identify who changed an entity

(defun C:FINGER ()
        (setq e (car (entsel)))              ; The entity
        (if e
           (progn
              (setq h (cdr (assoc 5 (entget e))))  ; Its handle
              (if (< (strlen h) 16)
                 (setq h (strcat (substr "0000000000000000"
                    1 (- 16 (strlen h))) h))
              )
              (setq s (ssget "X" '((8 . "$REV"))))
              (setq i 0)
              (setq found nil)
              (while (and (null found) (setq e (ssname s i)))
                 (setq i (1+ i))
                 (setq p T)
                 (setq lv nil)
                 (while p
                    (setq e (entnext e))
                    (setq ev (entget e))
                    (if (= "SEQEND" (cdr (assoc 0 ev)))
                       (setq p nil)
                       (setq lv (append lv (list (cdr (assoc 1 ev)))))
                    )
                 )
                 (if (and (> h (nth 4 lv)) (<= h (nth 5 lv)))
                    (setq found lv)
                 )
              )
              (if found
                 (princ (strcat "\nChanged by " (car found)
                    " on " (nth 3 found) " ECO: " (cadr found)
                    " Comments: " (caddr found)))
                 (princ "\nCan't find creator of that entity.")
              )
           )
        )
        (setq s nil)
        (princ)
)

;       INCHAND     - Increment handle (gasp!)

(defun inchand (s / i c os sv)
        (setq os "")
        (setq i 0)
        (setq c 1)
        (while (< i 16)
           (setq i (1+ i))
           (if (= c 1)
              (progn
                 (setq sv (substr s (strlen s)))
                 (setq c 0)
                 (cond
                    ((= sv "9") (setq sv "A"))
                    ((= sv "F") (setq sv "0" c 1))
                    (t (setq sv (chr (1+ (ascii sv)))))
                 )
                 (setq os (strcat sv os))
              )
              (progn
                 (setq os (strcat (substr s (strlen s)) os))
              )
           )
           (setq s (substr s 1 (1- (strlen s))))
        )
        os
)

;       C:SELUSER   - Select entities added by user

(defun C:SELUSER ( / s n i e p lv ev h1 h2 he)
        (setq s (ssget "X" '((8 . "$REV"))))
        (setq n (strcase (getstring T "\nUser name: ")))
        (setvar "CMDECHO" 0)
        (command "select")
        (setq i 0)
        (while (setq e (ssname s i))
           (setq i (1+ i))
           (setq p T)
           (setq lv nil)
           (while p
              (setq e (entnext e))
              (setq ev (entget e))
              (if (= "SEQEND" (cdr (assoc 0 ev)))
                 (setq p nil)
                 (setq lv (append lv (list (cdr (assoc 1 ev)))))
              )
           )
           (if (= (strcase (car lv)) n)
              (progn
                 (setq h1 (inchand (nth 4 lv)))
                 (setq h2 (nth 5 lv))
                 (while (<= h1 h2)
                    (if (setq he (handent h1))
                       (command he)
                    )
                    (setq h1 (inchand h1))
                 )
              )
           )
        )
        (setvar "CMDECHO" 1)
        (getstring "Press any key to continue:")
        (setvar "CMDECHO" 0)
        (command "")
        (setvar "CMDECHO" 1)
        (setq s nil)
        (princ)
)

;       C:SELECO   - Select entities by engineering change order

(defun C:SELECO ( / s n i e p lv ev h1 h2 he)
        (setq s (ssget "X" '((8 . "$REV"))))
        (setq n (strcase 
           (getstring T "\nEngineering change order number: ")))
        (setvar "CMDECHO" 0)
        (command "select")
        (setq i 0)
        (while (setq e (ssname s i))
           (setq i (1+ i))
           (setq p T)
           (setq lv nil)
           (while p
              (setq e (entnext e))
              (setq ev (entget e))
              (if (= "SEQEND" (cdr (assoc 0 ev)))
                 (setq p nil)
                 (setq lv (append lv (list (cdr (assoc 1 ev)))))
              )
           )
           (if (= (strcase (cadr lv)) n)
              (progn
                 (setq h1 (inchand (nth 4 lv)))
                 (setq h2 (nth 5 lv))
                 (while (<= h1 h2)
                    (if (setq he (handent h1))
                       (command he)
                    )
                    (setq h1 (inchand h1))
                 )
              )
           )
        )
        (setvar "CMDECHO" 1)
        (getstring "Press any key to continue:")
        (setvar "CMDECHO" 0)
        (command "")
        (setvar "CMDECHO" 1)
        (setq s nil)
        (princ)
)
(princ)
