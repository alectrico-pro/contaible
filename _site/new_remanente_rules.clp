(defmodule REMANENTE
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



(defrule inicio-de-modulo-mensual
   (declare (salience 10000))
   (empresa (nombre ?empresa ))
;   (balance (ano ?ano))
  =>
   (set-strategy breadth)
   (printout t "--------------------AJUSTES DE REMANENTES ------------------" crlf)   
)

(defrule codigos-f29-remanente-de-iva
  ( declare (salience 10000))

  ( actual  ( mes ?mes))
  ( tasas (utm ?utm)
          (mes ?mes-anterior)
          (ano ?ano-anterior))
  ( tasas (utm ?utm-pago)
          (mes ?mes-de-pago)
          (ano ?ano-de-pago))
  ?f <- ( f29 (partida ?numero)
              (mes ?mes)
              (ano ?ano)
  )
  ?imposiciones <- ( ajuste-de-remanente-de-iva
              (partida ?partida)
              (mes-anterior ?mes-anterior)
              (ano-anterior ?ano-anterior)
              ( mes ?mes )
              (ano ?ano)
              (mes-de-pago ?mes-de-pago)
              (ano-de-pago ?ano-de-pago)
              (mostrar-en ?mostrar-en)
              (antes ?antes)
  )
  ( ticket ( numero ?numero ))
  ( empresa (nombre ?empresa))
 =>

   ( bind ?antes-en-utm (round (/ (round (/ (* ?antes 100) ?utm)) 100)))
   ( printout t antes-en-utm ?antes-en-utm 100 crlf)
   ( bind ?calculado (round (* ?antes-en-utm ?utm-pago) ))
     


; ( bind ?calculado (round (/ (* ?antes ?utm-pago) ?utm) ))
 ;( bind ?en-utm-anterior (round (/ (?antes ?utm) ) ))

; ( bind ?calculado (* ?en-utm-anterior ?utm-pago))

  ( assert (partida
            ( empresa ?empresa)
            ( numero ?numero)
            ( dia 31)
            ( mes ?mes)
            ( ano ?ano)
            ( descripcion (str-cat "Formulario F29 " ?mes ))
            ( actividad codigos-f29)))

; ( assert ( formulario-f29
;           ( partida ?numero)
 ;          ( codigo 077)
 ;          ( descripcion (str-cat "REMANENTE DE CREDITO FISC. partida " ?partida))
;           ( valor ?antes)
;           ( mes ?mes-anterior)
;           ( ano ?ano-anterior)
;  ))

  ( assert ( acumulador-mensual
            (cuenta 077)
            (mes ?mes-anterior)
            (ano ?ano-anterior)
            (debe 0)
            (haber 0)
  ))
  ( assert ( sumar
            (qty 1)
            (debe ?calculado)
            (haber 0)
            (cuenta 077)
            (mes ?mes-anterior)
            (ano ?ano-anterior)
  ))

  ( assert ( acumulador-mensual
            (cuenta 504)
            (mes ?mes)
            (ano ?ano)
            (debe 0)
            (haber 0)
  ))
  ( assert ( sumar
            (qty 1)
            (debe ?calculado)
            (haber 0)
            (cuenta 504)
            (mes ?mes)
            (ano ?ano)
  ))
  (halt)
)


(defrule ajuste-de-remanente-de-iva-nuevo
 (declare (salience 10000))

 ?orden <- ( ajuste-de-remanente-de-iva-nuevo
   (mes-de-declaracion  ?mes-de-declaracion)
   (mes-de-presentacion ?mes-de-presentacion)
   (ano-de-declaracion  ?ano-de-declaracion)
   (ano-de-presentacion ?ano-de-presentacion) )

  ( tasas (utm ?utm-de-declaracion)
     (mes ?mes-de-declaracion)
     (ano ?ano-de-declaracion)  )
  
  ( tasas (utm ?utm-de-presentacion)
     (mes ?mes-de-presentacion)
     (ano ?ano-de-presentacion ))
 =>
  (printout t "Ajustando remanente por el método nuevo " ------------- crlf)
  (printout t "Período de Declaración"  tab ?utm-de-declaracion  tab ?ano-de-declaracion tab ?mes-de-declaracion  crlf)
  (printout t "Período de Presentación" tab ?utm-de-presentacion tab ?ano-de-presentacion tab ?mes-de-presentacion crlf )
  
  (halt )
)
 


(defrule ajustar-remanente-de-iva ;de un mes a otro puede cambiar si se ajusta por la utm
                                  ;se anota como ingreso si es a favor o como gasto si es en contra
   ( declare (salience 10000))

   ( tasas (utm ?utm)
     (mes ?mes-anterior)
     (ano ?ano-anterior))

   ( tasas (utm ?utm-pago)
     (mes ?mes-de-pago)
     (ano ?ano-de-pago))

   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))

   ?imposiciones <- ( ajuste-de-remanente-de-iva
    ( mes-anterior ?mes-anterior)
    ( ano-anterior ?ano-anterior)
    ( mes-que-se-declara-en-el-f29 ?mes-que-se-declara)
    ( mes-en-que-se-presenta-el-f29 ?mes-en-que-se-presenta)
    ( mes ?mes )
    ( ano ?ano)
    ( mes-de-pago ?mes-de-pago)
    ( ano-de-pago ?ano-de-pago)
    ( mostrar-en ?mostrar-en)
    ( antes ?antes)
    ( partida ?numero)
    ( pagado false)) ;si pagado es falce no se ajusta el remanente en registros, pero si se muestra en el f29
