( defmodule VALOR_ACTIVOS ( import MAIN deftemplate ?ALL))
;Este modulo recalcula los totales para luego efectuar cálculos de IVA sobre ellos


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


(deffunction numero_to_mes ( ?numero )
  ( switch ?numero
    ( case 1   then enero)
    ( case 2   then febrero)
    ( case 3   then marzo)
    ( case 4   then abril)
    ( case 5   then mayo)
    ( case 6   then junio)
    ( case 7   then julio)
    ( case 8   then agosto)
    ( case 9   then septiembre)
    ( case 10  then octubre)
    ( case 11  then noviembre)
    ( case 12  then diciembre)
    ( case 13  then enero)
    ( case 14  then febrero)
  )
)


(deffunction proximo_mes ( ?mes )
;  (numero_to_mes( (+ mes_to_numero( ?mes ) 1 )) )
)


(deftemplate hacer
  (slot cuenta)
  (slot mes)
)


(deffunction to_serial_date( ?dia ?mes ?ano)
  (+ (* 10000 ?ano) (* 100 ( mes_to_numero ?mes)) ?dia)
)


;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-valor-activos-rules

   ( declare (salience 10000))
   ( empresa (nombre ?empresa))

  =>

   ( bind ?archivo (str-cat "./doc/" ?empresa "/valor-activos.markdown"))
   ( open ?archivo k "w")
   ( printout k "--- " crlf)
;   ( printout k "title: " ?empresa "-valor-activos" crlf)
;   ( printout k "permalink: /" ?empresa "valor-activos/ " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
)



(defrule fin-kindle-k-valores-activos
  ( declare (salience -10000))
 =>
  ( close k )
)



( defrule inicio-de-modulo-IVA
   (declare (salience 1000))
  =>
   ( printout t "--módulo----------------------- VALOR-ACTIVOS ---------------------" crlf)
   ( set-strategy lex )
;   ( watch rules )
)


(defrule fin-modulo-DEPRECIACION
  (declare (salience -10000))
 =>
  ( printout t "--módulo----fin ------------ VALOR-ACTIVOS ----------------------" crlf)
  ( unwatch rules)
;  ( halt )
)



(defrule revisar-depreciaciones
 ?d <- (depreciacion
       ( partida ?numero)
       ( herramienta ?herramienta)
       ( mes ?mes)
       ( ano ?ano)
       ( monto ?monto) )
  =>
  ( printout t "Hay una depreciacion por :" ?monto " en la partida: " ?numero crlf)
  ( printout t "Corresponde a " ?herramienta crlf)
  ( printout t "Este comando debe ser reemplazado por ajustes-mensuales" crlf)
  ( halt )
)



(defrule revisar-amortizaciones
 ?d <- ( amortizacion
       ( partida ?numero)
       ( intangible ?intangible)
       ( mes ?mes)
       ( ano ?ano)
       ( monto ?monto) )
  =>
  ( printout t "Hay una amortización por: " ?monto " en la partida: " ?numero crlf)
  ( printout t "Corresponde a " ?intangible crlf)
  ( printout t "Este comando debe ser reemplazado por ajustes-mensuales" crlf)
  ( halt )

)



