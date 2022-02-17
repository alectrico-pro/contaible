( defmodule COMPROBACIONB ( import MAIN deftemplate ?ALL))

;---- este modulo se concentra en presentar en forma de T el comportamiento de las partidas para cada cuenta
;---- también totaliza sumas calificadas para alimentar al balance inicial y a otros informes
;---- los hechos de totales y subtotales ayudan a obtener los estados de síntesis para cada nivel de agregación
;---- la granularidad de los datos es a nivel de partida, donde intervienen las cuentas.
;---- luego las cuentas tienen diferentes estados que han sido establecidos por los movimientos entre cuentas de cada partida
;---- hay un resumen por cuentas, sin clasificarlas por estados, solo un listado con debe, haber, y los valora canonizados 
;---- deber y acreedor


(defrule provision-de-idpc
   ( no)
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ( subtotales (cuenta idpc) (acreedor ?acreedor) )
;   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 enero ?ano_top)))
  =>

   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?top) (mes ?mes_top) (ano ?ano_top) (descripcion (str-cat "Provisionando idpc en " ?mes_top)) ( actividad provision-de-idpc)))

   ( assert (cargo (tipo-de-documento provision-de-idpc) (cuenta idpc) (partida ?numero) (dia ?top) (mes ?mes_top) (ano ?ano_top) (empresa ?empresa) (monto ?acreedor) (glosa (str-cat por-provision-de-idpc ?acreedor))))
   ( assert (abono (tipo-de-documento provision-de-idpc) (cuenta provision-impuesto-a-la-renta) (partida ?numero) (dia ?top) (mes ?mes_top) (ano ?ano_top) (empresa ?empresa) (monto ?acreedor) (glosa (str-cat por-provision-de-idpc ?acreedor))))

   ( printout t "-->idpc-provisiona " tab ?acreedor tab ?mes_top crlf)
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



( defrule inicio-de-modulo-comprobacion
   (declare (salience 10000))
  =>
;   ( matches provision-de-idpc)
;   ( halt )
   ( printout t "--modulo--------------- COMPROBACION B------------------" crlf)
)


;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-comprobacionb-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))

  =>

   ( bind ?archivo (str-cat "./doc/" ?empresa "/comprobacionb.markdown"))
   ( open ?archivo k "w")

   ( printout k "--- " crlf)
   ( printout k "title: Saldos-B-" ?empresa crlf)
   ( printout k "permalink: /" ?empresa "/comprobacion b " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
)

(defrule fin-kindle-k
  ( declare (salience -10000) )
 =>
  ( close k )
)




;----------------- B A L A N C E ---------------------------------------------------------

(defrule balance-encabezado
   ( declare (salience -7000))
   ( empresa (nombre ?empresa))
   ( balance (dia ?dia) (mes ?mes) (ano ?ano))

  =>
   ( printout t crlf crlf )
   ( printout t "Solo se consideran las transacciones hasta el día " ?dia tab ?mes "."  crlf)
   ( printout t "Cifras en pesos." crlf)
   ( printout t "Se han practicado liquidaciones, por lo que NO se muestran cuentas nominales, ni subcuentas reales"  crlf)

   ( printout t crlf crlf "           B A L A N C E  DE COMPROBACION DE SUMAS Y SALDOS año: " ?ano crlf)
   ( printout t tab tab SUMAS tab tab "|" tab SALDOS crlf )
   ( printout t tab tab DEBE tab HABER tab "|" tab DEBER tab ACREEDOR crlf)
   ( printout t "---------------------------------------------------------------------" crlf)


   ( printout k crlf crlf )
   ( printout k "Solo se consideran las transacciones hasta el día " ?dia tab ?mes "."  crlf)
   ( printout k "Cifras en pesos." crlf)
   ( printout k "Se han practicado liquidaciones, por lo que NO se muestran cuentas nominales"  crlf)


  ( printout k "<table rules='groups'>" crlf)
  ( printout k "<style> tfoot {  border: 3px solid black;  } </style> " crlf)
  ( printout k "<thead><th colspan='7'> B A L A N C E  DE COMPROBACION DE SUMAS Y DE SALDOS </th> </thead>" crlf)
  ( printout k "<thead> <th colspan='7'> " ?empresa "</th></thead>" crlf)

  ( printout k "<thead> <th> </th> <th align='center' colspan= '2'>SUMAS</th> <th>|</th> <th align='center' colspan='2'>SALDOS</th> <th rowspan='2' > Errores </th> </thead>" crlf)
  ( printout k "<thead> <th></th>  <th>DEBE</th> <th>HABER</th> <th>|</th> <th>DEBER</th> <th>ACREEDOR</th> <th>A Corregir </th> </thead>" crlf)

  ( printout k "<tbody>" crlf)

)




