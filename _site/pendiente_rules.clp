( defmodule PENDIENTE
  (import MAIN deftemplate ?ALL)
)


(defrule pendientes
 (or
   (abono (realizado false))
   (cargo (realizado false))
 )
 =>
  (printout t "Pendiente" crlf)
  ( halt )
)