(defrule warning-partida-repetida

 ( ajustes-mensuales ( partida ?numero1) (mes ?mes) (ano ?ano))
 ( ajustes-mensuales ( partida ?numero2) (mes ?mes) (ano ?ano))
 ( test (neq ?numero1 ?numero2 ))
=>
  (printout t crlf crlf "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  (printout t "Warning: Hay dos comandos de ajustes-mensuales para el mismo mes" crlf)
  (printout t "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  (printout t "--- PARTIDA 1 ------" crlf )
  (printout t ?numero1 tab  ?mes tab ?ano crlf )
  (printout t "--- PARTIDA 2 ------" crlf )
  (printout t ?numero2 tab  ?mes tab ?ano crlf )
  (printout t "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  (printout t "Vaya al archivo de facts y modifique una de las dos." crlf)
  ( halt )
)



(defrule generar-partida-de-depreciacion-ultima-cuota
  
  (empresa (nombre ?empresa ))
 
  (ajustes-mensuales
    (mes ?mes )
    (ano ?ano )
    (partida ?numero))

  (balance (mes ?mes_top) (ano ?ano_top))

  (test (>= (to_serial_date 31 ?mes_top ?ano_top) (to_serial_date 31 ?mes ?ano)))


  (registro-de-depreciacion
    (metodo-tributario ?tributario)
    (metodo ?metodo)
    (nombre-del-activo ?nombre)
    (cuenta-del-activo ?activo)
    (cuenta-del-pasivo ?pasivo)
    (cuenta-acumuladora ?acc)
    (mes-de-adquisicion ?mes-inicio)
    (ano-de-adquisicion ?ano-inicio)
    (valor-de-adquisicion ?valor-de-adquisicion)
    (meses-de-vida-util ?duracion)
    (mes-final ?mes-final)
    (ano-final ?ano-final)
    (ultima-cuota ?monto&:(> ?monto 0))
  )

  ( test (= (to_serial_date 31 ?mes-final ?ano-final) (to_serial_date 31 ?mes ?ano)))

 =>

   ( bind ?dia 31)
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por depreciacion en " ?mes " de " ?nombre)) (actividad depreciacion-herramienta)))
   ( assert (cargo (tipo-de-documento depreciacion) (cuenta ?pasivo) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto  ?monto) (glosa (str-cat por-depreciacion-de-herramienta- ?nombre))))
   ( assert (abono (tipo-de-documento depreciacion-de-herramienta) (cuenta ?acc) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto ) (glosa (str-cat por-reconocimiento-de-depreciacion-de- ?nombre))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento depreciacion-herramienta) (monto-total ?monto)))
   ( printout t "-->depreciacion-auto.-activo-fijo " tab ?monto tab ?mes crlf)

   ( printout k "<table><tbody>" crlf)
   ( printout k "<tr><td> " ?nombre "</td> <td>" ?mes "</td><td> Depreciando por: </td> <td>" ?monto "</td></tr>"crlf)
   ( printout k "</tbody></table>" crlf)
)



(defrule generar-partida-de-depreciacion

  (empresa (nombre ?empresa ))

  (ajustes-mensuales
    (mes ?mes )
    (ano ?ano )
    (partida ?numero))

  (balance (mes ?mes_top) (ano ?ano_top))

  (test (>= (to_serial_date 31 ?mes_top ?ano_top) (to_serial_date 31 ?mes ?ano)))

  (registro-de-depreciacion
    (metodo-tributario ?tributario)
    (metodo ?metodo)
    (nombre-del-activo ?nombre)
    (cuenta-del-activo ?activo)
    (cuenta-del-pasivo ?pasivo)
    (cuenta-acumuladora ?acc)
    (mes-de-adquisicion ?mes-inicio)
    (ano-de-adquisicion ?ano-inicio)
    (valor-de-adquisicion ?valor-de-adquisicion)
    (meses-de-vida-util ?duracion)
    (mes-final ?mes-final)
    (ano-final ?ano-final)
    (depreciacion-mensual ?monto)
    (ultima-cuota ?cuenta&:(> ?cuenta 0))
  )

  ( test (<= (to_serial_date 31 ?mes-inicio ?ano-inicio) (to_serial_date 31 ?mes ?ano)))

  ;no debe incluir el ultimo mes, eso se debe hace en otra relga, pues en el ultimo mes
  ;la minoración es por menor valor
  ( test (> (to_serial_date 31 ?mes-final ?ano-final) (to_serial_date 31 ?mes ?ano)))  

 =>

   ( bind ?dia 31)
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por depreciacion en " ?mes " de " ?nombre)) (actividad depreciacion-herramienta)))
   ( assert (cargo (tipo-de-documento depreciacion) (cuenta ?pasivo) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-depreciacion-de-herramienta- ?nombre))))
   ( assert (abono (tipo-de-documento depreciacion-de-herramienta) (cuenta ?acc) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-reconocimiento-de-depreciacion-de- ?nombre))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento depreciacion-herramienta) (monto-total ?monto)))
   ( printout t "-->depreciacion-auto.-activo-fijo " tab ?monto tab ?mes crlf)
   ( printout k "<table><tbody>" crlf)
   ( printout k "<tr><td> " ?nombre "</td> <td>" ?mes "</td><td> Depreciando por: </td> <td>" ?monto "</td></tr>"crlf)
   ( printout k "</tbody></table>" crlf)   
)



