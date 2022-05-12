( defmodule SUBCUENTA ( import MAIN deftemplate ?ALL))

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
   ( printout t "--módulo----------------------- SUBCUENTAS ---------------------" crlf)
   ( set-strategy depth )
)


;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-sub-cuentas-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))
  =>

   ( bind ?archivo (str-cat "./doc/" ?empresa "/subcuentas.markdown"))
   ( open ?archivo k "w")

   ( printout k "--- " crlf)
   ( printout k "title: Subcuentas" crlf)
;   ( printout k "permalink: /" ?empresa "/subcuentas " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
;   ( printout k "<h1> Subcuentas </h1>" crlf)
)


( defrule encabezado

?cuenta <- ( cuenta
    ( partida ?Numero & nil )
   ( nombre ?nombre)
    ( padre ?padre )
    ( nombre-sii ?nombre-sii)
    ( descripcion ?descripcion)
    ( origen ?origen  )
 )

  (exists
    ( cuenta
      ( mostrado-en-t false)
      ( nombre  ?nombre)
      ( partida ?Numero2 & ~?Numero)
      ( saldo ?saldo )
    )
  ) 

;  ?cuenta <- ( cuenta
;     ( partida nil)
;     ( mostrado-en-t false)
;     ( nombre ?nombre)
;     ( origen nominativo)
;     ( padre ?padre )
;     ( saldo  ?saldo )
;  )
  (test (neq false ?padre))

 =>

  ( printout t crlf crlf crlf )
  ( printout t ?nombre "#" ?padre crlf )
  ( printout t "----------------------------" crlf)
  ( assert ( subtotales ( cuenta ?nombre)))
  ( assert ( hacer ?nombre))


  ( printout k "<table>" crlf)
  ( printout k "<tr><td colspan='6'> " ?nombre "</td><td colspan='3'>" ?nombre-sii "</td></tr>" crlf)
  ( printout k "<tr><td colspan='9'> " ?descripcion "</td></tr>" crlf)

  ( printout k "<tr><td> voucher </td><td> partida </td><td> debe </td> <td> | </td> <td> haber </td><td> mes </td> <td>recibida</td> <td>factor de corrección monetaria</td> <td> tipo documento</td></tr>"crlf)
  ( printout k "<tbody>" crlf)
)

