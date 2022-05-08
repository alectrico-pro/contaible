;Toma los datos de los ebooks desde volumenes.txt y e invoca a make para
;titular las cubiertas de todos los ebooks que estén en volumenes.txt y que tenga cubierta y titulo
(defmodule MAIN
  (export ?ALL )
)

(defrule inicio-titular-cubiertas
 =>
  ( load-facts "/doc/volumenes.txt")
)

(defrule titular-cubiertas
  (volumen (cubierta ?cubierta) (titulo ?titulo) )
  (test (neq nil ?cubierta))
 =>
  (printout t " Procesando " ?cubierta " con título " ?titulo crlf)
  (system (str-cat " make tit  ARCHIVO=" ?cubierta ".jpg"  " TITULO=" ?titulo ) )
)

