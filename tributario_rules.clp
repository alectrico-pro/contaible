(defmodule TRIBUTARIO (import MAIN deftemplate ?ALL))

(deftemplate info
  (slot inventario-final-liquidado (default false) )
  (slot amortizacion-instantanea (default 0))
  (slot depreciacion-instantanea (default 0))
  (slot anotado                   (default false) )
)

(defrule inventario-final-liquidado
  (exists (partida-inventario-final ))
   =>
  (assert (info (inventario-final-liquidado true)))
)

(defrule inventario-final-no-liquidado
  (not (exists (partida-inventario-final )))
 =>
  (assert (info (inventario-final-liquidado false)))
  
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

(defrule inicio
  ( declare (salience 10000))
  ( cuenta (nombre utilidad-tributaria) (partida ?p&:(neq nil ?p)) 
                                (haber ?haber&:(neq nil ?haber))
                                (debe  ?debe&:(neq nil ?debe))  )
 =>
  ( printout t "--modulo-----------CALCULO DE BASE TRIBUTARIA-----------------" crlf )
)



(defrule abonos-rechazados
  ?info <- (info (anotado false) )
  (abono (partida ?partida) (cuenta ?cuenta))
  (partida (numero ?partida))
  (revision (partida ?partida) (rechazado true))
 =>
  (printout t "Cuenta: " ?cuenta crlf)
  (printout t "Reintegrar abonos rechazados" crlf)
  ( halt )
)

(defrule cargos-rechazados
  ?info <- (info (anotado false) )
  (cargo (partida ?partida) (cuenta ?cuenta))
  (partida (numero ?partida))
  (revision (partida ?partida) (rechazado true))

 =>
  (printout t "Cuenta: " ?cuenta crlf)
  (printout t "Reintegrar cargos rechazados" crlf)
  ( halt )
)



(defrule descuentos-propyme 
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
  ?info <- (info (anotado false) )

 =>
;   ( (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?f:mes-de-adquisicion ?f:ano-de-adquisicion)))

:;    ( and (eq ?f:ano-de-adquisicion ?ano_top) (>  (mes_to_numero ?mes_top) (mes_to_numero ?f:mes-de-adquisicion)))

  ( bind ?suma-de-depreciacion 0)

  ( do-for-all-facts
    ((?f registro-de-depreciacion))
    (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?f:mes-de-adquisicion ?f:ano-de-adquisicion))
    (printout t ?f:nombre-del-activo crlf)
    (bind ?suma-de-depreciacion (+ ?suma-de-depreciacion ?f:valor-de-adquisicion)))

  ( bind ?suma-de-amortizacion 0)

  ( do-for-all-facts
    ((?f registro-de-amortizacion))
    (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?f:mes-de-adquisicion ?f:ano-de-adquisicion))
    (printout t ?f:nombre-del-activo crlf)
    (bind ?suma-amortizacion (+ ?suma-de-amortizacion ?f:valor-de-adquisicion)))

  ( modify ?info 
    ( anotado true)
    ( amortizacion-instantanea ?suma-de-amortizacion)
    ( depreciacion-instantanea ?suma-de-depreciacion))

  ( printout t " Suma de amortizacion: " ?suma-de-amortizacion crlf)
  ( printout t " Suma de depreciacion: " ?suma-de-depreciacion crlf)
)


(defrule fin
 ( declare (salience -10000))
 =>
  ( close k )
)




;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-tributario-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))
   ( selecciones (archivo-unico-markdown ?archivo-unico))

  =>

  ( if (eq true ?archivo-unico)
     then
      ( bind ?archivo (str-cat "./doc/k.markdown"))
      ( open ?archivo k "a")
     else
      ( bind ?archivo (str-cat "./doc/" ?empresa "/tributario.markdown"))
      ( open ?archivo k "w")
      ( printout k "--- " crlf)
      ( printout k "layout: page" crlf)
      ( printout k "--- " crlf)
      ( printout k "" crlf)
      ( printout k "<li><span style='background-color: lavender'>[    ]</span> partida revisada y resultado bueno. </li>" crlf)
      ( printout k "<li><span style='background-color: lightyellow'>[    ]</span> cuenta mayor del activo </li>" crlf)
      ( printout k "<li><span style='background-color: azure'>[    ]</span> cuenta mayor del pasivo </li>" crlf)
      ( printout k "<li><span style='color: white; background-color: cornflowerblue'>[    ]</span> cuenta de patrimonio </li>" crlf)
      ( printout k "<li><span style='background-color: gold'>[    ]</span> ganancia </li>" crlf)
      ( printout k "<li><span style='color: white; background-color: black'>[    ]</span> pérdida </li>" crlf)
      ( printout k "<li><span style='background-color: blanchedalmond'>[    ]</span> subtotales de la transacción </li>" crlf)
   )




 ;  ( printout t "En inicio-tributario-rules" )
;  ( bind ?archivo (str-cat "./doc/" ?empresa "/tributario.markdown"))

