;esto ya no se ocupa, ha sido reemplazo por tributario_rules.clp

(defmodule RESULTADO-KINDLE (import MAIN deftemplate ?ALL))


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
 =>
  ( printout t "--modulo-------------- RESULTADO KINDLE ----------" crlf )
 ; ( matches estado-de-resultados-mensual )
;  ( halt)
)

(defrule inicio-kindle
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))
  =>
;   ( bind ?archivo (str-cat "./doc/" ?empresa ".markdown"))

   ( bind ?archivo (str-cat "./doc/" ?empresa "/resultado-financiero.markdown"))
   ( open ?archivo k "w")

  ( printout k "--- " crlf)
  ( printout k "title: " ?empresa "-resultado-financiero" crlf)
  ( printout k "permalink: /" ?empresa "-resultado-financiero/ " crlf)
  ( printout k "layout: page" crlf)
  ( printout k "--- " crlf)

)


(defrule fin
  ( declare (salience -10000) )
 =>
  ( close k )
)




(defrule estado-de-resultados-mensual
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano))
  ( empresa (nombre ?empresa) (razon ?razon))

  (subtotales (cuenta ingresos-brutos) (acreedor ?ingresos-brutos))
  (subtotales (cuenta ventas) (acreedor ?ventas))
  (subtotales (cuenta devolucion-sobre-ventas) (debe ?devolucion-sobre-ventas))
  (subtotales (cuenta compras) (debe ?compras))
  (subtotales (cuenta gastos-sobre-compras) (debe ?gastos-sobre-compras))
  (subtotales (cuenta inventario-inicial) (debe ?inventario-inicial))
  (subtotales (cuenta inventario-final) (debe ?inventario-final))

  (subtotales (cuenta gastos-administrativos)
    (debe  ?gastos-administrativos-debe)
    (haber ?gastos-administrativos-haber))

  (subtotales (cuenta gastos-ventas) (debe ?gastos-ventas))
  (subtotales (cuenta gastos-en-investigacion-y-desarrollo) (debe ?gastos-en-investigacion-y-desarrollo))
  (subtotales (cuenta gastos-promocionales) (deber ?gastos-en-promocion))
  (subtotales (cuenta costos-de-ventas) (deber ?costos-de-ventas&:(> ?costos-de-ventas 0 )))
  (subtotales (cuenta idpc) (haber ?idpc))
  (subtotales (cuenta reserva-legal) (haber ?reserva-legal))

 (subtotales (cuenta utilidad) (acreedor ?utilidad-del-ejercicio-haber)
                               (deber  ?utilidad-del-ejercicio-debe)
 )

  (subtotales (cuenta provision-impuesto-a-la-renta ) (acreedor ?provision-impuesto-a-la-renta))
  (subtotales (cuenta amortizacion-intangibles ) (debe ?amortizacion-intangibles))
  (subtotales (cuenta depreciacion ) (debe ?depreciacion))
  (subtotales (cuenta salarios ) (debe ?salarios))
  
  (subtotales (cuenta impuesto-a-la-renta-por-pagar) (acreedor ?impuesto-a-la-renta-por-pagar))
  (subtotales (cuenta perdidas-ejercicios-anteriores) (debe ?pea))

  (subtotales (cuenta perdida-por-correccion-monetaria)
     (debe ?perdida-por-correccion-monetaria )) 
 
  (subtotales (cuenta ganancia-por-correccion-monetaria)
     (haber ?ganancia-por-correccion-monetaria )) 
 
  (tasas (idpc ?tasa-idpc) (mes diciembre) (ano ?ano))  
 =>
  (bind ?gastos-administrativos
    (- ?gastos-administrativos-debe
       ?gastos-administrativos-haber)
  )

  (bind ?utilidad-del-ejercicio
   (- ?utilidad-del-ejercicio-haber
      ?utilidad-del-ejercicio-debe)
  )
  (bind ?ventas-netas           (- ?ventas ?devolucion-sobre-ventas))

  (bind ?compras-totales        (+ ?compras ?gastos-sobre-compras))
  (bind ?compras-netas          ?compras-totales)

  (bind ?existencias            (+ ?compras-netas ?inventario-inicial))
  ;mercaderia disponible para ventas

  (bind ?utilidad-bruta         (- ?ventas-netas ?costos-de-ventas))

;  (bind ?gastos-de-operacion 
 ;    (+
 ;      ?gastos-administrativos
 ;       ?gastos-ventas
 ;       ?gastos-en-investigacion-y-desarrollo 
 ;       ?gastos-en-promocion
 ;       ?amortizacion-intangibles
 ;       ?depreciacion
 ;     )
 ; )

  (bind ?gastos-de-operacion
     (+
       ?gastos-administrativos
        ?gastos-ventas
        ?gastos-en-investigacion-y-desarrollo
        ?gastos-en-promocion
        ?amortizacion-intangibles
        ?depreciacion
        ?salarios
      )
  )

  (bind ?utilidad-de-operacion  (- ?utilidad-bruta ?gastos-de-operacion ?pea))
  (bind ?utilidad-antes-de-reserva ?utilidad-de-operacion)
  (bind ?utilidad-antes-de-idpc (- ?utilidad-de-operacion ?reserva-legal))

 ; (printout k ?empresa crlf)
 ;(printout k "================================================================================" crlf)
  ;( printout k crlf crlf )
  ( printout k "<br> <br> <br> <br> <br> <br> " crlf)
  ( printout k "Solo se consideran las transacciones hasta el día " ?top " de " ?mes_top "."  crlf )
  ( printout k "Cifras en pesos." crlf)
  ( printout k crlf)
  ( printout k "ESTADO DE RESULTADOS " crlf)
  ( printout k crlf )
  ( printout k "---|---|---|---|---|---|---|---|---|" crlf)
  ( printout k "|" ?ingresos-brutos "| Ingresos Brutos Percibidos A.29-LIR" crlf)
  ( printout k "| (+) " ?ventas "| Ventas" crlf)
  ( printout k "| (-) -  |  Rebajas sobre ventas" crlf)
  ( printout k "| (-) " ?devolucion-sobre-ventas "| Devoluciones sobre ventas" crlf)
  ( printout k "| (-) - | Descuentos sobre ventas" crlf)
  ( printout k "|||| (+) " ?ventas-netas "| Ventas Netas" crlf)