(defrule generar-partida-de-amortizacion-ultima-cuota
  
  ( empresa (nombre ?empresa))
  
  ( ajustes-mensuales
    ( mes ?mes )
    ( ano ?ano )
    (partida ?numero))
  
  (balance (mes ?mes_top) (ano ?ano_top))

  (test (>= (to_serial_date 31 ?mes_top ?ano_top) (to_serial_date 31 ?mes ?ano)))


  ( registro-de-amortizacion
    ( metodo-tributario ?tributario)
    ( metodo ?metodo)
    ( nombre-del-activo ?intangible)
    ( cuenta-del-activo ?activo)
    ( cuenta-del-pasivo ?pasivo)
    ( cuenta-acumuladora ?acc)
    ( mes-de-adquisicion ?mes-inicio)
    ( ano-de-adquisicion ?ano-inicio)
    ( mes-final ?mes-final)
    ( ano-final ?ano-final)
    ( valor-de-adquisicion ?valor-de-adquisicion)
    ( meses-de-vida-util ?duracion)
    ( amortizacion-mensual ?monto)
    ( ultima-cuota ?cuota&:(> ?cuota 0))
  )
   
  ( test (= (to_serial_date 31 ?mes-final ?ano-final) (to_serial_date 31 ?mes ?ano)))

 => 

  ( bind ?dia 31)
  ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por amortizacion en " ?mes " de " ?intangible)) (actividad amortizacion)))
  ( assert (cargo (tipo-de-documento amortizacion) (cuenta ?pasivo) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?cuota) (glosa (str-cat por-amortizacion-de-intangible- ?intangible))))
  ( assert (abono (tipo-de-documento amortizacion-de-intangible) (cuenta ?acc) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?cuota) (glosa (str-cat por-pago-de-amortizacion-de- ?intangible))))
  ( assert (ccm (folio na) (partida ?numero) (tipo-documento amortizacion-intangible) (monto-total ?monto)))
  ( printout t "-->am.auto-intangible " tab ?monto tab ?mes crlf)
  ( printout k "<table><tbody>" crlf)
  ( printout k "<tr><td> " ?intangible "</td> <td>" ?mes "</td><td> Amortizando por: </td> <td>" ?cuota "</td></tr>"crlf)
  ( printout k "</tbody></table>" crlf)
)




