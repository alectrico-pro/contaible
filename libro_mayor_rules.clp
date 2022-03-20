( defmodule LIBRO-MAYOR ( import MAIN deftemplate ?ALL))

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
;   ( printout k "title: L.Mayor-" ?empresa crlf)
;   ( printout k "permalink: /" ?empresa "/libro-mayor " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
)

(defrule fin-kindle-k
  ( declare (salience -100) )
 =>
  ( close k )
)

 
( defrule encabezado-cuentas-saldadas
              ( cuenta ( nombre ?nombre) ( partida nil)) 
 (not (exists ( cuenta ( nombre ?nombre) ( partida ~nil))) )
 =>
 ; ( printout t "La cuenta no se ha usado " ?nombre  crlf)
  ( assert ( subtotales ( cuenta ?nombre)))
;  ( printout t "Se generó un fact subtotales para esa cuenta" crlf)
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

  ( printout k "<thead><th> voucher </th><th> partida </th><th> debe </th> <th> | </th> <th> haber </th><th> mes </th> <th>recibida</th> <th>factor corrección monetaria</th> <th> tipo documento</th></thead>"crlf)
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
     ( factor-de-correccion-monetaria ?factor)
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
     ( rechazado ?rechazado)
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

  ( if (eq true ?rechazado)
   then
    ( printout k "<tr  >  <td>" ?voucher "</td> <td align='right'> <a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a> </td> <td style='text-decoration-line: line-through' align='right'>" ?debe "</td> <td> | </td> <td style='text-decoration-line:line-through' align='right'> " ?haber  "</td> <td>" ?mes "</td><td>" ?recibida "</td><td> " ?factor "</td><td> " ?tipo-de-documento "</td> </tr>" crlf )
   else
    ( printout k "<tr> <td>" ?voucher "</td> <td align='right'> <a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a> </td> <td align='right'>" ?debe "</td> <td> | </td> <td align='right'> " ?haber  "</td> <td>" ?mes "</td><td>" ?recibida "</td><td> " ?factor "</td><td> " ?tipo-de-documento "</td> </tr>" crlf )
  )

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
     ( acreedor ?acreedor)
     ( deber ?deber)
     ( totalizado false)
   )
   ( test (> ?debe ?haber))
  =>
   ( bind ?diferencia (- ?debe ?haber ))
   ( modify ?subtotales
     (deber ?diferencia) (deber_corregido ?diferencia) (totalizado true) (acreedor 0))
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
   ( modify ?subtotales
      (acreedor ?diferencia) (acreedor_corregido ?diferencia) (totalizado true) (deber 0))
)



( defrule t-footer-deudor
  ?subtotales <- ( subtotales 
    ( debe_corregido ?debe_corregido)
    ( haber_corregido ?haber_corregido)
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

;   ( printout k "<tr> <td></td> <td></td> <td align='right' >" ?debe "</td> <td>|</td> <td align='right'>" ?haber "</td></tr>" crlf )
 ;  ( printout k "<tr> <td></td> <td>$</td> <td align='right'>"  ?diferencia "</td></tr>" crlf )

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
    ( mostrado false )
  )
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

;   ( printout k "<tr> <td> </td><td></td> <td align='right'>" ?debe "</td> <td>|</td> <td align='right'>" ?haber "</td> </tr>" crlf )
 ;  ( printout k "<tr> <td> </td><td> </td> <td></td> <td>|</td> <td align='right'>"  ?diferencia "</td> <td>$</td> </tr>" crlf )

   ( printout k "</tbody>" crlf)
   ( printout k "</table>" crlf)
)


