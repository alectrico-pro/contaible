( defmodule ACCIONES ( import MAIN ?ALL ))


(defrule inicio-de-modulo-acciones
   (declare (salience 10000))
  => 
   ( printout t "-------------------- ACCIONES -----------------------------------------------------------" crlf)
   ( printout t "  material             dia    u       cu      ct        u      cu      ct            descripcion" crlf)
   ( printout t "..........................................................................................." crlf)
   ( printout t "                             ..........entrada.........|...........salida........." crlf)

   ( assert (comando (nombre hacer-inventario)))
)

;el asiento inicial ya está implementado por el usuario en sus facts
(defrule inventario-asiento-inicial
   ( empresa (nombre ?empresa) )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (origen ?origen) (partida nil) (nombre accionario ) (grupo ?grupo) (circulante ?circulante) (debe ?debe) (haber ?haber) (balanceado ?balanceado))
   ?accionario <- (accionario (dia ?dia) (mes ?mes) (u ?unidades) (operacion asiento-inicial) (material ?material) (partida ?numero) (ct ?total) (cu ?costo_unitario))
  =>
   ( assert ( cuenta (origen ?origen) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa ) (partida ?numero) (nombre accionario) (grupo ?grupo) (circulante ?circulante) (debe ?total) (haber 0) (balanceado ?balanceado)))
   (printout t ?material tab ?dia tab ?unidades tab ?costo_unitario tab ?total tab tab tab tab asiento-inicial crlf)
   ;( retract ?inventario )
  ;(printout t "Ignorada partida de inventario por " ?total " operacion es " asiento-inicial crlf)
  ( halt )
)


(defrule inventario-devolucion
   ( empresa (nombre ?empresa ))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (origen ?origen) (partida nil) (nombre accionario ) (grupo ?grupo) (circulante ?circulante) (debe ?debe) (haber ?haber) (balanceado ?balanceado) (tipo ?tipo))
   ?accionario <- (accionario (dia ?dia) (mes ?mes) (u ?unidades) (operacion devolucion) (material ?material) (partida ?numero) (ct ?total) (cu ?costo_unitario))
  => 
   ( assert ( cuenta (origen ?origen) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?empresa) (partida ?numero) (nombre accionario ) (grupo ?grupo) (circulante ?circulante) (debe ?total) (haber 0) (balanceado ?balanceado) (tipo ?tipo)))
   (printout t ?material tab ?dia tab ?unidades tab ?costo_unitario tab ?total tab tab tab tab devolucion crlf)
   ;(retract ?inventario)
 ; (printout t "Creada partida de inventario por " ?total " operacion es " devolucion crlf)
)


(defrule inventario-gasto-sobre-compra
   ( empresa (nombre ?empresa) )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (origen ?origen) (partida nil) (nombre acciones) (grupo ?grupo) (circulante ?circulante) (debe ?debe) (haber ?haber) (balanceado ?balanceado) (tipo ?tipo))
   ?accionario <- (accionario (dia ?dia) (mes ?mes) (u ?unidades) (operacion gasto-sobre-compra) (material ?material) (partida ?numero) (ct ?total) (cu ?costo_unitario))
  => 
   ( assert ( cuenta (origen ?origen) (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (nombre acciones ) (grupo ?grupo) (circulante ?circulante) (debe ?total) (haber 0) (balanceado ?balanceado) (tipo ?tipo)))
   ( printout t ?material tab ?dia tab ?unidades tab ?costo_unitario tab ?total tab tab tab tab gasto-sobre-compra crlf)
   ;( retract ?inventario )
 ;(printout t "Creada partida de inventario por " ?total " operacion es " gasto-sobre-compra  crlf)

)


(defrule inventario-compra
   ( empresa  (nombre ?empresa ))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (origen ?origen) (partida nil) (nombre acciones ) (grupo ?grupo) (circulante ?circulante) (debe ?debe) (haber ?haber) (balanceado ?balanceado) (tipo ?tipo))
   ?accionario <- (accionario (dia ?dia) (mes ?mes) (u ?unidades) (operacion compra) (material ?material) (partida ?numero) (ct ?total) (cu ?costo_unitario) )
  => 
   ( assert ( cuenta (origen ?origen) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (nombre acciones ) (grupo ?grupo) (circulante ?circulante) (debe ?total) (haber 0) (balanceado ?balanceado) (tipo ?tipo)))

   (printout t ?material tab ?dia tab ?unidades tab ?costo_unitario tab ?total tab tab tab tab compra crlf)
   ;( retract ?inventario )
;:  (printout t "Creada partida de inventario por " ?total " operacion es " compra  crlf)

)

(defrule inventario-venta
   ( empresa (nombre ?empresa))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (origen ?origen) (partida nil) (nombre acciones ) (grupo ?grupo) (circulante ?circulante) (debe ?debe) (haber ?haber) (balanceado ?balanceado) (tipo ?tipo))
   ?accionario <- (accionario (dia ?dia) (mes ?mes) (u ?unidades) (operacion venta) (material ?material) (partida ?numero) (ct ?total) (cu ?costo_unitario))
  => 
   ( assert ( cuenta (origen ?origen) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (nombre accionario ) (grupo ?grupo) (circulante ?circulante) (debe 0) (haber ?total) (balanceado ?balanceado) (tipo ?tipo) ))

   (printout t ?material tab ?dia tab tab tab tab ?unidades tab ?costo_unitario tab ?total tab venta crlf)
   ;(retract ?inventario)
 ;(printout t "Creada partida de inventario por " ?total " operacion es " venta crlf)
)

(defrule mostrar-accionario
  ( empresa (nombre ?empresa))
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  ?comando <- (comando (nombre mostrar-inventario) (realizado false))
  ?accionario <- (accionario (dia ?dia) (mes ?mes) (ano ?ano) (u ?unidades) (operacion ?operacion) (material ?material) (partida ?partida) (ct ?total) (cu ?costo_unitario))
 => 
  ( modify ?comando (realizado true))
  ( printout t ?dia " de " ?mes " - " partida  " #" ?partida ": " ?operacion " de " ?unidades " " ?material " a " ?costo_unitario " c/u por un valor total de " ?total crlf)
)