(defrule generar-partida-de-amortizacion

  ( empresa (nombre ?empresa))

  ( ajustes-mensuales
    ( mes ?mes )
    ( ano ?ano )
    (partida ?numero))

  (balance (mes ?mes_top) (ano ?ano_top))

  (test (>= (to_serial_date 31 ?mes_top ?ano_top) (to_serial_date 31 ?mes ?ano)))


  ( registro-de-amortizacion
    ( metodo-tributario ?tributario)
    ( metodo ?metodo)
    ( nombre-del-activo ?intangible)
    ( cuenta-del-activo ?activo)
    ( cuenta-del-pasivo ?pasivo)
    ( cuenta-acumuladora ?acc)
    ( mes-de-adquisicion ?mes-inicio)
    ( ano-de-adquisicion ?ano-inicio)
    ( mes-final ?mes-final)
    ( ano-final ?ano-final)
    ( valor-de-adquisicion ?valor-de-adquisicion)
    ( meses-de-vida-util ?duracion)
    ( amortizacion-mensual ?monto)
    ( ultima-cuota ?cuota&:(> ?cuota 0))
  )

  ( test (<= (to_serial_date 31 ?mes-inicio ?ano-inicio) (to_serial_date 31 ?mes ?ano)))

  ;no debe incluir el ultimo mes,pues el pago es difirente. usar la regla de
  ;generar-partida-de-amortizacion-ultima-cuota
  ( test (> (to_serial_date 31 ?mes-final ?ano-final) (to_serial_date 31 ?mes ?ano)))

 =>

  ( bind ?dia 31)
  ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por amortizacion en " ?mes " de " ?intangible)) (actividad amortizacion)))
  ( assert (cargo (tipo-de-documento amortizacion) (cuenta ?pasivo) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-amortizacion-de-intangible- ?intangible))))
  ( assert (abono (tipo-de-documento amortizacion-de-intangible) (cuenta ?acc) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-amortizacion-de- ?intangible))))
  ( assert (ccm (folio na) (partida ?numero) (tipo-documento amortizacion-intangible) (monto-total ?monto)))
  ( printout t "-->am.auto-intangible " tab ?monto tab ?mes crlf)
  ( printout k "<table><tbody>" crlf)
  ( printout k "<tr><td> " ?intangible "</td> <td>" ?mes "</td><td> Amortizando por: </td> <td>" ?monto "</td></tr>"crlf)
  ( printout k "</tbody></table>" crlf)
)



(defrule ajustar-ultima-cuota
  ( or
   ?r <- ( registro-de-depreciacion  (valor-de-adquisicion ?total)
                                 (nombre-del-activo ?nombre)
                                 (meses-de-vida-util ?duracion)
                                 (depreciacion-mensual ?devaluacion-mensual)
                                 (ultima-cuota 0))
                   
    ?r <-  ( registro-de-amortizacion  (valor-de-adquisicion ?total)
                                  (nombre-del-activo ?nombre)
                                  (meses-de-vida-util ?duracion)
                                  (amortizacion-mensual ?devaluacion-mensual)
                                  (ultima-cuota 0))                                   
  )  
 =>
  ( bind ?devaluacion-mensual-calculada (/ ?total ?duracion)) 
  ( bind ?total-nuevo (* ?devaluacion-mensual ?duracion))
  ( printout t crlf)
  ( printout t "Ajuste de la última cuota" crlf)
  ( printout t "--------------------------------------------------------" crlf)
  ( printout t ?nombre crlf)
  ( printout t "Valor de compra: $" ?total crlf)
  ( printout t "Tiempo de Vida Util: " ?duracion " meses " crlf)
  ( printout t "Devaluación Mensual que se usa: $" ?devaluacion-mensual crlf)
  ( printout t "cálculo de devaluacion mensual: $" ?devaluacion-mensual-calculada crlf)
  ( printout t "Se debe restar: " (- ?total ?total-nuevo) " de la última devaluación."  crlf)
  ( printout t "La última devaluacion mensual debe ser por $" (- ?devaluacion-mensual (- ?total-nuevo ?total)) crlf)
  ( modify ?r ( ultima-cuota  (- ?devaluacion-mensual (- ?total-nuevo ?total))))
  ( printout t "--------------------------------------------------------" crlf)
)