;   ?c <- ( cuenta (empresa ?empresa) (nombre iva-credito) (mes ?mes ) (ano ?ano) (debe ?debe) )
  =>
   ( printout t "------- " ?mes crlf)
   ( printout t "Remanente Generado en" tab ?mes-anterior  crlf)

   ( printout t "Mes que se declara en el f29" tab ?mes-que-se-declara crlf)
   ( printout t "Mes en que se presenta f29" tab ?mes-en-que-se-presenta crlf)
   ( printout t "Mes en que se presenta el f29" tab ?mostrar-en crlf)
   ( printout t "Mes para el que se ajusta el remanente " ?mes-de-pago crlf)
   ( printout t "utm del periodo de declaracion ( " ?mes " de " ?ano " )" tab ?utm crlf)
   ( printout t "utm del periodo de presentacion ( " ?mes-de-pago " de " ?ano-de-pago " )" tab ?utm-pago crlf)
   ( printout t "Monto de Remanente Generado en " ?mes-anterior " de " ?ano-anterior tab ?antes crlf)
   ( bind ?antes-en-utm (round ( / (round (/ (* ?antes 100) ?utm)) 100)))
   ( printout t "                 ....................... en utm " tab tab ?antes-en-utm crlf)
   ( bind ?calculado (round (* ?antes-en-utm ?utm-pago) ))
;   ( printout t "                 ....................... calculado-es" tab tab ?calculado crlf)
   ( printout t "               ................ajustado para " ?mes-de-pago " de " ?ano-de-pago tab ?calculado crlf)
   ( printout t "               ........... presentado en 504 de " ?mes " de " ?ano tab ?calculado crlf)
  
 
