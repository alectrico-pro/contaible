(defmodule FINAL
 (import MAIN deftemplate ?ALL)
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
  (declare (salience 10000) )
  =>
;   ( matches recuadro-de-balance)
;   ( halt )
;  ( printout t "-módulo-------------------------- FINAL --------" crlf )
)

(defrule preparacion-quitando-abono
  (declare (salience 10000) )
  ?abono <-  (abono)
  =>
  ( retract ?abono )
)


(defrule preparacion-quitando-cargo
  (declare (salience 10000) )
  ?cargo <-  (cargo)
  =>
  ( retract ?cargo )
)


(defrule recuadro-de-balance
   (empresa (nombre ?nombre) (razon ?razon))
   (balance (dia ?top) (mes ?mes_top) (ano ?ano))

 ;(subtotales (cuenta iva)           (acreedor ?iva-por-pagar))
; (subtotales (cuenta iva)           (deber    ?iva-por-cobrar))

   (subtotales (cuenta iva-credito)             (acreedor ?iva-credito-acreedor) (deber ?iva-credito-deber))
   (subtotales (cuenta iva-debito)              (acreedor ?iva-debito-acreedor) (deber ?iva-debito-deber))

   (subtotales (cuenta efectivo-y-equivalentes) (deber    ?efectivo-deber))
   (subtotales (cuenta efectivo-y-equivalentes) (acreedor ?efectivo-acreedor))
   (subtotales (cuenta gastos-administrativos)  (acreedor ?gastos-acreedor) (deber ?gastos-deber))

   (subtotales (cuenta terreno)                 (deber    ?terreno)  )
   (subtotales (cuenta edificio)                (deber    ?edificio) )
   (subtotales (cuenta maquinaria)              (deber    ?maquinaria) )
   (subtotales (cuenta mobiliario-y-equipo)     (deber    ?mobiliario) )
   (subtotales (cuenta intangibles)             (deber    ?intangibles) )
   (subtotales (cuenta clientes)                (deber    ?clientes) )
   (subtotales (cuenta colaboradores)           (deber    ?colaboradores) )

   (subtotales (cuenta capital-social)          (haber    ?capital-social) )

   (subtotales (cuenta proveedores)             (deber    ?proveedores-deber)  )
   (subtotales (cuenta proveedores)             (acreedor ?proveedores-acreedor)  )

   (subtotales (cuenta letras-por-pagar)        (deber    ?letras-por-pagar-deber ))
   (subtotales (cuenta letras-por-pagar)        (acreedor ?letras-por-pagar-acreedor))

   (subtotales (cuenta prestamo-bancario)       (acreedor ?prestamo-bancario) )
   (subtotales (cuenta reserva-legal)           (acreedor ?reserva-legal-acreedor) (deber ?reserva-legal-deber) )
   (subtotales (cuenta utilidad)                (acreedor ?utilidad-acreedor) (deber ?utilidad-deber) )

   (subtotales (cuenta idpc)                    (acreedor ?idpc-acreedor) (deber ?idpc-deber))
   (subtotales (cuenta inventario-final)        (deber ?inventario-final))
   (subtotales (cuenta inventario-inicial)      (deber ?inventario-inicial))

   (subtotales (cuenta documentos-por-cobrar)   (deber ?documentos-por-cobrar))
   (subtotales (cuenta retenciones-por-pagar )  (acreedor ?retencion))
   (subtotales (cuenta provision-impuesto-a-la-renta ) (debe ?provision-impuesto-a-la-renta))
   (subtotales (cuenta impuesto-a-la-renta-por-pagar) (acreedor ?impuesto-a-la-renta-por-pagar))
  ; (subtotales (cuenta ppm ) (deber ?ppm&:(> ?ppm 0)))
   (subtotales (cuenta ppm ) (deber ?ppm))
;  (subtotales (cuenta amortizacion-acumulada-intangibles)
 ;    (acreedor ?amortizacion-acumulada-intangibles&:(> ?amortizacion-acumulada-intangibles 0)))

   
   (subtotales (cuenta herramientas) (deber ?herramientas))
   (subtotales (cuenta depreciacion-acumulada-herramientas-y-enseres) (haber ?depreciacion))
   (totales
      (empresa ?empresa )
      (activos ?activos)
      (pasivos ?pasivos)
      (patrimonio ?patrimonio)
      (activo-circulante ?activo-circulante)
      (pasivo-circulante ?pasivo-circulante)
      (activo-fijo ?activo-fijo)
      (pasivo-fijo ?pasivo-fijo)
   )
  =>
   ( bind ?iva-por-cobrar (- ?iva-credito-deber ?iva-credito-acreedor ))
   ( bind ?iva-por-pagar  (- ?iva-debito-acreedor ?iva-debito-deber))
   ( printout t "=========================================================================" crlf )
   ( printout t ?razon crlf )
   ( printout t Empresa tab ?nombre crlf)
   
   ( printout t "Solo se consideran las transacciones hasta el día " ?top tab ?mes_top crlf)
   ( printout t "               - PARTIDA GENERAL FINAL " tab ?ano " -"  crlf)
   ( printout t "                         CIFRAS EN PESOS                   "  crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t ACTIVO tab tab tab tab  "|" PASIVO crlf)
   ( printout t CIRCULANTE tab tab ?activo-circulante tab "|" CIRCULANTE tab tab ?pasivo-circulante crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t "Efectivo y" tab tab tab "|" crlf)
   ( printout t Equivalentes. tab (- ?efectivo-deber ?efectivo-acreedor) tab tab "|" Proveedores. tab (- ?proveedores-acreedor ?proveedores-deber) crlf)

   ( printout t Clientes..... tab ?clientes tab tab "|" "IVA Débito" tab ?iva-por-pagar crlf)
   ( printout t tab tab tab tab "|" "Retenciones." tab  ?retencion crlf)
   ( printout t Colaboradores tab ?colaboradores tab tab "|" "Gastos..." tab (- ?gastos-acreedor ?gastos-deber) crlf)

   ( printout t "IVA Crédito..." tab ?iva-por-cobrar tab tab "|" crlf)

   ( printout t PPM ......... tab ?ppm tab tab "|" crlf)

   ( printout t Inventario tab tab tab "|" crlf)
   ( printout t Inicial...... tab ?inventario-inicial tab tab "|" crlf)


   ( printout t Inventario tab tab tab "|" crlf)
   ( printout t Final........ tab ?inventario-final tab tab "|" crlf)
 
   ( printout t tab tab tab tab "|Impuesto    " crlf)
   ( printout t tab tab tab tab "|Renta......." tab ?idpc-acreedor crlf)

   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t ACTIVO tab tab tab  tab "|" PASIVO crlf)
   ( printout t FIJO tab tab tab ?activo-fijo tab "|"  FIJO tab tab tab ?pasivo-fijo crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t Terreno..... tab ?terreno tab tab         "|" Prestamos crlf)
   ( printout t Edificio.... tab ?edificio tab tab        "|" Bancarios.. tab ?prestamo-bancario crlf)
   ( printout t tab tab tab tab "|" Letras-x-pagar tab (- ?letras-por-pagar-acreedor ?letras-por-pagar-deber) crlf)
   ( printout t Maquinaria.. tab ?maquinaria tab tab      "|" --------------------------------------- crlf)
   ( printout t Herramientas tab ?herramientas tab tab      "|" --------------------------------------- crlf)

   ( printout t Mobiliario   tab tab tab                  "|" TOTAL crlf)
   ( printout t y.Equipo....  tab ?mobiliario tab tab    "|" PASIVO tab tab tab ?pasivos crlf)
   ( printout t Intangibles.  tab ?intangibles tab tab "|" ======================================= crlf)
  ;( printout t Amortizacion  tab tab ?amortizacion-acumulada-intangibles tab "|" ======================================= crlf)

  ( printout t Dep. Acc. Herr.  tab tab ?depreciacion tab "|" ======================================= crlf)

   ( printout t tab  tab tab tab "|" tab tab PATRIMONIO crlf)
   ( printout t tab tab tab tab "|" PATRIMONIO tab tab ?patrimonio crlf)
   ( printout t tab tab tab tab "|" "Capital Social". ?capital-social crlf)
   ( printout t tab tab tab tab "|" "Reserva Legal".. (- ?reserva-legal-acreedor ?reserva-legal-deber) crlf)
   ( printout t tab tab tab tab "|" "Utilidad del "  crlf)
   ( printout t tab tab tab tab "|" "Ejercicio...... " (- ?utilidad-acreedor ?utilidad-deber) crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t tab tab tab tab "|" TOTAL crlf)
   ( printout t TOTAL tab tab tab tab "|" "PASIVOS +" crlf)
   ( printout t ACTIVOS tab tab tab ?activos tab "|" PATRIMONIO tab tab (+ ?pasivos ?patrimonio) crlf)
   ( printout t "=========================================================================" crlf crlf crlf)
)


