;--------------------------------------------------------------------------
; 3D.LSP
; 
; The user may initiate 3d.lsp by picking "3d objects" from the screen      
; menu, or by selecting the objects themselves from the "3d Construction"
; icon menu, or by loading it. Nine 3d objects can be drawn including 
; a box, cone, dish, dome, mesh, pyramid, sphere, torus, and wedge.
;
; When constructing a pyramid with the "ridge" option, enter the ridge
; points in the same direction as the base points, ridge point one being
; closest to base point one.  This will prevent the "bowtie" effect.
; Note that this is also true for the pyramid's "top" option.
;
; by Simon Jones - Autodesk UK Ltd.
; and Duff Kurland - Autodesk, Inc.
; November, 1986
;
; Combined into a single "3D" command - July 1987
;
; Changed functions to build shapes using the surface commands, and
; added box, wedge, pyramid, and mesh. - March 1988
;--------------------------------------------------------------------------
; Allow easier reloads

(setq boxwed     nil  
      cone       nil
      mesh       nil
      pyramid    nil
      spheres    nil
      torus      nil
      3derr      nil
      C:3D       nil)

;--------------------------------------------------------------------------
; System variable save

(defun modes (a)
   (setq MLST nil)
   (repeat (length a)
      (setq MLST (append MLST (list (list (car a) (getvar (car a))))))
      (setq a (cdr a))
   )
)

;--------------------------------------------------------------------------
; System variable restore

(defun moder ()
   (repeat (length MLST)
      (setvar (caar MLST) (cadar MLST))
      (setq MLST (cdr MLST))
   )
)

;--------------------------------------------------------------------------
;Draw a cone

(defun cone (/ elev cen1 rad top h numseg cen2 oldelev e1 e2)
   (setq numseg 0)
   (initget 17)                       ;3D point can't be null
   (setq elev (caddr (setq cen1 (getpoint "\nBase center point: "))))
   (initget 7 "Diameter")             ;Base radius can't be 0, neg, or null
   (setq rad (getdist cen1 "\nDiameter/<radius> of base: "))
   (if (= rad "Diameter")
      (progn
         (initget 7)                  ;Base diameter can't be 0, neg, or null
         (setq rad (/ (getdist cen1 "\nDiameter of base: ") 2.0))
      )
   )
 
   (initget 4 "Diameter")             ;Top radius can't be neg
   (setq top (getdist cen1 "\nDiameter/<radius> of top <0>: "))
   (if (= top "Diameter")
      (progn
         (initget 4)                  ;Top diameter can't be neg
         (setq top (getdist cen1 "\nDiameter of top <0>: "))
         (if top
            (setq top (/ top 2.0))
         )
      )
   )
   (if (null top)
      (setq top 0.0)
   )
   
   (initget 7 "Height")               ;Height can't be 0, neg, or null
   (setq h (getdist cen1 "\nHeight: "))
 
   (while (< numseg 2)                ;SURFTAB1 can't be less than 2
      (initget 6)
      (setq numseg (getint "\nNumber of segments <16>: "))
      (if (null numseg)
         (setq numseg 16)
      )  
      (if (< numseg 2)
         (princ "\nNumber of segments must be greater than 1.")
      )
   )
   (setvar "SURFTAB1" numseg)

   (command "CIRCLE" cen1 rad)        ;Draw base circle
   (setq undoit T)
   (setq e1 (entlast))
   (setq cen2 (list (car cen1) (cadr cen1) (+ (caddr cen1) h)))
   (setq oldelev (getvar "ELEVATION"))
   (command "ELEV" (+ elev h) "")
   (cond ((= top 0.0) (command "POINT" cen2)) ;Draw top point or circle
         (t (command "CIRCLE" cen2 top))
   )
   (setq e2 (entlast))
   (setvar "ELEVATION" oldelev)

   (command "RULESURF" (list e1 cen1) (list e2 cen2)) ;Draw cone
   (entdel e1) 
   (entdel e2)
)

;--------------------------------------------------------------------------
;Draw a sphere, dome, or dish

