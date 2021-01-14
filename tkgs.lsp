;****************************************************************************************
; UPDATE BLOCK COLOR (updblkcl.lsp)
; PRE-INSERTED BLOCK DEFINITION CLEAN-UP UTILITY
;
; This routine is especially usefull to redefine pre-inserted blocks whose
; entity colors need to be changed to BYLAYER.
;
; This routine allows the user to update the color of
; all entities within a block to a single color (exam: color=BYLAYER)
; without the user having to explode the symbol. By default the layer name of
; all entities are NOT changed. The routine changes the original
; definition of the block within the current drawing.
; 
; To use this routine the user is asked to specify a single
; color to place all entities of a selected block(s).
;
; The user is next prompted to select one or more blocks to update. The routine
; then redefines all entities of the block to the color specified.
;
; When the user regenerates the drawing she/he will find that all
; occurances of the block have been redefined. This is because the
; original definition of the block is changed!!!
;
; by CAREN LINDSEY, July 1996
;****************************************************************************************
;

;INTERNAL ERROR HANDLER
(defun err-ubc (s) ; If an error (such as CTRL-C) occurs
; while this command is active...
(if (/= s "Function cancelled")
(princ (strcat "\nError: " s))
)
(setq *error* olderr) ; Restore old *error* handler
(princ)
);err-ubc

(DEFUN C:tkgs (/ BLK CBL CBL2 C ACL ALY NLY NCL)

(setq olderr *error* *error* err-ubc)
(initget "?")
(while
(or (eq (setq C (getint "\nEnter new color number/: ")) "?")
(null C)
(> C 256)
(< C 0)
);or
(textscr)
(princ "\n ")
(princ "\n Color number | Standard meaning ")
(princ "\n ________________|____________________")
(princ "\n | ")
(princ "\n 0 | ")
(princ "\n 1 | Red ")
(princ "\n 2 | Yellow ")
(princ "\n 3 | Green ")
(princ "\n 4 | Cyan ")
(princ "\n 5 | Blue ")
(princ "\n 6 | Magenta ")
(princ "\n 7 | White ")
(princ "\n 8...255 | -Varies- ")
(princ "\n 256 | ")
(princ "\n \n\n\n")
(initget "?")
);while


(PROMPT "\nPick blocks to update. ")

(SETQ SS (SSGET '((0 . "INSERT"))))
(SETQ K 0)
(WHILE (< K (SSLENGTH SS))
(setq CBL (tblsearch "BLOCK" (CDR (ASSOC 2 (ENTGET (SETQ BLK (SSNAME SS K)))))))
(SETQ CBL2 (CDR (ASSOC -2 CBL)))
(WHILE (BOUNDP 'CBL2)
(SETQ EE (ENTGET CBL2))

;Update layer value
(SETQ NCL (CONS 62 C))
(SETQ ACL (ASSOC 62 EE))
(IF (= ACL nil)
(SETQ NEWE (APPEND EE (LIST NCL)))
(SETQ NEWE (SUBST NCL ACL EE))
);if
(ENTMOD NEWE)

(SETQ CBL2 (ENTNEXT CBL2))
);end while
(ENTUPD BLK)
(SETQ K (1+ K))
);end while
(setq *error* olderr)
(princ)
);end updblkcl  

 
