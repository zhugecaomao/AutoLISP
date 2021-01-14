;                            PROJECT.LSP

; Allows a "flat" projection of wireframe 3D models (lines, arcs,
; circles, polylines, solids, points) onto the current UCS.  This
; could be a useful aid for generating working drawings from a 3D 
; model.  3dmeshes will not be projected; Width information will 
; not be projected for polylines; Extrusion information will not
; be projected.  Entities not capable of projection will be 
; highlighted and tallied.

; After projection, the user is allowed to make the projection
; into a block, or write it out as a drawing file.  These blocks or
; drawing files (typically Top, Front, Side, and Iso projections)
; could be re-inserted onto a single UCS and annotated to create a
; multi-view orthographic drawing.

; The prompt sequence is:

;  Select entities:  {do so}
;  Project more entities? <N>:  {Y or N}
;  Make projected entity(s) into a block? <N>:  {Y or N}
;  Write projected entities to disk as DWG file? <N>:  {Y or N}

; Written by Jerry Ford & Brad Zehring
; Autodesk Training Department  8/18/88

;----- Standard Error Function ---------------------------------

(defun projerr (st)
 (if (/= st "Function cancelled")
    (princ (strcat "\nError: "s))
 )
 (moder)
 (setq *error* olderr)
 (princ)
)

;----- Mode Save -- Saves designated system variables in a list ---