(defun spheres (typ / cen r numseg ax ax1 e1 e2)
   (setq numseg 0)
   (initget 17)                       ;3D point can't be null
   (setq cen (getpoint (strcat "\nCenter of " typ": ")))
   (initget 7 "Diameter")             ;Radius can't be 0, neg, or null
   (setq r (getdist cen (strcat "\nDiameter/<radius>: ")))
   (if (= r "Diameter")
      (progn
         (initget 7)                  ;Diameter can't be 0, neg, or null
         (setq r (/ (getdist cen (strcat "\nDiameter: ")) 2.0))
      )
   )
   (setq cen (trans cen 1 0))         ;Translate from UCS to WCS
         
   (while (< numseg 2)                ;SURFTAB1 can't be less than 2
      (initget 6)
      (setq numseg (getint "\nNumber of longitudinal segments <16>: "))
      (if (null numseg)
         (setq numseg 16)
      )
      (if (< numseg 2)
         (princ "\nNumber of segments must be greater than 1.")
      )
   )
   (setvar "SURFTAB1" numseg)
    

   (setq numseg 0)
   (while (< numseg 2)                ;SURFTAB2 can't be less than 2
      (initget 6)
      (princ "\nNumber of latitudinal segments ") 
      (if (= typ "sphere")
         (princ "<16>: ")             ;Set default to 16 for a sphere
         (princ "<8>: ")              ;Set default to 8 for a dome or dish
      )
      (setq numseg (getint))
      (if (null numseg)
         (if (= typ "sphere")
            (setq numseg 16)
            (setq numseg 8)
         )
      )
      (if (< numseg 2)
         (princ "\nNumber of segments must be greater than 1.")
      )
   )
   (setvar "SURFTAB2" numseg)

   (command "UCS" "x" "90")
   (setq undoit T)

   (setq cen (trans cen 0 1))         ;Translate from WCS to UCS
   (cond
       ((= typ "sphere")
          (setq ax (list (car cen) (+ (cadr cen) r) (caddr cen)))
          (setq ax1 (list (car cen) (- (cadr cen) r) (caddr cen)))
          (command "3DLINE" ax ax1 "") ;Draw axis of revolution
          (setq e1 (entlast))
          (command "ARC" ax "e" ax1 "a" "180.0") ;Draw path curve
          (setq e2 (entlast)))
       (t
          (if (= typ "dome")
             (setq ax (list (car cen) (+ (cadr cen) r) (caddr cen)))
             (setq ax (list (car cen) (- (cadr cen) r) (caddr cen)))
          )
          (command "3DLINE" cen ax "") ;Draw axis of revolution
          (setq e1 (entlast))
          (command "ARC" "c" cen ax "a" "90.0") ;Draw path curve
          (setq e2 (entlast)))
   )

   (command "REVSURF" (list e2 ax) (list e1 cen) "" "") ;Draw dome or dish
   (entdel e1)                 
   (entdel e2)
   (command "UCS" "prev")
)

;--------------------------------------------------------------------------
;Draw a torus

(defun torus (/ cen l trad numseg hrad tcen ax e1 e2)
   (setq numseg 0)
   (initget 17)                       ;3D point can't be null
   (setq cen (getpoint "\nCenter of torus: "))
   (setq trad 0 l -1)
   (while (> trad (/ l 2.0))
      (initget 7 "Diameter")          ;Radius can't be 0, neg, or null
      (setq l (getdist cen "\nDiameter/<radius> of torus: "))
      (if (= l "Diameter")
         (progn
            (initget 7)               ;Diameter can't be 0, neg, or null
            (setq l (/ (getdist cen "\nDiameter: ") 2.0))
         )
      )
      (initget 7 "Diameter")          ;Radius can't be 0, neg, or null
      (setq trad (getdist cen "\nDiameter/<radius> of tube: "))
      (if (= trad "Diameter")
         (progn
            (initget 7)
            (setq trad (/ (getdist cen "\nDiameter: ") 2.0))
         )
      )
      (if (> trad (/ l 2.0))
         (prompt "\nTube diameter cannot exceed torus radius.")
      )
   )
   (setq cen (trans cen 1 0))         ;Translate from UCS to WCS

   (initget 6)                        ;SURFTAB1 can't be 0 or neg
   (setq numseg (getint "\nSegments around tube circumference <16>: "))
   (if (null numseg)
      (setq numseg 16)
   )
   (setvar "SURFTAB1" numseg)

   (setq numseg 0)
   (initget 6)                        ;SURFTAB2 can't be 0 or neg
   (setq numseg (getint "\nSegments around torus circumference <16>: "))
   (if (null numseg)
      (setq numseg 16)
   )
   (setvar "SURFTAB2" numseg)

   (command "UCS" "x" "90")
   (setq undoit T)

   (setq cen (trans cen 0 1))         ;Translate from WCS to UCS
   (setq hrad (- l (* trad 2.0)))
   (setq tcen (list (+ (+ (car cen) trad) hrad) (cadr cen) (caddr cen)))
   (setq ax (list (car cen) (+ (cadr cen) 2.0) (caddr cen)))

   (command "CIRCLE" tcen trad)       ;Draw path curve
   (setq e1 (entlast))
   (command "3DLINE" cen ax "")       ;Draw axis of revolution
   (setq e2 (entlast))
   (command "REVSURF" (list e1 tcen) (list e2 ax) "" "") ;Draw torus
   (entdel e1)            
   (entdel e2)
   (command "UCS" "prev")
)

