
; 该程序可生成三维实体外螺纹。
; 你可生成以下的螺纹:
; 执行命令：ISO228
; 功能： ISO 228 (相当于 DIN 228 和 NEN 176)
; 执行命令：mythread
; 功能：管螺纹, ISO 7-1 (相当于 DIN 2999 和 NEN 3258)
; 执行命令：Metric
; 功能：公制内外螺纹， NEN 81 和 NEN 1870

(defun myerror (s)

  (if (/= s "function cancelled") (princ (strcat "\nError: " s)))
  (setvar "cmdecho" ocmd)
  (setvar "osmode" osm)
  (setq *error* olderr)
  (princ)
)

(defun c:ISO228 (/ nom pitch length threadangle cpt inout minordiafactor nom1 nom2 size size1 n s olderr)

   ;;;;(setq olderr *error*
   ;;;;      *error* myerror)
   (setq osm (getvar "osmode"))
   (setq ocmd (getvar "cmdecho"))

   (setvar "cmdecho" 1)

   (setq minordiafactor 1.6666666667)
   ;(Princ "\nThread according to DIN ISO 228, NEN 176")
   ;(initget 1 "I E")
   ;(setq inout (getkword "\nInternal or External thread (I/E): "))
    (setq inout "I")
   (initget "1/16 1/8 1/4 3/8 1/2 5/8 3/4 7/8 1 1-1/8 1-1/4 1-1/2 1-3/4 2 2-1/4 2-1/2 2-3/4 3 3-1/2 4 4-1/2 5 5-1/2 6")
    (setq size1 (getkword "\n公称尺寸, 1/16' to 6' (如: 1/8 or 1-1/4): "))
 (if(= size1 "1/16")(setq nom1 1.5875))
 (if(= size1 "1/8")(setq nom1 3.175))
 (if(= size1 "1/4")(setq nom1 6.35))
 (if(= size1 "3/8")(setq nom1 9.525))
 (if(= size1 "1/2")(setq nom1 12.7))
 (if(= size1 "5/8")(setq nom1 15.875))
 (if(= size1 "3/4")(setq nom1 19.05))
 (if(= size1 "7/8")(setq nom1 22.225))
 (if(= size1 "1")(setq nom1 25.4))
 (if(= size1 "1-1/8")(setq nom1 28.575))
 (if(= size1 "1-1/4")(setq nom1 31.75))
 (if(= size1 "1-1/2")(setq nom1 38.1))
 (if(= size1 "1-3/4")(setq nom1 44.45))
 (if(= size1 "2")(setq nom1 50.8))
 (if(= size1 "2-1/4")(setq nom1 57.15))
 (if(= size1 "2-1/2")(setq nom1 63.5))
 (if(= size1 "2-3/4")(setq nom1 69.85))
 (if(= size1 "3")(setq nom1 76.2))
 (if(= size1 "3-1/2")(setq nom1 88.9))
 (if(= size1 "4")(setq nom1 101.6))
 (if(= size1 "4-1/2")(setq nom1 114.3))
 (if(= size1 "5")(setq nom1 127))
 (if(= size1 "5-1/2")(setq nom1 139.7))
 (if(= size1 "6")(setq nom1 152.4))
 ;(setq size "1")                                        ; demo version only 1
 ;(if (= size "1")(if (= inout "E") (setq nom1 33.069) (setq nom1 33.568)))
   (setq n (getdist "\n牙数:"))
   (setq pitch (/ 25.4 n))
   (initget 1)                                          ; no enter
   (setq cpt (getpoint "起始点: "))
   (initget 3)                                          ; no enter, not zero
   (setq length (getdist "\n螺纹总长(Y方向): "))

   (setq h (* 0.96049 pitch))                           ; h according to ISO 228
   (setq nom (+ nom1 (/ h 3)))                          ; biggest outside diameter
   (setq nom2 (- nom (* h minordiafactor)))             ; inside diameter
   (setq threadangle (+ 27.5 0))                        ; threadangle

   (setvar "osmode" 0)
   (setvar "cmdecho" 0)

   (drawthread nom nom1 nom2 pitch length threadangle cpt)

   (princ "\nDone")
   (setvar "osmode" osm)
   (setvar "cmdecho" ocmd)
   (setq *error* olderr)
   (princ)
)


; Next routine makes metric thread according to NEN 1870

