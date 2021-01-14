(DEFUN C:Y2()
  (SETQ Y2 (FINDFILE "C:/ACAD/HON/USER/Y2.SET"))
;===== WHEN NOT NIL =====MM SETTING=====
  (IF (/= Y2 NIL)
      (PROGN
      (SETQ FC (OPEN "C:/ACAD/HON/USER/Y2.SET" "r"))
      (SETQ #Y2 (READ-LINE FC))
      (IF (OR (= #Y2 "") (= #Y2 NIL))
          (CLOSE FC)
      )
      (IF (OR (= #Y2 "") (= #Y2 NIL))
         (PROGN
             (PROMPT"\nTABLET Y-2 LAYER:<DIM3>")
             (setq #Y2 (getSTRING))
             (IF (OR (= #Y2 "") (= #Y2 NIL))
                 (SETQ #Y2 "DIM3")
             )
;============WRITE TO FILE===================
             (SETQ FC (OPEN "C:/ACAD/HON/USER/Y2.SET" "w"))
             (WRITE-LINE #Y2 FC)
             (CLOSE FC)
             )
        )
      )
  )
;;=================END SETTING==========
;===== WHEN NIL SETING===========
  (IF (= Y2 NIL)
      (PROGN
         (SETQ FC (OPEN "C:/ACAD/HON/USER/Y2.SET" "w"))
         (WRITE-LINE "DIM3" FC)
         (CLOSE FC)
      )
  )
)
