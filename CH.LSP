(VMON)
(DEFUN C:CHWORD ()
(SETVAR "CMDECHO" 0)
(SETQ QJ (GETVAR "VIEWCTR"))                                  ;CETER OF PICTURE
(SETQ QM (/ (GETVAR "VIEWSIZE") 2))                           ;HALF HIGH OF PICTURE
(SETQ QQ (- (CADR (GETVAR "VSMAX")) (CADR (GETVAR "VSMIN")))) ;HIGH
(SETQ QN (- (CAR (GETVAR "VSMAX")) (CAR (GETVAR "VSMIN"))))   ;WIDTH
(SETQ QK (/ QQ QN))                                           ;SACLE H/W
(SETQ Q1 (/ QM QK))                                           ;SCALE OF AREA
(SETQ QG (LIST (- (CAR QJ) Q1) (- (CADR QJ) QM)))             ;LEFT RIGHT
(SETQ Q0 (/ (GETVAR "VIEWSIZE") 6) )                          ; 1/6 OF PICTURE
(SETQ QL (/ Q0 1 QK))                                         ;LENGTH OF WIDTH
(SETQ QO (GETPOINT "\nSelect one:"))                          ;SELECT POINT
(SETQ QH (- (CADR QO) (CADR QG)))
(SETQ QC (- (CAR QO) (CAR QG)))
(SETQ QEJ (FIX (/ QC QL)))
(SETQ QJJ (FIX (/ QH Q0)))
(REDRAW)
)
;-------------------------------------------------------------
(DEFUN PPL()
(SETQ PP (STRCAT "C:/TE/" PP))
(COMMAND "INSERT" PP PAUSE "" "" PAUSE)
(REDRAW)
)
;-------------------------------------------------------------
(DEFUN C:PAGE1 ()
(COMMAND "VSLIDE" "c:/acad/HON/SLD/CH1")
(C:CHWORD)
(COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "CH11")(PPL))
((AND(= QEJ 0)(= QJJ 4))(SETQ PP "CH12")(PPL))
((AND(= QEJ 0)(= QJJ 3))(SETQ PP "CH13")(PPL))
((AND(= QEJ 0)(= QJJ 2))(SETQ PP "CH16")(PPL))
((AND(= QEJ 0)(= QJJ 1))(SETQ PP "CH17")(PPL))
((AND(= QEJ 0)(= QJJ 0))(SETQ PP "CH14")(PPL))
((AND(= QEJ 1)(= QJJ 5))(SETQ PP "CH15")(PPL))
((AND(= QEJ 1)(= QJJ 4))(SETQ PP "C47")(PPL))
((AND(= QEJ 1)(= QJJ 3))(SETQ PP "C46")(PPL))
((AND(= QEJ 1)(= QJJ 2))(SETQ PP "C53")(PPL))
((AND(= QEJ 1)(= QJJ 1))(SETQ PP "C52")(PPL))
((AND(= QEJ 1)(= QJJ 0))(SETQ PP "C59")(PPL))
((AND(= QEJ 2)(= QJJ 5))(SETQ PP "C81")(PPL))
((AND(= QEJ 2)(= QJJ 4))(SETQ PP "C82")(PPL))
((AND(= QEJ 2)(= QJJ 3))(SETQ PP "C89")(PPL))
((AND(= QEJ 2)(= QJJ 2))(SETQ PP "T7")(PPL))
((AND(= QEJ 2)(= QJJ 1))(SETQ PP "C76")(PPL))
((AND(= QEJ 2)(= QJJ 0))(SETQ PP "C75")(PPL))
((AND(= QEJ 3)(= QJJ 5))(SETQ PP "T127")(PPL))
((AND(= QEJ 3)(= QJJ 4))(SETQ PP "C20"))
((AND(= QEJ 3)(= QJJ 3))(SETQ PP "C21"))
((AND(= QEJ 3)(= QJJ 2))(SETQ PP "C22"))
((AND(= QEJ 3)(= QJJ 1))(SETQ PP "C23"))
((AND(= QEJ 3)(= QJJ 0))(SETQ PP "C24"))
((AND(= QEJ 4)(= QJJ 5))(SETQ PP "C25"))
((AND(= QEJ 4)(= QJJ 4))(SETQ PP "C26"))
((AND(= QEJ 4)(= QJJ 3))(SETQ PP "C27"))
((AND(= QEJ 4)(= QJJ 2))(SETQ PP "C28"))
((AND(= QEJ 4)(= QJJ 1))(SETQ PP "C29"))
((AND(= QEJ 4)(= QJJ 0))(SETQ PP "C30"))
((AND(= QEJ 5)(= QJJ 5))(SETQ PP "C31"))
((AND(= QEJ 5)(= QJJ 4))(SETQ PP "C32"))
((AND(= QEJ 5)(= QJJ 3))(SETQ PP "C33"))
((AND(= QEJ 5)(= QJJ 2))(SETQ PP "C34"))
((AND(= QEJ 5)(= QJJ 1))(C:PAGE2))
((AND(= QEJ 5)(= QJJ 0))(COMMAND "CANCLE"))
)
(SETVAR "CMDECHO" 1)
)
;-------------------------------------------------------------
(DEFUN C:PAGE2 ()
(COMMAND "VSLIDE" "c:/acad/HON/SLD/CH2")
(C:CHWORD)
(COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "CH56")(PPL))
((AND(= QEJ 0)(= QJJ 4))(SETQ PP "CH57")(PPL))
((AND(= QEJ 0)(= QJJ 3))(SETQ PP "CH58")(PPL))
((AND(= QEJ 0)(= QJJ 2))(SETQ PP "CH25")(PPL))
((AND(= QEJ 0)(= QJJ 1))(SETQ PP "CH26")(PPL))
((AND(= QEJ 0)(= QJJ 0))(SETQ PP "CH33")(PPL))
((AND(= QEJ 1)(= QJJ 5))(SETQ PP "CH41")(PPL))
((AND(= QEJ 1)(= QJJ 4))(SETQ PP "CH61")(PPL))
((AND(= QEJ 1)(= QJJ 3))(SETQ PP "CH62")(PPL))
((AND(= QEJ 1)(= QJJ 2))(SETQ PP "CH32")(PPL))
((AND(= QEJ 1)(= QJJ 1))(SETQ PP "CH47")(PPL))
((AND(= QEJ 1)(= QJJ 0))(SETQ PP "CH73")(PPL))
((AND(= QEJ 2)(= QJJ 5))(SETQ PP "CH68")(PPL))
((AND(= QEJ 2)(= QJJ 4))(SETQ PP "CH71")(PPL))
((AND(= QEJ 2)(= QJJ 3))(SETQ PP "CH78")(PPL))
((AND(= QEJ 2)(= QJJ 2))(SETQ PP "C28")(PPL))
((AND(= QEJ 2)(= QJJ 1))(SETQ PP "CH72")(PPL))
((AND(= QEJ 2)(= QJJ 0))(SETQ PP "T60")(PPL))
((AND(= QEJ 3)(= QJJ 5))(SETQ PP "C78")(PPL))
((AND(= QEJ 3)(= QJJ 4))(SETQ PP "C85")(PPL))
((AND(= QEJ 3)(= QJJ 3))(SETQ PP "C15")(PPL))
((AND(= QEJ 3)(= QJJ 2))(SETQ PP "T131")(PPL))
((AND(= QEJ 3)(= QJJ 1))(SETQ PP "T139")(PPL))
((AND(= QEJ 3)(= QJJ 0))(SETQ PP "T132")(PPL))
((AND(= QEJ 4)(= QJJ 5))(SETQ PP "CH48")(PPL))
((AND(= QEJ 4)(= QJJ 4))(SETQ PP "T165")(PPL))
((AND(= QEJ 4)(= QJJ 3))(SETQ PP "C37")(PPL))
((AND(= QEJ 4)(= QJJ 2))(SETQ PP "C12")(PPL))
((AND(= QEJ 4)(= QJJ 1))(SETQ PP "T121")(PPL))
((AND(= QEJ 4)(= QJJ 0))(SETQ PP "T67")(PPL))
((AND(= QEJ 5)(= QJJ 5))(SETQ PP "T117")(PPL))
((AND(= QEJ 5)(= QJJ 4))(SETQ PP "T77")(PPL))
((AND(= QEJ 5)(= QJJ 3))(SETQ PP "T57")(PPL))
((AND(= QEJ 5)(= QJJ 2))(C:PAGE1))
((AND(= QEJ 5)(= QJJ 1))(C:PAGE3))
((AND(= QEJ 5)(= QJJ 0))(COMMAND "CANCLE"))
)
(SETVAR "CMDECHO" 1)
)
;-------------------------------------------------------------
(DEFUN C:PAGE3 ()
(COMMAND "VSLIDE" "c:/acad/HON/SLD/CH3")
(C:CHWORD)
(COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "T129")(PPL))
((AND(= QEJ 0)(= QJJ 4))(SETQ PP "T130")(PPL))
((AND(= QEJ 0)(= QJJ 3))(SETQ PP "T149")(PPL))
((AND(= QEJ 0)(= QJJ 2))(SETQ PP "T21")(PPL))
((AND(= QEJ 0)(= QJJ 1))(SETQ PP "T22")(PPL))
((AND(= QEJ 0)(= QJJ 0))(SETQ PP "T24")(PPL))
((AND(= QEJ 1)(= QJJ 5))(SETQ PP "T23")(PPL))
((AND(= QEJ 1)(= QJJ 4))(SETQ PP "C55")(PPL))
((AND(= QEJ 1)(= QJJ 3))(SETQ PP "T8")(PPL))
((AND(= QEJ 1)(= QJJ 2))(SETQ PP "C77")(PPL))
((AND(= QEJ 1)(= QJJ 1))(SETQ PP "C58")(PPL))
((AND(= QEJ 1)(= QJJ 0))(SETQ PP "C45")(PPL))
((AND(= QEJ 2)(= QJJ 5))(SETQ PP "T31")(PPL))
((AND(= QEJ 2)(= QJJ 4))(SETQ PP "C94")(PPL))
((AND(= QEJ 2)(= QJJ 3))(SETQ PP "T28")(PPL))
((AND(= QEJ 2)(= QJJ 2))(SETQ PP "T27")(PPL))
((AND(= QEJ 2)(= QJJ 1))(SETQ PP "T114")(PPL))
((AND(= QEJ 2)(= QJJ 0))(SETQ PP "T115")(PPL))
((AND(= QEJ 3)(= QJJ 5))(SETQ PP "T120")(PPL))
((AND(= QEJ 3)(= QJJ 4))(SETQ PP "C90")(PPL))
((AND(= QEJ 3)(= QJJ 3))(SETQ PP "C11")(PPL))
((AND(= QEJ 3)(= QJJ 2))(SETQ PP "C09")(PPL))
((AND(= QEJ 3)(= QJJ 1))(SETQ PP "C96")(PPL))
((AND(= QEJ 3)(= QJJ 0))(SETQ PP "C97")(PPL))
((AND(= QEJ 4)(= QJJ 5))(SETQ PP "C98")(PPL))
((AND(= QEJ 4)(= QJJ 4))(SETQ PP "C49")(PPL))
((AND(= QEJ 4)(= QJJ 3))(SETQ PP "C48")(PPL))
((AND(= QEJ 4)(= QJJ 2))(SETQ PP "C95")(PPL))
((AND(= QEJ 4)(= QJJ 1))(SETQ PP "C61")(PPL))
((AND(= QEJ 4)(= QJJ 0))(SETQ PP "T123")(PPL))
((AND(= QEJ 5)(= QJJ 5))(SETQ PP "C44")(PPL))
((AND(= QEJ 5)(= QJJ 4))(SETQ PP "T25")(PPL))
((AND(= QEJ 5)(= QJJ 3))(SETQ PP "C54")(PPL))
((AND(= QEJ 5)(= QJJ 2))(C:PAGE2))
((AND(= QEJ 5)(= QJJ 1))(C:PAGE4))
((AND(= QEJ 5)(= QJJ 0))(COMMAND "CANCLE"))
)
(SETVAR "CMDECHO" 1)
)
*-------------------------------------------------------------
(DEFUN C:PAGE4 ()
(COMMAND "VSLIDE" "c:/acad/HON/SLD/CH4")
(C:CHWORD)
(COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "T161")(PPL))
((AND(= QEJ 0)(= QJJ 4))(SETQ PP "T168")(PPL))
((AND(= QEJ 0)(= QJJ 3))(SETQ PP "T33")(PPL))
((AND(= QEJ 0)(= QJJ 2))(SETQ PP "T34")(PPL))
((AND(= QEJ 0)(= QJJ 1))(SETQ PP "T35")(PPL))
((AND(= QEJ 0)(= QJJ 0))(SETQ PP "T36")(PPL))

