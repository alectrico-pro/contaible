(defmodule TICKET
  (import MAIN deftemplate inicio-de-los-dias ticket nonce revision revision-general) 
)

(defrule inicio-de-los-dias-ticket
  (declare (salience 10000))
  (inicio-de-los-dias (partidas $?partidas))
=>
  ( printout t "----------------- TICKET ------------------" crlf)
  (progn$ (?i ?partidas)
    ( assert (ticket (numero ?i)))
    ( assert (nonce  (ticket ?i))))
)

(defrule revision-general
  (revision-general
    (partidas $?partidas))
 =>
  (printout t "Revision general hallada en el archivo <empresa>-revisiones.txt" crlf)
  (progn$  (?i ?partidas)
    (do-for-all-facts
        ((?f revision))     (eq ?i ?f:partida)
        (modify ?f ( rechazado true  ))
        (printout t "Revisión " ?f:partida " ahora indica rechazo." crlf)) )
)

