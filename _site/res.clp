( defmodule RESULTADO-SII ( import MAIN deftemplate ?ALL))

;---- este modulo se concentra en presentar en forma de T el comportamiento de las partidas para cada cuenta
;---- también totaliza sumas calificadas para alimentar al balance inicial y a otros informes
;---- los hechos de totales y subtotales ayudan a obtener los estados de síntesis para cada nivel de agregación
;---- la granularidad de los datos es a nivel de partida, donde intervienen las cuentas.
;---- luego las cuentas tienen diferentes estados que han sido establecidos por los movimientos entre cuentas de cada partida
;---- hay un resumen por cuentas, sin clasificarlas por estados, solo un listado con debe, haber, y los valora canonizados 
;---- deber y acreedor

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


( defrule inicio-de-modulo-T
   (declare (salience 10000))
  =>
   ( printout t "--módulo----------------------- T ----------------------" crlf)
   ( set-strategy depth )
)


(defrule fin-modulo-T
  (declare (salience -10000))
 =>
  ( printout t "--módulo----resumen------------ T ----------------------" crlf)
)


;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-t-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))
  =>

   ( bind ?archivo (str-cat "./doc/" ?empresa "/libro-mayor.markdown"))
   ( open ?archivo k "w")

   ( printout k "--- " crlf)
   ( printout k "title: L.Mayor-" ?empresa crlf)
   ( printout k "permalink: /" ?empresa "/libro-mayor " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
)

(defrule fin-kindle-k
  ( declare (salience -100) )
 =>
  ( close k )
)

