;------------------------------------------------------------------------
;DIMENSION MISCELLANEOUS PART
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(DEFUN C:MISS (/ K1 K2 K3)
  (MENUCMD "S=MISS")
  (SETQ K2 (GETSTRING "\nSelect iterm  then  specification:"))
  (MENUCMD "S=NUM")
  (SETQ K3 (GETSTRING "\nSelect number or RETURN for none:"))
  (MENUCMD "S=S")
  (COMMAND "DIM" "LEADER" PAUSE PAUSE "" (STRCAT K3 K2))
)
;-----------------------------------------------------------------------
