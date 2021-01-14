; =============================== SORT.LST ================================
; ***** This rountine will graphically sort the drawing for efficient *****
; **************** plotting, storage, retrieval and redraws ***************
; Usage:  SORT<enter>
;         After you enter the SORT command, you will be prompted
;         to enter the size of the sort "squares" or "window" you
;         wnat. You should enter the size in whatever units are
;         currently assigned to the drawing. After the drawing
;         has been sorted, it will be saved to the hard disk
;         using the "WBLOCK" command. As a safety measure, you
;         will be asked to specify the name of the file which
;         will be saved. You are free to choose the current
;         drawing name or a different one.

; ------------------------------- BEGIN () --------------------------------
;         Introduce user(s) to the SORT program & decide if to continue.

  (defun begin ()
    (prompt "ONLY VISIBLE LAYERS WILL BE SORTED!")
    (setq start (strcase
      (getstring "\nEnter C to continue... or any other key to quit")))
    (if (/= start "C") (haltprogram) (continue))
  ) ; endbegin

; ----------------------------- CONTINUE () -------------------------------
;         The sorting and other major routines are performed here.

  (defun continue ()
    (setq cname (getvar "dwgname"))
    (prompt "\nEnter DWG name under which to save sorted drawing...")
    (setq dname (getstring "\nor <RETURN> to use the current DWG name: "))
    (setq tempfile (open "dname.dwg" "r")) ;   check for existence of
    (if (/= tempfile nil)                  ;   current/drawing file
      (setq filexist T) (setq filexist nil)
    ) ; endif
    (if (= dname "") (setq dname cname))   ;   Determine sort window size
    (setq xwindow (atof (getstring "\nEnter X size of sort window: "))
          ywindow (atof (getstring "\nEnter Y size of sort window: "))
            lleft (list       ; lower left corner of zoom window
                  (1- (car (getvar "extmin"))) (1- (cadr (getvar "extmin"))))
           uright (list       ; upper right corner of zoom window
                  (1+ (car (getvar "extmax"))) (1+ (cadr (getvar "extmax"))))
              ll1 lleft       ; lower left corner of first sort window
              ur1 (list       ; upper right corner of first wort window
                  (+ (car lleft) xwindow) (+ (cadr lleft) ywindow))
               ll ll1
               ur ur1
        maxcountx (fix (1+
                  (/ (- (car uright) (car lleft)) xwindow)))   ; # of columns
        maxcounty (fix (1+
                  (/ (- (cadr uright) (cadr lleft)) ywindow))) ; # of rows
           countX 1
           countY 1
    ) ; endsetq
    (command "zoom" "w" lleft uright) ;Zoom to include all geometry+extra
    (if (= cname dname)
        (command "wblock" dname "Y" "" "0,0" "c" ll ur) ; File already exists
        (command "wblock" dname "" "0,0" "c" ll ur)     ; New file
    ) ; endif
    (while (<= countY maxcountY) ; Calculate & set up sort windows
      (command "crossing" ll ur)
      (setq ll (list (+ (car ll) xwindow) (cadr ll))
            ur (list (+ (car ur) xwindow) (cadr ur))
            countX (1+ countX)
      ) ; endsetq
      (if (> countX maxcountX)
        (setq ll (list (car ll1) (cadr ur))
              ur (list (car ur1) (+ (cadr ur) ywindow))
              countY (1+ countY)
              countX 1
        ) ; endsetq
      ) ; endif
    ) ; endwhile
    (command "crossing" lleft uright "")
    (setq halt T)
  ) ; endcontinue

; ----------------------------- HALTPROGRAM () ----------------------------

  (defun haltprogram ()
    (setq halt T)
    (princ "Program Hlated.")
    (princ)
  )

; -------------------------------- SORT () --------------------------------

;****************************** Main Function *****************************

(vmon)
(defun C:SORT ()
  (setq halt nil)       ; Initialize variables(s)
  (while (/= halt T)    ; Disable ONSNAP to be sure all geometry is selected
    (setq osnp (getvar "osmode"))
    (if (/= osnp 0)
      (setvar "osmode" 0)
    ) ; endif
    (begin)
  ) ; endwhile
  (setvar "osmode" osnp)
  (princ)
) ; endSORT

;--------------------------------------------------------------------------
