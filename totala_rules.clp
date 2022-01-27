;Este modulo totaliza los montos por separado de activos, pasivos y patrimonio
;De esta forma el balance de comprobación de saldos que siga podrá ser realizado
;Estos totales actuan sobre cuentas liquidadas
( defmodule TOTALA ( import MAIN deftemplate ?ALL))


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
  ( declare (salience 10000))
  ( empresa (nombre ?empresa))
=>
  ;( printout t "--------módulo----------- TOTALA -----------------------" crlf)  
  ( assert (totales (empresa ?empresa )))
)

;----------------------- Calculando los totales para el balance ----------------------
(defrule sumando-activos
   ( declare (salience 9000))
   ?cuenta <- ( cuenta (origen real) (partida ?numero) (nombre ?nombre ) (grupo activo) (debe ?debe) (haber ?haber) (totalizada-como-activo false) )
   ?totales <- ( totales (activos ?activos))
   (test (neq ?debe ?haber))
  => 
   ( bind ?saldo (- ?debe ?haber ))
   ( bind   ?total (+ ?activos ?saldo ))
   ( modify ?totales (activos ?total))
   ( modify ?cuenta (totalizada-como-activo true))
  ; ( printout t "--+a c t i v o= " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-activos-circulantes
   ( declare (salience 8))
   ( balance (dia ?top))
   ( partida (numero ?numero) (dia ?dia))
   ?cuenta <- ( cuenta (origen real) (partida ?numero) (nombre ?nombre ) (grupo activo) (circulante true) (debe ?debe) (haber ?haber) (totalizada-como-activo-circulante false))
   ?totales <- ( totales (activo-circulante ?activo-circulante))
   ( test (>= ?top ?dia))
   ( test (neq ?debe ?haber))
  =>
   ( bind   ?saldo (- ?debe ?haber ))
   ( bind   ?total (+ ?activo-circulante ?saldo ))
   ( modify ?totales (activo-circulante ?total))
   ( modify ?cuenta (totalizada-como-activo-circulante true))
  ; ( printout t "--+acirculante= " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-activos-fijos
   ( declare (salience 8))
   ( partida (numero ?numero) (dia ?dia))
   ?cuenta <- ( cuenta (origen real) (partida ?numero) (nombre ?nombre ) (grupo activo) (circulante false) (debe ?debe) (haber ?haber) (totalizada-como-activo-fijo false))
   ?totales <- ( totales (activo-fijo ?activo-fijo))
   ( test (neq ?debe ?haber))
  => 
   ( bind   ?saldo (- ?debe ?haber ))
   ( bind   ?total (+ ?activo-fijo ?saldo ))
   ( modify ?totales (activo-fijo ?total))
   ( modify ?cuenta (totalizada-como-activo-fijo true))
  ; ( printout t "--+a f i j o  = " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-pasivos 
   ( declare (salience 8))
   ( balance (dia ?top))
   ( partida (numero ?numero) (dia ?dia))
   ?cuenta <- ( cuenta (origen real) (partida ?numero) (nombre ?nombre ) (grupo pasivo) (debe ?debe) (haber ?haber) (totalizada-como-pasivo false))
   ?totales <- ( totales (pasivos ?pasivos))
   ( test (>= ?top ?dia))
   ( test (neq ?debe ?haber))
  => 
   ( bind   ?saldo (- ?haber ?debe ))
   ( bind   ?total (+ ?pasivos ?saldo ))
   ( modify ?totales (pasivos ?total))
   ( modify ?cuenta (totalizada-como-pasivo true))
 ;  ( printout t "--+p a s i v o= " ?total tab ?saldo " de " ?nombre crlf)
)



(defrule sumando-pasivos-circulantes
   ( declare (salience 8))
   ( partida (numero ?numero) (dia ?dia))
   ?cuenta <- ( cuenta (origen real) (partida ?numero) (nombre ?nombre ) (grupo pasivo) (circulante true) (debe ?debe) (haber ?haber) (totalizada-como-pasivo-circulante false))
   ?totales <- ( totales (pasivo-circulante ?pasivo-circulante))
   ( test (neq ?haber ?debe))
  =>
   ( bind   ?saldo (- ?haber ?debe ))
   ( bind   ?total (+ ?pasivo-circulante ?saldo ))
   ( modify ?totales (pasivo-circulante ?total))
   ( modify ?cuenta (totalizada-como-pasivo-circulante true))
 ;  ( printout t "--+pcirculante= " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-pasivo-fijo
   ( declare (salience 8))
   ( partida (numero ?numero) (dia ?dia))
   ?cuenta <- ( cuenta (origen real) (partida ?numero) (nombre ?nombre ) (grupo pasivo) (circulante false) (debe ?debe) (haber ?haber) (totalizada-como-pasivo-fijo false))
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
   (empresa (nombre ?empresa))
   (partida (numero ?numero) (dia ?dia))
   ?cuenta <- (cuenta
         (empresa ?empresa)
         (nombre ?nombre)
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

(defrule sumando-ganancias
   (declare (salience 8))
   (empresa (nombre ?empresa))
   (partida (numero ?numero) (dia ?dia))
   ?cuenta <- (cuenta
         (empresa ?empresa)
         (nombre ?nombre)
         (totalizada-como-patrimonio false)
         (de-resultado true)
         (debe   ?debe)
         (haber  ?haber)
         (origen real))
   ?totales <- (totales (empresa ?empresa) (resultados ?resultados))
   ( test (> ?debe ?haber))
  =>
   ( bind ?saldo (- ?debe ?haber))
   ( bind ?total (+ ?resultados ?saldo ))
   ( modify ?totales (resultados ?total ))
   ( modify ?cuenta (totalizada-como-patrimonio true))
 ;  ( printout t "--+ganancias  = " ?total tab ?saldo " de " ?nombre crlf)
)  


(defrule sumando-perdidas
   (declare (salience 8))
   (empresa (nombre ?empresa))
   (partida (numero ?numero) (dia ?dia))
   ?cuenta <- (cuenta
         (empresa ?empresa)
         (nombre ?nombre)
         (totalizada-como-patrimonio false)
         (de-resultado true)
         (debe   ?debe)
         (haber  ?haber)
         (origen real))
   ?totales <- (totales (empresa ?empresa) (resultados ?resultados))
   ( test (> ?haber ?debe))

  =>
   ( bind ?saldo (- ?haber ?debe))
   ( bind ?total (+ ?resultados ?saldo ))
   ( modify ?totales (resultados ?total ))
   ( modify ?cuenta (totalizada-como-patrimonio true))
;   ( printout t "--+perdidas   = " ?total tab ?saldo " de " ?nombre crlf)
)



~ 