(defun c:Metric (/ nom pitch length threadangle cpt inout minordiafactor nom1 nom2 ocmd osm 4H 5H 6H h6 g6 tol)

   ;-------------------------------------------------------------------
   ; Gets the nominal size, tpi, and total length
   ; then calculates a bunch of geometry points.
   ; All running osnaps are turned off as well.
   ;-------------------------------------------------------------------

   (setq 4H (list 0.0015 0.002 0.002 0.0025 0.003 0.0035 0.004 0.005 0.006 0.007 0.008 0.009 0.010))   
   (setq 5H (list 0.002 0.0025 0.003 0.004 0.0045 0.0055 0.0065 0.0075 0.009 0.010 0.0115 0.0125 0.0135))   
   (setq 6H (list 0.003 0.004 0.0045 0.0055 0.0065 0.008 0.0095 0.011 0.0125 0.0145 0.016 0.018 0.020))   
   (setq h6 (list -0.003 -0.004 -0.0045 -0.0055 -0.0065 -0.008 -0.0095 -0.011 -0.0125 -0.0145 -0.016 -0.018 -0.020))   
   (setq g6 (list -0.005 -0.008 -0.0095 -0.0115 -0.0135 -0.017 -0.0195 -0.023 -0.0265 -0.0295 -0.033 -0.036 -0.0515))   

   (setq osm (getvar "osmode"))
   (setq ocmd (getvar "cmdecho"))
   (setq minordiafactor 1.5)
   ;(initget 1 "I E")
   ;(setq inout (getkword "\nInternal or External thread (I/E): "))
   (setq inout "I")
   (initget 7)                                                            ; no enter, not zero, not negative
   (setq nom1 (getdist "\n公称外径: "))
   ;(setq nom1 10)                                                         ; demo version only M10
   (initget 7)                                                            ; no enter, not zero, not negative
   (setq pitch (getreal "\n螺距: "))
   ;(setq pitch 1.25)                                                      ; demo version only 1.25
   (initget 1)                                                            ; no enter
   (setq cpt (getpoint "起始点: "))
   (initget 3)                                                            ; no enter, not zero, not negative
   (setq length (getdist "\n螺纹总长(Y方向): "))

; add tolerance to nominal diameter

   (if (<= nom1 3) (setq n 0)           ; position in tolerance field depending on nominal diameter
    (if (<= nom1 6) (setq n 1)
    (if (<= nom1 10) (setq n 2)
    (if (<= nom1 18) (setq n 3)
    (if (<= nom1 30) (setq n 4)
    (if (<= nom1 50) (setq n 5)
    (if (<= nom1 80) (setq n 6)
    (if (<= nom1 120) (setq n 7)
    (if (<= nom1 180) (setq n 8)
    (if (<= nom1 250) (setq n 9)
    (if (<= nom1 315) (setq n 10)
    (if (<= nom1 400) (setq n 11)
    (if (<= nom1 500) (setq n 12)
   )))))))))))))

   (if (= inout "I")
    (if (< pitch 0.25) (setq nom1 (+ nom1 (nth n 4H)))       ; tolerance field to use depending on pitch
    (if (< pitch 0.35) (setq nom1 (+ nom1 (nth n 5H)))
    (if (>= pitch 0.35) (setq nom1 (+ nom1 (nth n 6H)))
    )))
   )
   (if (= inout "E")
    (if (< pitch 0.35) (setq nom1 (+ nom1 (nth n h6)))
    (if (>= pitch 0.35) (setq nom1 (+ nom1 (nth n g6)))
    ))
   )

   (setq h (* 0.866025 pitch))                                            ; h=0.866025
   (setq nom (+ nom1 (/ h 4)))                                            ; h/8
   (setq nom2 (- nom (* h minordiafactor)))                               ; inside diameter
   (setq threadangle (+ 30 0))                                            ; 30?threadangle

   (setvar "osmode" 0)
   (setvar "cmdecho" 0)

   (drawthread nom nom1 nom2 pitch length threadangle cpt)

   (princ "\nDone")
   (setvar "cmdecho" ocmd)
   (setvar "osmode" osm)
   (princ)
)


; Next routine makes all threads