( defrule encabezado
  ;para no repetir los encabezados,
  ;se busca que haya dos matchs con líneas
  ; la primera con una partida nil, esa es la que se pone en la bibilioteca (cuentas.txt)
  ; y otras con partida que no sea nil, 
  ; La condición resulta así: cuando haya al menos una partida no nula de una cuenta que ya exista en la biblioteca y que nunca haya sido mostrada en t
  ;
?cuenta <- ( cuenta
    ( partida ?Numero & nil )
    ( nombre ?nombre)
    ( nombre-sii ?nombre-sii)
    ( descripcion ?descripcion)
    ( origen real   )
 )

  (exists
    ( cuenta
      ( mostrado-en-t false)
      ( nombre  ?nombre)
      ( partida ?Numero2 & ~?Numero)
      ( saldo ?saldo )
    )
  ) 
 =>
  ( printout t crlf crlf crlf )
  ( printout t ?nombre crlf )
  ( printout t "---------------------------- recibida activo-fijo tipo-de-documento" crlf)


  ( printout k "<table>" crlf)
  ( printout k "<thead><th colspan='6'> " ?nombre "</th><th colspan='3'>" ?nombre-sii "</th></thead>" crlf)
  ( printout k "<thead><th colspan='9'> " ?descripcion "</th></thead>" crlf)

  ( printout k "<thead><th> voucher </th><th> partida </th><th> debe </th> <th> | </th> <th> haber </th><th> mes </th> <th>recibida</th> <th>activo-fijo</th> <th> tipo documento</th></thead>"crlf)
  ( printout k "<tbody>" crlf)


  ( assert ( hacer ?nombre))
  ( assert ( subtotales ( cuenta ?nombre)))
)

 
( defrule t-filas

  ( empresa (nombre ?empresa))
  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  ?hacer  <- ( hacer ?nombre )

  ?cuenta <- ( cuenta 
     ( recibida ?recibida )
     ( tipo-de-documento ?tipo-de-documento)
     ( activo-fijo ?activo-fijo)
     ( nombre ?nombre)
     ( partida ?partida) 
     ( debe    ?debe)
     ( haber   ?haber)
     ( mes  ?mes)
     ( mostrado-en-t false)
     ( origen  real ) )

   (revision
     ( partida ?partida)
     ( voucher ?voucher))

  ?subtotales <- ( subtotales
    ( mostrado   false)
    ( totalizado false)
    ( cuenta ?nombre )
    ( debe ?total_debe)
    ( haber ?total_haber) )

  ( test (and (neq nil ?partida) (> ?partida 0)))
;  ( test (or (> ?total_debe 0) (> ?total_haber 0)))
 =>
  ( printout t ?partida tab ?debe tab "|" tab ?haber tab ?mes tab ?recibida tab ?activo-fijo tab ?tipo-de-documento crlf )

  ( printout k "<tr> <td>" ?voucher "</td> <td align='right'>" ?partida "</td> <td align='right'>" ?debe "</td> <td> | </td> <td align='right'> " ?haber  "</td> <td>" ?mes "</td><td>" ?recibida "</td><td> " ?activo-fijo "</td><td> " ?tipo-de-documento "</td> </tr>" crlf )

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
   ( modify ?subtotales (deber ?diferencia) (totalizado true) (acreedor 0))
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
   ( modify ?subtotales (acreedor ?diferencia) (totalizado true) (deber 0))
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

   ( printout k "<tr> <td></td> <td></td> <td align='right' >" ?debe "</td> <td>|</td> <td align='right'>" ?haber "</td></tr>" crlf )
   ( printout k "<tr> <td></td> <td>$</td> <td align='right'>"  ?diferencia "</td></tr>" crlf )

   ( printout k "</tbody>" crlf)
   ( printout k "</table>" crlf)
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

   ( printout k "<tr> <td> </td><td></td> <td align='right'>" ?debe "</td> <td>|</td> <td align='right'>" ?haber "</td> </tr>" crlf )
   ( printout k "<tr> <td> </td><td> </td> <td></td> <td>|</td> <td align='right'>"  ?diferencia "</td> <td>$</td> </tr>" crlf )

   ( printout k "</tbody>" crlf)
   ( printout k "</table>" crlf)
)




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

   ( bind ?archivo (str-cat "./doc/" ?empresa "/resultado-sii.markdown"))
   ( open ?archivo k "w")

   ( printout k "--- " crlf)
   ( printout k "title: RESULTADO-SII-" ?empresa crlf)
   ( printout k "permalink: /" ?empresa "/resultado sii" crlf)
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

   ( printout t crlf crlf "           RESULTADO SII año: " ?ano crlf)
   ( printout t tab tab SUMAS tab tab "|" tab SALDOS crlf )
   ( printout t tab tab DEBE tab HABER tab "|" tab DEBER tab ACREEDOR crlf)
   ( printout t "---------------------------------------------------------------------" crlf)


   ( printout k crlf crlf )
   ( printout k "Solo se consideran las transacciones hasta el día " ?dia tab ?mes "."  crlf)
   ( printout k "Cifras en pesos." crlf)
   ( printout k "Se han practicado liquidaciones, por lo que NO se muestran cuentas nominales"  crlf)


  ( printout k "<table rules='groups'>" crlf)
  ( printout k "<style> tfoot {  border: 3px solid black;  } </style> " crlf)
  ( printout k "<thead> <th></th><th colspan='4'> E S T A D O  DE R E S U L T A D O S </th> </thead>" crlf)
  ( printout k "<thead> <th></th><th colspan='4'> " ?empresa "</th></thead>" crlf)

  ( printout k "<thead> <th></th><th> </th> <th align='center' colspan= '2'>SUMAS</th><th> Padre </th> </thead>" crlf)
  ( printout k "<thead> <th></th><th></th>  <th>DEBER</th> <th>ACREEDOR</th> </thead>" crlf)

  ( printout k "<tbody>" crlf)

)




(defrule balance-filas-sin-revisar
  ( declare (salience -8000))
  (no )
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
  (no)
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
; ( printout k "<td>" ?nombre-sii "<small>" ?cuenta" </small></td> <td align='right'>" ?debe "</td> <td align='right'>" ?haber "</td> <td> | </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> " crlf)
; ( printout k "<td colspan='2' style=' background: #faa; border: 1px solid red;'>" ?a-corregir " </td>" crlf)

  ( printout k "<td>" ?nombre-sii "<small>" ?cuenta" </small></td> <td align='right'>" ?debe "</td> <td align='right'>" ?haber "</td>" crlf)

  ( printout k "</tr>" crlf)
)


(defrule balance-filas-que-no-requieren-correcciones
  ( declare (salience -9000))
  (no)
  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (padre ?padre) (debe ?debe) (haber ?haber) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
  ( acreedor ?acreedor) )

; (revision (cuenta ?cuenta) (revisado true) )

  (test (neq false ?padre))
  =>
  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)

  ( printout k "<tr>" crlf)
;  ( printout k "<td>" ?nombre-sii "<small> " ?cuenta  " </small> </td> <td align='right'>" ?debe "</td> <td align='right'>" ?haber "</td> <td align='right'> | </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td>" crlf)

  ( printout k "<td> <small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre " </td> " crlf)

  ( printout k "</tr>" crlf)

)





