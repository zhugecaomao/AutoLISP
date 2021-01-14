(VMON)
;-------------------------------------------------------------------
;MOVE & ROTATE
(DEFUN C:MOFRO (/ Q1 Q2 Q3)
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
  (SETQ Q1 (SSGET))
  (SETQ Q2 (GETPOINT "\nBase point:"))
  (SETQ Q3 (GETPOINT Q2 "\nNew base point:"))
  (COMMAND "MOVE" Q1 "" Q2 Q3)
  (COMMAND "ROTATE" Q1 "" Q3 PAUSE)
)