((AND(= QEJ 1)(= QJJ 5))(SETQ PP "C14")(PPL))
((AND(= QEJ 1)(= QJJ 4))(SETQ PP "C92")(PPL))
((AND(= QEJ 1)(= QJJ 3))(SETQ PP "C87")(PPL))
((AND(= QEJ 1)(= QJJ 2))(SETQ PP "C86")(PPL))
((AND(= QEJ 1)(= QJJ 1))(SETQ PP "T16")(PPL))
((AND(= QEJ 1)(= QJJ 0))(SETQ PP "C13")(PPL))

((AND(= QEJ 2)(= QJJ 5))(SETQ PP "T15")(PPL))
((AND(= QEJ 2)(= QJJ 4))(SETQ PP "CH18")(PPL))
((AND(= QEJ 2)(= QJJ 3))(SETQ PP "C10")(PPL))
((AND(= QEJ 2)(= QJJ 2))(SETQ PP "C70")(PPL))
((AND(= QEJ 2)(= QJJ 1))(SETQ PP "CH55")(PPL))
((AND(= QEJ 2)(= QJJ 0))(SETQ PP "C39")(PPL))

((AND(= QEJ 3)(= QJJ 5))(SETQ PP "T5")(PPL))
((AND(= QEJ 3)(= QJJ 4))(SETQ PP "T90")(PPL))
((AND(= QEJ 3)(= QJJ 3))(SETQ PP "C38")(PPL))
((AND(= QEJ 3)(= QJJ 2))(SETQ PP "C37")(PPL))
((AND(= QEJ 3)(= QJJ 1))(SETQ PP "CH35")(PPL))
((AND(= QEJ 3)(= QJJ 0))(SETQ PP "CH36")(PPL))

