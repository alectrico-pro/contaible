;Toma los datos de los ebooks desde volumenes.txt y e invoca a make para
;titular las cubiertas de todos los ebooks que estén en volumenes.txt y que tenga cubierta y titulo
(defmodule MAIN
  (export ?ALL )
)

(defrule inicio-titular-cubiertas
 =>
  ( load-facts "volumenes.txt")
  ( bind ?archivo (str-cat "make-titular-cubiertas.sh"))
  ( open ?archivo k "w")
)

(defrule final
  (declare (salience -100) )
 =>
  (close k)
)

(defrule titular-cubiertas
  (volumen (cubierta ?cubierta) (titulo ?titulo) )
  (test (neq nil ?cubierta))
 =>
  ( printout t " Generando orden make para " ?cubierta " con título " ?titulo crlf)
  ( printout k (str-cat " make tit  ARCHIVO=" ?cubierta  " TITULO=" ?titulo ) crlf )
)

