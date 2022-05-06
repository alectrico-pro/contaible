( defmodule RESULTADO-SII ( import MAIN deftemplate ?ALL))

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



( defrule inicio-de-modulo-comprobacion
   (declare (salience 10000))
  =>
   ( printout t "--modulo--------------- RESULTADO SII------------------" crlf)
)


;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-comprobacionb-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))

  =>

   ( bind ?archivo (str-cat "./doc/" ?empresa "/resultado-sii.markdown"))
   ( open ?archivo k "w")

   ( printout k "--- " crlf)
   ( printout k "title: Estado de Resultados SII" crlf)
 ;  ( printout k "permalink: /" ?empresa "/resultado sii" crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
;   ( printout k "<h1> Estado de Resultados para Impuestos Internos </h1> " crlf)
)

(defrule fin-kindle-k
  ( declare (salience -10000) )
 =>
  ( close k )
)




;----------------- R E S U L T A D O  S I I ---------------------------------------------------------

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
;  ( printout k "<style> tfoot {  border: 3px solid black;  } </style> " crlf)
  ( printout k "<tr> <td></td><td colspan='4'> E S T A D O  DE R E S U L T A D O S </td> </tr>" crlf)
  ( printout k "<tr> <td></td><td colspan='4'> " ?empresa "</td></tr>" crlf)

  ( printout k "<tr> <td></td><td> </td> <td align='center' colspan= '2'>SUMAS</td><td> Padre </td> </tr>" crlf)
  ( printout k "<tr> <td></td><td></td>  <td>DEBER</td> <td>ACREEDOR</td> </tr>" crlf)

  ( printout k "<tbody>" crlf)

)




(defrule balance-filas-sin-revisar
  ( declare (salience -8000))
  (no )
  ( empresa (nombre ?empresa))

  (cuenta (nombre ?cuenta) (mes ?mes) (nombre-sii ?nombre-sii))

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
  ( printout k "<td>" ?mes "</td><td>" ?nombre-sii "<small>" ?cuenta "</small> </td> <td align='right'>" ?debe "</td> <td align='right'>" ?haber "</td> <td> | </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> </tr>" crlf )


)

(defrule balance-filas-que-requieren-correcciones
  ( declare (salience -8000))
  (no)
  ( empresa (nombre ?empresa))

  (cuenta (nombre ?cuenta) (mes ?mes) (nombre-sii ?nombre-sii))

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

  ( printout k "<td> " ?mes "</td><td>" ?nombre-sii "<small>" ?cuenta" </small></td> <td align='right'>" ?debe "</td> <td align='right'>" ?haber "</td>" crlf)

  ( printout k "</tr>" crlf)
)


(defrule balance-filas-que-no-requieren-correcciones
  ( declare (salience -9000))
  (no)
  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (padre ?padre) (debe ?debe) (haber ?haber) (nombre-sii ?nombre-sii))

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

  ( printout k "<td> " ?mes "</td>  <td> <small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre " </td> " crlf)

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
  ( printout k "<tr> <td></td><td colspan='4'> T O T A L    A C T I V O  </td> <td> " ?total "</td> </tr>" crlf)
)



;----------------------------------------------------------------------------------------


(defrule titulo-activo-fijo
  ( declare (salience -7990))
  ?totales <- (totales
   ( activo-fijo ?total) )


 =>
  ( printout k "<tr> <td></td><td colspan='4'> A C T I V O    F I J O</td> <td> " ?total "</td> </tr>" crlf)
)

;--------------------------------------------------------------------------------
(defrule titulo-activo-circulante
  ( declare (salience -7990))
  ?totales <- (totales
   ( activo-circulante ?total) )


 =>
  ( printout k "<tr> <td></td><td colspan='4'> A C T I V O    C I R C U L A N T E</td> <td> " ?total "</td> </tr>" crlf)
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
  ( printout k "<tr> <td></td><td>" ?nombre "</td><td> " ?deber "</td> </tr>" crlf)
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
  ( printout k "<tr> <td></td><td colspan='4'> G A S T O S    P R O M O C I O N A L E S </td> <td> " ?deber "</td> </tr>" crlf)
)




(defrule balance-filas-de-gastos-promocionales
  ( declare (salience -8002))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (padre ?padre) (nombre-sii ?nombre-sii))

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
  ( printout k "<td> " ?mes "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)

(defrule balance-filas-de-gastos-promocionales-casos
  ( declare (salience -8002))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (partida ?partida) ( debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))

  (test (eq ?padre gastos-promocionales))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ?debe tab ?haber tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?mes "</td><td><a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
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
  ( printout k "<tr> <td></td><td colspan='4'> G A S T O S     A D M I N I S T R A T I V O S </td> <td> " ?deber "</td></tr>" crlf)
)



