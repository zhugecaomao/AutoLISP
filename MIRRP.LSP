(defun C:mirrp()
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
   (prompt "\nSelect entities to be mirror:")
   (COMMAND "SELECT" "AU" "\\")
   (setq s1 (ssget "P"))
   (SETQ P1 (GETPOINT"SELECT CENTER MIRROR POINT:"))
   (command "array" s1 "" "p" P1 2 "" "")
)
