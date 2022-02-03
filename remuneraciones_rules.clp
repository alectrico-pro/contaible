(defmodule REMUNERACIONES
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
   (printout t "-------------------- REMUNERACIONES ------------------" crlf)   
)

(defrule fin-de-modulo-mensual
   (declare (salience -10000))
   (empresa (nombre ?empresa ))
;   (balance (ano ?ano))
  =>
   (set-strategy breadth)
   (printout t "---------fin-------- REMUNERACIONES ------------------" crlf)
;   (halt)

)




(defrule csv-del-libro-de-remuneraciones-electronicos
 =>
  (printout t "Elaborar exportar csv para llenar mensualmente el libro de remuneraciones electronicos" crlf)
)

(defrule csv-previred
  =>
   (printout t "Elaborar exportador csv para declarar y pagar mensualmente las imposiciones en previred" crlf)
)

(defrule actulizar-ccm-y-contabilidad
  => 
   (printout t "Elaborar csv para declarar las remuneraciones en el ccm" crlf)
)

(defrule generar-asientos-para-llevar-libro-de-remuneraciones
  =>
  (printout t "Elaborar asientos contables en alectrico" crlf)
)

(defrule plantilla
   ( declare (salience 1))
   ( trabajador ( mes-inicio ?mes ) (ano-inicio ?ano) (nombre ?nombre) (afp ?afp) (salud ?salud) )
   ( afp   (nombre ?afp))
   ( salud (nombre ?salud))
   ( remuneracion ( trabajador ?nombre) ( mes julio) ( monto ?sueldo) )
   ( contrato (funcion ?funcion)  (trabajador ?nombre) (dedicacion ?dedicacion) (jornada ?jornada) (diaria ?diaria) (duracion ?duracion) (tipo-de-duracion ?tipo-de-duracion))
  =>
   ( printout t
     trabajador: ?nombre crlf
     afp: tab ?afp  crlf
     salud: tab ?salud crlf
   )
   ( printout t crlf "********** Contrato ******"  crlf
    funcion tab ?funcion crlf
    jornada tab ?jornada crlf tab ?dedicacion crlf tab ?duracion crlf tab ?tipo-de-duracion crlf
    diaria: ?diaria crlf
                "**************************" crlf
   )
)

(defrule calculo-de-descuentos-legales
   ( salario (nombre ?nombre))

   ( remuneracion
     ( trabajador ?nombre)
     ( mes ?mes)
     ( monto ?imponible)
     ( dias-trabajados ?dias-trabajados)
     ( semana-corrida ?semana-corrida)
     ( declarada ?declarada )
     ( pagada ?pagada)
     ( impuesta ?impuesta)
   )

   ( trabajador
     ( diaria ?diaria)
     ( mes-inicio ?mes-inicio)
     ( ano-inicio ?ano-inicio)
     ( mes-fin ?mes-fin)
     ( ano-fin ?ano-fin)
     ( nombre ?nombre)
     ( afp ?afp)
     ( salud fonasa)
     ( duracion ?duracion)
   )
   ( afp
      (nombre ?afp )
      (comision ?comision)
      (sis ?sis)
   )
   ( salud
      (nombre ?salud)
      (cotizacion ?cotizacion)
   )
   ( afc
     (duracion ?duracion)
     (comision ?afc)
   )
   
  =>
   ( bind ?sueldo (* ?diaria (+ ?dias-trabajados ?semana-corrida)))
   ( printout t crlf)
   ( printout t "==========" ?mes "=================" crlf)
   ( printout t " Contrato " ?duracion  crlf)
   ( printout t "---- " ?mes tab ?nombre " -----" crlf )
   ( printout t d.trabajados: tab ?dias-trabajados crlf)
   ( printout t sem.-corrida: tab ?semana-corrida crlf)
   ( printout t remuneracion: tab ?sueldo crlf)
   ( printout t previsio-afp: tab (round (* ?sueldo 0.10)) crlf)
   ( printout t comision-afp: tab (round (* ?sueldo ?comision)) crlf)
   ( printout t .....oblig.":" tab (round (* ?sueldo (+ 0.10 ?comision))) crlf)
   ( printout t comision-afc: tab (round (* ?sueldo ?afc)) crlf)
   ( printout t cotizac.sis.: tab (round (* ?sueldo ?sis)) crlf)
   ( printout t cotiza.salud: tab (round (* ?sueldo ?cotizacion)) crlf)
   ( printout t "-------------------------" crlf)
   ( printout t AFP:   tab (round (* ?sueldo (+ 0.10 ?comision ?sis ?afc))) crlf)F
   ( printout t SALUD: tab (round (* ?sueldo ?cotizacion)) crlf)
   ( printout t TOTAL: tab (round (* ?sueldo (+ 0.10 ?comision ?sis ?cotizacion ?afc))) crlf)
   ( printout t LIQUI: tab (round (- ?sueldo (* ?sueldo (+ 0.10 ?comision ?sis ?cotizacion ?afc)))) crlf)

   ( printout t "===================================" crlf)
   ( printout t "EN FORMATO DE PLANILLAS PREVIRED: " crlf)
   ( printout t " PLANILLA AFP " crlf)
   ( printout t " Cotización. Obligatoria................. " tab (round (* ?sueldo (+ 0.10 ?comision))) crlf)
   ( printout t " Seguro Invalidez y Sobrevivencia (SIS)   " tab (round (* ?sueldo ?sis)) crlf)
   ( printout t " SubTotal a Pagar Fondo de Pensiones (AFP) " tab (round (* ?sueldo (+ 0.10 ?comision ?sis ))) crlf)
   ( printout t " Comisión AFP " tab (* ?comision 100) "%" tab (* ?sueldo ?comision) crlf)
   ( printout t " ---- " crlf)
   ( printout t " Resumen Cotizaciones Fondo de Cesantía (AFC)" crlf)
   ( printout t "  Cotizacion afiliado " crlf)
   ( printout t "  Cotizacion Empleador " crlf)
   ( printout t "Total a Pagar al Fondo de Cesantía" tab (* ?afc 100) "%" tab (* ?sueldo ?afc) crlf)
   ( printout t " PLANILLA SALUD    " crlf)
   ( printout t " Cotización Legal              "  tab ?salud crlf)

   ( printout t "===================================" crlf)
   ( printout t (if (eq ?declarada true ) then DECLARADA else NO-DECLARADA ) tab )
   ( printout t (if (eq ?pagada true ) then PAGADA else NO-PAGADA ) tab )
   ( printout t (if (eq ?impuesta true ) then IMPUESTA else NO-IMPUESTA ) crlf)


   ( printout t crlf)
)



