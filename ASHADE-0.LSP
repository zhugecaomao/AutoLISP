
;       AutoShade commands for AutoCAD

;       Designed and implemented by Kelvin R. Throop in May of 1987
;       6/28/88  CLH --  Modified for Release 10
;       7/27/88  JSY & KWL -- Added CAMVIEW 

;       CAMERA  --  Insert a camera

(defun C:CAMERA ( / olderr omode sname gname lfxy laxy oang
                    selev scale slayer ltyp orth rot)

        (setq olderr *error*
              *error* as-err)
        (setq omode (a:cmod))      ; Set common modes
        (graphscr)

        (setq sname (a:acqs "Enter camera name"  nil))

;       Get the camera's target. 

        (setq laxy (a:gp3d "Enter target point"))

;       Get the object's look from point
        
        (setq lfxy (a:gp3d "Enter camera location"))
        (setq rot (* (/ 180 pi) (- (angle lfxy laxy) 1.570796)))
        (setq scale (/ (getvar "VIEWSIZE") 9.52381))
        (if (null r9) (setq laxy (trans laxy 1 0)))
        (command
           "insert"
              "camera"
              lfxy
              scale
              scale
              (strcat "<<" (rtos rot 2 6))
              sname                     ; SNAME
              " "                       ; GNAME
              (rtos (car laxy) 2 6)     ; LAX
              (rtos (cadr laxy) 2 6)    ; LAY
              (rtos (caddr laxy) 2 6)   ; LAZ
        )

;       Restore the previous operating mode

        (a:smod omode)
        (setq *error* olderr)
        (princ)
)

;       LIGHT  --  Insert a light source

