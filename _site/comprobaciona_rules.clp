( defmodule COMPROBACIONA ( import MAIN deftemplate ?ALL))

;---- este modulo se concentra en presentar en forma de T el comportamiento de las partidas para cada cuenta
;---- también totaliza sumas calificadas para alimentar al balance inicial y a otros informes
;---- los hechos de totales y subtotales ayudan a obtener los estados de síntesis para cada nivel de agregación
;---- la granularidad de los datos es a nivel de partida, donde intervienen las cuentas.
;---- luego las cuentas tienen diferentes estados que han sido establecidos por los movimientos entre cuentas de cada partida
;---- hay un resumen por cuentas, sin clasificarlas por estados, solo un listado con debe, haber, y los valora canonizados 
;---- deber y acreedor


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



( defrule inicio-de-modulo-comprobacion_a
   (declare (salience 10000))
  =>
   ( printout t "--modulo--------------- COMPROBACIONA -------------------" crlf)
)


;----------------- B A L A N C E ---------------------------------------------------------

(defrule balance-encabezado
   ( declare (salience -7000))
   ( empresa (nombre ?empresa))
   ( balance (dia ?dia) (mes ?mes) (ano ?ano))
  =>
   ( printout t crlf crlf )
   ( printout t "<br> <br> <br> <br> <br> <br> " crlf)
   ( printout t "Solo se consideran las transacciones hasta el día " ?dia tab ?mes "."  crlf)
   ( printout t "Cifras en pesos." crlf)
   ( printout t "No se han practicado liquidaciones, por lo que se muestran cuentas nominales"  crlf)
   ( printout t crlf crlf "           B A L A N C E  DE COMPROBACION AJUSTADA DE SUMAS Y SALDOS mes: " ?mes crlf)
   ( printout t tab tab SUMAS tab tab "|" tab SALDOS crlf )
   ( printout t tab tab DEBE tab HABER tab "|" tab DEBER tab ACREEDOR crlf)
   ( printout t "---------------------------------------------------------------------" crlf)
)


(defrule balance-filas
  ( declare (salience -8000))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )
  =>
  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)
)


(defrule balance-genera-totales
  (declare (salience -8000))

  ?subtotales <- (subtotales
   ( mostrado-en-resumen false)
   ( cuenta   ?cuenta)
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

  ?totales <- (totales
   ( debe     ?total_debe)
   ( haber    ?total_haber)
   ( deber    ?total_deber)
   ( acreedor ?total_acreedor) )
  =>

   ( modify ?totales   (debe     (+ ?total_debe     ?debe)    )
                       (haber    (+ ?total_haber    ?haber)   )
                       (deber    (+ ?total_deber    ?deber)   )
                       (acreedor (+ ?total_acreedor ?acreedor)) )
   ( modify ?subtotales (mostrado-en-resumen true) )
   ( assert ( hacer-balance-footer ))
)


(defrule balance-footer
  ?comando <-  ( hacer-balance-footer)
  ( empresa (nombre ?empresa))
  ( balance (mes ?mes) (ano ?ano))

  (not (subtotales (mostrado-en-resumen false)))
  (totales
    ( debe     ?debe)
    ( haber    ?haber)
    ( deber    ?deber)
    ( activos ?activos)
    ( activo-circulante ?activo-circulante)
    ( activo-fijo ?activo-fijo)
    ( pasivos ?pasivos)
    ( pasivo-circulante ?pasivo-circulante)
    ( pasivo-fijo ?pasivo-fijo)
    ( patrimonio ?patrimonio)
    ( acreedor ?acreedor) )
  =>
   ( bind ?patrimonio_pasivo (+ ?patrimonio ?pasivos))
   ( printout t tab "......................................................." crlf)
   ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab activos= ?activos crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
;   ( printout t tab tab "* inventario es inventario inicial." crlf)
   ( retract ?comando)
)
