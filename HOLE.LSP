; **********************************************************************
;                            HOLE.LSP
;
; This routine uses 3dfaces to construct "holes" and "slots"
; in presentation models that will be rendered with AutoShade.
; It generates a rectangular edge of invisible faces around
; the top and bottom of the hole or slot.  This edge makes it
; much easier to attach adjoining faces to the hole.  To see
; this rectangular edge set the system variable "splframe" to 1.
;
; Written by Training Department - 3/01/88
; Added error checking and an error function - 4/27/88
; **********************************************************************

;Internal error handler

(defun MYERROR (s)                    ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
   (if (/= s "Function cancelled")
       (princ (strcat "\nError: " s))
   )
   (entdel temp)
   (if undo                           ; Undo 3dfaces for a clean exit
       (progn
          (command)                   ; simulate CTRL-C (cancel 3DFACE cmd)
          (command "UNDO" "End")      ; terminate Undo group
          (princ " ...undoing ")      ; erase partially-drawn stuff
          (command "U")
       )
   )
   (setvar "blipmode" obm)            ; restore saved BLIPMODE
   (setvar "cmdecho" ocmd)            ; restore saved CMDECHO
   (setq *error* olderr)              ; restore old *error* handler
   (princ)
)

(defun ADD-TO-SET (/ next)
 (while (setq next (entnext last))
  (ssadd next copy-set)
  (setq last (entnext last))
 )
 (setq last (entlast))
)

; Main program

(defun C:HOLE ( / olderr ocmd obm c-elev p-type ip rad 2p depth last
                  temp copy-set ang s-ang rs-ang halfdist one two three
                  four five six seven ur f1 f2 f3 f4 f5 f6 undo)
 (setq olderr  *error*
       *error* myerror)
 (setq ocmd (getvar "cmdecho"))
 (setvar "cmdecho" 0)
 (setq obm (getvar "blipmode"))
 (setq c-elev (getvar "elevation"))
 (setq p-type (strcase (getstring "\nHole or Slot? H/S <S>: ")))
 (if (= p-type "H")
  (progn
   (initget 17)
   (setq ip (getpoint "\nCenter point: "))
   (initget 7)
   (setq rad (getdist ip "\nRadius: "))
  )
  (progn
   (initget 17)
   (setq ip (getpoint "\nFirst center point of slot: "))
   (initget 7)
   (setq rad (getdist ip "\nSlot radius: "))
   (initget 17)
   (setq 2p (getpoint ip "\nSecond center point of slot: "))
  )
 )
 (if (null 2p) (setq 2p ip))
 (initget 7)
 (setq depth (getdist ip "\nDepth: "))
 (prompt "\nPlease wait . . .")
 (setvar "blipmode" 0)
 (command "point" ip)                 ; temporary node
 (setq last (entlast))
 (setq temp last)
 (setq copy-set (ssadd))              ; initialize copy set
 (setq ang (/ pi 10))
 (setq s-ang (angle ip 2p))
 (setq rs-ang (- s-ang pi))
 (setq halfdist (/ (distance ip 2p) 2))
 (setq one   (polar ip (+ rs-ang (* 0 ang)) rad)) ; calculate edge points
 (setq two   (polar ip (+ rs-ang (* 1 ang)) rad))
 (setq three (polar ip (+ rs-ang (* 2 ang)) rad))
 (setq four  (polar ip (+ rs-ang (* 3 ang)) rad))
 (setq five  (polar ip (+ rs-ang (* 4 ang)) rad))
 (setq six   (polar ip (+ rs-ang (* 5 ang)) rad))
 (setq seven (polar six s-ang halfdist))
 (setq ur    (polar one (- s-ang (/ pi 2)) rad))
 (setq f1 (list (car five) (cadr five) c-elev))
 (setq f2 (list (car five) (cadr five) (+ c-elev depth)))
 (setq f3 (list (car six) (cadr six) (+ c-elev depth)))
 (setq f4 (list (car six) (cadr six) c-elev))
 (setq f5 (list (car seven) (cadr seven) c-elev))
 (setq f6 (list (car seven) (cadr seven) (+ c-elev depth)))
 (command "3dface" "i" one   "i" two   "i" ur "i" ur "") ; draw edge
 (setq undo T)                        ; set undo 3dfaces marker
 (command "3dface" "i" two   "i" three "i" ur "i" ur "")
 (command "3dface" "i" three "i" four  "i" ur "i" ur "")
 (command "3dface" "i" four  "i" five  "i" ur "i" ur "")
 (command "3dface" "i" five  "i" six   "i" ur "i" ur "")

 (ADD-TO-SET)

 (command "copy" copy-set "" (list 0 0 0) (list 0 0 depth))
 (command "3dface" f6 f5 f4 f3 f2 f1) (command) ; draw vertical faces
 (command "array" "l" "" "c" ip "-18" 5 "y")    ; 1/4 complete

 (ADD-TO-SET)

 (command "mirror" copy-set "" ip (polar ip s-ang 1) "n")

 (ADD-TO-SET)

 (command "mirror" copy-set "" (polar ip s-ang halfdist)
                               (polar six s-ang halfdist) "n"
 )

 (entdel temp)
 (prompt " done")
 (setvar "blipmode" obm)              ; restore old BLIPMODE
 (setvar "cmdecho" ocmd)              ; restore old CMDECHO
 (setq *error* olderr)                ; restore old *error* handler
 (princ)
)
