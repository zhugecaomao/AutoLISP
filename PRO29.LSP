(DEFUN C:LSP ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "LSP")
     (std-1)
     (SETQ XR10 (/ XR 10))
     (SETQ YR13 (/ XR10 2.25))
     (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 10) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR10)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR13)) 1))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "MATCH3" "" "LPA" "UP" "" "" "" "" "" ""))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "MATCH2" "" "LP" "STD" "" "" "" "" "" ""))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "MATCH1" "" "KO" "ST" "" "" "" "" "" ""))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "INT" "" "K1" "SPP" "" "" "" "" "" ""))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "F" "" "GP" "SP" "" "" "" "" "" ""))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "EXT" "" "EP-2" "SE" "" "" "" "" "" ""))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "DIMSCL" "" "EP-1" "SCR" "" "" "" "" "" ""))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "DIMMM" "" "EJ" "SC" "" "" "" "" "" ""))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "DIMINCH" "CTEXT" "CP-2" "RL" "" "" "" "" "" ""))))
          (IF (= JA 10) (SETQ DS (NTH IA
              (LIST "CT" "TE" "CP" "PL" "MAK" "" "" "" "TL" "TL"))))
          (IF (= JA 11) (SETQ DS (NTH IA
              (LIST "CL" "OFFWL" "BUSH-B" "OP" "RETP" "" "SLDIM" "SLDIM" "FRLAY" "FRLAY"))))
          (IF (= JA 12) (SETQ DS (NTH IA
              (LIST "CLIP" "OF2" "BUSH-A" "NO" "WL" "" "VHDIME" "VHDIME" "FL" "FL"))))
          (IF (= JA 13) (SETQ DS (NTH IA
              (LIST "CBLOCK" "MTRIM" "BO" "LPB" "WE" "" "VHDIM" "VHDIM" "DL" "DL"))))
                ))
                (redraw)
   (if (= ds "BO")
       (if bo (c:bo)(progn (load "pro1")(c:bo)))
   )

   (if (= ds "BUSH-A")
   (if bush-a (c:bush-a)(progn (load "pro2")(c:bush-a))))

   (if (= ds "BUSH-B")
   (if bush-b (c:bush-b)(progn (load "pro3")(c:bush-b))))

   (if (= ds "CBLOCK")
   (if cblock (c:cblock)(progn (load "pro4")(c:cblock))))

   (if (= ds "CLIP")
   (if clip (c:clip)(progn (load "pro5")(c:clip))))

   (if (= ds "CL")
   (if cl (c:cl)(progn (load "pro6")(c:cl))))

   (if (= ds "CT")
   (if ct (c:ct)(progn (load "pro7")(c:ct))))

   (if (= ds "CP")
   (if cp (c:cp)(progn (load "pro8")(c:cp))))

   (if (= ds "CP-2")
   (if cp-2 (c:cp-2)(progn (load "pro9")(c:cp-2))))

   (if (= ds "CTEXT")
   (if ctext (c:ctext)(progn (load "pro10")(c:ctext))))

   (if (= ds "DIMINCH")
   (if diminch (c:diminch)(progn (load "pro11")(c:diminch))))

   (if (= ds "DIMMM")
   (if dimmm (c:dimmm)(progn (load "pro12")(c:dimmm))))

   (if (= ds "DIMSCL")
   (if dimscl (c:dimscl)(progn (load "pro13")(c:dimscl))))

   (if (= ds "DL")
   (if dl (c:dl)(progn (load "pro14")(c:dl))))

   (if (= ds "EJ")
   (if ej (c:ej)(progn (load "pro15")(c:ej))))

   (if (= ds "EP-1")
   (if ep-1 (c:ep-1)(progn (load "pro16")(c:ep-1))))

   (if (= ds "EP-2")
   (if ep-2 (c:ep-2)(progn (load "pro17")(c:ep-2))))

   (if (= ds "EXT")
   (if ext (c:ext)(progn (load "pro18")(c:ext))))

   (if (= ds "F")
   (if f (c:f)(progn (load "pro19")(c:f))))

   (if (= ds "FL")
   (if fl (c:fl)(progn (load "pro20")(c:fl))))

   (if (= ds "FRLAY")
   (if frlay (c:frlay)(progn (load "pro21")(c:frlay))))

   (if (= ds "GP")
   (if gp (c:gp)(progn (load "pro22")(c:gp))))

   (if (= ds "INT")
   (if int (c:int)(progn (load "pro23")(c:int))))

   (if (= ds "K1")
   (if k1 (c:k1)(progn (load "pro24")(c:k1))))

   (if (= ds "KO")
   (if ko (c:ko)(progn (load "pro25")(c:ko))))

   (if (= ds "LP")
   (if lp (c:lp)(progn (load "pro26")(c:lp))))

   (if (= ds "LPA")
   (if lpa (c:lp-a)(progn (load "pro27")(c:lp-a))))

   (if (= ds "LPB")
   (if lpb (c:lp-b)(progn (load "pro28")(c:lp-b))))

   (if (= ds "MAK")
   (if mak (c:mak)(progn (load "pro30")(c:mak))))

   (if (= ds "MATCH1")
   (if match1 (c:match1)(progn (load "pro58")(c:match1))))

   (if (= ds "MATCH2")
   (if match2 (c:match2)(progn (load "pro31")(c:match2))))

   (if (= ds "MATCH3")
   (if match3 (c:match3)(progn (load "pro32")(c:match3))))

   (if (= ds "MTRIM")
   (if mtrim (c:mtrim)(progn (load "pro33")(c:mtrim))))

   (if (= ds "NO")
   (if no (c:no)(progn (load "pro34")(c:no))))

   (if (= ds "OF2")
   (if of2 (c:of2)(progn (load "pro35")(c:of2))))

   (if (= ds "OFFWL")
   (if offwl (c:offwl)(progn (load "pro36")(c:offwl))))

   (if (= ds "OP")
   (if op (c:op)(progn (load "pro37")(c:op))))

   (if (= ds "PL")
   (if pl (c:pl)(progn (load "pro38")(c:pl))))

   (if (= ds "RL")
   (if rl (c:rl)(progn (load "pro39")(c:rl))))

   (if (= ds "RP")
   (if rp (c:rp)(progn (load "pro40")(c:rp))))

   (if (= ds "RETP")
   (if retp (c:retp)(progn (load "pro41")(c:retp))))

   (if (= ds "SC")
   (if sc (c:sc)(progn (load "pro42")(c:sc))))

   (if (= ds "SCR")
   (if scr (c:scr)(progn (load "pro43")(c:scr))))


   (if (= ds "SE")
   (if se (c:se)(progn (load "pro45")(c:se))))

   (if (= ds "SP")
   (if sp (c:sp)(progn (load "pro46")(c:sp))))

   (if (= ds "SPP")
   (if spp (c:spp)(progn (load "pro47")(c:spp))))

   (if (= ds "ST")
   (if st (c:st)(progn (load "pro48")(c:st))))

   (if (= ds "STD")
   (if st (c:std)(progn (load "pro49")(c:std))))


   (if (= ds "TE")
   (if te (c:te)(progn (load "pro50")(c:te))))

   (if (= ds "TL")
   (if tl (c:tl)(progn (load "pro51")(c:tl))))

   (if (= ds "UP")
   (if up (c:up)(progn (load "pro52")(c:up))))

   (if (= ds "VHDIM")
   (if vhdim (c:vhdim)(progn (load "pro53")(c:vhdim))))

   (if (= ds "VHDIME")
   (if vhdime (c:vhdime)(progn (load "pro54")(c:vhdime))))

   (if (= ds "SLDIM")
   (if sldim (c:sldim)(progn (load "pro55")(c:sldim))))

   (if (= ds "WE")
   (if we (c:we)(progn (load "pro56")(c:we))))

   (if (= ds "WL")
   (if wl (c:wl)(progn (load "pro57")(c:wl))))



)