((AND(= QEJ 4)(= QJJ 5))(SETQ PP "CH22")(PPL))
((AND(= QEJ 4)(= QJJ 4))(SETQ PP "CH21")(PPL))
((AND(= QEJ 4)(= QJJ 3))(SETQ PP "CH38")(PPL))
((AND(= QEJ 4)(= QJJ 2))(SETQ PP "CH37")(PPL))
((AND(= QEJ 4)(= QJJ 1))(SETQ PP "CH27")(PPL))
((AND(= QEJ 4)(= QJJ 0))(SETQ PP "CH28")(PPL))
((AND(= QEJ 5)(= QJJ 5))(SETQ PP "CH31")(PPL))
((AND(= QEJ 5)(= QJJ 4))(SETQ PP "T154")(PPL))
((AND(= QEJ 5)(= QJJ 3))(SETQ PP "CH43")(PPL))
((AND(= QEJ 5)(= QJJ 2))(C:PAGE3))
((AND(= QEJ 5)(= QJJ 1))(C:PAGE5))
((AND(= QEJ 5)(= QJJ 0))(COMMAND "CANCLE"))
)
(SETVAR "CMDECHO" 1)
)
*-------------------------------------------------------------
(DEFUN C:PAGE5 ()
(COMMAND "VSLIDE" "c:/acad/HON/SLD/CH5")
(C:CHWORD)
(COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "T148")(PPL))
((AND(= QEJ 0)(= QJJ 4))(SETQ PP "C71")(PPL))
((AND(= QEJ 0)(= QJJ 3))(SETQ PP "C72")(PPL))
((AND(= QEJ 0)(= QJJ 2))(SETQ PP "T152")(PPL))
((AND(= QEJ 0)(= QJJ 1))(SETQ PP "CH74")(PPL))
((AND(= QEJ 0)(= QJJ 0))(SETQ PP "CH63")(PPL))