(defrule warning-parametros-incorrectos
  ( or
    ?r <- ( registro-de-depreciacion
                                 (valor-de-adquisicion ?total)
                                 (nombre-del-activo ?nombre)
                                 (ano-de-adquisicion ?ano-inicial)
                                 (mes-de-adquisicion ?mes-inicial)
                                 (ano-final ?ano-final)
                                 (mes-final ?mes-final)
                                 (meses-de-vida-util ?duracion)
                                 (depreciacion-mensual ?devaluacion-mensual)
                                 (ultima-cuota ?ultima-cuota))
  
    ?r <-  ( registro-de-amortizacion
                                  (valor-de-adquisicion ?total)
                                  (nombre-del-activo ?nombre)
                                  (ano-de-adquisicion ?ano-inicial)
                                  (mes-de-adquisicion ?mes-inicial)
                                  (ano-final ?ano-final)
                                  (mes-final ?mes-final)
                                  (meses-de-vida-util ?duracion)
                                  (amortizacion-mensual ?devaluacion-mensual)
                                  (ultima-cuota ?ultima-cuota))  
  )

  ( test (< ?ano-final ?ano-inicial))
  ( test (= ?mes-final ?mes-inicial))
  ( test (neq (* (- ?ano-final ?ano-inicial) 12) ?duracion) )

 =>
  ( printout t "==================================================================" crlf)
  ( printout t "WARNING: Hay parámetros incorrectos." crlf)
  ( printout t "El activo con problemas es: " ?nombre crlf)
  ( printout t "Revise el archivo de valores-de-activo y modifique lo que sea necesario." crlf)
  ( printout t "==================================================================" crlf)
  ( halt )
)



(defrule warning-ultima-cuota-debe-ser-menor
  ( or
    ?r <- ( registro-de-depreciacion
                                 (valor-de-adquisicion ?total)
                                 (nombre-del-activo ?nombre)
                                 (meses-de-vida-util ?duracion)
                                 (depreciacion-mensual ?devaluacion-mensual)
                                 (ultima-cuota ?ultima-cuota))

    ?r <-  ( registro-de-amortizacion
                                  (valor-de-adquisicion ?total)
                                  (nombre-del-activo ?nombre)
                                  (meses-de-vida-util ?duracion)
                                  (amortizacion-mensual ?devaluacion-mensual)
                                  (ultima-cuota ?ultima-cuota))
  )
  ( test (< ?devaluacion-mensual ?ultima-cuota))

 =>
  ( printout t "==================================================================" crlf)
  ( printout t "WARNING La última cuota no está correcta, pero el error está en otro lado." crlf)
  ( printout t "El activo con problemas es: " ?nombre crlf)
  ( printout t "La ultima cuota que se calcula por el sistema es: " ?ultima-cuota crlf)
; ( printout t "Para que la contabilidad esté bien, ese valor debe ser menor que: " ?devaluacion-mensual crlf )   
  ( printout t "Revise el archivo de valores-de-activo y modifique" crlf)
  ( printout t "la devaluacion-mensual para que sea mayor que: " (/ ?total ?duracion) crlf)
  ( printout t "==================================================================" crlf)
  ( halt )
)



(defrule revisar-registros-de-depreciacion

  (registro-de-depreciacion
    (metodo-tributario ?tributario)
    (metodo ?metodo)
    (nombre-del-activo ?nombre)
    (cuenta-del-activo ?activo)
    (cuenta-del-pasivo ?pasivo)
    (cuenta-acumuladora ?acc)
    (mes-de-adquisicion ?mes-inicio)
    (ano-de-adquisicion ?ano-inicio)
    (valor-de-adquisicion ?valor-de-adquisicion)
    (meses-de-vida-util ?duracion)
    (depreciacion-mensual ?monto))

 =>
  ( printout t crlf )
  ( printout t "=========================================" crlf)
  ( printout t ?nombre crlf)
  ( printout t "=========================================" crlf)
  ( printout t ?metodo " de: " ?nombre crlf)
  ( printout t "Metodo tributario es: " ?tributario crlf)
  ( printout t "Cuentas son: " crlf )
  ( printout t "Activo: "  ?activo crlf)
  ( printout t "Pasivo: "  ?pasivo crlf)
  ( printout t "Acumuladora: " ?acc crlf)
  ( printout t "Fue adquirido en: " ?mes-inicio " de " ?ano-inicio " por $" ?valor-de-adquisicion crlf)
  ( printout t "Perderá todo su valor en: " ?duracion " meses " crlf)
  ( printout t "Mensualmente hay que depreciarlo en: $" ?monto crlf)
  ( printout t "=========================================" crlf)

  ( printout k "<table> <tbody>" crlf)
  ( printout k "<tr><th>" ?nombre "</th></tr>" crlf)
  ( printout k "<tr><td>" ?metodo " de: </td><td> " ?nombre " </td> </tr> " crlf)
  ( printout k "<tr><td> Metodo tributario es: </td><td> " ?tributario "</td></tr>" crlf)
  ( printout k "<tr><td> Cuentas son:  </td></tr>" crlf )
  ( printout k "<tr><td>  Activo: </td><td> "  ?activo "</td></tr>" crlf)
  ( printout k "<tr><td>  Pasivo: </td><td>  "  ?pasivo "</td></tr>" crlf)
  ( printout k "<tr><td> Acumuladora:</td><td>  " ?acc "</td></tr>" crlf)
  ( printout k "<tr><td> Fue adquirido en: </td> <td> " ?mes-inicio " de " ?ano-inicio " por $" ?valor-de-adquisicion "</td></tr>" crlf)
  ( printout k "<tr><td> Perderá todo su valor en: </td><td> " ?duracion " meses </td></tr> "  crlf)
  ( printout k "<tr><td> Mensualmente hay que depreciarlo en: </td><td> $" ?monto "</td></tr>" crlf)
  ( printout k "</tbody></table> " crlf)

)



