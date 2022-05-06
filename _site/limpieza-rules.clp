(defmodule LIMPIEZA
  ( import MAIN deftemplate ?ALL )
)


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



(defrule inicio-de-modulo-de-partida
  ( declare (salience 8000))
 =>
  ( set-strategy depth)
  ( printout t "------------------- LIMPIEZA--------------------" crlf)
)


(defrule limpieza-subtotales
  ( declare (salience 10000))
  ?subtotales <- (subtotales)
 =>
;  ( printout t "borrando subtotales" tab ?dia crlf)
  ( retract ?subtotales)
)


(defrule limpieza-ventas-a-futuro
  ( declare (salience 10000))
  (balance (dia ?top))
  ?venta <- (venta (dia ?dia))
  ( test (< ?top ?dia))
 =>
;  ( printout t "borrando venta dia" tab ?dia crlf)
  ( retract ?venta)
)


(defrule limpieza-compras-a-futuro
  ( declare (salience 10000))
  (balance (dia ?top))
  ?venta <- (compra (dia ?dia))
  (test (< ?top ?dia))
 =>
 ; ( printout t "borrando compra del dia" tab ?dia crlf)
  ( retract ?venta)
)


(defrule limpieza-devoluciones-a-futuro
  ( declare (salience 10000))
  (balance (dia ?top))
  ?devolucion <- (devolucion (dia ?dia))
  (test (< ?top ?dia))
 =>
;  ( printout t "borrando devolución del  dia" tab ?dia crlf)
  ( retract ?devolucion)
)

(defrule limpieza-pagos-a-futuro
  ( declare (salience 10000))
  (balance (dia ?top))
  ?pago <- (pago (dia ?dia))
  (test (< ?top ?dia))
 =>
 ; ( printout t "borrando pago del  dia" tab ?dia crlf)
  ( retract ?pago)
)

(defrule limpieza-despagos-a-futuro
  ( declare (salience 10000))
  (balance (dia ?top))
  ?despago <- (despago (dia ?dia))
  (test (< ?top ?dia))
 =>
 ; ( printout t "borrando despago del  dia" tab ?dia crlf)
  ( retract ?despago)
)


(defrule limpieza-gasto-administrativo-a-futuro
  ( declare (salience 10000))
  (balance (dia ?top))
  ?gasto <- (gasto-administrativo (dia ?dia))
  (test (< ?top ?dia))
 =>
 ; ( printout t "borrando gasto administrativo del dia" tab ?dia crlf)
  ( retract ?gasto)
)

(defrule limpieza-gasto-de-ventas-a-futuro
  ( declare (salience 10000))
  (balance (dia ?top))
  ?gasto <- (gasto-de-ventas (dia ?dia))
  (test (< ?top ?dia))
 =>
 ; ( printout t "borrando gasto de ventas  del  dia" tab ?dia crlf)
  ( retract ?gasto)
)


(defrule preparacion
  ( declare (salience 9000))
  ( empresa (nombre ?empresa))
  ( balance (dia ?top) (mes ?mes) (ano ?ano))
  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
  ( test (>= ?top ?dia))
 =>
  ( assert (ecuacion (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano)))
)

(defrule abonos-nil
  ( abono (partida ?partida) (dia ?dia) (mes ?mes ) (ano ?ano))
 =>
  ( printout t "abono nil partida " ?partida " dia " ?dia " mes " ?mes " año " ?ano crlf)
)