((AND(= QEJ 1)(= QJJ 5))(SETQ PP "T50")(PPL))
((AND(= QEJ 1)(= QJJ 4))(SETQ PP "CH65")(PPL))
((AND(= QEJ 1)(= QJJ 3))(SETQ PP "T66")(PPL))
((AND(= QEJ 1)(= QJJ 2))(SETQ PP "T64")(PPL))
((AND(= QEJ 1)(= QJJ 1))(SETQ PP "C29")(PPL))
((AND(= QEJ 1)(= QJJ 0))(SETQ PP "T76")(PPL))

((AND(= QEJ 2)(= QJJ 5))(SETQ PP "T59")(PPL))
((AND(= QEJ 2)(= QJJ 4))(SETQ PP "C08")(PPL))
((AND(= QEJ 2)(= QJJ 3))(SETQ PP "T80")(PPL))
((AND(= QEJ 2)(= QJJ 2))(SETQ PP "T133")(PPL))
((AND(= QEJ 2)(= QJJ 1))(SETQ PP "T49")(PPL))
((AND(= QEJ 2)(= QJJ 0))(SETQ PP "CH45")(PPL))

((AND(= QEJ 3)(= QJJ 5))(SETQ PP "T40")(PPL))
((AND(= QEJ 3)(= QJJ 4))(SETQ PP "T156")(PPL))
((AND(= QEJ 3)(= QJJ 3))(SETQ PP "T141")(PPL))
((AND(= QEJ 3)(= QJJ 2))(SETQ PP "T155")(PPL))
((AND(= QEJ 3)(= QJJ 1))(SETQ PP "CH44")(PPL))
((AND(= QEJ 3)(= QJJ 0))(SETQ PP "CH76")(PPL))

