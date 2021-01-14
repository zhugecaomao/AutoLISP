;;;--------------------------------------------------------------------------;
;;; XPLODE.LSP                                  
;;;   Copyright (C) 1990 by Autodesk, Inc.
;;;  
;;;   Permission to use, copy, modify, and distribute this software and its
;;;   documentation for any purpose and without fee is hereby granted, provided
;;;   that the above copyright notice appear in all copies and that both that
;;;   copyright notice and this permission notice appear in supporting
;;;   documentation.  This software is provided "as is" without express or
;;;   implied warranty.
;;;
;;;   Jan S. Yoder & K.C. Jones   Version 1.0                            
;;;
;;; --------------------------------------------------------------------------;
;;; DESCRIPTION
;;;
;;;
;;;   This is a replacement for the EXPLODE command in AutoCAD.  It allows
;;;   you to control all of the attributes of the comonent entities of a
;;;   block or set of blocks while exploding them.  There are several major
;;;   differences between XPlode and the EXPLODE command in AutoCAD.
;;;   
;;;   First, you can select as many entities as you wish; all dimensions,
;;;   polyline and polymeshes, and block insertions will be extracted from
;;;   your selection set, and you will be asked to XPlode them either
;;;   globally or individually.  If you chose to explode them globally, you
;;;   will see the following prompt for all of the candidate entities:
;;;   
;;;     All/Color/LAyer/LType/Inherit from parent block/<Explode>: 
;;;   
;;;   If, on the other hand, you elect to operate on them individually, you
;;;   will need to make a selection from this prompt for each entity.
;;;   
;;;   Second, the EXPLODE command in AutoCAD does not allow you to specify
;;;   any of the attributes for the component entities when you explode a
;;;   block.  Nor does it allow you to let the component entities inherit
;;;   the attributes of the parent block.
;;;   
;;;   
;;;   ALL
;;;   
;;;   This option allows you to specify a color, linetype, and layer for the
;;;   new entities.
;;;   
;;;   COLOR
;;;   
;;;   This option prompts you for a new color for the component entities.
;;;   
;;;     New color for exploded entities.
;;;     Red/Yellow/Green/Cyan/Blue/Magenta/White/BYLayer/BYBlock/<cecolor>:
;;;   
;;;   You may enter any color number from 1 through 255, or one of the 
;;;   standard color names listed.  "Cecolor" is the current entity color
;;;   from the CECOLOR system variable.
;;;   
;;;   LAYER
;;;   
;;;   This option prompts you to enter the name of the layer on which you 
;;;   want the component entities to be placed.
;;;   
;;;     XPlode onto what layer?  <clayer>:
;;;   
;;;   The layer name entered is verified and if it does not exist you are
;;;   reprompted for a layer name.  Pressing RETURN causes the current 
;;;   layer to be used.
;;;   
;;;   LTYPE
;;;   
;;;   This option lists all of the loaded linetypes in the current drawing,
;;;   and prompts you to choose one of them.  You must type the entire 
;;;   linetype name (sorry), or you may press RETURN to use the current one.
;;;   
;;;     Choose from the following list of linetypes.
;;;     CONTinuous/...others.../<CONTINUOUS>:
;;;   
;;;   INHERIT
;;;   
;;;   Inherit from parent block means that the attributes of the block
;;;   being XPloded will be the attributes of component entities.  No other
;;;   choices are required.
;;;   
;;;   EXPLODE
;;;   
;;;   This option issues the current EXPLODE command for each of the entities
;;;   in the selection set.
;;;   
;;; --------------------------------------------------------------------------;

;;; ------------------------ INTERNAL ERROR HANDLER --------------------------;

(defun xp_err (s)                     ; If an error (such as CTRL-C) occurs
  ;; while this command is active...
  (if (/= s "Function cancelled") 
    (princ (strcat "\nError: " s))
  ) 
  (if xp_oce (setvar "cmdecho" xp_oce)) ; restore old cmdecho value
  (setq *error* olderr)               ; restore old *error* handler
  (princ)
) 

;;; ---------------------------- COMMON FUNCTION -----------------------------;

(defun xp_val (n e f) 
  (if f ; if f then e is an entity list.
    (cdr (assoc n e))
    (cdr (assoc n (entget e)))
  )
) 

;;; ------------------------- GET ENTITY TO EXPLODE --------------------------;
;;; ---------------------------- MAIN PROGRAM --------------------------------;

