(DEFUN C:INTEXT ()
(COMMAND "SETVAR" "HIGHLIGHT" "1")
(COMMAND "SETVAR" "CMDECHO" "0")
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(PROMPT "\nSelect delete text:")
(COMMAND "SELECT" "AU" "\\")
(SETQ SA (SSGET "P" ))                ;select entity
;(SETQ STR (GETSTRING "\Input new text: "))
(SETQ N (SSLENGTH SA))                ;LIST HOW MANY SELECT
(SETQ I 0)                            ;FIRST ENTITY
(SETQ LPT (GETVAR "LASTPOINT"))
(REPEAT N
   (SETQ NA (ENTGET (SSNAME SA I)))                    ;GET ENTITY NAME
   (SETQ I (+ 1 I))
   (SETQ NB (ASSOC 0 NA))
   (IF (= "TEXT" (CDR NB))
       (PROGN
          (SETQ TP (ASSOC 10 NA))
          (SETQ TP1 (CDR TP))                                ;(INSERT POINT)
          (SETQ TP2 (LIST (+ (CAR TP1) 3) (+ (CADR TP1) 3))) ;CATCA POINT
          (SETQ TP3 (LIST (+ (CAR TP1) 3) (- (CADR TP1) 3))) ;CATCH POINT
          (SETQ CTX (ASSOC 1 NA))
          (SETQ CTX (CDR CTX))                    ;OLD STRINGS
          (SETQ NM (STRLEN CTX))                  ;STRING LENGTH
          (COMMAND "DIST" TP1 LPT)                ;DIST INSER POINT & LASTPOINT
          (SETQ DT1 (GETVAR "DISTANCE"))
          (SETQ A (ASSOC 40 NA))                  ;
          (SETQ A (CDR A))                        ;TEXT HEIGHT
          (SETQ FT (/ DT1 A))                     ;HOW MUCH
          (SETQ FT (FIX FT))
          (SETQ FT (+ FT 1))
          (SETQ FTR (SUBSTR CTX FT 1))            ;GET SELECT STRING  IS
          (SETQ RP 1)
          (SETQ G "")
          (REPEAT NM
              (IF (/= RP FT)
                  (PROGN
                     (SETQ FTR1 (SUBSTR CTX RP 1))
                     (SETQ G (STRCAT G FTR1))
                  )
              )
              (IF (= RP FT)
                  (PROGN
                     (PROMPT"\nBe selected string is:")
                     (PRIN1 FTR)
                     (PROMPT"\n:")
                     (SETQ STR (GETSTRING "\Input insert text: "))
                     (SETQ G (STRCAT G STR FTR))
                  )

             )
              (SETQ RP (+ RP 1))
          )
       )
   )
   (SETQ NA (SUBST (CONS 1 G) (ASSOC 1 NA) NA))
   (ENTMOD NA)
)
)
