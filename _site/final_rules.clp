(defmodule FINAL ( import MAIN deftemplate ?ALL))




(defrule inicio-kindle
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))
   ( selecciones (archivo-unico-markdown ?archivo-unico) (nombre-de-archivo-k ?archivo-nombre))
  =>

  ( if (eq true ?archivo-unico)
     then
       ( bind ?archivo (str-cat "./doc/" ?empresa "/" ?archivo-nombre ".markdown"))
       ( open ?archivo k "a")
      else
       ( bind ?archivo (str-cat "./doc/" ?empresa "/final.markdown"))
       ( open ?archivo k "w")

        ( printout k "--- " crlf)
        ( printout k "title: Balance Final" crlf)
;        ( printout k "permalink: /" ?empresa "/final" crlf)
        ( printout k "layout: page" crlf)
        ( printout k "--- " crlf)
        ( printout k "" crlf)
  ) 
;  ( printout k "<h1> Balance </h1>" crlf)
)



(defrule fin
  ( declare (salience -10000) )
 =>
  ( close k )
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


(deftemplate utilidad
  (slot determinada (default false)))

(defrule inicio-sin-utilidad-tributaria
  (declare (salience 10000) )
  (cuenta (nombre utilidad-tributaria) (debe ?utilidad-tributaria&:(=  ?utilidad-tributaria 0)))
  =>
   ( assert (utilidad (determinada false)))
   ( printout t "-módulo-------------------------- FINAL -- SIN utilidad tributaria ------"crlf )
;   ( matches  recuadro-de-balance )
 ;  ( halt )
)


(defrule inicio-con-utilidad-tributaria
  (declare (salience 10000) )
  (cuenta (nombre utilidad-tributaria) (debe ?utilidad-tributaria&:(> ?utilidad-tributaria 0)) )
  =>
   ( assert (utilidad (determinada true)))
   ( printout t "-módulo-------------------------- FINAL -- CON utilidad tributaria ------" crlf )
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


(deftemplate info
  (slot inventario-final-liquidado )
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


(defrule recuadro-de-balance
   (empresa (nombre ?nombre) (razon ?razon))
   (balance (dia ?top) (mes ?mes_top) (ano ?ano))
 

  ( info (inventario-final-liquidado ?inventario-final-liquidado))
  
 ;(subtotales (cuenta iva)           (acreedor ?iva-por-pagar))
; (subtotales (cuenta iva)           (deber    ?iva-por-cobrar))

   (subtotales (cuenta iva-credito)             (acreedor ?iva-credito-acreedor) (deber ?iva-credito-deber))
   (subtotales (cuenta iva-debito)              (acreedor ?iva-debito-acreedor) (deber ?iva-debito-deber))

  (subtotales (cuenta retencion-de-iva-articulo-11) (acreedor ?retencion-de-iva))

  ; (subtotales (cuenta efectivo-y-equivalentes) (deber    ?efectivo-deber))
  ; (subtotales (cuenta efectivo-y-equivalentes) (acreedor ?efectivo-acreedor))
  (subtotales (cuenta caja)                    (deber    ?caja-deber))
  (subtotales (cuenta caja)                    (acreedor ?caja-acreedor))

  (subtotales (cuenta banco-estado)            (deber    ?banco-estado-deber))
  (subtotales (cuenta banco-estado)            (acreedor ?banco-estado-acreedor))

   (subtotales (cuenta gastos-administrativos)  (acreedor ?gastos-acreedor) (deber ?gastos-deber))

   (subtotales (cuenta ingresos-percibidos-por-adelantado)  (acreedor ?ingresos-adelantados))

   (subtotales (cuenta terreno)                 (deber    ?terreno)  )
   (subtotales (cuenta edificio)                (deber    ?edificio) )
   (subtotales (cuenta maquinaria)              (deber    ?maquinaria) )
   (subtotales (cuenta mobiliario-y-equipo)     (deber    ?mobiliario) )
;   (subtotales (cuenta intangibles)             (deber    ?intangibles) )

   (subtotales (cuenta marca-alectrico)         (deber    ?marca-alectrico) )

   (subtotales (cuenta plataforma-alectrico)    (deber    ?plataforma-alectrico) )

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

   (subtotales (cuenta inventario)              (deber    ?inventario-deber)
                                                (acreedor ?inventario-acreedor))
   
   (subtotales (cuenta inventario-inicial)      (deber    ?inventario-inicial-deber)
                                                (acreedor ?inventario-inicial-acreedor))

 ; ( subtotales (cuenta materiales)              (deber ?materiales ) )

   ( subtotales (cuenta insumos)                 (deber ?insumos) )


   (subtotales (cuenta documentos-por-cobrar)   (deber ?documentos-por-cobrar))
   (subtotales (cuenta cuentas-por-cobrar)      (deber ?cuentas-por-cobrar))


   (subtotales (cuenta salarios-por-pagar )     (deber ?salarios-por-pagar-deber))
   (subtotales (cuenta salarios-por-pagar )     (acreedor ?salarios-por-pagar-acreedor))


   ;subtotales (cuenta retenciones-por-pagar )  (acreedor ?retencion))
   (subtotales (cuenta provision-impuesto-a-la-renta ) (debe ?provision-impuesto-a-la-renta))
   (subtotales (cuenta impuesto-a-la-renta-por-pagar) (acreedor ?impuesto-a-la-renta-por-pagar))
  ; (subtotales (cuenta ppm ) (deber ?ppm&:(> ?ppm 0)))
   (subtotales (cuenta ppm ) (deber ?ppm))
   (subtotales (cuenta amortizacion-acumulada-intangibles)
     (acreedor ?amortizacion-acumulada-intangibles&:(> ?amortizacion-acumulada-intangibles 0)))

   
   (subtotales (cuenta herramientas) (deber ?herramientas))
   (subtotales (cuenta depreciacion-acumulada-herramientas) (haber ?depreciacion))
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
   (utilidad (determinada ?hay-utilidad-tributaria))

   (subtotales (cuenta software) (deber ?software))

   (subtotales (cuenta licencia-contaible) (deber ?licencia-contaible))

   (subtotales (cuenta aumentos-de-capital-aportes) (acreedor ?aportes))

   (subtotales (cuenta utilidades-acumuladas) (acreedor ?utilidades-acumuladas))
   
   (subtotales (cuenta autorizacion-uso-de-inmueble) (acreedor ?autorizacion-uso-de-inmueble))

   (subtotales (cuenta revalorizacion-del-capital-propio) (acreedor ?revalorizacion-del-capital-propio))

   (subtotales (cuenta plataforma-ccm) (acreedor ?plataforma-ccm))

   (subtotales (cuenta utilidad-del-ejercicio-anterior) (acreedor ?utilidad-del-ejercicio-anterior))

  =>

   ( bind ?inventario-inicial (- ?inventario-inicial-deber ?inventario-inicial-acreedor))

   ;si el inventario-final se ha liquidado entonces no hay inventario
   ( if (eq ?inventario-final-liquidado true)
    then
     ( bind ?inventario  0)
    else
     ( bind ?inventario  (- ?inventario-deber          ?inventario-acreedor))
   )

   ( bind ?iva-por-cobrar (- ?iva-credito-deber ?iva-credito-acreedor ))
   ( bind ?iva-por-pagar  (- ?iva-debito-acreedor ?iva-debito-deber))
   ( printout t "=========================================================================" crlf )

  ;( printout k "<section>" crlf )
 ; ( printout k "<h2> PARTIDA GENERAL FINAL </h2>" crlf) 
   ( printout k "Solo se consideran las transacciones hasta el día " ?top tab ?mes_top "."  crlf)
   ( printout k "Cifras en pesos." crlf)
   ( printout k "<table>" crlf)
   ( printout k "<tr> <td colspan='6'> PARTIDA GENERAL FINAL " ?ano " </td> </tr> " crlf)
   ( printout k "<tr> <td>  ACTIVO CIRCULANTE </td> <td align='right' > "?activo-circulante "</td>" crlf)
   ( printout k "<td > PASIVO CIRCULANTE </td> <td align='right' >" ?pasivo-circulante "</td> </tr>" crlf)

   ( printout k "<tbody>" crlf)
 ; ( printout k "<tr> <td> Efectivo y Equivalentes </td> <td>" (- ?efectivo-deber ?efectivo-acreedor) "</td> <td> Proveedores. </td> <td> " (- ?proveedores-acreedor ?proveedores-deber) "</td> </tr>" crlf)
   ( printout k "<tr> <td> Caja </td> <td align='right' >" (- ?caja-deber ?caja-acreedor) "</td> <td> Proveedores. </td> <td align='right' > " (- ?proveedores-acreedor ?proveedores-deber) "</td> </tr>" crlf)

   ( printout k "<tr> <td> Banco Estado </td> <td align='right'  >" (- ?banco-estado-deber ?banco-estado-acreedor) "</td></tr>" crlf)

   ( printout k "<tr> <td> Clientes </td> <td align='right' >" ?clientes "</td> <td >  IVA Débito </td> <td align='right'>" ?iva-por-pagar "</td> </tr>" crlf)

   ( printout k "<tr> <td> Cuentas por Cobrar </td> <td align='right' >" ?cuentas-por-cobrar "</td></tr>" crlf)
   ( printout k "<tr> <td> Retenciones </td> <td align='right' style='font-weight:bold; color: white; background-color: crimson'>(  " ?retencion-de-iva  ")</td> </tr> " crlf)

   ( printout k "<tr> <td> Colaboradores </td> <td align='right' > " ?colaboradores "</td> " crlf)
   ( printout k "<td> SalariosXPagar </td> <td align='right'> " (- ?salarios-por-pagar-acreedor ?salarios-por-pagar-deber) "</td></tr> " crlf)

   ( printout k "<tr> <td> IVA Crédito </td><td align='right' >" ?iva-por-cobrar "</td> " crlf)
   ( printout k "<td> Ingresos Adelantados </td> </tr>" crlf)

   ( printout k "<tr> <td> PPM </td> <td align='right' >" ?ppm "</td></tr> " crlf)
;   ( printout k "<tr> <td> Inventario Inicial </td> <td>" ?inventario-inicial "</td> </tr>" crlf)

 ;  ( printout k "<tr> <td> Materiales </td> <td>" ?materiales "</td> </tr>" crlf)


   ( printout k "<tr> <td> Insumos</td> <td align='right'>" ?insumos "</td> </tr>" crlf)

   ( if (eq diciembre ?mes_top)
     then
;     ( printout k "<tr> <td> Materiales </td> <td align='right' >" ?materiales "</td> </tr>" crlf)

     ( printout k "<tr> <td> Inventario </td>" crlf)
     ( printout k "<td align='right'>"  ?inventario "</td> </tr> " crlf)
     else
    ( printout k "<tr> <td> Inventario </td>" crlf)
    ( printout k "<td align='right'>" ?inventario  "</td> </tr>" crlf)

;    ( printout k "<tr> <td> Materiales </td>" crlf)
;    ( printout k "<td align='right' >" ?materiales "</td> </tr>" crlf)
   )

;  ( printout k "<td>"  ?inventario "</td> " crlf)

   ( if (eq true ?hay-utilidad-tributaria) then 

     ( printout k "<tr><td> Impto Rta Determ. </td> <td align='right'>" ?idpc-acreedor "</td> ")
     ( printout k "</tr>" crlf)

   )
   ( printout k "<tr><td> ACTIVO FIJO </td> <td align='right'>" ?activo-fijo "</td></tr> " crlf )
   ( printout k "<tr><td> PASIVO FIJO </td> <td align='right'>" ?pasivo-fijo "</td></tr> " crlf)

   ( printout k "<tr> <td> Terreno </td> <td align='right'>"  ?terreno "</td> " crlf)
   ( printout k "<td> Préstamo Bancarios </td> <td align='right'>" ?prestamo-bancario "</td> </tr>" crlf)

   ( printout k "<tr><td> Edificio </td> <td align='right'>" ?edificio "</td> </tr>" crlf)

   ( printout k "<tr><td> Maquinaria </td> <td align='right'>" ?maquinaria "</td> <td colspan='2'> </td> </tr>" crlf)
   ( printout k "<tr><td> Herramientas </td> <td align='right'>" ?herramientas "</td> <td colspan='2'> </td> </tr>" crlf)

   ( printout k "<tr><td> Mobiliario y Equipamiento </td><td align='right' > 0 </td> <td colspan='2'> </td> </tr>" crlf)
   ( printout k "<tr><td> Marca alectrico ® </td> <td align='right'>" ?marca-alectrico "</td> <td colspan='2'> </td> </tr>" crlf)
   ( printout k "<tr><td> Plataforma alectrico ® </td> <td align='right'>" ?plataforma-alectrico "</td> <td colspan='2'> </td> </tr>" crlf)
   ( printout k "<tr><td> Plataforma CCM SII® </td> <td align='right'>" ?plataforma-ccm"</td> <td colspan='2'> </td> </tr>" crlf)


;  ( printout k "<tr><td> Software   </td> <td>" ?software "</td> <td colspan='2'> </td> </tr>" crlf)

   ( printout k "<tr><td> Licencia Contaible ®  </td> <td align='right'>" ?licencia-contaible "</td> <td colspan='2'> </td> </tr>" crlf)

   ( printout k "<tr><td> Autorización Uso de Inmueble </td> <td align='right'>" ?autorizacion-uso-de-inmueble "</td> <td colspan='2'> </td> </tr>" crlf)


   ( printout k "<tr><td> Amortización Acumulada Intangibles </td> <td align='right' style='font-weight:bold; color: white; background-color: crimson'>(" ?amortizacion-acumulada-intangibles ")</td> <td colspan='2'> </td> </tr>" crlf)
   ( printout k "<tr><td> Depreciación Acumulada Herramientas </td> <td align='right' style='font-weight:bold; color: white; background-color: crimson'>("  ?depreciacion ")</td><td colspan='2'> </td> </tr>" crlf)
   ( printout k "<tr> <td> </td> <td> </td> <td> TOTAL PASIVO </td> <td align='right'> " ?pasivos "</td></tr>"  crlf)

   ( printout k "<tr> <td> </td> <td> </td> <td> PATRIMONIO </td> <td align='right'>" ?patrimonio "</td> </tr>")
   ( printout k "<tr> <td colspan='2'></td> <td> Capital Social </td><td align='right'> " ?capital-social "</td> </tr>" crlf)

   ( printout k "<tr> <td colspan='2'></td> <td> Reserva Legal </td> <td align='right' >" (- ?reserva-legal-acreedor ?reserva-legal-deber) "</td> </tr>" crlf) 

   ( printout k "<tr> <td colspan='2'></td> <td> Utilidades Acumuladas </td> <td align='right' >" ?utilidades-acumuladas "</td> </tr>" crlf)

   ( printout k "<tr> <td colspan='2'></td> <td> Utilidad del Ejercicio Anterior </td> <td align='right' >" ?utilidad-del-ejercicio-anterior "</td> </tr>" crlf)


   ( printout k "<tr> <td colspan='2'></td> <td> Revalorización del Capital Propio </td> <td align='right' >" ?revalorizacion-del-capital-propio "</td> </tr>" crlf)


   ( printout k "<tr> <td colspan='2'></td> <td> Utilidad del Ejercicio </td><td align='right'>" (- ?utilidad-acreedor ?utilidad-deber) "</td> </tr>" crlf)

;   ( printout k "<thead><th>TOTAL ACTIVOS</th><th>" ?activos "</th><th>TOTAL PASIVO + PATRIMONIO</th><th>" (+ ?pasivos ?patrimonio) "</th></thead>" crlf)

  ( if (eq (+ ?pasivos ?patrimonio) ?activos)
    then
     ( printout k "<tr><td>TOTAL ACTIVOS</td><td style='background-color: lightgreen'>" ?activos "</td><td>TOTAL PASIVO + PATRIMONIO</td><td style='background-color: lightgreen'>" (+ ?pasivos ?patrimonio) "</td></tr>" crlf)
    else
     ( printout k "<tr><td>TOTAL ACTIVOS</td><td style='background-color: crimson'>" ?activos "</td><td>TOTAL PASIVO + PATRIMONIO</td><td style='background-color: crimson'>" (+ ?pasivos ?patrimonio) "</td></tr>" crlf)
   )

   ( printout k "<tr><td colspan='8'> " ?razon  " </td> </tr>" crlf)
   ( printout k "<tr><td colspan='8'> Partida General Final " ?ano " " ?razon "</td></tr>" crlf)



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
;  ( printout t Equivalentes. tab (- ?efectivo-deber ?efectivo-acreedor) tab tab "|" Proveedores. tab (- ?proveedores-acreedor ?proveedores-deber) crlf)


  ( printout t Caja....... tab (- ?caja-deber ?caja-acreedor) tab tab "|" Proveedores. tab (- ?proveedores-acreedor ?proveedores-deber) crlf)

  ( printout t BancoEstado. tab (- ?banco-estado-deber ?banco-estado-acreedor) tab tab "|"  crlf)


   ( printout t Clientes..... tab ?clientes tab tab "|" "IVA Débito" tab ?iva-por-pagar crlf)
   ( printout t CuentasXCobrar tab ?cuentas-por-cobrar tab tab "|" crlf)

;   ( printout t tab tab tab tab "|" "Retenciones." tab  ?retencion-de-iva crlf)
   ( printout t Colaboradores tab ?colaboradores tab tab "|" "SalariosXPagar" tab ?salarios-por-pagar-deber tab ?salarios-por-pagar-acreedor crlf)

   ( printout t "IVA Crédito..." tab ?iva-por-cobrar tab tab "|" "Ing.Adelant." tab ?ingresos-adelantados crlf)

   ( printout t "Retención IVA.." tab (- 0 ?retencion-de-iva) crlf)

   ( printout t PPM ......... tab ?ppm tab tab "|" crlf)


;  ( printout t Inventario tab tab tab "|" crlf)
 ; ( printout t Inicial...... tab ?inventario-inicial tab tab "|" crlf)

  ( printout t Insumos..... tab ?insumos tab tab "|" crlf)


;  ( if (eq diciembre ?mes_top)
;     then
;     ( printout t Materiales tab ?materiales crlf)
     ( printout t "Inventario" tab  ?inventario crlf)
 ;    else
 ;   ( printout t Inventario tab ?inventario  crlf)
  ;  ( printout t Materiales tab ?materiales  crlf)
  ; )


   ( if (eq true ?hay-utilidad-tributaria) then 
     ( printout t tab tab tab tab "|Impuesto    " crlf)
     ( printout t tab tab tab tab "|Renta.Determ." tab ?idpc-acreedor crlf)
   )

   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t ACTIVO tab tab tab  tab "|" PASIVO crlf)
   ( printout t FIJO tab tab tab ?activo-fijo tab "|"  FIJO tab tab tab ?pasivo-fijo crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t Terreno..... tab ?terreno tab tab         "|" Prestamos crlf)
   ( printout t Edificio.... tab ?edificio tab tab        "|" Bancarios.. tab ?prestamo-bancario crlf)
  ; ( printout t tab tab tab tab "|" Letras-x-pagar tab (- ?letras-por-pagar-acreedor ?letras-por-pagar-deber) crlf)
   ( printout t Maquinaria.. tab ?maquinaria tab tab      "|" crlf)
   ( printout t Herramientas tab ?herramientas tab tab      "|" --------------------------------------- crlf)

   ( printout t Mobiliario   tab tab tab                  "|" TOTAL crlf)
   ( printout t y.Equipo....  tab ?mobiliario tab tab    "|" PASIVO tab tab tab ?pasivos crlf)
;   ( printout t Intangibles.  tab ?intangibles tab tab "|" ======================================= crlf)

   ( printout t m. alectrico ®.  tab ?marca-alectrico tab tab "|" ======================================= crlf)

   ( printout t p. alectrico ®.  tab ?plataforma-alectrico tab tab "|"  crlf)

   ( printout t alectrico ®.  tab ?software tab tab "|"  crlf)

   ( printout t alectrico ®.  tab ?licencia-contaible tab tab "|" crlf)
   ( printout t alectrico ®.  tab ?plataforma-ccm tab tab "|" crlf)



   ( printout t Aut Inmueble tab ?autorizacion-uso-de-inmueble tab tab "|" crlf)


   ( printout t Amortizacion  tab tab ?amortizacion-acumulada-intangibles tab "|" crlf)

   ( printout t Dep. Acc. Herr.  tab tab ?depreciacion tab "|" crlf)

   ( printout t tab  tab tab tab "|" tab tab PATRIMONIO crlf)
   ( printout t tab tab tab tab "|" PATRIMONIO tab tab ?patrimonio crlf)
   ( printout t tab tab tab tab "|" "Capital Social". ?capital-social crlf)
   ( printout t tab tab tab tab "|" "Reserva Legal".. (- ?reserva-legal-acreedor ?reserva-legal-deber) crlf)
   ( printout t tab tab tab tab "|" "Utilidad Ejr.Anterior".. ?utilidad-del-ejercicio-anterior crlf)

   ( printout t tab tab tab tab "|" "Utilidades AC".. ?utilidades-acumuladas crlf)
   ( printout t tab tab tab tab "|" "Aportes".. ?aportes crlf)
   ( printout t tab tab tab tab "|" "Rev.Capital" ?revalorizacion-del-capital-propio crlf)
   ( printout t tab tab tab tab "|" "Utilidad del "  crlf)
   ( printout t tab tab tab tab "|" "Ejercicio...... " (- ?utilidad-acreedor ?utilidad-deber) crlf)
   ( printout t "------------------------------------------------------------------------" crlf)
   ( printout t tab tab tab tab "|" TOTAL crlf)
   ( printout t TOTAL tab tab tab tab "|" "PASIVOS +" crlf)

   ( if (neq (+ ?pasivos ?patrimonio) ?activos )
     then
      (printout t  "Error " Desbalance-en-Balance-Final crlf)
      (halt)
   )
     
   ( printout t ACTIVOS tab tab tab ?activos tab "|" PATRIMONIO tab tab (+ ?pasivos ?patrimonio) crlf)
   ( printout t "=========================================================================" crlf crlf crlf)

 ; ( printout k "==================================================================" crlf)
  ( printout k "</tbody>" crlf)
  ( printout k "</table>" crlf)
 ;( printout k "</section>" crlf )


)


