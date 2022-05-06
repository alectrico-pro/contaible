( defmodule IVA ( import MAIN deftemplate ?ALL))
;Este modulo es bien complejo
;Tiene tres o cuatro etapas
;Determinar que tipo de traspaso de iva se debe hacer en cada mes
;Rejustar el remanente de iva de acuerdo a parametros de utm
;Para prepara todo esto primero deben obtenerse totales de iva-creido 
;e iva-debito pero sin modificar esas cuentas, pues las partidas no 
;serán procesadas hasta más adelante, en otros módulos
;Entonces se usa encabeza e IVA-filas para sumar todo esto en el fact mensuales
;Mensuales solo tienen totales mensuales y eso no es suficiente.
;Al terminar se dispara resumen-mensual
;Resumen mensual suma con ayuda de un acarreo los totales mensuales
;El acarreo se modifica en efectuar-reajuste-de-remanente-de-iva
;Pero antes de llegar allá, en resumen-mensual se determina
;Si el traspaso de iva será desde crédito hacia débito o viceversa
;Tambíen se trata de explicar el proceso, incluso generando un html iva
;Desde resumen se disparan las reglas de traspaso
;ajustar-iva-contra-debito o 
;ajustar-iva-contra-credito
;Estas reglas generan las ordenes de abono y cargo que seŕan
;usadas en el flujo de contabilidad cuando sea llegado el mes
;la regla determinar-mes-de-ajuste-de-remanente-de-iva
;determina cuál es mes de donde se obtendrá la utm para el ajuste
;la regla efectuar-reajuste-de-remanente-de-iva hace el ajueste
;y lo deja en el fact remanente-de-iva
;la regla emitir-partida-de-ajuste-de-remanente
;genera los abonos y cargos necesarios para que se haga el
;ajuste del remanente en el flujo contable cuando sea llegado el mes
;También genera las partidas f29 para que se pueda reconocer
;el remanente recibido del mes anterior código 504
;y el remanente que se deja para el mes siguiente 077

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
(defrule inicio-kindle-k-iva-rules

   ( declare (salience 10000))
   ( empresa (nombre ?empresa))

  =>

   ( bind ?archivo (str-cat "./doc/" ?empresa "/iva.markdown"))
   ( open ?archivo k "w")
   ( printout k "--- " crlf)
;   ( printout k "title: IVA" crlf)
;   ( printout k "permalink: /" ?empresa "/iva " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
   ( printout k "" crlf)
   ( printout k "<h1> IVA </h1> " crlf)
)


(defrule fin-kindle-k
  ( declare (salience -10000))
 =>
  ( close k )
)

( defrule inicio-de-modulo-IVA
   (declare (salience 10000))
  =>
   ( printout t "--módulo----------------------- IVA ----------------------" crlf)
   ( set-strategy lex )
)


(defrule genera-resumenes
  (declare (salience -1000))
 =>
  ( printout t "--módulo----resumen------------ IVA ----------------------" crlf)
  ( printout t "NOTA: El IVA-DEBITO no se acumula de un mes al siguiente." crlf)
  ( printout t "El haber del iva-debito se compensa con el saldo del iva-credito" crlf)
  ( printout t "y si sobra algo, se paga por medio del f29." crlf)
  ( printout t "El IVA-CREDITO se acumula de un mes al siguiente" crlf)
  ( printout t "y al compensarse con el haber del IVA-DEBITO, disminiurá." crlf)
  ( printout t "Cada mes puede aumentar si hubo compras." crlf)
  ( printout t crlf)
  ( assert (acarreo-de-iva (valor 0) ))
  ( assert (resumen) )
)


(defrule fin-modulo-IVA
  (declare (salience -10000))
 =>
  ( printout t "--módulo----fin ------------ IVA ----------------------" crlf)
  ( unwatch rules)
  ;( halt )
)

(defrule partida-sin-revisar

 ?iva <-( ajuste-de-iva
  ( partida ?partida)
  ( mes ?mes)
  ( ano ?ano)
  ( hecho true))

  ( not (exists  ( revision (partida ?partida) (revisado true) )))

  =>
  ( printout t "============== W A R N I N G =========================" crlf)
  ( printout t "Partida sin Revisar: " ?partida crlf)
  ( printout t "Edite el archivo de revisiones y agregue una revisión para la partida " ?partida crlf)
  ( printout t crlf)
  ( printout t "======================================================" crlf)
  ( halt )
)


(defrule agregar-partida-de-ppm

 ?iva <-( ajuste-de-iva
  ( partida ?partida)
  ( mes ?mes)
  ( ano ?ano)
  ( hecho true))
  
  =>
  ( assert (pago-de-ppm (partida ?partida) ( mes ?mes ) (ano ?ano)))
)


(defrule solo-debito
  (resumen )
 ?iva <-( ajuste-de-iva
  ( partida ?partida)
  ( mes ?mes)
  ( ano ?ano)
  ( hecho false))

  ( mensuales (mes ?mes) (cuenta iva-credito) (haber ?haber-c) (debe ?debe-c) )
  (not ( exists ( mensuales (mes ?mes) (cuenta iva-debito)  (haber ?haber-d) (debe ?debe-d) )))


  =>
  ( modify ?iva (hecho true))
  ( printout t "Resumen: "  ?mes crlf)
  ( printout t "Solo hay debito" crlf)
)

(defrule solo-credito
  ( resumen )

  ?iva <-( ajuste-de-iva
  ( partida ?partida)
  ( mes ?mes)
  ( ano ?ano)
  ( hecho false))

  ( not (exists ( mensuales (mes ?mes) (cuenta iva-credito) (haber ?haber-c) (debe ?debe-c) )))
  ( mensuales (mes ?mes) (cuenta iva-debito)  (haber ?haber-d) (debe ?debe-d) )

  =>
  ( modify ?iva (hecho true))
  ( printout t "Resumen: "  ?mes crlf)
  ( printout t "Solo hay credito" crlf)
  ( halt )
)



(defrule resumen-mensual

  ( actual (mes ?mes))
  ( ticket (numero ?partida))
  ( resumen )

  ?iva <-( ajuste-de-iva
  ( partida ?partida)
  ( mes ?mes)
  ( ano ?ano)
  ( hecho false))


  ?iva-credito <- ( mensuales (mes ?mes) (cuenta iva-credito) (haber ?haber-c) (debe ?debe-c) )
  ?iva-debito  <- ( mensuales (mes ?mes) (cuenta iva-debito)  (haber ?haber-d) (debe ?debe-d) )

  ?acarreo <-  ( acarreo-de-iva (valor ?remanente) )

  ( balance  (mes ?mes_top) (ano ?ano_top))

  ( tasas (utm ?utm)
          (mes ?mes)
          (ano ?ano))

  ( test ( >= ( to_serial_date 31 ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)) )

  =>

  ( printout t crlf crlf)
  ( printout t "====================================================" crlf)
  ( printout t "Resumen: "  ?mes tab "Partida " ?partida crlf)
  ( printout t "====================================================" crlf)
  ( printout t "cuenta IVA-DEBITO"  tab "DEBE" tab "HABER"  crlf)
  ( printout t tab tab tab ?debe-d tab ?haber-d crlf)
  ( bind ?saldo-iva-debito ( - ?haber-d ?debe-d) )
  ( printout t "---------------------------------------" crlf)
  ( printout t tab tab tab tab ?saldo-iva-debito crlf)
  ( printout t  crlf)
  

  ( printout t crlf )
  ( printout t "Ajustando el crédito de iva para " tab ?mes crlf)
  ( printout t "Debe Anterior--- + " ?debe-c crlf)
  ( printout t "Remanente    --- + " ?remanente crlf)

  ( bind ?debe-actual-c (+ ?debe-c ?remanente) )

  ( printout t "          ----------------" crlf)
  ( printout t "Debe Actual--- - = " ?debe-actual-c crlf)
  ( printout t crlf )

  ( printout t "cuenta IVA-CREDITO" tab "DEBE" tab "HABER"  crlf)

  ( printout t tab tab tab ?debe-actual-c tab ?haber-c crlf)
  ( bind ?saldo-iva-credito (- ( + ?debe-c ?remanente ) ?haber-c) )
  ( printout t "---------------------------------------" crlf)
  ( printout t tab tab tab ?saldo-iva-credito crlf) 
  ( printout t  crlf)
 

  ( printout k "<table> <tbody>" crlf)
  ( printout k "<tr> <td colspan='6' style = 'font-style: small; background-color: azure'>" ?mes "</td></tr>" crlf) 
  ( printout k "<tr> <td colspan='2' style='background-color: lightyellow'> IVA CREDITO </td> <td colspan='2' style='background-color: beige'> IVA DEBITO </td> </tr> " crlf)
  ( printout k "<tr> <td> DEBE </td> <td> HABER </td> <td> DEBE </td><td> HABER </td> </tr> " crlf)
  ( printout k "<tr> <td>" ?debe-actual-c "</td> <td> " ?haber-c "</td> <td> " ?debe-d "</td><td> " ?haber-d "</td> </tr>" crlf)
  ( printout k "<tr> <td>" ?saldo-iva-credito "</td> <td></td><td></td><td>" ?saldo-iva-debito "</td> </tr>"  crlf)


 
;  ( printout t "Debito: " tab ?debe-d tab ?haber-d crlf)
;  ( printout t "Crédito: " tab ?debe-c tab ?haber-c crlf)
  ( bind ?credito (+ (- ?debe-c ?haber-c) ?remanente ))
  ( bind ?debito  (- ?haber-d ?debe-d) )
   
 
  ( if (> ?credito ?debito) then
    ( printout t "Como el saldo acreedor IVA-DEBITO es MENOR que el saldo deudor IVA-CREDITO " crlf)
    ( printout t "Se restará del saldo IVA-CREDITO el haber IVA-DEBITO " crlf)
    ( printout t "Ello es: -------" tab ?saldo-iva-credito tab "-" tab ?debito crlf)
    ( bind ?remanente (- ?saldo-iva-credito ?debito ) )
    ( printout t "De ello resulta un remanente de: " tab ?remanente crlf)
    ( printout t "Este remanente se usará el mes siguiente: y se debe reajustar con la" crlf)
    ( printout t "inflación" crlf)
    ( printout t crlf)
    ( printout t "Ajustando todo el haber del IVA-DEBITO contra el saldo del IVA-CREDITO por: " ?debito crlf)
    ( modify ?iva (hecho true) (haber ?debito  ))
    ( modify ?acarreo (valor ?remanente) (ajustado false))
    ( assert ( remanente-de-iva (partida ?partida) (valor ?remanente) (mes ?mes) (ano ?ano) (utm ?utm) ))
    ( assert ( ajuste-de-iva-contra-credito (partida ?partida) (monto ?debito) (mes ?mes) (ano ?ano)) ) 
 
    ( printout k "<tr> <td style='font-weight: bold; font-size: large; background-color: azure'>" ?remanente "</td> <td></td> <td> </td><td> </td> </tr>" crlf)

    ( printout k "</tbody> </table>" crlf)

  ) 
  
 ( if (> ?debito ?credito) then
    ( printout t "Como el saldo acreedor IVA-DEBITO es MAYOR que el saldo deudor IVA-CREDITO " crlf)
    ( printout t "Se usará todo el saldo IVA-CREDITO para hacer disminuir el saldo acreedor IVA-DEBITO " crlf)
    ( bind ?compensacion (- ?saldo-iva-debito ?saldo-iva-credito ) )
    ( printout t "Ello es: " tab ?saldo-iva-debito tab "-" tab ?saldo-iva-credito " = " ?compensacion crlf)
    ( printout t "De ello resulta que el remanente de crédito IVA habrá sido eliminado." crlf)
    ( printout t "pero, en cambio,  habrá que pagar el iva-debito en exceso de:" crlf)
    ( printout t ?compensacion crlf)
    ( printout t "Ajustando iva contra debito por: " tab ?compensacion crlf)
    ( modify ?iva (hecho true) (debe ?credito ))
    ( modify ?acarreo (valor 0) (ajustado false))
    ( assert ( remanente-de-iva (partida ?partida) (valor 0) (mes ?mes) (ano ?ano) (utm ?utm)  ))
    ( assert ( ajuste-de-iva-contra-debito (partida ?partida) (monto ?compensacion) (mes ?mes) (ano ?ano)) )
    ( printout k "<tr> <td></td> <td></td> <td> </td><td style='font-size: large; font-weight: bold; color: white; background-color: crimson'>" ?compensacion "</td> </tr>" crlf)

    ( printout k "</tbody> </table>" crlf)
   
 ))

(defrule emitir-partida-de-ajuste-de-remanente

  ( empresa (nombre ?empresa))

  (or
    ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (actividad ajustar-iva-contra-credito))
    ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (actividad ajustar-iva-contra-debito))
  )

  ?remanente <-  ( remanente-de-iva

    ( emitido false )
    ( determinado true)
    ( ajustado true)
    ( valor ?antes)
    ( valor-ajustado ?calculado)
    ( mes ?mes-que-declara)
    ( mes-de-ajuste ?mes-de-pago)
    ( ano ?ano-que-declara)
    ( ano-de-ajuste ?ano-de-pago)
    ( utm ?utm))

   ( acarreo-de-iva (valor ?acarreo))

   ;este es el truco para moverlo hacia el mes del f29
   ( test (eq ?mes (numero_to_mes (- (mes_to_numero ?mes-de-pago) 1))))

   ( f29
     (partida ?partida-f29)
     (mes ?mes)
     (ano ?ano))

  =>
   
   ( bind ?zero77 0)
   ( modify ?remanente (emitido true))
   ( if (> ?calculado ?antes) then
      ( bind ?ajuste (round (- ?calculado ?antes)))
      ( assert (cargo (tipo-de-documento remanente-iva) (cuenta iva-credito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano-de-pago) (empresa ?empresa) (monto ?ajuste) (glosa (str-cat por-remanente-de-iva- ?mes-de-pago ?ajuste))))
      ( assert (abono (tipo-de-documento remanente-iva) (cuenta ganancia-por-correccion-monetaria) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano-de-pago) (empresa ?empresa) (monto ?ajuste) (glosa (str-cat por-remanente-de-iva- ?mes-de-pago ?ajuste))))
     ( printout t "-->ari Ajustar a Ingresos Remanente de IVA " ?mes tab ?ajuste crlf)

     ( printout k "<table> <tbody> " crlf)
     ( printout k "<tr> <td >-->ari Ajustar a Ingresos Remanente de IVA </td><td> " ?mes "-" ?ano-de-pago "</td> <td style='font-weight: bold; font-size: large; background-color: azure'> (+) " ?ajuste "</td> </tr>"crlf)
     ( printout k "<tr> <td style='font-weight: bold; font-size: large; background-color: ivory'>" ?antes "</td> <td> (+) " ?ajuste" </td><td style='font-weight: bold; font-size: large; background-color: gold'  > (=) " ?calculado "</td> <td> f29 504 </td><td> Remanente de crédito fiscal del mes anterior</td> </tr>" crlf)
     ( bind ?zero77 (+ ?acarreo ?ajuste))
     ( printout k "<tr> <td style='font-weight: bold; font-size: large; background-color: ivory'>" ?acarreo "</td> <td> (+) " ?ajuste" </td><td style='font-weight: bold; font-size: large; background-color: greenyellow' > (=) " ?zero77 "</td> <td> f29 077 </td><td>Remanente del crédito fiscal para el mes siguiente</td></tr>" crlf)
   )

   ( if (< ?calculado ?antes) then
      ( bind ?ajuste (round (- ?antes ?calculado)))
     ;( bind ?dia 31)
      ( assert (abono (tipo-de-documento remanente-iva) (cuenta iva-credito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ajuste) (glosa (str-cat por-remanente-de-iva- ?mes-de-pago ?ajuste))))
      ( assert (cargo (tipo-de-documento remanente-iva) (cuenta perdida-por-correccion-monetaria) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ajuste) (glosa (str-cat por-remanente-de-iva- ?mes-de-pago ?ajuste))))
     ( printout t "-->ari Ajustar a Gastos Remanente de IVA " ?mes tab ?ajuste crlf)

     ( printout k "<table> <tbody> " crlf)
     ( printout k "<tr> <td>-->ari Ajustar a Gastos Remanente de IVA </td><td> " ?mes "</td> <td style='font-weight: bold; font-size: large; background-color: lightpink' > (-)" ?ajuste "</td> </tr>"crlf)
     ( printout k "<tr> <td style='font-weight: bold; font-size: large; background-color: azure'>" ?antes "</td> <td> (-) " ?ajuste" </td><td style='font-weight: bold; font-size: large; background-color: gold'  > (=) " ?calculado "</td> <td> f29 504 </td><td> Remanente de crédito fiscal del mes anterior</td> </tr>" crlf)
     ( bind ?zero77 (- ?acarreo ?ajuste))
     ( printout k "<tr> <td style='font-weight: bold; font-size: large; background-color: azure'>" ?acarreo "</td> <td> (-) " ?ajuste" </td><td style='font-weight: bold; font-size: large; background-color: greenyellow' > (=) " ?zero77 "</td> <td> f29 077 </td><td>Remanente del crédito fiscal para el mes siguiente</td></tr>" crlf)
   )

   ( if (= ?calculado ?antes) then
      ( bind ?ajuste 0)
      ( bind ?dia 31)
      ( bind ?zero77 (+ ?acarreo ?ajuste))

      ( printout t "-->ari No es necesario Ajustar Remanente de IVA " ?mes tab ?ajuste crlf)

      ( printout k "<table> <tbody> " crlf)
      ( printout k "<tr> <td>-->ari No es necesario Ajustar Remanente de IVA </td><td> " ?mes "</td> <td>" ?ajuste "</td> </tr>"crlf)
      ( printout k "<tr> <td style='font-weight: bold; font-size: large; background-color: azure'>" ?antes "</td> <td> (+) " ?ajuste" </td><td style='font-weight: bold; font-size: large; background-color: lightyellow'  > (=) " ?calculado "</td> <td> f29 504 </td><td> Remanente de crédito fiscal del mes anterior</td> </tr>" crlf)
      ( printout k "<tr> <td style='font-weight: bold; font-size: large; background-color: azure'>" ?acarreo "</td> <td> (+) " ?ajuste" </td><td style='font-weight: bold; font-size: large; background-color: lightyellow' > (=) " ?zero77 "</td> <td> f29 077 </td><td>Remanente del crédito fiscal para el mes siguiente</td></tr>" crlf)
   )

   ( assert ( formulario-f29
          ( partida ?partida-f29)
          ( codigo "077")
          ( descripcion "REMANENTE DE CREDITO FISC. ")
          ( valor ?zero77)
          ( mes ?mes)
          ( ano ?ano)))


   ( assert ( formulario-f29
          ( partida ?partida-f29)
          ( codigo "504")
          ( descripcion "REMANENTE CREDITO FISCAL MES ANTERIOR. ")
          ( valor ?calculado)
          ( mes ?mes)
          ( ano ?ano)))



   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ajuste-remanente-iva) (monto-total ?ajuste)))

   ( printout t "-------------------------------------------------------" crlf)

)


