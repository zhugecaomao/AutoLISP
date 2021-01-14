;
;       Plot function of two variables
;
;       Designed and implemented by Kelvin R. Throop in June of 1988
;
;       To make a three dimensional polygon mesh representing the
;       values of a function in two variables across a specified range
;       of values for the two variables, with a defined resolution
;       (specified as the number of subdivisions within the range), call:
;
;           (fplot function xrange yrange resolution)
;
;       where:
;
;          function    The function to be evaluated.  This will
;                      usually be the quoted name of a previously-
;                      defined function, or a quoted lambda-definition
;                      of a function.
;
;          xrange      The range of X values, specified as a list
;                      with the first element the lower bound for X
;                      and the second element the upper bound.
;
;          yrange      The range of Y values, specified as a list
;                      with the first element the lower bound for Y
;                      and the second element the upper bound.
;
;          resolution  An integer specifying the granularity of the
;                      mesh approximating the surface defined by the
;                      function's values for arguments in the specified
;                      range.
;
;       For example, to plot (e**(-(X**2 + Y**2))) over the range from
;       -1 to 1 in both the X and Y axes, use:
;
;               (fplot '(lambda (x y) (exp (- (+ (* x x) (* y y)))))
;                       '(-2 2)
;                       '(-2 2)
;                        20
;               )
;
;       (This will look like a tennis ball under the rug, when viewed
;       from, say, VPOINT 1,1,1.)
;
;       Or, you can plot a predefined function.  For example:
;
;                (defun cs (x y)
;                   (cos (sqrt (+ (* x x 2) (* y y))))
;                )
;                (fplot 'cs '(-20 20) '(-20 20) 40)
;
;       This makes a series of elliptical ripples, like a pond after
;       you've just dropped in a cinder block.
;
;       This file contains a complex predefined test case.  If you
;       enter the command:
;
;                DEMO
;
;       you'll get the interference pattern from two exponentially
;       damped cosine waves.  This example illustrates the amazing
;       surfaces you can generate with a simple definition using
;       fplot.
;
;
(defun fplot (fcn xrange yrange res / ce stepx stepy i j x y)

        (setq x (car xrange)
              stepx (/ (- (cadr xrange) x) (float res))
              stepy (/ (- (cadr yrange) (car yrange)) (float res))
              i 0
        )

        (setq ce (getvar "cmdecho"))
        (setvar "cmdecho" 0)
        (command "3Dmesh" res res)
        (while (< i res)
           (setq j 0
                 y (car yrange)
           )
           (while (< j res)
              (setq j (1+ j)
                    y (+ y stepy)
              )
              (command (list x y (apply fcn (list x y))))
           )
           (setq i (1+ i)
                 x (+ x stepx)
           )
        )
        (setvar "cmdecho" ce)
)

;       Demo program

;       Generate exponentially damped cosine wave

(defun dampcos (x y / dist omag sfreq decfr)
        (setq
              omag  2.0      ; Overall magnitude scale factor
              sfreq 8.0      ; Spatial frequency factor
              decfr 1.5      ; Exponential decay spatial frequency
        )
        (setq dist (sqrt (+ (* x x) (* y y))))
        (* omag
           (cos (* dist sfreq))
           (exp (- (* decfr dist)))
        )
)

;       Calculate interference of two damped cosine waves

(defun interf (x y / offset)
        (setq offset 0.9)          ; Offset of centres from origin
        (+ (dampcos (- x offset) y) (dampcos (+ x offset) y))
)

;       Demo run of function plot, type DEMO at command prompt

(defun C:demo ()
        (fplot 'interf
                '(-3 3) '(-3 3) 50)
        (princ)                    ; Suppress printing function result
)