;--------------------------------------------------------------------------
;Draw a box or wedge

(defun boxwed (typ / pt1 l w h1 h2 a ang pt2 pt3 pt4 pt5 pt6 pt7 pt8)
   (initget 17)                       ;3D point can't be null
   (setq pt1 (getpoint (strcat "\nCorner of "typ": ")))
   (setvar "ORTHOMODE" 1)
   (initget 7)                        ;Length can't be 0, neg, or null
   (setq l (getdist pt1 "\nLength: "))
   (setq pt3 (list (+ (car pt1) l) (cadr pt1) (caddr pt1)))
   (grdraw pt1 pt3 2)
   (cond ((= typ "wedge")
            (initget 7)               ;Width can't be 0, neg, or null
            (setq w (getdist pt1 "\nWidth: ")))
         (t (initget 7 "Cube")        ;Width can't be 0, neg, or null
            (setq w (getdist pt1 "\nCube/<Width>: "))
            (if (= w "Cube") 
               (setq w l h1 l h2 l)
            ))
   )
   (setq pt2 (list (car pt1) (+ (cadr pt1) w) (caddr pt1)))
   (setq pt4 (list (car pt3) (+ (cadr pt3) w) (caddr pt3)))
   (grdraw pt3 pt4 2)
   (grdraw pt4 pt2 2)
   (grdraw pt2 pt1 2)
   (setvar "ORTHOMODE" 0)
   (cond ((= typ "wedge")
             (initget 7)              ;Height can't be 0, neg, or null
             (setq h1 (getdist pt1 "\nHeight: "))
             (setq h2 0.0))
         (t  (if (/= h1 l) 
                (progn
                   (initget 7)        ;Height can't be 0, neg, or null
                   (setq h1 (getdist pt1 "\nHeight: "))
                   (setq h2 h1))))
   )

   (setq pt5 (list (car pt3) (cadr pt3) (+ (caddr pt3) h2)))
   (setq pt6 (list (car pt4) (cadr pt4) (+ (caddr pt4) h2)))
   (setq pt7 (list (car pt1) (cadr pt1) (+ (caddr pt1) h1)))
   (setq pt8 (list (car pt2) (cadr pt2) (+ (caddr pt2) h1)))
   (command "3DMESH" "6" "3" pt5 pt3 pt3 pt7 pt1 pt1 pt8 pt2
    pt1 pt6 pt4 pt3 pt6 pt6 pt5 pt8 pt8 pt7)            

(setq undoit T)
(prompt "\nRotation angle about Z axis: ")
(command "rotate" "l" "" pt1 pause)
)

;--------------------------------------------------------------------------
;Draw a pyramid

