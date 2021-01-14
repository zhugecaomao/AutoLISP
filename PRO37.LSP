(DEFUN C:OP ()
     (SETVAR "CMDECHO" 0)
     (COMMAND "VSLIDE" "OP")
     (std-1)
     (SETQ XR18 (/ XR 18))
     (SETQ YR9 XR18)
      (SETQ PT1 (GETPOINT "\nPLEASE DIGIT THE CHAR. TABLE : "))
     (IF (NULL PT1) (SETQ JA 14) (PROGN
          (SETQ IA (FIX (/ (- (NTH 0 PT1) XI) XR18)))
          (SETQ JA (+ (FIX (/ (- (NTH 1 PT1) YI) YR9)) 1))
          (IF (= JA 1) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""
                    "" "" "OP25D" "" "" "OP25C" "" ""
                    "OP25B" "" "" "OP25A" ))))
          (IF (= JA 2) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""
                    "" "" "OP22D" "" "" "OP22C" "" ""
                    "OP22B" "" "" "OP22A" ))))
          (IF (= JA 3) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""
                    "" "" "OP20D" "" "" "OP20C" "" ""
                    "OP20B" "" "" "OP20A" ))))
          (IF (= JA 4) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""
                    "" "" "OP18D" "" "" "OP18C" "" ""
                    "OP18B" "" "" "OP18A" ))))
          (IF (= JA 5) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""
                    "" "" "OP16D" "" "" "OP16C" "" ""
                    "OP16B" "" "" "OP16A" ))))
          (IF (= JA 6) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""
                    "" "" "OP14D" "" "" "OP14C" "" ""
                    "OP14B" "" "" "OP14A" ))))
          (IF (= JA 7) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""
                    "" "" "OP12D" "" "" "OP12C" "" ""
                    "OP12B" "" "" "OP12A" ))))
          (IF (= JA 8) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""
                    "" "OP36D" "OP09D" "" "OP36C" "OP09C" "" "OP36B"
                    "OP09B" "" "OP36A" "OP09A" ))))
          (IF (= JA 9) (SETQ DS (NTH IA
              (LIST "" "" "" "" "" ""
                    "" "OP31D" "OP07D" "" "OP31C" "OP07C" "" "OP31B"
                    "OP07B" "" "OP31A" "OP07A" ))))
            (REDRAW)))
         (setq ds1 (substr ds 1 2))
         (IF (= ds1 "OP")(PROGN
           (SETQ PO (GETPOINT "\nInsert O-Ring Base Point :"))
           (COMMAND "INSERT" DS PO "" "" )))
)