(defun c:mythread (/ nom pitch length threadangle cpt inout minordiafactor nom1 ocmd osm)

   ;-------------------------------------------------------------------
   ; Gets the nominal size, tpi, and total length
   ; then calculates a bunch of geometry points.
   ; All running osnaps are turned off as well.
   ;-------------------------------------------------------------------

   (setq osm (getvar "osmode"))
   (setq ocmd (getvar "cmdecho"))
   (initget 7)                                                            ; no enter, not zero, not negative
   (setq nom1 (getdist "\n有效外径: "))
   ;(setq nom1 22)                                                         ; demo version only 22
   (initget 7)                                                            ; no enter, not zero, not negative
   (setq nom (getdist "\n公称外径: "))
   ;(setq nom 22.5)                                                        ; demo version only 22.5
   (initget 7)                                                            ; no enter, not zero, not negative
   (setq nom2 (getdist "\n有效底径: "))
   (initget 7)                                                            ; no enter, not zero, not negative
   (setq pitch (getreal "\n螺距: "))
   (initget 7)                                                            ; no enter, not zero, not negative
   (setq threadangle (getreal "\n螺纹角度: "))
   (initget 1)                                                            ; no enter
   (setq cpt (getpoint "起始点: "))
   (initget 3)                                                            ; no enter, not zero, not negative
   (setq length (getdist "\n螺纹总长(Y方向): "))

   (setq h (* 0.866025 pitch))                                            ; h=0.866025

   (setvar "osmode" 0)
   (setvar "cmdecho" 0)

   (drawthread nom nom1 nom2 pitch length threadangle cpt)

   (princ "\nDone")
   (setvar "cmdecho" ocmd)
   (setvar "osmode" osm)
   (princ)
)


