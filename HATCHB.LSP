;;; HATCHB.LSP ver 1.6
;;; Recreates hatch boundary by selecting a hatch
;;; Boundary is created in current layer/color/linetype in WCS
;;; By Jimmy Bergmark
;;; Copyright (C) 1997-2002 JTB World, All Rights Reserved
;;; Website: www.jtbworld.com / http://jtbworld.vze.com
;;; E-mail: info@jtbworld.com / jtbworld@hotmail.com
;;; 2000-02-12 - First release
;;; 2000-03-27 - Counterclockwise arc's and ellipse's fixed
;;; Objects created joined to lwpolyline if possible
;;; Error-handling, undo of command
;;; Can handle PLINETYPE = 0,1,2
;;; 2000-03-30 - Integrating hatchb and hatchb14
;;; Selection of many hatches
;;; Splines supported if closed.
;;; 2001-04-02 - Fixed bug with entmake of line with no Z for r14
;;; 2001-07-31 - Removed an irritating semicolon to enable polylines to be created.
;;; 2001-10-04 - Changed mail and homepage so it's easy to find when new versions comes up.
;;; Tested on AutoCAD r14, 2000, 2000i, 2002
;;; should be working on older versions too. 
(defun c:hb () (c:hatchb)) ; this line can be commented out if there is an existing command called hb
(defun c:hatchb (/ es blay ed1 ed2
loops1 bptf part et noe
plist ic bul nr ang1
ang2 obj *ModelSpace*
*PaperSpace* space cw errexit
undox olderr oldcmdecho ss1 lastent
en1 en2 ss lwp
list->variantArray 3dPoint->2dPoint A2k
ent i ss2 knot-list
controlpoint-list kn cn pos
xv area
)
(setq area 0.0)
(setq A2k (wcmatch (getvar "ACADVER") "16*"))
(if A2k
(defun list->variantArray (ptsList / arraySpace sArray)
(setq arraySpace
(vlax-make-safearray
vlax-vbdouble
(cons 0 (- (length ptsList) 1))
)
)
(setq sArray (vlax-safearray-fill arraySpace ptsList))
(vlax-make-variant sArray)
)
)
(if A2k
(defun 3dPoint->2dPoint (3dpt)
(list (float (car 3dpt)) (float (cadr 3dpt)))
)
)
(defun errexit (s)
(princ "\nError: ")
(princ s)
(restore)
)
(defun undox ()
(command "._ucs" "_p")
(command "._undo" "_E")
(setvar "cmdecho" oldcmdecho)
(setq *error* olderr)
(princ)
)
(setq olderr *error*
restore undox
*error* errexit
)
(setq oldcmdecho (getvar "cmdecho"))
(setvar "cmdecho" 0)
(command "._UNDO" "_BE")
(if A2k
(progn
(vl-load-com)
(setq *ModelSpace* (vla-get-ModelSpace
(vla-get-ActiveDocument (vlax-get-acad-object))
)
*PaperSpace* (vla-get-PaperSpace
(vla-get-ActiveDocument (vlax-get-acad-object))
)
)
)
)

; For testing purpose
; (setq A2k nil)

(if (/= (setq ss2 (ssget '((0 . "HATCH")))) nil)
(progn
(setq i 0)
(while (setq ent (ssname ss2 i))
(setq ed1 (entget ent))
(if (not (equal (assoc 210 ed1) '(210 0.0 0.0 1.0)))
(princ "\nHatch not in WCS!")
)
(setq xv (cdr (assoc 210 ed1)))
(command "._ucs" "_w")
(setq loops1 (cdr (assoc 91 ed1)))
; number of boundary paths (loops)
(if (and A2k (= (strcase (cdr (assoc 410 ed1))) "MODEL"))
(setq space *ModelSpace*)
(setq space *PaperSpace*)
)
(repeat loops1
(setq ed1 (member (assoc 92 ed1) ed1))
(setq bptf (cdr (car ed1))) ; boundary path type flag
(setq ic (cdr (assoc 73 ed1))) ; is closed
(setq noe (cdr (assoc 93 ed1))) ; number of edges
(setq ed1 (member (assoc 72 ed1) ed1))
(setq bul (cdr (car ed1))) ; bulge
(setq plist nil)
(setq blist nil)
(cond
((> (boole 1 bptf 2) 0) ; polyline
(repeat noe
(setq ed1 (member (assoc 10 (cdr ed1)) ed1))
(setq plist (append plist (list (cdr (assoc 10 ed1)))))
(setq blist (append blist
(if (> bul 0)
(list (cdr (assoc 42 ed1)))
nil
)
)
)
)
(if A2k
(progn
(setq polypoints
(apply 'append
(mapcar '3dPoint->2dPoint plist)
)
)
(setq VLADataPts (list->variantArray polypoints))
(setq
obj (vla-addLightweightPolyline space VLADataPts)
)
(setq nr 0)
(repeat (length blist)
(if (/= (nth nr blist) 0)
(vla-setBulge obj nr (nth nr blist))
)
(setq nr (1+ nr))
)
(if (= ic 1)
(vla-put-closed obj T)
)
(setq area (+ area (vla-get-area obj)))
(setq obj (vlax-vla-object->ename obj))
(entdel obj)
)
(progn
(if (= ic 1)
(entmake '((0 . "POLYLINE") (66 . 1) (70 . 1)))
(entmake '((0 . "POLYLINE") (66 . 1)))
)
(setq nr 0)
(repeat (length plist)
(if (= bul 0)
(entmake (list (cons 0 "VERTEX")
(cons 10 (nth nr plist))
)
)
(entmake (list (cons 0 "VERTEX")
(cons 10 (nth nr plist))
(cons 42 (nth nr blist))
)
)
)
(setq nr (1+ nr))
)
(entmake '((0 . "SEQEND")))
)
)
)
(t ; not polyline
(setq lastent (entlast))
(setq lwp T)
(repeat noe
(setq et (cdr (assoc 72 ed1)))
(cond
((= et 1) ; line
(setq ed1 (member (assoc 10 (cdr ed1)) ed1))
(if A2k
(vla-AddLine
space
(vlax-3d-point (cdr (assoc 10 ed1)))
(vlax-3d-point (cdr (assoc 11 ed1)))
)
(entmake
(list
(cons 0 "LINE")
(list 10
(cadr (assoc 10 ed1))
(caddr (assoc 10 ed1))
0
)
(list 11
(cadr (assoc 11 ed1))
(caddr (assoc 11 ed1))
0
)
; (cons 210 xv)
)
)
)
(setq ed1 (cddr ed1))
)
((= et 2) ; circular arc
(setq ed1 (member (assoc 10 (cdr ed1)) ed1))
(setq ang1 (cdr (assoc 50 ed1)))
(setq ang2 (cdr (assoc 51 ed1)))
(setq cw (cdr (assoc 73 ed1)))
(if (equal ang2 6.28319 0.00001)
(progn
(if A2k
(vla-AddCircle
space
(vlax-3d-point (cdr (assoc 10 ed1)))
(cdr (assoc 40 ed1))
)
(entmake (list (cons 0 "CIRCLE")
(assoc 10 ed1)
(assoc 40 ed1)
)
)
)
(setq lwp nil)
)
(if A2k
(vla-AddArc
space
(vlax-3d-point (cdr (assoc 10 ed1)))
(cdr (assoc 40 ed1))
(if (= cw 0)
(- 0 ang2)
ang1
)
(if (= cw 0)
(- 0 ang1)
ang2
)
)
(entmake (list (cons 0 "ARC")
(assoc 10 ed1)
(assoc 40 ed1)
(cons 50
(if (= cw 0)
(- 0 ang2)
ang1
)
)
(cons 51
(if (= cw 0)
(- 0 ang1)
ang2
)
)
)
)
)
)
(setq ed1 (cddddr ed1))
)
((= et 3) ; elliptic arc
(setq ed1 (member (assoc 10 (cdr ed1)) ed1))
(setq ang1 (cdr (assoc 50 ed1)))
(setq ang2 (cdr (assoc 51 ed1)))
(setq cw (cdr (assoc 73 ed1)))
(if A2k
(progn
(setq obj (vla-AddEllipse
space
(vlax-3d-point (cdr (assoc 10 ed1)))
(vlax-3d-point (cdr (assoc 11 ed1)))
(cdr (assoc 40 ed1))
)
)
(vla-put-startangle
obj
(if (= cw 0)
(- 0 ang2)
ang1
)
)
(vla-put-endangle
obj
(if (= cw 0)
(- 0 ang1)
ang2
)
)
)
(princ "\nElliptic arc not supported!")
)
(setq lwp nil)
)
((= et 4) ; spline
(setq ed1 (member (assoc 94 (cdr ed1)) ed1))
(setq knot-list nil)
(setq controlpoint-list nil)
(setq kn (cdr (assoc 95 ed1)))
(setq cn (cdr (assoc 96 ed1)))
(setq pos (vl-position (assoc 40 ed1) ed1))
(repeat kn
(setq
knot-list (cons (cons 40 (cdr (nth pos ed1)))
knot-list
)
)
(setq pos (1+ pos))
)
(setq pos (vl-position (assoc 10 ed1) ed1))
(repeat cn
(setq controlpoint-list
(cons
(cons 10 (cdr (nth pos ed1)))
controlpoint-list
)
)
(setq pos (1+ pos))
)
(setq knot-list (reverse knot-list))
(setq controlpoint-list (reverse controlpoint-list))
(entmake (append
(list '(0 . "SPLINE"))
(list (cons 100 "AcDbEntity"))
(list (cons 100 "AcDbSpline"))
(list (cons 70
(+ 1
8
(* 2 (cdr (assoc 74 ed1)))
(* 4 (cdr (assoc 73 ed1)))
)
)
)
(list (cons 71 (cdr (assoc 94 ed1))))
(list (cons 72 kn))
(list (cons 73 cn))
knot-list
controlpoint-list
)
)
(setq ed1 (member (assoc 10 ed1) ed1))
(setq lwp nil)
)
) ; end cond
) ; end repeat noe
(if lwp
(progn
(setq en1 (entnext lastent))
(setq ss (ssadd))
(ssadd en1 ss)
(while (setq en2 (entnext en1))
(ssadd en2 ss)
(setq en1 en2)
)
(command "_.pedit" (entlast) "_Y" "_J" ss "" "")
(setq ename1 (entlast))
(setq ed1 (entget ename1))
(entdel ename1)
(setq noe (cdr (assoc 90 ed1))) ; number of edges
(setq plist nil)
(setq blist nil)
(repeat noe
(setq ed1 (member (assoc 10 (cdr ed1)) ed1))
(setq
plist (append plist (list (cdr (assoc 10 ed1))))
)
(setq blist (append blist
(list (cdr (assoc 42 ed1)))
)
)
)
(if A2k
(progn
(setq polypoints
(apply 'append
(mapcar '3dPoint->2dPoint plist)
)
)
(setq VLADataPts (list->variantArray polypoints))
(setq
obj
(vla-addLightweightPolyline space VLADataPts)
)
(setq nr 0)
(repeat (length blist)
(if (/= (nth nr blist) 0)
(vla-setBulge obj nr (nth nr blist))
)
(setq nr (1+ nr))
)

(vla-put-closed obj T)

(setq area (+ area (vla-get-area obj)))
(setq obj (vlax-vla-object->ename obj))
(entdel obj)
)
(progn
(if (= ic 1)
(entmake '((0 . "POLYLINE") (66 . 1) (70 . 1)))
(entmake '((0 . "POLYLINE") (66 . 1)))
)
(setq nr 0)
(repeat (length plist)
(if (= bul 0)
(entmake (list (cons 0 "VERTEX")
(cons 10 (nth nr plist))
)
)
(entmake (list (cons 0 "VERTEX")
(cons 10 (nth nr plist))
(cons 42 (nth nr blist))
)
)
)
(setq nr (1+ nr))
)
(entmake '((0 . "SEQEND")))
)
)
)
)
) ; end t
) ; end cond
) ; end repeat loops1
(setq i (1+ i))
)
)
)
(restore)
(setq area (rtos area))
(alert (strcat "\nÃæ»ýÎª£º" area "¡£"))
(princ)
)