;detectar si falta alguna tasa
(defrule warning-falta-dato-de-tasa

  ?remanente <-  ( remanente-de-iva
    ( determinado true)
    ( ajustado false)
    ( emitido false)
    ( mes-de-ajuste ?mes-de-ajuste)
    ( ano-de-ajuste ?ano-de-ajuste))
 (not  ( tasas (utm ?utm-de-ajuste) (ano ?ano-de-ajuste) (mes ?mes-de-ajuste) ))


=>
 ( printout t "Falta la tasa utm del mes: " tab ?mes-de-ajuste crlf)
 ( printout t "Busque el dato en sii y luego agréguelo al archivo de tasas." crlf)
 ( halt )
)

;efectar el reajuste del remanente 
(defrule efectuar-reajuste-de-remanente-de-iva

  ;El remanente queda como un registro para todo el ejercicio
  ;Pero igual hay que actualizar el acarreo para que se pueda
  ;Generar los traspasos de iva de forma adecuada a la inflación
  ?remanente <-  ( remanente-de-iva
    ( determinado true)
    ( ajustado false)
    ( emitido false)
    ( valor ?antes)
    ( mes ?mes)
    ( mes-de-ajuste ?mes-de-ajuste)
    ( ano ?ano)
    ( ano-de-ajuste ?ano-de-ajuste)
    ( utm ?utm))

  ( tasas (utm ?utm-de-ajuste) (ano ?ano-de-ajuste) (mes ?mes-de-ajuste) )

  ?acarreo <- ( acarreo-de-iva ( valor ?valor-acarreo) (ajustado false))

  ( test (neq nil ?mes-de-ajuste) )
  ( test (neq nil ?ano-de-ajuste) )

 =>
  ( bind ?antes-en-utm (round (/ (round (/ (* ?antes 100) ?utm)) 100)))
  ( printout t antes-en-utm ?antes-en-utm 100 crlf)
  ( bind ?calculado (round (* ?antes-en-utm ?utm-de-ajuste) ))
  ( printout t "El valor ajustado del remanente de iva  es: " ?calculado crlf)
  ( printout t "El acarreo es de: " tab ?valor-acarreo crlf)
  ( modify ?remanente (ajustado true) (valor-ajustado ?calculado))
  ( modify ?acarreo (valor ?calculado) (ajustado true))
  ( printout t "El acarreo fue actualizado a: " tab ?calculado crlf)
)



