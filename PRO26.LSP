(DEFUN C:LP ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "LP")
     (std-1)
     (SETQ XR18 (/ XR 18))
     (SETQ YR9 XR18)
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR18)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1));))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "" "" "" "LP55H" "" "" ""
                    "" "" "" "" "" "" ""
                    "" "" "" "" ))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "" "" "" "LP50H" "" "" ""
                    "" "" "" "" "" "" ""
                    "" "" "" "" ))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "LP60I" "LP60I" "" "LP48H" "LP60G" "LP60G" "LP60F"
                    "LP60F" "LP60E" "LP60E" "LP60D" "LP60D" "LP60C" "LP60C"
                    "LP60B" "LP60B" "LP60A" "LP60A" ))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "LP50I" "LP50I" "" "LP42H" "LP50G" "LP50G" "LP50F"
                    "LP50F" "LP50E" "LP50E" "LP50D" "LP50D" "LP50C" "LP50C"
                    "LP50B" "LP50B" "LP50A" "LP50A" ))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "LP40I" "LP40I" "" "LP40H" "LP40G" "LP40G" "LP40F"
                    "LP40F" "LP40E" "LP40E" "LP40D" "LP40D" "LP40C" "LP40C"
                    "LP40B" "LP40B" "LP40A" "LP40A" ))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "LP35I" "LP35I" "" "LP35H" "LP35G" "LP35G" "LP35F"
                    "LP35F" "LP35E" "LP35E" "LP35D" "LP35D" "LP35C" "LP35C"
                    "LP35B" "LP35B" "LP35A" "LP35A" ))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "LP30I" "LP30I" "LP80H" "LP30H" "LP30G" "LP30G" "LP30F"
                    "LP30F" "LP30E" "LP30E" "LP30D" "LP30D" "LP30C" "LP30C"
                    "LP30B" "LP30B" "LP30A" "LP30A" ))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "LP25I" "LP25I" "LP70H" "LP25H" "LP25G" "LP25G" "LP25F"
                    "LP25F" "LP25E" "LP25E" "LP25D" "LP25D" "LP25C" "LP25C"
                    "LP25B" "LP25B" "LP25A" "LP25A" ))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "LP20I" "LP20I" "LP60H" "LP20H" "LP20G" "LP20G" "LP20F"
                    "LP20F" "LP20E" "LP20E" "LP20D" "LP20D" "LP20C" "LP20C"
                    "LP20B" "LP20B" "LP20A" "LP20A" ))))
            (REDRAW)))
          (setq ds1 (substr ds 1 2))
         (IF (= ds1 "LP")(PROGN
           (SETQ PO (GETPOINT "\nInsert Leader Pin Base Point :"))
           (COMMAND "INSERT" DS PO "" "" )))
)
