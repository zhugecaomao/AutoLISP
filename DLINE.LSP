;;;   DLINE.LSP
;;;   Copyright (C) 1990-1992 by Autodesk, Inc.
;;;      
;;;   Permission to use, copy, modify, and distribute this software 
;;;   for any purpose and without fee is hereby granted, provided 
;;;   that the above copyright notice appears in all copies and that 
;;;   both that copyright notice and this permission notice appear in 
;;;   all supporting documentation.
;;;
;;;   THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED
;;;   WARRANTY.  ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR
;;;   PURPOSE AND OF MERCHANTABILITY ARE HEREBY DISCLAIMED.
;;;
;;;   DESCRIPTION
;;;     
;;;     This is a general purpose "double-line/arc" generator.  It performs 
;;;     automatic corner intersection cleanups, as well as a number of other 
;;;     features described below.
;;;  
;;;     The user is prompted for a series of endpoints.  As they are picked 
;;;     "DLINE"  segments are drawn on the current layer.  Options are 
;;;     available for changing the Width of the DLINE, specifying whether
;;;     or not to Snap to existing lines or arcs, whether or not to 
;;;     Break the lines or arcs when snapping to them, and which of the 
;;;     following to do:  
;;;     
;;;     Set the global variable dl:ecp to the values listed below:
;;;  
;;;     Value  Meaning
;;;     ---------------------------
;;;       0    No end caps
;;;       1    Start end cap only
;;;       2    Ending end cap only
;;;       3    Both end caps
;;;       4    Auto ON -- Cap any end not on a line or arc.
;;;       
;;;     The user may choose to back up as far as the beginning of the command 
;;;     by typing "U" or "Undo", both of which operate as AutoCAD's "UNDO 1" 
;;;     does.
;;;     
;;;     Curved DLINE's are drawn using the AutoCAD ARC command and follow as 
;;;     closely as possible its command structure for the various options.
;;;  
;;;----------------------------------------------------------------------------
;;;   OPERATION
;;;
;;;     The routine is executed, after loading, by typing either DL or DLINE
;;;     at which time you are presented with the opening line and menu of
;;;     choices:
;;;     
;;;       Dline, Version 1.11, (c) 1990-1992 by Autodesk, Inc.  
;;;       Break/Caps/Dragline/Offset/Snap/Undo/Width/<start point>: 
;;;     
;;;     Typing Break allows you to set breaking of lines and arcs found at
;;;     the start and end points of any segment either ON or OFF.
;;;     
;;;       Break Dline's at start and end points?  OFF/<ON>:
;;;     
;;;     Typing Caps allows you to specify how the DLINE will be finished 
;;;     off when exiting the routine, per the values listed above.
;;;     
;;;       Draw which endcaps?  Both/End/None/Start/<Auto>:
;;;       
;;;     The default of Auto caps an end only if you did not snap to an arc
;;;     or line.
;;;     
;;;     Typing Dragline allows you to set the location of the dragline
;;;     relative to the centerline of the two arcs or lines to any value
;;;     between - 1/2 of "tracewid" and + 1/2 of "tracewid".  (There is a
;;;     local variable you may set if you want to experiment with offsets
;;;     outside this range;  the results may not be correct, your choice.
;;;     See the function (dl_sao) for more information.)
;;;     
;;;       Set dragline position to Left/Center/Right/<Offset from center = 0.0>:
;;;     
;;;     Enter any real number or one of the keywords.  The value in the angle
;;;     brackets is the default value and changes as you change the dragline
;;;     position.
;;;     
;;;     Offset allows the first point you enter to be offset from a known
;;;     point.
;;;     
;;;       Offset from:  (enter a point)
;;;       Offset toward:    (enter a point)
;;;       Enter the offset distance:   (enter a distance or real number)
;;;  
;;;     Snap allows you to set the snapping size and turn snapping ON or OFF.
;;;     
;;;       Set snap size or snap On/Off.  Size/OFF/<ON>:
;;;       New snap size (1 - 10):
;;;     
;;;     The upper limit may be reset by changing the value of MAXSNP to a 
;;;     value other than 10.  Higher values may be necessary for ADI display
;;;     drivers, but generally, you should keep this value somewhere in the 
;;;     middle of the allowed range for snapping to work most effectively 
;;;     in an uncluttered drawing, and toward the lower end for a more 
;;;     cluttered drawing.  You may also use object snap to improve your 
;;;     aim.
;;;     
;;;     This feature allows you to very quickly "snap" to another line or arc, 
;;;     breaking it at the juncture and performing all of the intersection 
;;;     cleanups at one time without having to be precisely on the line, i.e., 
;;;     you can be visually one the line and it will work, or you can use 
;;;     object snap to be more precise.
;;;     
;;;     Undo backs you up one segment in the chain of segments you are drawing,
;;;     stopping when there are no more segments to be undone.  All of the 
;;;     necessary points are saved in lists so that the DLINE will close, cap,
;;;     and continue correctly after any number of undo's.
;;;     
;;;     Width prompts you for a new width.
;;;     
;;;       New DLINE width <1.0000>:
;;;       
;;;     You may enter a new width and continue the DLINE in the same direction
;;;     you were drawing before;  if you do this, connecting lines from the
;;;     endpoints of the previous segment are drawn to the start points of 
;;;     the new segment.
;;;     
;;;     If you press RETURN after closing a DLINE or before creating any
;;;     DLINE's, you will see this message:
;;;     
;;;       No continuation point -- please pick a point.  
;;;       Break/Caps/Dragline/Offset/Snap/Undo/Width/<start point>:  
;;;     
;;;     After you pick the first point, you will see this set of options:
;;;     
;;;       Arc/Break/CAps/CLose/Dragline/Snap/Undo/Width/<next point>:
;;;       
;;;     Picking more points will draw straight DLINE segments until either 
;;;     RETURN is pressed or the CLose option is chosen.
;;;     
;;;     CLose will close the lines if you have drawn at least two segments.
;;;     
;;;     Selecting Arc presents you with another set of choices:
;;;     
;;;       Break/CAps/CEnter/CLose/Dragline/Endpoint/Line/Snap/Undo/Width/<second point>:
;;;     
;;;     All of the options here are the same as they are for drawing straight
;;;     DLINE's except CEnter, Endpoint, and Line.
;;;     
;;;     The default option, CEnter, and Endpoint are modeled after the ARC
;;;     command in AutoCAD and exactly mimic its operation including all of
;;;     the subprompts.  Refer to the AutoCAD reference manual for exact usage.
;;;     
;;;     The Line option returns you to drawing straight DLINE segments.
;;;     
;;;     Snapping to existing LINE's an ARC's accomplishes all of the trimming 
;;;     and extending of lines and arcs necessary, including cases where arcs 
;;;     and lines do not intersect.  In these cases a line is drawn from either;
;;;     a point on the arc at the perpendicular point from the center of the 
;;;     arc to the line, to the line, or along the line from the centers of the
;;;     two arcs that do not intersect at the points where this line crosses
;;;     the two arcs.  In this way, we ensure that all DLINE's can be closed
;;;     visually.
;;;     
;;;     Breaking will not work unless Snapping is turned on.
;;;     
;;;----------------------------------------------------------------------------
;;;  GLOBALS:
;;;     dl:osd -- dragline alignment offset from center of two lines or arcs.
;;;     dl:snp -- T if snapping to existing lines and arcs.
;;;     dl:brk -- T if breaking existing lines and arcs.
;;;     dl:ecp -- Bitwise setting of caps when exiting.
;;;     v:stpt -- Continuation point.
;;;----------------------------------------------------------------------------
;;;
;;; ===========================================================================
;;; ===================== load-time error checking ============================
;;;

  (defun ai_abort (app msg)
     (defun *error* (s)
        (if old_error (setq *error* old_error))
        (princ)
     )
     (if msg
       (alert (strcat " Application error: "
                      app
                      " \n\n  "
                      msg
                      "  \n"
              )
       )
     )
     (exit)
  )

;;; Check to see if AI_UTILS is loaded, If not, try to find it,
;;; and then try to load it.
;;;
;;; If it can't be found or it can't be loaded, then abort the
;;; loading of this file immediately, preserving the (autoload)
;;; stub function.

  (cond
     (  (and ai_dcl (listp ai_dcl)))          ; it's already loaded.

     (  (not (findfile "ai_utils.lsp"))                     ; find it
        (ai_abort "DLINE"
                  (strcat "Can't locate file AI_UTILS.LSP."
                          "\n Check support directory.")))

     (  (eq "failed" (load "ai_utils" "failed"))            ; load it
        (ai_abort "DLINE" "Can't load file AI_UTILS.LSP"))
  )

  (if (not (ai_acadapp))               ; defined in AI_UTILS.LSP
      (ai_abort "DLINE" nil)         ; a Nil <msg> supresses
  )                                    ; ai_abort's alert box dialog.

;;; ==================== end load-time operations ===========================
;;; Main function