;debe reajustar el remanente para el mes siguiente
(defrule determinar-mes-de-ajuste-de-remanente-de-iva

  ?remanente <-  ( remanente-de-iva
    ( emitido false )
    ( determinado false)
    ( ajustado false)
    ( valor ?iva)
    ( mes ?mes)
    ( ano ?ano)
    ( utm ?utm))

 =>
  ( bind ?proximo-mes (numero_to_mes (+ 2 ( mes_to_numero ?mes) ) ))
  ( printout t ?proximo-mes crlf )
  ( if (or (eq ?proximo-mes enero) (eq ?proximo-mes febrero) ) then
       ( bind ?ano (+ ?ano 1))
  )

  ( printout t "En determinar mes de ajuste de remanente de iva " ?proximo-mes tab ?ano crlf)

  ( printout k "<tr> <td> Determinando mes de ajuste de remanente de IVA </td><td> " ?proximo-mes "</td> <td>" ?ano "</td> </tr>"crlf)

  ( modify ?remanente (determinado true) (mes-de-ajuste ?proximo-mes ) (ano-de-ajuste ?ano))
)



( defrule encabezado

   ( actual (mes ?mes) )

   ?cuenta <- ( cuenta
    ( partida ?Numero & nil )
    ( nombre ?nombre )
    ( nombre-sii ?nombre-sii )
    ( descripcion ?descripcion )
    ( origen real   ) )

  ( exists
    ( cuenta
      ( nombre  ?nombre )
      ( partida ?Numero2 & ~?Numero )
      ( saldo ?saldo )
    )
  ) 
  ( balance  (mes ?mes_top) (ano ?ano_top))
  ( test ( >= ( to_serial_date 31 ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano_top)))

 =>

  ( assert ( hacer (cuenta ?nombre) (mes ?mes)))
  ( assert ( mensuales (mes ?mes) ( cuenta ?nombre)) )
 ;( printout t "Encabezado: " tab ?mes crlf)
)