(defrule titulo-activo-circulante
  ( declare (salience -7990))
  ?totales <- (totales
   ( activo-circulante ?total) )
 =>
  ( printout k "<thead> <th></th><th colspan='4'> A C T I V O    C I R C U L A N T E</th> <th> " ?total "</th> </thead>" crlf)
)

;----------------------------------------------------------------------------------------


(defrule titulo-activo
  ( declare (salience -7990))
  ?totales <- (totales
   ( activos ?total) )


 =>
  ( printout k "<thead> <th></th><th colspan='4'> T O T A L    A C T I V O  </th> <th> " ?total "</th> </thead>" crlf)
)



;----------------------------------------------------------------------------------------


(defrule titulo-activo-fijo
  ( declare (salience -7990))
  ?totales <- (totales
   ( activo-fijo ?total) )


 =>
  ( printout k "<thead> <th></th><th colspan='4'> A C T I V O    F I J O</th> <th> " ?total "</th> </thead>" crlf)
)

;--------------------------------------------------------------------------------
(defrule titulo-activo-circulante
  ( declare (salience -7990))
  ?totales <- (totales
   ( activo-circulante ?total) )


 =>
  ( printout k "<thead> <th></th><th colspan='4'> A C T I V O    C I R C U L A N T E</th> <th> " ?total "</th> </thead>" crlf)
)

(defrule titulo-activos-con-partida
  ( declare (salience -7990))
  
  ?subtotales <- (subtotales
   ( cuenta   ?nombre)
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

   ( exists (cuenta (nombre ?nombre) (grupo activo) (padre false) (partida ?partida&:(neq nil ?partida))))

 =>
  ( printout k "<thead> <th></th><th>" ?nombre "</th><th> " ?deber "</th> </thead>" crlf)
)

(defrule titulo-gastos-promocionales
  ( declare (salience -8000))
  ?subtotales <- (subtotales
   ( cuenta   gastos-promocionales)
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )


 => 
  ( printout k "<thead> <th></th><th colspan='4'> G A S T O S    P R O M O C I O N A L E S </th> <th> " ?deber "</th> </thead>" crlf)
)




(defrule balance-filas-de-gastos-promocionales
  ( declare (salience -8002))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (padre ?padre) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

; ( revision (cuenta ?cuenta) (revisado true) )

  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre gastos-promocionales))

  =>

  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)
  ( printout k "<tr  style='background-color: lightyellow'>" crlf)
  ( printout k "<td></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)

(defrule balance-filas-de-gastos-promocionales-casos
  ( declare (salience -8002))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (partida ?partida) ( debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))

  (test (eq ?padre gastos-promocionales))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ?debe tab ?haber tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td>" ?partida "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)

;------------------------------------------------------------------------------------------
(defrule titulo-gastos-administrativos
  ( declare (salience -8003))
  ?subtotales <- (subtotales
   ( cuenta   gastos-administrativos)
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

 =>
  ( printout k "<thead> <th></th><th colspan='4'> G A S T O S     A D M I N I S T R A T I V O S </th> <th> " ?deber "</th></thead>" crlf)
)



(defrule balance-filas-de-gastos-administrativos
  ( declare (salience -8004))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (padre ?padre) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

; ( revision (cuenta ?cuenta) (revisado true) )

  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre gastos-administrativos))

  =>

  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)
  ( printout k "<tr  style='background-color: lightyellow'>" crlf)
  ( printout k "<td></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)

(defrule balance-filas-de-gastos-administrativos-casos
  ( declare (salience -8004))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre gastos-administrativos ))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ?debe tab ?haber tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?partida "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)

;--------------------------------------------------------------------------

(defrule titulo-intangibles
  ( declare (salience -8006))
  ?subtotales <- (subtotales
   ( cuenta   intangibles)
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

 =>
  ( printout k "<thead> <th></th><th colspan='4'> I N T A N G I B L E S </th> <th>" ?deber "</th> </thead>" crlf)
)


(defrule balance-filas-de-intangibles
  ( declare (salience -8007))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (padre ?padre) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

; ( revision (cuenta ?cuenta) (revisado true) )

  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre intangibles))

  =>

  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)

  ( printout k "<tr style='background-color: lightyellow'>" crlf)
  ( printout k "<td></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)

(defrule balance-filas-de-intangibles-casos
  ( declare (salience -8007))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre intangibles ))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ------ tab ----- tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?partida "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)

;----------------------------------- CORRECCIÓN MONETARIA -------------------------