(defun dline  (/ strtpt nextpt pt1    pt2    spts   wnames elast
                 uctr   pr     prnum  temp   ans    dir    ipt
                 v      lst    dist   cpt    rad    orad   ftmp
                 spt    ept    pt     en1    en2    npt    cpt1
                 flg    cont   flg2   flgn   ang    tmp    undo_setting
                 brk_e1 brk_e2 bent1  bent2  nn     nnn    
                 dl_osm dl_oem dl_oce dl_opb dl_obm dl_ver 
                 dl_err dl_oer dl_arc fang   MAXSNP ange   
                 savpt1 savpt2 savpt3 savpt4 savpts 
              )

  ;; Version number.  Reset this local if you make a change.
  (setq dl_ver "1.11")  
  
  ;; Reset this value higher for ADI drivers.
  (setq MAXSNP 10)              

  (setq dl_osm (getvar "osmode")
        dl_oce (getvar "cmdecho")
        dl_opb (getvar "pickbox")
  )

  ;;
  ;; Internal error handler defined locally
  ;;

  (defun dl_err (s)                   ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (command "_.UNDO" "_EN")
    (ai_undo_off)
    (if dl_oer                        ; If an old error routine exists
      (setq *error* dl_oer)           ; then, reset it 
    )
    (if dl_osm (setvar "osmode" dl_osm))
    (if dl_opb (setvar "pickbox" dl_opb))
    
    ;; Reset command echoing on error
    (if dl_oce (setvar "cmdecho" dl_oce))      
    (princ)
  )
  
  ;; Set our new error handler
  (if (not *DEBUG*)
    (if *error*
      (setq dl_oer *error* *error* dl_err)
      (setq *error* dl_err)
    )
  )

  (setvar "cmdecho" 0)
  (ai_undo_on)                       ; Turn on UNDO
  (command "_.UNDO" "_GROUP")
  (setvar "osmode" 0)
  (if (null dl:opb) (setq dl:opb (getvar "pickbox")))

  
  (setq nextpt "Straight")
 
  ;; Get the first segment's start point
 
  (menucmd "s=dline1")
  (graphscr)
  (princ (strcat "\nDline, Version " dl_ver ", (c) 1990-1992 by Autodesk, Inc. "))
  
  (setq cont T)
  (while cont
    (dl_m1)
 
    ;; Ready to draw successive DLINE segments
 
    (dl_m2)
  )
  
  (if dl_osm (setvar "osmode" dl_osm))
  (if dl_opb (setvar "pickbox" dl_opb))

  (ai_undo_off)                      ; Return UNDO to initial state

  ;; Reset command echoing
  (if dl_oce (setvar "cmdecho" dl_oce))      
  (menucmd "s=s")
  (princ)
)
;;;
;;; Main function subsection 1.
;;;
;;; dl_m1 == DLine_Main_1
;;;
(defun dl_m1 ()
  (setq temp T
        uctr nil 
  )
  (if dl_arc
    (setq nextpt "Arc")
    (setq nextpt "Line")
  )
  ;; temp set to nil when a valid point is entered.
  (while temp
    (initget "Break Caps Dragline Offset Snap Undo Width")
    (setq strtpt (getpoint 
      "\nBreak/Caps/Dragline/Offset/Snap/Undo/Width/<start point>: "))
    (cond
      ((= strtpt "Dragline")
        (dl_sao)
      )
      ((= strtpt "Break")
        (initget "ON OFf")
        (setq dl:brk (getkword 
          "\nBreak Dline's at start and end points?  OFf/<ON>: "))
        (setq dl:brk (if (= dl:brk "OFf") nil T))    
      )
      ((= strtpt "Offset")
        (dl_ofs)
      )
      ((= strtpt "Snap")
        (dl_sso)
      )
      ((= strtpt "Undo")
        (princ "\nAll segments already undone. ")
        (setq temp T)
      )
      ((= strtpt "Width")
        (initget 6)
        (dl_snw)
        (setq temp T)
      )
      ((null strtpt)
        (if v:stpt
          (setq strtpt v:stpt
                temp   nil
          )
          (progn
            (princ "\nNo continuation point -- please pick a point. ")
          )
        )
      )
      ((= strtpt "Caps")
        (endcap)    
      )
      ;; If none of the above, it must be OK to continue - a point has been 
      ;; picked or entered from the keyboard.
      (T
        (setq v:stpt strtpt
              temp   nil
        )
      )
    )
  )
)
;;;
;;; Main function subsection 2.
;;;
;;; dl_m3 == DLine_Main_2
;;;
(defun dl_m2 (/ temp)
  (setq spts (list strtpt)
        uctr 0 
  )
  (if dl:snp
    (dl_ved "brk_e1" strtpt)
  )
  ;; Make sure that the offset is not greater than 1/2 of "tracewid", even
  ;; if the user transparently resets it while the command is running.
  (setq temp (/ (getvar "tracewid") 2.0))
  (if (< dl:osd (- temp))
    (setq dl:osd (- temp))
  )
  (if (> dl:osd temp)
    (setq dl:osd temp)
  )
    
  (while (and nextpt (/= nextpt "CLose"))
    (if (/= nextpt "Quit")
      (if dl_arc 
        (progn
          (menucmd "s=dline2")
          (initget 
            "Break CAps CEnter CLose Dragline Endpoint Line Snap Undo Width")
          (setq nextpt (getpoint strtpt (strcat
            "\nBreak/CAps/CEnter/CLose/Dragline/Endpoint/"
            "Line/Snap/Undo/Width/<second point>: "))
          )
        )
        (progn
          (menucmd "s=dline3")
          (initget "Arc Break CAps CLose Dragline Snap Undo Width")
          (setq nextpt (getpoint strtpt
            "\nArc/Break/CAps/CLose/Dragline/Snap/Undo/Width/<next point>: ")
          )
        )
      )
    )
    (setq v:stpt (last spts))
    (cond
      ((= nextpt "Dragline")
        (dl_sao)
      )
      ((= nextpt "Width")
        (dl_snw)
        
      )
      ((= nextpt "Undo")
        (cond
          ;;((= uctr 0) (princ "\nNothing to undo. ") )
          ((= uctr 0) (setq nextpt nil) )
          ((> uctr 0) 
            (command "_.U")
            (setq spts   (dl_lsu spts 1))
            (setq savpts (dl_lsu savpts 2))
            (setq wnames (dl_lsu wnames 2))
            (setq uctr (- uctr 2))
            (setq strtpt (last spts))
          )
        ) 
        (if dl:snp
          (if (= uctr 0)
            (dl_ved "brk_e1" strtpt)
          ) 
        ) 
      )
      ((= nextpt "Break")
        (initget "ON OFf")
        (setq dl:brk (getkword 
          "\nBreak Dline's at start and end points?  OFF/<ON>: "))
        (setq dl:brk (if (= dl:brk "OFf") nil T))    
        
        (if dl:snp
          (dl_ved "brk_e1" strtpt)
        )
        (if dl_arc
          (setq nextpt "Arc")
          (setq nextpt "Line")
        )
      )
      ((= nextpt "Snap")
        (dl_sso)
      )
      ((= nextpt "Arc")
        (setq dl_arc T)               ; Change to Arc segment prompt.
      )
      ((= nextpt "Line")
        (setq dl_arc nil)             ; Change to Line segment prompt.
      )
      ((= nextpt "CLose")
        (dl_cls)
      )
      ((= (type nextpt) 'LIST)
        (dl_ds)
      )
      ((= nextpt "CEnter")
        (dl_ceo)
      )
      ((= nextpt "Endpoint")
        (dl_epo)
      )
      ((= nextpt "CAps")
        (endcap)                      ; Set which caps to draw when exiting.
      )
      (T
        (setq nextpt nil cont nil)
        (if (> uctr 1)
          (if (= (logand 4 dl:ecp) 4)
            (progn
              (if (null brk_e1) (command "_.LINE" savpt1 savpt2 ""))
              (dl_ssp)
              (if (null brk_e2) (command "_.LINE" savpt3 savpt4 ""))
            )
            (progn
              (if (= (logand 1 dl:ecp) 1)
                (command "_.LINE" savpt1 savpt2 "")
              )
              (if (= (logand 2 dl:ecp) 2)
                (progn
                  (dl_ssp)
                  (command "_.LINE" savpt3 savpt4 "")
                )
              )
            )
          )
        )
        (if brk_e1 (setq brk_e1 nil))
        (if brk_e2 (setq brk_e2 nil))
        (command "_.UNDO" "_EN")
      )                               ; end of inner cond  
    )                                 ; end of outer cond  
  )                                   ; end of while
)
;;; ------------------ End Main Functions ---------------------------
;;; ---------------- Begin Support Functions ------------------------


;;;
;;; Close the DLINE with either straight or arc segments.  
;;; If closing with arcs, the minimum number of segments already drawn
;;; is 1, otherwise it is 2.
;;;
;;; dl_cls == DLine_CLose_Segments
;;;
(defun dl_cls ()
  (if (or (and (null dl_arc) (< uctr 4)
               (if (> uctr 1)
                 (/= (dl_val 0 (entlast)) "ARC")
                 (not (> uctr 1))
               )
          )
          (and dl_arc (< uctr 2)))
    (progn 
      (princ "\nCannot close -- too few segments. ")
      (if dl_arc
        (setq nextpt "Arc")
        (setq nextpt "Line")
      )
    )
    (progn
      (command "_.UNDO" "_GROUP")
      (setq nextpt (nth 0 spts))
      (if (null dl_arc)
        ;; Close with line segments
        (dl_mlf 3)
        (progn
          (setq tmp (last wnames)
                ange (trans '(1 0 0) (dl_val -1 tmp) 1)
                ange (angle '(0 0 0) ange)
                dir (if (= (dl_val 0 tmp) "LINE")
                      (angle (trans (dl_val 10 tmp) 0 1) 
                             (trans (dl_val 11 tmp) 0 1))
                      (progn
                        (setq dir (+ (dl_val 50 tmp) ange)
                              dir (if (> dir (* 2 pi))
                                    (- dir (* 2 pi))
                                    dir
                                  )
                        )
                        (if (equal dir
                                   (setq dir (angle (trans (dl_val 10 tmp) 
                                                           (dl_val -1 tmp) 
                                                           1)
                                                    strtpt
                                             ) 
                                   )
                                   0.01)
                          (- dir (/ pi 2))
                          (+ dir (/ pi 2))
                        )
                      )
                    )
          )
          (command "_.ARC" 
                   strtpt 
                   "_E" 
                   nextpt 
                   "_D"
                   (* dir (/ 180 pi))
          )
          ;; Close with arc segments
          (dl_mlf 4)
        )
      )
      ;; set nextpt to "CLose" which will cause an exit.
      (setq nextpt "CLose"
            v:stpt nil
            cont   nil
      )
    )
  )
)
;;;
;;; A point was entered, do either an arc or line segment.
;;;
;;; dl_ds == DLine_Do_Segment
;;;
(defun dl_ds ()
  (if (equal strtpt nextpt 0.0001)
    (progn
      (princ "\nCoincident point -- please try again. ")
      (if dl_arc
        (setq nextpt "Arc")
        (setq nextpt "Line")
      )
    )
    (progn
      (command "_.UNDO" "_GROUP")
      (setq nextpt (list (car nextpt) (cadr nextpt) (caddr strtpt)))
      (if dl_arc
        (progn
          (command "_.ARC" strtpt nextpt)
          (prompt "\nEndpoint: ")
          (command pause)
          (setq nextpt (getvar "lastpoint")
                v:stpt nextpt)
          (setq temp (entlast))
          ;; Delete the last arc segment so we can find the line or 
          ;; arc under it.
          (entdel temp)
          (if dl:snp
            (dl_ved "brk_e2" nextpt)
          )
          ;; Restore the arc previously deleted.
          (entdel temp)
          ;; Draw the arc segments.
          (dl_mlf 2)
        )
        (progn
          (setq v:stpt nextpt)
          (if dl:snp
            (dl_ved "brk_e2" nextpt)
          )
          (if (and brk_e1 (eq brk_e1 brk_e2) (= (dl_val 0 brk_e1) "LINE"))
            (progn
              (princ "\nSecond point cannot be on the same line segment. ")
              (setq brk_e2 nil)
            )
            ;; Draw the line segments.
            (dl_mlf 1)
          )
        )
      )
      (if brk_e2 (setq nextpt "Quit"))
    )
  )
)
;;;
;;; The CEnter option for drawing arc segments was selected.
;;;
;;; dl_ceo == DLine_CEnter_Option
;;;
(defun dl_ceo ()
  (command "_.UNDO" "_GROUP")
  (setq temp T)
  (while temp
    (initget 1)
    (setq cpt (getpoint strtpt "\nCenter point: "))
    (if (<= (distance cpt strtpt) (- (/ (getvar "tracewid") 2.0) dl:osd))
      (progn
        (princ 
        "\nThe radius defined by the selected center point is too small ")
        (princ "\nfor the current Dline width.  ")
        (princ "Please select another point.")
      )
      (setq temp nil)
    )
  )
  ;; Start the ARC command so that we can get visual dragging.
  (command "_.ARC" strtpt "_C" cpt)
  (initget "Angle Length Endpoint")
  (setq nextpt (getkword "\nAngle/Length of chord/<Endpoint>: "))
  (cond 
    ((= nextpt "Angle")
      (prompt "\nIncluded angle: ")
      (command "_A" pause)
      (setq nextpt (dl_vnp)
            v:stpt nextpt
      )
      ;; Draw the arc segments.
      (dl_mlf 2) 
    )
    ((= nextpt "Length")
      (prompt "\nChord length: ")
      (command "_L" pause)
      (setq nextpt (dl_vnp)
            v:stpt nextpt
      )
      ;; Draw the arc segments.
      (dl_mlf 2) 
    )
    (T
      (prompt "\nEndpoint: ")
      (command pause)
      (setq nextpt (dl_vnp)
            v:stpt nextpt
      )
      ;; Draw the arc segments.
      (dl_mlf 2) 
    )
  )
)
;;;
;;; Endpoint option was selected.
;;;
;;; dl_epo == DLine_End_Point_Option
;;;
(defun dl_epo ()
  (command "_.UNDO" "_GROUP")
  (initget 1)
  (setq cpt (getpoint "\nEndpoint: "))
  ;; Start the ARC command so that we can get visual dragging.
  (command "_.ARC" strtpt "_E" cpt)
  (initget "Angle Direction Radius Center")
  (setq nextpt (getkword "\nAngle/Direction/Radius/<Center>: "))
  (cond 
    ((= nextpt "Angle")
      (prompt "\nIncluded angle: ")
      (command "_A" pause)
      (setq nextpt (dl_vnp)
            v:stpt nextpt
      )
      ;; Draw the arc segments.
      (dl_mlf 2) 
    )
    ((= nextpt "Direction")
      (prompt "\nTangent direction: ")
      (command "_D" pause)
      (setq nextpt (dl_vnp)
            v:stpt nextpt
      )
      ;; Draw the arc segments.
      (dl_mlf 2) 
    )          
    ((= nextpt "Radius")
      (setq temp T)
      (while temp
        (initget 1)
        (setq rad (getdist cpt "\nRadius: "))
        
        (if (or (<= rad (/ (getvar "tracewid") 2.0))
                (< rad (/ (distance strtpt cpt) 2.0)))
          (progn
            (princ "\nThe radius entered is less than 1/2 ")
            (princ "of the Dline width or is invalid")
            (princ "\nfor the selected endpoints.  ")
            (princ "Please enter a radius greater than ")
            (if (< (/ (getvar "tracewid") 2.0) 
                   (/ (distance strtpt cpt) 2.0))
              (princ (rtos (/ (distance strtpt cpt) 2.0)))
              (princ (rtos (/ (getvar "tracewid") 2.0)))
            )
            (princ ". ")
          )
          (setq temp nil)
        )
      )
      (command "_R" rad)
      (setq nextpt (dl_vnp)
            v:stpt nextpt
      )
      ;; Draw the arc segments.
      (dl_mlf 2) 
    )
    (T
      (prompt "\nCenter: ")
      (command pause)
      (setq nextpt (dl_vnp)
            v:stpt nextpt
      )
      ;; Draw the arc segments.
      (dl_mlf 2) 
    )
  )
)
;;;
;;; Set the ending save points for capping the DLINE.
;;;
;;; dl_ssp == DLine_Set_Save_Points
;;;
(defun dl_ssp ( / temp)
  (setq temp (length savpts))
  (if (> temp 1)
    (progn
      (setq savpt3 (nth (- temp 2) savpts)
            savpt4 (nth (- temp 1) savpts)
      )
    )
  )
)
;;;
;;; Set the alignment of the "ghost" line to one of the following values:
;;;   
;;;   Left   == -1/2 of width (Real number)
;;;           > -1/2 of width (Real number)
;;;   Center == 0.0
;;;           < +1/2 of width (Real number)
;;;   Right  == +1/2 of width (Real number)
;;;
;;; All of the alignment options are taken as if you are standing at the
;;; start point of the line or arc looking toward the end point, with 
;;; left and negative values being on the left, center or 0.0 being
;;; directly in line, and right or positive on the right.
;;; 
;;; Entering a real number equal to 1/2 of the width sets an absolute offset
;;; distance from the centerline, while specifying the same offset distance
;;; with the keywords tells the routine to change the offset distance to 
;;; match 1/2 of the width, whenever it is changed.
;;;
;;; NOTE:  If you wish to allow the dragline to be positioned outside
;;;      of the two arcs or lines being created, you may set the local 
;;;      variable "dragos" = T, on the 4th line of the defun, which  
;;;      checks that the offset value entered is not greater or less 
;;;      than + or - TRACEWID / 2.
;;;      
;;;      You should be aware that the results of allowing this to occur
;;;      may not be obvious or necessarily correct.  Specifically, when
;;;      drawing lines with a width of 1 and an offset of 4, if you draw
;;;      segments as follows, the lines will cross back on themselves.
;;;      
;;;      dl 0,0,0 10,0,0 10,5 then 5,5
;;;      
;;;      However, this can be quite useful for creating parallel DLINE's.
;;;      
;;; dl_sao == DLine_Set_Alignment_Option
;;;
(defun dl_sao (/ temp dragos)
  (initget "Left Center Right")
  (setq temp dl:osd)
  ;;(setq dragos T)                   ; See note above.
  (setq dl:osd (getreal (strcat
    "\nSet dragline position to Left/Center/Right/<Offset from center = "
    (rtos dl:osd) ">: ")))
  (cond
    ((= dl:osd "Left")
      (setq dl:aln 1
            dl:osd (- (/ (getvar "tracewid") 2.0))
      )
    )
    ((= dl:osd "Center")
      (setq dl:aln 0
            dl:osd 0.0
      )
    )
    ((= dl:osd "Right")
      (setq dl:aln 2
            dl:osd (/ (getvar "tracewid") 2.0)
      )
    )
    ((= (type dl:osd) 'REAL)
      (if dragos
        (setq dl:aln nil)
        (progn
          (setq dl:aln nil)
          (if (> dl:osd (/ (getvar "tracewid") 2.0))
            (progn
              (princ "\nValue entered is out of range.  Reset to ")
              (princ (/ (getvar "tracewid") 2.0))
              (setq dl:osd (/ (getvar "tracewid") 2.0))
            )
          )
          (if (< dl:osd (- (/ (getvar "tracewid") 2.0)))
            (progn
              (princ "\nValue entered is out of range.  Reset to ")
              (princ (- (/ (getvar "tracewid") 2.0)))
              (setq dl:osd (- (/ (getvar "tracewid") 2.0)))
            )
          )
        )
      )
    )
    (T
      (setq dl:osd temp)
    )
  )
)
;;;
;;; Set a new DLINE width.
;;;
;;; dl_snw == DLine_Set_New_Width
;;;
(defun dl_snw ()
  (initget 6)
  (setvar "tracewid"
    (if (setq temp (getdist (strcat 
      "\nNew DLINE width <" (rtos (getvar "tracewid")) ">: ")))
      temp
      (getvar "tracewid") 
    ) 
  )
  (if dl:aln
    (cond
      ((= dl:aln 1) ; left aligned
        (setq dl:osd (- (/ (getvar "tracewid") 2.0)))
      )
      ((= dl:aln 2) ; right aligned
        (setq dl:osd (/ (getvar "tracewid") 2.0))
      )
      (T
        (princ)     ; center aligned
      )
    )
  )
)
;;;
;;; Get an offset from a given point to the start point toward a second
;;; point.  The distance between the two points is the default, but any
;;; positive distance may be entered.  If a negative number is entered,
;;; it is used as a percentage distance from the "Offset from" point 
;;; toward the "Offset toward" point, i.e., if -75 is entered, a point
;;; 75% of the distance between the two points listed above is returned.
;;; 
;;;
;;; dl_ofs == DLine_OFfset_Startpoint
;;;
(defun dl_ofs ()
  (menucmd "s=osnapb")
  (initget 1)
  (setq strtpt (getpoint "\nOffset from: "))
  (initget 1)
  (setq nextpt (getpoint strtpt "\nOffset toward: "))
  
  (setq dist (getdist strtpt (strcat
    "\nEnter the offset distance <" (rtos (distance strtpt nextpt)) 
    ">: ")))
  (setq dist (if (or (= dist "") (null dist))
               (distance strtpt nextpt)
               (if (< dist 0)
                 (* (distance strtpt nextpt) (/ (abs dist) 100.0))
                 dist
               )
             )
  )              
  (setq strtpt (polar strtpt
                      (angle strtpt nextpt)
                      dist
               ) 
  )
  (setq temp nil)
  (command "_.UNDO" "_GROUP")
)
;;;
;;; Set snap options to ON, OFF or set the size of the area to be searched
;;; by (ssget point) via "pickbox".  This value is being limited for built-
;;; in display drivers at 10 pixels.  For ADI drivers it may be necessary 
;;; to bump up this number by adjusting "MAXSNP" at the top of this file.
;;;
;;; dl_sso == DLine_Set_Snap_Options
;;;
(defun dl_sso ()
  (initget "ON OFf Size")
  (setq ans (getkword
    "\nSet snap size or snap On/Off.  Size/OFF/<ON>: "))
  (if (= ans "OFf") 
    (progn
      (setq dl:snp nil)
      (setvar "pickbox" 0) 
    )
    (if (= ans "Size") 
      (progn
        (setq dl:snp T ans 0)
        (while (or (< ans 1) (> ans MAXSNP))
          (setq ans (getint (strcat
            "\nNew snap size (1 - " (itoa MAXSNP) ") <" (itoa dl:opb) ">: ")))

          (if (or (= ans "") (null ans))
            (setq ans dl:opb)
          )
        )
        (setvar "pickbox" ans)
        (setq dl:opb ans)
      )
      (progn
        (setq dl:snp T)
        (setvar "pickbox" dl:opb)
      )  
    ) 
  )
  (if dl:snp
    (if (= uctr 0)
      (dl_ved "brk_e1" strtpt)
    ) 
  ) 
  (if dl_arc
    (setq nextpt "Arc")
    (setq nextpt "Line")
  )

)
;;;
;;; Obtain and verify the extrusion direction of an entity at the 
;;; start point or endpoint of the line or arc we are drawing.
;;;
;;; dl_ved == DLine_Verify_Extrusion_Direction
;;;
(defun dl_ved (vent pt)
  ;; Get entity to break if the user snapped to a DLINE.
  ;; Make sure that it is a line or arc and that its extrusion
  ;; direction is parallel to the current UCS.
  (if (set (read vent) (ssget pt))
    (progn
      (set (read vent) (ssname (eval (read vent)) 0))
      (if (and 
            (or (= (dl_val 0 (eval (read vent))) "ARC")
                (= (dl_val 0 (eval (read vent))) "LINE")
            )
            (equal (caddr(dl_val 210 (eval (read vent))))
                   (caddr(trans '(0 0 1) 1 0)) 0.001)
          )
        (princ)
        (progn
          (princ (strcat
            "\nEntity found is not an arc or line, "
            "or is not parallel to the current UCS. "))
          (set (read vent) nil)
        )
      )
    )
  )
  (eval (read vent))
)
;;;
;;; Verify nextpt.
;;; Get the point on the arc at the opposite 
;;; end from the start point (strtpt).
;;;
;;; dl_vnp == DLine_Verify_NextPt
;;;
(defun dl_vnp (/ temp cpt ang rad)

  (setq temp (entlast))
  (if (= (dl_val 0 temp) "LINE")
    (setq nextpt (if (equal strtpt (dl_val 10 temp) 0.001)
                   (dl_val 11 temp)
                   (dl_val 10 temp)
                 )
    )
    ;; Then it must be an arc...
    (progn
      ;; get its center point
      (setq cpt  (trans (dl_val 10 temp) (dl_val -1 temp) 1)
            ang  (dl_val 50 temp)     ; starting angle
            rad  (dl_val 40 temp)     ; radius
      )
      (setq ange (trans '(1 0 0) (dl_val -1 temp) 1)
            ange (angle '(0 0 0) ange)
            ang (+ ang ange)
      )
      (if (> ang (* 2 pi))
        (setq ang (- ang (* 2 pi)))
      )
      (setq nextpt (if (equal strtpt (polar cpt ang rad) 0.01)
                     (polar cpt (dl_val 51 temp) rad)
                     (polar cpt ang rad)
                   )
      )
    )
  )
)
;;; ----------------- Main Line Drawing Function -------------------
;;;
;;; Draw the lines.
;;;
;;; dl_mlf == DLine_Main_Line_Function
;;;
(defun dl_mlf (flg / temp1 temp2 newang ang1 ang2 
                     ent cpt ang rad1 rad2 sent1 sent2
                     tmpt1 tmpt2 tmpt3 tmpt4)

  ;; Verify nextpt
  (if (null nextpt) (setq nextpt (dl_vnp)))
  
  (if (equal nextpt (nth 0 spts) 0.01)
    (if dl_arc
      (setq flg 4)
      (setq flg 3)
    )
  )
   
  (setq temp1  (+ (/ (getvar "tracewid") 2.0) dl:osd)
        temp2  (- (getvar "tracewid") temp1)
        newang (angle strtpt nextpt)
        ang1   (+ (angle strtpt nextpt) (/ pi 2))
        ang2   (- (angle strtpt nextpt) (/ pi 2))
  )
  (cond
    ((= flg 1)                        ; if drawing lines
      (dl_dls nil ang1 temp1)         ; Draw line segment 1
      (dl_dls nil ang2 temp2)         ; Draw line segment 2
    )
    ((or (= flg 2) (= flg 4))         ; else drawing arcs...
      (setq tmp (entlast)             ; get the last arc entity
            ent  (entget tmp)         ; (i.e., the guideline)
            ;; get its center point
            cpt  (trans (dl_val 10 tmp) (dl_val -1 tmp) 1) 
            ang  (dl_val 50 tmp)      ; starting angle
      )
      (setq ange (trans '(1 0 0) (dl_val -1 tmp) 1)
            ange (angle '(0 0 0) ange)
            ang (+ ang ange)
      )
      (if (> ang (* 2 pi))
        (setq ang (- ang (* 2 pi)))
      )
     
      ;; if start angle needs revision
      (if (equal (angle cpt strtpt) ang 0.01)   
        (progn
          ;; Start angle needs revision.
          (setq strt_a T
                rad1  (+ (dl_val 40 tmp) temp2) ; outer radius
                rad2  (- (dl_val 40 tmp) temp1) ; inner radius
          )
          (setq ent (subst (cons 40 rad2) ; modify its radius
                           (assoc 40 ent) 
                           ent))
          (entmod ent) 
          (dl_atl)                    ; Add ename to list
          (setq save_1 ent)
          (setq sent1 (dl_val -1 tmp))                            
          (if (= flg 4)
            (if (> uctr 2)
              (dl_das 0 rad2 50)      ; modify arc endpt and close
            )
            (dl_das nil rad2 50)      ; else modify arc endpt
          )
          ;; Create the "parallel" arc
          (command "_.OFFSET" (getvar "tracewid") ; offset the arc
                              (list tmp '(0 0 0)) 
                              (polar cpt ang (+ 1 rad1 rad2))
                              "")
          (setq tmp (entlast)         ; get the offset arc
                ent  (entget tmp))
          (dl_atl)                    ; Add ename to list
          (setq save_2 ent)
          (setq sent2 tmp) 
          (if (= flg 4)
            (if (> uctr 3)
              (progn
                (dl_das 1 rad1 50)    ; modify arc endpt and close

                ;; set nextpt to "CLose" which will cause an exit.
                (setq nextpt "CLose"
                      v:stpt nil
                      cont   nil
                )
              )
            )
            (dl_das nil rad1 50)      ; else modify arc endpt
          )

        )
        (progn                        ; if end angle needs revision
          ;; End angle needs revision.
          (setq strt_a nil
                rad1  (+ (dl_val 40 tmp) temp1) ; outer radius
                rad2  (- (dl_val 40 tmp) temp2) ; inner radius
          )
          (setq ent (subst (cons 40 rad1) ; modify its radius
                           (assoc 40 ent) 
                           ent))
          (entmod ent)                             
          (dl_atl)                    ; Add ename to list
          (setq save_1 ent)
          (setq sent1 (dl_val -1 tmp))                            
          (if (= flg 4)
            (if (> uctr 2)
              (dl_das 0 rad1 51)      ; modify arc endpt and close
            )
            (dl_das nil rad1 51)      ; else modify arc endpt
          )
          ;; Create the "parallel" arc
          (command "_.OFFSET" (getvar "tracewid")    
                            (list tmp '(0 0 0)) 
                            cpt 
                            "")
          (setq tmp (entlast)         ; get the last arc entity
                ent  (entget tmp))
          (dl_atl)                    ; Add ename to list
          (setq save_2 ent)
          (setq sent2 tmp)
          (if (= flg 4)
            (if (> uctr 3)
              (progn
                (dl_das 1 rad2 51)    ; modify arc endpt and close

                ;; set nextpt to "CLose" which will cause an exit.
                (setq nextpt "CLose"
                      v:stpt nil
                      cont   nil
                )
              )
            )
            (dl_das nil rad2 51)      ; else modify arc endpt
          )
        )
      )

    )
    ((= flg 3)                        ; if straight closing
      (setq nextpt (nth 0 spts)
            ang1   (+ (angle strtpt nextpt) (/ pi 2))
            ang2   (- (angle strtpt nextpt) (/ pi 2))
      )
      (dl_dls 0 ang1 temp1)
      (dl_dls 1 ang2 temp2)

      ;; set nextpt to "CLose" which will cause an exit.
      (setq nextpt "CLose"
            v:stpt nil
            cont   nil
      )
    )
    (T
      (princ "\nERROR:  Value out of range. ")
      (exit)
    )
  )
  (setq strtpt nextpt   
        spts   (append spts (list strtpt))
        savpts (append savpts (list savpt3))
        savpts (append savpts (list savpt4))
  )
  (command "_.UNDO" "_E")                ; only end when DLINE's have been drawn
)
;;; ------------------- End Support Functions -----------------------
;;; ---------------- Begin Line Drawing Functions -------------------
;;;
;;; Straight DLINE function
;;;
;;; dl_dls == DLine_Draw_Line_Segment
;;;
(defun dl_dls (flgn ang temp / j k pt1 pt2 tmp1 ent1 p1 p2)

  (mapcar                             ; get endpoints of the offset line
    '(lambda (j k)
       (set j (polar (eval k) ang temp))
     )      
     '(pt1 pt2)
     '(strtpt nextpt)
  )
  (cond
    ((= uctr 0)
      ;; Set points 1 and 2 for segment 1.
      (setq p1 (if (dl_l01 brk_e1 "1" pt1 pt2 strtpt) ipt savpt1)) 
      (setq pt2 (if (dl_l01 brk_e2 "3" pt2 pt1 nextpt) ipt savpt3))
      (setq pt1 p1)
    )
    ((= uctr 1)
      ;; Set points 1 and 2 for segment 2.
      (setq p1 (if (dl_l01 brk_e1 "2" pt1 pt2 strtpt) ipt savpt2))
      (setq pt2 (if (dl_l01 brk_e2 "4" pt2 pt1 nextpt) ipt savpt4))
      (setq pt1 p1)
      
      ;; Now break the line or arc found at the start point 
      ;; if there is one, and we are in a breaking mood.
      (if (and dl:brk brk_e1)
        (progn
          (command "_.BREAK" brk_e1 savpt1 savpt2)
        )
      )
      ;; Now break the line or arc found at the end point 
      ;; if there is one, and we are in a breaking mood.
      (if (and dl:brk brk_e2)
        (progn
          (if (eq brk_e1 brk_e2)
            (progn
              ;; Delete first line so we can find the arc or line that
              ;; we found previously.
              (entdel (nth 0 wnames))  
              (dl_ved "brk_e2" nextpt)
              ;; Restore first line
              (entdel (nth 0 wnames))
            )
          )
          (command "_.BREAK" brk_e2 savpt3 savpt4)
        )
      )
      ;; Do not set brk_e2 nil... it will be set later.
    )
    ((= (rem uctr 2.0) 0)    
      (setq fang nil)
      (setq p1 (dl_dl2 pt1))          ; Draw line part 2
      (setq pt2 (if (dl_l01 brk_e2 "3" pt2 pt1 strtpt) 
                  ipt
                  savpt3
                )
      )
      (setq pt1 p1)
      (if flgn                        ; if closing
        (progn
          (setq tmp1 (nth flgn wnames)
                ent1 (entget tmp1)    ; get the corresponding prev. entity
          )
          (if (= (dl_val 0 tmp1) "LINE")
            ;; if it's a line
            (setq pt2 (dl_mls nil 10))           
            ;; if it's an arc
            (setq pt2 (dl_mas T nil pt2 pt1 nil))  
          )
        )                             
      )
    )
    (T
      (setq p1 (dl_dl2 pt1))              ; Draw line part 2
      (setq pt2 (if (dl_l01 brk_e2 "4" pt2 pt1 nextpt) 
                  ipt
                  savpt4
                )
      )
      (setq pt1 p1)
      (if flgn                        ; if closing
        (progn
          (setq tmp1 (nth flgn wnames)
                ent1 (entget tmp1)    ; get the corresponding prev. entity
                brk_e1 nil
                brk_e2 nil
          )
          (if (= (dl_val 0 tmp1) "LINE")
            ;; if it's a line
            (setq pt2 (dl_mls nil 10))           
            ;; if it's an arc
            (setq pt2 (dl_mas T nil pt2 pt1 nil))  
          )
        )                             
      )
      ;; Now break the line or arc found at the end point 
      ;; if there is one, and we are in a breaking mood.
      (if (and dl:brk brk_e2)
        (progn
          (command "_.BREAK" brk_e2 savpt3 savpt4)
        )
      )
      ;; Do not set brk_e2 nil... it will be set later.
    )
  )
  (command "_.LINE" pt1 pt2 "")         ; draw the line
  (setq wnames (if (null wnames) 
                 (list (setq elast (entlast)) )
                 (append wnames (list (setq elast (entlast)))))
        uctr   (1+ uctr)
  )
  wnames
)
;;;
;;; Set pt1 or pt2 based on whether there is an arc or line to be broken.
;;;
;;; dl_l01 == DLine_draw_Lines_0_and_1
;;;
(defun dl_l01 (bent1 n p1 p2 pt / temp)
  (setq n (strcat "savpt" n))
  (setq spt nil)
  (if bent1
    (if (= (dl_val 0 bent1) "LINE")
      (progn
        (setq temp (inters (trans (dl_val 10 bent1) 0 1)
                            (trans (dl_val 11 bent1) 0 1)
                            p1
                            p2
                            nil
                    )
        ) 
        (if temp
          (set (read n) temp)
          (progn
            (set (read n) p1)
            (setq brk_e1 nil)
          )
        )
      )
      (progn
        (set (read n) (dl_ial bent1 p1 p2 pt))
        ;; Spt is set only if there was no intersection point.
        (if spt
          (progn
            (setq ipt (eval (read n)))
            (set (read n) spt)
          )
        )
      )
    )
    (set (read n) p1)
  )
  (if spt
    T
    nil
  )
)
;;;
;;; Do more of the line drawing stuff.  This is where we call the modify 
;;; functions for the previous arc or line segment.  The line end being
;;; modified is always the group 11 end, but we have to test the start
;;; and end angle of an arc to tell which end to modify.
;;;
;;; dl_dl2 == DLine_Draw_Line_segment_part_2
;;;
(defun dl_dl2 (npt)
  (setq tmp1 (nth (- uctr 2) wnames)
        ent1 (entget tmp1))           ; get the corresponding prev. entity
   
  (if (= (dl_val 0 tmp1) "LINE")  
    ;; Check angles 0 180, -180  and 360...   
    (if (or  (equal (angle strtpt nextpt)
                   (angle (trans (dl_val 10 tmp1) 0 1)
                          (trans (dl_val 11 tmp1) 0 1)) 0.001)
             (equal (angle strtpt nextpt)
                   (angle (trans (dl_val 11 tmp1) 0 1)
                          (trans (dl_val 10 tmp1) 0 1)) 0.001)
             (equal (+ (* 2 pi) (angle strtpt nextpt))
                   (angle (trans (dl_val 10 tmp1) 0 1)
                          (trans (dl_val 11 tmp1) 0 1)) 0.001)
        )
      ;; if it's a line
      (progn
        (setq brk_e2 nil)
        (command "_.LINE" (trans (dl_val 11 tmp1) 0 1) pt1 "") 
        pt1 
      )
      ;; else, if it's an arc
      (progn
        (dl_mls nil 11)
      )
    )
    ;; if it's an arc
    (dl_mas nil nil pt1 pt2 strtpt)  
  )
)
;;;
;;; Modify line endpoint
;;;
;;; dl_mls == DLine_Modify_Line_Segment
;;;
(defun dl_mls (flg2 nn / spt ept pt)  ; flg2 = nil if line to line
                                      ;      = T   if line to arc

  ;; This is the previous entity; a line
  (setq spt (trans (dl_val 10 tmp1) 0 1)   
        ept (trans (dl_val 11 tmp1) 0 1)
  )
  (if flg2
    ;; find intersection with arc; tmp == ename of arc
    (progn
      ;; Find arc intersection with line; tmp == ename of arc.
      (setq pt (dl_ial tmp spt ept (if flgn nextpt strtpt)))
    )

    ;; find intersection with line
    (setq pt (inters spt ept pt1 pt2 nil)) 
  )
  ;; modify the previous line
  (if pt 
    (entmod (subst (cons nn (trans pt 1 0)) 
                   (assoc nn ent1) 
                   ent1))
    (setq pt pt2)
  )
  pt
)
;;; 
;;; This routine does a variety of tasks: it calculate the distance from
;;; the center of the arc (or congruent circle) to a line, then it
;;; calculates up to two intersection points of a line and the arc,
;;; then it attempts to determine which of the points serves as a 
;;; best-fit to the following criteria:
;;; 
;;;   1) One end of the arc must lie "on" the line, or
;;;      one end of the line must lie on the arc. 
;;;   2) Given that the point given in 1 above is p1,
;;;      and that the other point is p2, then if the arc crosses over
;;;      the line then use p2, otherwise the arc does not cross over
;;;      the line so use p1.
;;;      
;;; If the line and the arc do not intersect, then a line will be drawn
;;; from the point of intersection of the arc and the perpendicular from
;;; the line to the arc centerpoint, and the line;  The line and arc will be 
;;; trimmed or extended as needed to meet these points.
;;; 
;;; If the line and arc are tangent, then the arc and line are
;;; trimmed/extended to this point. 
;;;
;;; p1 and p2 are two points on a line
;;; ename  == entity name of arc
;;; flg == T when the segment being drawn ends on an arc, 
;;; flg == nil when the segment being drawn starts on an arc.
;;;
;;; dl_ial == DLine_Intersect_Arc_with_Line
;;;
(defun dl_ial (arc pt_1 pt_2 npt / d pi2 rad ang nang temp ipt)

  (setq cpt  (trans (dl_val 10 arc) (dl_val -1 arc) 1)  
        pi2  (/ pi 2)                 ; 1/2 pi
        ang  (angle pt_1 pt_2)                   
        nang (+ ang pi2)              ; Normal to "ang"
        temp (inters pt_1 pt_2 cpt (polar cpt nang 1) nil)
        nang (angle cpt temp)
  )
  ;; Get the perpendicular distance from the center of the arc to the line.
  (setq d (distance cpt temp))

  (cond
    ((equal (setq rad (dl_val 40 arc)) d 0.01)
      ;; One intersection.
      (setq ipt temp)
    )
    ((< rad d)                       
      ;; No intersection.
      (setq spt (polar cpt nang rad)
            ipt temp
      )
      (command "_.LINE" spt ipt "")
      ipt
    )
    (T
      ;; Two intersections. Now...
      ;; If drawing arcs, fang is set, we're past the first segment...
      ;; Reset the `near' point based on the previous ipt.  This can be
      ;; quite different and necessary from the `npt' passed in.
      (if (and dl_arc fang (> uctr 1)) 
        (setq npt (polar cpt fang rad))
      )
      (dl_g2p npt)
      (setq ipt (dl_bp arc pt_1 pt_2 ipt1 ipt2))
      ;; If `fang' is not set, set it, otherwise set it to nil.
      (if fang 
        (setq fang nil)
        (if dl_arc (setq fang (angle cpt ipt)))
      )
      ipt
    )
  )
)
;;;
;;; Get two intersection points, ordering them such that ipt1
;;; is the closer of the two points to the passed-in point "npt".
;;;
;;; dl_g2p == DLine_Get_2_Points
;;;
(defun dl_g2p (npt / temp l theta)
  (if (equal d 0.0 0.01)
    (setq theta pi2
          nang (+ ang pi2)            ; Normal to "ang"
    )
    (setq l     (sqrt (abs (- (expt rad 2) (expt d 2))))
          theta (abs (atan (/ l d)))
    )
  )
  ;; Get the two angles to the infinite intersection points of the 
  ;; congruent circle to the arc, and the line, then get the two 
  ;; intersection points.
  (setq ipt1 (polar cpt (- nang theta) rad))
  (setq ipt2 (polar cpt (+ nang theta) rad))
  ;; Set the closer of the two points to npt to be ipt1.
  (if (< (distance ipt2 npt) (distance ipt1 npt))
    ;; Swap points
    (setq temp ipt1
          ipt1 ipt2
          ipt2 temp
    )
    (if (equal (distance ipt2 npt) (distance ipt1 npt) 0.01)
      (exit)
    )
  )
  ipt1
)
;;;
;;; Test a point `pt' to see if it is on the line `sp--ep'.
;;;
;;; dl_onl == DLine_ON_Line_segment
;;;
(defun dl_onl (sp ep pt / cpt sa ea ang)
  (if (inters sp ep pt
              (polar pt (+ (angle sp ep) (/ pi 2))
                     (/ (getvar "tracewid") 10)
              )
              T)
    T 
    nil
  )
)
;;;
;;; Test a point `pt' to see if it is on the arc `arc'.
;;;
;;; dl_ona == DLine_ON_Arc_segment
;;;
(defun dl_ona (arc pt / cpt sa ea ang)
  (setq cpt (trans (dl_val 10 arc) (dl_val -1 arc) 1) 
        sa  (dl_val 50 arc)           ; angle of current ent start point
        ea  (dl_val 51 arc)           ; angle of current ent end point
        ang (angle cpt pt)            ; angle to pt.
  )
  (if (> sa ea)
    (if (or (and (> ang sa) (< ang (+ ea (* 2 pi))))
            (and (> ang (- ea (* 2 pi))) (< ang ea))
        ) 
      T 
      nil
    )
    (if (and (> ang sa) (< ang ea)) T nil)
  )
)
;;;
;;; Get the best intersection point of an arc and a line.  The criteria
;;; are as follows:
;;; 
;;;   1) The best point will lie on both the arc and the line.
;;;   2) It will be the point which causes the shortest arc to be created
;;;      such that (1) is satisfied.
;;;   3) If closing, then always use the point closest to nextpt.  Unless,
;;;      the points are equidistant, then use 1 and 2 above to tiebreak.
;;;   4) If breaking an arc with a line, always use the points nearest the
;;;      break point.
;;;
;;; dl_bp == DLine_Best_Point_of_arc_and_line
;;;
(defun dl_bp (en1 p1 p2 pp1 pp2 / temp temp1 temp2)
  (setq temp1 (dl_onl p1 p2 pp2)
        temp2 (dl_ona en1 pp2)
        temp  (if (or (= flg 1) (= flg 3)) T nil)
  )
  (if (and temp1 temp2)
    (if (and (< uctr 2) 
             (and brk_e1 brk_e2))
      pp1
      (if (and temp (not fang)) pp1 pp2)
    )
    pp1
  )
)
;;; ----------------- End Line Drawing Functions --------------------
;;; ---------------- Begin Arc  Drawing Functions -------------------
;;;
;;; Draw curved DLINE
;;;
;;; dl_das == DLine_Draw_Arc_Segment
;;;
(defun dl_das (flgn orad nn / tmp1 ent1 pt ang )
  (cond
    ((= uctr 0)
      (setq sent1 tmp)
      (dl_a01 brk_e1 "1" strtpt nil)  ; DLine_draw_Arc_0_and_1
      (dl_a01 brk_e2 "3" nextpt T)    ; DLine_draw_Arc_0_and_1
    )
    ((= uctr 1)
      (setq sent1 tmp)
      (dl_a01 brk_e1 "2" strtpt nil)  ; DLine_draw_Arc_0_and_1
      (dl_a01 brk_e2 "4" nextpt T)    ; DLine_draw_Arc_0_and_1
      (dl_mae nil T)
      (dl_mae nil nil)
      ;; Now break the line or arc found at the start point
      ;; if there is one, and we are in a breaking mood.
      (if (and dl:brk brk_e1)
        (progn
          (dl_mae T T)
          (dl_mae T nil)
          (command "_.BREAK" brk_e1 savpt1 savpt2)
        )
      )
      ;; Do not set brk_e1 nil... it will be set later.
      ;; Now break the line or arc found at the end point 
      ;; if there is one, and we are in a breaking mood.
      (if (and dl:brk brk_e2)
        (progn
          (if (eq brk_e1 brk_e2)
            (progn
              ;; Delete both arcs so we can find the arc or line that
              ;; we found previously.
              (entdel (nth 0 wnames))  
              (entdel (nth 1 wnames))  
              (dl_ved "brk_e2" nextpt)
              ;; Restore first line
              (entdel (nth 0 wnames))
              (entdel (nth 1 wnames))
            )
          )
          (if (null brk_e1)
            (progn
              (dl_mae T T)
              (dl_mae T nil)
            )
          )
          (command "_.BREAK" brk_e2 savpt3 savpt4)
        )
      )
      ;; Do not set brk_e2 nil... it will be set later.
    )
    ((= (rem uctr 2.0) 0) 
      (setq fang nil)
      (dl_da2)                        ; Draw arc part 2
      (if fang 
        (setq ftmp fang
              fang nil
        )
      )
      (setq save_1 ent)
      (setq sent1 (cdr(assoc -1 ent)))
      (setq pt2 (dl_a01 brk_e2 "3" nextpt T)) ; DLine_draw_Arc_0_and_1
      (if ftmp 
        (setq fang ftmp
              ftmp nil
        )
      )
    )
    (T
      (dl_da2)                        ; Draw arc part 2
      (if fang 
        (setq ftmp fang
              fang nil
        )
      )
      (setq save_2 ent)
      (setq sent1 (cdr(assoc -1 ent)))
      (setq pt2 (dl_a01 brk_e2 "4" nextpt T)) ; DLine_draw_Arc_0_and_1
      (if ftmp 
        (setq fang fang
              ftmp nil
        )
      )

      ;; Now break the line or arc found at the end point 
      ;; if there is one, and we are in a breaking mood.
      (if (and dl:brk brk_e2)
        (progn
          (dl_mae T T)
          (dl_mae T nil)
          (command "_.BREAK" brk_e2 savpt3 savpt4)
        )
      )
      ;; Do not set brk_e2 nil... it will be set later.
    )
  )
  (setq uctr   (1+ uctr))
)
;;;
;;; Set pt1 or pt2 based on whether there is an arc or line to be broken.
;;;
;;; dl_a01 == DLine_draw_Arcs_0_and_1
;;;
(defun dl_a01 (bent1 n pt flg / pt1 pt2 ang1 ang2 anga angb)
  ;; "n" is the point to save for end capping
  (setq n (strcat "savpt" n))
  ;; "tmp" is the arc just created.
  ;; "bent1" is the line or arc to be broken, if there is one...
  (if bent1
    (if (= (dl_val 0 bent1) "LINE")
      (progn
        (set (read n) (dl_ial tmp (trans (dl_val 10 bent1) 0 1)
                                  (trans (dl_val 11 bent1) 0 1) pt)) 
      )
      (progn
        (setq curcpt (trans (dl_val 10 sent1) (dl_val -1 sent1) 1) 
              prvcpt (trans (dl_val 10 bent1) (dl_val -1 bent1) 1)
              pt1    (polar prvcpt (dl_val 50 bent1) (dl_val 40 bent1))
              pt2    (polar curcpt (dl_val nn sent1) (dl_val 40 sent1))
              ang1   (angle prvcpt pt1)
        )
        (if (not (equal ang1 (angle prvcpt strtpt) 0.01))
          (setq pt1  (polar prvcpt (dl_val 51 bent1) (dl_val 40 bent1))
                ang1 (angle prvcpt pt1)
                ang2 (angle curcpt pt2)
                anga (- ang1 ang2)
                angb (- ang2 ang1)
          )
        )
        (if (or (and (< anga 0.0872665)
                     (> anga -0.0872665))
                (and (< angb 0.0872665)
                     (> angb -0.0872665))
            )
          (progn
            (set (read n) pt)
            (if (= bent1 brk_e1) 
              (setq brk_e1 nil)
              (setq brk_e2 nil)
            )
          )
          (set (read n) (dl_iaa sent1 bent1 pt flg))
        )
      )
    )
    (progn
      (setq cpt (trans (dl_val 10 tmp) (dl_val -1 tmp) 1))
      (set (read n) (polar cpt (angle cpt pt) orad))
    )
  )
  (eval (read n))
)
;;;
;;; Do more of the arc drawing stuff.  This is where we call the modify 
;;; functions for the previous arc or line segment.  The line end being
;;; modified is always the group 11 end, but we have to test the start
;;; and end angle of an arc to tell which end to modify.
;;;
;;; dl_da2 == DLine_Draw_Arc_segment_part_2
;;;
(defun dl_da2 (/ pt)
  ;; get the corresponding previous entity
  (setq tmp1 (nth (- uctr 2) wnames) 
        ent1 (entget tmp1))
  (if (= (dl_val 0 tmp1) "LINE")     
    ;; if it's a line
    (setq pt (dl_mls T 11))             
    ;; if it's an arc
    (setq pt (dl_mas nil T nil nil strtpt)) 
  )
  ;; pt is a point in the current UCS, not ECS
  (if pt
    (progn
      (setq ang (- (angle cpt pt) ange))
      (entmod (setq ent (subst (cons nn ang) 
                       (assoc nn ent) 
                       ent)))         ; modify arc endpt
    )
  )
  (if flgn                            ; if closing 
    (progn
      (setq tmp1 (nth flgn wnames)     
            ent1  (entget tmp1))  ; get the flagged entity
      (if (= (dl_val 0 tmp1) "LINE")     
        ;; if it's a line
        (setq pt (dl_mls T 10))   
        ;; if it's an arc
        (setq pt (dl_mas T T nil nil nextpt)) 
      )
      (if pt
        (progn
          (setq ang (- (angle cpt pt) ange))
          (setq nn (if (= nn 50) 51 50))
          (entmod (setq ent (subst (cons nn ang) 
                         (assoc nn ent) 
                         ent)))       ; modify arc endpt
        )                             
      )
    )                             
  )
)
;;;
;;; Modify the endpoints of an arc by changing the start and end angles.
;;;
;;; dl_mae == DLine_Modify_Arc_Endpoints
;;;
(defun dl_mae (eflg sflg / nn1 nn2)
  (if (= nn 50)
    (setq nn1 50 nn2 51)
    (setq nn1 51 nn2 50)
  )
  (if sflg
    (if eflg
      (setq save_1 (subst (cons nn2 
                                (angle 
                                  (trans cpt    1 (cdr(assoc -1 save_1)))
                                  (trans savpt3 1 (cdr(assoc -1 save_1)))
                                )
                          )
                          (assoc nn2 save_1) save_1)
      )
      (setq save_1 (subst (cons nn1 
                                (angle 
                                  (trans cpt    1 (cdr(assoc -1 save_1)))
                                  (trans savpt1 1 (cdr(assoc -1 save_1)))
                                )
                          )
                          (assoc nn1 save_1) save_1)
      )
    )
    (if eflg
      (setq save_2 (subst (cons nn2 
                                (angle 
                                  (trans cpt    1 (cdr(assoc -1 save_1)))
                                  (trans savpt4 1 (cdr(assoc -1 save_2)))
                                )
                          )
                          (assoc nn2 save_2) save_2)
      )
      (setq save_2 (subst (cons nn1 
                                (angle 
                                  (trans cpt    1 (cdr(assoc -1 save_1)))
                                  (trans savpt2 1 (cdr(assoc -1 save_2)))
                                )
                          )
                          (assoc nn1 save_2) save_2)
      )
    )
  )
  (if sflg
    (entmod save_1)
    (entmod save_2)
  )
)
;;;
;;; Modify arc                        ; flg2 = nil if arc to line
;;;                                   ;      = T   if arc to arc
;;;
;;; dl_mas == DLine_Modify_Arc_Segment
;;;
(defun dl_mas (flg3 flg2 spt ept pt / nnn pt1 pt2 rad1 ange)
  ;; get some stuff
  (setq cpt1   (trans (dl_val 10 tmp1) (dl_val -1 tmp1) 1)           
        rad1   (dl_val 40 tmp1)
        ang1   (dl_val 50 tmp1)
  )
  (if (null pt)                       ; if a point is not passed in:
    (setq pt (nth 0 spts))            ; set to initial saved start point.
  )               
  (setq ange (trans '(1 0 0) (dl_val -1 tmp1) 1)
        ange (angle '(0 0 0) ange)
        ang1 (+ ang1 ange)
  )
  (if (> ang1 (* 2 pi))
    (setq ang1 (- ang1 (* 2 pi)))
  )
  (if (equal (angle cpt1 pt) ang1 0.01) ; figure out if we're looking
    (setq nnn 50)                     ; for the start or end point of
    (setq nnn 51)                     ; the beginning arc, then
  )                                   ; get the intersection point
  ;; if arc to arc
  (if flg2
    ;; then
    (progn
      ;; find intersection with arc
      (setq pt1 (dl_iaa tmp tmp1 (if flg3 nextpt strtpt) flg2))   
      (if pt1 
        (progn
          (setq ang1 (- (angle cpt1 pt1) ange))
          (setq ent1 (subst (cons nnn ang1) 
                            (assoc nnn ent1) 
                            ent1))                 
          (entmod ent1)               ; modify arc endpt
        )
      )
    )
    ;; else
    (progn 
      ;; find arc intersection with line from spt to ept
      (setq pt1 (dl_ial tmp1 spt ept pt)) 
      (setq ang1 (- (angle cpt1 pt1) ange))
      (setq ent1 (subst (cons nnn ang1) 
                        (assoc nnn ent1) 
                        ent1))                 
      (entmod ent1)                   ; modify arc endpt
    )
  )
  pt1
)
;;; ---------------- Begin Arc to Arc Functions ---------------------
;;;
;;; This routine does a variety of tasks: it calculate up to two 
;;; intersection points of two arcs,
;;; then it attempts to determine which of the points serves as a 
;;; best-fit to the following criteria:
;;; 
;;;   1) One end of the arc must lie "on" the arc. 
;;;   2) Given that the point given in 1 above is pt1,
;;;      and that the other point is pt2, then if the arc crosses over
;;;      the other arc then use pt2, otherwise the arc does not cross over
;;;      the other arc so use pt1.
;;;      
;;; If the two arcs do not intersect, then a line will be drawn
;;; from the point of intersection of the arc and the perpendicular from
;;; the line of the two arc centerpoints;  The arcs will be 
;;; trimmed or extended as needed to meet these points.
;;; 
;;; If the two arcs are tangent, then they are
;;; trimmed/extended to this point. 
;;;
;;; Intersection point of two arcs or circles
;;; a    = radius of ename 1
;;; b    = distance from curcpt to prvcpt
;;; c    = radius of ename 2
;;; curcpt = center point of first circle or arc  -- bent1, bent2, tmp
;;; prvcpt = center point of second circle or arc -- sent1, sent2, tmp1
;;; npt  = near point for nearest test
;;;
;;; dl_iaa == DLine_Intersect_Arc_and_Arc
;;;
(defun dl_iaa  (en1 en2 npt flga / a b c s ang alpha alph ipt 
                                   curcpt prvcpt temp temp1 temp2)
  (setq curcpt  (trans (dl_val 10 en1) (dl_val -1 en1) 1) ; the "last" entity
        prvcpt  (trans (dl_val 10 en2) (dl_val -1 en2) 1) ; the previous entity
        a       (dl_val 40 en2)
        b       (distance curcpt prvcpt)
        c       (dl_val 40 en1)
        s       (/ (+ a b c) 2.0)
        ang     (angle curcpt prvcpt)
  )
  (cond
    ;; circles are tangent
    ;; If (- s a) == 0, this would cause a divide by zero below...
    ((or (= (- s a) 0) (equal b (+ a c) 0.001) (equal b (abs (- a c)) 0.001))
      ;; Circles are tangent.
      (setq ipt nil)
    )
    ;; circles do not intersect
    ((and (or (> b (+ a c)) (if (> c a) (< (+ a b) c) (< (+ c b) a)))                 
          (not (equal (+ a b ) c (/ (+ a b c) 1000000))))
      ;; No intersection.
      (if (= flg 4) 
        (progn
          (setq ipt (polar curcpt (angle curcpt prvcpt) c))
          (command "_.LINE" (polar prvcpt (angle prvcpt ipt) a) ipt "")
        )
        (progn
          (setq ipt (polar curcpt (angle curcpt prvcpt) c))
          (command "_.LINE" (polar prvcpt (angle prvcpt ipt) a) ipt "")
        )
      )
    )
    (T
      ;; general law of cosines formula -- (- s a) != 0
      (setq alpha (* 2.0 (atan (sqrt (abs (/ (* (- s b) (- s c)) 
                                             (* s (- s a)))))))
      )
      
      (setq tpt1 (polar curcpt (+ ang alpha) c)
            tpt2 (polar curcpt (- ang alpha) c)
            anga  (angle curcpt npt)
            angb  (angle prvcpt npt)
      )
      ;; Two intersections. Now...
      ;; If drawing arcs, fang is set, we're past the first segment...
      ;; Reset the `near' point based on the previous ipt.  This can be
      ;; quite different and necessary from the `npt' passed in.
      (if (and dl_arc fang (> uctr 1)) 
        (setq npt (polar prvcpt fang c))
      )
      (if (< (distance tpt1 npt) (distance tpt2 npt))
        (setq temp tpt1
              tpt1 tpt2
              tpt2 temp
        )
      )
      (setq temp (angle prvcpt curcpt)) ; angle from prev ent to this ent
      (setq ipt (dl_bap en1 en2 tpt2 tpt1 nil))
      (if fang 
        (setq fang nil)
        (if dl_arc (setq fang (angle cpt ipt)))
      )
    )
  )
  (setq cpt curcpt)
  (setq cpt1 prvcpt)
  ipt                                 ; return point
)
;;;
;;; Get the best point for the arc/arc intersection.
;;;
;;; dl_bap == DLine_Best_Point_to_Arc
;;;
(defun dl_bap (en1 en2 pp1 pp2 flg / temp1 temp2)
  (setq temp1 (dl_ona en1 pp2)
        temp2 (dl_ona en2 pp2)
  )
  (if temp2
    (if (and (< uctr 2) 
             (and brk_e1 brk_e2))
      pp1
      (if temp1 
        (if (< uctr 2) 
          pp2
          (if (not fang) pp2 pp1)
        )
        pp1
      )
    )
    pp1
  )        
)
;;; ----------------- End Arc  Drawing Functions --------------------
;;; -------------------- Begin Misc Functions -----------------------
;;;
;;; Add the entity name to the list in wnames.
;;;
;;; dl_atl == DLine_Add_To_List
;;;
(defun dl_atl ()
  (setq wnames (if (null wnames) 
                 (list (entlast)) 
                 (append wnames (list tmp)))
  )
  wnames
)
;;;
;;; The value of the assoc number of <ename>
;;;
(defun dl_val (v temp)
  (cdr(assoc v (entget temp)))
)
;;;
;;; List stripper : strips the last "v" members from the list
;;;
(defun dl_lsu (lst v / m)
  (setq m 0 temp '())
  (repeat (- (length lst) v)
    (progn
      (setq temp (append temp (list (nth m lst))))
      (setq m (1+ m))
  ) )
  temp
)
;;;
;;; Bitwise DLINE endcap setting function.
;;;
(defun endcap ()
  (initget "Auto Both End None Start")
  (setq dl:ecp (getkword 
    "\nDraw which endcaps?  Both/End/None/Start/<Auto>: "))
  (cond
    ((= dl:ecp "None")
      (setq dl:ecp 0)
    )
    ((= dl:ecp "Start")
      (setq dl:ecp 1)
    )
    ((= dl:ecp "End")
      (setq dl:ecp 2)
    )
    ((= dl:ecp "Both")
      (setq dl:ecp 3)
    )
    (T  ; Auto
      (setq dl:ecp 4)
    )
  )
)
;;;
;;; Set these defaults when loading the routine.
;;;
(if (null dl:ecp) (setq dl:ecp 4))    ; default to auto endcaps
(if (null dl:snp) (setq dl:snp T))    ; default to snapping ON
(if (null dl:brk) (setq dl:brk T))    ; default to breaking ON
(if (null dl:osd) (setq dl:osd 0))    ; default to center alignment
;;;
;;; These are the c: functions.
;;;
(defun c:dl () (dline))
(defun c:dline () (dline))

(princ "  DLINE loaded.")
(princ)
