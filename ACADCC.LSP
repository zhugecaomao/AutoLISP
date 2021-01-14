;----------------TO DRAW TOLERANCE HORIZONTALLY------------*
(vmon)
(DEFUN C:DTLH ()
       (SETQ VA1 3.60)
       (SETQ VA2 (* 0.6 VA1))
       (SETQ VA3 (* 0.8 VA1))
       (SETQ OVER (GETSTRING "OVER :"))
       (SETQ UNDER (GETSTRING "UNDER :"))
       (SETQ P1 (GETPOINT "INSERT POINT :"))
       (COMMAND "TEXT" P1 VA2 "0" UNDER
                "TEXT" (LIST (CAR P1) (+ (CADR P1) VA3)) VA2 "0" OVER)
)
;----------------------------------------------------------*
;----------------TO DRAW TOLERANCE VERTICALLY--------------*
(DEFUN C:DTLV ()
       (SETQ VA1 3.60)
       (SETQ VA2 (* 0.6 VA1))
       (SETQ VA3 (* 0.8 VA1))
       (SETQ OVER (GETSTRING "OVER :"))
       (SETQ UNDER (GETSTRING "UNDER :"))
       (SETQ P1 (GETPOINT "INSERT POINT :"))
       (COMMAND "TEXT" P1 VA2 "90" UNDER
                "TEXT" (LIST (- (CAR P1) VA3) (CADR P1)) VA2 "90" OVER)
)
;----------------------------------------------------------*
;........... TO DRAW A LINE WITH TAPER.....................*
(defun c:tpline ()
       (setq v1 (getvar "cmdecho"))
       (setvar "cmdecho" 0)
       (setq pt (getpoint "\nEnter base point:"))
       (setq d1 (getdist pt "\nEnter offset distance:"))
       (if (/= 0 d1)
           (setq dr (getint "\nEnter offset direction in 0 90 180 270:"))
           (setq dr '())
       )
       (cond
           ((= 0 dr) (setq p1 (list (+ (car pt) d1) (cadr pt))))
           ((= 90 dr) (setq p1 (list (car pt) (+ (cadr pt) d1))))
           ((= 180 dr) (setq p1 (list (- (car pt) d1) (cadr pt))))
           ((= 270 dr) (setq p1 (list (car pt) (- (cadr pt) d1))))
           (t (setq p1 pt))
       )
       (setq dg (getangle p1 "\nAngle of taper in xx.xx degree:"))
       (setq l (getdist p1 "\nLength:"))
       (setq a (getangle p1 "\nWhich direction :"))
       (setq lr (/ l (cos dg)))
       (cond
            ((<= a (/ pi 4)) (setq r dg))
            ((and (>= a (/ pi 4)) (<= a (/ pi 2))) (setq r (- (/ pi 2) dg)))
            ((and (>= a (* pi 0.5)) (<= a (* pi 0.75))) (setq r (+ (/ pi 2) dg)))
            ((and (>= a (* pi 0.75)) (<= a pi)) (setq r (- pi dg)))
            ((and (>= a pi) (<= a (* pi 1.25))) (setq r (+ pi dg)))
            ((and (>= a (* pi 1.25)) (<= a (* pi 1.5))) (setq r (- (* pi 1.5) dg)))
            ((and (>= a (* pi 1.5)) (<= a (* pi 1.75))) (setq r (+ (* pi 1.5) dg)))
            ((and (>= a (* pi 1.75)) (<= a (* pi 2))) (setq r (- (* pi 2) dg)))
       )
       (command "line" p1
                (polar p1 r lr)
                ""
       )
       (setvar "cmdecho" v1)
)
;----------------------------------------------------------*
;..................TO DRAW COUNTERBORE WITH CLEARANCE OPTION................*
(defun c:contbor ()
        (setq v1 (getvar "cmdecho"))
        (setvar "cmdecho" 0)
        (setq p1 (getpoint "\nInsert point:"))
        (setq l2 (getdist p1 "\nEnter the full length of hole:"))
        (setq dl (getdist p1 "\nEnter the diameter of large hole:"))
        (setq l1 (getdist p1 "\nEnter the depth of large hole:"))
        (setq ds (getdist p1 "\nEnter the diameter of small hole:"))
        (setq l4 (- l2 l1))
        (setq a (getint "\nDirection in 0 90 180 270 :"))
        (setq cl (float (getdist p1 "\nEnter the clearance :")))
        (if (/= 0 cl)
             (setq l3 (getdist p1 "\nEnter the depth of clearance:"))
        )
        (command "line"
                (setq p (list (car p1) (- (cadr p1) (/ dl 2))))
                (setq p2 (polar p 0 l1))
                (setq p (polar p2 (/ pi 2) dl))
                (polar p pi l1)
                ""
                "line"
                (setq p (list (car p2) (- (cadr p1) (/ ds 2))))
                (polar p 0 l4)
                ""
                "mirror" "last" "" p1 (polar p1 0 100) "no"
        )
        (if (/= 0 cl)
            (progn
             (setq dsc (+ (/ ds 2) cl))
             (setq dsd (+ (* cl 2) ds))
             (command "line"
                 (setq p4 (list (car p2) (- (cadr p1) dsc)))
                 (setq p7 (polar p4 0 l3))
                 (setq p (polar p7 (/ pi 2) dsd))
                 (polar p pi l3) ""
                 "trim"
                 (list (car p7) (+ (cadr p7) (/ dsd 2))) ""
                 (list (- (car p7) (/ l3 2)) (+ (cadr p7) cl 1))
                 (list (- (car p7) (/ l3 2)) (-(+ (cadr p7) ds cl ) 1)) ""
             )
            )
        )
        (cond
             ((= a 0) (redraw))
             (t (command "rotate" "window"
                        (list (- (car p1) 1) (- (cadr p1) (/ dl 2) 1))
                        (list (+ (car p1) l2 1) (+ (cadr p1) (/ dl 2) 1))
                        "" p1 a
                )
             )
         )
         (redraw)
         (setvar "cmdecho" v1)
)
;---------------------------------------------------------
;DRAW BILL OF MATERIAL
;
(DEFUN C:BM (/ P1 P2 P3 P4 P5 P6 P7 P8 N1 L1 T1 T2 T3 T4 T5)
  (SETQ P1 (GETPOINT "\nEnter original point:"))
  (SETQ N1 (GETINT "\nEnter number of row:"))
  (SETVAR "BLIPMODE" 0)
  (SETQ L1 (* 7.5 N1))
    (WHILE (>= L1 7.5)
      (SETQ T1 (GETINT "\nDET.: "))
      (MENUCMD "S=MOLDNAME")
      (SETQ T2 (STRCASE (GETSTRING T "\nDESCRIPTION:(Select specification from screen menu...) ")))
      (SETQ T3 (STRCASE (GETSTRING T "\nMAT. SIZE: ")))
      (MENUCMD "S=STEEL")
      (SETQ T4 (STRCASE (GETSTRING T "\nMATL:(Select specification from screen menu...) ")))
      (SETQ T5 (GETINT "\nQ'TY: "))
      (SETQ T6 (STRCASE (GETSTRING T "\nREMARK: ")))
      (SETVAR "CMDECHO" 0)
      (SETQ P2 (POLAR P1 (/ PI 2) 7.5))
      (COMMAND "LINE" P2 (LIST (+ (CAR P1) 165) (CADR P2)) ""
               "LINE" P1 P2 ""
               "LINE" (LIST (+ (CAR P1) 20) (CADR P1))
                      (LIST (+ (CAR P1) 20) (CADR P2)) ""
               "LINE" (LIST (+ (CAR P1) 60) (CADR P1))
                      (LIST (+ (CAR P1) 60) (CADR P2)) ""
               "LINE" (LIST (+ (CAR P1) 105) (CADR P1))
                      (LIST (+ (CAR P1) 105) (CADR P2)) ""
               "LINE" (LIST (+ (CAR P1) 120) (CADR P1))
                      (LIST (+ (CAR P1) 120) (CADR P2)) ""
               "LINE" (LIST (+ (CAR P1) 140) (CADR P1))
                      (LIST (+ (CAR P1) 140) (CADR P2)) ""
               "LINE" (LIST (+ (CAR P1) 165) (CADR P1))
                      (LIST (+ (CAR P1) 165) (CADR P2)) ""
      )
         (SETQ P3 (POLAR (LIST (+ (CAR P1) 2.5) (CADR P1)) (/ PI 4) 3))
         (SETQ P4 (POLAR (LIST (+ (CAR P1) 22.5) (CADR P1)) (/ PI 4) 3))
         (SETQ P5 (POLAR (LIST (+ (CAR P1) 140) (CADR P1)) (/ PI 4) 3))
         (SETQ P6 (POLAR (LIST (+ (CAR P1) 62.5) (CADR P1)) (/ PI 4) 3))
         (SETQ P7 (POLAR (LIST (+ (CAR P1) 104) (CADR P1)) (/ PI 4) 3))
         (SETQ P8 (POLAR (LIST (+ (CAR P1) 125) (CADR P1)) (/ PI 4) 3))
         (COMMAND "TEXT" P3 3 0 T1
                  "TEXT" P4 3 0 T2
                  "TEXT" P6 3 0 T3
                  "TEXT" P7 3 0 T4
                  "TEXT" P8 3 0 T5
                  "TEXT" P5 3 0 T6
         )
       (SETQ P1 P2)
       (SETQ L1 (- L1 7.5))
       (SETVAR "CMDECHO" 1)
    )
  (SETVAR "BLIPMODE" 1)
  (TERPRI)
)
;-------------------------------------------------------------------------
;Draw water channels
(defun C:WC (/ i1 a1 a2 m1 l1 d1 i2 i3 i4 i5 i6)
;Convert angle in degrees to radians
     (defun dtr (a)
        (* pi (/ a 180.0))
     )
   (setq i1 (getpoint "\nInsert point: "))
   (setq d1 (getreal "\nDiameter <6/8/10/12>: "))
   (setq a1 (getangle i1 "\nAngle <0>: "))
   (if (= a1 nil) (setq a1 0))
   (setq a2 (rtos (* 180.0 (/ a1 pi)) 2 2))
   (setq m1 (strcase (getstring "\nEnter PT or WPT or return for none: ")))
   (prompt "\nSelect specification from screen menu: ")
   (cond
      ((or (= m1 "PT") (= m1 "P"))
       (menucmd "S=PPT")
       (command "insert" pause i1 1 a2)
       (menucmd "S=S")
      )
      ((or (= m1 "W") (= m1 "WP") (= m1 "WPT"))
       (menucmd "S=WWPt")
       (command "insert" pause i1 1 a2)
       (menucmd "S=S")
      )
   )
   (setq l1 (getdist i1 "\nLength: "))
   (setq angp90 (+ a1 (dtr 90)))
   (setq angm90 (- a1 (dtr 90)))
   (setq i2 (polar i1 angm90 (/ d1 2)))
   (setq i3 (polar i2 a1 l1))
   (setq i4 (polar i3 angp90 d1))
   (setq i5 (polar i4 (+ a1 (dtr 180)) l1))
   (setq i6 (polar i3 angp90 (/ d1 2)))
   (setq o1 (strcase (getstring "\nRequire o-ring? <N>:")))
   (if (or (= o1 "") (= o1 "N") (= o1 "NO"))
       (progn
         (setvar "CMDECHO" 0)
         (command "line" i2 i3 i4 i5 "")
         (cond
          ((= d1 6) (command "insert" "*s6" i6 1 a2))
          ((= d1 8) (command "insert" "*s8" i6 1 a2))
          ((= d1 10) (command "insert" "*s10" i6 1 a2))
          ((= d1 12) (command "insert" "*s12" i6 1 a2))
         )
       )
       (progn
         (setvar "CMDECHO" 0)
         (command "line" i2 i3 ""
                  "line" i4 i5 ""
         )
         (cond
          ((= d1 6) (command "insert" "*p10f" i6 1 a2))
          ((= d1 8) (command "insert" "*p12f" i6 1 a2))
          ((= d1 10) (command "insert" "*p14f" i6 1 a2))
          ((= d1 12) (command "insert" "*p16f" i6 1 a2))
         )
       )
   )
   (setvar "CMDECHO" 1)
)
;-----------------------------------------------------------------------
;Quick change specificed layer of existed entities
(DEFUN C:QCHNG ()
   (PRINC "\nSelect objects to be changed...\n")
   (COMMAND "SELECT" "AU" "\\")
   (SETQ S1 "P")
   (SETVAR "CMDECHO" 0)
   (IF S1 (COMMAND "CHANGE" S1 "" "P" "COLOR" "BYLAYER" "LT" "BYLAYER" "LA" LR ""))
   (SETVAR "CMDECHO" 1)
   (PRINC)
)
;-----------------------------------------------------------------------
;create an intersection point by two lines
(defun C:PNT (/ a1 a2)
    (setq a1 (entget (car (entsel "Select line1:"))))
    (princ)
    (setq a2 (entget (car (entsel "Select line2:"))))
    (command "point" (inters (cdr (assoc 10 a1)) (cdr (assoc 11 a1))
                             (cdr (assoc 10 a2)) (cdr (assoc 11 a2)) nil
                     )
    )
)
;------------------------------------------------------------------------
;DIMENSION MISCELLANEOUS PART
(DEFUN C:MISS (/ K1 K2 K3)
  (MENUCMD "S=MISS")
  (SETQ K2 (GETSTRING "\nSelect iterm  then  specification:"))
  (MENUCMD "S=NUM")
  (SETQ K3 (GETSTRING "\nSelect number or RETURN for none:"))
  (MENUCMD "S=S")
  (COMMAND "DIM" "LEADER" PAUSE PAUSE "" (STRCAT K3 K2))
)
;-----------------------------------------------------------------------
;DRAW A PROJECTED LINE OF 45ø
(DEFUN C:TRI (/ UX2 UX3)
   (IF UX1
    (KK)
    (PROGN
     (SETVAR "OSMODE" 512)
     (SETVAR "APERTURE" 3)
     (setq UX1 (entget (car (entsel "\nSelect 45%%c line:"))))
     (SETVAR "APERTURE" 5)
     (SETVAR "OSMODE" 0)
     (KK)
    )
   )
)
(DEFUN KK ()
     (SETVAR "CMDECHO" 1)
     (SETVAR "ORTHOMODE" 1)
     (terpri)
     (COMMAND "LINE" PAUSE PAUSE "")
     (SETQ UX2 (entget (entlast)))
     (SETQ UX3 (inters (cdr (assoc 10 UX1)) (cdr (assoc 11 UX1))
                       (cdr (assoc 10 UX2)) (cdr (assoc 11 UX2)) nil
               )
     )
     (SETVAR "ORTHOMODE" 1)
     (terpri)
     (COMMAND "LINE" UX3 PAUSE "")
     (SETVAR "ORTHOMODE" 0)
)
;  ------------TO DRAW BOX---------
(DEFUN C:BOX ()
   (setq C1 (getpoint "\nInsert point: "))
   (setq C2 (getDIST C1 "\nLength in X direction : "))
   (setq C3 (getDIST C1 "\nLength in Y direction : "))
   (COMMAND "LINE" C1
         (SETQ C4 (POLAR C1 0 C2))
         (SETQ C5 (POLAR C4 (/ PI 2) C3))
                  (POLAR C5 PI  C2) "C"
   )
)
;-----------------------------------------------------------------------
(defun *error* (st)
   (prompt "\nERROR: ")
   (prompt st)
   (prompt "\nPress ^C to quit.")
   (terpri)
   (grread)
)
(setq P_t 0 P_1 0 dtl 0 Ts 0)
(defun Lp (E1 E2 C1 / Pm X Y B)
   (if (> 0.001 (abs (- (car E2) (car E1))))
      (setq X (car E1) Y (cadr C1))
      (setq M (/ (- (cadr E2) (cadr E1)) (- (car E2) (car E1)))
            B (- (cadr E1) (* M (car E1)))
            X (/ (- (+ (* M (cadr C1)) (car C1)) (* M B)) (+ 1. (* M M)))
            Y (+ (* M X) B)
      )
   )
   (setq Pm (list X Y))
)
(defun clean()
   (setq atomlist (member 'clean atomlist))
   'DONE
)
(vmon)
;-------------------------
;(SETQ F1 (OPEN "C:/SD.INI" "r"))
;(SETQ F2 (OPEN "C:/MIRROR.FIL" "r"))
(vmon)
;*-------
(defun dtr (a)
  (* pi (/ a 180.0))
 )
;*-------
(defun rtd (a)
  (/  (* a 180.0) pi)
 )
*----------------

*----------------
(DEFUN C:O()
(COMMAND "OSNAP" "NEAR")
(COMMAND "SNAP" "OFF")
(SETQ P2 (OSNAP (SETQ P1 (GETPOINT"\nSELECT LINE:" )) "MID" ))
(COMMAND "SNAP" "R" P1 P2)
(COMMAND "SNAP" "OFF")
(COMMAND "OSNAP" "NONE")
)
*----------------
(DEFUN C:Z()
   (COMMAND "SETVAR" "HIGHLIGHT" 1)
 )
*------------------
(defun C:CONFIG()
  (SETQ ANS (GETSTRING T "\nDO YOU WANT CONFIG TABLET ? (Y/N)"))
  (IF (= ANS "Y")
    (PROGN
      (setvar "cmdecho" 1)
      (command "tablet" "cfg" "0" "")
      (COMMAND "VSLIDE" "/acad/HON/SLD/CONFIG")
      (command "tablet" "cfg" "4" "25" "9" "11" "9" "4" "13" "25" "7" "Y")(redraw)
    )
    (setvar "cmdecho" 0)
  )
)
*----------------
(DEFUN C:F()
(COMMAND "SNAP" "R" P1 0)
(COMMAND "OSNAP" "NONE")
(COMMAND "SNAP" "OFF")
)
*------------------------
;(DEFUN *ERROR* (STOP)
;  (PRINC "AUTOLISP DISABLE")
;  (TERPRI)
;)
(PRINC "\n UJ MOLD-CAD SERIAL VERSION V2.12 ")