(defrule titulo-correccion-monetaria
  ( declare (salience -8009))
  ?subtotales <- (subtotales
   ( cuenta   correccion-monetaria)
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

 =>
  ( printout k "<thead> <th></th><th colspan='4'> C O R R E C C I O N    M O N E T A R I A</th><th> " ?acreedor "</th> </thead>" crlf)
)



(defrule balance-filas-de-correccion-monetaria
  ( declare (salience -8010))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (padre ?padre) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre correccion-monetaria))

  =>

  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)
  ( printout k "<tr  style='background-color: lightyellow'>" crlf)
  ( printout k "<td></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)


(defrule balance-filas-de-correccion-monetaria-casos
  ( declare (salience -8010))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre correccion-monetaria))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ------ tab ----- tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?partida "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)


;-----------------------------------------------------------------------------------------------
(defrule titulo-costos-de-ventas
  ( declare (salience -8012))
  ?subtotales <- (subtotales
   ( cuenta   costos-de-ventas)
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

 =>
  ( printout k "<thead> <th></th><th colspan='4'> C O S T O S   D E    V E N T A S </th> <th> " ?deber "</th></thead>" crlf)
)



(defrule balance-filas-de-costos-de-ventas
  ( declare (salience -8014))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (padre ?padre) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre costos-de-ventas))

  =>

  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)
  ( printout k "<tr  style='background-color: lightyellow'>" crlf)
  ( printout k "<td></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)
)


(defrule balance-filas-de-costo-de-ventas-casos
  ( declare (salience -8014))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
 ;( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre costos-de-ventas ))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ------ tab ----- tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?partida "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)


(defrule titulo-insumos
  ( declare (salience -8015))
  ?subtotales <- (subtotales
   ( cuenta   insumos)
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

 =>

  ( printout k "<thead> <th></th><th colspan='4'> I N S U M O S</th> <th>" ?deber "</th></thead>" crlf)
)




(defrule balance-filas-de-insumos
  ( declare (salience -8016))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (padre ?padre) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

; ( revision (cuenta ?cuenta) (revisado true) )

  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre insumos))

  =>

  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)
  ( printout k "<tr  style='background-color: lightyellow'>" crlf)
  ( printout k "<td></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)



(defrule balance-filas-de-insumos-casos
  ( declare (salience -8016))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre insumos ))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ------ tab ----- tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?partida "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)


;-------------------------------------------------------------------------------------

(defrule titulo-materiales
  ( declare (salience -8018))
  ?subtotales <- (subtotales
   ( cuenta   materiales)
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber) 
   ( acreedor ?acreedor) )

  
 =>
  ( printout k "<thead> <th></th><th colspan='4'> M A T E R I A L E S </th> <th> " ?deber "</th> </thead>" crlf)
)



(defrule balance-filas-de-materiales
  ( declare (salience -8019))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (padre ?padre) (nombre-sii ?nombre-sii))

  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

; ( revision (cuenta ?cuenta) (revisado true) )

  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre materiales))

  =>

  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)
  ( printout k "<tr  style='background-color: lightyellow'>" crlf)
  ( printout k "<td></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)
)


(defrule balance-filas-de-materiales-casos
  ( declare (salience -8019))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (partida ?partida) ( debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))

  (test (eq ?padre materiales))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ?debe tab ?haber tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td>" ?partida "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)
)


;-------------------------- V E N T A S ---------------------------------------
(defrule titulo-ventas
  ( declare (salience -8024))
  ?subtotales <- (subtotales
   ( cuenta   ventas)
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )

 =>
  ( printout k "<thead> <th></th><th colspan='4'> V E N T A S </th><th> " ?acreedor "</th> </thead>" crlf)
)



(defrule balance-filas-de-ventas
  ( declare (salience -8025))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (padre ?padre) (nombre-sii ?nombre-sii))
  ?subtotal <- (subtotales
   ( mostrado false )
   ( cuenta   ?cuenta )
   ( debe     ?debe)
   ( haber    ?haber)
   ( deber    ?deber)
   ( acreedor ?acreedor) )
;  ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre ventas ))

  =>

  ( modify ?subtotal (mostrado true))
  ( printout t tab tab ?debe tab ?haber tab "|" tab ?deber tab ?acreedor tab ?cuenta crlf)
  ( printout k "<tr  style='background-color: lightyellow'>" crlf)
  ( printout k "<td></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)
)


(defrule balance-filas-de-ventas-casos
  ( declare (salience -8025))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
 ;( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre ventas ))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ------ tab ----- tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?partida "</td> <td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)
)




(defrule balance-subtotales
  ( declare (salience -9000))
  (no)
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
  (no)
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