((AND(= QEJ 4)(= QJJ 5))(SETQ PP "CH66")(PPL))
((AND(= QEJ 4)(= QJJ 4))(SETQ PP "CH67")(PPL))
((AND(= QEJ 4)(= QJJ 3))(SETQ PP "T65")(PPL))
((AND(= QEJ 4)(= QJJ 2))(SETQ PP "T143")(PPL))
((AND(= QEJ 4)(= QJJ 1))(SETQ PP "T20")(PPL))
((AND(= QEJ 4)(= QJJ 0))(SETQ PP "C73")(PPL))
((AND(= QEJ 5)(= QJJ 5))(SETQ PP "C74")(PPL))
((AND(= QEJ 5)(= QJJ 4))(SETQ PP "C26")(PPL))
((AND(= QEJ 5)(= QJJ 3))(SETQ PP "T140")(PPL))
((AND(= QEJ 5)(= QJJ 2))(C:PAGE4))
((AND(= QEJ 5)(= QJJ 1))(C:PAGE6))
((AND(= QEJ 5)(= QJJ 0))(COMMAND "CANCLE"))
)
(SETVAR "CMDECHO" 1)
)
*-------------------------------------------------------------
*-------------------------------------------------------------
(DEFUN C:PAGE6 ()
(COMMAND "VSLIDE" "c:/acad/HON/SLD/CH6")
(C:CHWORD)
(COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "T61")(PPL))
((AND(= QEJ 0)(= QJJ 4))(SETQ PP "T79")(PPL))
((AND(= QEJ 0)(= QJJ 3))(SETQ PP "T86")(PPL))
((AND(= QEJ 0)(= QJJ 2))(SETQ PP "CH46")(PPL))
((AND(= QEJ 0)(= QJJ 1))(SETQ PP "CH75")(PPL))
((AND(= QEJ 0)(= QJJ 0))(SETQ PP "C23")(PPL))

((AND(= QEJ 1)(= QJJ 5))(SETQ PP "T126")(PPL))
((AND(= QEJ 1)(= QJJ 4))(SETQ PP "T122")(PPL))
((AND(= QEJ 1)(= QJJ 3))(SETQ PP "C16")(PPL))
((AND(= QEJ 1)(= QJJ 2))(SETQ PP "C83")(PPL))
((AND(= QEJ 1)(= QJJ 1))(SETQ PP "C84")(PPL))
((AND(= QEJ 1)(= QJJ 0))(SETQ PP "C56")(PPL))

((AND(= QEJ 2)(= QJJ 5))(SETQ PP "C24")(PPL))
((AND(= QEJ 2)(= QJJ 4))(SETQ PP "C25")(PPL))
((AND(= QEJ 2)(= QJJ 3))(SETQ PP "T32")(PPL))
((AND(= QEJ 2)(= QJJ 2))(SETQ PP "T158")(PPL))
((AND(= QEJ 2)(= QJJ 1))(SETQ PP "T159")(PPL))
((AND(= QEJ 2)(= QJJ 0))(SETQ PP "T162")(PPL))

((AND(= QEJ 3)(= QJJ 5))(SETQ PP "T29")(PPL))
((AND(= QEJ 3)(= QJJ 4))(SETQ PP "T142")(PPL))
((AND(= QEJ 3)(= QJJ 3))(SETQ PP "C42")(PPL))
((AND(= QEJ 3)(= QJJ 2))(SETQ PP "C41")(PPL))
((AND(= QEJ 3)(= QJJ 1))(SETQ PP "C88")(PPL))
((AND(= QEJ 3)(= QJJ 0))(SETQ PP "C40")(PPL))

((AND(= QEJ 4)(= QJJ 5)))
((AND(= QEJ 4)(= QJJ 4)))
((AND(= QEJ 4)(= QJJ 3)))
((AND(= QEJ 4)(= QJJ 2)))
((AND(= QEJ 4)(= QJJ 1)))
((AND(= QEJ 4)(= QJJ 0)))
((AND(= QEJ 5)(= QJJ 5)))
((AND(= QEJ 5)(= QJJ 4)))
((AND(= QEJ 5)(= QJJ 3)))
((AND(= QEJ 5)(= QJJ 2))(C:PAGE5))
((AND(= QEJ 5)(= QJJ 1))(C:PAGE7))
((AND(= QEJ 5)(= QJJ 0))(COMMAND "CANCLE"))
)
(SETVAR "CMDECHO" 1)
)
*-------------------------------------------------------------
*-------------------------------------------------------------
(DEFUN C:PAGE7 ()
(COMMAND "VSLIDE" "c:/acad/HON/SLD/CH7")
(C:CHWORD)
(COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "T41")(PPL))
((AND(= QEJ 0)(= QJJ 4))(SETQ PP "T42")(PPL))
((AND(= QEJ 0)(= QJJ 3))(SETQ PP "T43")(PPL))
((AND(= QEJ 0)(= QJJ 2))(SETQ PP "T37")(PPL))
((AND(= QEJ 0)(= QJJ 1))(SETQ PP "CH23")(PPL))
((AND(= QEJ 0)(= QJJ 0))(SETQ PP "CH24")(PPL))

