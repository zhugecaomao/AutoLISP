(vmon)
;
;
(defun C:TEXP(/ sset ssl cont sn fpt ent
                strg oes oesp esty ocs oesp csty vert high)
      (command "UNDO" "GROUP")
      (setq cmec (getvar "CMDECHO")
            cmex (getvar "EXPERT")
            ucsf (getvar "UCSFOLLOW")
            ucsi (getvar "UCSICON")
            elev (getvar "ELEVATION")
            insb (getvar "INSBASE")
            oerr *error*
            *error* nerr
      )
;     (setvar "CMDECHO" 0)
      (setvar "EXPERT" 4)
      (setvar "UCSFOLLOW" 0)
      (setvar "UCSICON" 0)
      (command "UCS" "S" "$TEXP"
               "UCS" "W"
      )
      (setvar "INSBASE" '(0 0 0))
      (princ "\nSelect text to explode :")
      (setq sset (ssget)
            ssl (sslength sset)
            cont ssl
            sn 0
            fpt (open "SUNEXP.LST" "w")
            oes ""
            oesp ""
            ocs ""
            ocsp ""
      )
      (if (null fpt)
          (progn
               (princ "\nFile open failure : SUNEXP.LST")
               (setq cont 0)
          )
      )
;
;     SEARCH SELECT SET FOR TEXT ENTITIES
;     WRITE TEXT STYLE,VERTICAL CODE,TEXT HIGH,TEXT STRING TO SUNEXP.LST
;
      (if (> cont 0) (princ "\nSearching text string ..."))
      (while (> cont 0)
         (setq ent (- ssl cont)
               ent (entget (ssname sset ent))
         )
         (if (= (cdr (assoc 0 ent)) "TEXT")
            (progn
               (setq sn (1+ sn)
                     strg (cdr (assoc 7 ent))
                     strg (tblsearch "STYLE" strg)
                     esty (cdr (assoc 3 strg))
                     csty (cdr (assoc 4 strg))
                     vert (boole 1 (cdr (assoc 70 strg)) 4)
                     strg (cdr (assoc 1 ent))
                     high (cdr (assoc 40 ent))
               )
               (if (= esty oes)
                (setq esty oesp)
                (if (not (null esty))
                  (setq oes esty
                        esty (strcat esty ".SHX")
                        esty (findfile esty)
                        oesp esty
                  )
                )
               )
               (if (= csty ocs)
                (setq csty ocsp)
                (if (not (null csty))
                  (setq ocs csty
                        csty (strcat csty ".SHX")
                        csty (findfile csty)
                        ocsp csty
                  )
                )
               )
               (if (= vert 4) (setq vert 1))
               (if (null esty) (write-line "" fpt) (write-line esty fpt))
               (if (null csty) (write-line "" fpt) (write-line csty fpt))
               (write-line (itoa vert) fpt)
               (write-line (rtos high 1 8) fpt) ; DO NOT CHANGE THE ACCURACY
               (write-line strg fpt)

            ); end progn of if

         ) ; end if text
         (setq cont (1- cont) )

      ) ; end while

      (if (not (null fpt)) (close fpt) )
;
;     SET UCS TO TEXT ENTITIES AND READ XPS*.DXB IN
;
      (if (> sn 0)
         (progn                ;ADD ONE LINE IN ACAD.PGP :
           (command "SunEXP")    ;SUNEXP,C:\SUNNEX\SUNEXP,75000,,4
                               ;EXPLODE TEXT BY SUNEXP.EXE
           (princ "\nReading DXB file ...")
           (setq cont ssl
                 sn 0
           )
           (while (> cont 0)
              (setq high (- ssl cont)
                    high (ssname sset high)
                    ent (entget high)
              )
              (if (= (cdr (assoc 0 ent)) "TEXT")
                (progn
                   (setq sn (1+ sn)
                       vert (strcat "000" (itoa sn))
                       strg (- (strlen vert) 3)
                        strg (substr vert strg 4)
                        strg (strcat "XPS" strg)
                  )


                   (command "UCS" "E" high)
                   (setq vert (caddr (getvar "INSBASE")) )
                   (setvar "ELEVATION" vert)
      (command "erase" "l" "")
                   (command "DXBIN" strg)

                ); end progn of if
              ) ; end if text
             (setq cont (1- cont) )

           ) ; end while

         ) ; end progn
      ) ; end if

      (reset)
      (prin1)
)
;
;     error handle
;
(defun nerr(st)
      (reset)
      (if (/= st "Function cancelled")
        (princ (strcat "\nError: " st))
      )
      (prin1)
)
(defun reset()
      (command "UCS" "R" "$TEXP"
               "UCS" "D" "$TEXP"
      )
      (setvar "CMDECHO" cmec)
      (setvar "EXPERT" cmex)
      (setvar "UCSFOLLOW" ucsf)
      (setvar "UCSICON" ucsi)
      (setvar "ELEVATION" elev)
      (setvar "INSBASE" insb)
      (setq *error* oerr)
      (command "UNDO" "END")
)
(prompt "\n        C:TEXP loaded.  Use TEXP to explode text string.")
(prin1)