(defrule balance-filas-de-gastos-administrativos
  ( declare (salience -8004))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (padre ?padre) (nombre-sii ?nombre-sii))

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
  ( printout k "<td>" ?mes "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)

(defrule balance-filas-de-gastos-administrativos-casos
  ( declare (salience -8004))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre gastos-administrativos ))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ?debe tab ?haber tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?mes "</td><td><a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
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
  ( printout k "<tr> <td></td><td colspan='4'> I N T A N G I B L E S </td> <td>" ?deber "</td> </tr>" crlf)
)


(defrule balance-filas-de-intangibles
  ( declare (salience -8007))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (padre ?padre) (nombre-sii ?nombre-sii))

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
  ( printout k "<td>" ?mes "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)

(defrule balance-filas-de-intangibles-casos
  ( declare (salience -8007))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (partida ?partida) (mes ?mes) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre intangibles ))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ------ tab ----- tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?mes "</td><td> <a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
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
  ( printout k "<tr> <td></td><td colspan='4'> C O R R E C C I O N    M O N E T A R I A</td><td> " ?acreedor "</td> </tr>" crlf)
)



(defrule balance-filas-de-correccion-monetaria
  ( declare (salience -8010))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (padre ?padre) (nombre-sii ?nombre-sii))

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
  ( printout k "<td>" ?mes "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)


(defrule balance-filas-de-correccion-monetaria-casos
  ( declare (salience -8010))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre correccion-monetaria))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ------ tab ----- tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?mes "</td><td> <a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
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
  ( printout k "<tr> <td></td><td colspan='4'> C O S T O S   D E    V E N T A S </td> <td> " ?deber "</td></tr>" crlf)
)



(defrule balance-filas-de-costos-de-ventas
  ( declare (salience -8014))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (padre ?padre) (nombre-sii ?nombre-sii))

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
  ( printout k "<td> " ?mes "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)
)


(defrule balance-filas-de-costo-de-ventas-casos
  ( declare (salience -8014))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
 ;( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre costos-de-ventas ))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ------ tab ----- tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?mes "</td><td> <a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
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

  ( printout k "<tr> <td></td><td colspan='4'> I N S U M O S</td> <td>" ?deber "</td></tr>" crlf)
)




(defrule balance-filas-de-insumos
  ( declare (salience -8016))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (padre ?padre) (nombre-sii ?nombre-sii))

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
  ( printout k "<td> " ?mes "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)

)



(defrule balance-filas-de-insumos-casos
  ( declare (salience -8016))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre insumos ))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ------ tab ----- tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?mes "</td><td><a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
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
  ( printout k "<tr> <td></td><td colspan='4'> M A T E R I A L E S </td> <td> " ?deber "</td> </tr>" crlf)
)



(defrule balance-filas-de-materiales
  ( declare (salience -8019))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (padre ?padre) (nombre-sii ?nombre-sii))

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
  ( printout k "<td> " ?mes "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)
)


(defrule balance-filas-de-materiales-casos
  ( declare (salience -8019))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (partida ?partida) ( debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
; ( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))

  (test (eq ?padre materiales))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ?debe tab ?haber tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?mes "</td><td><a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a></td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
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
  ( printout k "<tr> <td></td><td colspan='4'> V E N T A S </td><td> " ?acreedor "</td> </tr>" crlf)
)



(defrule balance-filas-de-ventas
  ( declare (salience -8025))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (padre ?padre) (nombre-sii ?nombre-sii))
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
  ( printout k "<td>" ?mes "</td><td><small> " ?cuenta  " </small> </td> <td align='right'> " ?deber  "</td> <td align='right'>" ?acreedor "</td> <td> " ?padre "</td>" crlf)
  ( printout k "</tr>" crlf)
)


(defrule balance-filas-de-ventas-casos
  ( declare (salience -8025))

  ( empresa (nombre ?empresa))
  ( cuenta (nombre ?cuenta) (mes ?mes) (partida ?partida) (debe ?debe) (haber ?haber) (padre ?padre) (nombre-sii ?nombre-sii))
 ;( revision (cuenta ?cuenta) (revisado true) )
  ( test (neq 0 (- ?haber ?debe) ))
  ( test (eq ?padre ventas ))

  =>

  ( printout t tab ?partida tab ?debe tab ?haber tab "|" tab ------ tab ----- tab ?cuenta crlf)
  ( printout k "<tr style='background-color: lavender'>" crlf)
  ( printout k "<td> " ?mes "</td><td><a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a></td> <td><small> " ?cuenta  " </small> </td> <td align='right'> " ?debe  "</td> <td align='right'>" ?haber "</td> <td> " ?padre "</td>" crlf)
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

