(defmodule RECUADRO (import MAIN deftemplate ?ALL))


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
  ( printout t "--modulo-------------- RECUADRO------------------" crlf )
)

(defrule estado-de-resultados-mensual-simplificado
  (empresa (nombre ?empresa))
  (subtotales (cuenta iva) (acreedor ?iva-debito) (deber ?iva-credito))

;  ( test (or (> ?iva-debito 0) (> ?iva-credito 0)))
 =>
  (printout t crlf crlf )
  (printout t "================================================================================" crlf)
  (printout t "ESTADO DE RESULTADOS SIMPLIFICADO" crlf)
  (printout t "================================================================================" crlf)
  (printout t "|" ?iva-credito tab tab tab tab  "IVA Credito" crlf)
  (printout t "|" ?iva-debito tab tab tab tab  "IVA Debito" crlf)
  (printout t "================================================================================" crlf)
  (printout t crlf crlf)

)

(defrule estado-de-resultados-mensual

  (empresa (nombre ?empresa))

  (subtotales (cuenta ventas) (haber ?ventas))
  (subtotales (cuenta devolucion-sobre-ventas) (debe ?devolucion-sobre-ventas))
  (subtotales (cuenta compras) (debe ?compras))
  (subtotales (cuenta gastos-sobre-compras) (debe ?gastos-sobre-compras))
  (subtotales (cuenta inventario-inicial) (debe ?inventario-inicial))
  (subtotales (cuenta inventario-final) (debe ?inventario-final))
  (subtotales (cuenta gastos-administrativos) (debe ?gastos-administrativos))
  (subtotales (cuenta gastos-ventas) (debe ?gastos-ventas))
  (subtotales (cuenta costos-de-ventas) (deber ?costos-de-ventas))
  (subtotales (cuenta idpc) (haber ?idpc))
  (subtotales (cuenta reserva-legal) (haber ?reserva-legal))
  (subtotales (cuenta utilidad) (haber ?utilidad-del-ejercicio))
  
 =>
  (bind ?ventas-netas           (- ?ventas ?devolucion-sobre-ventas))

  (bind ?compras-totales        (+ ?compras ?gastos-sobre-compras))
  (bind ?compras-netas          ?compras-totales)

  (bind ?existencias            (+ ?compras-netas ?inventario-inicial))
  ;mercaderia disponible para ventas

  (bind ?utilidad-bruta         (- ?ventas-netas ?costos-de-ventas))

  (bind ?gastos-de-operacion    (+ ?gastos-administrativos ?gastos-ventas))
  (bind ?utilidad-de-operacion  (- ?utilidad-bruta ?gastos-de-operacion))
  (bind ?utilidad-antes-de-reserva ?utilidad-de-operacion)
  (bind ?utilidad-antes-de-idpc (- ?utilidad-de-operacion ?reserva-legal))

  (printout t ?empresa crlf)
  (printout t "================================================================================" crlf)
  (printout t "ESTADO DE RESULTADOS" crlf)
  (printout t "================================================================================" crlf)
  (printout t "|" tab tab "|     " ?ventas tab "Ventas" crlf)
  (printout t "|" tab tab "| (-) -  " tab tab "Rebajas sobre ventas" crlf)
  (printout t "|" tab tab "| (-) " ?devolucion-sobre-ventas tab tab "Devoluciones sobre ventas" crlf)  
  (printout t "|" tab tab "| (-) -  " tab tab "Descuentos sobre ventas" crlf)
  (printout t "|" tab tab "| (=) " ?ventas-netas tab "Ventas Netas" crlf)
  (printout t crlf)
  (printout t "|" tab tab "| (-) " ?costos-de-ventas tab "Costos de Ventas" crlf)
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
  (printout t "|" tab tab "| (-) " ?gastos-de-operacion tab tab "Gastos de Operación (Gastos Admon + Gastos Vtas)" crlf)
  (printout t "|" ?gastos-administrativos tab tab tab tab  "Gastos del Dpto Administración" crlf)
  (printout t "|" ?gastos-ventas tab tab tab tab "Gastos del Dpto Ventas" crlf)
  (printout t "|" tab tab "|     " ?utilidad-de-operacion tab "UTILIDAD DE OPERACION (U.Bruta - G.Op.)" crlf)
  (printout t "|" tab tab "| (-) " tab tab tab "Otros Gastos" crlf)
  (printout t "|" tab tab "|     " ?utilidad-antes-de-reserva tab "UTILIDAD ANTES DE RESERVA (U.Op-Reserva Lega)" crlf)
  (printout t "|" tab tab  "| (-) " ?reserva-legal tab (* ?utilidad-antes-de-reserva 0.07) " Reserva Legal (7% de Utilidad de Operacion)" crlf)
  (printout t "|" tab tab "|     " ?utilidad-antes-de-idpc tab "UTILIDAD ANTES DE IMPUESTO A LA RENTA (U.Antes.Reserva - idpc)" crlf)
  (printout t "|" tab tab "| (-) " ?idpc tab (* ?utilidad-antes-de-idpc 0.25) " Impuesto a la Renta (25% de U.Antes.impuesto) (idpc 10% en 2020)" crlf)
  (printout t "|" tab tab "|     " ?utilidad-del-ejercicio tab (- ?utilidad-antes-de-idpc ?idpc) " UTILIDAD DEL EJERCICIO (U.Antes.idpc - idpc)" crlf) 
  (printout t "================================================================================" crlf)
)


