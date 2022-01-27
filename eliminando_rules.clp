( defmodule TA ( import MAIN deftemplate ?ALL))

;---- este modulo se concentra en presentar en forma de T el comportamiento de las partidas para cada cuenta
;---- también totaliza sumas calificadas para alimentar al balance inicial y a otros informes
;---- los hechos de totales y subtotales ayudan a obtener los estados de síntesis para cada nivel de agregación
;---- la granularidad de los datos es a nivel de partida, donde intervienen las cuentas.
;---- luego las cuentas tienen diferentes estados que han sido establecidos por los movimientos entre cuentas de cada partida
;---- hay un resumen por cuentas, sin clasificarlas por estados, solo un listado con debe, haber, y los valora canonizados 
;---- deber y acreedor
;---- No es necesario filtrar por dia, mes, año o empresa pues los modulos anteriores eliminan o evitan reglas fuera de estos filtos.


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



( defrule inicio-de-modulo-TA
   (declare (salience 9000))
;  (empresa (nombre ?empresa))
  =>
   ( printout t "--módulo----------------------- TA ----------------------" crlf)
   ( set-strategy depth )
   ( facts )
)

(defrule eliminando-abonos
 (declare (salience 10000))
 ?a <- (abono) 
=>
 (retract ?a)
)

(defrule eliminando-cargos
 (declare (salience 10000))
 ?a <- (cargo)
=>
 (retract ?a)
)

(defrule eliminando-cuentas
 (declare (salience 10000))
 ?a <- (cuenta)
=>
 (retract ?a)
)

(defrule eliminando-inventario
 (declare (salience 10000))
 ?a <- (inventario)
=>
 (retract ?a)
)

(defrule eliminando-liquidacion
 (declare (salience 10000))
 ?a <- (liquidacion)
=>
 (retract ?a)
)


(defrule eliminando-comando
 (declare (salience 10000))
 ?a <- (comando)
=>
 (retract ?a)
)

(defrule eliminando-partidas
 (declare (salience 10000))
 ?a <- (partida)
=>
 (retract ?a)
)

(defrule gasto-sobre-compras
 (declare (salience 10000))
 ?a <- (gasto-sobre-compras)
=>
 (retract ?a)
)

(defrule ecuacion
 (declare (salience 10000))
 ?a <- (ecuacion)
=>
 (retract ?a)
)

( defrule encabezado
  ?cuenta <- ( cuenta
     ( partida nil)
     ( mostrado-en-t false)
     ( nombre ?nombre)
     ( origen real)
     ( saldo  ?saldo )
  )
 =>
  ( printout t crlf crlf crlf )
  ( printout t ?nombre crlf )
  ( printout t "----------------------------" crlf)
  ( assert ( subtotales ( cuenta ?nombre)))
  ( assert ( hacer ?nombre))

)

( defrule t-filas
  ( empresa (nombre ?empresa))
  ( balance (dia ?top))
  ( partida (numero ?partida) (dia ?dia))

  ?hacer  <- ( hacer ?nombre )

  ?cuenta <- ( cuenta 
     ( grupo ?grupo)
     ( circulante ?circulante)
     ( de-resultado false)
     ( nombre ?nombre)
     ( partida ?partida) 
     ( debe    ?debe)
     ( haber   ?haber)
     ( origen ?origen)
     ( mostrado-en-t false)
      )

  ?subtotales <- ( subtotales
    ( mostrado   false)
    ( totalizado false)
    ( cuenta ?nombre )
    ( debe ?total_debe)
    ( haber ?total_haber) )

  ( test (and (neq nil ?partida) (> ?partida 0)))
  ( test (>= ?top ?dia))
 =>
  ( printout t ?partida tab ?debe tab "|" tab ?haber tab ?grupo tab ?circulante tab ?origen crlf )
  ( modify ?cuenta (mostrado-en-t true ))
  ( modify ?subtotales
       (debe  (+ ?total_debe  ?debe))
       (haber (+ ?total_haber ?haber)))
)


( defrule t-diferencia-deudora
   ?subtotales <- ( subtotales
     ( mostrado false)
     ( haber ?haber )
     ( debe  ?debe )
     ( acreedor ?acreedor)
     ( deber ?deber)
     ( totalizado false)
   )
   ( test (> ?debe ?haber))
  =>
   ( bind ?diferencia (- ?debe ?haber ))
   ( modify ?subtotales (deber ?diferencia) (totalizado true))
)



( defrule t-diferencia-acreedora
   ?subtotales <- ( subtotales
     ( haber ?haber )
     ( debe  ?debe )
     ( acreedor ?acreedor)
     ( deber ?deber)
     ( totalizado false)
     ( mostrado false)
   )
   ( test (< ?debe ?haber))
  =>
   ( bind ?diferencia (- ?haber ?debe ))
   ( modify ?subtotales (acreedor ?diferencia) (totalizado true))
)



( defrule t-footer-deudor
  ?subtotales <- ( subtotales 
    ( haber ?haber )
    ( debe  ?debe )
    ( totalizado true)
    ( mostrado false)
  )
  ( test (> ?debe ?haber))
  =>
   ( bind ?diferencia (- ?debe ?haber ))
   ( printout t "----------------------------" crlf)
   ( printout t tab ?debe tab "|" tab ?haber crlf )
   ( printout t tab "--------------------" crlf)
   ( printout t "$" tab ?diferencia crlf )
)



( defrule t-footer-acreedor
  ?subtotales <- ( subtotales
    ( haber ?haber )
    ( debe  ?debe )
    ( totalizado true)
    ( mostrado false )
  )
  ( test (< ?debe ?haber))
  =>
   ( bind ?diferencia (- ?haber ?debe ))
   ( printout t "----------------------------" crlf)
   ( printout t tab ?debe tab "|" tab ?haber crlf )
   ( printout t tab "---------------------" crlf)
   ( printout t tab tab "|" tab  ?diferencia tab "$" crlf )
)