( defrule IVA-filas

  ( empresa (nombre ?empresa))
  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))

  ( actual (mes ?mes))

  ?hacer  <- ( hacer (cuenta ?nombre ) (mes ?mes))

  ?cuenta <- ( cuenta 
     ( recibida ?recibida )
     ( tipo-de-documento ?tipo-de-documento)
     ( activo-fijo ?activo-fijo)
     ( nombre ?nombre)
     ( partida ?partida) 
     ( debe    ?debe)
     ( haber   ?haber)
     ( mes     ?mes)
     ( mostrado-en-t false)
     ( ajustado-iva false)
     ( origen  real ) )


  ?mensuales <- ( mensuales
    ( mes ?mes)
    ( mostrado   false)
    ( totalizado false)
    ( cuenta ?nombre )
    ( debe ?total_debe)
    ( haber ?total_haber) )

  ( test (and (neq nil ?partida) (> ?partida 0)))

  ( balance  (mes ?mes_top) (ano ?ano_top))
  ( test ( >= ( to_serial_date 31 ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano_top)))

 =>
  ( modify ?cuenta
       ( ajustado-iva true))

  ( modify ?mensuales
       ( debe  (+ ?total_debe  ?debe))
       ( haber (+ ?total_haber ?haber)))

  ( printout t "IVA-filas: " ?mes tab ?debe tab ?haber tab ?nombre crlf)
)



