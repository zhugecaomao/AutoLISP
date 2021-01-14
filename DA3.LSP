;********* WRIT TEXT ON A SELECT CIRCLE  OR ARC *********
( defun c:da3    ()
; (IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
; (IF (= (TYPE F2) 'FILE ) "YES" (STOP))
          (GRAPHSCR)
;     ******* get data ********
    (SETQ DDD (GETSTRING "\n Do you need MIRROR TEXT <Y/N>?"))
    (SETQ DD (STRCASE DDD))
    (SETQ C1 (ENTGET (CAR (ENTSEL"\n Select a CIRCLE or ARC :"))))
                     (INITGET 1)
    (SETQ PS (getpoint "\nInput START point of text :"))
                (INITGET 1)
    (SETQ PE (getpoint "\nInput END  point of text:"))
                (INITGET (+ 1 2 4))
    (SETQ HI (getreal "\n Input the text height :"))
                (INITGET (+ 1 2 4))
    (SETQ DIS(getreal "\n Input the Distance between EDGE and TEXT :") )
                (INITGET 1)
    (SETQ TEXT1 (GETSTRING   "\n Input STRING :"))
    (setq CIRP (CDR (ASSOC 10 C1)) ) ;CIRCLE POINT
    (setq RADI (CDR (ASSOC 40 C1)) ) ;RADUIS
                ;compute
    (setq N (STRLEN TEXT1) )      ;TEXT NUMBER
    (setq RA   (+ radi dis) )
    (setq AGS (ANGLE CIRP PS ))   ;ANGLE  OF STAR POINT
    (setq AGE (ANGLE CIRP PE ))   ;ANGLE  OF END POINT
    (setq j (dtr 360)    )
    (setq Ts (- ags age )  )
;     ****** DESIDE SIDE  *******
    (if (< ts 0)
        (setq toang (+ ts j ) )
        (setq toang ts)
    )
    (SETQ VANG (/ TOANG  (+ 1 N)))
                ;writ text
    (SETQ M 1)
    (setq Z  (dtr 90 ))
    (REPEAT N
        (SETQ ANG  (- AGS   (* VANG M) ) )
        (SETQ PUT (POLAR CIRP  ANG RA  ))
        (SETQ PM1 (POLAR CIRP  ANG   (+ HI RA ) ))
        (SETQ T1 (SUBSTR  TEXT1 M 1))
        (setq rota (RTD (- ANG Z )))
        (COMMAND "TEXT" "C" PUT hi ROTA T1)
        (IF (= DD "Y")
          (COMMAND "MIRROR" "C" PUT PM1 ""  PUT PM1 "Y")
        )
        (SETq M (+ M 1))
    ));ENDREPEAT,ENDDEFUN