(defrule balance-filas-sin-revisar
  ( declare (salience -8000))
  ( empresa (nombre ?empresa))

  (cuenta (nombre ?cuenta) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

  ( not (exists (revision (cuenta ?cuenta))))

  (test (neq ?cuenta ingresos-brutos))
  (test (neq ?cuenta ventas))
  (test (neq 0 (- ?haber ?debe) ))
  =>
  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)

  ( printout k "<tr style=' background: #fff; border: 1px solid red;'>" crlf)
  ( printout k "<td>" ?nombre-sii "<small>" ?cuenta "</small> </td> <td align='right'>" ?debe "</td> <td align='right'>" ?haber "</td> <td> | </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> </tr>" crlf )


)

(defrule balance-filas-que-requieren-correcciones
  ( declare (salience -8000))
  ( empresa (nombre ?empresa))

  (cuenta (nombre ?cuenta) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )
  (revision (cuenta ?cuenta) (revisado false) (a-corregir ?a-corregir))

  (test (neq ?cuenta ingresos-brutos))
  (test (neq ?cuenta ventas))
  (test (neq 0 (- ?haber ?debe) ))


  =>
  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)
  ( printout k "<tr>" crlf)
  ( printout k "<td>" ?nombre-sii "<small>" ?cuenta" </small></td> <td align='right'>" ?debe "</td> <td align='right'>" ?haber "</td> <td> | </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> " crlf)
  ( printout k "<td colspan='2' style=' background: #faa; border: 1px solid red;'>" ?a-corregir " </td>" crlf)
  ( printout k "</tr>" crlf)
)

(defrule balance-filas-que-no-requieren-correcciones
  ( declare (salience -8000))
  ( empresa (nombre ?empresa))
  (cuenta (nombre ?cuenta) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )
  (revision (cuenta ?cuenta) (revisado true) )

  (test (neq ?cuenta ingresos-brutos))
  (test (neq ?cuenta ventas))
  (test (neq 0 (- ?haber ?debe) ))

  =>
  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)

  ( printout k "<tr>" crlf)
  ( printout k "<td>" ?nombre-sii "<small> " ?cuenta  " </small> </td> <td align='right'>" ?debe "</td> <td align='right'>" ?haber "</td> <td align='right'> | </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td>" crlf)
  ( printout k "</tr>" crlf)

)



(defrule balance-subtotales
  ( declare (salience -8000))
  ( empresa (nombre ?empresa))

  ?subtotales <- (subtotales
   ( mostrar-en-comprobacion true )
   ( mostrado true )
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

  (test (neq ?cuenta ingresos-brutos))
  (test (neq ?cuenta ventas))
  =>

   ( modify ?totales   (debe     (+ ?total_debe     ?debe)    )
                       (haber    (+ ?total_haber    ?haber)   )
                       (deber    (+ ?total_deber    ?deber)   )
                       (acreedor (+ ?total_acreedor ?acreedor)) )
   ( modify ?subtotales (mostrado-en-resumen true))
   ( assert ( hacer-balance-footer ))
)


(defrule balance-footer
  (declare (salience -10000))
  ?comando <-  ( hacer-balance-footer)
  ( empresa (nombre ?empresa))

;  (not (subtotales (mostrado-en-resumen false)))
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

   ( printout k "</tbody>" crlf)

   ( printout k "<tfoot>" crlf)
   ( printout k "<tr> <td></td> <td align='right'>" ?debe "</td> <td align='right'>" ?haber "</td><td> | </td> <td align='right'>" ?deber "</td> <td align='right'>" ?acreedor "</td> </tr>" crlf )
   ( printout k "</tfoot>" crlf)

   ( printout k "</table>" crlf)



;   ( printout t tab tab "* inventario es inventario inicial." crlf)
   ( retract ?comando)
)

