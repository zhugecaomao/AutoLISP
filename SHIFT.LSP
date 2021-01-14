(defun C:shift()
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
   (command "color" 8 "line" Pd "perp" P1 "")
   (setq P11 (getvar "lastpoint"))
   (command "erase" Pd "" "line" Pd "perp" P2 "")
   (setq P22 (getvar "lastpoint"))
   (command "erase" Pd "" "break" P1 P1 "break" P2 P2)
   (setq P1 (osnap P1 "endp") P2 (osnap P2 "endp"))
   (command "color" "bylayer"
            "line" P1 (polar P1 (angle P11 Pd) Ofs) ""
            "line" P2 (polar P2 (angle P22 Pd) Ofs) ""
   )
   (while (not (null (setq S1 (entsel "\nSelect object to offset: "))))
      (setq l1 (entget (car S1)) P1 (cadr S1))
      (command "offset" Ofs P1 Pd "" "erase" P1 "")
   )
)
