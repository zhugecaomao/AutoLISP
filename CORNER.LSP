(defun C:CORNER(/ p1 p2 osm r cmd)

(setq r (getvar "FILLETRAD"))
(setq osm (getvar "osmode"))
(setq cmd (getvar "CMDECHO"))
(setvar "cmdecho" 0)
(setvar "osmode" (+   32 256))
(setq p1 (car (cdr (entsel
 "\nSelect first entity or corner point: "))))
(setq p2 (car (cdr (entsel "\nSelect second
 entity or RETURN for no-one: "))))
(if (null p2) (setq p2 p1))
(setvar "FILLETRAD" 0)
(command "fillet" p1 p2)
(setvar "osmode" osm)
(setvar "cmdecho" 1)
(setvar "filletrad" r)
)