;   ( open ?archivo k "w")

;   ( printout k "--- " crlf)
;   ( printout k "title: " ?empresa "-tributario" crlf)
;  ( printout k "permalink: /" ?empresa "/tributario/ " crlf)
;   ( printout k "layout: page" crlf)
;   ( printout k "--- " crlf)
;   ( printout k "" crlf)
;   ( printout k "<li><span style='background-color: lavender'>[    ]</span> partida revisada y resultado bueno. </li>" crlf)
;   ( printout k "<li><span style='background-color: lightyellow'>[    ]</span> cuenta mayor del activo </li>" crlf)
;   ( printout k "<li><span style='background-color: azure'>[    ]</span> cuenta mayor del pasivo </li>" crlf)
 ;  ( printout k "<li><span style='color: white; background-color: cornflowerblue'>[    ]</span> cuenta de patrimonio </li>" crlf)
;   ( printout k "<li><span style='background-color: gold'>[    ]</span> ganancia </li>" crlf)
;   ( printout k "<li><span style='color: white; background-color: black'>[    ]</span> pérdida </li>" crlf)
;   ( printout k "<li><span style='background-color: blanchedalmond'>[    ]</span> subtotales de la transacción </li>" crlf)
)


(defrule estado-de-resultados-mensual
  ( balance (dia ?dia) (mes ?mes) (ano ?ano ))
  ( empresa (nombre ?empresa))


  ( info
    ( inventario-final-liquidado ?inventario-final-liquidado)
    ( anotado true)
    ( depreciacion-instantanea ?depreciacion-instantanea)
    ( amortizacion-instantanea ?amortizacion-instantanea) )

  ( subtotales (cuenta ingresos-brutos) (acreedor ?ingresos-brutos))
  ( subtotales (cuenta ventas) (deber ?ventas-deber) (acreedor ?ventas-acreedor))
  ( subtotales (cuenta devolucion-sobre-ventas) (debe ?devolucion-sobre-ventas))


  ( subtotales (cuenta devolucion-sobre-gastos) (haber ?devolucion-sobre-gastos))
  ( subtotales (cuenta reintegro-de-devolucion-sobre-ventas) (haber ?reintegro-de-devolucion-sobre-ventas))

  ( subtotales (cuenta compras) (debe ?compras))
  ( subtotales (cuenta gastos-sobre-compras) (debe ?gastos-sobre-compras))
  ( subtotales (cuenta inventario-inicial) (deber ?inventario-inicial))

  ( subtotales (cuenta inventario)
    (deber ?inventario-deber)
    (acreedor ?inventario-acreedor))

  ( subtotales (cuenta inventario-final)
    (deber ?inventario-final-deber)
    (acreedor ?inventario-final-acreedor))

  ( subtotales (cuenta gastos-administrativos)
    (debe  ?gastos-administrativos-debe)
    (haber ?gastos-administrativos-haber))

  ( cuenta (nombre rechazados) (debe ?debe-rechazados) (haber ?haber-rechazados))
  ( subtotales (cuenta salarios ) (deber ?salarios-deber))
  ( subtotales (cuenta salarios ) (acreedor ?salarios-acreedor))
  ( subtotales (cuenta gastos-ventas) (deber ?gastos-ventas))
  ( subtotales (cuenta gastos-en-investigacion-y-desarrollo) (debe ?gastos-en-investigacion-y-desarrollo))
  ( subtotales (cuenta gastos-promocionales) (deber ?gastos-en-promocion))
  ( subtotales (cuenta costos-de-ventas) (deber ?costos-de-ventas))
  ( subtotales (cuenta idpc) (haber ?idpc))
  ( subtotales (cuenta reserva-legal) (haber ?reserva-legal))
  ( subtotales (cuenta utilidad-tributaria) (deber ?utilidad-tributaria-deber) (acreedor ?utilidad-tributaria-acreedor))
  ( subtotales (cuenta base-imponible) (deber ?base-imponible-deber) (acreedor ?base-imponible-acreedor))
  ( subtotales (cuenta utilidad) (acreedor ?utilidad-acreedor) (deber ?utilidad-deber) )
  ( subtotales (cuenta provision-impuesto-a-la-renta ) (acreedor ?provision-impuesto-a-la-renta))
  ( subtotales (cuenta amortizacion-intangibles ) (deber ?amortizacion-intangibles))
  ( subtotales (cuenta depreciacion) (deber ?depreciacion))
  ( subtotales (cuenta impuesto-a-la-renta-por-pagar) (acreedor ?impuesto-a-la-renta-por-pagar))
  ( subtotales (cuenta perdidas-ejercicios-anteriores) (debe ?pea))
  ( subtotales (cuenta perdida-por-correccion-monetaria) (debe ?perdida-por-correccion-monetaria))
  ( subtotales (cuenta ganancia-por-correccion-monetaria) (haber ?ganancia-por-correccion-monetaria))
  ( subtotales (cuenta aumentos-de-capital-aportes) (haber ?aportes))
  ( subtotales (cuenta insumos) (deber ?insumos))
  ( subtotales (cuenta costos-de-mercancias) (deber ?costos-de-mercancias-deber) (acreedor ?costos-de-mercancias-acreedor))

  ( cuenta (nombre impuestos-no-recuperables) (haber ?impuestos-no-recuperables))
  ( tasas (idpc ?tasa-idpc) (mes ?mes) (ano ?ano))  
  ( selecciones (regimen ?regimen) (incentivo-al-ahorro ?incentivo-al-ahorro))

 =>

  (bind ?rechazados (- ?haber-rechazados ?debe-rechazados))

  (bind ?costos-de-mercancias (- ?costos-de-mercancias-deber ?costos-de-mercancias-acreedor))

  (bind ?inventario
   (- ?inventario-deber
      ?inventario-acreedor))

  (bind ?ventas   (- ?ventas-acreedor ?ventas-deber))
  (bind ?utilidad (- ?utilidad-acreedor ?utilidad-deber))
  (bind ?salarios (- ?salarios-deber ?salarios-acreedor))

  (bind ?inventario-final 
   (abs  (- ?inventario-final-deber
       ?inventario-final-acreedor)))

  (bind ?gastos-administrativos
    (- ?gastos-administrativos-debe
       ?gastos-administrativos-haber))
    
  (bind ?utilidad-tributaria
   (- ?utilidad-tributaria-acreedor
      ?utilidad-tributaria-deber))

  (bind ?base-imponible
   (- ?base-imponible-acreedor
      ?base-imponible-deber))

  (bind ?ventas-netas           (- ?ventas  (- ?devolucion-sobre-ventas ?reintegro-de-devolucion-sobre-ventas) ))
  (bind ?compras-totales        (+ ?compras ?gastos-sobre-compras ))
  (bind ?compras-netas          ?compras-totales)
  (bind ?existencias            (+ ?compras-netas ?inventario-inicial))
  ;mercaderia disponible para ventas
;  (bind ?costos-de-mercancias   ?inventario-final)

  (if (eq true ?inventario-final-liquidado)
    then
     (if (eq diciembre ?mes) 
       then
        (bind ?utilidad-bruta (- ?ventas-netas ?costos-de-mercancias ?costos-de-ventas) )
       else
        (bind ?utilidad-bruta (- ?ventas-netas ?costos-de-mercancias ?costos-de-ventas))  )

     else
     (if (eq diciembre ?mes)
       then
        ;no se ha liquidado el inventario final, tampoco acá
        (bind ?utilidad-bruta (+ (- ?ventas-netas ?costos-de-mercancias ?costos-de-ventas ) ?inventario))
       else
        (bind ?utilidad-bruta (+ (- ?ventas-netas ?costos-de-mercancias ?costos-de-ventas)  ?inventario ))))

  (bind ?gastos-de-operacion 
      (-  (+ ?gastos-administrativos
             ?gastos-ventas
             ?gastos-en-investigacion-y-desarrollo 
             ?gastos-en-promocion
             ?amortizacion-intangibles
             ?depreciacion
             ?salarios )
           ?devolucion-sobre-gastos )  )
  
  (bind ?utilidad-de-operacion  (- ?utilidad-bruta ?gastos-de-operacion ?pea))
  (bind ?utilidad-antes-de-reserva ?utilidad-de-operacion)
  (bind ?margen-de-explotacion (- ?utilidad-de-operacion ?reserva-legal))

  (bind ?margen-fuera-de-explotacion (- (+ ?margen-de-explotacion
                                           ?ganancia-por-correccion-monetaria )
                                        ?impuestos-no-recuperables))

  (bind ?utilidad-antes-de-idpc  ?margen-fuera-de-explotacion )

  (bind ?resultado (+ ?aportes (- ?margen-fuera-de-explotacion   (+ ?depreciacion-instantanea   ?amortizacion-instantanea))) )

  (bind ?resultado-final (- ?resultado ?rechazados))

  (printout k "<table><tbody>" crlf )
  (printout k "<tr><th colspan='3'>" ?empresa "</th></tr>" crlf )

  (printout t ?empresa crlf)
  (printout t "================================================================================" crlf)
  (printout t "CALCULO DE LA BASE IMPONIBLE PROPYME" crlf)
  (printout t " Solo se consideran las transacciones hasta el día " ?dia " de " ?mes " de " ?ano "o. Cifras en pesos." crlf)
  (printout k "<tr><th colspan='8'> CALCULO DE LA BASE IMPONIBLE PROPYME </th></tr>" )
  (printout k "<tr><td colspan='8'>Solo se consideran las transacciones hasta el día " ?dia " de " ?mes tab ?ano ". Cifras en pesos. </td></tr>" crlf)

  (printout t "================================================================================" crlf)

  (if (eq true ?inventario-final-liquidado)
   then
     (printout k "<tr style='font-weight:bold;background-color: azure'><td colspan='8' align='center'>" INVENTARIO-FINAL-LIQUIDADO "</td></tr>" crlf)
  )
  (printout t "|" tab tab "|     " ?ingresos-brutos tab "Ingresos Brutos Percibidos A.29-LIR" crlf)
  (printout k "<tr><td></td><td></td><td></td><td></td><td align='right'>" ?ingresos-brutos "</td><td colspan='2'> Ingresos Brutos Percibidos A.29-LIR </td></tr>" crlf)

  (printout t "|" tab tab "|     " ?ventas tab "Ventas" crlf)
  (printout k "<tr><td></td><td></td><td></td><td></td><td align='right'>" ?ventas "</td><td> Ventas </td></tr>" crlf)


  (printout t "|" tab tab "| (-) -  " tab tab "Rebajas sobre ventas" crlf)
  (printout k "<tr><td></td><td></td><td></td><td> (-) </td> <td align='right'>0 </td> <td>  Rebajas sobre ventas </td></tr>" crlf)


  (printout t "|" tab tab "| (-) " ?devolucion-sobre-ventas tab tab "Devoluciones sobre ventas" crlf)  
  (printout k "<tr><td></td><td></td><td></td><td> (-) </td><td align='right'>" ?devolucion-sobre-ventas "</td><td> Devoluciones sobre ventas </td></tr>" crlf)  

  (printout t "|" tab tab "| (+) " ?reintegro-de-devolucion-sobre-ventas tab tab "Reintegros de Devoluciones sobre ventas" crlf)
  (printout k "<tr><td></td><td></td><td></td><td> (+) </td><td align='right'>" ?reintegro-de-devolucion-sobre-ventas "</td><td> Reintegro de Devoluciones sobre ventas </td></tr>" crlf)


  (printout t "|" tab tab "| (-) -  " tab tab "Descuentos sobre ventas" crlf)
  (printout k "<tr><td></td><td></td><td></td><td> (-) </td><td align='right'>0</td><td>Descuentos sobre ventas </td></tr>" crlf)


  (printout t "|" tab tab "| (=) " ?ventas-netas tab "Ventas Netas" crlf)
  (printout k "<tr><td></td><td></td><td></td><td> (=) </td><td align='right'>" ?ventas-netas "</td><td> Ventas Netas </td></tr>" crlf)


  (printout t crlf)
  (printout t "|" tab tab "| (-) " ?costos-de-ventas tab "Costos de Ventas A.30-LIR" crlf)
  (printout k "<tr><td></td><td></td><td></td><td> (-) </td><td align='right'>" ?costos-de-ventas "</td> <td>Costos de Ventas A.30-LIR </td></tr>" crlf)



  (printout t crlf) 
  (printout t "|" ?compras tab tab tab tab "Compras" crlf)
  (printout k "<tr><td></td><td align='right'>" ?compras  "</td><td></td><td></td><td></td><td> Compras </td></tr>" crlf)



  (printout t "| (+) " ?gastos-sobre-compras tab tab tab tab"Gastos sobre Compras" crlf)
  (printout k "<tr><td> (+) </td><td align='right'> " ?gastos-sobre-compras "</td><td></td><td> </td><td></td><td> Gastos sobre Compras </td></tr>" crlf)



  (printout t "|" ?compras-totales tab tab tab tab "Compras Totales" crlf)
  (printout k "<tr><td> (=) </td><td align='right'>" ?compras-totales "</td><td></td><td></td><td></td><td>Compras Totales</td></tr> " crlf)



  (printout t "| (-) - " tab tab tab tab "Rebajas sobre Compras" crlf)
  (printout t "| (-) - " tab tab tab tab "Devoluciones sobre Compras" crlf)
  (printout t "| (-) - " tab tab tab tab "Descuentos sobre Compras" crlf)

  (printout k "<tr><td> (-) </td><td align='right'>" 0 "</td><td></td><td></td><td></td><td> Rebajas Cobre Compras </td></tr>" crlf)

  (printout k "<tr><td> (-) </td><td align='right'>" 0 "</td><td></td><td></td><td></td><td> Descuentos Sobre Compras </td></tr>" crlf)


  (printout t "|" ?compras-totales tab tab tab tab "Compras Netas" crlf)
  (printout k "<tr><td>(=)</td><td align='right'>" ?compras-totales "</td><td></td><td></td><td></td><td>Compras Netas</td></tr> " crlf)

  (printout t crlf)

  (printout t "| (+) " ?inventario-inicial tab "|" tab tab "Inventario Inicial" crlf)
  (printout k "<tr><td> (+) </td><td align='right'>"  ?inventario-inicial "</td><td></td><td></td><td></td><td colspan='2'>Inventario Inicial</td></tr> " crlf)


; (printout t "| (=) " ?existencias tab "|" tab tab "Mercadería Disponible para la Venta " crlf)
; (printout k "<tr><td> (=) </td><td align='right'> " ?existencias "</td><td></td><td> </td><td></td><td> Mercadería Disponible para la Venta </td></tr>" crlf)



; (printout t "|     0  |" tab tab "Costos de Mercancías Vendidas" crlf)
; (printout k "<tr><td>     </td> <td align='right'> 0 </td><td> </td><td></td><td></td><td colspan='2'>Costo de Mercancías Vendidas</td></tr>" crlf)


  (printout t "| (-) " ?inventario tab "|" tab tab "Inventario " crlf)
  (printout k "<tr><td> (-) </td> <td align='right'>" ?inventario "</td><td> </td><td></td><td></td><td colspan='2'>Inventario </td></tr>" crlf)


  (printout t "| (-) " ?inventario-final tab "|" tab tab "Inventario Final " crlf)
  (printout k "<tr><td> (-) </td> <td align='right'>" ?inventario-final "</td><td> </td><td></td><td></td><td colspan='2'>Inventario Final </td></tr>" crlf)


  (printout t "| (=) " ?costos-de-mercancias tab "|" tab tab "Costos de Mercancías " crlf)
  (printout k "<tr><td> (=) </td> <td align='right'>" ?costos-de-mercancias "</td><td> </td><td></td><td></td><td colspan='2'>Costo de Mercancías </td></tr>" crlf)

  (printout t "| (-) " ?insumos tab "|" tab tab "Insumos " crlf)
  (printout k "<tr><td> (=) </td> <td align='right'>" ?insumos "</td><td> </td><td></td><td></td><td colspan='2'>Insumos </td></tr>" crlf)

  (printout t crlf)
  
  (if (eq true ?inventario-final-liquidado)
   then

     (printout t "|" tab tab "|     " ?utilidad-bruta tab "UTILIDAD BRUTA (Ventas Netas - Costo de Ventas - Costos de Mercancías)" crlf)
     (printout k "<tr><td></td><td></td><td></td><td></td><td align='right'>" ?utilidad-bruta "</td><td colspan='4'>  UTILIDAD BRUTA (Ventas Netas - Costo de Ventas - Costos de Mercancías - Insumos) </td></tr>"  crlf)
   else

     (printout t "|" tab tab "|     " ?utilidad-bruta tab "UTILIDAD BRUTA (Ventas Netas - Costo de Ventas)" crlf)
     (printout k "<tr><td></td><td></td><td></td><td></td><td align='right'>" ?utilidad-bruta "</td><td colspan='4'>  UTILIDAD BRUTA (Ventas Netas - Costo de Ventas) </td></tr>"  crlf) )

  (printout k "<tr style='font-weight:bold; background-color: azure'><td></td><td></td><td></td><td></td><td align='right'>" ?utilidad-bruta "</td><td colspan='4'>  Margen de Explotacion </td></tr>"  crlf)


  (printout t "|" tab tab "| (-) " ?gastos-de-operacion tab "Gastos Operacionales (Gastos Admon + Gastos Vtas + I+D + Promocion + Amortiza + Depreciacion)" crlf)
  (printout k "<tr><td></td><td></td><td></td><td>(-)</td><td align='right'>" ?gastos-de-operacion "</td><td colspan='4'> Gastos de Deducibles de Impuesto (Gastos Admon + Gastos Vtas + I+D + Promocion + Amortiza.Int A.31-LIR) </td></tr>"  crlf)


  (printout t "|" ?gastos-administrativos tab tab tab tab  "Gastos del Dpto Administración" crlf)
  (printout t "|" ?gastos-ventas tab tab tab tab "Gastos del Dpto Ventas" crlf)
  (printout t "|" ?gastos-en-investigacion-y-desarrollo tab tab tab tab "Gastos en I+D" crlf)
  (printout t "|" ?gastos-en-promocion tab tab tab tab "Gastos en Promocion" crlf)
  (printout t "|" ?salarios tab tab tab tab "Salarios" crlf)
  (printout t "|" ?perdida-por-correccion-monetaria tab tab tab tab "Pérdida por Corrección Monetaria" crlf)
  (printout t "|" ?amortizacion-intangibles tab tab tab tab " (-) Amortizacion Contable Intangibles" crlf)
  (printout t "|" ?depreciacion tab tab tab tab " (-) Depreciacion" crlf)


  (printout k "<tr><td> (-) </td><td align='right'>" ?gastos-administrativos "</td><td></td><td></td><td></td><td> Gastos del Dpto Administración </td></tr>" crlf)

  (printout k "<tr><td> (-) </td><td align='right'>" ?devolucion-sobre-gastos "</td><td></td><td></td><td></td><td> Devolución sobre Gastos </td></tr>" crlf)


  (printout k "<tr><td> (-) </td><td align='right'>" ?gastos-ventas "</td><td></td><td></td><td></td><td> Gastos del Dpto Ventas </td></tr>" crlf)

  (printout k "<tr><td>(-)</td><td align='right' >" ?gastos-en-investigacion-y-desarrollo "</td><td></td><td></td><td></td><td> Gastos en I+D </td></tr>" crlf)

  (printout k "<tr><td>(-)</td><td align='right'>" ?gastos-en-promocion "</td><td></td><td></td><td></td><td> Gastos en Promoción </td></tr>" crlf)

  (printout k "<tr><td>(-)</td><td align='right'>" ?salarios "</td><td></td><td></td><td></td><td> Salarios </td></tr>" crlf)

  (printout k "<tr><td>(-) </td><td align='right'>" ?perdida-por-correccion-monetaria "</td><td></td><td></td><td></td><td> Pérdida Por Corrección Monetaria </td></tr>" crlf)

  (printout k "<tr><td>(-) </td><td align='right'>" ?amortizacion-intangibles "</td><td></td><td></td><td></td><td> Amortización </td></tr>" crlf)

  (printout k "<tr><td>(-) </td><td align='right'>" ?depreciacion "</td><td></td><td></td><td></td><td> Depreciación </td></tr>" crlf)

  (printout t "|" tab tab "| (-) " ?pea tab tab "Pérdida Ejercicio Anterior PEA A.33-LIR)" crlf)

  (printout k "<tr><td></td><td></td><td></td><td> (-) </td><td align='right'>" ?pea "</td><td> Pérdida Ejercicio Anterior PEA A.33-LIR </td></tr>" crlf)

  (printout t "|" tab tab "|     " ?utilidad-de-operacion tab "UTILIDAD DE OPERACION (U.Bruta - G.Ded. - PEA)" crlf)
  (printout k "<tr><td> </td><td></td><td></td><td></td><td align='right'> " ?utilidad-de-operacion "</td><td> UTILIDAD DE OPERACIÓN </td></tr>" crlf)

  (printout t "|" tab tab "| (-) " tab "Otros Gastos" crlf)
  (printout k "<tr><td></td><td></td><td></td><td> (-) </td><td align='right'>" 0 "</td><td> Otros Gastos </td></tr>" crlf)


  (printout t "|" tab tab "|     " ?utilidad-antes-de-reserva tab "UTILIDAD ANTES DE RESERVA (U.Op-Reserva Lega)" crlf)
  (printout k "<tr><td></td><td> </td><td> </td><td></td><td align='right'>" ?utilidad-antes-de-reserva "</td><td> Utilidad Antes de Reserva </td></tr>" crlf)

  (printout t "|" tab tab  "| (-) " tab ?reserva-legal tab " Reserva Legal" crlf)

  (printout k "<tr><td></td><td></td><td></td><td> (-) </td><td align='right'>" ?reserva-legal "</td><td> Reserva Legal </td></tr>" crlf)

  (printout t "|" tab tab "| (=) " ?margen-de-explotacion tab "Resultado de Explotación " crlf)
  (printout k "<tr style='font-weight:bold; background-color: azure'><td> <td></td></td><td> </td><td></td><td align='right'>" ?margen-de-explotacion "</td><td> Resultado de Explotacion </td></tr>" crlf)

  (printout t "|" tab tab "| (+) " ?ganancia-por-correccion-monetaria tab "Ganancia Por Corrección Monetaria" crlf)
  (printout k "<tr><td></td><td></td><td></td><td> (+) </td><td align='right'>" ?ganancia-por-correccion-monetaria "</td><td> Ganancia Por Corrección Monetaria </td></tr>" crlf)

  (printout t "|" tab tab "| (-) " ?impuestos-no-recuperables tab "Impuestos No Recuperables" crlf)
  (printout k "<tr><td></td><td></td><td></td><td> (-) </td><td align='right'>"  ?impuestos-no-recuperables "</td><td> Impuestos No Recuperables </td></tr>" crlf)

  (printout t "|" tab tab "| (=) " ?margen-fuera-de-explotacion tab "Resultado Fuera de Explotación " crlf)
  (printout k "<tr style='font-weight:bold; background-color: azure'><td> <td></td></td><td> </td><td></td><td align='right'>" ?margen-fuera-de-explotacion "</td><td> Resultado Fuera de Explotacion </td></tr>" crlf)

  (printout t "|" tab tab "|     " ?utilidad-antes-de-idpc tab "Resultado Antes de Impuesto" crlf)
  (printout k "<tr style='font-weight:bold; background-color: azure'><td> <td></td></td><td> </td><td></td><td align='right'>" ?utilidad-antes-de-idpc "</td><td> Resultado Antes de Impuesto</td></tr>" crlf)


  ( if (< ?base-imponible 0 )
   then
    (printout t "|" tab tab "| (-) " ?idpc tab "Impuesto Determinado: " (round (* ?tasa-idpc 100) ) " en " ?ano crlf)
    (printout k "<tr style='color: white;background-color: lightgreen' ><td></td><td></td><td></td><td> (X) </td><td align='right'> " ?idpc "</td><td> Impuesto No Aplica porque hay pérdida tributaria </td></tr>" crlf)
    (bind ?utilidad-despues ?utilidad-antes-de-idpc )
   else
    (printout t "|" tab tab "| (-) " ?idpc tab "Impuesto Determinado, factor es " ?tasa-idpc " en " ?ano crlf)
    (printout k "<tr style='color: white; font-weight:bold; background-color: crimson'><td></td><td></td><td></td><td> (-) </td><td align='right'> " ?idpc "</td><td> Impuesto Determinado, factor es: " ?tasa-idpc " en " ?ano " </td></tr>" crlf)
    (bind ?utilidad-despues (- ?utilidad-antes-de-idpc ?idpc))
  )

  (printout t "|" tab tab "|     " ?utilidad-despues tab "Utilidad Calc. Desp.Imp." crlf)
  (printout k "<tr style='font-weight:bold;background-color: azure'><td> <td></td></td><td> </td><td></td><td align='right'>" ?utilidad-despues "</td><td> Utilidad Después de Impuestos <small> Calculada </small></td></tr>" crlf)
  (printout t "---------------------------------------------------------------------------" crlf)
  (printout k "</tbody></table>" crlf)
  (printout k "<table> " crlf)
  (printout t "----------- DETERMINACIÓN DE LA BASE IMPONIBLE -----------------------------" crlf)
  (printout t " Determina los impuestos del régimen " ?regimen  crlf)
  (printout k "<tr><th> <td colspan=6> DETERMINACIÓN DE LA BASE IMPONIBLE </td></th></tr>" crlf)
  (printout k "<tr><th> <td colspan=6> Determina los impuestos del regimen " ?regimen "</td></th></tr>" crlf)
  (printout k "<tbody>" crlf)
  (printout t "|" tab tab "|     " ?utilidad tab "Utilidad (módulo liquidación)" crlf)
  (printout t "|" tab tab "|     " ?margen-fuera-de-explotacion  tab "Margen fuera de Explotacion" crlf)
  (printout k "<tr style='font-weight:bold;background-color: azure'><td> <td></td></td><td> </td><td></td><td align='right'>" ?utilidad "</td><td> Utilidad del Ejercicio Ant.Impuesto (m. liquidación)</td></tr>" crlf)
  (printout t "| (-) " tab ?depreciacion-instantanea tab tab tab tab "Depreciación Instantanea Propyme" crlf)
  (printout t "| (-) " tab ?amortizacion-instantanea tab tab tab tab "Amortizacion Instántanea Intangibles (no-contable) " crlf)
  ( printout k "<tr><td> (-) </td><td align='right'>" ?depreciacion-instantanea "</td><td></td><td></td><td></td><td> Depreciación Instantánea Activo Fijo Propyme </td></tr>" crlf)
  ( printout k "<tr><td> (-) </td><td align='right'>" ?amortizacion-instantanea "</td><td></td><td></td><td></td><td> Amortización Instantánea Intangibles </td></tr>" crlf)

  ( printout t "|" ?aportes tab tab tab tab "(+) Aportes Cap." crlf)
  ( printout k "<tr><td> (+) </td><td align='right'>" ?aportes "</td><td></td><td></td><td></td><td> Aportes al Capital </td></tr>" crlf)

  (printout t "|" tab tab "| (=) " ?resultado tab "RLI Calculada sin considerar partidas rechazadas" crlf)
  (printout k "<tr><td> <td></td></td><td> </td><td> (=) </td><td align='right' style = 'font-weight:bold; background-color: lightgreen'>" ?resultado "</td><td> RLI Calculada sin considerar partidas rechazadas </td></tr>" crlf)


  (if (eq ?base-imponible (- ?resultado ?rechazados))
   then


    (printout t "|" tab tab "| (-) " ?rechazados tab "Rechazados" crlf)
    (printout k "<tr><td> <td></td></td><td> </td><td>  (-) </td><td align='right' >" ?rechazados "</td><td> Rechazados </td></tr>" crlf)
    (printout t "|" tab tab "| (=) " (- ?resultado ?rechazados) tab "RLI Calculada" crlf)
    (printout k "<tr><td> <td></td></td><td> </td><td> (1) (=) </td><td align='right' style = 'font-weight:bold; background-color: lightgreen'>" (- ?resultado ?rechazados) "</td><td> RLI Calculada </td></tr>" crlf)


   else
    (printout t "|" tab tab "| (-) " ?rechazados tab "Rechazados" crlf)
    (printout k "<tr><td> <td></td></td><td> </td><td>  (-) </td><td align='right' >" ?rechazados "</td><td> Rechazados </td></tr>" crlf)

    (printout t "|" tab tab "| (=) " (- ?resultado ?rechazados) tab "RLI Calculada (1)" crlf)
    (printout k "<tr><td> <td></td></td><td> </td><td> (1) (=) </td><td align='right' style = 'color: white;font-weight:bold; background-color: red'>" (- ?resultado ?rechazados) "</td><td> RLI Calculada </td></tr>" crlf)
  )


;  (printout t "|" tab tab "| (-) " ?idpc tab "Impuesto Determinado" crlf)
;  (printout k "<tr><td> <td></td></td><td> </td><td> (-) </td><td align='right'>" ?idpc "</td><td> Impuesto Determinado: " (round (* ?tasa-idpc 100) ) "% </td></tr>" crlf)
 
  (printout t "|" tab tab "| (=) " ?base-imponible tab "RLI desp.Imptos (2) (m. liquidaciones)" crlf) 

  (printout t "(1) debe ser igual que (2) " crlf)

  (if (eq ?base-imponible (- ?resultado ?rechazados))
   then
    (printout k "<tr><td></td><td></td><td></td><td> </td><td align='right' style=' background-color: lightgreen'> <img src='../revisado.png'> " ?base-imponible "</td><td> RLI desp. Imptos ( m. liquidaciones) <small> " ?regimen "</small></td></tr>" crlf)
   
   else
    (printout k "<tr><td></td><td></td><td></td><td> (2) </td><td align='right' style='font-weight:bold; color:white; background-color: red'>" ?base-imponible "</td><td>  RLI deps. Imptos (m. liquidaciones) <small>" ?regimen "</small></td></tr>" crlf)
    (printout k "<tr></tr><tr><td colspan=6 rowspan=1 style='color: white; font-weight:bold; background-color: crimson'> (1) y (2) deben ser iguales: Lasliquidaciones pueden que esté con problemas. Revise que las cuentas de resultados estén bien configuradas en cuentas.txt. Deben tener grupo=resultado. Revise que estas líneas estén en el alectrico-2021-facts.txt 
;tributario
( ajuste-anual
   (ano 2021) (partida 209)
   (liquidacion tributaria)
   (efecto aporte))

( ajuste-anual
   (ano 2021) (partida 210)
   (liquidacion tributaria)
   (efecto deduccion))


( ajuste-anual-de-resultado-tributario
   (ano 2021) (partida 211))


;financiero

( ajuste-anual
   (ano 2021) (partida 213)
   (liquidacion financiera)
   (efecto ganador))

( ajuste-anual
   (ano 2021) (partida 212)
   (liquidacion financiera)
   (efecto perdedor))




 </td></tr>" crlf)
)

 

 (if (and (eq ?incentivo-al-ahorro true) (eq ?regimen propyme) (> ?base-imponible 0))
   then 
    (printout t "  INCENTIVO AL AHORRO SOLICITADO EN selecciones.txt " crlf)
    (printout t tab tab ?base-imponible tab " RLI Calculada " crlf)
    (printout t tab tab (round (* ?resultado-final 0.5)) tab tab "Rebaja Art.14 Letra E " ?regimen  crlf)
    (printout t tab tab (round (* ?resultado-final ?tasa-idpc)) tab "IDPC A PAGAR" tab (round (* ?tasa-idpc 100)) "%" crlf)
    (printout k "<tr> <th> INCENTIVO AL AHORRO SOLICITADO EN selecciones.txt </th></tr> " crlf)
    (printout k "<tr><td></td><td></td><td></td><td> (-) </td><td align='right' style = 'font-weight:bold; background-color: azure'  >" ?resultado-final "</td><td> RENTA LIQUIDA IMPONIBLE</td></tr>" crlf)
    (printout k "<tr><td></td><td></td><td></td><td> (-) </td><td align='right' style=' background-color: gold'>" (round (* ?resultado-final 0.5)) "</td><td>    Rebaja Art.14 Letra E <small>" ?regimen "</small></td></tr>" crlf)
    (printout k "<tr><td></td><td></td><td></td><td> (=) </td><td align='right' style='font-weight:bold; background-color: lightgreen'>" (round (* ?resultado-final 0.5))"</td><td> RESULTADO DESPUES DE IMPUESTO <img src='../revisado.png'></td> </tr>" crlf)
    (printout k "<tr><td></td><td></td><td></td><td> (=) </td><td align='right' style='font-weight:bold; color: white; background-color: crimson'>" (round (* ?resultado-final 0.5 ?tasa-idpc)) "</td><td> IDPC A PAGAR <small> " (round (* ?tasa-idpc 100) )  "% en abril </small></td></tr>" crlf)
 )  

; (printout t "|" tab tab "|     ------" crlf)

; (printout t "|" tab tab "|     " ?utilidad-antes-de-idpc tab "UTILIDAD ANTES DE IMPUESTO A LA RENTA (U.Antes.Reserva - idpc)" crlf)
; (printout t "|" tab tab "| (-) " ?provision-impuesto-a-la-renta tab " Provisión de Impuesto Renta " crlf)
 
; (printout t "|" tab tab "| (=) " (- ?utilidad-antes-de-idpc ?provision-impuesto-a-la-renta) tab "UTILIDAD DEL EJERCICIO AJUSTADA (U.Ejercicio - Provision idpc)" crlf)
  (printout t "================================================================================" crlf)
  (printout k "</tbody></table>")
)


