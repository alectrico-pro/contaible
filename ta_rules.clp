;Este TA devuelve el estado de liquidación de la empresa
;Toma cuentas que han siso anotadas para tener saldo 0
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
  =>
   ( printout t "--módulo----------------------- TA ----------------------" crlf)
   ( set-strategy depth )
)

( defrule fin-de-modulo-TA
   (declare (salience -10000))
  =>
   ( printout t "--fin----------------------- TA ----------------------" crlf)
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

(defrule eliminando-inventario
  (declare (salience 10000))
  (no)
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
  (no)
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

( defrule calculando-subtotal-de-cuentas-liquidadas
  ( empresa (nombre ?empresa))
  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  ( cuenta (nombre ?nombre) (grupo patrimonio))


  ?cuenta <- ( cuenta
     ( nombre ?nombre)
     ( liquidada true)
     ( partida ?partida)
     ( debe    ?debe)
     ( haber   ?haber)
     ( mostrado-en-t false)
     ( origen  ?origen ) )

  ?subtotales <- ( subtotales
    ( mostrado   false)
    ( totalizado false)
    ( cuenta ?nombre )
    ( debe ?total_debe)
    ( haber ?total_haber) )
   
  ( test (and (neq nil ?partida) (> ?partida 0)))
  ( test (or (> ?debe 0) (> ?haber 0)))
 =>
  ( printout t ?partida tab ?debe tab "|" tab ?haber crlf )
  ( modify ?cuenta (mostrado-en-t true ))
  ( modify ?subtotales
       (debe  (+ ?total_debe  ?debe))
       (haber (+ ?total_haber ?haber)))
)  



( defrule encabezado
  ?s <- (subtotales (cuenta ?nombre) (totalizado false))
(no)
  ?cuenta <- ( cuenta
     ( grupo patrimonio)
     ( partida nil)
     ( mostrado-en-t false)
     ( nombre ?nombre)
     ( origen real)
     ( saldo  ?saldo )
  )
  (not (exists (subtotales (cuenta ?nombre) (totalizado true))))
 =>
  ( printout t crlf crlf crlf )
  ( printout t ?nombre crlf )
  ( printout t "------- creando subtotales para " ?nombre " --------------------- " crlf)
  ( retract ?s)
  ( assert (subtotales (cuenta ?nombre)))
  ( assert ( hacer ?nombre))
)

( defrule encabezados-idpc
  (exists ( cuenta (nombre idpc) ))
  (not (exists ( hacer idpc)))
 =>  
  ( printout t crlf crlf crlf )
  ( printout t idpc crlf )
  ( printout t "------- creando subtotales para " idpc " --------------------- " crlf)
  ( assert ( subtotales (cuenta idpc)))
  ( assert ( hacer idpc))
) 

( defrule encabezados-utilidad
  ?s <- ( subtotales (cuenta utilidad))
  (not (exists (subtotales (cuenta utilidad) (totalizado true))))
  (not (exists ( hacer utilidad)))

 =>
  ( printout t crlf crlf crlf )
  ( printout t utilidad crlf )
  ( printout t "------- creando subtotales para " utilidad " --------------------- " crlf)
  ( retract ?s)
  ( assert ( subtotales (cuenta utilidad)))
  ( assert ( hacer utilidad))
)


( defrule encabezados-inventario
  ?s <- ( subtotales (cuenta ?nombre))
  (not (exists (subtotales (cuenta ?nombre) (totalizado true))))
  (test (eq ?nombre inventario))
  (not (exists ( hacer ?nombre)))

 =>
  ( printout t crlf crlf crlf )
  ( printout t utilidad crlf )
  ( printout t "------- creando subtotales para " ?nombre " --------------------- " crlf)
  ( retract ?s)
  ( assert ( subtotales (cuenta ?nombre)))
  ( assert ( hacer ?nombre))
)



( defrule encabezados-utilidad-tributaria
  (not (exists (subtotales (cuenta utilidad-tributaria) (totalizado true))))
  ?s <- (subtotales (cuenta utilidad-tributaria))
  (not (exists ( hacer utilidad-tributaria)))

 =>
  ( printout t crlf crlf crlf )
  ( printout t utilidad-tributaria crlf )
  ( printout t "------- creando subtotales para " utilidad-tributaria " --------------------- " crlf)
  ( retract ?s)
  ( assert (subtotales (cuenta utilidad-tributaria)))
  ( assert ( hacer utilidad-tributaria))
)

( defrule t-filas
;  ( cuenta (partida nil) (nombre ?nombre) (grupo ?grupo&:(or liquidadora tributario patrimonio pasivo)))
  ( empresa (nombre ?empresa))

  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))

  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  ?hacer  <- ( hacer ?nombre )

  ?cuenta <- ( cuenta 
     ( grupo ?grupo)
     ( circulante ?circulante)
     ( nombre ?nombre)
     ( partida ?partida) 
     ( debe    ?debe)
     ( haber   ?haber)
     ( origen  ?origen)
     ( mostrado-en-t false)
      )

  ?subtotales <- ( subtotales
    ( mostrado   false)
    ( totalizado false)
    ( cuenta ?nombre )
    ( debe ?total_debe)
    ( haber ?total_haber) )

  ( test (and (neq nil ?partida) (> ?partida 0)))

 =>
  ( printout t ?partida tab ?debe tab "|" tab ?haber tab ?grupo tab ?circulante tab ?origen crlf )
  ( modify ?cuenta (mostrado-en-t true ))
  ( modify ?subtotales
       (debe  (+ ?total_debe  ?debe))
       (haber (+ ?total_haber ?haber)))
)


( defrule t-diferencia-deudora
   ( cuenta (nombre ?nombre) (grupo ?grupo&:(or tributario patrimonio pasivo)))

   ?subtotales <- ( subtotales
     ( cuenta ?nombre)
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
   ( modify ?subtotales (deber ?diferencia) (totalizado true) (acreedor 0))
)



( defrule t-diferencia-acreedora
   ( cuenta (nombre ?nombre) (grupo ?grupo&:(or patrimonio pasivo)))
   ?subtotales <- ( subtotales
     ( cuenta ?nombre)
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
   ( modify ?subtotales (acreedor ?diferencia) (totalizado true) (deber 0))
)



( defrule t-footer-deudor
  ( cuenta (nombre ?nombre) (grupo ?grupo&:(or tributario patrimonio pasivo)))
  ?subtotales <- ( subtotales 
    ( cuenta ?nombre)
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
   ( modify ?subtotales (mostrado true))

)



( defrule t-footer-acreedor
  ( cuenta (nombre ?nombre) (grupo ?grupo&:(or tributario patrimonio pasivo)))
  ?subtotales <- ( subtotales
    ( cuenta ?nombre)
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
   ( modify ?subtotales (mostrado true))
)



