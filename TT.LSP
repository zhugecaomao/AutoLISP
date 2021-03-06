(defun  c:wig ()
(setq  MA (getstring " Material (SS41,SS41D,S45C,FC20,Cu,Al,STainless,GOld,OTher) = "))
(prompt "Please Input mm^  ")
(setq  aa (getreal "Enter Area = "))
(setq  ae (/ aa 1000 ))
(prompt "Please Input mm  ")
(setq  la (getreal "Enter Thickness = "))
(setq  li (/ la 1000 ))
(IF (OR (= MA "SS41")(= MA "ss41")(= MA "SS41D")(= MA "ss41d"))
(PROGN
(SETQ KA (* ae li 7.86 ))
(prompt "Material Weight = ")
(prin1 KA)(prompt " kg  ")
))
(IF (OR (= MA "S45C")(= MA "s45c"))
(PROGN
(SETQ KA (* ae li 7.844 ))
(prompt "Material Weight = ")
(prin1 KA)(prompt " kg  ")
))
(IF (OR (= MA "FC20")(= MA "fc20"))
(PROGN
(SETQ KA (* ae li 7.15 ))
(prompt "Material Weight = ")
(prin1 KA)(prompt " kg  ")
))
(IF (OR (= MA "CU")(= MA "cu")(= MA "Cu")(= MA "cU"))
(PROGN
(SETQ KA (* ae li 8.96 ))
(prompt "Material Weight = ")
(prin1 KA)(prompt " kg  ")
))
(IF (OR (= MA "al")(= MA "AL")(= MA "Al")(= MA "aL"))
(PROGN
(SETQ KA (* ae li 2.699 ))
(prompt "Material Weight = ")
(prin1 KA)(prompt " kg  ")
))
(IF (OR (= MA "ST")(= MA "st")(= MA "St")(= MA "sT"))
(PROGN
(SETQ KA (* ae li 7.93 ))
(prompt "Material Weight = ")
(prin1 KA)(prompt " kg  ")
))
(IF (OR (= MA "GO")(= MA "go")(= MA "Go")(= MA "gO"))
(PROGN
(SETQ KA (* ae li 19.3 ))
(prompt "Material Weight = ")
(prin1 KA)(prompt " kg  ")
))
)