(defun pyramid (/ pt1 pt2 pt3 pt4 pt5 tp1 tp2 tp3 tp4)
   (initget 17)                       ;3D point can't be null
   (setq pt1 (getpoint "\nFirst base point: "))
   (initget 17)
   (setq pt2 (getpoint pt1 "\nSecond base point: "))
   (grdraw pt1 pt2 2)
   (initget 17)
   (setq pt3 (getpoint pt2 "\nThird base point: ")) 
   (grdraw pt2 pt3 2)
   (initget 17 "Tetrahedron")         ;Choose 3 or 4 point base
   (setq pt4 (getpoint pt3 "\nTetrahedron/<Fourth base point>: ")) 
   (if (= pt4 "Tetrahedron")
      (grdraw pt3 pt1 2)
      (progn
         (grdraw pt3 pt4 2)
         (grdraw pt4 pt1 2)
      )
   )
   (cond ((= pt4 "Tetrahedron")       ;3 point may have top or apex
            (initget 17 "Top")
            (setq pt5 (getpoint "\nTop/<Apex point>: ")))
         (t                           ;4 point may have ridge, top, or apex
            (initget 17 "Top Ridge") 
            (setq pt5 (getpoint "\nRidge/Top/<Apex point>: ")))
   )
   (cond ((= pt5 "Top")               ;Prompt for top points
            (initget 17)
            (setq tp1 (getpoint pt1 "\nFirst top point: "))
            (grdraw pt1 tp1 2)
            (initget 17)
            (setq tp2 (getpoint pt2 "\nSecond top point: "))
            (grdraw tp1 tp2 2)
            (grdraw pt2 tp2 2)
            (initget 17)
            (setq tp3 (getpoint pt3 "\nThird top point: "))
            (grdraw tp2 tp3 2)
            (grdraw pt3 tp3 2)
            (if (/= pt4 "Tetrahedron")
               (progn
                  (initget 17)
                  (setq tp4 (getpoint pt4 "\nFourth top point: "))
                  (grdraw tp3 tp4 2)
                  (grdraw pt4 tp4 2))))
         ((= pt5 "Ridge")             ;Prompt for ridge points
            (grdraw pt4 pt1 2 -1)
            (initget 17)                
            (setq tp1 (getpoint "\nFirst ridge point: "))
            (grdraw pt4 pt1 2)
            (grdraw pt1 tp1 2)
            (grdraw pt4 tp1 2)
            (grdraw pt3 pt2 2 -1)
            (initget 17)                
            (setq tp2 (getpoint tp1 "\nSecond ridge point: "))
            (grdraw pt2 tp2 2)
            (grdraw pt3 tp2 2))
         (t (setq tp1 pt5)            ;Must be apex
            (setq tp2 tp1))
   )

   (cond ((and (/= pt4 "Tetrahedron")(/= pt5 "Top"))
            (command "3DMESH" "4" "4" tp1 tp1 tp2 tp2 tp1 pt4 pt3 tp2 
             tp1 pt1 pt2 tp2 tp1 tp1 tp2 tp2))
         ((and (/= pt4 "Tetrahedron")(= pt5 "Top"))
            (command "3DMESH" "5" "4" tp1 tp1 tp2 tp2 tp4 tp4 tp3 tp3
             tp4 pt4 pt3 tp3 tp1 pt1 pt2 tp2 tp1 tp1 tp2 tp2))
         ((and (= pt4 "Tetrahedron")(/= pt5 "Top"))
            (command "3DMESH" "5" "2" tp1 pt2 pt3 pt2 pt3 pt1 tp1 pt1 
             tp1 pt2))
         (t (command "3DMESH" "4" "4" pt3 pt1 tp1 tp3 pt2 pt2 tp2 tp2
             pt3 pt3 tp3 tp3 pt3 pt1 tp1 tp3))
   )     
)

;--------------------------------------------------------------------------
; Draw a mesh

; Given a starting and an ending point, this function finds the next
; set of points in the N direction.

(defun next-n (pt1 pt2 / xinc yinc zinc loop pt)
   (setq xinc (/ (- (car pt2) (car pt1)) (1- n)))
   (setq yinc (/ (- (cadr pt2) (cadr pt1)) (1- n)))
   (setq zinc (/ (- (caddr pt2) (caddr pt1)) (1- n)))
   (setq loop (1- n))
   (setq pt pt1)
   (while (> loop 0)
      (setq pt (list (+ (car pt) xinc) (+ (cadr pt) yinc) (+ (caddr pt) zinc)))
      (setq l (cons pt l))
      (setq loop (1- loop))
   )
)

; This function finds the next point in the M direction.

(defun next-m (pt1 pt2 loop / xinc yinc zinc)
   (if (/= m loop)
      (progn
         (setq xinc (/ (- (car pt2) (car pt1)) (- m loop)))
         (setq yinc (/ (- (cadr pt2) (cadr pt1)) (- m loop)))
         (setq zinc (/ (- (caddr pt2) (caddr pt1)) (- m loop)))
      )
      (progn
         (setq xinc 0)
         (setq yinc 0)
         (setq zinc 0)
      )
   )
   (setq pt1 (list (+ (car pt1) xinc) (+ (cadr pt1) yinc) (+ (caddr pt1) zinc)))
)