((AND(= QEJ 1)(= QJJ 5))(SETQ PP "T70")(PPL))
((AND(= QEJ 1)(= QJJ 4))(SETQ PP "T71")(PPL))
((AND(= QEJ 1)(= QJJ 3))(SETQ PP "T45")(PPL))
((AND(= QEJ 1)(= QJJ 2))(SETQ PP "T44")(PPL))
((AND(= QEJ 1)(= QJJ 1))(SETQ PP "T82")(PPL))
((AND(= QEJ 1)(= QJJ 0))(SETQ PP "T83")(PPL))

((AND(= QEJ 2)(= QJJ 5))(SETQ PP "T150")(PPL))
((AND(= QEJ 2)(= QJJ 4))(SETQ PP "T151")(PPL))
((AND(= QEJ 2)(= QJJ 3))(SETQ PP "T74")(PPL))
((AND(= QEJ 2)(= QJJ 2))(SETQ PP "T146")(PPL))
((AND(= QEJ 2)(= QJJ 1))(SETQ PP "CH77")(PPL))
((AND(= QEJ 2)(= QJJ 0))(SETQ PP "T145")(PPL))

((AND(= QEJ 3)(= QJJ 5))(SETQ PP "C01")(PPL))
((AND(= QEJ 3)(= QJJ 4))(SETQ PP "C02")(PPL))
((AND(= QEJ 3)(= QJJ 3))(SETQ PP "C03")(PPL))
((AND(= QEJ 3)(= QJJ 2))(SETQ PP "C04")(PPL))
((AND(= QEJ 3)(= QJJ 1))(SETQ PP "C05")(PPL))
((AND(= QEJ 3)(= QJJ 0))(SETQ PP "C06")(PPL))

((AND(= QEJ 4)(= QJJ 5))(SETQ PP "C07")(PPL))
((AND(= QEJ 4)(= QJJ 4))(SETQ PP "C17")(PPL))
((AND(= QEJ 4)(= QJJ 3))(SETQ PP "C18")(PPL))
((AND(= QEJ 4)(= QJJ 2))(SETQ PP "C22")(PPL))
((AND(= QEJ 4)(= QJJ 1))(SETQ PP "C21")(PPL))
((AND(= QEJ 4)(= QJJ 0))(SETQ PP "C20")(PPL))

((AND(= QEJ 5)(= QJJ 5))(SETQ PP "C19")(PPL))
((AND(= QEJ 5)(= QJJ 4)))
((AND(= QEJ 5)(= QJJ 3)))
((AND(= QEJ 5)(= QJJ 2))(C:PAGE6))
((AND(= QEJ 5)(= QJJ 1))(C:PAGE8))
((AND(= QEJ 5)(= QJJ 0))(COMMAND "CANCLE"))
)
(SETVAR "CMDECHO" 1)
)
*-------------------------------------------------------------
*-------------------------------------------------------------
(DEFUN C:PAGE8 ()
(COMMAND "VSLIDE" "c:/acad/HON/SLD/CH8")
(C:CHWORD)
(COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "CH34")(PPL))
((AND(= QEJ 0)(= QJJ 4))(SETQ PP "T119")(PPL))
((AND(= QEJ 0)(= QJJ 3))(SETQ PP "T157")(PPL))
((AND(= QEJ 0)(= QJJ 2))(SETQ PP "C51")(PPL))
((AND(= QEJ 0)(= QJJ 1))(SETQ PP "C50")(PPL))
((AND(= QEJ 0)(= QJJ 0))(SETQ PP "C57")(PPL))

((AND(= QEJ 1)(= QJJ 5))(SETQ PP "C80")(PPL))
((AND(= QEJ 1)(= QJJ 4))(SETQ PP "C93")(PPL))
((AND(= QEJ 1)(= QJJ 3))(SETQ PP "C91")(PPL))
((AND(= QEJ 1)(= QJJ 2))(SETQ PP "T12")(PPL))
((AND(= QEJ 1)(= QJJ 1))(SETQ PP "T13")(PPL))
((AND(= QEJ 1)(= QJJ 0))(SETQ PP "T14")(PPL))