(defun MODES (a)
   (setq MLST '())
   (repeat (length a)
      (setq MLST (append MLST (list (list (car a) (getvar (car a))))))
      (setq a (cdr a)))
)
;----- Mode Reset -- Resets previously saves system variables ---

(defun MODER ()
   (repeat (length MLST)
      (setvar (caar MLST) (cadar MLST))
      (setq MLST (cdr MLST))
   )
)

;----- Converts radians to degrees ------------------------------

(defun rtd (r)
 (* 180 (/ r pi))
)

;----- Project LINE ---------------------------------------------

(defun lines-pro (/ stpt endpt)
 (setq
  stpt (trans (cdr (assoc 10 elist)) 0 1)
  endpt (trans (cdr (assoc 11 elist)) 0 1)
 )
 (command "line"
  (list (car stpt) (cadr stpt) 0)
  (list (car endpt) (cadr endpt) 0)
  ""
 )
 (setq entset (ssadd (entlast) entset))
)

;-----Project CIRCLE -- circle will be projected as curve fit polyline
; derive 0.3490658504 with (* pi (/ 1.0 9.0))

(defun circ-pro (/ pntlst center radius p-coord p-ctr)
 (setq 
  radius (cdr (assoc 40 elist))
  center (cdr (assoc 10 elist))
  p-ctr 0
  pntlst '("c")  ;initialize point list for PLINE command
 )
 (while (< p-ctr 18)
  (setq p-coord
    (trans 
      (polar center (* p-ctr 0.3490658504) radius)
      ename 1
    )
  )
  (setq p-coord
     (list (car p-coord) (cadr p-coord) (cddr center))
  )
  (setq pntlst  ;build point list
    (cons
      (list 'quote (list (car p-coord) (cadr p-coord)))
      pntlst
    )
  )
  (setq p-ctr (1+ p-ctr))
 )
 (eval (append '(command "pline") pntlst)) ;feed in one COMMAND call
 (command "pedit" "l" "f" "x")
 (setq entset (ssadd (entlast) entset))
)

;----- Project ARC -- arc will be projected as curve fit polyline
; derive 6.2831853072 with (* 2 pi)

(defun arc-pro (/ center radius st-ang end-ang)
 (setq center (cdr (assoc 10 elist))
       radius (cdr (assoc 40 elist))
       st-ang (cdr (assoc 50 elist))
       end-ang (cdr (assoc 51 elist))
 )
 (command "pline")
 (arc-draw center radius st-ang end-ang)
)

(defun arc-draw (center radius st-ang end-ang
                 / pt-num incl-ang angmult p-ctr)
 (setq incl-ang (- end-ang st-ang) p-ctr 0)
 (if (< incl-ang 0) (setq incl-ang (+ 6.2831853072 incl-ang)))
 (setq pt-num (fix (+ 1 (/ incl-ang 0.3927)))) ;set # of pline vertex's
 (if (< pt-num 4) (setq pt-num 4)) ;minimum # of vertex
 (setq angmult (/ incl-ang (- pt-num 1)))
 (while (< p-ctr pt-num)
  (setq p-coord
    (trans
      (polar center (+ st-ang (* p-ctr angmult)) radius)
      ename 1
    )
  )
  (setq p-coord
    (list (car p-coord) (cadr p-coord) (cddr center))
  )
  (command (list (car p-coord) (cadr p-coord)))
  (setq p-ctr (1+ p-ctr))
 )
 (command "") (command "pedit" "l" "f" "x")
 (setq entset (ssadd (entlast) entset))
)

;----- Project PLINE -- polyline will be projected as polyline

(defun pline-pro (/ 2dor3d bit-70 closed)
  (setq 2dor3d nil)
  (setq bit-70 (cdr (assoc 70 elist))) ;type of polyline?
  (if (equal 0 (boole 1 bit-70 1))                    ;test for closure
      (setq closed nil)
      (setq closed (cdr (assoc 10 (entget (entnext ename)))))
  )
  (cond ((= (boole 1 bit-70 8) 8) (setq 2dor3d 0) (pline-dr)); space poly?
        ((= 16 (boole 1 bit-70 16)) (setq reject-ent (ssadd ename reject-ent)));mesh?
        (t (setq 2dor3d ename) (pline-dr));must be 2D poly
  )
)

(defun pline-dr (/ subname sublist sub-etype bulge v-coord
                   sp ep center radius st-ang end-ang)
  (setq subname (entnext ename))
  (setq sublist (entget subname))
  (command "pline")
  (while (eq (setq sub-etype (cdr (assoc 0 sublist))) "VERTEX")
   (if (/= (logand (cdr (assoc 70 sublist)) 16) 16) ;spline frame?
     (progn
       (if (/= (setq bulge (cdr (assoc 42 sublist))) 0) ;bulge?
        (progn
         (setq v-coord (trans (cdr (assoc 10 sublist)) 2dor3d 1))
         (setq v-coord (list (car v-coord) (cadr v-coord)))
         (command v-coord) (command)
         (setq entset (ssadd (entlast) entset))
         (setq sp (cdr (assoc 10 sublist)))
         (if (setq ep (cdr (assoc 10 (entget (entnext subname)))))
           (progn
            (cvtbulge sp ep bulge)
            (command "pline")
            (arc-draw center radius st-ang end-ang)
            (command "pline")
           )
           (if closed
             (progn
              (setq ep closed)
              (cvtbulge sp ep bulge)
              (command "pline")
              (arc-draw center radius st-ang end-ang)
              (setq closed nil)
             )
             (command)
           )
         )
        )
        (progn
         (setq v-coord (trans (cdr (assoc 10 sublist)) 2dor3d 1))
         (setq v-coord (list (car v-coord) (cadr v-coord)))
         (command v-coord)
        )
       )
     )
   )
   (setq subname (entnext subname))
   (setq sublist (entget subname))
  )
  (if closed
      (progn
         (setq v-coord (trans closed 2dor3d 1))
         (setq v-coord (list (car v-coord) (cadr v-coord)))
         (command v-coord)
         (command)
      )
      (command)
  )
  (setq entset (ssadd (entlast) entset))
)

;----- Project 3DFACE -- face will be projected as 1 polyline ---

(defun face-pro (/ c-type corner)
 (setq c-type 10)
 (setq pntlst '("c"))
 (while (< c-type 14)
  (setq corner (trans (cdr (assoc c-type elist)) 0 1))
  (setq pntlst
   (cons (list 'quote (list (car corner) (cadr corner) 0)) pntlst)
  )
  (setq c-type (+ 1 c-type))
 )
 (eval (append '(command "pline") pntlst))
 (setq entset (ssadd (entlast) entset))
)

;----- Project SOLID -- solid will be projected as 1 polyline ----

(defun solid-pro (/ c-type pntlst)
 (setq pntlst '("c")) ;initialize point list for SOLID command
 (setq c-type 10) (findcorner)
 (setq c-type 11) (findcorner)
 (setq c-type 13) (findcorner)
 (setq c-type 12) (findcorner)
 (eval (append '(command "pline") pntlst))  ;feed in one COMMAND call
 (setq entset (ssadd (entlast) entset))
)

(defun findcorner (/ corner)
  (setq corner (trans (cdr (assoc c-type elist)) ename 1))
  (setq pntlst  ;build point list
   (cons (list 'quote (list (car corner) (cadr corner))) pntlst)
  )
)

;----- Project POINT ----------------------------------

(defun point-pro (/ pt)
 (setq pt (trans (cdr (assoc 10 elist)) 0 1))
 (command "point" (list (car pt) (cadr pt) 0))
 (setq entset (ssadd (entlast) entset))
)

;----- Project all entities ---------------------------

(defun proj-ent (/ ctr entities setlength ename elist n-of-ents)
 (prompt "\nExtrusion and mesh information will not be projected. ")
 (setq ctr 0)
 (setq entities (ssget))
 (setq setlength (sslength entities))
 (while (setq ename (ssname entities ctr))
   (setq elist (entget ename)
         etype (cdr (assoc 0 elist))
   )
   (cond ((or (eq etype "LINE") (eq etype "3DLINE")) (lines-pro))
         ((eq etype "CIRCLE") (circ-pro))
         ((eq etype "ARC") (arc-pro))
         ((eq etype "POLYLINE" ) (pline-pro))
         ((eq etype "3DFACE") (face-pro))
         ((eq etype "POINT") (point-pro))
         ((or (eq etype "TRACE") (eq etype "SOLID")) (solid-pro))
         (T (setq reject-ent (ssadd ename reject-ent)))
   )
   (setq ctr (+ ctr 1))
 )
 (setq n-of-ents (sslength reject-ent))
 (princ (strcat "\n" (itoa n-of-ents) " entities not projected"))
 (redraw-rej)
)

;----- Redraw rejected entities --------------------------

(defun redraw-rej (/ r-ctr)
  (setq r-ctr 0)
  (while (> n-of-ents r-ctr)
    (redraw (ssname reject-ent r-ctr) 3)
    (setq r-ctr (1+ r-ctr))
  )
)

;----- Make BLOCK from projected entities ----------------

(defun make-blk (/ blknam blkflg ip)
 (setq blknam (getstring "\nBlock name: "))
 (setq blkflg "")  ;initialize flag to redefine exist block
 (if
   (tblsearch "BLOCK" blknam)
   (while
     (and (tblsearch "BLOCK" blknam) (not (eq blkflg "Y")))
     (prompt (strcat "\nBlock " blknam " already exists. "))
     (setq blkflg (strcase (getstring "\nRedefine it? <N>: ")))
     (if
       (not (eq blkflg "Y"))
       (setq blknam (getstring "\Block name: "))
     )
   )
 )
 (setq ip (getpoint "\nInsertion point <UCS 0,0,0>: "))
 (if (not ip) (setq ip '(0 0 0)))
 (if
   (eq blkflg "Y")
   (command "block" blknam "Y" ip entset "")
   (command "block" blknam ip entset "")
 )
)

;----- Write projected entities to disk as DWG file ------

(defun write-blk (/ flname dwgflg filept ip)
 (setq flname (getstring "\nFile name: "))
 (setq dwgflg "")  ;initialize flag to redefine exist file
 (if  ;file of same name?
   (setq filept (open (strcat flname ".DWG") "r"))
   (progn
     (setq filept (close filept))  ;close file
     (while
       (and 
         (setq filept (open (strcat flname ".DWG") "r"))
         (not (eq dwgflg "Y"))
       )
       (prompt (strcat "\nFile " flname " already exists. "))
       (setq dwgflg (strcase (getstring "\nOverwrite it? <N>: ")))
       (if
         (not (eq dwgflg "Y"))
         (progn
           (setq filept (close filept))
           (setq flname (getstring "\File name: "))
         )
         (setq filept (close filept))
       )
     )
   )
 )
 (setq ip (getpoint "\nInsertion point <UCS 0,0,0>: "))
 (if (not ip) (setq ip '(0 0 0)))
 (if
   (eq dwgflg "Y")
   (command "wblock" flname "Y" "" ip entset "")
   (command "wblock" flname "" ip entset "")
 )
)
;--------- Convert bulge information -------------------
; AutoLISP function to convert from Polyline "Bulge" representation
; of an arc to AutoCAD's normal "center, radius, start/end angles"
; form of arc.  This function applies the bulge between two adjacent
; vertices.  It assumes that global symbols "sp", "ep", and "bulge"
; contain the current vertex (start point), next vertex (end point),
; and bulge, respectively.  It sets the appropriate values in global
; symbols "center", "radius", "st-ang", and "end-ang".

; by Duff Kurland - Autodesk, Inc.
; July 7, 1986


(defun cvtbulge (sp ep bulge / x1 x2 y1 y2 cotbce)
  (setq x1 (car  sp) x2 (car  ep))
  (setq y1 (cadr sp) y2 (cadr ep))
  (setq cotbce (/ (- (/ 1.0 bulge) bulge) 2.0))

  ; Compute center point and radius

  (setq center (list (/ (+ x1 x2 (- (* (- y2 y1) cotbce))) 2.0)
                     (/ (+ y1 y2    (* (- x2 x1) cotbce) ) 2.0)
                     (caddr sp)
               )
  )
  (setq radius (distance center sp))

  ; Compute start and end angles

  (setq st-ang  (atan (- y1 (cadr center)) (- x1 (car center))))
  (setq end-ang  (atan (- y2 (cadr center)) (- x2 (car center))))
  (if (< st-ang 0.0)                      ; Eliminate negative angles
     (setq st-ang (+ st-ang (* 2.0 pi)))
  )
  (if (< end-ang 0.0)
     (setq end-ang (+ end-ang (* 2.0 pi)))
  )
  (if (< bulge 0.0)                   ; Swap angles if clockwise
     (progn
        (setq temp st-ang)
        (setq st-ang end-ang)
        (setq end-ang temp)
     )
  )
)

;----- Select entities, test for entity type and call approprite function

(defun C:PROJECT (/ olderr reject-ent entset)
 (setq olderr *error* *error* projerr)
 (modes '("cmdecho" "blipmode" "expert" "flatland"))
  (mapcar 'setvar
          '("cmdecho" "blipmode" "expert" "flatland")
          '(0 0 1 0)
  )
 (setq reject-ent (ssadd))
 (setq entset (ssadd))

 (proj-ent)
 (while  ;continue projecting more selection sets?
   (eq (strcase (getstring "\nProject more entities? <N>: ")) "Y")
   (proj-ent)
 )
 (cond
   ((eq (strcase
        (getstring "\nMake projected entity(s) into block? <N>: ")
        ) "Y"
    )
    (make-blk)
   )
   ((eq (strcase
    (getstring "\nWrite projected entity(s) to disk as DWG file? <N>: ")
        ) "Y"
    )
    (write-blk)
   )
   (T)
 )
 (moder)
 (setq *error* olderr)
 (princ)
)

