;esto no se ocupa, ha sido reemplazo por tributario_rules.clp
(defmodule RESULTADO (import MAIN deftemplate ?ALL))


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
  ( printout t "--modulo-------------- RESULTADO------------------" crlf )
)

(defrule estado-de-resultados-mensual
  ( balance (mes ?mes) (ano ?ano ))
  ( empresa (nombre ?empresa))

  ( subtotales (cuenta ventas-con-eboleta-afecta ) ( debe ?ventas-con-eboleta-afecta))
  ( subtotales (cuenta ventas-con-eboleta-exenta ) ( debe ?ventas-con-eboleta-exenta))
  ( subtotales (cuenta ventas-con-factura-afecta ) ( debe ?ventas-con-factura-afecta))
  ( subtotales (cuenta ventas-con-factura-exenta ) ( debe ?ventas-con-factura-exenta))
  ( subtotales (cuenta ventas-con-voucher-afecto ) ( debe ?ventas-con-voucher-afecto))


  ( subtotales (cuenta ingresos-brutos) (acreedor ?ingresos-brutos))
  ( subtotales (cuenta ventas) (acreedor ?ventas))
  ( subtotales (cuenta devolucion-sobre-ventas) (debe ?devolucion-sobre-ventas))
  ( subtotales (cuenta compras) (debe ?compras))
  ( subtotales (cuenta gastos-sobre-compras) (debe ?gastos-sobre-compras))
  ( subtotales (cuenta inventario-inicial) (debe ?inventario-inicial))
  ( subtotales (cuenta inventario-final) (debe ?inventario-final))

  ( subtotales (cuenta gastos-administrativos) 
    (debe  ?gastos-administrativos-debe)
    (haber ?gastos-administrativos-haber))


  ( subtotales (cuenta gastos-ventas) (deber ?gastos-ventas))
  ( subtotales (cuenta gastos-en-investigacion-y-desarrollo) (deber ?gastos-en-investigacion-y-desarrollo))
  ( subtotales (cuenta gastos-promocionales) (debe ?gastos-en-promocion))
  ( subtotales (cuenta costos-de-ventas) (deber ?costos-de-ventas&:(> ?costos-de-ventas 0 )))

  ( subtotales (cuenta idpc) (deber ?idpc))
  ( subtotales (cuenta reserva-legal) (haber ?reserva-legal))
  ( subtotales (cuenta utilidad) (acreedor ?utilidad-del-ejercicio-haber)
                                (deber ?utilidad-del-ejercicio-debe)
  )

  ( subtotales (cuenta provision-impuesto-a-la-renta ) (acreedor ?provision-impuesto-a-la-renta))
  ( subtotales (cuenta amortizacion-intangibles ) (debe ?amortizacion-intangibles))
  ( subtotales (cuenta depreciacion ) (debe ?depreciacion))
  ( subtotales (cuenta salarios ) (debe ?salarios))

  ( subtotales (cuenta impuesto-a-la-renta-por-pagar) (acreedor ?impuesto-a-la-renta-por-pagar))
  ( subtotales (cuenta perdidas-ejercicios-anteriores) (debe ?pea))

  ( subtotales (cuenta perdida-por-correccion-monetaria)
     (debe ?perdida-por-correccion-monetaria )) 
 
  ( subtotales (cuenta ganancia-por-correccion-monetaria)
     (haber ?ganancia-por-correccion-monetaria )) 
 
  ( tasas (idpc ?tasa-idpc) (mes diciembre) (ano ?ano))  

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

; (bind ?gastos-de-operacion 
;    (+
;      ?gastos-administrativos
;       ?gastos-ventas
;       ?gastos-en-investigacion-y-desarrollo 
;       ?gastos-en-promocion
;       ?amortizacion-intangibles
;       ?depreciacion
;     )
 ;)

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

  (printout t ?empresa crlf)
  (printout t "================================================================================" crlf)
  (printout t tab tab "ESTADO DE RESULTADOS" crlf)
  (printout t ?mes tag ?ano crlf)
  (printout t "================================================================================" crlf)
  (printout t "|" tab tab "|     " ?ingresos-brutos tab "Ingresos Brutos Percibidos A.29-LIR" crlf)
  (printout t "|" tab tab "|     " ?ventas tab "Ventas" crlf)
  (printout t "|" tab tab tab ?ventas-con-eboleta-afecta tab "Vtas eBoleta Afecta" crlf)
  (printout t "|" tab tab tab ?ventas-con-eboleta-exenta tab "Vtas eBoleta Exenta" crlf)
  (printout t "|" tab tab tab ?ventas-con-factura-afecta tab "Vtas Factura Afecta" crlf)
  (printout t "|" tab tab tab ?ventas-con-factura-exenta tab "Vtas Factura Exenta" crlf)
  (printout t "|" tab tab tab ?ventas-con-voucher-afecto tab "Vtas Voucher Afecto" crlf)
  (printout t "|" tab tab "| (-) -  " tab tab "Rebajas sobre ventas" crlf)
  (printout t "|" tab tab "| (-) " ?devolucion-sobre-ventas tab tab "Devoluciones sobre ventas" crlf)  
  (printout t "|" tab tab "| (-) -  " tab tab "Descuentos sobre ventas" crlf)
  (printout t "|" tab tab "| (=) " ?ventas-netas tab "Ventas Netas" crlf)
  (printout t crlf)
  (printout t "|" tab tab "| (-) " ?costos-de-ventas tab "Costos de Ventas A.30-LIR" crlf)
  (printout t crlf) 
  (printout t "|" ?compras tab tab tab tab "Compras" crlf)
  (printout t "| (+) " ?gastos-sobre-compras tab tab tab tab"Gastos sobre Compras" crlf)
  (printout t "|" ?compras-totales tab tab tab tab "Compras Totales" crlf)
  (printout t "| (-) - " tab tab tab tab "Rebajas sobre Compras" crlf)
  (printout t "| (-) - " tab tab tab tab "Devoluciones sobre Compras" crlf)
  (printout t "| (-) - " tab tab tab tab "Descuentos sobre Compras" crlf)
  (printout t "|" ?compras-totales tab tab tab tab "Compras Netas" crlf)
  (printout t crlf)
  (printout t "| (+) " ?inventario-inicial tab "|" tab tab "Inventario Inicial" crlf)
  (printout t "| (=) " ?existencias tab "|" tab tab "Mercadería Disponible para la Venta " crlf)
  (printout t "| (-) " ?inventario-final tab "|" tab tab "Inventario Final " crlf)
  (printout t crlf)
  (printout t "|" tab tab "|     " ?utilidad-bruta tab "UTILIDAD BRUTA (Ventas Netas - Costo de Ventas)" crlf)
  (printout t "|" tab tab "| (-) " ?gastos-de-operacion tab tab "Gastos de Operación (Gastos Admon + Gastos Vtas + I+D + Promocion + Amortiza.Int A.31-LIR)" crlf)
  (printout t "|" ?gastos-administrativos tab tab tab tab  "Gastos del Dpto Administración" crlf)
  (printout t "|" ?gastos-ventas tab tab tab tab "Gastos del Dpto Ventas" crlf)
  (printout t "|" ?gastos-en-investigacion-y-desarrollo tab tab tab tab "Gastos en I+D" crlf)
  (printout t "|" ?gastos-en-promocion tab tab tab tab "Gastos en Promocion" crlf)
  (printout t "|" ?amortizacion-intangibles tab tab tab tab "Amortizacion Intangibles" crlf)
  (printout t "|" ?depreciacion tab tab tab tab "Depreciacion" crlf)
  (printout t "|" ?salarios tab tab tab tab "Salarios" crlf)
  (printout t "|" tab tab "| (-) " ?pea tab tab "Pérdida Ejercicio Anterior PEA A.33-LIR)" crlf)
  (printout t "|" tab tab "|     " ?utilidad-de-operacion tab "UTILIDAD DE OPERACION (U.Bruta - G.Op. - PEA)" crlf)
  (printout t "|" tab tab "| (-) " tab tab tab "Otros Gastos" crlf)
  (printout t "|" tab tab "|     " ?utilidad-antes-de-reserva tab "UTILIDAD ANTES DE RESERVA (U.Op-Reserva Lega)" crlf)
  (printout t "|" tab tab  "| (-) " ?reserva-legal tab " Reserva Legal" crlf)
  (printout t "|" tab tab  "| (=) " ?utilidad-antes-de-idpc tab "RESULTADO DE EXPLOTACION" crlf)
  (printout t "|" tab tab  "|------------------------------------------------------------------" crlf)
  (printout t "|" tab tab "|     " ?utilidad-antes-de-idpc tab "UTILIDAD ANTES DE IMPUESTO A LA RENTA (U.Antes.Reserva - idpc)" crlf)
  (printout t "|" ?perdida-por-correccion-monetaria tab tab tab tab "Pérdida por Corrección Monetaria" crlf)
  (printout t "|" ?ganancia-por-correccion-monetaria tab tab tab tab "Ganancia por Corrección Monetaria" crlf)
  (printout t "|" tab tab "|     " (- (+ ?utilidad-antes-de-idpc ?ganancia-por-correccion-monetaria) ?perdida-por-correccion-monetaria) tab "RESULTADO FUERA DE EXPLOTACION" crlf )
  ( if (> ?utilidad-antes-de-idpc ?utilidad-del-ejercicio ) then 
  (printout t "|" tab tab "| (-) " ?idpc tab "Impuesto Determinado, factor es " ?tasa-idpc " en " ?ano crlf))
  ( if (< ?utilidad-antes-de-idpc ?utilidad-del-ejercicio ) then 
  (printout t "|" tab tab "| (X) " ?idpc tab "Impuesto Que no se Aplica porque hubo pérdida tributaria" crlf))
  (printout t "|" tab tab "| (=) " ?utilidad-del-ejercicio tab "UTILIDAD DEL EJERCICIO (U.Antes.idpc - idpc)" crlf) 

 ;(printout t "|" tab tab "|     ------" crlf)

; (printout t "|" tab tab "|     " ?utilidad-antes-de-idpc tab "UTILIDAD ANTES DE IMPUESTO A LA RENTA (U.Antes.Reserva - idpc)" crlf)
; (printout t "|" tab tab "| (-) " ?provision-impuesto-a-la-renta tab " Provisión de Impuesto Renta " crlf)
 
; (printout t "|" tab tab "| (=) " (- ?utilidad-antes-de-idpc ?provision-impuesto-a-la-renta) tab "UTILIDAD DEL EJERCICIO AJUSTADA (U.Ejercicio - Provision idpc)" crlf)
  (printout t "================================================================================" crlf)
)