( defrule t-filas-de-resultados


  ( empresa (nombre ?empresa))
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))

  ( partida (numero ?partida) (dia ?dia) (mes ?mes) (ano ?ano))

  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  ?hacer  <- ( hacer ?nombre )

  ?cuenta <- ( cuenta
     ( factor-de-correccion-monetaria ?factor)
     ( partida ?partida)
     ( nombre ?nombre)
     ( debe    ?debe)
     ( haber   ?haber)
     ( recibida ?recibida)
     ( activo-fijo ?activo-fijo)
     ( mes ?mes)
     ( tipo-de-documento ?tipo-de-documento)
     ( de-resultado true)
     ( mostrado-en-t false)
     ( origen  ?origen ) )

  ?subtotales <- ( subtotales
    ( mostrado   false)
    ( totalizado false)
    ( cuenta ?nombre )
    ( debe ?total_debe)
    ( haber ?total_haber) )

  (revision
     ( partida ?partida)
     ( voucher ?voucher))

  ( test (or (> ?debe 0) (> ?haber 0)))

 =>
  ( printout t "r " ?partida tab ?debe tab "|" tab ?haber crlf )

  ( printout k "<tr> <td>" ?voucher "</td> <td align='right'>" ?partida "</td> <td align='right'>" ?debe "</td> <td> | </td> <td align='right'> " ?haber  "</td> <td>" ?mes "</td><td>" ?recibida "</td><td> " ?factor "</td><td> " ?tipo-de-documento "</td> </tr>" crlf )
  ( modify ?cuenta (mostrado-en-t true ))
  ( modify ?subtotales
       (debe_corregido (* ?factor (+ ?total_debe  ?debe)))
       (haber_corregido (* ?factor (+ ?total_haber ?haber)))
       (debe  (+ ?total_debe  ?debe))
       (haber (+ ?total_haber ?haber)))
)


 
( defrule t-filas

  ( empresa (nombre ?empresa))
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
  ( partida (numero ?partida) (dia ?dia) (mes ?mes) (ano ?ano))

  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  ?hacer  <- ( hacer ?nombre )

  ?cuenta <- ( cuenta 
     ( factor-de-correccion-monetaria ?factor)
     ( tipo-de-documento ?tipo-de-documento)
     ( de-resultado false)
     ( nombre ?nombre)
     ( mes ?mes)
     ( partida ?partida) 
     ( recibida ?recibida)
     ( activo-fijo ?activo-fijo)
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

  (revision
     ( partida ?partida)
     ( voucher ?voucher))

  ( test (and (neq nil ?partida) (> ?partida 0)))
  ( test (or (> ?debe 0) (> ?haber 0)))

 =>

  ( printout t ?partida tab ?debe tab "|" tab ?haber tab ?mes tab tipo-de-documento tab ?tipo-de-documento crlf )
  ( printout k "<tr> <td>" ?voucher "</td> <td align='right'> <a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a> </td> <td align='right'>" ?debe "</td> <td> | </td> <td align='right'> " ?haber  "</td> <td>" ?mes "</td><td>" ?recibida "</td><td> " ?factor "</td><td> " ?tipo-de-documento "</td> </tr>" crlf )
  ( modify ?cuenta (mostrado-en-t true ))
  ( modify ?subtotales
       (debe_corregido  (* ?factor (+ ?total_debe ?debe)))
       (haber_corregido (* ?factor (+ ?total_haber ?haber)))
       (debe  (+ ?total_debe  ?debe))
       (haber (+ ?total_haber ?haber)))
)



( defrule t-diferencia-deudora
   ?subtotales <- ( subtotales
     ( mostrado false)
     ( haber ?haber )
     ( debe  ?debe )
     ( totalizado false) )
   ( test (> ?debe ?haber))

  =>

   ( bind ?diferencia (- ?debe ?haber ))
   ( modify ?subtotales (deber_corregido ?diferencia) (deber ?diferencia) (totalizado true))
)



( defrule t-diferencia-acreedora
   ?subtotales <- ( subtotales
     ( haber ?haber )
     ( debe  ?debe )
     ( totalizado false)
     ( mostrado false) )
   ( test (< ?debe ?haber))

  =>

   ( bind ?diferencia (- ?haber ?debe ))
   ( modify ?subtotales (acreedor ?diferencia) (acreedor_corregido ?diferencia) (totalizado true))

)



( defrule t-footer-deudor
  ?subtotales <- ( subtotales 
    ( haber ?haber )
    ( haber_corregido ?haber_corregido)
    ( debe  ?debe )
    ( debe_corregido ?debe_corregido)
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

   ( printout t "---------- CORRECCION MONETARIA ANUAL -----------" crlf)
   ( bind ?diferencia_corregida (- ?debe_corregido ?haber_corregido ))
   ( printout t "----------------------------" crlf)
   ( printout t tab ?debe_corregido tab "|" tab ?haber_corregido crlf ) 
   ( printout t tab "--------------------" crlf)
   ( printout t "$" tab ?diferencia_corregida crlf )
   ( printout t monto-de-correccion "$" tab (round (- ?diferencia_corregida ?diferencia)) crlf )
   ( printout k "<tr> <td></td> <td></td> <td align='right'>" ?debe " <small> " ?debe_corregido "</small> </td> <td>|</td> <td align='right'>" ?haber "<small> " ?haber_corregido "</small> </td></tr>" crlf )
   ( printout k "<tr> <td></td> <td>$</td> <td align='right'>"  ?diferencia " <small> " ?diferencia_corregida "</small></td></tr>" crlf )
  
   ( printout k "<tr> <td> Monto Corrección </td> <td>$</td> <td align='right'>" (round (- ?diferencia_corregida ?diferencia)) " </td></tr>" crlf )
   ( printout k "</tbody>" crlf)
   ( printout k "</table>" crlf)
)



( defrule t-footer-acreedor
  ?subtotales <- ( subtotales
    ( haber_corregido ?haber_corregido)
    ( debe_corregido ?debe_corregido)
    ( haber ?haber )
    ( debe  ?debe )
    ( totalizado true)
    ( mostrado false ) )

  ( test (< ?debe ?haber))

  =>

   ( bind ?diferencia (- ?haber ?debe ))
   ( printout t "----------------------------" crlf)
   ( printout t tab ?debe tab "|" tab ?haber crlf )
   ( printout t tab "---------------------" crlf)
   ( printout t tab tab "|" tab  ?diferencia tab "$" crlf )


   ( printout t "---------- CORRECCION MONETARIA ANUAL -----------" crlf)
   ( bind ?diferencia_corregida (- ?haber_corregido ?debe_corregido ))
   ( printout t "----------------------------" crlf)
   ( printout t tab ?debe_corregido tab "|" tab ?haber_corregido crlf ) 
   ( printout t tab "--------------------" crlf)
   ( printout t tab tab " | $" tab ?diferencia_corregida crlf )

   ( printout t monto-de-correccion "$" tab (round (- ?diferencia_corregida ?diferencia)) crlf )
   ( printout k "<tr> <td></td> <td></td> <td align='right'>" ?debe " <small> " ?debe_corregido "</small> </td> <td>|</td> <td align='right'>" ?haber "<small> " ?haber_corregido "</small> </td></tr>" crlf )
   ( printout k "<tr> <td> </td> <td> </td> <td></td> <td>|</td> <td align='right'>"  ?diferencia " <small> " ?diferencia_corregida "</small></td> <td>$</td> </tr>" crlf )
   ( printout k "<tr> <td colspan='2'> Monto Corrección</td><td></td><td>$</td> <td align='right'>" (round (- ?diferencia_corregida ?diferencia)) " </td></tr>" crlf )

   ( printout k "</tbody>" crlf)
   ( printout k "</table>" crlf)
)


