(defun C:CFG()
  (SETQ ANS (GETSTRING T "\nDO YOU WANT CONFIG TABLET ? (Y/N)"))
  (SETQ ANS (STRCASE ANS))
  (IF (= ANS "Y")
    (PROGN
      (setvar "cmdecho" 1)
      (command "tablet" "cfg" "0" "")
      (COMMAND "VSLIDE" "/ACAD/HON/SLD/CONFIG")
      (command "tablet" "cfg" "4" "\\" "\\" "\\" "25" "9" "\\" "\\" "\\" "11" "9" "\\" "\\" "\\" "4" "13" "\\" "\\" "\\" "25" "7" "Y" "\\" "\\")(redraw)
    )
    (setvar "cmdecho" 0)
  )
)
*----------------
