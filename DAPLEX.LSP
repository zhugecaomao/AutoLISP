
(DEFUN C:DAPLEX ()
  (PROMPT "\n Select Object")
  (COMMAND "SELECT" "AU" "\\")
  (SETQ FIGC (SSGET "P"))
  (SETQ W (SSLENGTH FIGC))
    (SETQ IND 0)
    (REPEAT W
      (SETQ FIGG (ENTGET (SSNAME FIGC IND)))
      (SETQ PNA (CDR (ASSOC 0 FIGG)))
      (SETQ PN  (CDR (ASSOC -1 FIGG)))
      (IF (= PNA "POLYLINE")  (COMMAND "EXPLODE" PN) )

      (SETQ IND (+ IND 1))
    )
)
