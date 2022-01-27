( defmodule TC ( import MAIN deftemplate ?ALL))

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



( defrule inicio-de-modulo-TC
   (declare (salience 9000))
;  (empresa (nombre ?empresa))
  =>
   ( printout t "--módulo----------------------- TC ----------------------" crlf)
   ( set-strategy depth )
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
  ( printout t "---------------------------- recibida activo-fijo tipo-de-documento" crlf)

  ( assert ( subtotales ( cuenta ?nombre)))
  ( assert ( hacer ?nombre))

)

( defrule t-filas-de-resultados


  ( empresa (nombre ?empresa))
  ( balance (dia ?top))
  ( partida (numero ?partida) (dia ?dia))

  ?hacer  <- ( hacer ?nombre )

  ?cuenta <- ( cuenta
     ( partida ?partida)
     ( nombre ?nombre)
     ( debe    ?debe)
     ( haber   ?haber)
     ( de-resultado true)
     ( mostrado-en-t false)
     ( origen  ?origen ) )

  ?subtotales <- ( subtotales
    ( mostrado   false)
    ( totalizado false)
    ( cuenta ?nombre )
    ( debe ?total_debe)
    ( haber ?total_haber) )

  ( test (>= ?top ?dia))
 =>
  ( printout t "r " ?partida tab ?debe tab "|" tab ?haber crlf )
  ( modify ?cuenta (mostrado-en-t true ))
  ( modify ?subtotales
       (debe  (+ ?total_debe  ?debe))
       (haber (+ ?total_haber ?haber)))
)


 
( defrule t-filas


  ( empresa (nombre ?empresa))
  ( balance (dia ?top))
  ( partida (numero ?partida) (dia ?dia))

  ?hacer  <- ( hacer ?nombre )

  ?cuenta <- ( cuenta 
     ( de-resultado false)
     ( nombre ?nombre)
     ( partida ?partida) 
     ( debe    ?debe)
     ( haber   ?haber)
     ( mostrado-en-t false)
     ( origen  real ) )

  ?subtotales <- ( subtotales
    ( mostrado   false)
    ( totalizado false)
    ( cuenta ?nombre )
    ( debe ?total_debe)
    ( haber ?total_haber) )

  ( test (and (neq nil ?partida) (> ?partida 0)))
  ( test (>= ?top ?dia))
 =>
  ( printout t ?partida tab ?debe tab "|" tab ?haber crlf )
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