(defun explode ( / oce ohl e0 en e1 s0) 

  ;; Version number.  Reset this local if you make a change.
  (setq xp_ver "1.00")  
  
  (setq xp_oer *error* 
        *error* xp_err)
  (setq xp_oce (getvar "cmdecho"))    ; save value of cmdecho
  (setvar "cmdecho" 0)                ; turn cmdecho off

  (graphscr)
  (princ (strcat "\nXPlode, Version " xp_ver ", (c) 1990 by Autodesk, Inc. "))

  (princ "\nSelect entities to XPlode. ")
  (setq ss (ssget))

  (if ss
    (progn
      ;; Sort out any entities not explodeable...
      (setq ss (xp_sxe)) ; DLine_Sort_Xplodable_Entities
    
      ;; XPlode Individually or Globally?
    
      (if (> (sslength ss) 0)
        (progn
          (if (> (sslength ss) 1)
            (progn
              (initget "Individually Globally")
              (setq ans (getkword "\n\nXPlode Individually/<Globally>: "))
            )
            (setq ans "Globally")
          )
        
        
          (cond
            ((= ans "Individually")
              (setq sslen (sslength ss)
                    j    0
              )
              (while (< j sslen)
                (setq temp  (ssname ss j)
                      prmpt T
                )
        
                (redraw temp 3)
                (setq typ (xp_gxt))
                (xp_xpe temp typ)
                (redraw temp 4)
                (setq j (1+ j))
              )
            )
            (T
              (setq sslen (sslength ss)
                    j     0
                    ans   "Globally"
                    prmpt T
              )
              (setq typ (xp_gxt))
              (while (< j sslen)
                (setq temp (ssname ss j))
                (xp_xpe temp typ)
                (setq j (1+ j))
              )
            )
          )
        )
      )
    )
  )
  
  (if xp_oce (setvar "cmdecho" xp_oce)) ; restore old cmdecho value
  (setq *error* xp_err)               ; restore old *error* handler
  (prin1)
) 
;;;
;;; Sort out all of the entities which can be exploded from the selection
;;; set.  Also ensure that block insertions have equal X, Y and Z scale factors.
;;;
;;; xp_sxe == DLine_Sort_Xplodable_Entities
;;;
(defun xp_sxe (/ temp bad)

  (setq sslen (sslength ss)
        j     0
        ss1   (ssadd)
  )
  (while (< j sslen)
    (setq temp (ssname ss j))
    (setq j (1+ j))
    (if (member (xp_val 0 temp nil) '("INSERT" "DIMENSION" "POLYLINE"))
      (if (= (xp_val 0 temp nil) "INSERT")
        (if (and (= (xp_val 41 temp nil) (xp_val 42 temp nil)) 
                 (= (xp_val 41 temp nil) (xp_val 43 temp nil))
            )
          (ssadd temp ss1)
        )
        (ssadd temp ss1)
      )
    )
  )
  (setq sslen (sslength ss)
        bad (sslength ss1)
  )
  (princ "\n")
  (princ sslen)
  (princ " entities found.  ")
  (if (> (- sslen bad) 0)
    (progn
      (princ (- sslen bad))
      (princ " invalid. ")
    )
  )
  ss1
)
;;;
;;; Set the type of explode to do.
;;;
;;; xp_gxt == XPlode_Get_Xplode_Type
;;;
(defun xp_gxt (/ temp)
  
  (initget "All Color LAyer LType Inherit Explode")
  (setq temp (getkword
    "\n\nAll/Color/LAyer/LType/Inherit from parent block/<Explode>: "))

  (if (or (= temp "") (null temp))
    (setq temp "Explode")
  )
  temp
)
;;;
;;; Do the explosion of an entity.
;;;
;;; xp_xpe == XPlode_XPlode_Entity
;;;
(defun xp_xpe (ent typ /  )

  (cond 
    ((= typ "All")
      (if prmpt
        (progn
          (setq color (xp_scn))
          (setq ltype (xp_slt))
          (setq layer (xp_sla))
          (setq prmpt nil)
        )
      )

      (xp_xfa)
      (if (or (= ans "Individually") (= j (1- sslen)))
        (progn
          (if (and (> sslen 1) (= ans "Globally"))
            (princ "\nEntities ")
            (princ "\nEntity ")
          )
          (princ (strcat "exploded with color of " 
                         (if (= (type color) 'INT) (itoa color) color) ", "
                         "linetype of " ltype ", "
                         "and layer " layer "."))
        )
      )
    )
    ((= typ "Color")
      (if prmpt
        (progn
          (setq color (xp_scn))
          (setq ltype (getvar "celtype"))
          (setq layer (getvar "clayer"))
          (setq prmpt nil)
        )
      )

      (xp_xfa)
      (if (or (= ans "Individually") (= j (1- sslen)))
        (progn
          (if (and (> sslen 1) (= ans "Globally"))
            (princ "\nEntities ")
            (princ "\nEntity ")
          )
          (princ (strcat "exploded with color of  " 
                         (if (= (type color) 'INT) (itoa color) color) ".")) 
        )
      )
    )
    ((= 
    typ "LAyer")
      (if prmpt
        (progn
          (setq color (getvar "cecolor"))
          (setq ltype (getvar "celtype"))
          (setq layer (xp_sla))
          (setq prmpt nil)
        )
      )

      (xp_xfa)
      (if (or (= ans "Individually") (= j (1- sslen)))
        (progn
          (if (and (> sslen 1) (= ans "Globally"))
            (princ "\nEntities ")
            (princ "\nEntity ")
          )
          (princ (strcat "exploded onto layer " layer ".")) 
        )
      )
    )
    ((= typ "LType")
      (if prmpt
        (progn
          (setq color (getvar "cecolor"))
          (setq ltype (xp_slt))
          (setq layer (getvar "clayer"))
          (setq prmpt nil)
        )
      )

      (xp_xfa)
      (if (or (= ans "Individually") (= j (1- sslen)))
        (progn
          (if (and (> sslen 1) (= ans "Globally"))
            (princ "\nEntities ")
            (princ "\nEntity ")
          )
          (princ (strcat "exploded with linetype of  " ltype ".")) 
        )
      )
    )
    ((= typ "Inherit")
      (xp_iap ent)
    )
    (T
      (command "explode" (xp_val -1 ent nil))
    )
  )
)
;;;
;;; Force the color, linetype and layer attributes after exploding.
;;;
;;; xp_xea == XPlode_Xplode_Force_All
;;;
(defun xp_xfa ()

  (setq e0 (entlast))
  (setq en (entnext e0))
  (while (not (null en))              ; find the last entity              
    (setq e0 en)
    (setq en (entnext e0))
  ) 
      
  (command "explode" (xp_val -1 ent nil)) ; explode the entity

  (setq s0 (ssadd))
  
  (while (entnext e0) 
    (ssadd (setq e0 (entnext e0))
           s0
    )
  ) 
  (command "chprop" s0 ""             ; change entities to the proper layer
           "c"  color                 ; color, and linetype, regardless
           "lt" ltype                 ; of their extrusion direction
           "la" layer
           ""
  ) 
)
;;;
;;; Inherit attributes (if BYBLOCK) from parent.
;;;
;;; xp_iap == XPlode_Inherit_Attributes_from_Parent
;;;
(defun xp_iap (t1 / t1cl t1lt t1ly s0ly s0lt s0cl t0e)
  (setq t0 (entlast))
  (setq tn (entnext t0))
  (while (not (null tn))              ; find the last entity              
    (setq t0 tn)
    (setq tn (entnext t0))
  ) 
      
  (setq t1cl (xp_val 62 t1 nil))      ; record the attributes of the block
  (setq t1lt (xp_val 6  t1 nil))
  (setq t1ly (xp_val 8  t1 nil))
  (command "explode" (xp_val -1 t1 nil)) ; explode the entity
  (setq s0ly (ssadd))                 ; create nil selection sets for layer
  (setq s0lt (ssadd))                 ; linetype and color changes
  (setq s0cl (ssadd))
  (setq t0 (entnext t0))
  (while t0                           ; can exploded entities
    (setq t0e (entget t0))            ; and build selection sets
    
    (if (=  (xp_val 62 t0e T) "BYBLOCK") (ssadd t0 s0cl))
    (if (=  (xp_val 6  t0e T) "BYBLOCK") (ssadd t0 s0lt))
    (if (=  (xp_val 8  t0e T) "0")       (ssadd t0 s0ly))
    (setq t0 (entnext t0))
  )
  (if (> (sslength s0cl) 0)           ; is selection set non-nil...
      (command "chprop" s0cl ""       ; Change exploded entities with color
               "co" t1cl "")          ; BYBLOCK to color of old block
  )
  (if (> (sslength s0lt) 0)
      (command "chprop" s0lt ""       ; Change exploded entities with linetype
               "lt" t1lt "")          ; BYBLOCK to linetype of old block
  )
  (if (> (sslength s0ly) 0)
      (command "chprop" s0ly ""       ; Change exploded entities with linetype
               "la" t1ly "")          ; BYBLOCK to linetype of old block
  )
  (if (or (= ans "Individually") (= j (1- sslen)))
    (progn
      (if (and (> sslen 1) (= ans "Globally"))
        (princ "\nEntities ")
        (princ "\nEntity ")
      )
      (princ "exploded.") 
    )
  )
)

;;;
;;; Set the color for the exploded entities.
;;;
;;; xp_scn == XPlode_Set_Color_Number
;;;
(defun xp_scn ()
  (setq arg 257)
  (while (> arg 256)
    (initget 2 "Red Yellow Green Cyan Blue Magenta White BYLayer BYBlock")
    (setq arg (getint (strcat
      "\n\nNew color for exploded entities.  "
      "\nRed/Yellow/Green/Cyan/Blue/"
      "Magenta/White/BYLayer/BYBlock/<"
      (if (= (type (getvar "cecolor")) 'INT)
        (itoa (getvar "cecolor")) 
        (getvar "cecolor")
      ) 
      ">: ")))
    (cond
      ((= arg "BYLayer") (setq arg 0))
      ((= arg "Red")     (setq arg 1))
      ((= arg "Yellow")  (setq arg 2))
      ((= arg "Green")   (setq arg 3))
      ((= arg "Cyan")    (setq arg 4))
      ((= arg "Blue")    (setq arg 5))
      ((= arg "Magenta") (setq arg 6))
      ((= arg "White")   (setq arg 7))
      ((= arg "BYBlock") (setq arg 256))
      (T
        (if (= (type arg) 'INT)
          (if (> arg 255)
            (progn
              (princ "\nColor number out of range 1 - 255. ")
              (setq arg 257) ; kludge
            )
          )
          (setq arg (if (= (type (setq arg (getvar "cecolor"))) 'INT)
                      (getvar "cecolor") 
                      (cond
                        ((= arg "BYLAYER") (setq arg 0))
                        ((= arg "BYBLOCK") (setq arg 256))
                      )
                    )
          )
        )
      )
    )
  )
  (cond
    ((= arg 0) (setq arg "BYBLOCK"))
    ((= arg 256) (setq arg "BYLAYER"))
  )
  arg
)
;;;
;;; Set the linetype from the loaded linetypes.
;;;
;;; xp_slt == XPlode_Set_Line_Type
;;;
(defun xp_slt ()
  (princ "\n\nChoose from the following list of linetypes. ")
  (tblnext "ltype" T)
  (setq xp_lta "CONTINUOUS,CONT BYLayer BYBlock"
        xp_ltb "BYBlock/BYLayer/CONTinuous")

  (while (setq xp_lt (cdr(assoc 2 (tblnext "ltype"))))
    (setq xp_lta (strcat xp_lta " " xp_lt)
          xp_ltb (strcat xp_ltb "/" xp_lt))
  )
  (initget xp_lta)
  (princ (strcat 
    "\nEnter new linetype name. \n" xp_ltb "/<"
    (getvar "celtype") "> : "))
  (setq xp_nln (getkword) )
  (if (or (= xp_nln nil) (= xp_nln ""))
    (setq xp_nln (getvar "celtype"))
  )
  xp_nln
)
;;;
;;; Set a layer if it exists.
;;;
;;; xp_sla == XPlode_Set_LAyer
;;;
(defun xp_sla (/ temp)
  (while (null temp)
    (initget 1)
    (setq temp (getstring (strcat
      "\n\nXPlode onto what layer?  <" (getvar "clayer") ">: ")))
    (if (or (= temp "") (null temp))
      (setq temp (getvar "clayer"))
      (if (not (tblsearch "layer" temp))
        (progn
          (princ "\nInvalid layer name. ")
          (setq temp nil)
        )
      )
    )
  )
  temp
)

;;; --------------------------------------------------------------------------;
(defun c:xp       () (explode))
(defun c:xplode   () (explode))
(princ 
  "\n\tC:XPlode loaded.  Start command with XP or XPLODE.")
(princ)
