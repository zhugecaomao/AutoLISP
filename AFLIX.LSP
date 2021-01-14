;
;       Generate cameras and scenes to walk through drawing
;       or perform kinetic animation.
;
;       Last updated in release 1.0a
;
;       Designed and implemented by Kelvin R. Throop in May of 1987.
;
;       8/88  TLD/KWL -- Modified for Release 10.
;
;       This command takes a polyline, specifying the path and eye
;       height (from the polyline's elevation), and generates cameras
;       and scenes to walk through the model along the polyline.  It
;       simultaneously writes an AutoShade script file to generate
;       the images for each frame, and an AutoFlix command file
;       to create a movie from the frame images.  The camera's look-at
;       point can either be fixed or can be specified by a second
;       polyline, allowing either examination of a fixed point
;       from different viewpoints or a true Steadicam-type walkthrough.
;       In addition, the camera may be smoothly twisted throughout
;       the walkthrough, permitting inspection from various angles.
;
;       The generated script normally uses full shading to make the
;       images.  To change this to fast shading, or to subsequently
;       change back to full shade, use the command SHADETYPE.
;

(vmon)
(setq shadecmd "fullshade")
(setq flixver "1.0b")

;       SHADETYPE command.  Permits user to select fast or full shaded
;                           renderings for animation frames.

(defun C:shadetype ()
        (setq prcd T)
        (while prcd
           (setq s (strcase (substr (getstring (strcat "\nFast shading for images? <"
              (if (= shadecmd "fastshade") "Y" "N")
              ">: ")) 1 1)))
           (cond
              ((= (strlen s) 0) (setq prcd nil))
              ((= s "Y") (setq prcd nil shadecmd "fastshade"))
              ((= s "N") (setq prcd nil shadecmd "fullshade"))
           )
        )
        (princ)
)

;       Construct item name from type code B, base name, and index N

(defun cname (b n)
        (strcat b bname (itoa n))
)

;       ICL  -- Insert camera or light.  Presently used only for cameras

(defun icl (blkn lfxy laxy sname / scale slayer rot)
        (setq scale (/ (getvar "VIEWSIZE") 9.52381))
        (setq rot (* (/ 180 pi) (- (angle lfxy laxy) 1.570796)))
        (setq laxy (trans laxy 1 0))
        (command
           "insert"
              blkn
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
)

;       ISH  -- Insert scene/set/shot/whatever the heck we're calling it today

(defun ish (sname otype oname / omode slayer)
        (command
           "insert"
              "shot"
              (list '2 '2)
              1                               ; No x scaling
              1                               ; No y scaling
              "<<0"                           ; No rotation
              otype                           ; Object type
              oname                           ; Object name
              sname                           ; Scene name
        )
)

; SLOB   Select Object

; Selects one of the active object types.
; Won't take NULL for an answer.

; Input:  prefix prompt
;         postfix prompt
;         Null pick ok flag

;         Uses global objct

; Return: entity

(defun slob (pre post nulok / prcd)

  (setq prcd 1)

;   Select the object to update.

  (while (= 1 prcd)
     (setq ename (car (entsel (strcat pre (strcase objct t) post))))
     (if ename
        (if (= (cdr (assoc '0 (setq elist (entget ename)))) "INSERT")
           (progn
              (setq bnam (cdr (assoc '2 elist)))
              (cond
                 ; Inserted block must have the desired object name.
                 ((or
                    (= objct bnam)
                    (and (= bnam "DIRECT") (= objct "LIGHT"))
                    (and (= bnam "OVERHEAD") (= objct "LIGHT"))
                    (and (= bnam "SHOT") (= objct "SCENE")))
                    (setq prcd nil)
                 )
                 (T
                    (prompt (strcat "\nSelected object is not a "
                       (strcase objct t) " \n")))
              )
           )
        )
        (if nulok
           (setq prcd nil))
     )
  )
  ename
)

; bget (ename)

; Starting at ENAME entity name it searches the database for an SEQEND
; entity . The following list is returned:

;   (elist0   elist1   elist2   ...   elistN), where

;      elist0    Is the block's entity list

;      elist<i>, i=1,N are the entities lists of the block's attributes

; If the desired INSERT entity is not found nil is returned

; Input:  ename     - Where to start the search.

; Return: blist     - A global value

(defun bget ( ename / prcd elist)

  (setq prcd 1)

; Before starting, see if the current blist contains
; the desired entity.

  (cond
     ((and (listp 'blist) (= ename (cdr (assoc '-1 (car blist)))))
        (ename))

     (T
        (setq blist (list (entget ename)))
        (while prcd
           (setq elist (entget (setq ename (entnext ename))))
           (if (= (cdr (assoc '0 elist)) "SEQEND")
             (setq prcd nil)
             (setq blist (append blist (list elist)))
           )
        )
        (cdr (assoc '-1 (car blist)))
     )
  )
)

; eget ( tagn )

; Searches the current blist for an ATTRIB elist with an attribute
; tag equal to the argument's tag name. It returns either the
; attribute's elist or nil.

; Input:  tagn      - The attribute tag name
;         blist     - A global list containing the elists to be
;                     searched.
;
; Return: elist     - The desired entity list or nil

(defun eget ( tagn / elist wlist)

  (setq elist nil)
  (foreach wlist blist
     (if (and (= (cdr (assoc '0 wlist)) "ATTRIB")
              (= (cdr (assoc '2 wlist)) tagn)
         )
        (setq elist wlist)
     )
  )
  elist
)

;       GETZ  --  Obtain elevation defaulting to current elevation

(defun getz (s / z)
        (setq z (getreal (strcat s " elevation <"
           (rtos (getvar "elevation")) ">: ")))
        (if (null z)
           (setq z (getvar "elevation"))
        )
        z
)

;       DIVPL  --  Divide polyline into n animation steps.  One
;                  step is placed at the start and one at the
;                  end of the polyline, and n - 2 in the middle.
;                  For historical reasons, DIVPL is called with
;                  1 one greater than the number of points desired.

      (defun divpl (p n / e op tda tdb)
        (if (setq op (= 0 (logand 1 (cdr (assoc 70 (entget (car p)))))))
           (progn
              (setq tda
                 (trans (cdr (assoc 10 (entget (entnext (car p))))) (car p) 1)
              )
              (command "point" (list (car tda) (cadr tda)))
           )
        )
        (command "divide" p (- n (if op 2 1)))
        (if op (progn
           (setq e (car p))
           (while (/= "SEQEND" (cdr (assoc 0 (entget (entnext e)))))
              (setq e (entnext e))
           )
           (setq tdb (trans (cdr (assoc 10 (entget e))) e 1))
           (command "point" (list (car tdb) (cadr tdb)))
        ))
)

;       UCSP -- Check for UCS-parallel entities
;
;               Input is extrusion vector.
;               Returns T if UCS-parallel, nil if not.

(defun ucsp (edir / udir arbval dx dy dz)
   (setq udir   (trans '(0 0 1) 1 0 t)
         dx     (- (car edir) (car udir))
         dy     (- (cadr edir) (cadr udir))
         dz     (- (caddr edir) (caddr udir))
         arbval (/ 1.0 64.0)
   )
   (if (< (+ (* dx dx) (* dy dy) (* dz dz)) 1E-20)
      (equal (and (< (abs (car edir)) arbval) (< (abs (cadr edir))))
             (and (< (abs (car udir)) arbval) (< (abs (cadr udir))))
      )
      nil
   )
)

;       WALKTHROUGH  --   Main walk-through generation command

(defun C:walkthrough ( / ss ssep tdc tdd tde)
        (setq prcd t)
        (while prcd
           (setq e (entsel "\nChoose walk-through polyline: "))
           (if (and e
                    (= (cdr (assoc 0 (entget (car e)))) "POLYLINE")
                    (< (cdr (assoc 70 (entget (car e)))) 8)
               )
               (if (null (assoc 210 (entget (car e))))
                   (if (ucsp (trans '(0 0 1) (car e) 0 T))
                      (setq prcd nil)
                      (princ "\n2D polyline must be UCS-parallel!\n")
                   )
                   (if (ucsp (cdr (assoc 210 (entget (car e)))))
                       (setq prcd nil)
                       (princ "\n2D polyline must be UCS-parallel!\n")
                   )
               )
               (princ "\nMust be a 2D polyline!\n")
           )
        )
        (setq ep nil)
        (initget (+ 1 8 16) "Path Same")
        (setq samef nil)
        (setq laxy (getpoint "\nChoose look-at point (or Path or Same): "))
        (if (= laxy "Path")
           (progn
              (setq prcd t)
              (while prcd
                 (setq ep (entsel "\nChoose look-at path polyline: "))
                 (if (and ep
                        (= (cdr (assoc 0 (entget (car ep)))) "POLYLINE")
                        (< (cdr (assoc 70 (entget (car ep)))) 8)
                     )
                     (if (null (assoc 210 (entget (car ep))))
                         (if (ucsp (trans '(0 0 1) (car ep) 0 T))
                            (setq prcd nil)
                            (princ "\n2D polyline must be UCS-parallel!\n")
                         )
                         (if (ucsp (cdr (assoc 210 (entget (car ep)))))
                            (setq prcd nil)
                            (princ "\n2D polyline must be UCS-parallel!\n")
                         )
                     )
                     (princ "\nMust be a 2D polyline!\n")
                 )
              )
              (setq piz (getz "\nInitial path"))
              (setq pfz (getz "\nFinal path"))
           )
           (if (= laxy "Same")
              (setq samef t)
           )
        )
        (setq llist nil bname nil)
        (while (null bname)
           (setq bname (getstring "\nBase name for path (1-3 characters): "))
           (if (or (< (strlen bname) 1) (> (strlen bname) 3))
              (progn
                 (princ
                  "Base name null or too long.  Must be 1 to 3 characters.\n")
                 (setq bname nil)
              )
           )
        )
        (initget (+ 1 2 4))
        (setq np (getint "\nNumber of frames: "))
        (if (< np 3)
           (progn
              (setq np 3)
              (princ "Frames set to minimum: 3\n")
           )
        )
        (setq iz (getz "\nInitial camera"))
        (setq fz (getz "\nFinal camera"))
        (setq twist (getreal "\nTwist revolutions <0>: "))

;       Acquire the names of the lights to be used in this picture
;       by letting the user select them.

        (setq objct "LIGHT")
        (while (or (null llist) lname)
           (setq lname (slob "\nSelect a " ": " T))

;          Include the light name in the list of
;          objects which belong to the scene. Don't
;          do it if the light is already part of the
;          scene.

           (if lname
              (progn
                 (bget lname)
                 (setq lname (cdr (assoc '1 (eget "SNAME"))))
                 (prompt (strcat " " lname "\n"))
                 (if (not (member lname llist))
                    (setq
                       llist (cons lname llist)
                    )
                    (prompt (strcat "\nLight " lname " already selected.\n"))
                 )
              )
           )
        )

;       All user input acquired.  Now go generate the cameras and scenes.

        (setq cmdo (getvar "CMDECHO"))
        (setvar "CMDECHO" 0)
        (setq blippo (getvar "BLIPMODE"))
        (setvar "BLIPMODE" 0)

;       Place the temporary divide information on layer "$$DOTS"

        (setq slayer (getvar "CLAYER"))
        (command "LAYER" "MAKE" "$$DOTS" "")
        (command "point" '(0 0))
        (setq np (1+ np))
        (setq ss (entlast))
;       (command "divide" e np)
        (divpl e np)
        (if ep
           (progn
              (setq ssep (entlast))
;             (command "divide" ep np)
              (divpl ep np)
           )
        )
        (command "LAYER" "MAKE" "ASHADE" "")

;       Now walk through the polyline and generate a camera and
;       a set containing it and every light named, all pointing to
;       the desired look-at point.

        (setq asf (open (strcat bname ".scr") "w"))
        (setq mvf (open (strcat bname ".mvi") "w"))
        (write-line "spercent -1" asf)
        (write-line "record on" asf)

        (setq pernt 1)
        (setq e el)
        (setq tangle 0.0)
        (while (< pernt np)
           (setq en (setq ss (entnext ss)))
           (setq pelev (+ iz (* (- fz iz)
              (/ (- pernt 1.0) (- np 2.0)))))
; (princ "Point ") (princ pernt) (princ " elevation ") (princ pelev) (terpri)
           (if ep
              (progn
                 (setq tdc (cdr (assoc 10 (entget (setq ssep (entnext ssep)))))
                       laxy (list
                               (car tdc)
                               (cadr tdc)
                               (+ piz (* (- pfz piz) (/ (- pernt 1.0) (- np 2.0))))
                            )
                 )
              )
           )

;          If look at path is same as camera path, constantly look at
;          next point (and at end, look from next to last to last
;          direction from the last point).

           (if samef
              (progn
                 (if (< pernt (1- np))
                    (setq
                       plaxy laxy
                       tdd (cdr (assoc 10 (entget (entnext en))))
                       laxy (list (car tdd)
                                  (cadr tdd)
                                  (+ iz (* (- fz iz) (/ pernt (- np 2.0))))
                            )
                    )
                    (progn
                       (setq
                          tdd (cdr (assoc 10 (entget (entnext en))))
                          cpxy (list (car tdd) (cadr tdd) pelev)
                       )
                       (setq laxy (mapcar '+ cpxy
                          (mapcar '- cpxy plaxy))
                       )
                    )
                 )
              )
           )
           (if (= 0 (getvar "WORLDUCS"))
              (setq tde (trans (cdr (assoc 10 (entget en))) 0 1))
              (setq tde (cdr (assoc 10 (entget en))))
           )
           (icl "camera"
                (list (car tde) (cadr tde) pelev)
                laxy
                (setq tcn (cname "C" pernt))
           )
           (ish (setq tsn (cname "S" pernt)) "CAMERA" tcn)
           (setq ll llist)
           (while ll
              (ish tsn "LIGHT" (car ll))
              (setq ll (cdr ll))
           )
           (setq usn (cname "s" pernt))
           (write-line (strcat "scene " usn) asf)
           (if twist
              (progn
                 (write-line (strcat "twist " (rtos tangle 2 6)) asf)
                 (setq tangle (rem (+ tangle (/ (* 360.0 twist) (- np 2.0)))
                    360.0))
              )
           )
           (write-line (strcat shadecmd " " usn) asf)
           (write-line usn mvf)
           (setq pernt (1+ pernt))
        )
        (close asf)
        (close mvf)
        (command "erase" (ssget "X" '((8 . "$$DOTS"))) "")
        (command "LAYER" "SET" slayer "")
        (setvar "CMDECHO" cmdo)
        (setvar "BLIPMODE" blippo)
        (princ)
)

;       ANIMLENS  --  Specify nonstandard lens focal length for kinetic
;                     animation.  Causes ANIMATE to generate a "lens"
;                     script command for every frame.

(setq animlens nil)
(defun C:animlens ()
        (setq animlens nil)
        (initget (+ 2 4))
        (setq animlens
           (getreal "\nAnimation lens focal length in mm <50>: "))
        (princ)
)

;       ANIMATE  --  Kinetic animation command.  Writes one filmroll
;                    per frame.

(defun C:animate ( / tdc tdd tde tdf)
        (setq prcd t)
        (while prcd
           (setq e (entsel "\nChoose camera path polyline: "))
           (if (and e
                    (= (cdr (assoc 0 (entget (car e)))) "POLYLINE")
                    (< (cdr (assoc 70 (entget (car e)))) 8)
               )
               (if (null (assoc 210 (entget (car e))))
                   (if (ucsp (trans '(0 0 1) (car e) 0 T))
                      (setq prcd nil)
                      (princ "\n2D polyline must be UCS-parallel!\n")
                   )
                   (if (ucsp (cdr (assoc 210 (entget (car e)))))
                       (setq prcd nil)
                       (princ "\n2D polyline must be UCS-parallel!\n")
                   )
               )
               (princ "\nMust be a 2D polyline!\n")
           )
        )
        (setq ep nil)
        (initget (+ 1 8 16) "Path Same")
        (setq samef nil)
        (setq laxy (getpoint "\nChoose look-at point (or Path or Same): "))
        (if (= laxy "Path")
           (progn
              (setq prcd t)
              (while prcd
                 (setq ep (entsel "\nChoose look-at path polyline: "))
                 (if (and ep
                          (= (cdr (assoc 0 (entget (car ep)))) "POLYLINE")
                          (< (cdr (assoc 70 (entget (car ep)))) 8)
                     )
                     (if (null (assoc 210 (entget (car ep))))
                         (if (ucsp (trans '(0 0 1) (car ep) 0 T))
                            (setq prcd nil)
                            (princ "\n2D polyline must be UCS-parallel!\n")
                         )
                         (if (ucsp (cdr (assoc 210 (entget (car ep)))))
                             (setq prcd nil)
                             (princ "\n2D polyline must be UCS-parallel!\n")
                         )
                     )
                     (princ "\nMust be a 2D polyline!\n")
                 )
              )
              (setq piz (getz "\nInitial path"))
              (setq pfz (getz "\nFinal path"))
           )
           (if (= laxy "Same")
              (setq samef t)
           )
        )

        (setq llist nil bname nil)
        (while (null bname)
           (setq bname (getstring "\nBase name for path (1-3 characters): "))
           (if (or (< (strlen bname) 1) (> (strlen bname) 3))
              (progn
                 (princ
                  "Base name null or too long.  Must be 1 to 3 characters.\n")
                 (setq bname nil)
              )
           )
        )
        (initget (+ 1 2 4))
        (setq np (getint "\nNumber of frames: "))
        (if (< np 3)
           (progn
              (setq np 3)
              (princ "Frames set to minimum: 3\n")
           )
        )
        (setq iz (getz "\nInitial camera"))
        (setq fz (getz "\nFinal camera"))
        (setq twist (getreal "\nTwist revolutions <0>: "))
        (setq motl nil motrot nil motzt nil prcd t)
        (while prcd
           (if (> (strlen (setq ml (getstring "\nLayer to move: "))) 0)
              (progn
                 (if (and (tblsearch "layer" ml) (ssget "X"
                            (list (cons 8 ml))))
                    (progn
                       (setq prcd1 t)
                       (while prcd1
                          (setq mlp (entsel (strcat
                             "\nChoose motion path polyline for " ml ": ")))
                          (if (and mlp
                                   (= (cdr (assoc 0 (entget
                                       (car mlp)))) "POLYLINE")
                                   (< (cdr (assoc 70 (entget (car mlp)))) 8)
                              )
                              (if (null (assoc 210 (entget (car mlp))))
                                  (if (ucsp (trans '(0 0 1) (car mlp) 0 T))
                                     (setq prcd1 nil)
                                     (princ "\n2D polyline must be UCS-parallel!\n")
                                  )
                                  (if (ucsp (cdr (assoc 210 (entget (car mlp)))))
                                      (setq prcd1 nil)
                                      (princ "\n2D polyline must be UCS-parallel!\n")
                                  )
                              )
                              (princ "\nMust be a 2D polyline!\n")
                          )
                       )
                       (setq motl (append motl (list (list ml mlp))))
                       (if (setq mrz (getreal "\nRotations <0>: "))
                          (setq motrot (append motrot (list
                             (/ (* 360.0 mrz) np))))
                          (setq motrot (append motrot '(0)))
                       )
                       (if (setq mrz (getreal "\nZ translation <0>: "))
                          (setq motzt (append motzt (list
                             (/ mrz np))))
                          (setq motzt (append motzt '(0)))
                       )
                    )
                    (prompt "No such layer in drawing or layer empty.\n")
                 )
              )
              (setq prcd nil)
           )
        )

;       Acquire the names of the lights to be used in this picture
;       by letting the user select them.

        (setq objct "LIGHT")
        (while (or (null llist) lname)
           (setq lname (slob "\nSelect a " ": " T))

;          Include the light name in the list of
;          objects which belong to the scene. Don't
;          do it if the light is already part of the
;          scene.

           (if lname
              (progn
                 (bget lname)
                 (setq lname (cdr (assoc '1 (eget "SNAME"))))
                 (prompt (strcat " " lname "\n"))
                 (if (not (member lname llist))
                    (setq
                       llist (cons lname llist)
                    )
                    (prompt (strcat "\nLight " lname " already selected.\n"))
                 )
              )
           )
        )

        (setq cmdo (getvar "CMDECHO"))
        (setvar "CMDECHO" 0)
        (setq blippo (getvar "BLIPMODE"))
        (setvar "BLIPMODE" 0)

        (setq slayer (getvar "CLAYER"))
        (command "LAYER" "MAKE" "$$DOTS" "")
        (command "point" '(0 0))
        (setq np (1+ np))
        (setq ss (entlast))
        (divpl e np)
        (if ep
           (progn
              (setq ssep (entlast))
              (divpl ep np)
           )
        )

;       Now walk through the motion layer list and create division
;       points on the polylines that trace object motion.

        (setq pernt 0 motp nil)
        (while (< pernt (length motl))
           (setq motp (append motp (list (entlast))))
           (divpl (cadr (nth pernt motl)) np)
;          Sledgehammer to put all objects back at original position
;          at the end.  Admire, but don't emulate.
           (setq tdf (trans (cdr (assoc 10 (entget (entnext (nth pernt motp))))) 0 1))
           (command "point" (list (car tdf) (cadr tdf)))
           (setq pernt (1+ pernt))
        )

        (command "LAYER" "MAKE" "$$ANICAM" "")

;       Now walk through the polyline and generate a camera and
;       a set containing it and every light named, all pointing to
;       the desired look-at point.

        (setq asf (open (strcat bname ".scr") "w"))
        (setq mvf (open (strcat bname ".mvi") "w"))
        (write-line "record on" asf)

        (setq pernt 1)
        (setq e el)
        (setq tangle 0.0)
        (while (< pernt np)
           (setq en (setq ss (entnext ss)))
           (setq pelev (+ iz (* (- fz iz)
              (/ (- pernt 1.0) (- np 2.0)))))
           (if ep
              (progn
                 (setq tdc (cdr (assoc 10 (entget (setq ssep (entnext ssep)))))
                       laxy (list
                               (car tdc)
                               (cadr tdc)
                               (+ piz (* (- pfz piz) (/ (- pernt 1.0)(- np 2.0))))
                            )
                 )
              )
           )

;          If look at path is same as camera path, constantly look at
;          next point (and at end, look from next to last to last
;          direction from the last point).

           (if samef
              (progn
                 (if (< pernt (1- np))
                    (setq
                       plaxy laxy
                       tdd (cdr (assoc 10 (entget (entnext en))))
                       laxy (list (car tdd)
                                  (cadr tdd)
                                  (+ iz (* (- fz iz) (/ pernt (- np 2.0))))
                            )
                    )
                    (progn
                       (setq
                          tdd (cdr (assoc 10 (entget (entnext en))))
                          cpxy (list (car tdd) (cadr tdd) pelev)
                       )
                       (setq laxy (mapcar '+ cpxy
                          (mapcar '- cpxy plaxy))
                       )
                    )
                 )
              )
           )
           (if (= 0 (getvar "WORLDUCS"))
              (setq tde (trans (cdr (assoc 10 (entget en))) 0 1))
              (setq tde (cdr (assoc 10 (entget en))))
           )
           (icl "camera"
                (list (car tde) (cadr tde) pelev)
                laxy
                (setq tcn (cname "C" pernt))
           )
           (ish (setq tsn (cname "S" pernt)) "CAMERA" tcn)
           (setq ll llist)
           (while ll
              (ish tsn "LIGHT" (car ll))
              (setq ll (cdr ll))
           )
           (setq usn (cname "s" pernt))
           (write-line (strcat "open" " " usn) asf)
           (write-line (strcat "scene " usn) asf)
           (write-line "spercent -1" asf)
           (if animlens
              (write-line (strcat "lens " (rtos animlens 2 6)) asf)
           )
           (if twist
              (progn
                 (write-line (strcat "twist " (rtos tangle 2 6)) asf)
                 (setq tangle (rem (+ tangle (/ (* 360.0 twist) (- np 2.0)))
                    360.0))
              )
           )
           (command "filmroll" usn)
           ; Get rid of camera and scene
           (command "erase" (ssget "X" '((8 . "$$ANICAM"))) "")
           (write-line (strcat shadecmd " " usn) asf)
           (write-line usn mvf)

;          Move everything into position for the next frame

           (setq motn 0 motu nil)
           (while (< motn (length motl))
              (setq me (entnext (nth motn motp)))
              (command "move" (ssget "X" (list (cons 8
                 (car (nth motn motl))))) ""
                 (list (car (trans (cdr (assoc 10 (entget me))) 0 1))
                       (cadr (trans (cdr (assoc 10 (entget me))) 0 1))
                       0.0
                 )
                 (append
                    (setq motbp
                       (list (car (trans (cdr (assoc 10 (entget (entnext me)))) 0 1))
                             (cadr (trans (cdr (assoc 10 (entget (entnext me)))) 0 1))
                       )
                    )
                    (list (nth motn motzt))
                 )
              )
              (setq motu (append motu (list me)))
              (if (/= 0 (setq motor (nth motn motrot)))
                 (command "rotate" (ssget "X" (list (cons 8
                    (car (nth motn motl))))) ""
                    motbp
                    (strcat "<<" (rtos motor 2 6))
                 )
              )
              (setq motn (1+ motn))
           )
           (setq motp motu)

           (setq pernt (1+ pernt))
        )

        ; Reverse rotation and Z translation for moving objects

        (setq motn 0)
        (while (< motn (length motl))
           (setq me (entnext (nth motn motp)))
           (command "move" (ssget "X" (list (cons 8
              (car (nth motn motl))))) ""
                 (list (car (trans (cdr (assoc 10 (entget me))) 0 1))
                       (cadr (trans (cdr (assoc 10 (entget me))) 0 1))
                       0.0
                 )
                 (append
                    (setq motbp
                       (list (car (trans (cdr (assoc 10 (entget me))) 0 1))
                             (cadr (trans (cdr (assoc 10 (entget me))) 0 1))
                       )
                    )
                    (list (* -1 (- np 1) (nth motn motzt)))
                 )
           )
           (setq motu (append motu (list me)))
           (if (/= 0 (setq motor (nth motn motrot)))
              (command "rotate" (ssget "X" (list (cons 8
                 (car (nth motn motl))))) ""
                 motbp
                 (strcat "<<" (rtos (* -1 (- np 1) motor) 2 6))
              )
           )
           (setq motn (1+ motn))
        )

        (close asf)
        (close mvf)
        (command "erase" (ssget "X" '((8 . "$$DOTS"))) "")
        (command "LAYER" "SET" slayer "")
        (setvar "BLIPMODE" blippo)
        (setvar "CMDECHO" cmdo)
        (princ)
)

;       BUTTON  --  Add a button to the image

(defun C:button ()
        (initget 1)
        (setq p1 (getpoint "\nFirst corner of button: "))
        (initget 1)
        (setq p2 (getcorner p1 "\nSecond corner of button: "))
        (initget (+ 1 2 4))
        (setq bn (getint "\nButton number: "))

        (setq c1 (list (min (car p1) (car p2)) (min (cadr p1) (cadr p2))))
        (setq c2 (list (max (car p1) (car p2)) (max (cadr p1) (cadr p2))))

        (setq cmdo (getvar "CMDECHO"))
        (setvar "CMDECHO" 0)
        (setq blippo (getvar "BLIPMODE"))
        (setvar "BLIPMODE" 0)

        (setq slayer (getvar "CLAYER"))
        (command "LAYER" "MAKE" "$$BUTTONS" "")
        (setq scolour (getvar "CECOLOR"))
        (command "COLOUR" 100)
        ; Draw button outline polyline
        (command "PLINE" c1 (list (car c1) (cadr c2))
                         c2 (list (car c2) (cadr c1))
                         "c"
        )
        ; Label button number
        (command "TEXT" "MIDDLE" (list (/ (+ (car c1) (car c2)) 2.0)
           (/ (+ (cadr c1) (cadr c2)) 2.0))
           (* 0.9 (- (cadr c2) (cadr c1)))
           0
           (itoa bn)
        )
        ; Draw button definition line
        (command "COLOUR" (+ 100 bn))
        (command "LINE" c1 c2)
        (command)


        (command "LAYER" "SET" slayer "")
        (command "COLOUR" scolour)
        (setvar "BLIPMODE" blippo)
        (setvar "CMDECHO" cmdo)
        (princ)
)