(defun mesh (/ c1 c2 c3 c4 m n l loop i)
   (setq m 0 n 0)                     ;Initialize variables
   (initget 17)                     
   (setq c1 (getpoint "\nFirst corner: "))
   (initget 17)                     
   (setq c2 (getpoint c1 "\nSecond corner: "))
   (grdraw c1 c2 2)
   (initget 17)                     
   (setq c3 (getpoint c2 "\nThird corner: "))
   (grdraw c2 c3 2)
   (initget 17)                     
   (setq c4 (getpoint c3 "\nFourth corner: "))
   (grdraw c3 c4 2)
   (grdraw c4 c1 2 1)
   (while (or (< m 2) (> m 256))
      (initget 7)                     
      (setq m (getint "\nMesh M size: "))
      (if (or (< m 2) (> m 256)) 
         (princ "\nValue must be between 2 and 256.")
      )
   )
   (grdraw c4 c1 2)
   (grdraw c1 c2 2 1)
   (while (or (< n 2) (> n 256))
      (initget 7)                     
      (setq n (getint "\nMesh N size: "))
      (if (or (< n 2) (> n 256)) 
         (princ "\nValue must be between 2 and 256.")
      )
   )
 
   (setq l (list c1))
   (setq loop 1)
   (next-n c1 c2)
   (while (< loop m)
      (setq c1 (next-m c1 c4 loop)) 
      (setq c2 (next-m c2 c3 loop))
      (setq l (cons c1 l))
      (next-n c1 c2)
      (setq loop (1+ loop))
   )
   (setvar "osmode" 0)                ;Turn OSMODE off
   (setvar "blipmode" 0)              ;Turn BLIPMODE off
   (setq i 0)
   (command "3dmesh" m n)
   (while (<= i (* m n)) (command (nth i l)) (setq i (1+ i)))
)

;--------------------------------------------------------------------------
;Internal error handler

(defun 3derr (s)                      ;If an error (such as CTRL-C) occurs
                                      ;while this command is active...
   (if (/= s "Function cancelled")
       (princ (strcat "\nError: " s))
   )
   (if undoit
      (progn
         (command)
         (command "UNDO" "e")         ;Terminate undo group
         (princ "\nundoing...") 
         (command "U")                ;Erase partially drawn shape
      )
      (command "UNDO" "e")               
   )
   (moder)                            ;Restore saved modes
   (if ofl
       (setvar "FLATLAND" ofl)
   )
   (command "REDRAWALL")
   (setvar "CMDECHO" oce)             ;Restore saved cmdecho value
   (setq *error* olderr)              ;Restore old *error* handler
   (princ)

)

;--------------------------------------------------------------------------

; Main program.  Draws 3D object specified by "key" argument.
; If "key" is nil, asks which object is desired.

(defun 3d (key / olderr)
   (if m:err                            ;If called from the menu
      (setq olderr m:err *error* 3derr) ;save the menus trapped *error*
      (setq olderr *error* *error* 3derr)
   )
   (setq undoit nil ofl nil)
   (setq oce (getvar "cmdecho"))
   (setvar "CMDECHO" 0)
   (modes '("BLIPMODE" "GRIDMODE" "ORTHOMODE" "OSMODE"
            "SURFTAB1" "SURFTAB2" "UCSFOLLOW"))
   (if (and (setq ofl (getvar "FLATLAND")) ;Test for FLATLAND
            (/= ofl 0))                    ;and FLATLAND's value.
       (setvar "FLATLAND" 0)               ;Set FLATLAND for duration
   )                                       ;of the function.
   (command "UNDO" "group")
   (setvar "UCSFOLLOW" 0)
   (setvar "GRIDMODE" 0)
   (setvar "OSMODE" 0)
   (if (null key)
       (progn
           (initget "Box Cone DIsh DOme Mesh Pyramid Sphere Torus Wedge")
           (setq key (getkword "\nBox/Cone/DIsh/DOme/Mesh/Pyramid/Sphere/Torus/Wedge: "))
       )
   )
   (cond ((= key "Box")     (boxwed "box")) 
         ((= key "Cone")    (cone))
         ((= key "DIsh")    (spheres "dish"))
         ((= key "DOme")    (spheres "dome"))
         ((= key "Mesh")    (mesh))
         ((= key "Pyramid") (pyramid))
         ((= key "Sphere")  (spheres "sphere"))
         ((= key "Torus")   (torus))
         ((= key "Wedge")   (boxwed "wedge"))
         (T nil)                      ;Null reply?  Just exit
   )
   (moder)                            ;Restore saved modes
   (if ofl
       (setvar "FLATLAND" ofl)
   )
   (command "REDRAWALL")
   (command "UNDO" "e")               ;Terminate undo group
   (setvar "CMDECHO" oce)             ;Restore saved cmdecho value
   (setq *error* olderr)              ;Restore old *error* handler
   (princ)
)

;--------------------------------------------------------------------------

(defun C:BOX ()     (3d "Box"))
(defun C:CONE ()    (3d "Cone"))
(defun C:DISH ()    (3d "DIsh"))
(defun C:DOME ()    (3d "DOme"))
(defun C:MESH ()    (3d "Mesh"))
(defun C:PYRAMID () (3d "Pyramid"))
(defun C:SPHERE ()  (3d "Sphere"))
(defun C:TORUS ()   (3d "Torus"))
(defun C:WEDGE ()   (3d "Wedge"))
(defun C:3D ()      (3d nil))