((AND(= QEJ 2)(= QJJ 5))(SETQ PP "T128")(PPL))
((AND(= QEJ 2)(= QJJ 4))(SETQ PP "T30")(PPL))
((AND(= QEJ 2)(= QJJ 3))(SETQ PP "T17")(PPL))
((AND(= QEJ 2)(= QJJ 2)))
((AND(= QEJ 2)(= QJJ 1)))
((AND(= QEJ 2)(= QJJ 0)))

((AND(= QEJ 3)(= QJJ 5)))
((AND(= QEJ 3)(= QJJ 4)))
((AND(= QEJ 3)(= QJJ 3)))
((AND(= QEJ 3)(= QJJ 2)))
((AND(= QEJ 3)(= QJJ 1)))
((AND(= QEJ 3)(= QJJ 0)))

((AND(= QEJ 4)(= QJJ 5)))
((AND(= QEJ 4)(= QJJ 4)))
((AND(= QEJ 4)(= QJJ 3)))
((AND(= QEJ 4)(= QJJ 2)))
((AND(= QEJ 4)(= QJJ 1)))
((AND(= QEJ 4)(= QJJ 0)))
((AND(= QEJ 5)(= QJJ 5)))
((AND(= QEJ 5)(= QJJ 4)))
((AND(= QEJ 5)(= QJJ 3)))
((AND(= QEJ 5)(= QJJ 2))(C:PAGE7))
((AND(= QEJ 5)(= QJJ 1))(C:PAGE9))
((AND(= QEJ 5)(= QJJ 0))(COMMAND "CANCLE"))
)
(SETVAR "CMDECHO" 1)
)
*-------------------------------------------------------------
*-------------------------------------------------------------
(DEFUN C:PAGE9 ()
(COMMAND "VSLIDE" "c:/acad/HON/SLD/CH9")
(C:CHWORD)
(COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "CH51")(PPL))
((AND(= QEJ 0)(= QJJ 4))(SETQ PP "CH52")(PPL))
((AND(= QEJ 0)(= QJJ 3))(SETQ PP "CH53")(PPL))
((AND(= QEJ 0)(= QJJ 2))(SETQ PP "CH54")(PPL))
((AND(= QEJ 0)(= QJJ 1))(SETQ PP "T136")(PPL))
((AND(= QEJ 0)(= QJJ 0))(SETQ PP "T137")(PPL))

((AND(= QEJ 1)(= QJJ 5))(SETQ PP "T138")(PPL))
((AND(= QEJ 1)(= QJJ 4))(SETQ PP "C69")(PPL))
((AND(= QEJ 1)(= QJJ 3))(SETQ PP "C43")(PPL))
((AND(= QEJ 1)(= QJJ 2))(SETQ PP "C36")(PPL))
((AND(= QEJ 1)(= QJJ 1))(SETQ PP "C35")(PPL))
((AND(= QEJ 1)(= QJJ 0))(SETQ PP "C30")(PPL))

((AND(= QEJ 2)(= QJJ 5))(SETQ PP "C32")(PPL))
((AND(= QEJ 2)(= QJJ 4))(SETQ PP "C36")(PPL))
((AND(= QEJ 2)(= QJJ 3))(SETQ PP "C35")(PPL))
((AND(= QEJ 2)(= QJJ 2))(SETQ PP "T160")(PPL))
((AND(= QEJ 2)(= QJJ 1))(SETQ PP "T144")(PPL))
((AND(= QEJ 2)(= QJJ 0))(SETQ PP "T153")(PPL))

((AND(= QEJ 3)(= QJJ 5))(SETQ PP "T26")(PPL))
((AND(= QEJ 3)(= QJJ 4))(SETQ PP "T6")(PPL))
((AND(= QEJ 3)(= QJJ 3))(SETQ PP "T19")(PPL))
((AND(= QEJ 3)(= QJJ 2))(SETQ PP "T4")(PPL))
((AND(= QEJ 3)(= QJJ 1))(SETQ PP "T3")(PPL))
((AND(= QEJ 3)(= QJJ 0))(SETQ PP "T2")(PPL))

((AND(= QEJ 4)(= QJJ 5))(SETQ PP "T167")(PPL))
((AND(= QEJ 4)(= QJJ 4))(SETQ PP "T124")(PPL))
((AND(= QEJ 4)(= QJJ 3))(SETQ PP "C67")(PPL))
((AND(= QEJ 4)(= QJJ 2))(SETQ PP "C68")(PPL))
((AND(= QEJ 4)(= QJJ 1))(SETQ PP "C66")(PPL))
((AND(= QEJ 4)(= QJJ 0))(C:PAGE8))