(defrule ajustar-iva-contra-debito
   ( declare (salience 10000))
  
   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?imposiciones <- ( ajuste-de-iva-contra-debito ( mes ?mes) (ano ?ano) (partida ?numero) (pagado false) (monto ?monto))
  =>

   ( bind ?dia 31)
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por ajuste del Credito Fiscal Contra el Debito Fiscal, mes de " ?mes)) (actividad ajustar-iva-contra-debito)))
   ( assert (cargo (tipo-de-documento ajuste-iva-debito) (cuenta iva-credito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-iva ?monto))))
   ( assert (abono (tipo-de-documento ajuste-iva-debito) (cuenta iva-debito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-iva ?monto))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ajustar-iva-contra-debito) (monto-total ?monto)))

   ( printout t "-->ami Ajuste Mensual de IVA " ?mes tab ?monto crlf)
)



(defrule ajustar-iva-contra-credito
   ( declare (salience 10000))

   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?imposiciones <- ( ajuste-de-iva-contra-credito ( mes ?mes ) (ano ?ano) (partida ?numero) (pagado false) (monto ?monto))
  =>

   ( bind ?dia 31)
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por ajuste del Debito Fiscal Contra el Credito Fiscal, mes de " ?mes))
(actividad ajustar-iva-contra-credito)))
   ( assert (abono (tipo-de-documento ajuste-iva-credito) (cuenta iva-credito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-iva ?monto))))
   ( assert (cargo (tipo-de-documento ajuste-iva-credito) (cuenta iva-debito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-iva ?monto))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ajustar-iva-contra-credito) (monto-total ?monto)))

   ( printout t "-->ami Ajuste Mensual de IVA " ?mes tab ?monto crlf)
)   
   
~                                                                                                       
~               