;  ( bind ?ajuste (- ?ahora ?antes))
   ( if (> ?calculado ?antes) then 
      ( bind ?ajuste (round (- ?calculado ?antes)))
      ( bind ?dia 31)
      ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por ajuste del remanente de IVA. El valor actualizado de 504 f29 es de: " ?calculado  " para " ?mostrar-en))  (actividad ajuste-a-ingreso-remanente-de-iva)))
      ( assert (cargo (tipo-de-documento remanente-iva) (cuenta iva-credito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ajuste) (glosa (str-cat por-remanente-de-iva- ?mes-de-pago ?ajuste)))) 
      ( assert (abono (tipo-de-documento remanente-iva) (cuenta ganancia-por-correccion-monetaria) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ajuste) (glosa (str-cat por-remanente-de-iva- ?mes-de-pago ?ajuste)))) 
     ( printout t "-->ari Ajustar a Ingresos Remanente de IVA " ?mes tab ?ajuste crlf) 
    ) 
   ( if (< ?calculado ?antes) then
      ( bind ?ajuste (round (- ?antes ?calculado)))
      ( bind ?dia 31)
      ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por ajuste del remanente de IVA. El valor actualizado de 504 f29 es de: "  ?calculado  " para " ?mostrar-en))  (actividad ajuste-a-gastos-de-remanente-de-iva)))
      ( assert (abono (tipo-de-documento remanente-iva) (cuenta iva-credito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ajuste) (glosa (str-cat por-remanente-de-iva- ?mes-de-pago ?ajuste))))
      ( assert (cargo (tipo-de-documento remanente-iva) (cuenta perdida-por-correccion-monetaria) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ajuste) (glosa (str-cat por-remanente-de-iva- ?mes-de-pago ?ajuste)))) 
     ( printout t "-->ari Ajustar a Gastos Remanente de IVA " ?mes tab ?ajuste crlf)
    )

   ( if (= ?calculado ?antes) then
      ( bind ?ajuste 0)
      ( bind ?dia 31)
      ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por ajuste del remanente de IVA. El valor actualizado de 504 f29 es de: " ?antes  " para " ?mes-de-pago))  (actividad ajuste-a-ingreso-remanente-de-iva)))
      ( printout t "-->ari No es necesario Ajustar Remanente de IVA " ?mes tab ?ajuste crlf)
    )
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ajuste-remanente-iva) (monto-total ?ajuste)))
   ( printout t "-------------------------------------------------------" crlf)
)


(defrule ajustar-iva-contra-debito
   ( declare (salience 10000))
   ( actual  ( mes ?mes_top))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?imposiciones <- ( ajuste-de-iva-contra-debito ( mes ?mes_top) (ano ?ano) (partida ?numero) (pagado false) (monto ?monto))
;   ?c <- ( cuenta (empresa ?empresa) (nombre iva-credito) (mes ?mes ) (ano ?ano) (debe ?debe))
  =>

   ( bind ?dia 31)
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes_top) (ano ?ano) (descripcion (str-cat "Por ajuste del Credito Fiscal Contra el Debito Fiscal, mes de " ?mes_top))
(actividad ajustar-iva-contra-debito)))
   ( assert (abono (tipo-de-documento traspaso) (cuenta iva-credito) (partida ?numero) (dia ?dia) (mes ?mes_top) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-iva ?monto))))
   ( assert (cargo (tipo-de-documento traspaso) (cuenta iva-debito) (partida ?numero) (dia ?dia) (mes ?mes_top) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-iva ?monto))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ajustar-iva-contra-debito) (monto-total ?monto)))

   ( printout t "-->ami Ajuste Mensual de IVA " ?mes_top tab ?monto crlf)
)


(defrule ajustar-iva-contra-credito
   ( declare (salience 10000))

   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?imposiciones <- ( ajuste-de-iva-contra-credito ( mes ?mes ) (ano ?ano) (partida ?numero) (pagado false) (monto ?monto))
;   ?c <- ( cuenta (empresa ?empresa) (nombre iva-debito) (mes ?mes ) (ano ?ano) (haber ?haber) )
  =>

   ( bind ?dia 31)
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por ajuste del Debito Fiscal Contra el Credito Fiscal, mes de " ?mes))
(actividad ajustar-iva-contra-credito)))
   ( assert (abono (tipo-de-documento ajuste-iva) (cuenta iva-credito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-iva ?monto))))
   ( assert (cargo (tipo-de-documento ajuste-iva) (cuenta iva-debito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-iva ?monto))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ajustar-iva-contra-credito) (monto-total ?monto)))

   ( printout t "-->ami Ajuste Mensual de IVA " ?mes tab ?monto crlf)
)

