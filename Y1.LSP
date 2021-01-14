(DEFUN C:Y1()
  (SETQ Y1 (FINDFILE "C:/ACAD/HON/USER/Y1.SET"))
;===== WHEN NOT NIL =====MM SETTING=====
  (IF (/= Y1 NIL)
      (PROGN
      (SETQ FC (OPEN "C:/ACAD/HON/USER/Y1.SET" "r"))
      (SETQ #Y1 (READ-LINE FC))
      (IF (OR (= #Y1 "") (= #Y1 NIL))
          (CLOSE FC)
      )
      (IF (OR (= #Y1 "") (= #Y1 NIL))
         (PROGN
             (PROMPT"\nTABLET Y-1 LAYER:<DIM3>")
             (setq #Y1 (getSTRING))
             (IF (OR (= #Y1 "") (= #Y1 NIL))
                 (SETQ #Y1 "DIM3")
             )
;============WRITE TO FILE===================
             (SETQ FC (OPEN "C:/ACAD/HON/USER/Y1.SET" "w"))
             (WRITE-LINE #Y1 FC)
             (CLOSE FC)
             )
        )
      )
  )
;;=================END SETTING==========
;===== WHEN NIL SETING===========
  (IF (= Y1 NIL)
      (PROGN
         (SETQ FC (OPEN "C:/ACAD/HON/USER/Y1.SET" "w"))
         (WRITE-LINE "DIM3" FC)
         (CLOSE FC)
      )
  )
)
