(defmodule INICIAL
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


(defrule inicio-de-modulo-inicial
  =>
   (printout t "-------------------- INICIAL ----------------------" crlf )
  ; (matches recuadro-de-balance )
;  (assert (balance (dia 31)))
)

(defrule recuadro-de-balance
   (declare (salience -9000))
   (empresa (nombre ?nombre) (razon ?razon))
   (balance (dia ?top))
   (subtotales (cuenta iva)           (deber ?iva-por-cobrar))
   (subtotales (cuenta iva)           (acreedor ?iva-por-pagar))

   (subtotales (cuenta efectivo-y-equivalentes) (deber ?efectivo)     )
;   (subtotales (cuenta compras)                 (deber ?compras)      )

   (subtotales (cuenta terreno)                 (deber ?terreno)  )
   (subtotales (cuenta edificio)                (deber ?edificio) )
   (subtotales (cuenta maquinaria)              (deber ?maquinaria) )
   (subtotales (cuenta mobiliario-y-equipo)     (deber ?mobiliario) )
   (subtotales (cuenta intangibles)             (deber ?intangibles) )
   (subtotales (cuenta inventario)              (deber ?inventario) )
   (subtotales (cuenta clientes)                (deber ?clientes) )

   (subtotales (cuenta capital-social)          (haber ?capital-social) )
   (subtotales (cuenta reserva-legal)           (haber ?reserva-legal) )
   (subtotales (cuenta utilidad)                (haber ?utilidad) )

   (subtotales (cuenta idpc)                (haber ?idpc) )


   (cuenta (nombre inventario) (saldo ?inventario-inicial) (verificada true) (partida 1))

   (subtotales (cuenta proveedores)             (acreedor ?proveedores)  )
   (subtotales (cuenta prestamo-bancario)       (acreedor ?prestamo-bancario) )

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

   ( printout t "=========================================================================" crlf )
   ( printout t ?razon crlf )
   ( printout t Empresa tab ?nombre crlf)
   ( printout t "Solo se consideran las transacciones hast el día " ?top crlf)
   ( printout t "               - PARTIDA GENERAL FINAL MARZO 2014 -"  crlf)
   ( printout t "                         CIFRAS EN PESOS                   "  crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t ACTIVO tab tab tab tab  "|" PASIVO crlf)
   ( printout t CIRCULANTE tab tab ?activo-circulante tab "|" CIRCULANTE tab tab ?pasivo-circulante crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t "Efectivo y" tab tab tab "!" crlf)
   ( printout t Equivalentes. tab ?efectivo tab tab "|" Proveedores. tab ?proveedores crlf)
   ( printout t Clientes..... tab ?clientes tab tab "|" "IVA por pagar" tab ?iva-por-pagar crlf)
   ( printout t Inventario... tab ?inventario tab tab "|" crlf)
   ( printout t IVA-por-cobrar tab ?iva-por-cobrar tab tab "!" Impuesto Renta tab ?idpc crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t ACTIVO tab tab tab  tab "|" PASIVO crlf)
   ( printout t FIJO tab tab tab ?activo-fijo tab "|"  FIJO tab tab tab ?pasivo-fijo crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t Terreno..... tab ?terreno tab tab         "|" Préstamos crlf)
   ( printout t Edificio.... tab ?edificio tab tab        "|" Bancarios.. tab ?prestamo-bancario crlf)

  ( printout t Maquinaria.. tab ?maquinaria tab tab      "|" --------------------------------------- crlf)
   ( printout t Mobiliario   tab tab tab                  "|" TOTAL crlf)
   ( printout t y.Equipo....  tab ?mobiliario tab tab    "|" PASIVO tab tab tab ?pasivos crlf)
   ( printout t Intangibles.  tab ?intangibles tab tab "|" ======================================= crlf)
 ;  ( printout t Compras.....  tab ?compras tab tab "!" ======================================= crlf)

   ( printout t tab  tab tab tab "|" tab tab PATRIMONIO crlf)
   ( printout t tab tab tab tab "|" PATRIMONIO tab tab ?patrimonio crlf)
   ( printout t tab tab tab tab "|" "Capital Social". ?capital-social crlf)
   ( printout t tab tab tab tab "|" "Reserva Legal".. ?reserva-legal crlf)
   ( printout t tab tab tab tab "|" "Utilidad del" crlf)
   ( printout t tab tab tab tab "|" "Ejercicio......" ?utilidad crlf)

   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t tab tab tab tab "|" TOTAL crlf)
   ( printout t TOTAL tab tab tab tab "|" "PASIVOS +" crlf)
   ( printout t ACTIVOS tab tab tab ?activos tab "|" PATRIMONIO tab tab (+ ?pasivos ?patrimonio) crlf)
   ( printout t "=========================================================================" crlf crlf crlf)
   ( assert (mostrar-inventario))
)

