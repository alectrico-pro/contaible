(defmodule CALCULO (import MAIN deftemplate ?ALL))


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



(defrule inicio-de-modulo-calculo
 (declare ( salience 10000))
=>
 ( printout t  "---------------------- CALCULO --------------------" crlf)
)

(defrule liquidacion-mostrar-partida
( declare (salience 8000))
  ?partida<-(partida (numero ?numero) )
  (liquidacion (partida ?numero))
 =>
  ( assert (cabeza ?numero))
)

;============================== Tabla de la Partida ================================
(defrule encabezado
  ( cabeza ?numero )
  ;( balance ( dia ?top ) (mes ?mes) (ano ?ano))
 ; ( empresa (nombre ?empresa) (razon ?razon))
  ;( test (>= ?top ?dia))
 =>
  ( printout t crlf crlf crlf)
  ( printout t "==================================================================" crlf)
  ( printout t FECHA tab Parcial tab Debe tab Haber tab Descripción crlf)
  ( printout t "==================================================================" crlf)
  ( printout t "Partida " ?numero crlf)
  ( printout t ".................................................................." crlf)
  ( assert (fila ?numero))
)



(defrule footer
  ?fila <- ( fila ?numero )
;  ( balance ( dia ?top ) (mes ?mes) (ano ?ano))
  ( empresa (nombre ?empresa) (razon ?razon))
  ( partida (numero ?numero) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion))
 ; ( test (>= ?top ?dia))
 =>
  ;:( retract ?fila )
  ( printout t "------------------------------------------------------------------" crlf)
  ( printout t tab tab ?debe tab ?haber tab "( " ?dia " de " ?mes tab ?ano tab " )" crlf)
  ( printout t "==================================================================" crlf)
  ( printout t ?razon crlf)
  ( printout t ?descripcion crlf)
  ( printout t crlf crlf)
)



(defrule muestra-saldo-liquidadora-saldo-nulo
  (no)
   ?f1 <- (cuenta (nombre ?nombre) (debe ?debe) (haber ?haber) (saldo ?saldo))
   ;test (eq false ?verificada))
   (test (= ?debe ?haber))
  =>
   ( bind ?saldo (- ?debe ?haber ) )
;  ( modify  ?f1 ( saldo ?saldo ) (verificada (not ?verificada)))
 ;  ( retract ?f1)
   ( printout t crlf)
   ( printout t "-----------------------------------------------------" crlf)
   ( printout t tab tab ?nombre  tab saldo-nulo crlf)
   ( printout t "----------------------------------------------------" crlf)
   ( printout t tab (round ?debe) tab "|" tab (round ?haber) crlf)
   ( printout t tab (round ?saldo) crlf)
   ( printout t crlf)
)



(defrule muestra-saldo-liquidadora-saldo-deudor
   ?f1 <- (cuenta (nombre ?nombre) (debe ?debe) (haber ?haber) (saldo ?saldo) (tipo liquidadora))  
   (test (> ?debe ?haber))
  => 
   ( bind ?saldo (- ?debe ?haber ) )
   ( printout t crlf)
   ( printout t "-----------------------------------------------------" crlf)
   ( printout t tab tab ?nombre  tab saldo-deudor crlf)
   ( printout t "----------------------------------------------------" crlf)
   ( printout t tab (round ?debe) tab "|" tab (round ?haber) crlf)
   ( printout t tab (round ?saldo) crlf)
   ( printout t crlf)
)


(defrule muestra-saldo-liquidadora-saldo-acreedor 
   ?f1 <- (cuenta (nombre ?nombre) (debe ?debe) (haber ?haber) (saldo ?saldo) (tipo liquidadora) ) 
   (test (< ?debe ?haber))
  => 
   ( bind ?saldo (- ?haber ?debe ) )
   ( printout t crlf)
   ( printout t "-----------------------------------------------------" crlf)
   ( printout t tab tab ?nombre tab saldo-acreedor crlf)
   ( printout t "-----------------------------------------------------" crlf)
   ( printout t tab (round ?debe) tab "|" tab (round ?haber) crlf)
   ( printout t tab tab "|" tab (round ?saldo) crlf)
   ( printout t crlf)
)



(defrule liquidar-acreedora-de-resultados
   (declare (salience 80))

   (fila ?numero)
   (empresa (nombre ?empresa))
   ?partida     <- (partida (numero ?numero) (debe ?debep) (haber ?haberp))
   ?f1          <- (liquidacion (partida ?numero) (cuenta ?nombre) (ano ?ano))  
   ?acreedora   <- (cuenta (de-resultado true) (parte ?parte) (nombre ?nombre)  (debe ?debe)  (haber ?haber)  (tipo acreedora) (liquidada false) )
   ?inventario  <- (cuenta (nombre inventario) (acreedor ?resultado))
   ?liquidador  <- (cuenta (nombre ?liquidora) (debe ?debe2) (haber ?haber2) (tipo liquidadora) (saldo ?saldo2) )
   (test (and (= ?debe 0) (= ?haber 0)))
  => 
   ( bind ?saldo (round (* ?parte ?resultado)))

   ( modify ?acreedora
     ( liquidada true )
     ( haber (+ ?haber ?saldo))
   )

   ( modify ?liquidador
     ( ano ?ano)
     ( empresa ?empresa )
     ( haber (+ ?haber2 ?saldo))
     ;( saldo (+ ?saldo2 ?saldo))
   ) 
   ( modify ?partida (debe (+ ?debep ?saldo)) ( haber (+ ?haberp ?saldo)))

   ( printout t "x-- Liquidando cuenta de resultados " ?nombre " en " ?liquidora crlf)
   ( printout t tab tab ?saldo "|" tab tab tab ?nombre crlf)
   ( printout t tab tab tab "|" tab ?saldo tab tab "r<" ?liquidora ">" crlf)
)