(defun drawthread (nom nom1 nom2 pitch length threadangle cpt / total pt1 pt1z pt2 pt3 ang pt1a
pt1az pt3a pt1b pt1bz pt3b pt4 pt4 pt6 pt7 pt8 pt9 pt10 pt11 pt12 ss conewantedstart conewantedend)

   ;-------------------------------------------------------------------
   ; Gets the nominal size, tpi, and total length
   ; then calculates a bunch of geometry points.
   ; All running osnaps and cmdecho are turned off as well.
   ;-------------------------------------------------------------------
   ;(command "undo" "begin")                            ; start undo steps

   (setq total (+ (fix (/ (abs length) pitch)) 3)
      pt1 (list (- (car cpt) (/ nom 2.0)) (cadr cpt) (caddr cpt))
      pt1z (list (- (car cpt) (/ nom 2.0)) (cadr cpt) (+  (caddr pt1) 1.0))
      pt2 (polar pt1 (/ (* threadangle pi) 180.0) 1)
      pt3 (list (+ (car pt1) nom) (+ (cadr pt1) (/ pitch 2.0))  (caddr cpt))
      ang (angle pt1 pt3)
      pt1a (polar pt1 (+ ang (/ pi 2.0)) pitch)
      pt1az (list (car pt1a) (cadr pt1a) (+  (caddr pt1a) 1.0))
      pt3a (polar pt1a ang nom)
      pt1b (polar pt1 (- ang (/ pi 2.0)) pitch)
      pt1bz (list (car pt1b) (cadr pt1b) (+  (caddr pt1b) 1.0))
      pt3b (polar pt1b ang nom)
      pt4 (polar pt3 (/ (* (- 180 threadangle) pi) 180.0) 1)
      pt5 (inters pt1 pt2 pt3 pt4 nil)
      pt6 (list (car pt5) (cadr cpt)  (caddr cpt))
      pt7 (polar pt1 (/ (* (- 360 threadangle) pi) 180.0) 1)
      pt8 (polar pt3 (/ (* (+ 180 threadangle) pi) 180.0) 1)
      pt9 (inters pt1 pt7 pt3 pt8 nil)
      pt10 (list (car pt9) (cadr pt3)  (caddr pt3))
      pt11 (polar cpt (/ pi 2.0) pitch)
      pt12 (polar pt11 (/ pi 2.0) (abs length))
   )

   ;-------------------------------------------------------------------
   ; Draws two cones which are inverted and offset 1/2 the pitch.
   ; The cones are each sliced at the angle of the crest line
   ; and then unioned together
   ;-------------------------------------------------------------------

;   (initget 0 "Y N")
;   (setq conewantedstart (getkword "\nDo you want a 90?top angle at the start? (Y/N) <Y>: 
(SETQ CONEWANTEDSTART "N")
;"))
;   (initget 0 "Y N")
;   (setq conewantedend (getkword "\nDo you want a 90?top angle at the end? (Y/N) <Y>: "))
(SETQ CONEWANTEDEND "Y")
   (command "zoom" "w" (list (car pt1a) (+ (cadr pt1a) (abs length)) (caddr pt1a)) pt3b)

   (princ "\n绘制螺纹....需要一段时间")
   (command "pline" pt1 pt5 pt6 "c")
   (command "revolve" "l" "" pt5 pt6 "")
   (command "slice" "l" "" pt1 pt3 pt1z pt5)
   (command "slice" "l" "" pt1a pt3a pt1az pt3)
   (setq ss (ssadd (entlast)))
   (command "pline" pt3 pt9 pt10 "c")
   (command "revolve" "l" "" pt9 pt10 "")
   (command "slice" "l" "" pt1 pt3 pt1z pt9)
   (command "slice" "l" "" pt1b pt3b pt1bz pt3)
   (setq ss (ssadd (entlast) ss))
   (command "union" ss "")

   ;-------------------------------------------------------------------
   ; This above solid is sliced in half and then mirrored. This
   ; creates the "helix" in the thread. The height of the single
   ; thread is actually equal to twice the pitch, but the
   ; excess is either absorbed or cut off in the last step
   ;-------------------------------------------------------------------

   (command "slice" ss "" "xy" cpt "b")
   (setq ss (ssadd (entlast) ss))
   (command "mirror" "l" "" pt1 "@10<0" "y")
   (command "union" ss "")

   ;-------------------------------------------------------------------
   ; The thread is arrayed and then unioned together (this part can
   ; take a while). The resulting solid is cut to the specified length.
   ;-------------------------------------------------------------------

   (setq e (entlast))
   (command "array" ss "" "r" total 1 pitch)
   (repeat (1- total)
      (setq e (entnext e)
         ss (ssadd e ss)
      )
   )
   (command "union" ss "")

; if wanted make a 45?cone at the start and union with thread

   (if (/= conewantedstart "N")
    (progn (setq e (entlast))
     (command "cone" (list (car cpt) (+ (cadr cpt) pitch) (caddr cpt)) "d" nom1 "a" (list (car cpt) (+ (+ (cadr cpt) (/ nom1 2)) pitch) (caddr cpt)))
     (command "union" "l" e "")
    )
   )

   (command "slice" "l" "" "zx" pt11 pt12)
   (command "slice" "l" "" "zx" pt12 pt11)
   (command "move" "l" "" cpt (list (car cpt) (- (cadr cpt) pitch) (caddr cpt))) 

; make a minor diameter cylinder and union with thread

   (setq e (entlast))
   (command "cylinder" cpt "d" nom2 "c" (list (car cpt) (+ (cadr cpt) (abs length)) (caddr cpt)))
   (command "union" "l" e "")
   (setq ss (entlast))

; make a hollow cylinder, with or without end cone, and subtract from thread

   (command "cylinder" cpt "d" nom1 "c" (list (car cpt) (+ (cadr cpt) (abs length)) (caddr cpt)))     ; minor dia
   (setq e (entlast))

   ; if wanted make a 45?cone at the end

   (if (/= conewantedend "N")
    (progn (command "move" "l" "" cpt (list (car cpt) (- (cadr cpt) (/ (- nom1 nom2) 2)) (caddr cpt)))        ; move minor dia down
     (command "cone" cpt "d" nom1 "a" (list (car cpt) (+ (cadr cpt) (/ nom1 2)) (caddr cpt)))   ; put cone on minor dia
     (command "move" "l" "" cpt (list (car cpt) (- (+ (cadr cpt) (abs length)) (/ (- nom1 nom2) 2)) (caddr cpt)))
     (command "union" "l" e "")                ; union cone and minor dia
     (setq e (entlast))
    )
   )

   ; subtract minor dia from bigger cylinder

   (command "cylinder" cpt "d" (* nom1 1.5) "c" (list (car cpt) (+ (cadr cpt) (abs length)) (caddr cpt)))
   (command "subtract" "l" "" e "")
   (setq e (entlast))

   ; subtract hollow cylinder from thread

   (command "subtract" ss "" e "")

   ; if thread negative length then mirror

   (setq e (entlast))
   (if (< length 0) (mirror3d e "zx" cpt "y"))

   (command "zoom" "p")

   (command "undo" "end")                                 ; end undo steps
)


;;;---------------------------------------------------------------------------------------------------------------------;

(arxload "geom3d" nil)
(princ "\n\tISO228, Metric 和 Mythread 已加载。 ")
(princ)