((AND(= QEJ 5)(= QJJ 5))(SETQ PP "T167")(PPL))
((AND(= QEJ 5)(= QJJ 4))(SETQ PP "T124")(PPL))
((AND(= QEJ 5)(= QJJ 3))(SETQ PP "C67")(PPL))
((AND(= QEJ 5)(= QJJ 2))(SETQ PP "C68")(PPL))
((AND(= QEJ 5)(= QJJ 1))(SETQ PP "C66")(PPL))
((AND(= QEJ 5)(= QJJ 0))(C:PAGE10))
)
(SETVAR "CMDECHO" 1)
)
*-------------------------------------------------------------
*-------------------------------------------------------------
(DEFUN C:PAGE10 ()
(COMMAND "VSLIDE" "c:/acad/HON/SLD/CH10")
(C:CHWORD)
(COND ((AND(= QEJ 0)(= QJJ 5))(SETQ PP "C64")(PPL))
((AND(= QEJ 0)(= QJJ 4))(SETQ PP "C65")(PPL))
((AND(= QEJ 0)(= QJJ 3))(SETQ PP "C34")(PPL))
((AND(= QEJ 0)(= QJJ 2))(SETQ PP "C33")(PPL))
((AND(= QEJ 0)(= QJJ 1))(SETQ PP "T18")(PPL))
((AND(= QEJ 0)(= QJJ 0))(SETQ PP "C63")(PPL))

((AND(= QEJ 1)(= QJJ 5))(SETQ PP "C64")(PPL))
((AND(= QEJ 1)(= QJJ 4))(SETQ PP "C65")(PPL))
((AND(= QEJ 1)(= QJJ 3))(SETQ PP "C34")(PPL))
((AND(= QEJ 1)(= QJJ 2))(SETQ PP "C33")(PPL))
((AND(= QEJ 1)(= QJJ 1))(SETQ PP "T18")(PPL))
((AND(= QEJ 1)(= QJJ 0))(SETQ PP "C63")(PPL))

((AND(= QEJ 2)(= QJJ 5))(SETQ PP "C99")(PPL))
((AND(= QEJ 2)(= QJJ 4))(SETQ PP "C100")(PPL))
((AND(= QEJ 2)(= QJJ 3))(SETQ PP "C101")(PPL))
((AND(= QEJ 2)(= QJJ 2))(SETQ PP "C102")(PPL))
((AND(= QEJ 2)(= QJJ 1))(SETQ PP "C103")(PPL))
((AND(= QEJ 2)(= QJJ 0))(SETQ PP "C104")(PPL))

((AND(= QEJ 3)(= QJJ 5))(SETQ PP "C99")(PPL))
((AND(= QEJ 3)(= QJJ 4))(SETQ PP "C100")(PPL))
((AND(= QEJ 3)(= QJJ 3))(SETQ PP "C101")(PPL))
((AND(= QEJ 3)(= QJJ 2))(SETQ PP "C102")(PPL))
((AND(= QEJ 3)(= QJJ 1))(SETQ PP "C103")(PPL))
((AND(= QEJ 3)(= QJJ 0))(SETQ PP "C104")(PPL))

((AND(= QEJ 4)(= QJJ 5))(SETQ PP "C105")(PPL))
((AND(= QEJ 4)(= QJJ 4))(SETQ PP "C106")(PPL))
((AND(= QEJ 4)(= QJJ 3))(SETQ PP "C107")(PPL))
((AND(= QEJ 4)(= QJJ 2))(SETQ PP "C108")(PPL))
((AND(= QEJ 4)(= QJJ 1))(C:PAGE9))
((AND(= QEJ 4)(= QJJ 0))(C:PAGE9))

((AND(= QEJ 5)(= QJJ 5))(SETQ PP "C105")(PPL))
((AND(= QEJ 5)(= QJJ 4))(SETQ PP "C106")(PPL))
((AND(= QEJ 5)(= QJJ 3))(SETQ PP "C107")(PPL))
((AND(= QEJ 5)(= QJJ 2))(SETQ PP "C108")(PPL))
((AND(= QEJ 5)(= QJJ 1))(COMMAND "PAGE1"))
((AND(= QEJ 5)(= QJJ 0))(COMMAND "CANCLE"))
)
(SETVAR "CMDECHO" 1)
)
*-------------------------------------------------------------