(defrule revisar-registros-de-amortizacion

  (registro-de-amortizacion
    (metodo-tributario ?tributario)
    (metodo ?metodo)
    (nombre-del-activo ?nombre)
    (cuenta-del-activo ?activo)
    (cuenta-del-pasivo ?pasivo)
    (cuenta-acumuladora ?acc)
    (mes-de-adquisicion ?mes-inicio)
    (ano-de-adquisicion ?ano-inicio)
    (valor-de-adquisicion ?valor-de-adquisicion)
    (meses-de-vida-util ?duracion)
    (amortizacion-mensual ?monto)
  )
 =>
  ( printout t crlf )
  ( printout t "=========================================" crlf)
  ( printout t ?nombre crlf)
  ( printout t "=========================================" crlf)
  ( printout t  ?metodo " de: " ?nombre crlf)
  ( printout t "Metodo tributario es: " ?tributario crlf)
  ( printout t "Cuentas son: " crlf )
  ( printout t "Activo: "  ?activo crlf)
  ( printout t "Pasivo: "  ?pasivo crlf)
  ( printout t "Acumuladora: " ?acc crlf)
  ( printout t "Fue adquirido en: " ?mes-inicio " de " ?ano-inicio " por $ " ?valor-de-adquisicion crlf)
  ( printout t "Perderá todo su valor en: " ?duracion " meses " crlf)
  ( printout t "Mensualmente hay que amortizarlo en: $ " ?monto crlf)
  ( printout t "=========================================" crlf)

  ( printout k "<table> <tbody>" crlf)
  ( printout k "<tr><th>" ?nombre "</th></tr>" crlf)
  ( printout k "<tr><td>" ?metodo " de: </td><td> " ?nombre " </td> </tr> " crlf)
  ( printout k "<tr><td> Metodo tributario es: </td><td> " ?tributario "</td></tr>" crlf)
  ( printout k "<tr><td> Cuentas son:  </td></tr>" crlf )
  ( printout k "<tr><td>  Activo: </td><td> "  ?activo "</td></tr>" crlf)
  ( printout k "<tr><td>  Pasivo: </td><td>  "  ?pasivo "</td></tr>" crlf)
  ( printout k "<tr><td> Acumuladora:</td><td>  " ?acc "</td></tr>" crlf)
  ( printout k "<tr><td> Fue adquirido en: </td> <td> " ?mes-inicio " de " ?ano-inicio " por $" ?valor-de-adquisicion "</td></tr>" crlf)
  ( printout k "<tr><td> Perderá todo su valor en: </td><td> " ?duracion " meses </td></tr> "  crlf)
  ( printout k "<tr><td> Mensualmente hay que depreciarlo en: </td><td> $" ?monto "</td></tr>" crlf)
  ( printout k "</tbody></table> " crlf)

)


