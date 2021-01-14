(DEFUN C:MATCH1 (/ QO#)
 (SETVAR"cmdecho"0)
 (PROMPT"\n \n \nSelect an object that represents the layer that you want to set to.")
 (COND
  ((/= (SETQ QO# (ENTSEL))NIL)
   (SETQ QO# (ENTGET (CAR QO#)))
   (COMMAND"layer""s" (CDR (ASSOC 8 QO#))"")
   (PROMPT (STRCAT"\nLayer set to " (CDR (ASSOC 8 QO#))" layer."))
  )
  (T
   (PROMPT"\nNo object selected.")
  )
 )
 (PROMPT"\n \n \nProcessing completed.")
 (PRINC)
)
