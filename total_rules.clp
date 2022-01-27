;Este modulo totaliza los montos por separado de activos, pasivos y patrimonio
;De esta forma el balance de comprobación de saldos que siga podrá ser realizado
( defmodule TOTAL ( import MAIN deftemplate ?ALL))


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



(defrule inicio-de-modulo-total
  (declare (salience 9000))
  (empresa (nombre ?empresa))
=>
;  (printout t "--------módulo----------- TOTAL -----------------------" crlf)  
  ( assert (totales (empresa ?empresa )))
)


( defrule subtotales-costos-de-ventas-no-mostrar-en-comprobacion
  ?s <- ( subtotales ( cuenta costos-de-ventas ) (mostrar-en-comprobacion true))
=>
  ( modify ?s (mostrar-en-comprobacion false))
)


;----------------------- Calculando los totales para el balance inicial ----------------------
(defrule sumando-activos
   ( declare (salience 10000))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (padre false) (origen real) (partida ?numero&:(neq nil ?numero)) (nombre ?nombre ) (grupo activo) (debe ?debe) (haber ?haber) (totalizada-como-activo false))
   ?totales <- ( totales (activos ?activos))
   ( test (or (> ?debe 0) (> ?haber 0)))

  => 
   ( bind ?saldo (- ?debe ?haber ))
   ( bind   ?total (+ ?activos ?saldo ))
   ( modify ?totales (activos ?total))
   ( modify ?cuenta (totalizada-como-activo true))
;   ( printout t "--+a c t i v o= " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-activos-circulantes
   ( declare (salience 8))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))

   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (padre false) (origen real) (partida ?numero&:(neq nil ?numero)) (nombre ?nombre ) (grupo activo) (circulante true) (debe ?debe) (haber ?haber) (totalizada-como-activo-circulante false))
   ?totales <- ( totales (activo-circulante ?activo-circulante))

  =>
   ( bind   ?saldo (- ?debe ?haber ))
   ( bind   ?total (+ ?activo-circulante ?saldo ))
   ( modify ?totales (activo-circulante ?total))
   ( modify ?cuenta (totalizada-como-activo-circulante true))
;   ( printout t "--+acirculante= " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-activos-fijos
   ( declare (salience 8))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (padre false) (origen real) (partida ?numero&:(neq nil ?numero)) (nombre ?nombre ) (grupo activo) (circulante false) (debe ?debe) (haber ?haber) (totalizada-como-activo-fijo false))
   ?totales <- ( totales (activo-fijo ?activo-fijo))
  => 
   ( bind   ?saldo (- ?debe ?haber ))
   ( bind   ?total (+ ?activo-fijo ?saldo ))
   ( modify ?totales (activo-fijo ?total))
   ( modify ?cuenta (totalizada-como-activo-fijo true))
;  ( printout t "--+a f i j o  = " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-pasivos 
   ( declare (salience 8))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (padre false) (origen real) (partida ?numero&:(neq nil ?numero) ) (nombre ?nombre ) (grupo pasivo) (debe ?debe) (haber ?haber) (totalizada-como-pasivo false))
   ?totales <- ( totales (pasivos ?pasivos))
  => 
   ( bind   ?saldo (- ?haber ?debe ))
   ( bind   ?total (+ ?pasivos ?saldo ))
   ( modify ?totales (pasivos ?total))
   ( modify ?cuenta (totalizada-como-pasivo true))
;   ( printout t "--+p a s i v o= " ?total tab ?saldo " de " ?nombre crlf)
)



(defrule sumando-pasivos-circulantes
   ( declare (salience 8))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (padre false) (origen real) (partida ?numero&:(neq nil ?numero)) (nombre ?nombre ) (grupo pasivo) (circulante true) (debe ?debe) (haber ?haber) (totalizada-como-pasivo-circulante false))
   ?totales <- ( totales (pasivo-circulante ?pasivo-circulante))
  =>
   ( bind   ?saldo (- ?haber ?debe ))
   ( bind   ?total (+ ?pasivo-circulante ?saldo ))
   ( modify ?totales (pasivo-circulante ?total))
   ( modify ?cuenta (totalizada-como-pasivo-circulante true))
;   ( printout t "--+pcirculante= " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-pasivo-fijo
   ( declare (salience 8))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (padre false) (origen real) (partida ?numero&:(neq nil ?numero)) (nombre ?nombre ) (grupo pasivo) (circulante false) (debe ?debe) (haber ?haber) (totalizada-como-pasivo-fijo false))
   ?totales <- ( totales (pasivo-fijo ?pasivo-fijo))
  => 
   ( bind   ?saldo (- ?haber ?debe ))
   ( bind   ?total (+ ?pasivo-fijo ?saldo ))
   ( modify ?totales (pasivo-fijo ?total))
   ( modify ?cuenta (totalizada-como-pasivo-fijo true))
;   ( printout t "--+p f i j o  = " ?total tab ?saldo " de " ?nombre crlf)
)



(defrule sumando-patrimonio
   (declare (salience 8))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   (empresa (nombre ?empresa))
   ?cuenta <- (cuenta
         (padre false)
         (empresa ?empresa)
         (nombre ?nombre)
         (partida ?numero&:(neq nil ?numero))
         (totalizada-como-patrimonio false)
         (grupo patrimonio)
         (debe   ?debe)
         (haber  ?haber)
         (mostrado-en-t true)
         (origen real))
   ?totales <- (totales (empresa ?empresa) (patrimonio ?patrimonio) )
  =>
   ( bind ?saldo (- ?haber ?debe))
   ( bind ?total (+ ?patrimonio ?saldo ))
   ( modify ?totales (patrimonio ?total ))
   ( modify ?cuenta (totalizada-como-patrimonio true))
 ; ( printout t "--+patrimonio = " ?total tab ?saldo " de " ?nombre crlf)
)
