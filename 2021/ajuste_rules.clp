;los subtotales hasta aquí refelejan el estado contable antes de las liquidaciones
;No conviente borrarlos y reemplazarlos por valores que correpondan a un estado
;donde las cuentas de resultado se hayan liquidado, pues daran cero
;Pero sí es importante calcular los nuevos subtotales para las cuentas
;de patrimonio y de impuestos. Pues ese es el objtivo de la liquidacion
;Tomar todo el resultado  y determinar la utilidad del ejercicio
( defmodule AJUSTE ( import MAIN deftemplate ?ALL))

(deffunction mes_to_numero ( ?mes )
  ( switch ?mes
    ( case enero      then 1)
    ( case febrero    then 2)
    ( case marzo      then 3)
    ( case abril      then 4)
    ( case mayo       then 5)
    ( case junio      then 6)
    ( case julio      then 7)
    ( case agosto     then 8)
    ( case septiembre then 9)
    ( case octubre    then 10)
    ( case noviembre  then 11)
    ( case diciembre  then 12)
  )
)

(deffunction to_serial_date( ?dia ?mes ?ano)
  (+ (* 10000 ?ano) (* 100 ( mes_to_numero ?mes)) ?dia)
)



( defrule inicio-de-modulo-subtotal
   (declare (salience 10000))
  =>
   ( printout t "----------------------- AJUSTE ----------------------" crlf)
   ( set-strategy depth )
)


( defrule preparacion-cuenta
   ?cuenta <- (cuenta (mostrado-en-t true ))
  =>
  ( modify ?cuenta ( mostrado-en-t false ) )
) 

( defrule preparacion-totales
   ?totales <- (totales )
  =>
   ( retract ?totales )
)

(defrule elimina-subtotales-de-utilidad-tributaria
 (no)
  ?u <- (subtotales (cuenta utilidad-tributaria ))
 =>
  ( retract ?u )
)

(defrule elimina-subtotales-de-salarios
  (no)
  ?u <- (subtotales (cuenta salarios ))
 =>
  ( retract ?u )
)


(defrule elimina-subtotales-de-idpc
  ?u <- (subtotales (cuenta idpc ))
 =>
  ( retract ?u )
)



(defrule elimina-subtotales-de-patrimonio
  (no)
  (cuenta (nombre ?nombre) (grupo  patrimonio))
    ?u <- (subtotales (cuenta ?nombre ))
 =>
  ( retract ?u )
)


( defrule preparacion-subtotal
   (no)
   ?subtotales <- (subtotales  ( cuenta ?cuenta))
   ( test ( neq ?cuenta costos-de-ventas))
  =>
   ( retract ?subtotales )
)

( defrule fin-de-modulo-subtotal
   (declare (salience 10))
  =>
   ( printout t "----fin------------------- AJUSTE ----------------------" crlf)
)