;  (printout k crlf)
  ( printout k "|||| (-) " ?costos-de-ventas "| Costos de Ventas A.30-LIR" crlf)
 ; (printout k crlf)
  (printout k "| (+)" ?compras "| Compras" crlf)
  (printout k "| (+)" ?gastos-sobre-compras "| Gastos sobre Compras" crlf)
 ;(printout k "|" ?compras-totales "| | | | Compras Totales" crlf)
  (printout k "| (-) 0 | Rebajas sobre Compras" crlf)
  (printout k "| (-) 0 | Devoluciones sobre Compras" crlf)
  (printout k "| (-) 0 | Descuentos sobre Compras" crlf)
  (printout k "| (=)" ?compras-totales "| Compras Netas" crlf)
;  (printout k crlf)
  (printout k "| (+) " ?inventario-inicial tab "| Inventario Inicial" crlf)
  (printout k "| (=) " ?existencias "| Mercadería Disponible para la Venta " crlf)
  (printout k "| (-) " ?inventario-final "| Inventario Final " crlf)
 ; (printout k crlf)
  (printout k "| | | | (=)" ?utilidad-bruta "| UTILIDAD BRUTA (Ventas Netas - Costo de Ventas)" crlf)
  (printout k "| | | | | (-) " ?gastos-de-operacion "| Gastos de Operación A.31-LIR)" crlf)

  (printout k "|" ?gastos-administrativos "| Gastos del Dpto Administración" crlf)
  (printout k "|" ?gastos-ventas "| Gastos del Dpto Ventas" crlf)
  (printout k "|" ?gastos-en-investigacion-y-desarrollo " | Gastos en I+D" crlf)
  (printout k "|" ?gastos-en-promocion "|  Gastos en Promocion" crlf)
  (printout k "|" ?amortizacion-intangibles "| Amortizacion Intangibles" crlf)
  (printout k "|" ?depreciacion "| Depreciacion" crlf)
  (printout k "|" ?salarios "| Salarios" crlf)

  (printout k "| | | | | (-) " ?pea " | Pérdida Ejercicio Anterior PEA A.33-LIR)" crlf)

 (printout k "| | | | " ?utilidad-de-operacion "| UTILIDAD DE OPERACION (U.Bruta - G.Op. - PEA)" crlf)
 (printout k "| | | | | (-) 0 | Otros Gastos" crlf)
 (printout k "| | | | (=)" ?utilidad-antes-de-reserva "| UTILIDAD ANTES DE RESERVA (U.Op-Reserva Lega)" crlf)
 (printout k "| | | | | (-) " ?reserva-legal "| Reserva Legal" crlf)
 (printout k "| | | | (=) " ?utilidad-antes-de-idpc "| RESULTADO DE EXPLOTACION" crlf)
 ; (printout k "|" tab tab  "|------------------------------------------------------------------" crlf)
 (printout k "| | | |     " ?utilidad-antes-de-idpc "| UTILIDAD ANTES DE IMPUESTO A LA RENTA (U.Antes.Reserva - idpc)" crlf)
 (printout k "| | | | | (-)" ?perdida-por-correccion-monetaria "| Pérdida por Corrección Monetaria" crlf)
 (printout k " | | | | | (+)" ?ganancia-por-correccion-monetaria "| Ganancia por Corrección Monetaria" crlf)
 (printout k " | | | | (=)" (- (+ ?utilidad-antes-de-idpc ?ganancia-por-correccion-monetaria) ?perdida-por-correccion-monetaria) "| RESULTADO FUERA DE EXPLOTACION" crlf )

 ( if (> ?utilidad-antes-de-idpc ?utilidad-del-ejercicio ) then
 (printout k "| | | | | (-) " ?idpc "| Impuesto Determinado, factor es " ?tasa-idpc " en " ?ano crlf))

 ( if (< ?utilidad-antes-de-idpc ?utilidad-del-ejercicio ) then
   (printout k "| | | | | (X) " ?idpc "| Impuesto que no se aplica por que hubo pérdida tributaria"  crlf))

 (printout k "| | | | (=) " ?utilidad-del-ejercicio "| UTILIDAD DEL EJERCICIO (U.Antes.idpc - idpc)" crlf) 

 ;(printout k "|" tab tab "|     ------" crlf)

;(printout k "| | | |" ?utilidad-antes-de-idpc "| UTILIDAD ANTES DE IMPUESTO A LA RENTA (U.Antes.Reserva - idpc)" crlf)
; (printout k "|" tab tab "| (-) " ?provision-impuesto-a-la-renta tab " Provisión de Impuesto Renta " crlf)
 
; (printout k "|" tab tab "| (=) " (- ?utilidad-antes-de-idpc ?provision-impuesto-a-la-renta) tab "UTILIDAD DEL EJERCICIO AJUSTADA (U.Ejercicio - Provision idpc)" crlf)
 ; (printout k "================================================================================" crlf)
)


