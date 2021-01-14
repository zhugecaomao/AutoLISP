(VMON)
defun c:SMC
;(IF (= (TYPE F1) 'FILE ) "YES"  (STOP))
;(IF (= (TYPE F2) 'FILE ) "YES" (STOP))
(SETQ P1 (GETPOINT "Insert Point:"))
(SETQ W1 P1)
(command "vslide" "TWO")
(setq a (getreal "\nEnter [A] size:"))
(setq b (getreal "\nEnter [B] size:"))
(setq c (getreal "\nEnter [C] size:"))
(setq d (getreal "\nEnter [D] size:"))
(setq e (getreal "\nEnter [E] size:"))
(setq f (getreal "\nEnter [F] size:"))
(setq g (getreal "\nEnter [G] size:"))
(setq h (getreal "\nEnter [H] size:"))
(setq i (getreal "\nEnter [I] size:"))
(setq j (getreal "\nEnter [J] size:"))
(setq k (getreal "\nEnter [K] size:"))
(setq l (getreal "\nEnter [L] size:"))
(setq m (getreal "\nEnter [M] size:"))
(setq gp (getSTRING "\nEnter Dia. of G.P.:"))
(setq rp (getSTRING "\nEnter Dia. of R.P.:"))
(setq mA (getSTRING "\nEnter Dia. of M1:"))
(setq mB (getSTRING "\nEnter Dia. of M2:"))

;(setq a 200)
;(setq b 150)
;(setq c 90)
;(setq d 28)
;(setq e 150)
;(setq f 132)
;(setq g 57)
;(setq h 55)
;(setq i 48)
;(setq j 72)
;(setq k 114)
;(setq l 120)
;(setq m 56)
;(setq gp 16)
;(setq rp 12)
;(setq mA 6)
;(setq mB 10)

(SETQ P2 (LIST (+ (CAR P1) A)(CADR P1)))
(SETQ P3 (LIST (CAR P2 ) (- (CADR P2) E)))
(SETQ P4 (LIST (- (CAR P3) A) (CADR P3)))
(SETQ P5 (LIST (/ (+ (CAR P1) (CAR P2)) 2) (+ (CADR P1) 10))) ;CENTER LINE UP
(SETQ P6 (LIST (/ (+ (CAR P3) (CAR P4)) 2) (- (CADR P4) 10)));CENTER LINE DOWN
(SETQ P7 (LIST (- (/ (+ (CAR P1) (CAR P4)) 2) 10) (/ (+ (CADR P1) (CADR P4)) 2)));CENTER LINE LEGT
(SETQ P8 (LIST (+ (/ (+ (CAR P2) (CAR P3)) 2) 10) (/ (+ (CADR P2) (CADR P3)) 2)));RIGHT
(COMMAND "LAYER" "S" "DRAW" "")
(COMMAND "LINE" P1 P2 P3 P4 "C")
(COMMAND "LAYER" "S"  "CENTER" "")
(COMMAND "LINE" P5 P6 "" "LINE" P7 P8 "") ;DRAW CENETR
(COMMAND "LAYER" "S"  "HIDDEN" "")
(COMMAND "LINE" (LIST (+ (CAR P5) (/ C 2))  (- (CADR P5) 10))
                (LIST (+ (CAR P6) (/ C 2))  (+ (CADR P6) 10)) "")
(COMMAND "LINE" (LIST (- (CAR P5) (/ C 2))  (- (CADR P5) 10))
                (LIST (- (CAR P6) (/ C 2))  (+ (CADR P6) 10)) "")
(COMMAND "LINE" (LIST (+ (CAR P5) (/ C 2) 2)  (- (CADR P5) 10))
                (LIST (+ (CAR P6) (/ C 2) 2)  (+ (CADR P6) 10)) "")
(COMMAND "LINE" (LIST (- (CAR P5) (/ C 2) 2)  (- (CADR P5) 10))
                (LIST (- (CAR P6) (/ C 2) 2)  (+ (CADR P6) 10)) "")
(SETQ SD (/ (- B C (* D 2)) 2))

;(COMMAND "LINE" (LIST (+ (CAR P5) (/ C 2))  (- (CADR P5) 10))
;                (LIST (+ (CAR P6) (/ C 2))  (+ (CADR P6) 10)) "")
;(COMMAND "LINE" (LIST (- (CAR P5) (/ C 2))  (- (CADR P5) 10))
;                (LIST (- (CAR P6) (/ C 2))  (+ (CADR P6) 10)) "")

(COMMAND "LAYER" "S"  "DRAW" "")
(COMMAND "LINE" (LIST (+ (CAR P5) (/ B 2))  (- (CADR P5) 10))
                (LIST (+ (CAR P6) (/ B 2))  (+ (CADR P6) 10)) "")
(COMMAND "LINE" (LIST (- (CAR P5) (/ B 2))  (- (CADR P5) 10))
                (LIST (- (CAR P6) (/ B 2))  (+ (CADR P6) 10)) "")
(SETQ D1 (/ (- A B) 2))
(SETQ D2 (+ (/ (- A B) 2 ) D))
(SETQ D3 (+ (/ (- A B) 2 ) D (/ (- B C  D D ) 2)))

(SETQ C4 (LIST (+ (CAR P6) (/ K 2)) (-(CADR P8) H))) ;G.P
(SETQ C3 (LIST (- (CAR P6) (/ K 2)) (-(CADR P8) G)))
(SETQ C2 (LIST (+ (CAR P5) (/ K 2)) (+(CADR P8) G)))
(SETQ C1 (LIST (- (CAR P5) (/ K 2)) (+(CADR P8) G)))
(SETQ M4 (LIST (+ (CAR P6) (/ j 2)) (- (CADR P8) (/ f 2) )))
(SETQ M3 (LIST (- (CAR P6) (/ j 2)) (- (CADR P7) (/ f 2) )))
(SETQ M2 (LIST (+ (CAR P5) (/ J 2)) (+ (CADR P8) (/ f 2) )))
(SETQ M1 (LIST (- (CAR P5) (/ J 2)) (+ (CADR P8) (/ f 2) )))
(SETQ Y4 (LIST (+ (CAR P6) (/ L 2)) (- (CADR P8) (/ m 2) )))
(SETQ Y3 (LIST (- (CAR P6) (/ L 2)) (- (CADR P7) (/ m 2) )))
(SETQ Y2 (LIST (+ (CAR P5) (/ L 2)) (+ (CADR P8) (/ m 2) )))
(SETQ Y1 (LIST (- (CAR P5) (/ L 2)) (+ (CADR P8) (/ m 2) )))
(SETQ R4 (LIST (+ (CAR P6) (/ i 2)) (- (CADR P8) G)))
(SETQ R3 (LIST (- (CAR P6) (/ i 2)) (- (CADR P8) G)))
(SETQ R2 (LIST (+ (CAR P5) (/ i 2)) (+ (CADR P8) G)))
(SETQ R1 (LIST (- (CAR P5) (/ i 2)) (+ (CADR P8) G)))

;(SETQ GP (ITOA GP))
(SETQ GP-1 (STRCAT "C:\\ACAD\\HON\\G\\G" GP "-1"))
(command "insert" GP-1 C4 1 1 0)
(command "insert" GP-1 C3 1 1 0)
(command "insert" GP-1 C2 1 1 0)
(command "insert" GP-1 C1 1 1 0)
;(SETQ RP (ITOA RP))
(SETQ RP-1 (STRCAT "C:\\ACAD\\HON\\R\\R" RP "-1"))
(command "insert" RP-1 R4 1 1 0)
(command "insert" RP-1 R3 1 1 0)
(command "insert" RP-1 R2 1 1 0)
(command "insert" RP-1 R1 1 1 0)

;(SETQ MA (ITOA MA))
(SETQ MA-1 (STRCAT "C:\\ACAD\\HON\\B\\BLT1-" MA))
(command "insert" MA-1 M4 1 1 0)
(command "insert" MA-1 M3 1 1 0)
(command "insert" MA-1 M2 1 1 0)
(command "insert" MA-1 M1 1 1 0)

;(SETQ MB (ITOA MB))
(SETQ MB-1 (STRCAT "C:\\ACAD\\HON\\B\\BLT1-" MB))
(command "insert" MB-1 Y4 1 1 0)
(command "insert" MB-1 Y3 1 1 0)
(command "insert" MB-1 Y2 1 1 0)
(command "insert" MB-1 Y1 1 1 0)

;(SETQ GP (ATOI GP))
;(SETQ RP (ATOI RP))
;(SETQ MA (ATOI MA))
;(SETQ MB (ATOI MB))




(COMMAND "LAYER" "S" "DRAW" "")
(COMMAND "VSLIDE" "FSC")
(setq n (getreal "\nEnter [N] size:"))
(setq o (getreal "\nEnter [O] size:"))
(setq p (getreal "\nEnter [P] size:"))
(setq q (getreal "\nEnter [Q] size:"))
(setq r (getreal "\nEnter [R] size:"))
(setq s (getreal "\nEnter [S] size:"))
(setq t (getreal "\nEnter [T] size:"))

;(setq n  20 )
;(setq o  35 )
;(setq p  35 )
;(setq q  50 )
;(setq r 13 )
;(setq s 15  )
;(setq t 10  )

 (SETQ T1 A1)


; 2ST PICTURE
;DRAW BOX
(SETQ P1 (LIST (CAR P1) (- (CADR P1) E 100)))  ;SECOND ORG P1
(SETQ Z1 P1)
(SETQ W2 P1)
(COMMAND "LINE" P1 (LIST (+ A (CAR P1)) (CADR P1)) (LIST (+ A (CAR P1)) ;1ST BOX
(- (CADR P1) N)) (LIST (CAR P1 ) (- (CADR P1) N )) P1 "")
;
(SETQ P1 (LIST (+ (CAR P1) (/ (- A B ) 2) ) (- (CADR P1 ) N))) ;2ND BO3
(COMMAND "LINE" (LIST (+ B (CAR P1)) (CADR P1))
(LIST (+ B (CAR P1)) (- (CADR P1 ) O))
(LIST (CAR P1) (- (CADR P1) O)) P1 "")
;
(SETQ P1 (LIST (CAR P1) (- (CADR P1 ) O) ))                   ;3ND BO3
(COMMAND "LINE" (LIST (+ B (CAR P1)) (CADR P1))
(LIST (+ B (CAR P1)) (- (CADR P1 ) P))
(LIST (CAR P1) (- (CADR P1) P)) P1 "")
;
(SETQ P1 (LIST (CAR P1) (- (CADR P1 ) P) ))                   ;4ND BOX
(COMMAND "LINE" (LIST (+ B (CAR P1)) (CADR P1))
(LIST (+ B (CAR P1)) (- (CADR P1 ) Q))
(LIST (CAR P1) (- (CADR P1) Q)) P1 "")


;LAST BOX
 (SETQ T1 (+ N O P Q ))
 (SETQ Q1 (LIST  (CAR Z1) (- (CADR Z1 ) T1)))
 (COMMAND "LINE" Q1 (LIST (+ (CAR Q1) A) (CADR Q1))
                   (LIST (+ (CAR Q1) A) (- (CADR Q1) N))
                   (LIST (CAR Q1)       (- (CADR Q1) N)) Q1 "")


;6ND BO3  INSIDE 1
(SETQ P1 (LIST (+ (CAR Z1) (+ D (/ (- A B) 2)) (/ (- B C D D ) 2))
               (+ (- (CADR Z1) N O P Q ) R S T)))
(COMMAND "LINE" P1 (LIST (+ C (CAR P1)) (CADR P1))
(LIST (+ C (CAR P1)) (- (CADR P1 ) R)) "")
(COMMAND "LINE" (LIST (CAR P1) (- (CADR P1) R)) P1 "")

;INSIDE 2
 (SETQ P1 (LIST (+ (CAR Z1) (+ D (/ (- A B) 2)) (/ (- B C D D ) 2))
                (+ (- (CADR Z1 ) N O P Q ) S T)))
 (COMMAND "LINE" P1 (LIST (+ C (CAR P1)) (CADR P1))
 (LIST (+ C (CAR P1)) (- (CADR P1 ) S))
 (LIST (CAR P1) (- (CADR P1) S)) P1 "")


;INSIDE 3
;(SETQ P1 (LIST (+ (CAR Z1) (+ D (/ (- A B) 2)) (/ (- B C D D ) 2))
;               (+ (- (CADR Z1 ) N O P Q ) T)))

(COMMAND "LAYER" "S" "CENTER" "")
(COMMAND "LINE" (LIST (+ (CAR Z1) (/ A 2)) (+ (CADR Z1) 10))
                (LIST (+ (CAR Z1) (/ A 2)) (- (CADR Z1) 10 N O P Q N)) "")

(COMMAND "LAYER" "S" "DRAW" "")
(SETQ P1 (LIST (+ (CAR Z1) (/ (- A E ) 2)) (- (CADR Z1) N O P )))
; TWO LINE
(SETQ I1 (LIST (CAR Z1) (- (CADR Z1) N O P )))
(SETQ I3 (LIST (-  (+ (CAR I1) A)  D (/ ( - A B) 2)) (CADR I1) ) )
(COMMAND "LINE" I3 (LIST (CAR I3) (- (CADR I3) Q)  ) "")

(SETQ I4 (LIST (+ (CAR I1) D (/ ( - A B) 2)) (CADR I1) ) )
(COMMAND "LINE" I4 (LIST (CAR I4) (- (CADR I4) Q)  ) "")



;THIRD PICTURE
(SETQ P1 (LIST (+ (CAR W1) 100 A) (CADR W1)))
(SETQ P2 (LIST (+ (CAR P1) A)(CADR P1)))
(SETQ P3 (LIST (CAR P2 ) (- (CADR P2) e)))
(SETQ P4 (LIST (- (CAR P3) A) (CADR P3)))
(SETQ P5 (LIST (/ (+ (CAR P1) (CAR P2)) 2) (+ (CADR P1) 10))) ;CENTER LINE UP
(SETQ P6 (LIST (/ (+ (CAR P3) (CAR P4)) 2) (- (CADR P4) 10)));CENTER LINE DOWN
(SETQ P7 (LIST (- (/ (+ (CAR P1) (CAR P4)) 2) 10) (/ (+ (CADR P1) (CADR P4)) 2)));CENTER LINE LEGT
(SETQ P8 (LIST (+ (/ (+ (CAR P2) (CAR P3)) 2) 10) (/ (+ (CADR P2) (CADR P3)) 2)));RIGHT
(COMMAND "LAYER" "S" "DRAW" "")
(COMMAND "LINE" P1 P2 P3 P4 "C")
(COMMAND "LAYER" "S"  "CENTER" "")
(COMMAND "LINE" P5 P6 "" "LINE" P7 P8 "") ;DRAW CENETR
(SETQ D1 (/ (- A B) 2))
(SETQ D2 (+ (/ (- A B) 2 ) D))
(SETQ D3 (+ (/ (- A B) 2 ) D (/ (- B C  D D ) 2)))
(COMMAND "LAYER" "S" "draw" "")
(COMMAND "LINE" (LIST (+ (CAR P5) (/ B 2)) (- (CADR P5) 10)) ;DRAW CENETR RIGTH
                (LIST (+ (CAR P6) (/ B 2)) (+ (CADR P6) 10)) "")
(COMMAND "LINE" (LIST (- (CAR P5) (/ B 2)) (- (CADR P5) 10)) ;DRAW CENETR RIGTH
                (LIST (- (CAR P6) (/ B 2)) (+ (CADR P6) 10)) "")


(COMMAND "LAYER" "S" "CENTER" "")
(SETQ T4 (LIST (+ (CAR C4 ) A 100) (CADR C3 )))
(SETQ T3 (LIST (+ (CAR C3 ) A 100) (CADR C4 )))
(SETQ T2 (LIST (+ (CAR C2 ) A 100) (CADR C1 )))
(SETQ T1 (LIST (+ (CAR C1 ) A 100) (CADR C2 )))
(SETQ Y4 (LIST (+ (CAR Y4 ) A 100) (CADR Y4 )))
(SETQ Y3 (LIST (+ (CAR Y3 ) A 100) (CADR Y3 )))
(SETQ Y2 (LIST (+ (CAR Y2 ) A 100) (CADR Y2 )))
(SETQ Y1 (LIST (+ (CAR Y1 ) A 100) (CADR Y1 )))


;(SETQ GP (ITOA GP))
(SETQ GP-2 (STRCAT "C:\\ACAD\\HON\\G\\G" GP "-1"))
(command "insert" GP-2 T3 1 1 0)
(command "insert" GP-2 T4 1 1 0)
(command "insert" GP-2 T1 1 1 0)
(command "insert" GP-2 T2 1 1 0)

;(SETQ MB (ITOA MB))
(SETQ MB-2 (STRCAT "C:\\ACAD\\HON\\B\\BLT1-" MB))
(command "insert" MB-2 Y4 1 1 0)
(command "insert" MB-2 Y3 1 1 0)
(command "insert" MB-2 Y2 1 1 0)
(command "insert" MB-2 Y1 1 1 0)



;FOURTH PICTURE
(COMMAND "LINE" (LIST (+ 100 A (/ E 2) (CAR Z1)) (+ (CADR Z1) 10))
                (LIST (+ 100 A (/ E 2) (CAR Z1)) (- (CADR Z1) 10 N O P Q  N)) "" )
;CENTER LINE
;
(COMMAND "LAYER" "S" "draw" "")
(COMMAND "LINE"
(LIST (+ 100 A (CAR Z1)) (CADR Z1))
(LIST (+ 100 A E (CAR Z1)) (CADR Z1))
(LIST (+ 100 A E (CAR Z1 ) ) (- (CADR Z1) N O P Q  N ))
(LIST (+ 100 A (CAR Z1 ) ) (- (CADR Z1) N O P Q N )) "C")


;HERE
(SETQ Z1 (LIST (+ 100 A (CAR Z1)) (CADR Z1)))
(COMMAND "LINE" (LIST (CAR Z1)       (- (CADR Z1) N))
                (LIST (+ (CAR Z1) E) (- (CADR Z1) N)) "")
(COMMAND "LINE" (LIST (CAR Z1)       (- (CADR Z1) (+ N O )))
                (LIST (+ (CAR Z1) E) (- (CADR Z1) (+ N O ))) "")
(COMMAND "LINE" (LIST (CAR Z1)       (- (CADR Z1) (+ N O P)))
                (LIST (+ (CAR Z1) E) (- (CADR Z1) (+ N O P))) "")


(COMMAND "LINE" (LIST (CAR Z1)       (- (CADR Z1) (+ N O P Q)))
                (LIST (+ (CAR Z1) E) (- (CADR Z1) (+ N O P Q))) "")

(COMMAND "MENU" "ACAD4")