(defun C:LIGHT ( / olderr omode sname gname lfxy laxy oang
                    selev scale slayer blkn ltyp orth rot)

        (setq olderr *error*
              *error* as-err)
        (setq omode (a:cmod))      ; Set running modes
        (graphscr)

        (setq sname (a:acqs "Enter light name" nil))

;       See if the light is a point source or a parallel (directed) source.
;       If it's a directed source, get the direction of the beam.

        (setq selev T)
        (while selev
           (setq selev (strcase (substr
              (a:acqs "Point source or Directed" "P") 1 1)))
           (cond ((= selev "P")
                    (setq blkn "overhead")
                    (setq gname " ")
                    (setq laxy '(0 0 0))
                    (setq selev nil)
                 )
                 ((= selev "D")
                    (setq blkn "direct")
                    (setq gname "Parallel")
                    (setq laxy (a:gp3d "Enter light aim point"))
                    (setq selev nil)
                 )
           )
        )

;       Get the light's location
        
        (setq lfxy (a:gp3d "Enter light location"))
        (setq scale (/ (getvar "VIEWSIZE") 9.52381))
        (if (= blkn "overhead") 
           (setq rot 0)
           (setq rot (* (/ 180 pi) (- (angle lfxy laxy) 1.570796)))
        )
        (if (null r9) (setq laxy (trans laxy 1 0)))
        (command
           "insert"
              blkn
              lfxy
              scale
              scale
              (strcat "<<" (rtos rot 2 6))
              sname                     ; SNAME
              gname                     ; GNAME
              (rtos (car laxy) 2 6)     ; LAX
              (rtos (cadr laxy) 2 6)    ; LAY
              (rtos (caddr laxy) 2 6)   ; LAZ
        )

;       Restore the previous operating modes

        (a:smod omode)
        (setq *error* olderr)
        (princ)
)

;       SCENE  --  Define a scene

;       It prompts the user for a camera name and optional light sources
;       and insert a series of scene blocks, one for the camera and as many as
;       needed for the light sources.

(defun C:SCENE ( / olderr sname cname lname savss savobj wlist oname
                   ename lfxy scale lrefs)

        (setq olderr *error*
              *error* as-err)
        (setq sname "")            ; The set name
        (setq v:olst nil)          ; List of the scene's objects
        (graphscr)

;       Obtain scene name

        (setq sname (a:acqs "Enter scene name" nil))

;       Save the SCENE name

        (setq v:olst (list sname))

;       Get the camera's name.  Don't take null for an answer.

        (setq v:objc "CAMERA")

        (a:bget (a:slob "\nSelect the " ": " nil))
        (setq cname (cdr (assoc '1 (a:eget "SNAME"))))
        (prompt (strcat " " cname "\n"))

;       Include the camera name in the list of objects
;       which belong to the scene.
        
        (setq
           v:olst
             (append v:olst (list (list "CAMERA" cname)))
        )

;       Get the light sources' names. Here, a null
;       line is interpreted as an end of the list of light sources.

        (setq v:objc "LIGHT")
        (setq lrefs "Lights:")

        (setq lname 1)
        (while (and cname lname)
           (setq lname (a:slob "\nSelect a " ": " T))

;          Include the light name in the list of
;          objects which belong to the scene. Don't
;          do it if the light is already part of the
;          scene.

           (if lname
              (progn
                 (a:bget lname)
                 (setq lname (cdr (assoc '1 (a:eget "SNAME"))))
                 (prompt (strcat " " lname "\n"))
                 (if (a:ntin lname)
                    (setq v:olst 
                       (append v:olst
                          (list (list v:objc lname))
                       )
                       lrefs (strcat lrefs " " lname)
                    )
                    (prompt (strcat "\nLight " lname " already selected.\n"))
                 )
              )
           )
        )
        
        (if v:olst
           (progn

;             Create a list of all of the objects to be inserted

              (setq wlist (cdr v:olst))

;             Get the camera name

              (setq oname (cadr (assoc '"CAMERA" wlist)))

;             Obtain location to put scene reference block

              (setq lfxy (a:gp3d "Enter scene location"))
              (setq scale (/ (getvar "VIEWSIZE") 85.0))

;             Put the clapper in the drawing

              (a:clin sname lfxy scale (strcat "Camera: " oname) lrefs)

;             Insert the Scene's camera block and update its attributes

              (a:sins sname "CAMERA" oname lfxy scale)

;             Insert the Scene's light sources and update their attributes

              (foreach oname wlist
                 (if (eq (car oname) "LIGHT")
                    (progn
;                      Offset each SHOT block to form bars on the clapper
                       (setq lfxy (cons
                          (+ (car lfxy) (* 0.8 scale)) (cdr lfxy)))
                       (a:sins sname "LIGHT" (cadr oname) lfxy scale)
                    )
                 )
              )
              (prompt (strcat "\nScene " sname " included.\n"))
           )
           (prompt "\nNo scenes included.\n")
        )
        (setq v:olst nil)
        (setq *error* olderr)
        (princ)
)

; A:SINS - Scene insert update attributes

; It will insert a scene block and update its attributes accordingly.

; Input:  sname   The scene name
;         otype   The object' type
;         oname   The object's name

(defun a:sins (sname otype oname lfxy scale / omode slayer)

        (setq omode (a:cmod))      ; use common modes

        (command "insert"
              "shot"               ; Load up the number 4 buck, Billy Bob!
              lfxy                 ; Shot reference location
              scale                ; X scaling
              scale                ; Y scaling
              "<<0"                ; No rotation
              otype                ; Object type (e.g., light, camera)
              oname                ; Object name (its name)
              sname                ; Scene name
        )

;       Restore the previous operating modes

        (a:smod omode)
)

;       Insert clapper.  The whole purpose of the clapper is to carry the
;       extra attributes which cannot be added to the SHOT block.

(defun a:clin (sname lfxy scale cref lref / omode slayer)

        (setq omode (a:cmod))      ; use common modes

        (command "insert"
              "clapper"            ; No applause for morons
              lfxy                 ; Shot reference location
              scale                ; X scaling
              scale                ; Y scaling
              "<<0"                ; No rotation
              sname                ; Scene name
              cref                 ; Camera reference string
              lref                 ; Light reference string
        )

;       Restore the previous operating modes

        (a:smod omode)
)

;       A:SMOD  -  Save and set operating modes

; Saves the operating modes in MLIST and sets them to the values
; indicated. It returns a list with the current settings.

; Input:  mlist   - A list containing paired lists with operating names
;                   and the values which to set them. The format is as
;                   follows:

;                   ((STRING1 VALUE1) (STRING2 VALUE2) ... (STRINGN VALUEN))

; Return: clist   - A list with the same format as MLIST containning the
;                   current settings.

(defun a:smod (mlist / clist pair string oval)
        (setq clist nil)
        (foreach  pair mlist
           (setq string (car pair))
           (setq oval (getvar string))
           (setq clist (append clist (list (list string oval))))
           (setvar string (cadr pair))
        )
        clist
)

;       A:CMOD  --  Set operating modes used whilst accessing our blocks

(defun a:cmod()
               (a:smod '(("CMDECHO" 0)("LIMCHECK" 0)("EXPERT" 1)
                        ("ORTHOMODE" 0) ("ATTDIA" 0)))
)


;       A:ACQS  --  Acquire string.  Handles defaults and rejects null;
;                   input if there is no default.
;                   Since this is used only for object names, it limits
;                   the name length to 8 characters.

; Input:  a     - The prompt string
;         b     - The default string
;

(defun a:acqs ( a b / c d)

;       Initialise working environment

        (setq c nil d T)

;       Display default value, if necessary

        (cond
           ((null b)
              (setq a (strcat "\n" a ": ")))
           (T
              (setq a (strcat "\n" a " <" b ">: ")))
        )
        (while d
           (setq c (getstring a))
           (if (or (not (or (null c) (= c ""))) b)
              (setq d nil) 
           )
        )

;       A null answer causes default to be returned

        (substr (if (= c "") b c) 1 8)
)

; A:SLOB   Select Object

; Selects one of the active object types.
; Won't take NULL for an answer. 

; Input:  prefix prompt
;         postfix prompt
;         Null pick ok flag

;         Uses globals v:objc and v:objo

; Return: entity

(defun a:slob (pre post nulok / prcd)

  (setq prcd 1)

;   Select the object to update.

  (while (= 1 prcd)
     (setq ename (car (entsel (strcat pre (strcase v:objc t) post))))
     (if ename
        (if (= (cdr (assoc '0 (setq elist (entget ename)))) "INSERT")
           (progn
              (setq bnam (cdr (assoc '2 elist)))
              (cond
                 ; Inserted block must have the desired object name.
                 ((or
                    (= v:objc bnam)
                    (and (= bnam "DIRECT") (= v:objc "LIGHT"))
                    (and (= bnam "OVERHEAD") (= v:objc "LIGHT"))
                    (and (= bnam "SHOT") (= v:objc "SCENE")))
                    (setq prcd nil)
                 )
                 (T 
                    (prompt (strcat "\nSelected object is not a "
                       (strcase v:objc t) " \n")))
              )
           )
        )
        (if nulok
           (setq prcd nil))
     )
  )
  ename
)

; a:bget (ename)

; Starting at ENAME entity name it searches the database for an SEQEND
; entity . The following list is returned:

;   (elist0   elist1   elist2   ...   elistN), where

;      elist0    Is the block's entity list

;      elist<i>, i=1,N are the entities lists of the block's attributes

; If the desired INSERT entity is not found nil is returned

; Input:  ename     - Where to start the search.

; Return: v:blst     - A global value

(defun a:bget ( ename / prcd elist)

  (setq prcd 1)

; Before starting, see if the current v:blst contains
; the desired entity.

  (cond
     ((and (listp 'v:blst) (= ename (cdr (assoc '-1 (car v:blst)))))
        (ename))

     (T
        (setq v:blst (list (entget ename)))
        (while prcd
           (setq elist (entget (setq ename (entnext ename))))
           (if (= (cdr (assoc '0 elist)) "SEQEND")
             (setq prcd nil)
             (setq v:blst (append v:blst (list elist)))
           )
        )
        (cdr (assoc '-1 (car v:blst)))
     )
  )
)

; a:eget ( tagn )

; Searches the current v:blst for an ATTRIB elist whith an attribute
; tag equal to the argument's tag name. It returns either the
; attribute's elist or nil.

; Input:  tagn      - The attribute tag name
;         v:blst    - A global list containing the elists to be
;                     searched.
;
; Return: elist     - The desired entity list or nil

(defun a:eget ( tagn / elist wlist)

  (setq elist nil)
  (foreach wlist v:blst
     (if (and (= (cdr (assoc '0 wlist)) "ATTRIB")
              (= (cdr (assoc '2 wlist)) tagn)
         )
        (setq elist wlist)
     )
  )
  elist
)

; A:NTIN

; It searches the current v:olst looking for the named object. If
; the object is defined it returns T otherwise nil.

; Input:  oname  - The name of the object being searched.
;         v:olst - A global list containing the list of objects
;                  which belong to the current defined scene.

; Return: T      - if the object is already part of the scene.
;         nil    - otherwise

(defun a:ntin ( lname / opair odfnd)

  (setq odfnd nil)                 ; Say object not defined
  (foreach opair (cdr v:olst)
     (if (and (eq "LIGHT" (car opair)) (eq lname (cadr opair)))
        (setq odfnd 1)
     )
  )
  (null odfnd)
)

;       A:GP3D  --  Acquire 3D point

(defun a:gp3d (p) 
        (initget (+ 1 8 16))       ; no null, limcheck off, want 3D
        (setvar "lastpt3d" (getpoint (strcat "\n" p ": ")))
)

;       CAMVIEW  --  Display a camera's view

;    The routine drives DVIEW with a null selection set and the default 
;    distance from the target to the camera in order to set perspective  
;    on and then exits DVIEW.


(defun C:CAMVIEW ( / olderr ename cname)

        (if (= 1 (getvar "flatland")) ; exit if FLATLAND is on
          (prompt "This routine requires FLATLAND to be set to 0.")
          (progn
            (setq olderr *error*
                  *error* as-err)
            (setq omode (a:cmod))
             
;       Get the camera's name.  Don't take null for an answer.

            (setq v:objc "CAMERA")

            (setq ename (a:bget (a:slob "\nSelect the " ": " nil)))
            (setq cname (cdr (assoc '1 (a:eget "SNAME"))))
            (prompt (strcat " " cname "\n"))
            (act (entget ename)) 
            (a:smod omode)
            (setq *error* olderr)
          )
        )
        (princ)
)        

;       ACT  --  Get to the new camera position

; Input:  sset - A camera entity

(defun act (sset / nxt lax lay laz tar cam dis)

        (setq nxt (entget (entnext (cdr (assoc -1 sset)))))
        (while 
          (and (= (cdr(assoc 0 nxt)) "ATTRIB") (/= (cdr(assoc 0 nxt)) "SEQEND"))
            (cond
               ((= (cdr(assoc 2 nxt)) "LAX")
                   (setq lax (cdr(assoc 1 nxt)))
               )   
               ((= (cdr(assoc 2 nxt)) "LAY")
                   (setq lay (cdr(assoc 1 nxt)))
               )
               ((= (cdr(assoc 2 nxt)) "LAZ")
                   (setq laz (cdr(assoc 1 nxt)))
               )
               (T)                 ; no operation if true
            )
          (setq nxt (entget (entnext (cdr (assoc -1 nxt)))))
        )

        ; Translate target and camera points to world coordinates
      
        (setq tar (trans (list (atof lax) (atof lay) (atof laz)) 0 1))
        (setq cam (trans (list (cadr  (assoc 10 sset)) 
                               (caddr (assoc 10 sset))
                               (cadddr(assoc 10 sset)))
                         (cdr (assoc -1 sset)) 1))

        (setq dis (distance cam tar))
        (command "dview" "" "po" tar cam "d" dis "") ; use default dviewblock
)

;       AS-ERR -- AutoShade internal error handler

(defun as-err (s)                  ; If an error (such as CTRL-C) occurs
                                   ; while this command is active...
        (if (/= s "Function cancelled")
           (princ (strcat "\nError: " s))
        )
        (a:smod omode)
        (setq *error* olderr)      ; restore old *error* handler
        (princ)
)

(defun a:shade ()                  ; function for AEC
        (princ "\n \n \nAutoShade Commands Loaded, errors: ")
        (princ)
        (setq v:olst nil)
)
; Running under Release 10 or later?
(cond ((getvar "viewmode") (setq r9 nil)) 
      (T (setq r9 T c:camview nil act nil)))
(princ "\nAutoShade Commands Loaded, errors: ")
(setq v:olst nil)
